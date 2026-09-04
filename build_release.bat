@echo off
chcp 866 >nul
:: ---------------------------------------------------------------
:: ???? ???? (cf) ?? ??? master: vrunner compile
:: ?????????: build_release.bat 1.0.0
:: ---------------------------------------------------------------
if "%~1"=="" ( echo ?????? ????? ????, ??????: build_release.bat 1.0.0 & exit /b 1 )
set VERSION=%~1
set REPO=D:/DATA/BASE 1C/OTUS_DEMO_REP/
set BUILD_BASE=D:/DATA/BASE 1C/OTUS_DEMO_BUILD

cd /d "%REPO%" || exit /b 1

echo [1/4] ????????? master
git checkout master || exit /b 1
git pull origin master || exit /b 1

echo [2/4] ??????? ???? ??? ??
if not exist "%BUILD_BASE%\1Cv8.1CD" call vrunner init-dev --ibconnection /F"%BUILD_BASE%"

echo [3/4] ???? cf ?? ???????? src
if not exist build mkdir build
call vrunner compile --src ./src --out ./build/release-%VERSION%.cf --ibconnection /F"%BUILD_BASE%"
if errorlevel 1 exit /b 1

echo [4/4] ??? ????
git tag -a v%VERSION% -m "Release %VERSION%"
git push origin v%VERSION%

echo ????: build\release-%VERSION%.cf -- ?????? ? GitHub Release v%VERSION%.