@echo off
echo ========================================
echo Push to GitHub - Roblox Optimizm
echo ========================================
echo.

set /p username="Enter your GitHub username: "

echo.
echo Setting up remote...
git remote remove origin 2>nul
git remote add origin https://github.com/%username%/roblox-optimizm.git

echo.
echo Pushing to GitHub...
git branch -M main
git push -u origin main

echo.
echo ========================================
echo Done!
echo ========================================
echo.
echo Your LoadString URL:
echo loadstring(game:HttpGet("https://raw.githubusercontent.com/%username%/roblox-optimizm/main/sc_real.lua"))()
echo.
pause
