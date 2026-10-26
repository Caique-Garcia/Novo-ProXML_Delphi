unit ProXML.FormRelatorios;

{ Relatório de Notas no QuickReport (Plano 4, etapa 4.8; mockup docs/ui/mockups/relatorio-a4.html,
  tokens.md seção 6, glossário seção 9).

  Também traz as funções usadas pelos dois relatórios impressos (Notas e IBS/CBS): valores do banco
  formatados na impressão (PD-5), período, modelo, cabeçalho com trechos em Semibold, logo, zebra,
  rodapé e a contagem de páginas ("Página X de Y").

  Bandas: Title (cabeçalho completo, só na 1ª página) · PageHeader (linha de continuação, da 2ª página
  em diante) · ColumnHeader (títulos das colunas, em toda página) · Detail (linha de 20 px com zebra) ·
  Summary (total alinhado às colunas e legenda) · PageFooter (rodapé). Os totais vêm da memória
  (FormPrincipal.Totais, com o filtro de modelo), não de SUM no banco. }

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Types,
  System.UITypes,
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
  TFormRelatorios = class(TForm)
    QuickNotas: TQuickRep;
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
    QRLabelChave: TQRLabel;
    QRLabelValor: TQRLabel;
    QRLabelBaseICMS: TQRLabel;
    QRLabelICMS: TQRLabel;
    QRShapeColunas: TQRShape;
    QRBandDetalhe: TQRBand;
    QRDBTextNumero: TQRDBText;
    QRDBTextModelo: TQRDBText;
    QRDBTextData: TQRDBText;
    QRDBTextChave: TQRDBText;
    QRDBTextValor: TQRDBText;
    QRDBTextBaseICMS: TQRDBText;
    QRDBTextICMS: TQRDBText;
    QRBandTotais: TQRBand;
    QRShapeTotais: TQRShape;
    QRLabelTotal: TQRLabel;
    QRLabelTotalValor: TQRLabel;
    QRLabelTotalBaseICMS: TQRLabel;
    QRLabelTotalICMS: TQRLabel;
    QRLabelLegenda: TQRLabel;
    QRBandRodape: TQRBand;
    QRShapeRodape: TQRShape;
    QRLabelRodape: TQRLabel;
    procedure FormCreate(Sender: TObject);
    procedure QuickNotasBeforePrint(Sender: TCustomQuickRep; var PrintReport: Boolean);
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
    //Totais da memória (FormPrincipal.Totais), já com o filtro de modelo: quantidade e somas
    procedure SetTotais(const Totais: TTotaisNotas);
    //Pasta das notas carregadas (linha "Pasta:" do cabeçalho)
    procedure SetPasta(const Pasta: string);
    //Versão do executável para o rodapé (ex.: "1.1.0"); vazio = sem versão
    procedure SetVersao(const Versao: string);
    procedure GerarRelatorio();
  end;

  //Resumo das notas que um relatório lista (a própria query, depois de aberta)
  TResumoRelatorio = record
    Quantidade   : Integer;
    Quantidade55 : Integer;
    Quantidade65 : Integer;
    DataMenor    : Integer;   //aaaammdd; 0 = nenhuma data válida
    DataMaior    : Integer;
  end;

//--- Funções dos dois relatórios impressos (Notas e IBS/CBS), etapa 4.8 ---------------------

//PD-5: os valores da tabela nf estão gravados como texto (FormatFloat('0.00') com o separador decimal
//do Windows: "1234,56" ou "1234.56"). Na impressão viram "1.234,56" (pt-BR explícito), aceitando vírgula
//ou ponto. Texto que não é número sai como veio
function TextoValorRelatorio(const Texto: string): string;

//Contagem com singular e plural: "1 nota", "128 notas"
function QuantidadeNotasRelatorio(const Quantidade: Integer): string;

//Percorre as notas que o relatório lista (DataSet aberto) e devolve quantidades e período
function ResumirRelatorio(DataSet: TDataSet): TResumoRelatorio;

//Período das notas: "01/10/2026 a 31/10/2026"; data única quando todas são do mesmo dia; vazio sem
//nenhuma data válida
function TextoPeriodoRelatorio(const Resumo: TResumoRelatorio): string;

