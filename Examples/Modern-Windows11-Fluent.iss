; =====================================================================
; Inno Setup 7 - Modelo 1: Windows 11 Fluent (Moderno & Elegante)
; =====================================================================
; Este script demonstra como criar um instalador com visual limpo,
; moderno no estilo Windows 11 Fluent Design, com suporte a tema 
; Claro/Escuro Dinâmico e imagens personalizadas.
; =====================================================================

#define MyAppName "Meu Aplicativo Moderno"
#define MyAppVersion "2.0"
#define MyAppPublisher "Minha Empresa"
#define MyAppURL "https://www.meusite.com"
#define MyAppExeName "MyProg-x64.exe"

[Setup]
; Informações básicas do aplicativo
AppId={{8B4F9A6C-32A1-4D5E-88B9-123456789ABC}
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
OutputBaseFileName=Instalador-Windows11-Fluent
Compression=lzma2/ultra64
SolidCompression=yes

; =====================================================================
; CONFIGURAÇÃO VISUAL MODERNA (ESTILO DO ASSISTENTE)
; =====================================================================
; WizardStyle define a aparência moderna. 
; 'modern': Layout amplo moderno
; 'dynamic': Alterna automaticamente entre Claro e Escuro conforme o Windows
; 'windows11': Estilo visual baseado no Windows 11 Fluent
WizardStyle=modern dynamic windows11 hidebevels includetitlebar

; WizardResizable é automático no Inno Setup 7 moderno
WizardSizePercent=115,115

; =====================================================================
; CONTROLE DA JANELA DE IDIOMA
; =====================================================================
; 'auto': Detecta automaticamente o idioma do Windows sem mostrar janelinha antiga!
; Se você quiser forçar a não mostrar nunca: ShowLanguageDialog=no
ShowLanguageDialog=auto

; =====================================================================
; SUAS IMAGENS PERSONALIZADAS
; =====================================================================
; WizardSmallImageFile: Ícone do canto superior direito (substitui a caixa com CD)
; Tamanho recomendado: 55x55 ou 64x64 pixels
WizardSmallImageFile=Images\ModernLogo64.bmp

; WizardImageFile: Imagem grande lateral das páginas inicial e final
; Tamanho recomendado: 164x314 pixels
WizardImageFile=Images\ModernBanner.bmp

; Ícone moderno do executável e das caixas de diálogo (.ico)
SetupIconFile=Images\ModernApp.ico

; Idiomas disponíveis
[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
; Arquivos do seu programa
Source: "MyProg-x64.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "Readme.txt"; DestDir: "{app}"; Flags: ignoreversion isreadme

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[Code]
// Personalizações visuais modernas via código Pascal
procedure InitializeWizard;
begin
  // Usa a fonte oficial moderna do Windows 11
  WizardForm.Font.Name := 'Segoe UI';
  
  // Ajusta títulos e textos para ficarem elegantes e legíveis
  WizardForm.WelcomeLabel1.Font.Size := 14;
  WizardForm.WelcomeLabel1.Font.Style := [fsBold];
  WizardForm.FinishedLabel.Font.Size := 14;
  WizardForm.FinishedLabel.Font.Style := [fsBold];
end;
