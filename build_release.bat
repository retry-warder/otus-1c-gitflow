@echo off
:: ---------------------------------------------------------------
:: Build release cf from master branch using vrunner compile.
:: Usage: build_release.bat 1.1.0
:: ---------------------------------------------------------------
if "%~1"=="" ( echo Usage: build_release.bat X.Y.Z & exit /b 1 )
set VERSION=%~1
set REPO=D:/DATA/BASE 1C/OTUS_DEMO_REP/
set BUILD_BASE=D:/DATA/BASE 1C/OTUS_DEMO_BUILD

cd /d "%REPO%" || exit /b 1

echo [1/4] Update master
git checkout master || exit /b 1
git pull origin master || exit /b 1

echo [2/4] Service build base
if not exist "%BUILD_BASE%/1Cv8.1CD" call vrunner init-dev --ibconnection /F"%BUILD_BASE%"

echo [3/4] Compile cf from src
if not exist build mkdir build
call vrunner compile --src ./src --out ./build/release-%VERSION%.cf --ibconnection /F"%BUILD_BASE%"
if errorlevel 1 exit /b 1

echo [4/4] Release tag
git tag -a v%VERSION% -m "Release %VERSION%"
git push origin v%VERSION%

echo Done: build/release-%VERSION%.cf -- attach it to GitHub Release v%VERSION%.