//Modelo do filtro (DMConfig.FiltroModelo): completo no cabeçalho ("Todos (NF-e 55 e NFC-e 65)") e
//curto na linha de continuação ("Todos")
function TextoModeloRelatorio(const Filtro: Integer; const Completo: Boolean): string;

//Largura do texto em pixels a 96 dpi, medida numa escala 10 vezes maior (sem o arredondamento das
//fontes pequenas na tela)
function MedirTextoRelatorio(Fonte: TFont; const Texto: string): Double;

//Texto longo cortado no meio com "…" para caber na largura (pixels a 96 dpi)
function EncurtarNoMeioRelatorio(Fonte: TFont; const Texto: string; const Largura: Double): string;

//Posição horizontal em pixels a 96 dpi, gravada em milímetros (não depende da escala da tela)
procedure PosicionarRelatorio(Controle: TQRPrintable; const Esquerda, Largura: Double);

//Mesma coluna para título, dado e total: o mesmo Left/Width (padding dos dois lados)
procedure PosicionarColunaRelatorio(const Controles: array of TQRPrintable; const Esquerda, Largura,
  Padding: Integer);

//Trechos de uma linha do cabeçalho lado a lado (rótulos em Semibold, valores em cinza), a partir de
//Esquerda. Trechos desabilitados ficam de fora. Devolve onde a linha termina
function MontarLinhaRelatorio(const Trechos: array of TQRLabel; const Esquerda: Double): Double;

//Logo claro (D7 revista) desenhado pelo Skia numa imagem de ~600 dpi; se falhar, o texto "ProXML"
procedure DesenharLogoRelatorio(Imagem: TQRImage; Marca: TQRLabel);

//Zebra: alterna a cor da linha; a 1ª linha de cada página é branca
procedure PintarLinhaRelatorio(Relatorio: TCustomQuickRep; Banda: TQRCustomBand; var LinhaNaPagina: Integer);

//Rodapé (glossário 9.19 e 10.17): "Gerado pelo ProXML v1.1.0 · dd/mm/aaaa hh:mm · Página X de Y"
function TextoRodapeRelatorio(const Versao: string; const GeradoEm: TDateTime; const Pagina,
  TotalPaginas: Integer): string;

//Prepara o relatório uma vez só para contar as páginas (o QuickReport só sabe o total no fim).
//Devolve 0 se não conseguir
function ContarPaginasRelatorio(Relatorio: TQuickRep): Integer;

var
  FormRelatorios: TFormRelatorios;

implementation

uses
  Skia,
  Skia.Vcl,
  ProXML.Tema,
  ProXML.Icones;

{$R *.dfm}

{ Funções dos dois relatórios }

function TextoValorRelatorio(const Texto: string): string;
var
    Original : string;
    Limpo    : string;
    Formato  : TFormatSettings;
    Valor    : Double;
    Decimal  : Integer;
    I        : Integer;
begin
    Original := Trim(Texto);
    Result   := Original;
    if Original = '' then
        Exit;

    //O último separador ("," ou ".") é o decimal; outros que existirem são de milhar e saem.
    //O banco sempre grava com duas casas ("0.00"), então "1.234" sem casas não acontece
    Decimal := 0;
    for I := Length(Original) downto 1 do
        if (Original[I] = ',') or (Original[I] = '.') then
        begin
            Decimal := I;
            Break;
        end;

    Limpo := '';
    for I := 1 to Length(Original) do
    begin
        if (Original[I] = ',') or (Original[I] = '.') then
        begin
            if I = Decimal then
                Limpo := Limpo + '.';
        end
        else
            Limpo := Limpo + Original[I];
    end;

    //Leitura com ponto decimal fixo (regra 4): não depende da configuração regional do Windows
    Formato := TFormatSettings.Create;
    Formato.DecimalSeparator := '.';
    if TryStrToFloat(Limpo, Valor, Formato) then
        Result := FormatarValor(Valor);
end;

function QuantidadeNotasRelatorio(const Quantidade: Integer): string;
begin
    if Quantidade = 1 then
        Result := '1 nota'
    else
        Result := IntToStr(Quantidade) + ' notas';
end;

function DataDoRelatorio(const Texto: string): Integer;
var
    Dia, Mes, Ano: Integer;
