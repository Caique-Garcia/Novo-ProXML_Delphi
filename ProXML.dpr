program ProXML;

uses
  Vcl.Forms,
  ProXML.FormPrincipal in 'view\ProXML.FormPrincipal.pas' {FormPrincipal},
  uCalculadoraXML in 'lib\uCalculadoraXML.pas',
  ProXML.FormRelatorios in 'view\ProXML.FormRelatorios.pas' {FormRelatorios};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  //Application.CreateForm(TFormRelatorios, FormRelatorios);
  Application.Run;
end.
