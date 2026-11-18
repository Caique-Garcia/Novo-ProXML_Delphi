unit ProXML.FormRelatorioDivergencias;

{ Relatório Divergências IBS/CBS no QuickReport (Plano 7, etapa 7.4; mockup relatorio-divergencias-a4.html,
  tokens.md seção 6, glossário seção 18), no mesmo padrão do Relatório IBS/CBS.

  - Uma linha por divergência da conferência de IBS/CBS (QryDivergencias, tabela divergencia_ibscbs), só das
    notas do filtro de modelo, em ordem de Nº, item (Total por último) e nível (decisões P7-8 e P7-10).
  - Contagens de notas conferidas, com Erro e com Alerta vêm da memória (FormPrincipal.Totais, com o filtro de
    modelo); o período vem das notas conferidas do filtro (QryNotasConferidas).
  - Sem divergência o relatório sai do mesmo jeito, com a mensagem "Nenhuma divergência de IBS/CBS" no corpo
    da 1ª página (decisão P7-9). Sem nota conferida no filtro, não sai (o botão fica desabilitado).
  - As funções comuns (período, cabeçalho, logo, zebra, rodapé) ficam em ProXML.FormRelatorios. }

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
  TFormRelatorioDivergencias = class(TForm)
    QuickDivergencias: TQuickRep;
    QRBandTitulo: TQRBand;
    QRLabelTitulo: TQRLabel;
    QRLabelRotuloPeriodo: TQRLabel;
    QRLabelPeriodo: TQRLabel;
    QRLabelRotuloModelo: TQRLabel;
    QRLabelModeloFiltro: TQRLabel;
    QRLabelQuantidade: TQRLabel;
    QRLabelNotas: TQRLabel;
    QRLabelQuantidadeDivergencias: TQRLabel;
    QRLabelDivergencias: TQRLabel;
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
    QRLabelItem: TQRLabel;
    QRLabelNivel: TQRLabel;
    QRLabelTipo: TQRLabel;
    QRLabelCampo: TQRLabel;
    QRLabelValorXML: TQRLabel;
    QRLabelEsperado: TQRLabel;
    QRShapeColunas: TQRShape;
    QRBandDetalhe: TQRBand;
    QRDBTextNumero: TQRDBText;
    QRDBTextModelo: TQRDBText;
    QRDBTextData: TQRDBText;
    QRDBTextItem: TQRDBText;
    QRDBTextNivel: TQRDBText;
    QRDBTextTipo: TQRDBText;
    QRDBTextCampo: TQRDBText;
    QRDBTextValorXML: TQRDBText;
    QRDBTextEsperado: TQRDBText;
    QRBandTotais: TQRBand;
    QRShapeTotais: TQRShape;
    QRLabelTotal: TQRLabel;
    QRLabelContagem: TQRLabel;
    QRLabelContagemNota: TQRLabel;
    QRLabelLegendaNiveis: TQRLabel;
    QRLabelLegendaTipos: TQRLabel;
    QRLabelLegendaFora: TQRLabel;
    QRLabelLegendaRegras: TQRLabel;
    QRShapeVazio: TQRShape;
    QRLabelVazioTitulo: TQRLabel;
    QRLabelVazioTexto: TQRLabel;
    QRLabelVazioRegras: TQRLabel;
    QRBandRodape: TQRBand;
    QRShapeRodape: TQRShape;
    QRLabelRodape: TQRLabel;
    procedure FormCreate(Sender: TObject);
    procedure QuickDivergenciasBeforePrint(Sender: TCustomQuickRep; var PrintReport: Boolean);
    procedure QRBandColunasBeforePrint(Sender: TQRCustomBand; var PrintBand: Boolean);
    procedure QRBandDetalheBeforePrint(Sender: TQRCustomBand; var PrintBand: Boolean);
    procedure QRBandRodapeBeforePrint(Sender: TQRCustomBand; var PrintBand: Boolean);
    procedure ItemPrint(sender: TObject; var Value: string);
  private
    FTotais        : TTotaisNotas;
    FPasta         : string;
    FVersao        : string;
    FGeradoEm      : TDateTime;
    FTotalPaginas  : Integer;   //0 = não foi possível contar: o rodapé mostra só "Página X"
    FLinhaNaPagina : Integer;   //zebra: posição da linha na página atual
    FDivergencias  : Integer;   //divergências do filtro (linhas do relatório)
    procedure AplicarVisual;
    procedure MontarTextos;
    procedure EmpilharLegendas;
    procedure PosicionarContagem;
  public
    //Totais da memória (FormPrincipal.Totais), já com o filtro de modelo: notas conferidas, com Erro e com Alerta
    procedure SetTotais(const Totais: TTotaisNotas);
    //Pasta das notas carregadas (linha "Pasta:" do cabeçalho)
    procedure SetPasta(const Pasta: string);
    //Versão do executável para o rodapé (ex.: "1.3.0"); vazio = sem versão
    procedure SetVersao(const Versao: string);
    procedure QRBandTituloBeforePrint(Sender: TQRCustomBand; var PrintBand: Boolean);
    procedure QRBandTotaisBeforePrint(Sender: TQRCustomBand; var PrintBand: Boolean);
    //Abre a visualização do relatório (com ou sem divergência). Retorna False, sem abrir nada, quando
    //nenhuma nota do filtro de modelo atual foi conferida (nenhuma tem IBS/CBS)
    function  GerarRelatorio(): Boolean;
  end;