begin
    //Data gravada no banco como "dd/mm/aaaa" (FormatarDataNota) -> aaaammdd; inválida (ex.: "00/00/0000") = 0
    Result := 0;
    if (Length(Texto) < 10) or (Texto[3] <> '/') or (Texto[6] <> '/') then
        Exit;
    if not (TryStrToInt(Copy(Texto, 1, 2), Dia) and TryStrToInt(Copy(Texto, 4, 2), Mes) and
            TryStrToInt(Copy(Texto, 7, 4), Ano)) then
        Exit;
    if (Dia < 1) or (Dia > 31) or (Mes < 1) or (Mes > 12) or (Ano < 1) then
        Exit;
    Result := Ano * 10000 + Mes * 100 + Dia;
end;

function ResumirRelatorio(DataSet: TDataSet): TResumoRelatorio;
var
    Data: Integer;
begin
    Result.Quantidade   := 0;
    Result.Quantidade55 := 0;
    Result.Quantidade65 := 0;
    Result.DataMenor    := 0;
    Result.DataMaior    := 0;

    if (DataSet = nil) or (not DataSet.Active) then
        Exit;

    //Mesma ordem e mesmo filtro que o relatório vai imprimir (a query do próprio relatório)
    DataSet.DisableControls;
    try
        DataSet.First;
        while not DataSet.Eof do
        begin
            Inc(Result.Quantidade);
            case DataSet.FieldByName('MODELO').AsInteger of
                FILTRO_MODELO_NFE  : Inc(Result.Quantidade55);
                FILTRO_MODELO_NFCE : Inc(Result.Quantidade65);
            end;

            Data := DataDoRelatorio(Trim(DataSet.FieldByName('DATA').AsString));
            if Data > 0 then
            begin
                if (Result.DataMenor = 0) or (Data < Result.DataMenor) then
                    Result.DataMenor := Data;
                if Data > Result.DataMaior then
                    Result.DataMaior := Data;
            end;

            DataSet.Next;
        end;
        DataSet.First;
    finally
        DataSet.EnableControls;
    end;
end;

function TextoPeriodoRelatorio(const Resumo: TResumoRelatorio): string;

    function DataDaOrdem(const Ordem: Integer): string;
    begin
        //aaaammdd -> dd/mm/aaaa
        Result := Format('%.2d/%.2d/%.4d', [Ordem mod 100, (Ordem div 100) mod 100, Ordem div 10000]);
    end;

begin
    if Resumo.DataMenor = 0 then
        Result := ''
    else if Resumo.DataMenor = Resumo.DataMaior then
        Result := DataDaOrdem(Resumo.DataMenor)
    else
        Result := DataDaOrdem(Resumo.DataMenor) + ' a ' + DataDaOrdem(Resumo.DataMaior);
end;

function TextoModeloRelatorio(const Filtro: Integer; const Completo: Boolean): string;
begin
    case Filtro of
        FILTRO_MODELO_NFE  : Result := 'NF-e 55';
        FILTRO_MODELO_NFCE : Result := 'NFC-e 65';
    else
        if Completo then
            Result := 'Todos (NF-e 55 e NFC-e 65)'
        else
            Result := 'Todos';
    end;
end;

function MedirTextoRelatorio(Fonte: TFont; const Texto: string): Double;
var
    Medida: TBitmap;
begin
    Medida := TBitmap.Create;
    try
        Medida.Canvas.Font.Name  := Fonte.Name;
        Medida.Canvas.Font.Style := Fonte.Style;
        //Altura em pixels de 960 dpi (10 x 96): a medida não sofre o arredondamento da fonte pequena
        Medida.Canvas.Font.Height := -MulDiv(Abs(Fonte.Size), 960, 72);
        Result := Medida.Canvas.TextWidth(Texto) / 10;
    finally
        Medida.Free;
    end;
end;

function EncurtarNoMeioRelatorio(Fonte: TFont; const Texto: string; const Largura: Double): string;
const
    //Folga de 5%: o QuickReport desenha o texto um pouco mais largo que a medida (fonte ajustada à
    //tela de referência) e corta o que passar da largura do rótulo (o fim do caminho sumia)
    Folga = 1.05;
var
    Esquerda  : Integer;
    Direita   : Integer;
    Tentativa : string;
