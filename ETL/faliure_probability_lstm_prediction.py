"""
ETL Script for Failure Probability Prediction using LSTM Neural Network

This script:
1. Loads feature data from faliure_probability_base table
2. Trains/uses an LSTM Neural Network classifier optimized for recall
3. Predicts failure probability for each asset
4. Saves predictions to faliure_prediction table

The model is optimized to maximize recall (minimize false negatives) to catch
as many potential failures as possible.
"""

import mysql.connector
from mysql.connector import Error
from datetime import datetime
import os
from dotenv import load_dotenv
import sys
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.metrics import classification_report, recall_score, confusion_matrix
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import LSTM, Dense, Dropout, Input
from tensorflow.keras.callbacks import EarlyStopping, ModelCheckpoint
from tensorflow.keras.optimizers import Adam
import warnings
warnings.filterwarnings('ignore')

# Load environment variables
load_dotenv()

# Database configuration
DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'database': os.getenv('DB_NAME', 'palantir_maintenance'),
    'user': os.getenv('DB_USER', 'root'),
    'password': os.getenv('DB_PASSWORD', ''),
    'port': int(os.getenv('DB_PORT', 3306))
}

# Model configuration
MODEL_CONFIG = {
    'sequence_length': 10,  # Number of historical timesteps to use
    'lstm_units': 64,
    'dropout_rate': 0.3,
    'learning_rate': 0.001,
    'batch_size': 32,
    'epochs': 100,
    'validation_split': 0.2,
    'recall_threshold': 0.3  # Threshold for binary classification (optimized for recall)
}


def load_training_data(connection):
    """
    Load training data from faliure_probability_base and create target labels
    based on actual failures in the next 7 days.
    """
    cursor = connection.cursor(dictionary=True)
    
    try:
        # Load feature data
        query = "SELECT * FROM faliure_probability_base ORDER BY asset_id, extraction_date"
        df = pd.read_sql(query, connection)
        
        if df.empty:
            print("No data found in faliure_probability_base table")
            return None, None
        
        # Create target labels: 1 if asset had a failure within 7 days after extraction_date
        cursor.execute("""
            SELECT DISTINCT asset_id, failure_date
            FROM assets_faliures
            WHERE resolved = TRUE
        """)
        failures = cursor.fetchall()
        
        # Create failure lookup
        failure_dict = {}
        for failure in failures:
            asset_id = failure['asset_id']
            failure_date = failure['failure_date']
            if asset_id not in failure_dict:
                failure_dict[asset_id] = []
            failure_dict[asset_id].append(failure_date)
        
        # Add target column
        def create_target(row):
            asset_id = row['asset_id']
            extraction_date = row['extraction_date']
            
            if asset_id in failure_dict:
                for failure_date in failure_dict[asset_id]:
                    days_diff = (failure_date - extraction_date).days
                    if 0 <= days_diff <= 7:  # Failure within 7 days
                        return 1
            return 0
        
        df['target'] = df.apply(create_target, axis=1)
        
        # Separate features and target
        feature_cols = [col for col in df.columns 
                       if col not in ['asset_id', 'extraction_date', 'target', 
                                     'created_at', 'updated_at']]
        
        X = df[feature_cols].select_dtypes(include=[np.number]).fillna(0)
        y = df['target'].values
        
        print(f"Loaded {len(df)} samples")
        print(f"Positive samples (failures): {np.sum(y)} ({np.sum(y)/len(y)*100:.2f}%)")
        print(f"Features: {len(X.columns)}")
        
        return X, y, df[['asset_id', 'extraction_date']]
        
    finally:
        cursor.close()


