@echo off
chcp 65001 >nul

rem  Inno Setup
rem  Copyright (C) 1997-2026 Jordan Russell
rem  Portions by Martijn Laan
rem  For conditions of distribution and use, see LICENSE.TXT.
rem
rem  Arquivo em lote para compilar e executar testes de unidade ISTestTool

setlocal

cd /d %~dp0

if "%1"=="" (
  set "Archs=x86 x64"
) else if "%1"=="x86" (
  set "Archs=x86"
) else if "%1"=="x64" (
  set "Archs=x64"
) else (
  echo Parâmetro de arquitetura inválido. Deve ser omitido ou ser "x86" ou "x64".
  goto failed
)

for %%a in (%Archs%) do (
  call :test %%a
  if errorlevel 1 goto failed
)

echo Sucesso!

exit /b 0

:failed
echo *** FALHOU ***
exit /b 1

:test
echo Limpando arquivos da compilação anterior...
if exist Files\ISTestTool.exe del Files\ISTestTool.exe

call .\compile.bat %~1 ISTestTool
if errorlevel 1 exit /b 1
echo Compilação do Inno Setup Test Tool %~1 concluída

Files\ISTestTool.exe Projects\Bin\Script.Test.iss
if errorlevel 1 exit /b 1
echo Testes do Inno Setup %~1 concluídos

exit /b
