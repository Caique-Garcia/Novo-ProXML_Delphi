unit ProXML.FormRelatorios;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  QRCtrls,
  QuickRpt,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  DM;

type
  TFormRelatorios = class(TForm)
    QuickNotas: TQuickRep;
    Label186: TLabel;
    QRBand166: TQRBand;
    QRLabel601: TQRLabel;
    QRLabel602: TQRLabel;
    QRLabel606: TQRLabel;
    QRLabel607: TQRLabel;
    QRLabel608: TQRLabel;
    QRLabel611: TQRLabel;
    QRLabel612: TQRLabel;
    QRShape40: TQRShape;
    QRBand167: TQRBand;
    QRDBText248: TQRDBText;
    QRDBText249: TQRDBText;
    QRDBText250: TQRDBText;
    QRDBText252: TQRDBText;
    QRDBText253: TQRDBText;
    QRBand168: TQRBand;
    QRSysData74: TQRSysData;
    QRSysData75: TQRSysData;
    QRLabel609: TQRLabel;
    QRBand169: TQRBand;
    QRLabel610: TQRLabel;
    QRLabel613: TQRLabel;
    QRShape88: TQRShape;
    QRLabel621: TQRLabel;
    QRLabelValorTotal: TQRLabel;
    QRLabelTotalICMS: TQRLabel;
    QRLabelTotalBC: TQRLabel;
  private

    { Private declarations }
  public
    procedure SetTotal(const Value: String);
    procedure SetTotalBC(const Value: String);
    procedure SetTotalICMS(const Value: String);
    procedure GerarRelatorio();
  end;

var
  FormRelatorios: TFormRelatorios;

implementation

{$R *.dfm}

{ TFormRelatorios }

procedure TFormRelatorios.GerarRelatorio;
begin
    //Gera o relatório de notas
    DMConfig.QryNotas.Active := False;

    DMConfig.QryNotas.Active := True;

    if Not DMConfig.QryNotas.IsEmpty then
        QuickNotas.Preview
    else
        raise Exception.Create('Sem registros no banco de dados!');
end;

procedure TFormRelatorios.SetTotal(const Value: String);
begin
    QRLabelValorTotal.Caption := Trim(Value);
end;

procedure TFormRelatorios.SetTotalICMS(const Value: String);
begin
    QRLabelTotalICMS.Caption := Trim(Value);
end;

procedure TFormRelatorios.SetTotalBC(const Value: String);
begin
    QRLabelTotalBC.Caption := Trim(Value);
end;

end.