begin
    //Mantém o começo e o fim do caminho (a unidade e a pasta final) e põe "…" no lugar do meio
    Result := Texto;
    if (Texto = '') or (MedirTextoRelatorio(Fonte, Texto) * Folga <= Largura) then
        Exit;

    Esquerda := Length(Texto) div 2;
    Direita  := Length(Texto) - Esquerda;
    while (Esquerda > 0) or (Direita > 0) do
    begin
        if Esquerda >= Direita then
            Dec(Esquerda)
        else
            Dec(Direita);
        Tentativa := Copy(Texto, 1, Esquerda) + #$2026 + Copy(Texto, Length(Texto) - Direita + 1, Direita);
        if MedirTextoRelatorio(Fonte, Tentativa) * Folga <= Largura then
            Exit(Tentativa);
    end;
    Result := #$2026;
end;

procedure PosicionarRelatorio(Controle: TQRPrintable; const Esquerda, Largura: Double);
var
    Unidade: TQRUnit;
begin
    Unidade := Controle.Size.Units;
    Controle.Size.Units := MM;
    try
        Controle.Size.Left  := Esquerda * 25.4 / 96;
        Controle.Size.Width := Largura * 25.4 / 96;
    finally
        Controle.Size.Units := Unidade;
    end;
end;

procedure PosicionarColunaRelatorio(const Controles: array of TQRPrintable; const Esquerda, Largura,
  Padding: Integer);
var
    I: Integer;
begin
    for I := Low(Controles) to High(Controles) do
        PosicionarRelatorio(Controles[I], Esquerda + Padding, Largura - 2 * Padding);
end;

function MontarLinhaRelatorio(const Trechos: array of TQRLabel; const Esquerda: Double): Double;
const
    //Folga na largura de cada trecho para a última letra nunca ser cortada (o próximo trecho começa
    //no fim do texto, não no fim da folga: os rótulos são transparentes)
    Folga = 4;
var
    I       : Integer;
    Largura : Double;
begin
    Result := Esquerda;
    for I := Low(Trechos) to High(Trechos) do
    begin
        if not Trechos[I].Enabled then
            Continue;
        Largura := MedirTextoRelatorio(Trechos[I].Font, Trechos[I].Caption);
        PosicionarRelatorio(Trechos[I], Result, Largura + Folga);
        Result := Result + Largura;
    end;
end;

procedure DesenharLogoRelatorio(Imagem: TQRImage; Marca: TQRLabel);
var
    Pincel  : TSkSvgBrush;
    Bitmap  : TBitmap;
    Largura : Integer;
    Altura  : Integer;
begin
    //Logo vetorial claro desenhado numa imagem de ~600 dpi no tamanho do cabeçalho (98 x 20 px a 96 dpi):
    //fica nítido no papel e no PDF. Sem o Skia (ou com erro), vale o texto "ProXML" em CorMarinho
    Pincel := nil;
    Bitmap := nil;
    try
        try
            Largura := MulDiv(LarguraLogoRelatorio, ResolucaoLogoRelatorio, 96);
            Altura  := MulDiv(AlturaLogoRelatorio, ResolucaoLogoRelatorio, 96);

            Pincel := TSkSvgBrush.Create;
            Pincel.Source := LogoClaro;

            Bitmap := TBitmap.Create;
            Bitmap.SetSize(Largura, Altura);
            Bitmap.SkiaDraw(
                procedure(const ACanvas: ISkCanvas)
                begin
                    ACanvas.Clear(CorAlpha(CorSuperficie));
                    Pincel.Render(ACanvas, RectF(0, 0, Largura, Altura), 1);
                end);

            //Fundo opaco: a imagem vai para o relatório como bitmap comum de 24 bits (sem canal alfa,
            //que algumas impressoras e o PDF não tratam)
            Bitmap.AlphaFormat := afIgnored;
            Bitmap.PixelFormat := pf24bit;

            Imagem.Picture.Assign(Bitmap);
            Imagem.Stretch := True;
            Imagem.Enabled := True;
            Marca.Enabled  := False;
        except
            Imagem.Enabled := False;
            Marca.Enabled  := True;
        end;
    finally
        Bitmap.Free;
        Pincel.Free;
    end;
end;

procedure PintarLinhaRelatorio(Relatorio: TCustomQuickRep; Banda: TQRCustomBand; var LinhaNaPagina: Integer);
begin
    //O BeforePrint vem antes da quebra de página: a linha que não cabe vai para a próxima página e é a
    //1ª dela (a zebra recomeça em cada página, como no mockup). Linhas pares em CorZebra
    if Relatorio.AvailableSpace < Round(Banda.Size.Length) then
        LinhaNaPagina := 1
    else
        Inc(LinhaNaPagina);

    if Odd(LinhaNaPagina) then
        Banda.Color := CorSuperficie
    else
        Banda.Color := CorZebra;
