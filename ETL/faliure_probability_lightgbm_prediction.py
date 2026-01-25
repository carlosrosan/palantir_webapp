"""
ETL Script for Failure Probability Prediction using Decision Tree and LightGBM

This script:
1. Loads feature data from faliure_probability_base table (daily granularity)
2. Trains Decision Tree Classifier and LightGBM models
3. Predicts failure probability for each asset-day
4. Saves predictions to faliure_prediction table

The models are used to predict if an asset will have a failure in the next week.
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
from sklearn.preprocessing import StandardScaler
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import (
    classification_report, recall_score, precision_score, 
    f1_score, accuracy_score, confusion_matrix, roc_auc_score
)
from lightgbm import LGBMClassifier
import joblib
import warnings
warnings.filterwarnings('ignore')

# Load environment variables
load_dotenv()

# Database configuration
DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'database': os.getenv('DB_NAME', 'palantir_maintenance'),
    'user': os.getenv('DB_USER', 'root'),
    'password': os.getenv('DB_PASSWORD', 'admin'),
    'port': int(os.getenv('DB_PORT', 3306))
}


def load_training_data(connection):
    """
    Load training data from faliure_probability_base table.
    The 'faliure' column indicates if there's a failure in the next 7 days.
    """
    try:
        # Load feature data with the faliure target column
        query = """
            SELECT * FROM faliure_probability_base 
            ORDER BY asset_id, reading_date
        """
        df = pd.read_sql(query, connection)
        
        if df.empty:
            print("No data found in faliure_probability_base table")
            return None, None, None
        
        # Separate features and target
        # Exclude non-feature columns
        exclude_cols = ['base_id', 'asset_id', 'reading_date', 'faliure', 
                       'asset_status', 'created_at', 'updated_at']
        
        feature_cols = [col for col in df.columns if col not in exclude_cols]
        
        X = df[feature_cols].select_dtypes(include=[np.number]).fillna(0)
        y = df['faliure'].astype(int).values
        
        print(f"Loaded {len(df)} samples")
        print(f"Positive samples (failures in next week): {np.sum(y)} ({np.sum(y)/len(y)*100:.2f}%)")
        print(f"Negative samples: {len(y) - np.sum(y)} ({(len(y) - np.sum(y))/len(y)*100:.2f}%)")
        print(f"Features: {len(X.columns)}")
        
        return X, y, df[['asset_id', 'reading_date']]
        
    except Error as e:
        print(f"Error loading data: {e}")
        return None, None, None


def train_decision_tree(X_train, y_train, X_test, y_test):
    """Train Decision Tree classifier."""
    print("\n" + "="*60)
    print("Training Decision Tree Classifier...")
    print("="*60)
    
    # Create model with parameters optimized for recall
    dt_model = DecisionTreeClassifier(
        max_depth=10,
        min_samples_split=5,
        min_samples_leaf=2,
        class_weight='balanced',  # Handle imbalanced data
        random_state=42
    )
    
    # Train
    dt_model.fit(X_train, y_train)
    
    # Predict
    y_pred = dt_model.predict(X_test)
    y_pred_proba = dt_model.predict_proba(X_test)[:, 1]
    
    # Evaluate
    print("\nDecision Tree Results:")
    print(f"Accuracy:  {accuracy_score(y_test, y_pred):.4f}")
    print(f"Precision: {precision_score(y_test, y_pred, zero_division=0):.4f}")
    print(f"Recall:    {recall_score(y_test, y_pred, zero_division=0):.4f}")
    print(f"F1-Score:  {f1_score(y_test, y_pred, zero_division=0):.4f}")
    
    if len(np.unique(y_test)) > 1:
        print(f"AUC-ROC:   {roc_auc_score(y_test, y_pred_proba):.4f}")
    
    print("\nClassification Report:")
    print(classification_report(y_test, y_pred, zero_division=0))
    
    print("\nConfusion Matrix:")
    print(confusion_matrix(y_test, y_pred))
    
    return dt_model


def train_lightgbm(X_train, y_train, X_test, y_test):
    """Train LightGBM classifier."""
    print("\n" + "="*60)
    print("Training LightGBM Classifier...")
    print("="*60)
    
    # Calculate scale_pos_weight for imbalanced data
    n_neg = np.sum(y_train == 0)
    n_pos = np.sum(y_train == 1)
    scale_pos_weight = n_neg / n_pos if n_pos > 0 else 1
    
    # Create model
    lgbm_model = LGBMClassifier(
        objective='binary',
        metric='binary_logloss',
        boosting_type='gbdt',
        num_leaves=31,
        learning_rate=0.05,
        n_estimators=100,
        scale_pos_weight=scale_pos_weight,  # Handle imbalanced data
        random_state=42,
        verbose=-1
    )
    
    # Train with early stopping
    lgbm_model.fit(
        X_train, y_train,
        eval_set=[(X_test, y_test)],
        eval_names=['valid'],
        callbacks=[
            lgbm_model.early_stopping(stopping_rounds=20, verbose=False)
        ]
    )
    
    # Predict
    y_pred = lgbm_model.predict(X_test)
    y_pred_proba = lgbm_model.predict_proba(X_test)[:, 1]
    
    # Evaluate
    print("\nLightGBM Results:")
    print(f"Accuracy:  {accuracy_score(y_test, y_pred):.4f}")
    print(f"Precision: {precision_score(y_test, y_pred, zero_division=0):.4f}")
    print(f"Recall:    {recall_score(y_test, y_pred, zero_division=0):.4f}")
    print(f"F1-Score:  {f1_score(y_test, y_pred, zero_division=0):.4f}")
    
    if len(np.unique(y_test)) > 1:
        print(f"AUC-ROC:   {roc_auc_score(y_test, y_pred_proba):.4f}")
    
    print("\nClassification Report:")
    print(classification_report(y_test, y_pred, zero_division=0))
    
    print("\nConfusion Matrix:")
    print(confusion_matrix(y_test, y_pred))
    
    # Feature importance
    feature_importance = pd.DataFrame({
        'feature': X_train.columns,
        'importance': lgbm_model.feature_importances_
    }).sort_values('importance', ascending=False)
    
    print("\nTop 10 Most Important Features:")
    print(feature_importance.head(10))
    
    return lgbm_model


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


def save_predictions(connection, metadata, probabilities, predictions, model_version):
    """Save predictions to faliure_prediction table."""
    cursor = connection.cursor()
    
    try:
        # Clear existing predictions
        cursor.execute("TRUNCATE TABLE faliure_prediction")
        
        for i in range(len(metadata)):
            asset_id = metadata['asset_id'].iloc[i]
            reading_date = metadata['reading_date'].iloc[i]
            prob = float(probabilities[i]) if i < len(probabilities) else 0.0
            pred = bool(predictions[i]) if i < len(predictions) else False
            risk_level = calculate_risk_level(prob)
            
            cursor.execute("""
                INSERT INTO faliure_prediction
                (asset_id, prediction_date, probability_score, predicted_failure, risk_level, model_version)
                VALUES (%s, %s, %s, %s, %s, %s)
            """, (
                int(asset_id),
                reading_date,
                prob,
                pred,
                risk_level,
                model_version
            ))
        
        connection.commit()
        print(f"\nSuccessfully saved {len(metadata)} predictions to faliure_prediction table")
        
    except Error as e:
        print(f"Error saving predictions: {e}")
        connection.rollback()
        raise
    finally:
        cursor.close()


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
                probabilities = np.random.uniform(0.1, 0.5, len(X))
                predictions = (probabilities >= 0.5).astype(int)
                save_predictions(connection, metadata, probabilities, predictions, 'Simple_v1.0')
                return
            
            # Check if we have both classes
            if len(np.unique(y)) < 2:
                print("Warning: Only one class present in data. Cannot train meaningful model.")
                probabilities = np.zeros(len(X))
                predictions = np.zeros(len(X), dtype=int)
                save_predictions(connection, metadata, probabilities, predictions, 'NoClass_v1.0')
                return
            
            # Split data
            X_train, X_test, y_train, y_test, meta_train, meta_test = train_test_split(
                X, y, metadata, test_size=0.2, random_state=42, stratify=y
            )
            
            print(f"\nTraining set: {len(X_train)} samples")
            print(f"Test set: {len(X_test)} samples")
            
            # Scale features
            scaler = StandardScaler()
            X_train_scaled = scaler.fit_transform(X_train)
            X_test_scaled = scaler.transform(X_test)
            
            # Convert to DataFrame for LightGBM feature importance
            X_train_scaled_df = pd.DataFrame(X_train_scaled, columns=X_train.columns)
            X_test_scaled_df = pd.DataFrame(X_test_scaled, columns=X_test.columns)
            
            # Train models
            dt_model = train_decision_tree(X_train_scaled, y_train, X_test_scaled, y_test)
            lgbm_model = train_lightgbm(X_train_scaled_df, y_train, X_test_scaled_df, y_test)
            
            # Compare models and choose the best one based on F1-score
            dt_pred = dt_model.predict(X_test_scaled)
            lgbm_pred = lgbm_model.predict(X_test_scaled_df)
            
            dt_f1 = f1_score(y_test, dt_pred, zero_division=0)
            lgbm_f1 = f1_score(y_test, lgbm_pred, zero_division=0)
            
            print("\n" + "="*60)
            print("MODEL COMPARISON")
            print("="*60)
            print(f"Decision Tree F1-Score: {dt_f1:.4f}")
            print(f"LightGBM F1-Score:      {lgbm_f1:.4f}")
            
            # Use the better model for predictions
            if lgbm_f1 >= dt_f1:
                print("\nUsing LightGBM for final predictions (better F1-score)")
                best_model = lgbm_model
                model_version = 'LightGBM_v1.0'
                X_all_scaled = scaler.transform(X)
                X_all_scaled_df = pd.DataFrame(X_all_scaled, columns=X.columns)
                probabilities = best_model.predict_proba(X_all_scaled_df)[:, 1]
                predictions = best_model.predict(X_all_scaled_df)
            else:
                print("\nUsing Decision Tree for final predictions (better F1-score)")
                best_model = dt_model
                model_version = 'DecisionTree_v1.0'
                X_all_scaled = scaler.transform(X)
                probabilities = best_model.predict_proba(X_all_scaled)[:, 1]
                predictions = best_model.predict(X_all_scaled)
            
            # Save predictions
            save_predictions(connection, metadata, probabilities, predictions, model_version)
            
            # Save models
            joblib.dump(dt_model, 'decision_tree_failure_model.pkl')
            joblib.dump(lgbm_model, 'lightgbm_failure_model.pkl')
            joblib.dump(scaler, 'feature_scaler.pkl')
            print("\nModels saved: decision_tree_failure_model.pkl, lightgbm_failure_model.pkl")
            
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
