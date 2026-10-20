program ProXML;

uses
  Vcl.Forms,
  ProXML.FormPrincipal in 'view\ProXML.FormPrincipal.pas' {FormPrincipal},
  uCalculadoraXML in 'lib\uCalculadoraXML.pas',
  ProXML.FormRelatorios in 'view\ProXML.FormRelatorios.pas' {FormRelatorios},
  ProXML.FormRelatorioIBSCBS in 'view\ProXML.FormRelatorioIBSCBS.pas' {FormRelatorioIBSCBS},
  DM in 'datamodule\DM.pas' {DMConfig: TDataModule},
  ProXML.Classes in 'classes\ProXML.Classes.pas',
  ProXML.Tema in 'view\ProXML.Tema.pas',
  ProXML.Botao in 'view\ProXML.Botao.pas';

{$R *.res}

begin
  Application.Initialize;
  //Application.OnException := GravaLog;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDMConfig, DMConfig);
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
