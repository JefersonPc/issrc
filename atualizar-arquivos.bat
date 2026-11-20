@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo ===================================================
echo   Atualizador dos Binarios e Recursos do Inno Setup
echo ===================================================
echo.

set SOURCE_EXE=
if exist "Projects\Bin\ISIDE.exe" set SOURCE_EXE=Projects\Bin\ISIDE.exe
if not defined SOURCE_EXE if exist "Files\ISIDE.exe" set SOURCE_EXE=Files\ISIDE.exe

if not defined SOURCE_EXE goto sem_exe

echo [1/3] Usando executavel: %SOURCE_EXE%
echo [2/3] Atualizando Files\ISIDE.exe...
copy /y "%SOURCE_EXE%" "Files\ISIDE.exe" >nul

if not exist "D:\Apps\Inno Setup 7" goto fim_sucesso

echo [3/3] Atualizando instalacao em D:\Apps\Inno Setup 7...
copy /y "%SOURCE_EXE%" "D:\Apps\Inno Setup 7\ISIDE.exe" >nul 2>&1
if errorlevel 1 (
    echo.
    echo [AVISO] Nao foi possivel sobrescrever D:\Apps\Inno Setup 7\ISIDE.exe
    echo Certifique-se de FECHAR o Inno Setup antes se ele estiver aberto!
    echo.
) else (
    echo       ISIDE.exe copiado com sucesso para D:\Apps\Inno Setup 7!
)

if not exist "D:\Apps\Inno Setup 7\Styles" mkdir "D:\Apps\Inno Setup 7\Styles" >nul 2>&1
copy /y "Files\Styles\*.vsf" "D:\Apps\Inno Setup 7\Styles\" >nul 2>&1
if not exist "D:\Apps\Inno Setup 7\Examples\Images" mkdir "D:\Apps\Inno Setup 7\Examples\Images" >nul 2>&1
copy /y "Examples\Images\*.*" "D:\Apps\Inno Setup 7\Examples\Images\" >nul 2>&1
copy /y "Examples\Modern-*.iss" "D:\Apps\Inno Setup 7\Examples\" >nul 2>&1
if not exist "D:\Apps\Inno Setup 7\Languages" mkdir "D:\Apps\Inno Setup 7\Languages" >nul 2>&1
copy /y "Files\Languages\BrazilianPortuguese.isl" "D:\Apps\Inno Setup 7\Languages\" >nul 2>&1
copy /y "Files\Languages\Portuguese.isl" "D:\Apps\Inno Setup 7\Languages\" >nul 2>&1
echo       Estilos VSF, exemplos e idiomas atualizados com sucesso!

:fim_sucesso
echo.
echo ===================================================
echo   SUCESSO: Todos os arquivos foram processados!
echo   Voce ja pode abrir o Inno Setup normalmente.
echo ===================================================
echo.
pause
exit /b 0

:sem_exe
echo.
echo ===================================================
echo   AVISO: Nenhum ISIDE.exe foi encontrado!
echo   Por favor, compile no Delphi primeiro (Shift+F9).
echo ===================================================
echo.
pause
exit /b 1
