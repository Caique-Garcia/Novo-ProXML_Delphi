program ProXML;

uses
  Vcl.Forms,
  ProXML.FormPrincipal in 'view\ProXML.FormPrincipal.pas' {FormPrincipal},
  uCalculadoraXML in 'lib\uCalculadoraXML.pas',
  ProXML.FormRelatorios in 'view\ProXML.FormRelatorios.pas' {FormRelatorios},
  DM in 'datamodule\DM.pas' {DMConfig: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDMConfig, DMConfig);
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
