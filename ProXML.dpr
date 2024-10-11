program ProXML;

uses
  Vcl.Forms,
  ProXML.FormPrincipal in 'view\ProXML.FormPrincipal.pas' {FormPrincipal},
  uCalculadoraXML in 'lib\uCalculadoraXML.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
