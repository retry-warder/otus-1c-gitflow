@echo off
:: ---------------------------------------------------------------
:: Синхронизация хранилища 1С в ветку storage_1c (GitFlow)
:: ---------------------------------------------------------------
set STORAGE=D:/DATA/BASE 1C/OTUS_DEMO_STORAGE/
set REPO=D:/DATA/BASE 1C/OTUS_DEMO_REP/
set STORAGE_USER=Admin
set STORAGE_PWD=
set BRANCH=storage_1c

cd /d "%REPO%" || exit /b 1

echo [1/4] Переключение на ветку %BRANCH%
git checkout %BRANCH% || exit /b 1
git pull origin %BRANCH%

echo [2/4] Выгрузка новых версий хранилища (gitsync)
call gitsync sync --storage-user %STORAGE_USER% --storage-pwd "%STORAGE_PWD%" "%STORAGE%" "%REPO%src/"
if errorlevel 1 exit /b 1

echo [3/4] Новые коммиты:
git log --oneline branch_sync_hran..%BRANCH%

echo [4/4] Отправка в origin и обновление служебной ветки
git push origin %BRANCH% || exit /b 1
git branch -f branch_sync_hran %BRANCH%
git push -f origin branch_sync_hran

echo Готово. Откройте Pull Request %BRANCH% -^> develop.