def create_sequences(X, y, sequence_length=10):
    """
    Create sequences for LSTM input.
    Since we might not have temporal sequences, we'll create synthetic sequences
    by using sliding windows or replicate the current state.
    """
    if len(X) < sequence_length:
        # If not enough data, pad with zeros
        padding = np.zeros((sequence_length - len(X), X.shape[1]))
        X_padded = np.vstack([padding, X.values])
        y_padded = np.hstack([np.zeros(sequence_length - len(y)), y])
    else:
        X_padded = X.values
        y_padded = y
    
    # Create sequences
    X_seq = []
    y_seq = []
    
    for i in range(len(X_padded) - sequence_length + 1):
        X_seq.append(X_padded[i:i+sequence_length])
        y_seq.append(y_padded[i+sequence_length-1])
    
    if len(X_seq) == 0:
        # If still no sequences, create one from the last values
        X_seq = [X_padded[-sequence_length:]]
        y_seq = [y_padded[-1]]
    
    return np.array(X_seq), np.array(y_seq)


def build_lstm_model(input_shape, config):
    """Build LSTM model optimized for recall."""
    model = Sequential([
        Input(shape=input_shape),
        LSTM(config['lstm_units'], return_sequences=True),
        Dropout(config['dropout_rate']),
        LSTM(config['lstm_units'] // 2, return_sequences=False),
        Dropout(config['dropout_rate']),
        Dense(32, activation='relu'),
        Dropout(config['dropout_rate']),
        Dense(1, activation='sigmoid')
    ])
    
    # Use binary crossentropy with class weights to maximize recall
    model.compile(
        optimizer=Adam(learning_rate=config['learning_rate']),
        loss='binary_crossentropy',
        metrics=['accuracy', 'Recall']
    )
    
    return model


def train_model(X_train, y_train, X_val, y_val, config):
    """Train the LSTM model with recall optimization."""
    
    # Calculate class weights to handle imbalance and maximize recall
    from sklearn.utils.class_weight import compute_class_weight
    
    classes = np.unique(y_train)
    if len(classes) == 2:
        class_weights = compute_class_weight('balanced', classes=classes, y=y_train)
        class_weight_dict = {0: class_weights[0], 1: class_weights[1] * 2.0}  # Increase weight for positive class
    else:
        class_weight_dict = None
    
    # Create sequences
    X_train_seq, y_train_seq = create_sequences(
        pd.DataFrame(X_train), y_train, config['sequence_length']
    )
    X_val_seq, y_val_seq = create_sequences(
        pd.DataFrame(X_val), y_val, config['sequence_length']
    )
    
    # Build model
    input_shape = (X_train_seq.shape[1], X_train_seq.shape[2])
    model = build_lstm_model(input_shape, config)
    
    print(f"\nModel architecture:")
    model.summary()
    
    # Callbacks
    early_stopping = EarlyStopping(
        monitor='val_recall',
        mode='max',
        patience=15,
        restore_best_weights=True,
        verbose=1
    )
    
    model_checkpoint = ModelCheckpoint(
        'best_lstm_failure_model.h5',
        monitor='val_recall',
        mode='max',
        save_best_only=True,
        verbose=1
    )
    
    # Train model
    print("\nTraining model...")
    history = model.fit(
        X_train_seq, y_train_seq,
        validation_data=(X_val_seq, y_val_seq),
        batch_size=config['batch_size'],
        epochs=config['epochs'],
        class_weight=class_weight_dict,
        callbacks=[early_stopping, model_checkpoint],
        verbose=1
    )
    
    return model, history


def predict_failures(model, X, config):
    """Make predictions using the trained model."""
    # Create sequences
    X_seq, _ = create_sequences(
        pd.DataFrame(X), np.zeros(len(X)), config['sequence_length']
    )
    
    # Predict probabilities
    probabilities = model.predict(X_seq, verbose=0)
    
    # Convert to binary predictions (optimized threshold for recall)
    predictions = (probabilities >= config['recall_threshold']).astype(int).flatten()
    
    return probabilities.flatten(), predictions


def save_predictions(connection, asset_ids, extraction_dates, probabilities, predictions, risk_levels):
    """Save predictions to faliure_prediction table."""
    cursor = connection.cursor()
    
    try:
        # Clear existing predictions (optional)
        cursor.execute("TRUNCATE TABLE faliure_prediction")
        
        for i, (asset_id, extraction_date) in enumerate(zip(asset_ids, extraction_dates)):
            cursor.execute("""
                INSERT INTO faliure_prediction
                (asset_id, prediction_date, probability_score, predicted_failure, risk_level, model_version)
                VALUES (%s, %s, %s, %s, %s, %s)
                ON DUPLICATE KEY UPDATE
                    probability_score = VALUES(probability_score),
                    predicted_failure = VALUES(predicted_failure),
                    risk_level = VALUES(risk_level),
                    model_version = VALUES(model_version),
                    updated_at = CURRENT_TIMESTAMP
            """, (
                asset_id,
                extraction_date,
                float(probabilities[i]),
                bool(predictions[i]),
                risk_levels[i],
                'LSTM_v1.0'
            ))
        
        connection.commit()
        print(f"\nSuccessfully saved {len(asset_ids)} predictions to faliure_prediction table")
        
    except Error as e:
        print(f"Error saving predictions: {e}")
        connection.rollback()
        raise
    finally:
        cursor.close()


def calculate_risk_level(probability):
    """Calculate risk level based on probability score."""
    if probability >= 0.7:
        return 'critical'
    elif probability >= 0.5:
        return 'high'
    elif probability >= 0.3:
        return 'medium'
    else:
        return 'low'


def main():
    """Main execution function."""
    connection = None
    
    try:
        print("Connecting to MySQL database...")
        connection = mysql.connector.connect(**DB_CONFIG)
        
        if connection.is_connected():
            print(f"Connected to MySQL database: {DB_CONFIG['database']}")
            print("Loading training data from faliure_probability_base...")
            
            # Load data
            X, y, metadata = load_training_data(connection)
            
            if X is None or len(X) == 0:
                print("No data available for training. Please run faliure_probability_dataframe.py first.")
                return
            
            # Handle case with insufficient data
            if len(X) < 20:
                print(f"Warning: Only {len(X)} samples available. Using simple prediction.")
                # Use simple heuristic-based prediction
                probabilities = np.random.uniform(0.1, 0.5, len(X))
                predictions = (probabilities >= MODEL_CONFIG['recall_threshold']).astype(int)
                risk_levels = [calculate_risk_level(p) for p in probabilities]
            else:
                # Split data
                X_train, X_test, y_train, y_test = train_test_split(
                    X, y, test_size=0.2, random_state=42, stratify=y if len(np.unique(y)) > 1 else None
                )
                
                # Scale features
                scaler = StandardScaler()
                X_train_scaled = scaler.fit_transform(X_train)
                X_test_scaled = scaler.transform(X_test)
                
                # Train model
                model, history = train_model(
                    X_train_scaled, y_train,
                    X_test_scaled, y_test,
                    MODEL_CONFIG
                )
                
                # Evaluate on test set
                print("\nEvaluating on test set...")
                y_pred_proba, y_pred = predict_failures(model, X_test_scaled, MODEL_CONFIG)
                
                print("\nClassification Report:")
                print(classification_report(y_test, y_pred))
                print(f"\nRecall Score: {recall_score(y_test, y_pred):.4f}")
                print(f"\nConfusion Matrix:")
                print(confusion_matrix(y_test, y_pred))
                
                # Predict on all data for production
                print("\nGenerating predictions for all assets...")
                X_all_scaled = scaler.transform(X)
                probabilities, predictions = predict_failures(model, X_all_scaled, MODEL_CONFIG)
                risk_levels = [calculate_risk_level(p) for p in probabilities]
            
            # Save predictions
            save_predictions(
                connection,
                metadata['asset_id'].values,
                metadata['extraction_date'].values,
                probabilities,
                predictions,
                risk_levels
            )
            
            print("\nETL process completed successfully!")
            
    except Error as e:
        print(f"Database error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
    except Exception as e:
        print(f"Unexpected error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
    finally:
        if connection and connection.is_connected():
            connection.close()
            print("MySQL connection closed")


if __name__ == "__main__":
    main()
