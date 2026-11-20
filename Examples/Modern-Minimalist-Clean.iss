; =====================================================================
; Inno Setup 7 - Modelo 3: Minimalist Corporate Clean (Minimalista & Pro)
; =====================================================================
; Este script é focado em softwares corporativos, ferramentas e utilitários
; que necessitam de uma instalação limpa, direta, sem poluição visual.
; =====================================================================

#define MyAppName "Professional Suite"
#define MyAppVersion "3.5"
#define MyAppPublisher "Software Solutions"
#define MyAppURL "https://www.example.com"
#define MyAppExeName "MyProg-x64.exe"

[Setup]
AppId={{D3E4A1B2-55C6-4890-8811-AABBCCDDEEFF}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
OutputDir=..\Output
OutputBaseFileName=Instalador-Minimalist-Clean
Compression=lzma2/max
SolidCompression=yes

; =====================================================================
; ESTILO VISUAL MINIMALISTA LIMPO
; =====================================================================
; 'modern dynamic zircon': Estilo moderno dinâmico refinado com tons neutros
WizardStyle=modern dynamic zircon hidebevels includetitlebar

; Não mostra janelinha antiga de idioma se o Windows estiver em Português
ShowLanguageDialog=auto

; Imagens personalizadas
WizardSmallImageFile=Images\ModernLogo64.bmp
SetupIconFile=Images\ModernApp.ico

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "MyProg-x64.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "Readme.txt"; DestDir: "{app}"; Flags: ignoreversion isreadme

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[Code]
// Verificação de sistema e personalização limpa
function InitializeSetup: Boolean;
begin
  // Permite verificar se o sistema atende aos requisitos
  Result := True;
end;

procedure InitializeWizard;
begin
  WizardForm.Font.Name := 'Segoe UI';

  // Configuração refinada de tipografia
  WizardForm.WelcomeLabel1.Font.Size := 14;
  WizardForm.WelcomeLabel1.Font.Style := [fsBold];
  WizardForm.FinishedLabel.Font.Size := 14;
  WizardForm.FinishedLabel.Font.Style := [fsBold];
  
  // Posicionamento espaçoso e confortável
  WizardForm.WelcomeLabel2.Font.Size := 10;
end;
