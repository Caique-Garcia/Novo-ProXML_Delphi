unit ProXML.FormRelatorioIBSCBS;

{ Relatório IBS/CBS no QuickReport (Plano 1; visual da etapa 4.8 do Plano 4, no mesmo padrão do
  Relatório de Notas: mockup relatorio-a4.html, tokens.md seção 6, glossário seção 10).

  Só entram as notas do filtro de modelo que têm o grupo IBSCBSTot (QryNotasIBSCBS). Colunas na ordem
  Nº · Modelo · Data · … (decisão D9). Os totais vêm da memória (FormPrincipal.Totais), não de SUM no
  banco. As funções comuns (valores, período, cabeçalho, logo, zebra, rodapé) ficam em
  ProXML.FormRelatorios. }

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
  DM,
  uCalculadoraXML;

type
  TFormRelatorioIBSCBS = class(TForm)
    QuickIBSCBS: TQuickRep;
    QRBandTitulo: TQRBand;
    QRLabelTitulo: TQRLabel;
    QRLabelRotuloPeriodo: TQRLabel;
    QRLabelPeriodo: TQRLabel;
    QRLabelRotuloModelo: TQRLabel;
    QRLabelModeloFiltro: TQRLabel;
    QRLabelQuantidade: TQRLabel;
    QRLabelNotas: TQRLabel;
    QRLabelRotuloPasta: TQRLabel;
    QRLabelPasta: TQRLabel;
    QRImageLogo: TQRImage;
    QRLabelMarca: TQRLabel;
    QRShapeTitulo: TQRShape;
    QRBandContinuacao: TQRBand;
    QRLabelContinuacao: TQRLabel;
    QRLabelPeriodoContinuacao: TQRLabel;
    QRShapeContinuacao: TQRShape;
    QRBandColunas: TQRBand;
    QRLabelNumero: TQRLabel;
    QRLabelModelo: TQRLabel;
    QRLabelData: TQRLabel;
    QRLabelBaseIBSCBS: TQRLabel;
    QRLabelIBSUF: TQRLabel;
    QRLabelIBSMun: TQRLabel;
    QRLabelIBS: TQRLabel;
    QRLabelCBS: TQRLabel;
    QRShapeColunas: TQRShape;
    QRBandDetalhe: TQRBand;
    QRDBTextNumero: TQRDBText;
    QRDBTextModelo: TQRDBText;
    QRDBTextData: TQRDBText;
    QRDBTextBaseIBSCBS: TQRDBText;
    QRDBTextIBSUF: TQRDBText;
    QRDBTextIBSMun: TQRDBText;
    QRDBTextIBS: TQRDBText;
    QRDBTextCBS: TQRDBText;
    QRBandTotais: TQRBand;
    QRShapeTotais: TQRShape;
    QRLabelTotal: TQRLabel;
    QRLabelTotalBaseIBSCBS: TQRLabel;
    QRLabelTotalIBSUF: TQRLabel;
    QRLabelTotalIBSMun: TQRLabel;
    QRLabelTotalIBS: TQRLabel;
    QRLabelTotalCBS: TQRLabel;
    QRLabelLegenda: TQRLabel;
    QRBandRodape: TQRBand;
    QRShapeRodape: TQRShape;
    QRLabelRodape: TQRLabel;
    procedure FormCreate(Sender: TObject);
    procedure QuickIBSCBSBeforePrint(Sender: TCustomQuickRep; var PrintReport: Boolean);
    procedure QRBandDetalheBeforePrint(Sender: TQRCustomBand; var PrintBand: Boolean);
    procedure QRBandRodapeBeforePrint(Sender: TQRCustomBand; var PrintBand: Boolean);
    procedure ValorPrint(sender: TObject; var Value: string);
  private
    FTotais        : TTotaisNotas;
    FPasta         : string;
    FVersao        : string;
    FGeradoEm      : TDateTime;
    FTotalPaginas  : Integer;   //0 = não foi possível contar: o rodapé mostra só "Página X"
    FLinhaNaPagina : Integer;   //zebra: posição da linha na página atual
    procedure AplicarVisual;
    procedure MontarTextos;
  public
    //Totais da memória (FormPrincipal.Totais), já com o filtro de modelo: notas com IBS/CBS, notas do
    //filtro e somas de IBS/CBS
    procedure SetTotais(const Totais: TTotaisNotas);
    //Pasta das notas carregadas (linha "Pasta:" do cabeçalho)
    procedure SetPasta(const Pasta: string);
    //Versão do executável para o rodapé (ex.: "1.1.0"); vazio = sem versão
    procedure SetVersao(const Versao: string);
    //Abre a visualização do relatório. Retorna False, sem abrir nada, quando
    //nenhuma nota do filtro de modelo atual tem IBS/CBS
    function  GerarRelatorio(): Boolean;
  end;

