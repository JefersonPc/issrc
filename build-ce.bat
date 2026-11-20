@echo off
chcp 65001 >nul

rem  Inno Setup
rem  Copyright (C) 1997-2026 Jordan Russell
rem  Portions by Martijn Laan
rem  For conditions of distribution and use, see LICENSE.TXT.
rem
rem  Arquivo em lote para preparar o release do Inno Setup 64 bits (Community Edition)
rem
rem  Chama setup-sign.bat se existir para criar compilação assinada, senão cria setup.exe sem assinar
rem  Compilações assinadas também exigem que exista setup-presign.bat para assinar todos os arquivos passados para ele
rem
rem  Este arquivo em lote executa as seguintes etapas:
rem  -Solicita ao usuário para compilar o Inno Setup incluindo ISSigTool e ISHelpGen após limpar a saída
rem  -Compila ISetup*.chm
rem  -Executa os testes de unidade
rem  -Cria o instalador do Inno Setup 64 bits
rem
rem  Uma vez concluído, o instalador pode ser encontrado em Output

setlocal

set VER=7.1.1

echo Compilando Inno Setup %VER%...
echo.

cd /d %~dp0

if /I "%1"=="setup" goto setup
if not "%1"=="" goto failed

if not exist files\issigtool.exe (
  echo ISSigTool não encontrado
  echo Agora abra Projects\Projects.groupproj e compile o projeto ISSigTool na plataforma Win64 em modo Release

  echo - Aguardando arquivo...
  call :waitforfile files\issigtool.exe
  echo Compilação do ISSigTool concluída
)

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

if not exist ishelp\ishelpgen\ishelpgen.exe (
  echo ISHelpGen não encontrado
  echo Agora abra Projects\Projects.groupproj e compile o projeto ISHelpGen na plataforma Win64 em modo Release

  echo - Aguardando arquivo...
  call :waitforfile ishelp\ishelpgen\ishelpgen.exe
  echo Compilação do ISHelpGen concluída
)

cd ishelp
if errorlevel 1 goto failed
call .\compile.bat
if errorlevel 1 goto failed
cd ..
if errorlevel 1 goto failed
echo Compilação dos arquivos de ajuda ISetup*.chm concluída
pause

echo.
call :deletefile files\iside.exe
call :deletefile files\iscc.exe
call :deletefile files\iscmplr.dll
call :deletefile files\ispp.dll
call :deletefile files\setup.e32
call :deletefile files\setup.e64
call :deletefile files\setupcustomstyle.e32
call :deletefile files\setupcustomstyle.e64
call :deletefile files\setupldr.e32
call :deletefile files\setupldr.e64
call :deletefile files\issigtool.exe
call :deletefile files\istesttool.exe
call :deletefile ishelp\ishelpgen\ishelpgen.exe

echo Limpeza dos arquivos de compilação concluída
echo Agora abra Projects\Projects.groupproj e compile o grupo de compilação Release64
echo Você pode abrir o painel Build Groups na janela de ferramentas Projects

echo - Aguardando arquivos...
call :waitforfile files\iside.exe
call :waitforfile files\iscc.exe
call :waitforfile files\iscmplr.dll
call :waitforfile files\ispp.dll
call :waitforfile files\setup.e32
call :waitforfile files\setup.e64
call :waitforfile files\setupcustomstyle.e32
call :waitforfile files\setupcustomstyle.e64
call :waitforfile files\setupldr.e32
call :waitforfile files\setupldr.e64
call :waitforfile files\issigtool.exe
call :waitforfile files\istesttool.exe
call :waitforfile ishelp\ishelpgen\ishelpgen.exe

echo Todos os arquivos foram encontrados, aguardando mais 2 segundos...
timeout /t 2 /nobreak >nul
echo Compilação do Inno Setup concluída

Files\ISTestTool.exe Projects\Bin\Script.Test.iss
if errorlevel 1 goto failed
echo Testes do Inno Setup concluídos

if exist .\setup-presign.bat (
  echo - Pré-assinando
  call .\setup-presign.bat Files\ISCC.exe Files\ISCmplr.dll Files\ISPP.dll
  if errorlevel 1 goto failed
  echo Pré-assinatura concluída
)

rem  Assinar usando a chave privada do usuário - consulte também compile.bat
call .\issig.bat sign Files\ISCmplr.dll Files\ISPP.dll Files\Setup.e32 Files\Setup.e64 Files\SetupCustomStyle.e32 Files\SetupCustomStyle.e64 Files\SetupLdr.e32 Files\SetupLdr.e64
if errorlevel 1 goto failed
echo Assinatura do ISSigTool concluída

:setup
echo - Setup.exe
if exist .\setup-sign.bat (
  call .\setup-sign.bat /Dx64
) else (
  files\iscc setup.iss /NS /NSC /Dx64
)
if errorlevel 1 goto failed
echo - Renomeando arquivos...
cd output
if errorlevel 1 goto failed
move /y mysetup.exe innosetup-%VER%.exe
if errorlevel 1 goto failed
cd ..
if errorlevel 1 goto failed
echo Criação do instalador do Inno Setup concluída
call .\issig.bat sign output\innosetup-%VER%.exe
if errorlevel 1 goto failed

echo Tudo pronto!
pause
exit /b 0

:failed
echo *** FALHOU ***
pause
exit /b 1

:deletefile
if exist "%~1" (
    del "%~1"
    if exist "%~1" goto failed
    echo Removido: %~1
) 
exit /b

:waitforfile
if not exist "%~1" (
    timeout /t 1 /nobreak >nul
    goto waitforfile
)
echo Encontrado: %~1
exit /b
