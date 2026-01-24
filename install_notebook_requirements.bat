@echo off
REM Script para instalar las dependencias de los notebooks
REM Usa python -m pip para evitar problemas con el launcher de pip

echo ========================================
echo Instalando dependencias de notebooks...
echo ========================================
echo.

cd /d "%~dp0"

REM Activar el entorno virtual y usar python -m pip
call palantir_venv\Scripts\activate.bat

echo Actualizando pip...
python -m pip install --upgrade pip

echo.
echo Instalando librerias de ciencia de datos...
python -m pip install pandas numpy matplotlib seaborn scikit-learn lightgbm joblib sqlalchemy

echo.
echo Instalando librerias de Jupyter...
python -m pip install ipython jupyter notebook

echo.
echo Instalando librerias de MySQL...
python -m pip install PyMySQL mysql-connector-python

echo.
echo ========================================
echo Instalacion completada!
echo ========================================
pause