var
  FormRelatorioIBSCBS: TFormRelatorioIBSCBS;

implementation

uses
  ProXML.Tema,
  ProXML.FormRelatorios;

{$R *.dfm}

{ TFormRelatorioIBSCBS }

procedure TFormRelatorioIBSCBS.FormCreate(Sender: TObject);
begin
    AplicarVisual;
end;

procedure TFormRelatorioIBSCBS.AplicarVisual;
var
    X    : Integer;
    Base : Integer;
begin
    //Mesmo visual do Relatório de Notas: fontes e cores só do tema, legível em impressora monocromática
    QuickIBSCBS.Font.Name   := FonteTexto;
    QRBandTitulo.Color      := CorSuperficie;
    QRBandContinuacao.Color := CorSuperficie;
    QRBandColunas.Color     := CorFundo;
    QRBandDetalhe.Color     := CorSuperficie;
    QRBandTotais.Color      := CorSuperficie;
    QRBandRodape.Color      := CorSuperficie;

    //Cabeçalho da 1ª página
    AplicarFonte(QRLabelTitulo.Font, FonteDestaque, TamanhoRelatorioTitulo, CorTexto);
    AplicarFonte(QRLabelRotuloPeriodo.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelRotuloModelo.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelQuantidade.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelRotuloPasta.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelPeriodo.Font, FonteTexto, TamanhoRelatorioDados, CorTextoSecundario);
    AplicarFonte(QRLabelModeloFiltro.Font, FonteTexto, TamanhoRelatorioDados, CorTextoSecundario);
    AplicarFonte(QRLabelNotas.Font, FonteTexto, TamanhoRelatorioDados, CorTextoSecundario);
    AplicarFonte(QRLabelPasta.Font, FonteTexto, TamanhoRelatorioDados, CorTextoSecundario);
    AplicarFonte(QRLabelMarca.Font, FonteDestaque, TamanhoMarcaRelatorio, CorMarinho);
    QRShapeTitulo.Brush.Color := CorMarinho;
    QRShapeTitulo.Pen.Style   := psClear;

    //Continuação (páginas 2 em diante)
    AplicarFonte(QRLabelContinuacao.Font, FonteTexto, TamanhoRelatorioDados, CorTextoSecundario);
    AplicarFonte(QRLabelPeriodoContinuacao.Font, FonteTexto, TamanhoRelatorioDados, CorTextoSecundario);
    QRShapeContinuacao.Brush.Color := CorBorda;
    QRShapeContinuacao.Pen.Style   := psClear;

    //Títulos das colunas e dados
    AplicarFonte(QRLabelNumero.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelModelo.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelData.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelBaseIBSCBS.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelIBSUF.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelIBSMun.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelIBS.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelCBS.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    QRShapeColunas.Brush.Color := CorBordaCampo;
    QRShapeColunas.Pen.Style   := psClear;
    AplicarFonte(QRDBTextNumero.Font, FonteTexto, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRDBTextModelo.Font, FonteTexto, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRDBTextData.Font, FonteTexto, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRDBTextBaseIBSCBS.Font, FonteTexto, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRDBTextIBSUF.Font, FonteTexto, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRDBTextIBSMun.Font, FonteTexto, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRDBTextIBS.Font, FonteTexto, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRDBTextCBS.Font, FonteTexto, TamanhoRelatorioDados, CorTexto);

    //Total e legenda
    QRShapeTotais.Brush.Color := CorMarinho;
    QRShapeTotais.Pen.Style   := psClear;
    AplicarFonte(QRLabelTotal.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelTotalBaseIBSCBS.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelTotalIBSUF.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelTotalIBSMun.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelTotalIBS.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelTotalCBS.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelLegenda.Font, FonteTexto, TamanhoRelatorioRodape, CorTextoSecundario);

    //Rodapé
    QRShapeRodape.Brush.Color := CorBorda;
    QRShapeRodape.Pen.Style   := psClear;
    AplicarFonte(QRLabelRodape.Font, FonteTexto, TamanhoRelatorioRodape, CorTextoSecundario);

    //Colunas (tokens.md 6, D9): Nº · Modelo · Data · Base IBS/CBS (o resto) · IBS UF · IBS Mun. · IBS · CBS.
    //Título, dado e total com o mesmo Left/Width e o mesmo alinhamento
    Base := LarguraUtilRelatorio - (LarguraRelIBSNumero + LarguraRelIBSModelo + LarguraRelIBSData +
                                    LarguraRelIBSUF + LarguraRelIBSMun + LarguraRelIBS + LarguraRelCBS);
    X := 0;
    PosicionarColunaRelatorio([QRLabelNumero, QRDBTextNumero], X, LarguraRelIBSNumero, PaddingCelulaRelatorio);
    Inc(X, LarguraRelIBSNumero);
    PosicionarColunaRelatorio([QRLabelModelo, QRDBTextModelo], X, LarguraRelIBSModelo, PaddingCelulaRelatorio);
    Inc(X, LarguraRelIBSModelo);
    PosicionarColunaRelatorio([QRLabelData, QRDBTextData], X, LarguraRelIBSData, PaddingCelulaRelatorio);
    Inc(X, LarguraRelIBSData);
    //"Total · n notas" ocupa as colunas antes da Base IBS/CBS (D8)
    PosicionarColunaRelatorio([QRLabelTotal], 0, X, PaddingCelulaRelatorio);
    PosicionarColunaRelatorio([QRLabelBaseIBSCBS, QRDBTextBaseIBSCBS, QRLabelTotalBaseIBSCBS], X, Base,
                              PaddingCelulaRelatorio);
    Inc(X, Base);
    PosicionarColunaRelatorio([QRLabelIBSUF, QRDBTextIBSUF, QRLabelTotalIBSUF], X, LarguraRelIBSUF,
                              PaddingCelulaRelatorio);
    Inc(X, LarguraRelIBSUF);
    PosicionarColunaRelatorio([QRLabelIBSMun, QRDBTextIBSMun, QRLabelTotalIBSMun], X, LarguraRelIBSMun,
                              PaddingCelulaRelatorio);
    Inc(X, LarguraRelIBSMun);
    PosicionarColunaRelatorio([QRLabelIBS, QRDBTextIBS, QRLabelTotalIBS], X, LarguraRelIBS, PaddingCelulaRelatorio);
    Inc(X, LarguraRelIBS);
    PosicionarColunaRelatorio([QRLabelCBS, QRDBTextCBS, QRLabelTotalCBS], X, LarguraRelCBS, PaddingCelulaRelatorio);
    PosicionarColunaRelatorio([QRLabelLegenda], 0, LarguraUtilRelatorio, PaddingCelulaRelatorio);

    //Logo à direita do cabeçalho; o texto "ProXML" só aparece se o logo não puder ser desenhado
    PosicionarRelatorio(QRImageLogo, LarguraUtilRelatorio - LarguraLogoRelatorio, LarguraLogoRelatorio);
    DesenharLogoRelatorio(QRImageLogo, QRLabelMarca);
end;

procedure TFormRelatorioIBSCBS.MontarTextos;
var
    Resumo     : TResumoRelatorio;
    Periodo    : string;
    Filtro     : Integer;
    Ponto      : string;
    Fim        : Double;
    Espaco     : Double;
    Largura    : Double;
    Quantidade : Integer;
begin
    Ponto      := ' ' + #$00B7 + ' ';
    Filtro     := DMConfig.FiltroModelo;
    Quantidade := FTotais.QuantidadeIBSCBS;
    //Período só das notas com IBS/CBS (as que este relatório lista)
    Resumo  := ResumirRelatorio(DMConfig.QryNotasIBSCBS);
    Periodo := TextoPeriodoRelatorio(Resumo);

    //Linha 1 (10.2/10.3): "Período: … · Modelo: … · {n} notas com IBS/CBS"
    QRLabelRotuloPeriodo.Enabled := Periodo <> '';
    QRLabelPeriodo.Enabled       := Periodo <> '';
    QRLabelPeriodo.Caption       := ' ' + Periodo + Ponto;
    QRLabelModeloFiltro.Caption  := ' ' + TextoModeloRelatorio(Filtro, True) + Ponto;
    QRLabelQuantidade.Caption    := IntToStr(Quantidade);
    if Quantidade = 1 then
        QRLabelNotas.Caption := ' nota com IBS/CBS'
    else
        QRLabelNotas.Caption := ' notas com IBS/CBS';
    MontarLinhaRelatorio([QRLabelRotuloPeriodo, QRLabelPeriodo, QRLabelRotuloModelo, QRLabelModeloFiltro,
                          QRLabelQuantidade, QRLabelNotas], 0);

    //Linha 2 (10.4): "Pasta: {caminho}" numa linha só, cortada no meio antes do logo
    Fim     := MontarLinhaRelatorio([QRLabelRotuloPasta], 0);
    Espaco  := MedirTextoRelatorio(QRLabelPasta.Font, ' ');
    Largura := LarguraUtilRelatorio - LarguraLogoRelatorio - EspacoLogoRelatorio - Fim;
    QRLabelPasta.Caption := ' ' + EncurtarNoMeioRelatorio(QRLabelPasta.Font, FPasta, Largura - Espaco);
    PosicionarRelatorio(QRLabelPasta, Fim, Largura);

    //Continuação (10.16)
    QRLabelContinuacao.Caption        := 'Relatório IBS/CBS' + Ponto + 'Modelo: ' + TextoModeloRelatorio(Filtro, False) +
                                         Ponto + 'continuação';
    QRLabelPeriodoContinuacao.Caption := Periodo;

    //Total (10.14, D8): valores da memória embaixo de cada coluna
    QRLabelTotal.Caption           := 'Total' + Ponto + QuantidadeNotasRelatorio(Quantidade);
    QRLabelTotalBaseIBSCBS.Caption := FormatarValor(FTotais.BaseIBSCBS);
    QRLabelTotalIBSUF.Caption      := FormatarValor(FTotais.IBSUF);
    QRLabelTotalIBSMun.Caption     := FormatarValor(FTotais.IBSMun);
    QRLabelTotalIBS.Caption        := FormatarValor(FTotais.IBS);
    QRLabelTotalCBS.Caption        := FormatarValor(FTotais.CBS);

    //Legenda (10.15): "{n} de {m} notas do filtro têm o grupo IBS/CBS" (o verbo concorda com n)
    QRLabelLegenda.Caption := IntToStr(Quantidade) + ' de ' + QuantidadeNotasRelatorio(FTotais.Quantidade) +
                              ' do filtro';
    if Quantidade = 1 then
        QRLabelLegenda.Caption := QRLabelLegenda.Caption + ' tem o grupo IBS/CBS'
    else
        QRLabelLegenda.Caption := QRLabelLegenda.Caption + ' têm o grupo IBS/CBS';
end;

function TFormRelatorioIBSCBS.GerarRelatorio: Boolean;
begin
    //Gera o relatório de IBS/CBS (QryNotasIBSCBS já filtra pelo DMConfig.FiltroModelo)
    DMConfig.QryNotasIBSCBS.Active := False;

    DMConfig.QryNotasIBSCBS.Active := True;

    Result := not DMConfig.QryNotasIBSCBS.IsEmpty;

    if not Result then
    begin
        DMConfig.QryNotasIBSCBS.Active := False;
        Exit;
    end;

    //Data e hora do rodapé: uma só para todas as páginas
    FGeradoEm := Now;
    MontarTextos;

    //"Página X de Y": uma passada para contar as páginas e depois a visualização
    FTotalPaginas := 0;
    FTotalPaginas := ContarPaginasRelatorio(QuickIBSCBS);
    QuickIBSCBS.Preview;
end;

procedure TFormRelatorioIBSCBS.QuickIBSCBSBeforePrint(Sender: TCustomQuickRep; var PrintReport: Boolean);
begin
    //Cada montagem (contagem, visualização, impressão ou exportação) recomeça a zebra
    FLinhaNaPagina := 0;
end;

procedure TFormRelatorioIBSCBS.QRBandDetalheBeforePrint(Sender: TQRCustomBand; var PrintBand: Boolean);
begin
    PintarLinhaRelatorio(QuickIBSCBS, Sender, FLinhaNaPagina);
end;

procedure TFormRelatorioIBSCBS.QRBandRodapeBeforePrint(Sender: TQRCustomBand; var PrintBand: Boolean);
begin
    QRLabelRodape.Caption := TextoRodapeRelatorio(FVersao, FGeradoEm, QuickIBSCBS.PageNumber, FTotalPaginas);
end;

procedure TFormRelatorioIBSCBS.ValorPrint(sender: TObject; var Value: string);
begin
    //PD-5: texto do banco ("1234,56" ou "1234.56") impresso como "1.234,56"
    Value := TextoValorRelatorio(Value);
end;

procedure TFormRelatorioIBSCBS.SetTotais(const Totais: TTotaisNotas);
begin
    FTotais := Totais;
end;

procedure TFormRelatorioIBSCBS.SetPasta(const Pasta: string);
begin
    FPasta := Trim(Pasta);
end;

procedure TFormRelatorioIBSCBS.SetVersao(const Versao: string);
begin
    FVersao := Trim(Versao);
end;

end.
