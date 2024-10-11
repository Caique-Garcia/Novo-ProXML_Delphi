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
    QuickRepRelConvenio: TQuickRep;
    Label186: TLabel;
    QRBand166: TQRBand;
    QRLabel600: TQRLabel;
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
    QRLabelTotalConv: TQRLabel;
    QRLabelPagoConv: TQRLabel;
    QRShape88: TQRShape;
    QRLabel621: TQRLabel;
    QRLabel628: TQRLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormRelatorios: TFormRelatorios;

implementation

{$R *.dfm}

end.
