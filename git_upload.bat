@echo off
title Git Upload Script
echo ===================================================
echo               4P Checking App Git Uploader
echo ===================================================
echo.

:: Check if git is installed
where git >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Git is not installed or not in PATH!
    echo Please install Git from https://git-scm.com/
    pause
    exit /b
)

:: Check if git repository is initialized
if not exist .git (
    echo [INFO] Git repository not initialized. Initializing now...
    git init
    git branch -M main
    echo.
    set /p "remote_url=Enter your remote Git repository URL (e.g., https://github.com/username/repo.git): "
    if not "%remote_url%"=="" (
        git remote add origin %remote_url%
        echo [SUCCESS] Remote origin added.
    ) else (
        echo [WARNING] No remote URL provided. You will need to add it manually later.
    )
    echo.
)

:: Stage all changes
echo [INFO] Staging changes...
git add .

:: Prompt for commit message
echo.
set /p "commit_msg=Enter commit message (Press Enter for default: 'Update 4P Checking App'): "
if "%commit_msg%"=="" (
    set "commit_msg=Update 4P Checking App"
)

:: Commit changes
echo.
echo [INFO] Committing changes...
git commit -m "%commit_msg%"

:: Push changes
echo.
echo [INFO] Pushing to remote repository...
:: Check if upstream is set
git rev-parse --abbrev-ref @{u} >nul 2>nul
if %errorlevel% neq 0 (
    echo [INFO] No upstream branch set. Pushing to origin main...
    git push -u origin main
) else (
    git push
)

if %errorlevel% equ 0 (
    echo.
    echo ===================================================
    echo [SUCCESS] Code uploaded successfully to Git!
    echo ===================================================
) else (
    echo.
    echo ===================================================
    echo [ERROR] Git push failed. Please check your credentials or remote URL.
    echo ===================================================
)

pause
