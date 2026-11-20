@echo off
chcp 65001 >nul

rem  Inno Setup
rem  Copyright (C) 1997-2026 Jordan Russell
rem  Portions by Martijn Laan
rem  For conditions of distribution and use, see LICENSE.TXT.
rem
rem  Arquivo em lote para preparar o release

setlocal

set VER=7.1.1

echo Compilando Inno Setup %VER%...
echo.

cd /d %~dp0

call .\compile.bat x64 ISSigTool
if errorlevel 1 goto failed
echo Compilação do ISSigTool concluída

rem  Verificar binários pré-compilados usados durante a compilação
rem  Nota: Outros binários pré-compilados são verificados por Setup.iss
call .\issig.bat verify --key-file=def01.ispublickey ^
  Projects\Src\Compression.LZMADecompressor\Lzma2Decode\ISLzmaDec-x86.obj ^
  Projects\Src\Compression.LZMADecompressor\Lzma2Decode\ISLzmaDec-x64.obj ^
  Projects\Src\Compression.LZMA1SmallDecompressor\LzmaDecode\LzmaDecodeInno-x86.obj ^
  Projects\Src\Compression.LZMA1SmallDecompressor\LzmaDecode\LzmaDecodeInno-x64.obj ^
  Projects\Src\Compression.SevenZipDecoder\7zDecode\IS7zDec-x86.obj ^
  Projects\Src\Compression.SevenZipDecoder\7zDecode\IS7zDec-x64.obj
if errorlevel 1 goto failed
echo Verificação do ISSigTool concluída

rem  Incorporar chave pública do usuário nos fontes
call .\issig.bat embed
if errorlevel 1 goto failed
echo Incorporação da chave no ISSigTool concluída

call .\compile.bat x64 ISHelpGen
if errorlevel 1 goto failed
echo Compilação do ISHelpGen concluída

cd ishelp
if errorlevel 1 goto failed
call .\compile.bat
if errorlevel 1 goto failed
cd ..
if errorlevel 1 goto failed
echo Compilação dos arquivos de ajuda ISetup*.chm concluída
pause

call :build x86
if errorlevel 1 goto failed

echo Limpando arquivos da compilação anterior...
del Files\ISCmplr.dll Files\ISPP.dll Files\Setup.e32 Files\Setup.e64 Files\SetupCustomStyle.e32 Files\SetupCustomStyle.e64 Files\SetupLdr.e32 Files\SetupLdr.e64
if errorlevel 1 goto failed
del Files\ISIDE.exe Files\ISCC.exe Files\ISSigTool.exe Files\ISTestTool.exe
if errorlevel 1 goto failed

call :build x64
if errorlevel 1 goto failed

echo Tudo pronto!
pause
exit /b 0

:failed
echo *** FALHOU ***
pause
exit /b 1

:build
call .\compile.bat %~1
if errorlevel 1 exit /b 1
echo Compilação do Inno Setup %~1 concluída

Files\ISTestTool.exe Projects\Bin\Script.Test.iss
if errorlevel 1 exit /b 1
echo Testes do Inno Setup %~1 concluídos

if exist .\setup-presign.bat (
  echo - Pré-assinando
  call .\setup-presign.bat Files\ISCC.exe Files\ISCmplr.dll Files\ISPP.dll
  if errorlevel 1 exit /b 1
  echo Pré-assinatura concluída
) 

rem  Assinar usando a chave privada do usuário - consulte também compile.bat
call .\issig.bat sign Files\ISCmplr.dll Files\ISPP.dll Files\Setup.e32 Files\Setup.e64 Files\SetupCustomStyle.e32 Files\SetupCustomStyle.e64 Files\SetupLdr.e32 Files\SetupLdr.e64
if errorlevel 1 exit /b 1
echo Assinatura ISSigTool %~1 concluída

echo - %~1 Setup.exe
if exist .\setup-sign.bat (
  call .\setup-sign.bat /D%~1
) else (
  files\iscc setup.iss /NS /NSC /D%~1
)
if errorlevel 1 exit /b 1
echo - Renomeando arquivos %~1...
cd output
if errorlevel 1 exit /b 1
move /y mysetup.exe innosetup-%VER%-%~1.exe
if errorlevel 1 exit /b 1
cd ..
if errorlevel 1 exit /b 1
echo Criação do instalador do Inno Setup %~1 concluída
call .\issig.bat sign output\innosetup-%VER%-%~1.exe
if errorlevel 1 exit /b 1

exit /b
