@echo off
setlocal
flutter pub get
flutter build windows --release
if errorlevel 1 exit /b %errorlevel%
echo Build complete: build\windows\x64\runner\Release\booksoul_dashboard.exe