var
  FormRelatorioDivergencias: TFormRelatorioDivergencias;

implementation

uses
  System.Math,
  ProXML.Tema,
  ProXML.FormRelatorios,
  uConferenciaIBSCBS;

{$R *.dfm}

{ TFormRelatorioDivergencias }

procedure TFormRelatorioDivergencias.FormCreate(Sender: TObject);
begin
    AplicarVisual;
end;

procedure TFormRelatorioDivergencias.AplicarVisual;
var
    X     : Integer;
    Campo : Integer;
begin
    //Mesmo visual dos outros relatórios: fontes e cores só do tema, legível em impressora monocromática
    QuickDivergencias.Font.Name := FonteTexto;
    QRBandTitulo.Color      := CorSuperficie;
    QRBandContinuacao.Color := CorSuperficie;
    QRBandColunas.Color     := CorFundo;
    QRBandDetalhe.Color     := CorSuperficie;
    QRBandTotais.Color      := CorSuperficie;
    QRBandRodape.Color      := CorSuperficie;

    //Cabeçalho da 1ª página (18.10 a 18.14)
    AplicarFonte(QRLabelTitulo.Font, FonteDestaque, TamanhoRelatorioTitulo, CorTexto);
    AplicarFonte(QRLabelRotuloPeriodo.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelRotuloModelo.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelQuantidade.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelQuantidadeDivergencias.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelRotuloPasta.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelPeriodo.Font, FonteTexto, TamanhoRelatorioDados, CorTextoSecundario);
    AplicarFonte(QRLabelModeloFiltro.Font, FonteTexto, TamanhoRelatorioDados, CorTextoSecundario);
    AplicarFonte(QRLabelNotas.Font, FonteTexto, TamanhoRelatorioDados, CorTextoSecundario);
    AplicarFonte(QRLabelDivergencias.Font, FonteTexto, TamanhoRelatorioDados, CorTextoSecundario);
    AplicarFonte(QRLabelPasta.Font, FonteTexto, TamanhoRelatorioDados, CorTextoSecundario);
    AplicarFonte(QRLabelMarca.Font, FonteDestaque, TamanhoMarcaRelatorio, CorMarinho);
    QRShapeTitulo.Brush.Color := CorMarinho;
    QRShapeTitulo.Pen.Style   := psClear;

    //Continuação (páginas 2 em diante, 18.28)
    AplicarFonte(QRLabelContinuacao.Font, FonteTexto, TamanhoRelatorioDados, CorTextoSecundario);
    AplicarFonte(QRLabelPeriodoContinuacao.Font, FonteTexto, TamanhoRelatorioDados, CorTextoSecundario);
    QRShapeContinuacao.Brush.Color := CorBorda;
    QRShapeContinuacao.Pen.Style   := psClear;

    //Títulos das colunas (18.15) e dados. O Tipo "Erro" fica em Semibold na impressão (18.18)
    AplicarFonte(QRLabelNumero.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelModelo.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelData.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelItem.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelNivel.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelTipo.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelCampo.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelValorXML.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelEsperado.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    QRShapeColunas.Brush.Color := CorBordaCampo;
    QRShapeColunas.Pen.Style   := psClear;
    AplicarFonte(QRDBTextNumero.Font, FonteTexto, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRDBTextModelo.Font, FonteTexto, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRDBTextData.Font, FonteTexto, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRDBTextItem.Font, FonteTexto, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRDBTextNivel.Font, FonteTexto, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRDBTextTipo.Font, FonteTexto, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRDBTextCampo.Font, FonteTexto, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRDBTextValorXML.Font, FonteTexto, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRDBTextEsperado.Font, FonteTexto, TamanhoRelatorioDados, CorTexto);

    //Total (18.21, 9 pt Semibold, linha de 2 px CorMarinho), contagem e legendas (18.21a a 18.25, 8 pt cinza).
    //Na contagem, "Notas com Erro: … Notas sem divergência: {s}" sai em Semibold CorTexto e só a observação
    //"· a nota com Erro e Alerta conta só em Erro" fica em cinza (mockup .tot2 b; D4 da B4)
    QRShapeTotais.Brush.Color := CorMarinho;
    QRShapeTotais.Pen.Style   := psClear;
    AplicarFonte(QRLabelTotal.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelContagem.Font, FonteDestaque, TamanhoRelatorioRodape, CorTexto);
    AplicarFonte(QRLabelContagemNota.Font, FonteTexto, TamanhoRelatorioRodape, CorTextoSecundario);
    //Os dois trechos da contagem sempre numa linha só (D6 da B5): sem AutoSize, o QuickReport quebrava o texto
    //que passava da caixa e a 2ª linha sumia. Com AutoSize e sem WordWrap ele não quebra nem apaga nada, e a
    //caixa acompanha o texto
    QRLabelContagem.WordWrap     := False;
    QRLabelContagem.AutoSize     := True;
    QRLabelContagemNota.WordWrap := False;
    QRLabelContagemNota.AutoSize := True;
    AplicarFonte(QRLabelLegendaNiveis.Font, FonteTexto, TamanhoRelatorioRodape, CorTextoSecundario);
    AplicarFonte(QRLabelLegendaTipos.Font, FonteTexto, TamanhoRelatorioRodape, CorTextoSecundario);
    AplicarFonte(QRLabelLegendaFora.Font, FonteTexto, TamanhoRelatorioRodape, CorTextoSecundario);
    AplicarFonte(QRLabelLegendaRegras.Font, FonteTexto, TamanhoRelatorioRodape, CorTextoSecundario);

    //Sem divergência (18.26 e 18.27, tokens.md 6): quadro com borda CorBorda, título 12 pt Semibold e texto
    //9 pt CorTextoSecundario
    QRShapeVazio.Brush.Color := CorSuperficie;
    QRShapeVazio.Pen.Color   := CorBorda;
    QRShapeVazio.Pen.Style   := psSolid;
    AplicarFonte(QRLabelVazioTitulo.Font, FonteDestaque, TamanhoRelatorioVazio, CorTexto);
    AplicarFonte(QRLabelVazioTexto.Font, FonteTexto, TamanhoRelatorioDados, CorTextoSecundario);
    AplicarFonte(QRLabelVazioRegras.Font, FonteTexto, TamanhoRelatorioRodape, CorTextoSecundario);

    //Rodapé (18.29)
    QRShapeRodape.Brush.Color := CorBorda;
    QRShapeRodape.Pen.Style   := psClear;
    AplicarFonte(QRLabelRodape.Font, FonteTexto, TamanhoRelatorioRodape, CorTextoSecundario);

    //Colunas (tokens.md 6): Nº · Mod. · Data · Item · Nível · Tipo · Campo (o resto) · Valor no XML · Esperado.
    //Título e dado com o mesmo Left/Width e o mesmo alinhamento
    Campo := LarguraUtilRelatorio - (LarguraRelDivNumero + LarguraRelDivModelo + LarguraRelDivData + LarguraRelDivItem +
                                     LarguraRelDivNivel + LarguraRelDivTipo + LarguraRelDivValor + LarguraRelDivEsperado);
    X := 0;
    PosicionarColunaRelatorio([QRLabelNumero, QRDBTextNumero], X, LarguraRelDivNumero, PaddingCelulaRelatorio);
    Inc(X, LarguraRelDivNumero);
    PosicionarColunaRelatorio([QRLabelModelo, QRDBTextModelo], X, LarguraRelDivModelo, PaddingCelulaEstreita);
    Inc(X, LarguraRelDivModelo);
    PosicionarColunaRelatorio([QRLabelData, QRDBTextData], X, LarguraRelDivData, PaddingCelulaEstreita);
    Inc(X, LarguraRelDivData);
    PosicionarColunaRelatorio([QRLabelItem, QRDBTextItem], X, LarguraRelDivItem, PaddingCelulaEstreita);
    Inc(X, LarguraRelDivItem);
    PosicionarColunaRelatorio([QRLabelNivel, QRDBTextNivel], X, LarguraRelDivNivel, PaddingCelulaEstreita);
    Inc(X, LarguraRelDivNivel);
    PosicionarColunaRelatorio([QRLabelTipo, QRDBTextTipo], X, LarguraRelDivTipo, PaddingCelulaRelatorio);
    Inc(X, LarguraRelDivTipo);
    PosicionarColunaRelatorio([QRLabelCampo, QRDBTextCampo], X, Campo, PaddingCelulaRelatorio);
    Inc(X, Campo);
    PosicionarColunaRelatorio([QRLabelValorXML, QRDBTextValorXML], X, LarguraRelDivValor, PaddingCelulaRelatorio);
    Inc(X, LarguraRelDivValor);
    PosicionarColunaRelatorio([QRLabelEsperado, QRDBTextEsperado], X, LarguraRelDivEsperado, PaddingCelulaRelatorio);

    //Total e legendas na largura toda (os dois trechos da contagem vêm de MontarTextos); o quadro "sem
    //divergência" também
    PosicionarColunaRelatorio([QRLabelTotal, QRLabelLegendaNiveis, QRLabelLegendaTipos, QRLabelLegendaFora,
                               QRLabelLegendaRegras], 0, LarguraUtilRelatorio, PaddingCelulaRelatorio);
    PosicionarRelatorio(QRShapeVazio, 0, LarguraUtilRelatorio);
    PosicionarColunaRelatorio([QRLabelVazioTitulo, QRLabelVazioTexto, QRLabelVazioRegras], 0, LarguraUtilRelatorio,
                              PaddingOpcao);

    //Logo à direita do cabeçalho; o texto "ProXML" só aparece se o logo não puder ser desenhado
    PosicionarRelatorio(QRImageLogo, LarguraUtilRelatorio - LarguraLogoRelatorio, LarguraLogoRelatorio);
    DesenharLogoRelatorio(QRImageLogo, QRLabelMarca);
end;

procedure TFormRelatorioDivergencias.MontarTextos;
var
    Resumo       : TResumoRelatorio;
    Periodo      : string;
    Filtro       : Integer;
    Ponto        : string;
    Fim          : Double;
    Espaco       : Double;
    Largura      : Double;
    Conferidas   : Integer;
    ComErro      : Integer;
    ComAlerta    : Integer;
    SemDiverg    : Integer;
    ComDiverg    : Integer;
    TextoRegras  : string;
    Vazio        : Boolean;
begin
    Ponto      := ' ' + #$00B7 + ' ';
    Filtro     := DMConfig.FiltroModelo;
    Conferidas := FTotais.QuantidadeConferidas;
    ComErro    := FTotais.ConferidasComErro;
    ComAlerta  := FTotais.ConferidasComAlerta;
    ComDiverg  := ComErro + ComAlerta;
    SemDiverg  := Conferidas - ComDiverg;
    if SemDiverg < 0 then
        SemDiverg := 0;
    //Período das notas conferidas do filtro (18.12)
    Resumo  := ResumirRelatorio(DMConfig.QryNotasConferidas);
    Periodo := TextoPeriodoRelatorio(Resumo);

    //Linha 1 (18.12/18.13): "Período: … · Modelo: … · {k} notas conferidas · {d} divergências"
    QRLabelRotuloPeriodo.Enabled := Periodo <> '';
    QRLabelPeriodo.Enabled       := Periodo <> '';
    QRLabelPeriodo.Caption       := ' ' + Periodo + Ponto;
    QRLabelModeloFiltro.Caption  := ' ' + TextoModeloRelatorio(Filtro, True) + Ponto;
    QRLabelQuantidade.Caption    := IntToStr(Conferidas);
    if Conferidas = 1 then
        QRLabelNotas.Caption := ' nota conferida' + Ponto
    else
        QRLabelNotas.Caption := ' notas conferidas' + Ponto;
    QRLabelQuantidadeDivergencias.Caption := IntToStr(FDivergencias);
    if FDivergencias = 1 then
        QRLabelDivergencias.Caption := ' divergência'
    else
        QRLabelDivergencias.Caption := ' divergências';
    MontarLinhaRelatorio([QRLabelRotuloPeriodo, QRLabelPeriodo, QRLabelRotuloModelo, QRLabelModeloFiltro,
                          QRLabelQuantidade, QRLabelNotas, QRLabelQuantidadeDivergencias, QRLabelDivergencias], 0);

    //Linha 2 (18.14): "Pasta: {caminho}" numa linha só, cortada no meio antes do logo
    Fim     := MontarLinhaRelatorio([QRLabelRotuloPasta], 0);
    Espaco  := MedirTextoRelatorio(QRLabelPasta.Font, ' ');
    Largura := LarguraUtilRelatorio - LarguraLogoRelatorio - EspacoLogoRelatorio - Fim;
    QRLabelPasta.Caption := ' ' + EncurtarNoMeioRelatorio(QRLabelPasta.Font, FPasta, Largura - Espaco);
    PosicionarRelatorio(QRLabelPasta, Fim, Largura);

    //Continuação (18.28)
    QRLabelContinuacao.Caption        := 'Divergências IBS/CBS' + Ponto + 'Modelo: ' + TextoModeloRelatorio(Filtro, False) +
                                         Ponto + 'continuação';
    QRLabelPeriodoContinuacao.Caption := Periodo;

    //Total (18.21): "Total · {d} divergências em {m} notas"
    if FDivergencias = 1 then
        QRLabelTotal.Caption := 'Total' + Ponto + '1 divergência em ' + QuantidadeNotasRelatorio(ComDiverg)
    else
        QRLabelTotal.Caption := 'Total' + Ponto + IntToStr(FDivergencias) + ' divergências em ' +
                                QuantidadeNotasRelatorio(ComDiverg);

    //Contagem (18.21a): a nota com Erro e Alerta conta só em Erro, como na coluna da grade. Dois trechos na
    //mesma linha: as contagens em Semibold e a observação em cinza (mockup)
    QRLabelContagem.Caption     := 'Notas com Erro: ' + IntToStr(ComErro) + Ponto + 'Notas com Alerta: ' +
                                   IntToStr(ComAlerta) + Ponto + 'Notas sem divergência: ' + IntToStr(SemDiverg);
    QRLabelContagemNota.Caption := Ponto + 'a nota com Erro e Alerta conta só em Erro';

    //Legendas (18.22 a 18.25), com as versões da unit da conferência
    QRLabelLegendaNiveis.Caption := 'Nível 1: conta do item' + Ponto + 'Nível 2: itens × totais' + Ponto +
                                    'Nível 3: base de cálculo' + Ponto + 'Nível 4: alíquota, redução e CST. ' +
                                    'Níveis 1 e 2 são Erro; 3 e 4, Alerta.';
    QRLabelLegendaTipos.Caption  := 'Erro: conta que não fecha com os valores do próprio XML. Alerta: indicação ' +
                                    'para conferir; depende da operação e da regra legal e não afirma que a nota ' +
                                    'está errada.';
    QRLabelLegendaFora.Caption   := 'Não entram: notas sem IBS/CBS e itens sem conferência (monofásico, ' +
                                    'transferência de crédito, ajustes, compra governamental; veja o Resumo). Nos ' +
                                    'itens do Simples Nacional (gTribSN), só os totais e o cClassTrib são conferidos.';
    TextoRegras := 'Regras da NT 2025.002 v' + VERSAO_NT_2025_002 + ', da NT 2026.005 v' + VERSAO_NT_2026_005 +
                   ' (Simples Nacional) e da tabela de cClassTrib v' + VERSAO_TABELA_CCLASSTRIB + '. A conferência ' +
                   'não muda os totais do ProXML.';
    QRLabelLegendaRegras.Caption := TextoRegras;

    //Sem divergência (18.26 e 18.27, decisão P7-9): mensagem no corpo da 1ª página, com a 18.25 logo abaixo
    QRLabelVazioTitulo.Caption := 'Nenhuma divergência de IBS/CBS';
    if Conferidas = 1 then
        QRLabelVazioTexto.Caption := 'A nota com IBS/CBS do filtro foi conferida, sem Erro nem Alerta.'
    else
        QRLabelVazioTexto.Caption := 'As ' + IntToStr(Conferidas) + ' notas com IBS/CBS do filtro foram ' +
                                     'conferidas, sem Erro nem Alerta.';
    QRLabelVazioRegras.Caption := TextoRegras;

    //Um modo ou o outro na faixa do fim: total e legendas, ou o quadro "sem divergência"
    Vazio := FDivergencias = 0;
    QRShapeTotais.Enabled        := not Vazio;
    QRLabelTotal.Enabled         := not Vazio;
    QRLabelContagem.Enabled      := not Vazio;
    QRLabelContagemNota.Enabled  := not Vazio;
    QRLabelLegendaNiveis.Enabled := not Vazio;
    QRLabelLegendaTipos.Enabled  := not Vazio;
    QRLabelLegendaFora.Enabled   := not Vazio;
    QRLabelLegendaRegras.Enabled := not Vazio;
    QRShapeVazio.Enabled         := Vazio;
    QRLabelVazioTitulo.Enabled   := Vazio;
    QRLabelVazioTexto.Enabled    := Vazio;
    QRLabelVazioRegras.Enabled   := Vazio;

    //Os dois trechos da contagem lado a lado, alinhados ao texto do Total
    PosicionarContagem;
end;

procedure TFormRelatorioDivergencias.PosicionarContagem;
const
    //Folga na largura de cada trecho, como em MontarLinhaRelatorio
    Folga = 4;
var
    Trechos : array[0..1] of TQRLabel;
    I       : Integer;
    X       : Double;
    Largura : Double;
begin
    //Contagem (Semibold) e observação (Regular, cinza) lado a lado a partir do texto do Total (D6 da B5). Cada
    //trecho avança pela largura medida com a sua própria fonte. Na visualização e na impressão o QuickReport
    //desenha numa página na resolução da tela, com a fonte arredondada para pixel: o 8 pt Semibold sai mais
    //largo que a medida exata, também a 96 dpi. Ali vale a maior das duas medidas, a do próprio QuickReport
    //(TextWidth, a mesma do FormatLines) em qualquer zoom da visualização. Na exportação (PDF) o texto usa a
    //medida exata. Assim a observação começa logo depois da contagem, sem cobri-la
    Trechos[0] := QRLabelContagem;
    Trechos[1] := QRLabelContagemNota;
    X := PaddingCelulaRelatorio;
    for I := Low(Trechos) to High(Trechos) do
    begin
        if not Trechos[I].Enabled then
            Continue;
        Largura := MedirTextoRelatorio(Trechos[I].Font, Trechos[I].Caption);
        if not QuickDivergencias.Exporting then
            Largura := Max(Largura, MulDiv(QuickDivergencias.TextWidth(Trechos[I].Font, Trechos[I].Caption),
                                           Trechos[I].Zoom, 100) * 96 / Screen.PixelsPerInch);
        PosicionarRelatorio(Trechos[I], X, Largura + Folga);
        X := X + Largura;
    end;
end;

procedure TFormRelatorioDivergencias.EmpilharLegendas;
var
    Topo: Double;

    procedure PosicionarNaAltura(Controle: TQRPrintable; const Y, Altura: Double);
    var
        Unidade: TQRUnit;
    begin
        //Pixels a 96 dpi convertidos para milímetros, como em PosicionarRelatorio
        Unidade := Controle.Size.Units;
        Controle.Size.Units := MM;
        try
            Controle.Size.Top    := Y * 25.4 / 96;
            Controle.Size.Height := Altura * 25.4 / 96;
        finally
            Controle.Size.Units := Unidade;
        end;
    end;

    function LinhasDoRotulo(Rotulo: TQRLabel): Integer;
    var
        Expandida: Extended;
        Linha    : Integer;
    begin
        //A mesma quebra que o QuickReport faz ao imprimir (TQRCustomLabel.FormatLines, na largura atual da
        //caixa e com a fonte na escala do sistema): a legenda curta fica com 1 linha e a longa com as que precisar
        Rotulo.GetExpandedHeight(Expandida);
        Linha := MulDiv(QuickDivergencias.TextHeight(Rotulo.Font, 'W'), Rotulo.Zoom, 100);
        if Linha <= 0 then
            Result := 1
        else
            Result := Max(1, Round(Expandida / Linha));
    end;

    procedure Empilhar(Rotulo: TQRLabel);
    var
        Altura: Double;
    begin
        Altura := LinhasDoRotulo(Rotulo) * AlturaLinhaLegendaRelatorio;
        PosicionarNaAltura(Rotulo, Topo, Altura);
        Topo := Topo + Altura + EspacoLegendaRelatorio;
    end;

var
    Unidade: TQRUnit;
begin
    //Contagem e legendas 18.22 a 18.25 uma embaixo da outra com o mesmo espaço (D4 da B4): antes cada legenda
    //tinha altura fixa de 2 linhas e a 18.22, que cabe em 1, deixava uma linha vazia. Depois de
    //FolgaDeEscalaRelatorio, que muda a largura das caixas fora de 100%. Sem divergência, a faixa fica como no
    //.dfm (quadro 18.26/18.27)
    if FDivergencias = 0 then
        Exit;

    Unidade := QRLabelContagem.Size.Units;
    QRLabelContagem.Size.Units := MM;
    try
        Topo := QRLabelContagem.Size.Top * 96 / 25.4;
    finally
        QRLabelContagem.Size.Units := Unidade;
    end;

    //Contagem: uma linha, os dois trechos no mesmo Top
    PosicionarNaAltura(QRLabelContagem, Topo, AlturaLinhaLegendaRelatorio);
    PosicionarNaAltura(QRLabelContagemNota, Topo, AlturaLinhaLegendaRelatorio);
    Topo := Topo + AlturaLinhaLegendaRelatorio + EspacoLegendaRelatorio;

    Empilhar(QRLabelLegendaNiveis);
    Empilhar(QRLabelLegendaTipos);
    Empilhar(QRLabelLegendaFora);
    Empilhar(QRLabelLegendaRegras);

    //Faixa do Total na altura do conteúdo, com meio passo embaixo (como no .dfm)
    Topo := Topo - EspacoLegendaRelatorio + EspacoMeio;
    Unidade := QRBandTotais.Size.Units;
    QRBandTotais.Size.Units := MM;
    try
        QRBandTotais.Size.Height := Topo * 25.4 / 96;
    finally
        QRBandTotais.Size.Units := Unidade;
    end;
end;

function TFormRelatorioDivergencias.GerarRelatorio: Boolean;
begin
    //Notas conferidas e divergências do filtro de modelo (as duas queries filtram pelo DMConfig.FiltroModelo)
    DMConfig.QryNotasConferidas.Active := False;
    DMConfig.QryDivergencias.Active    := False;

    DMConfig.QryNotasConferidas.Active := True;
    Result := not DMConfig.QryNotasConferidas.IsEmpty;
    if not Result then
    begin
        DMConfig.QryNotasConferidas.Active := False;
        Exit;
    end;

    DMConfig.QryDivergencias.Active := True;
    //Contagem percorrendo a query (o RecordCount do FireDAC pode não ter todas as linhas ainda)
    FDivergencias := ResumirRelatorio(DMConfig.QryDivergencias).Quantidade;

    //Data e hora do rodapé: uma só para todas as páginas
    FGeradoEm := Now;
    MontarTextos;
    FolgaDeEscalaRelatorio(Self);
    EmpilharLegendas;
    QRBandTitulo.BeforePrint := QRBandTituloBeforePrint;
    QRBandTotais.BeforePrint := QRBandTotaisBeforePrint;

    //"Página X de Y": uma passada para contar as páginas e depois a visualização
    FTotalPaginas := 0;
    FTotalPaginas := ContarPaginasRelatorio(QuickDivergencias);
    QuickDivergencias.Preview;
end;

procedure TFormRelatorioDivergencias.QuickDivergenciasBeforePrint(Sender: TCustomQuickRep; var PrintReport: Boolean);
begin
    //Cada montagem (contagem, visualização, impressão ou exportação) recomeça a zebra
    FLinhaNaPagina := 0;
end;

procedure TFormRelatorioDivergencias.QRBandTituloBeforePrint(Sender: TQRCustomBand; var PrintBand: Boolean);
begin
    LinhaCabecalhoNaEscala(QuickDivergencias, [QRLabelRotuloPeriodo, QRLabelPeriodo, QRLabelRotuloModelo,
                                               QRLabelModeloFiltro, QRLabelQuantidade, QRLabelNotas,
                                               QRLabelQuantidadeDivergencias, QRLabelDivergencias]);
    LinhaCabecalhoNaEscala(QuickDivergencias, [QRLabelRotuloPasta, QRLabelPasta]);
end;

procedure TFormRelatorioDivergencias.QRBandTotaisBeforePrint(Sender: TQRCustomBand; var PrintBand: Boolean);
begin
    //Os dois trechos da contagem (Semibold e cinza) de novo, agora sabendo se é visualização/impressão ou PDF
    PosicionarContagem;
end;

procedure TFormRelatorioDivergencias.QRBandColunasBeforePrint(Sender: TQRCustomBand; var PrintBand: Boolean);
begin
    //Sem divergência não há linhas: os títulos das colunas não aparecem (mockup, estado "Sem divergência").
    //Nem na página que só recebe o Total e as legendas (D5 da B4): o QuickReport repete os títulos no começo de
    //cada página, e o Total só passa para a página nova depois da última linha, com a consulta já no fim (Eof).
    //Quando a página nova começa por uma linha que não coube, a consulta está nela: os títulos saem
    PrintBand := (FDivergencias > 0) and (not DMConfig.QryDivergencias.Eof);
end;

procedure TFormRelatorioDivergencias.QRBandDetalheBeforePrint(Sender: TQRCustomBand; var PrintBand: Boolean);
begin
    PintarLinhaRelatorio(QuickDivergencias, Sender, FLinhaNaPagina);
    //18.18: "Erro" em Semibold, sem cor (impressão monocromática)
    if DMConfig.QryDivergencias.FieldByName('TIPO').AsString = TextoSituacaoIBSCBS(scErro) then
        QRDBTextTipo.Font.Name := FonteDestaque
    else
        QRDBTextTipo.Font.Name := FonteTexto;
end;

procedure TFormRelatorioDivergencias.QRBandRodapeBeforePrint(Sender: TQRCustomBand; var PrintBand: Boolean);
begin
    QRLabelRodape.Caption := TextoRodapeRelatorio(FVersao, FGeradoEm, QuickDivergencias.PageNumber, FTotalPaginas);
end;

procedure TFormRelatorioDivergencias.ItemPrint(sender: TObject; var Value: string);
begin
    //18.16: item 0 (ITEM_TOTAL_IBSCBS) = divergência dos totais da nota (nível 2)
    if Trim(Value) = IntToStr(ITEM_TOTAL_IBSCBS) then
        Value := 'Total';
end;

procedure TFormRelatorioDivergencias.SetTotais(const Totais: TTotaisNotas);
begin
    FTotais := Totais;
end;

procedure TFormRelatorioDivergencias.SetPasta(const Pasta: string);
begin
    FPasta := Trim(Pasta);
end;

procedure TFormRelatorioDivergencias.SetVersao(const Versao: string);
begin
    FVersao := Trim(Versao);
end;

end.
