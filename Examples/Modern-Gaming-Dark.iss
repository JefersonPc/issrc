; =====================================================================
; Inno Setup 7 - Modelo 2: Gaming Dark Elegance (Visual Gamer & Escuro)
; =====================================================================
; Este script é ideal para Jogos (como simuladores, mods, jogos indie)
; ou softwares pesados/gráficos com visual Dark Mode profissional.
; =====================================================================

#define MyAppName "TruckPlay Simulator"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "TruckPlay Studios"
#define MyAppURL "https://www.truckplay.com"
#define MyAppExeName "MyProg-x64.exe"

[Setup]
AppId={{9C5E8B1A-7744-4F23-99AA-FEDCBA987654}
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
OutputBaseFileName=Instalador-Gaming-Dark
Compression=lzma2/max
SolidCompression=yes

; =====================================================================
; ESTILO VISUAL GAMER ESCURO
; =====================================================================
; 'modern dark slate': Estilo visual escuro elegante grafite com alto contraste
WizardStyle=modern dark slate hidebevels includetitlebar

; Não mostra janelinha antiga de idioma se o Windows estiver em Português
ShowLanguageDialog=auto

; Imagens personalizadas do instalador (com transparência sem quadrado preto ao redor)
WizardSmallImageFile=Images\ModernLogo64.bmp
WizardSmallImageFileDynamicDark=Images\ModernLogoDark64.bmp
WizardSmallImageBackColor=clNone
WizardImageFile=Images\ModernBanner.bmp
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
var
  ProgressPercentLabel: TLabel;

// Atualiza o progresso visual durante a extração dos arquivos
procedure CurInstallProgressChanged(CurProgress, MaxProgress: Integer);
var
  Percent: Integer;
begin
  if (MaxProgress > 0) and (ProgressPercentLabel <> nil) then
  begin
    Percent := (CurProgress * 100) div MaxProgress;
    ProgressPercentLabel.Caption := 'Instalando arquivos... ' + IntToStr(Percent) + '%';
  end;
end;

procedure InitializeWizard;
begin
  WizardForm.Font.Name := 'Segoe UI';

  // Destaque nos títulos da tela inicial
  WizardForm.WelcomeLabel1.Font.Size := 15;
  WizardForm.WelcomeLabel1.Font.Style := [fsBold];
  WizardForm.FinishedLabel.Font.Size := 15;
  WizardForm.FinishedLabel.Font.Style := [fsBold];

  // Cria um indicador de progresso moderno acima da barra de instalação
  ProgressPercentLabel := TLabel.Create(WizardForm);
  ProgressPercentLabel.Parent := WizardForm.InstallingPage;
  ProgressPercentLabel.Left := WizardForm.ProgressGauge.Left;
  ProgressPercentLabel.Top := WizardForm.ProgressGauge.Top - 22;
  ProgressPercentLabel.Font.Name := 'Segoe UI';
  ProgressPercentLabel.Font.Size := 9;
  ProgressPercentLabel.Font.Style := [fsBold];
  ProgressPercentLabel.Caption := 'Preparando arquivos...';
end;
