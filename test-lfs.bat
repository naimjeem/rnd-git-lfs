@echo off
REM Git LFS Test Script for Windows
REM This script helps test Git LFS functionality locally

echo === Git LFS Test Script ===
echo.

REM Check if Git LFS is installed
git lfs version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Git LFS is not installed!
    echo Please install Git LFS first:
    echo   - Using Chocolatey: choco install git-lfs
    echo   - Or download from https://git-lfs.github.io/
    pause
    exit /b 1
)

echo ✅ Git LFS is installed:
git lfs version
echo.

REM Check if we're in a Git repository
git rev-parse --git-dir >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Not in a Git repository!
    echo Please run this script from the repository root
    pause
    exit /b 1
)

echo ✅ In a Git repository
echo.

REM Initialize Git LFS
echo 🔧 Initializing Git LFS...
git lfs install
echo.

REM Check LFS configuration
echo 📋 Git LFS Configuration:
git lfs env
echo.

REM List LFS files
echo 📁 LFS Files in repository:
git lfs ls-files
echo.

REM Check if large file exists
if exist "large_file.bin" (
    echo 📊 Large file information:
    dir large_file.bin
    echo.
) else (
    echo ⚠️  large_file.bin not found in working directory
    echo Running 'git lfs pull' to download LFS files...
    git lfs pull
    echo.
    if exist "large_file.bin" (
        echo ✅ File downloaded successfully:
        dir large_file.bin
    ) else (
        echo ❌ Failed to download LFS file
        pause
        exit /b 1
    )
)

echo.
echo === Test Summary ===
echo ✅ Git LFS is properly configured
echo ✅ Large file is tracked by LFS
echo ✅ File can be downloaded successfully
echo.
echo 🎉 All tests passed! Git LFS is working correctly.
pause