end;

function TextoRodapeRelatorio(const Versao: string; const GeradoEm: TDateTime; const Pagina,
  TotalPaginas: Integer): string;
begin
    Result := 'Gerado pelo ProXML';
    if Versao <> '' then
        Result := Result + ' v' + Versao;
    Result := Result + ' ' + #$00B7 + ' ' + FormatDateTime('dd/mm/yyyy hh:nn', GeradoEm, FormatoPtBR) +
              ' ' + #$00B7 + ' Página ' + IntToStr(Pagina);
    if TotalPaginas > 0 then
        Result := Result + ' de ' + IntToStr(TotalPaginas);
end;

function ContarPaginasRelatorio(Relatorio: TQuickRep): Integer;
begin
    //Primeira passada só para contar: Prepare monta as páginas sem mostrar nada; o QRPrinter dessa
    //passada é descartado e a visualização monta tudo de novo, já sabendo o total
    Result := 0;
    try
        Relatorio.Prepare;
        try
            if Relatorio.QRPrinter <> nil then
                Result := Relatorio.QRPrinter.PageCount;
        finally
            Relatorio.QRPrinter.Free;
            Relatorio.QRPrinter := nil;
        end;
    except
        //Sem a contagem o rodapé mostra só "Página X" (tokens.md 6); o erro de verdade, se houver,
        //aparece na visualização
        Result := 0;
    end;
end;

{ TFormRelatorios }

procedure TFormRelatorios.FormCreate(Sender: TObject);
begin
    AplicarVisual;
end;

procedure TFormRelatorios.AplicarVisual;
var
    X     : Integer;
    Chave : Integer;
