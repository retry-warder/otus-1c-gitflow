@echo off
:: ---------------------------------------------------------------
:: Сборка релиза (cf) из ветки master: vrunner compile
:: Использование: build_release.bat 1.0.0
:: ---------------------------------------------------------------
if "%~1"=="" ( echo Укажите версию релиза, например: build_release.bat 1.0.0 & exit /b 1 )
set VERSION=%~1
set REPO=D:/DATA/BASE 1C/OTUS_DEMO_REP/
set BUILD_BASE=D:/DATA/BASE 1C/OTUS_DEMO_BUILD

cd /d "%REPO%" || exit /b 1

echo [1/4] Актуализация master
git checkout master || exit /b 1
git pull origin master || exit /b 1

echo [2/4] Служебная база для сборки
if not exist "%BUILD_BASE%\1Cv8.1CD" call vrunner init-dev --ibconnection /F"%BUILD_BASE%"

echo [3/4] Сборка cf из исходников src
if not exist build mkdir build
call vrunner compile --src ./src --out ./build/release-%VERSION%.cf --ibconnection /F"%BUILD_BASE%"
if errorlevel 1 exit /b 1

echo [4/4] Тег релиза
git tag -a v%VERSION% -m "Release %VERSION%"
git push origin v%VERSION%

echo Готово: build\release-%VERSION%.cf -- приложите к GitHub Release v%VERSION%.
