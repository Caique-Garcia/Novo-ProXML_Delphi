unit ProXML.FormRelatorioIBSCBS;

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
  Data.DB,
  DM;

type
  TFormRelatorioIBSCBS = class(TForm)
    QuickIBSCBS: TQuickRep;
    QRBandCabecalho: TQRBand;
    QRShapeCabecalho: TQRShape;
    QRLabelTitulo: TQRLabel;
    QRLabelQt: TQRLabel;
    QRLabelSubtitulo: TQRLabel;
    QRLabelModelo: TQRLabel;
    QRLabelNumero: TQRLabel;
    QRLabelData: TQRLabel;
    QRLabelBaseIBSCBS: TQRLabel;
    QRLabelIBSUF: TQRLabel;
    QRLabelIBSMun: TQRLabel;
    QRLabelIBS: TQRLabel;
    QRLabelCBS: TQRLabel;
    QRBandDetalhe: TQRBand;
    QRDBTextModelo: TQRDBText;
    QRDBTextNumero: TQRDBText;
    QRDBTextData: TQRDBText;
    QRDBTextBaseIBSCBS: TQRDBText;
    QRDBTextIBSUF: TQRDBText;
    QRDBTextIBSMun: TQRDBText;
    QRDBTextIBS: TQRDBText;
    QRDBTextCBS: TQRDBText;
    QRBandTotais: TQRBand;
    QRShapeTotais: TQRShape;
    QRLabelTituloBaseIBSCBS: TQRLabel;
    QRLabelTituloIBSUF: TQRLabel;
    QRLabelTituloIBSMun: TQRLabel;
    QRLabelTituloIBS: TQRLabel;
    QRLabelTituloCBS: TQRLabel;
    QRLabelTituloQt: TQRLabel;
    QRLabelTotalBaseIBSCBS: TQRLabel;
    QRLabelTotalIBSUF: TQRLabel;
    QRLabelTotalIBSMun: TQRLabel;
    QRLabelTotalIBS: TQRLabel;
    QRLabelTotalCBS: TQRLabel;
    QRLabelTotalQt: TQRLabel;
    QRBandRodape: TQRBand;
    QRSysDataData: TQRSysData;
    QRSysDataPagina: TQRSysData;
    QRLabelDesenvolvido: TQRLabel;

  private

    { Private declarations }
  public
    procedure SetTotalBaseIBSCBS(const Value: String);
    procedure SetTotalIBSUF(const Value: String);
    procedure SetTotalIBSMun(const Value: String);
    procedure SetTotalIBS(const Value: String);
    procedure SetTotalCBS(const Value: String);
    procedure SetQtRegistros(const Value: String);
    //Modelo filtrado no subtítulo (ex.: 'NF-e 55'); vazio = todos os modelos
    procedure SetDescricaoFiltro(const Descricao: String);
    //Abre a visualização do relatório. Retorna False, sem abrir nada, quando
    //nenhuma nota do filtro de modelo atual tem IBS/CBS
    function  GerarRelatorio(): Boolean;
  end;

var
  FormRelatorioIBSCBS: TFormRelatorioIBSCBS;

implementation

{$R *.dfm}

{ TFormRelatorioIBSCBS }

function TFormRelatorioIBSCBS.GerarRelatorio: Boolean;
begin
    //Gera o relatório de IBS/CBS (QryNotasIBSCBS já filtra pelo DMConfig.FiltroModelo)
    DMConfig.QryNotasIBSCBS.Active := False;

    DMConfig.QryNotasIBSCBS.Active := True;

    Result := not DMConfig.QryNotasIBSCBS.IsEmpty;

    if Result then
        QuickIBSCBS.Preview
    else
        DMConfig.QryNotasIBSCBS.Active := False;
end;

procedure TFormRelatorioIBSCBS.SetDescricaoFiltro(const Descricao: String);
begin
    if Trim(Descricao) = '' then
        QRLabelSubtitulo.Caption := 'XMLs de Nota Fiscal com IBS/CBS processados pelo programa'
    else
        QRLabelSubtitulo.Caption := 'XMLs de Nota Fiscal (' + Trim(Descricao) + ') com IBS/CBS processados pelo programa';
end;

procedure TFormRelatorioIBSCBS.SetQtRegistros(const Value: String);
begin
    //Quantidade de notas no cabeçalho e no rodapé
    QRLabelQt.Caption      := Trim(Value);
    QRLabelTotalQt.Caption := Trim(Value);
end;

procedure TFormRelatorioIBSCBS.SetTotalBaseIBSCBS(const Value: String);
begin
    QRLabelTotalBaseIBSCBS.Caption := Trim(Value);
end;

procedure TFormRelatorioIBSCBS.SetTotalIBSUF(const Value: String);
begin
    QRLabelTotalIBSUF.Caption := Trim(Value);
end;

procedure TFormRelatorioIBSCBS.SetTotalIBSMun(const Value: String);
begin
    QRLabelTotalIBSMun.Caption := Trim(Value);
end;

procedure TFormRelatorioIBSCBS.SetTotalIBS(const Value: String);
begin
    QRLabelTotalIBS.Caption := Trim(Value);
end;

procedure TFormRelatorioIBSCBS.SetTotalCBS(const Value: String);
begin
    QRLabelTotalCBS.Caption := Trim(Value);
end;

end.
