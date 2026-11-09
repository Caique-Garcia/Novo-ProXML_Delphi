; Instalador do ProXML (Inno Setup 6)
;
; Não compile direto pela IDE: use installer\build.ps1, que monta a pasta de
; staging (só arquivos versionados + o exe Release informado) e passa:
;   /DAppVersion=1.2.0   versão do programa (AppVersion e VersionInfoVersion)
;   /DSourceDir=<pasta>  pasta de staging com ProXML.exe, sk4d.dll, Report\, ...
;
; Decisões (docs/planos/plano-2-instalador.md):
; - por usuário, em {localappdata}\ProXML, sem administrador e sem assinatura;
; - db\notas.db vazio só se não existir e nunca desinstalado (preserva as configurações);
; - atalhos com WorkingDir: {app}; atalho na Área de Trabalho opcional e marcado;
; - "Iniciar o ProXML" marcado na última tela;
; - nome do setup fixo: ProXML-Setup.exe (links releases/latest/download).

#ifndef AppVersion
  #error Informe a versão: /DAppVersion=1.2.0 (use installer\build.ps1)
#endif
#ifndef SourceDir
  #error Informe a pasta de staging: /DSourceDir=... (use installer\build.ps1)
#endif

#define AppName      "ProXML"
#define AppExeName   "ProXML.exe"
#define AppPublisher "Caique Garcia"
#define AppURL       "https://github.com/Caique-Garcia/Novo-ProXML_Delphi"

[Setup]
; AppId FIXO: não altere, senão as atualizações deixam de substituir a versão anterior.
AppId={{E7CB7020-EEB6-475A-8BDB-4B358B48B837}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#AppURL}
AppSupportURL={#AppURL}/issues
AppUpdatesURL={#AppURL}/releases/latest
VersionInfoVersion={#AppVersion}
VersionInfoProductName={#AppName}
VersionInfoDescription=Instalador do {#AppName}

; Por usuário, sem pedir administrador.
PrivilegesRequired=lowest
DefaultDirName={localappdata}\{#AppName}
UsePreviousAppDir=yes
DisableProgramGroupPage=yes
UninstallDisplayIcon={app}\{#AppExeName}
UninstallDisplayName={#AppName}

; Fecha o ProXML aberto antes de atualizar (Restart Manager).
CloseApplications=yes
RestartApplications=no

OutputDir=Output
OutputBaseFilename=ProXML-Setup
SetupIconFile=..\ProXML_Icon.ico
WizardStyle=modern
Compression=lzma2/max
SolidCompression=yes

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Tasks]
; Sem a flag "unchecked": vem marcada por padrão (pendência P1).
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Dirs]
Name: "{app}\db"; Flags: uninsneveruninstall
; Pastas de saída do app. Na desinstalação o Inno só as remove se estiverem vazias.
Name: "{app}\NFCe\danfePDF"
Name: "{app}\NFCe\EnvioResposta"

[Files]
Source: "{#SourceDir}\{#AppExeName}";       DestDir: "{app}"; Flags: ignoreversion
Source: "{#SourceDir}\sk4d.dll";            DestDir: "{app}"; Flags: ignoreversion
Source: "{#SourceDir}\LICENSE-lucide.txt";  DestDir: "{app}"; Flags: ignoreversion
Source: "{#SourceDir}\Report\*";            DestDir: "{app}\Report";  Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#SourceDir}\Schemas\*";           DestDir: "{app}\Schemas"; Flags: ignoreversion recursesubdirs createallsubdirs
; Banco vazio: só na primeira instalação; nunca sobrescrito nem desinstalado.
Source: "{#SourceDir}\db\notas.db";         DestDir: "{app}\db"; Flags: onlyifdoesntexist uninsneveruninstall

[Icons]
Name: "{autoprograms}\{#AppName}"; Filename: "{app}\{#AppExeName}"; WorkingDir: "{app}"
Name: "{autodesktop}\{#AppName}";  Filename: "{app}\{#AppExeName}"; WorkingDir: "{app}"; Tasks: desktopicon

[Run]
; Marcado por padrão (pendência P2); não roda em instalação silenciosa.
Filename: "{app}\{#AppExeName}"; Description: "{cm:LaunchProgram,{#AppName}}"; WorkingDir: "{app}"; Flags: nowait postinstall skipifsilent
