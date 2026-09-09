@echo off
REM ==============================================
REM Mx Emulator - Setup para Windows
REM Root Terminal estilo Kali en rojo con Zsh
REM ==============================================

setlocal enabledelayedexpansion

color 0C
echo.
echo ╔══════════════════════════════════════════════╗
echo ║         Mx Emulator - Setup Windows         ║
echo ║         Root Terminal en rojo               ║
echo ╚══════════════════════════════════════════════╝
echo.

REM Verificar si estamos en WSL
wsl --status >nul 2>&1
if %errorlevel% equ 0 (
    echo [✓] WSL detectado
    echo [!] Ejecutando setup.sh en WSL...
    wsl bash -c "curl -sSL https://raw.githubusercontent.com/tu-usuario/Mx-Emulator/main/setup.sh | bash"
    pause
    exit /b
)

REM Si no hay WSL, instalar Git Bash y Zsh portable
echo [!] No se detectó WSL.
echo [!] Instalando dependencias para Windows nativo...

REM Crear directorios
echo [+] Creando estructura de directorios...
mkdir "%USERPROFILE%\.config\mx-emulator" 2>nul
mkdir "%USERPROFILE%\.local\share\mx-emulator\tools" 2>nul
mkdir "%USERPROFILE%\.local\share\mx-emulator\scripts" 2>nul
mkdir "%USERPROFILE%\Mx-Emulator\logs" 2>nul

REM Crear script de lanzamiento para PowerShell
echo [+] Creando lanzador Mx...
(
echo @echo off
echo color 0C
echo echo.
echo echo ╔══════════════════════════════════════════════╗
echo echo ║         Mx Emulator - Root Terminal         ║
echo echo ╚══════════════════════════════════════════════╝
echo echo.
echo echo [!] Modo Windows - Usa WSL para mejor experiencia
echo echo [!] Instala WSL con: wsl --install
echo echo.
echo echo [+] Usando PowerShell...
echo powershell -ExecutionPolicy Bypass -File "%%USERPROFILE%%\.local\share\mx-emulator\scripts\mx.ps1"
echo pause
) > "%USERPROFILE%\Desktop\Mx-Emulator.bat"

REM Crear script PowerShell con prompt rojo
echo [+] Creando configuración PowerShell...
(
echo # Mx Emulator - PowerShell Prompt
echo $Host.UI.RawUI.ForegroundColor = "Red"
echo function prompt {
echo     $p = Get-Location
echo     Write-Host "┌─[root@Mx]─[$p]" -ForegroundColor Red
echo     Write-Host "└─# " -ForegroundColor Red -NoNewline
echo     return " "
echo }
echo Write-Host "╔══════════════════════════════════════════════╗" -ForegroundColor Red
echo Write-Host "║         Mx Emulator - Root Terminal         ║" -ForegroundColor Red
echo Write-Host "║         Modo: Hacking Ético                 ║" -ForegroundColor Red
echo Write-Host "╚══════════════════════════════════════════════╝" -ForegroundColor Red
echo Write-Host "[✓] Mx Emulator cargado correctamente" -ForegroundColor Green
echo Write-Host "[!] Para herramientas, instala WSL y usa setup.sh" -ForegroundColor Yellow
) > "%USERPROFILE%\.local\share\mx-emulator\scripts\mx.ps1"

REM Crear herramientas básicas (batch)
echo [+] Creando herramientas básicas...
(
echo @echo off
echo color 0C
echo echo [+] Escaneando red local...
echo ping -n 1 192.168.1.1 >nul 2>&1
echo if errorlevel 1 (
echo     echo [!] Red no accesible o sin WSL
echo ) else (
echo     echo [✓] Red local detectada
echo     arp -a
echo )
echo pause
) > "%USERPROFILE%\.local\share\mx-emulator\tools\mx-scan.bat"

echo.
echo ╔══════════════════════════════════════════════╗
echo ║         ¡INSTALACIÓN COMPLETADA!            ║
echo ║                                             ║
echo ║  Para iniciar Mx Emulator:                  ║
echo ║     Ejecuta Mx-Emulator.bat en el escritorio║
echo ║                                             ║
echo ║  Recomendado: Instala WSL y ejecuta:       ║
echo ║     wsl bash setup.sh                      ║
echo ╚══════════════════════════════════════════════╝
echo.

pause
