@echo off
setlocal enabledelayedexpansion

set REPO=D:/DATA/BASE 1C/OTUS_DEMO_REP/
set SRC_BRANCH=storage_1c
set BASE_BRANCH=develop

cd /d "%REPO%" || exit /b 1
git fetch origin

echo Storage versions (commits %BASE_BRANCH%..%SRC_BRANCH%):
git log --reverse --oneline --no-decorate %BASE_BRANCH%..%SRC_BRANCH%
echo.

for /f "usebackq tokens=1,2 delims= " %%a in (`git log --reverse --oneline --no-decorate %BASE_BRANCH%..%SRC_BRANCH%`) do (
    set TASK=%%b
    set TASK=!TASK:,=!
    set TASK=!TASK::=!
    echo !TASK! | findstr /i /b "task" >nul
    if not errorlevel 1 (
        echo Branch task/!TASK!  -^>  commit %%a
        git branch -f task/!TASK! %%a
        git push -f origin task/!TASK!
    ) else (
        echo Skip commit %%a: message does not start with TASK
    )
)

echo.
echo Done. Create Pull Requests task/TASK-N -^> %BASE_BRANCH% in ascending order.
endlocal