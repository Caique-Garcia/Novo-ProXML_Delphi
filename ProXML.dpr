program ProXML;

uses
  Vcl.Forms,
  ProXML.FormPrincipal in 'view\ProXML.FormPrincipal.pas' {FormPrincipal},
  uCalculadoraXML in 'lib\uCalculadoraXML.pas',
  ProXML.FormRelatorios in 'view\ProXML.FormRelatorios.pas' {FormRelatorios},
  DM in 'datamodule\DM.pas' {DMConfig: TDataModule},
  ProXML.Classes in 'classes\ProXML.Classes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  AApplication.CreateForm(TDMConfig, DMConfig);
  AApplication.CreateForm(TFormPrincipal, FormPrincipal);
  plication.Run;
end.