begin
    //Fontes e cores só do tema (Segoe UI; nada de Courier). Legível em impressora monocromática:
    //só cinzas claros e marinho
    QuickNotas.Font.Name := FonteTexto;
    QRBandTitulo.Color      := CorSuperficie;
    QRBandContinuacao.Color := CorSuperficie;
    QRBandColunas.Color     := CorFundo;
    QRBandDetalhe.Color     := CorSuperficie;
    QRBandTotais.Color      := CorSuperficie;
    QRBandRodape.Color      := CorSuperficie;

    //Cabeçalho da 1ª página: título 16 pt Semibold; rótulos em Semibold e valores em cinza (9 pt)
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

    //Títulos das colunas (9 pt Semibold sobre CorFundo, linha CorBordaCampo) e dados (9 pt)
    AplicarFonte(QRLabelNumero.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelModelo.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelData.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelChave.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelValor.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelBaseICMS.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelICMS.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    QRShapeColunas.Brush.Color := CorBordaCampo;
    QRShapeColunas.Pen.Style   := psClear;
    AplicarFonte(QRDBTextNumero.Font, FonteTexto, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRDBTextModelo.Font, FonteTexto, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRDBTextData.Font, FonteTexto, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRDBTextChave.Font, FonteTexto, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRDBTextValor.Font, FonteTexto, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRDBTextBaseICMS.Font, FonteTexto, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRDBTextICMS.Font, FonteTexto, TamanhoRelatorioDados, CorTexto);

    //Total (9 pt Semibold, linha de 2 px CorMarinho) e legenda (8 pt cinza)
    QRShapeTotais.Brush.Color := CorMarinho;
    QRShapeTotais.Pen.Style   := psClear;
    AplicarFonte(QRLabelTotal.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelTotalValor.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelTotalBaseICMS.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelTotalICMS.Font, FonteDestaque, TamanhoRelatorioDados, CorTexto);
    AplicarFonte(QRLabelLegenda.Font, FonteTexto, TamanhoRelatorioRodape, CorTextoSecundario);

    //Rodapé (8 pt cinza, linha de 1 px CorBorda)
    QRShapeRodape.Brush.Color := CorBorda;
    QRShapeRodape.Pen.Style   := psClear;
    AplicarFonte(QRLabelRodape.Font, FonteTexto, TamanhoRelatorioRodape, CorTextoSecundario);

    //Colunas (tokens.md 6): título, dado e total com o mesmo Left/Width e o mesmo alinhamento (R1).
    //Nº · Mod. · Data · Chave (o resto, no mínimo 270) · Valor · Base ICMS · ICMS
    Chave := LarguraUtilRelatorio - (LarguraRelNumero + LarguraRelModelo + LarguraRelData + LarguraRelValor +
                                     LarguraRelBaseICMS + LarguraRelICMS);
    X := 0;
    PosicionarColunaRelatorio([QRLabelNumero, QRDBTextNumero], X, LarguraRelNumero, PaddingCelulaRelatorio);
    Inc(X, LarguraRelNumero);
    PosicionarColunaRelatorio([QRLabelModelo, QRDBTextModelo], X, LarguraRelModelo, PaddingCelulaEstreita);
    Inc(X, LarguraRelModelo);
    PosicionarColunaRelatorio([QRLabelData, QRDBTextData], X, LarguraRelData, PaddingCelulaEstreita);
    Inc(X, LarguraRelData);
    PosicionarColunaRelatorio([QRLabelChave, QRDBTextChave], X, Chave, PaddingCelulaRelatorio);
    Inc(X, Chave);
    //"Total · n notas" ocupa as colunas antes do Valor (D8)
    PosicionarColunaRelatorio([QRLabelTotal], 0, X, PaddingCelulaRelatorio);
    PosicionarColunaRelatorio([QRLabelValor, QRDBTextValor, QRLabelTotalValor], X, LarguraRelValor,
                              PaddingCelulaRelatorio);
    Inc(X, LarguraRelValor);
    PosicionarColunaRelatorio([QRLabelBaseICMS, QRDBTextBaseICMS, QRLabelTotalBaseICMS], X, LarguraRelBaseICMS,
                              PaddingCelulaRelatorio);
    Inc(X, LarguraRelBaseICMS);
    PosicionarColunaRelatorio([QRLabelICMS, QRDBTextICMS, QRLabelTotalICMS], X, LarguraRelICMS,
                              PaddingCelulaRelatorio);
    PosicionarColunaRelatorio([QRLabelLegenda], 0, LarguraUtilRelatorio, PaddingCelulaRelatorio);

    //Logo à direita do cabeçalho; o texto "ProXML" só aparece se o logo não puder ser desenhado
    PosicionarRelatorio(QRImageLogo, LarguraUtilRelatorio - LarguraLogoRelatorio, LarguraLogoRelatorio);
    DesenharLogoRelatorio(QRImageLogo, QRLabelMarca);
end;

procedure TFormRelatorios.MontarTextos;
var
    Resumo   : TResumoRelatorio;
    Periodo  : string;
    Filtro   : Integer;
    Ponto    : string;
    Fim      : Double;
    Espaco   : Double;
    Largura  : Double;
begin
    Ponto  := ' ' + #$00B7 + ' ';
    Filtro := DMConfig.FiltroModelo;
    //Período e quantidade de cada modelo vêm das notas que o relatório lista
    Resumo  := ResumirRelatorio(DMConfig.QryNotas);
    Periodo := TextoPeriodoRelatorio(Resumo);

    //Linha 1 (9.3/9.4): "Período: … · Modelo: … · {n} notas" (sem data válida, o período fica de fora)
    QRLabelRotuloPeriodo.Enabled := Periodo <> '';
    QRLabelPeriodo.Enabled       := Periodo <> '';
    QRLabelPeriodo.Caption       := ' ' + Periodo + Ponto;
    QRLabelModeloFiltro.Caption  := ' ' + TextoModeloRelatorio(Filtro, True) + Ponto;
    QRLabelQuantidade.Caption    := IntToStr(FTotais.Quantidade);
    if FTotais.Quantidade = 1 then
        QRLabelNotas.Caption := ' nota'
    else
        QRLabelNotas.Caption := ' notas';
    MontarLinhaRelatorio([QRLabelRotuloPeriodo, QRLabelPeriodo, QRLabelRotuloModelo, QRLabelModeloFiltro,
                          QRLabelQuantidade, QRLabelNotas], 0);

    //Linha 2 (9.6): "Pasta: {caminho}" numa linha só, cortada no meio antes do logo
    Fim     := MontarLinhaRelatorio([QRLabelRotuloPasta], 0);
    Espaco  := MedirTextoRelatorio(QRLabelPasta.Font, ' ');
    Largura := LarguraUtilRelatorio - LarguraLogoRelatorio - EspacoLogoRelatorio - Fim;
    QRLabelPasta.Caption := ' ' + EncurtarNoMeioRelatorio(QRLabelPasta.Font, FPasta, Largura - Espaco);
    PosicionarRelatorio(QRLabelPasta, Fim, Largura);

    //Continuação (9.18): modelo curto e o período à direita
    QRLabelContinuacao.Caption        := 'Relatório de Notas' + Ponto + 'Modelo: ' + TextoModeloRelatorio(Filtro, False) +
                                         Ponto + 'continuação';
    QRLabelPeriodoContinuacao.Caption := Periodo;

    //Total (9.14 a 9.16, D8): valores da memória, alinhados às colunas
    QRLabelTotal.Caption         := 'Total' + Ponto + QuantidadeNotasRelatorio(FTotais.Quantidade);
    QRLabelTotalValor.Caption    := FormatarValor(FTotais.ValorTotal);
    QRLabelTotalBaseICMS.Caption := FormatarValor(FTotais.BaseICMS);
    QRLabelTotalICMS.Caption     := FormatarValor(FTotais.ValorICMS);

    //Legenda (9.17): os dois modelos só no filtro Todos
    case Filtro of
        FILTRO_MODELO_NFE  : QRLabelLegenda.Caption := 'NF-e 55: ' + QuantidadeNotasRelatorio(Resumo.Quantidade55);
        FILTRO_MODELO_NFCE : QRLabelLegenda.Caption := 'NFC-e 65: ' + QuantidadeNotasRelatorio(Resumo.Quantidade65);
    else
        QRLabelLegenda.Caption := 'NF-e 55: ' + QuantidadeNotasRelatorio(Resumo.Quantidade55) + Ponto +
                                  'NFC-e 65: ' + QuantidadeNotasRelatorio(Resumo.Quantidade65);
    end;
    QRLabelLegenda.Caption := QRLabelLegenda.Caption + Ponto + 'notas não autorizadas não entram no relatório';
end;

procedure TFormRelatorios.GerarRelatorio;
begin
    //Gera o relatório de notas
    DMConfig.QryNotas.Active := False;

    DMConfig.QryNotas.Active := True;

    if DMConfig.QryNotas.IsEmpty then
        //Glossário 8.14: aparece como motivo da caixa 8.13
        raise Exception.Create('Nenhuma nota para o relatório.');

    //Data e hora do rodapé: uma só para todas as páginas
    FGeradoEm := Now;
    MontarTextos;

    //"Página X de Y": uma passada para contar as páginas e depois a visualização
    FTotalPaginas := 0;
    FTotalPaginas := ContarPaginasRelatorio(QuickNotas);
    QuickNotas.Preview;
end;

procedure TFormRelatorios.QuickNotasBeforePrint(Sender: TCustomQuickRep; var PrintReport: Boolean);
begin
    //Cada montagem (contagem, visualização, impressão ou exportação) recomeça a zebra
    FLinhaNaPagina := 0;
end;

procedure TFormRelatorios.QRBandDetalheBeforePrint(Sender: TQRCustomBand; var PrintBand: Boolean);
begin
    PintarLinhaRelatorio(QuickNotas, Sender, FLinhaNaPagina);
end;

procedure TFormRelatorios.QRBandRodapeBeforePrint(Sender: TQRCustomBand; var PrintBand: Boolean);
begin
    QRLabelRodape.Caption := TextoRodapeRelatorio(FVersao, FGeradoEm, QuickNotas.PageNumber, FTotalPaginas);
end;

procedure TFormRelatorios.ValorPrint(sender: TObject; var Value: string);
begin
    //PD-5: texto do banco ("1234,56" ou "1234.56") impresso como "1.234,56"
    Value := TextoValorRelatorio(Value);
end;

procedure TFormRelatorios.SetTotais(const Totais: TTotaisNotas);
begin
    FTotais := Totais;
end;

procedure TFormRelatorios.SetPasta(const Pasta: string);
begin
    FPasta := Trim(Pasta);
end;

procedure TFormRelatorios.SetVersao(const Versao: string);
begin
    FVersao := Trim(Versao);
end;

end.
