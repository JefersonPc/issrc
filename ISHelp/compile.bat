@echo off
chcp 65001 >nul

rem  Inno Setup
rem  Copyright (C) 1997-2024 Jordan Russell
rem  Portions by Martijn Laan
rem  For conditions of distribution and use, see LICENSE.TXT.
rem
rem  Arquivo em lote para compilar o arquivo de ajuda

setlocal

cd /d %~dp0

if exist compilesettings.bat goto compilesettingsfound
:compilesettingserror
echo ISHelp\compilesettings.bat está ausente ou incompleto. Ele precisa ser criado
echo com as seguintes linhas, ajustadas para o seu sistema:
echo.
echo   set HHCEXE=%%ProgramFiles%%\HTML Help Workshop\hhc.exe   [Caminho para o compilador de ajuda]
goto failed

:compilesettingsfound
set HHCEXE=
call .\compilesettings.bat
if "%HHCEXE%"=="" goto compilesettingserror

rem -------------------------------------------------------------------------

echo Sincronizando arquivos do tema escuro:
echo.
call .\synch-darkfiles.bat nopause
if errorlevel 1 goto failed

call :generate_help
if errorlevel 1 goto failed
call :generate_help -dark
if errorlevel 1 goto failed

del /q Staging-dark\topic_*.htm

echo Sucesso!
exit /b 0

:generate_help
echo Gerando arquivos de ajuda usando ISHelpGen:
echo.
ISHelpGen\ISHelpGen.exe . %1
if errorlevel 1 exit /b 1

echo.
exit /b
