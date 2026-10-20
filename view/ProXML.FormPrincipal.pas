unit ProXML.FormPrincipal;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  //System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Skia,
  Skia.Vcl,
  Vcl.Imaging.pngimage,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.VCLUI.Wait,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  Vcl.ComCtrls,
  Vcl.Grids,
  Vcl.DBGrids,
  FireDAC.Stan.StorageBin,
  Vcl.Samples.Gauges,
  Vcl.Menus,
  DM,
  ProXML.FormRelatorios,
  ProXML.FormRelatorioIBSCBS,
  System.ImageList,
  Vcl.ImgList,
  ACBrDFeReport,
  ACBrDFeDANFeReport,
  ACBrNFeDANFEClass,
  ACBrNFeDANFEFR,
  ACBrBase,
  ACBrDFe,
  ACBrNFe,
  ACBrNFeDANFeFPDF,
  ShellAPI,
  ProXML.Classes,
  System.UITypes,    
  SysUtils,  
  ACBrMail,
  Midas,
  MidasLib,
  uCalculadoraXML,
  Vcl.ActnList,
  System.Actions,
  ProXML.Botao,
  ProXML.Tema,
  ProXML.FrameLoad;

type
  //Relatório aberto depois de gravar as notas no banco (GravarNotasDB)
  TTipoRelatorio = (trNotas, trIBSCBS);

  //Telas da área de conteúdo (Plano 4, etapa 4.4). Cada tela é uma aba do PageControl1 e toda
  //troca de tela passa por TFormPrincipal.MostrarTela, que também sincroniza o item ativo do menu
  TTela = (tlResumo, tlNotas, tlRelatorios, tlEnviar, tlConfiguracoes, tlCarregando);
  //Telas com item no menu lateral. Carregando não tem item (o item da tela de origem continua
  //destacado) e uma tela nova sem item (ex.: Sobre, etapa 4.7) deixa o menu sem item ativo
  TTelaMenu = tlResumo..tlConfiguracoes;

  TFormPrincipal = class(TForm)
    PnlContainer: TPanel;
    PnlCabecalho: TPanel;
    PnlCorpo: TPanel;
    PnlLocal: TPanel;
    PnlInfoLocal: TPanel;
    {$IFDEF MSWINDOWS}
      FileOpenDialog1: TFileOpenDialog;
    {$ENDIF}
    //Cabeçalho (etapa 4.3): logo vetorial e acesso à tela Sobre
    SkSvgLogo: TSkSvg;
    PnlSobre: TPanel;
    SkSvgSobre: TSkSvg;
    LabelSobre: TLabel;
    //Barra de pasta (etapa 4.3): campo, Selecionar…, seletor de modelo e Processar
    PnlBarraPasta: TPanel;
    PnlBarraPastaBorda: TPanel;
    PnlCampoPasta: TPanel;
    PnlCampoPastaFundo: TPanel;
    SkSvgPasta: TSkSvg;
    PnlSelecionar: TPanel;
    PnlModelo: TPanel;
    //Faixa de cards no topo da área de conteúdo (etapa 4.3, decisão D1)
    PnlConteudo: TPanel;
    PnlCards: TPanel;
    PnlCardValorTotal: TPanel;
    PnlCardValorTotalFundo: TPanel;
    PnlCardValorTotalRotulo: TPanel;
    SkSvgCardValorTotal: TSkSvg;
    LabelTituloValorTotal: TLabel;
    LabelValorTotal: TLabel;
    PnlCardBaseICMS: TPanel;
    PnlCardBaseICMSFundo: TPanel;
    PnlCardBaseICMSRotulo: TPanel;
    SkSvgCardBaseICMS: TSkSvg;
    LabelTituloBaseICMS: TLabel;
    LabelbaseICMS: TLabel;
    PnlCardICMS: TPanel;
    PnlCardICMSFundo: TPanel;
    PnlCardICMSRotulo: TPanel;
    SkSvgCardICMS: TSkSvg;
    LabelTituloICMS: TLabel;
    LabelValorICMS: TLabel;
    PnlCardIBS: TPanel;
    PnlCardIBSFundo: TPanel;
    PnlCardIBSRotulo: TPanel;
    SkSvgCardIBS: TSkSvg;
    LabelTituloIBS: TLabel;
    LabelValorIBS: TLabel;
    PnlCardCBS: TPanel;
    PnlCardCBSFundo: TPanel;
    PnlCardCBSRotulo: TPanel;
    SkSvgCardCBS: TSkSvg;
    LabelTituloCBS: TLabel;
    LabelValorCBS: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Memo1: TMemo;
    Panel5: TPanel;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    FDMemTable1: TFDMemTable;
    FDMemTable1numero: TIntegerField;
    FDMemTable1chave: TWideStringField;
    FDMemTable1data: TWideStringField;
    FDMemTable1vlicms: TFloatField;
    FDMemTable1bcicms: TFloatField;
    FDMemTable1vtotal: TFloatField;
    Gauge1: TGauge;
    EditCaminho: TEdit;
    Panel7: TPanel;
    //Menu lateral (etapa 4.4): itens TProItemMenu criados em runtime no PnlMenuItens
    PanelMenus: TPanel;
    PnlMenuItens: TPanel;
    PnlMenuBorda: TPanel;
    PopupMenu: TPopupMenu;
    GerarPDF1: TMenuItem;
    Loading: TTabSheet;
    FormRelatorio: TFormRelatorios;
    FDMemTable1xml: TStringField;
    FDMemTable1modelo: TIntegerField;
    FDMemTable1tem_ibscbs: TBooleanField;
    FDMemTable1vbcibscbs: TFloatField;
    FDMemTable1vibsuf: TFloatField;
    FDMemTable1vibsmun: TFloatField;
    FDMemTable1vibs: TFloatField;
    FDMemTable1vcbs: TFloatField;
    ACBrNFe: TACBrNFe;
    GerarDANFe1: TMenuItem;
    ACBrNFeDANFeFPDF1: TACBrNFeDANFeFPDF;
    Enviar: TTabSheet;
    Config: TTabSheet;
    PanelCorpoConfig: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Shape2: TShape;
    Shape3: TShape;
    Shape10: TShape;
    Shape11: TShape;
    Shape12: TShape;
    Label4: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    CheckBoxSSL: TCheckBox;
    CheckBoxTSL: TCheckBox;
    EditSMTP: TEdit;
    EditPorta: TEdit;
    EditEmail: TEdit;
    EditPass: TEdit;
    MemoMsg: TMemo;
    Panel9: TPanel;
    SkSvg5: TSkSvg;
    ACBrMail1: TACBrMail;
    Panel10: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    Shape15: TShape;
    Shape17: TShape;
    Label15: TLabel;
    Label17: TLabel;
    EditEmailEnviar: TEdit;
    MemoMensagem: TMemo;
    Panel11: TPanel;
    ACBrNFeDANFEFR: TACBrNFeDANFEFR;
    LabelFiltroModelo: TLabel;
    //Faixa de aviso no Resumo (etapa 4.3): pasta salva que não existe mais (glossário 2.14)
    PnlAvisoPasta: TPanel;
    PnlAvisoPastaBarra: TPanel;
    SkSvgAvisoPasta: TSkSvg;
    LabelAvisoPasta: TLabel;
    //Tela Carregando (etapa 4.4; tokens.md 5.14): animação do ProXML.FrameLoad, operação e legenda
    PnlCarregando: TPanel;
    PnlCarregandoFundo: TPanel;
    PnlAnimacao: TPanel;
    LabelCarregandoTitulo: TLabel;
    LabelCarregandoLegenda: TLabel;
    //Tela Relatórios (etapa 4.4; mockup relatorios.html e glossário 8.1 a 8.11)
    Relatorios: TTabSheet;
    PnlRelatorios: TPanel;
    PnlRelatoriosTitulo: TPanel;
    LabelRelatoriosTitulo: TLabel;
    PnlRelatoriosFiltro: TPanel;
    PnlRelatoriosFiltroFundo: TPanel;
    SkSvgRelatoriosFiltro: TSkSvg;
    LabelRelatoriosFiltro: TLabel;
    PnlOpcoes: TPanel;
    PnlOpcaoNotas: TPanel;
    PnlOpcaoNotasFundo: TPanel;
    PnlOpcaoNotasTitulo: TPanel;
    SkSvgOpcaoNotas: TSkSvg;
    LabelOpcaoNotasTitulo: TLabel;
    LabelOpcaoNotasDescricao: TLabel;
    PnlOpcaoNotasRodape: TPanel;
    PnlGerarNotas: TPanel;
    SkSvgDicaNotas: TSkSvg;
    LabelDicaNotas: TLabel;
    PnlOpcaoIBSCBS: TPanel;
    PnlOpcaoIBSCBSFundo: TPanel;
    PnlOpcaoIBSCBSTitulo: TPanel;
    SkSvgOpcaoIBSCBS: TSkSvg;
    LabelOpcaoIBSCBSTitulo: TLabel;
    LabelOpcaoIBSCBSDescricao: TLabel;
    PnlOpcaoIBSCBSRodape: TPanel;
    PnlGerarIBSCBS: TPanel;
    SkSvgDicaIBSCBS: TSkSvg;
    LabelDicaIBSCBS: TLabel;
    LabelRelatoriosRodape: TLabel;
    procedure SelecionarPastaClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GerarPDF1Click(Sender: TObject);
    procedure GravarNotasDB(const Relatorio: TTipoRelatorio);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GerarDANFe1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSalvarConfigClick(Sender: TObject);
    procedure SkSvg5Click(Sender: TObject);
    procedure btnEnviarEmailClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SeletorModeloChange(Sender: TObject);
  private
    ConfigEmail : TConfig;
    FTotais : TTotaisNotas;
    FGerandoDanfe : Boolean;   //evita gerar dois DANFEs ao mesmo tempo (a espera do PDF processa mensagens)
    FJanelaNormal : TRect;     //posição e tamanho da janela no estado normal (salvos mesmo se maximizada)
    FRolagemEnviar: TScrollBox;
    FRolagemConfig: TScrollBox;
    FMaximizarAoMostrar: Boolean;   //janela salva maximizada: maximiza no FormShow
    FPPIAtual : Integer;
    FPastaNaoEncontrada: string;   //pasta do aviso 2.14 (o texto da faixa encurta o caminho)       //escala atual da tela (o PixelsPerInch do 10.2 fica com o valor do .dfm)
    //Etapa 4.4: tela Carregando e moldura do PageControl
    FCarregando         : Boolean;        //tela Carregando aberta (menu bloqueado)
    FFocoAntesCarregando: TWinControl;    //controle que tinha o foco ao abrir a tela Carregando
    FFrameCarregando    : TFrameLoad;     //animação Lottie (ProXML.FrameLoad), criada em runtime
    FJanelaPaginas      : TWndMethod;     //WindowProc original do PageControl1
    FAjustandoRelatorios: Boolean;        //evita reentrada no layout da tela Relatórios
    procedure SetTextoTranferencia(const Text: String);
    procedure AjustarAlturaLinhasGrade;
    procedure GerarRelatorio(const Relatorio: TTipoRelatorio);
    procedure FinalizaRelatorio(const Relatorio: TTipoRelatorio);
    procedure AbrirRelatorioIBSCBS;
    function  DescricaoFiltroModelo: string;
    procedure ConfigACBR;
    procedure GerarDanfe(const CaminhoArq, Numero: String);
    function  ConfigurarLayoutDanfe(out Mensagem: string): Boolean;
    function  AguardarArquivoPDF(const Caminhos: array of string; out CaminhoGerado: string): Boolean;
    procedure ComprimirArquivos();
    procedure LerConfigEmail();
    procedure EnviaArquivo(const Email, Assunto: string);
    procedure ApplicationException(Sender: TObject; E: Exception);
    function  CreateProcessSimple(cmd: string): boolean;
    //Plano 4, etapa 4.2: botões, atalhos, rolagem e preferências da janela
    procedure CriarBotoes;
    procedure CriarAtalhos;
    function  CriarRolagem(Painel: TPanel): TScrollBox;
    procedure RolagemResize(Sender: TObject);
    function  TemNotaNaGrade: Boolean;
    procedure RestaurarPreferencias;
    procedure SalvarPreferencias;
    procedure GuardarUltimaPasta(const Pasta: string);
    procedure RegistrarFalhaPreferencias(E: Exception);
    function  AjustarAreaVisivel(const Janela: TRect): TRect;
    procedure RegistrarJanelaNormal;
    procedure WMMove(var Message: TWMMove); message WM_MOVE;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure AcaoSelecionarPastaExecute(Sender: TObject);
    procedure AcaoProcessarExecute(Sender: TObject);
    procedure AcaoProcessarUpdate(Sender: TObject);
    procedure AcaoBuscarExecute(Sender: TObject);
    procedure AcaoCopiarChaveExecute(Sender: TObject);
    procedure AcaoCopiarChaveUpdate(Sender: TObject);
    procedure AcaoGerarDanfeExecute(Sender: TObject);
    procedure AcaoGerarDanfeUpdate(Sender: TObject);
    //Plano 4, etapa 4.3: cabeçalho, barra de pasta e cards
    function  Escalar(const Valor: Integer): Integer;
    procedure FixarTamanhoMinimo;
    procedure AplicarVisualCabecalho;
    procedure CriarBarraPasta;
    procedure PrepararCards;
    procedure PnlCardsResize(Sender: TObject);
    procedure AjustarFonteValoresCards;
    procedure AtualizarVisualCards;
    procedure PaginaShow(Sender: TObject);
    procedure EditCaminhoChange(Sender: TObject);
    procedure EditCaminhoEnter(Sender: TObject);
    procedure EditCaminhoExit(Sender: TObject);
    procedure AtualizarBordaCampoPasta(const ComFoco: Boolean);
    procedure MostrarAvisoPastaNaoEncontrada(const Pasta: string);
    procedure PnlAvisoPastaResize(Sender: TObject);
    procedure AjustarLargurasBarraPasta;
    procedure WMDropFiles(var Message: TWMDropFiles); message WM_DROPFILES;
    procedure WMDpiChanged(var Message: TWMDpi); message WM_DPICHANGED;
    procedure WMProXMLPPI(var Message: TMessage); message WM_PROXML_PPI;
    function  PPIAtual: Integer;
    procedure FonteNaEscala(Fonte: TFont; const Tamanho: Integer);
    procedure AposMudarEscala;
    //Plano 4, etapa 4.4: menu, navegação, tela Relatórios e tela Carregando
    procedure CriarMenu;
    procedure ItemMenuClick(Sender: TObject);
    function  AbaDaTela(const Tela: TTela): TTabSheet;
    function  TelaDaAba(const Aba: TTabSheet): TTela;
    procedure SincronizarMenu(const Tela: TTela);
    procedure HabilitarMenu(const Habilitar: Boolean);
    function  TelaSemMoldura(const Tela: TTela): Boolean;
    procedure JanelaPaginas(var Message: TMessage);
    procedure PrepararTelaRelatorios;
    procedure PrepararOpcaoRelatorio(Borda, Fundo, Titulo: TPanel; Icone: TSkSvg; Rotulo,
      Descricao: TLabel; Rodape, Encaixe: TPanel; IconeDica: TSkSvg; Dica: TLabel; Botao: TProBotao);
    procedure AjustarLayoutRelatorios;
    procedure PnlOpcoesResize(Sender: TObject);
    procedure AjustarIndicadorFiltro;
    procedure MostrarDica(IconeDica: TSkSvg; Dica: TLabel; const Texto: string);
    function  AlturaTextoQuebrado(Rotulo: TLabel; const Largura: Integer): Integer;
    procedure GerarRelatorioNotasClick(Sender: TObject);
    procedure GerarRelatorioIBSCBSClick(Sender: TObject);
    procedure PrepararTelaCarregando;
    procedure AjustarLayoutCarregando;
    procedure PnlCarregandoFundoResize(Sender: TObject);
    procedure IniciarCarregando(const Titulo, Legenda: string);
    procedure EncerrarCarregando(const Destino: TTela);

  protected
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
  public
    //A VCL escala as Constraints junto com o DPI (ao carregar o .dfm e ao trocar de monitor);
    //o mínimo da janela volta para 1024x640 pixels reais
    procedure ScaleForPPI(NewPPI: Integer); override;

  public
    //Botões criados em runtime (TProBotao) nos painéis de encaixe Panel7, PnlSelecionar, Panel11 e Panel9
    btnProcessar    : TProBotao;
    btnSelecionar   : TProBotao;
    btnEnviarEmail  : TProBotao;
    btnSalvarConfig : TProBotao;
    //Seletor de modelo em botões segmentados (decisão D6), criado em runtime no PnlModelo
    SeletorModelo   : TProSegmentado;
    //Atalhos de teclado (criados em runtime em CriarAtalhos)
    Acoes              : TActionList;
    actSelecionarPasta : TAction;   //Ctrl+O
    actProcessar       : TAction;   //F5
    actBuscar          : TAction;   //Ctrl+F
    actCopiarChave     : TAction;   //Ctrl+C (com a grade em foco)
    actGerarDanfe      : TAction;   //Ctrl+D (na tela Notas)
    //Menu lateral (etapa 4.4): um item por tela com item no menu, criados em CriarMenu
    ItensMenu          : array[TTelaMenu] of TProItemMenu;
    //Botões "Gerar relatório" da tela Relatórios (criados em PrepararTelaRelatorios)
    btnGerarRelNotas   : TProBotao;
    btnGerarRelIBSCBS  : TProBotao;
    //Troca de tela (única rotina): mostra a aba da tela e sincroniza o item ativo do menu
    procedure MostrarTela(const Tela: TTela);
    //Tela exibida agora (pela aba ativa do PageControl1)
    function  TelaAtual: TTela;
    //Tela Carregando aberta (menu bloqueado)
    property  Carregando: Boolean read FCarregando;
    //Textos, botões e dicas da tela Relatórios conforme as notas do filtro de modelo atual
    procedure AtualizarTelaRelatorios;
    procedure AtualizarTotais;
    //Há pasta escolhida? (P3: só olha se o campo está preenchido, sem comparar texto)
    function  TemPasta: Boolean;
    //Processar habilitado só com pasta (com a dica "Selecione uma pasta primeiro." no painel)
    procedure AtualizarEstadoProcessar;
    //Abre o seletor de pasta (clique no campo, em Selecionar… ou Ctrl+O)
    procedure SelecionarPasta;
    //Usa a pasta (ou a pasta do arquivo) solta na janela; False se o item não existe
    function  UsarItemSolto(const Caminho: string): Boolean;
    //Modelo escolhido no seletor (FILTRO_MODELO_TODOS, FILTRO_MODELO_NFE ou FILTRO_MODELO_NFCE)
    function  ModeloSelecionado: Integer;
    //Aplica o modelo escolhido na grade, nos cards e nos relatórios
    procedure AplicarFiltroModelo;
    //Totais das notas da grade (respeitando o filtro), inclusive IBS/CBS
    property Totais : TTotaisNotas read FTotais;
  end;

Type
  TDBGridPadrao = class(TDBGrid);

var
  FormPrincipal: TFormPrincipal;

implementation

uses
  Vcl.Clipbrd,
  ACBrDFe.Conversao,
  pcnConversaoNFe,
  {$IFDEF MSWINDOWS}
    Vcl.FileCtrl,
  {$ENDIF}
  System.IOUtils,
  System.Math,
  Winapi.CommCtrl,
  ProXML.Icones;

{$R *.dfm}

const
  //Tempo máximo de espera pelo PDF do DANFE (milissegundos)
  TEMPO_LIMITE_PDF_MS = 15000;

procedure TFormPrincipal.ApplicationException(Sender: TObject; E: Exception);
begin
  // Grava no log o erro com detalhes
  DMConfig.CreateLog(E.ClassName, E.Message);
end;

procedure TFormPrincipal.btnEnviarEmailClick(Sender: TObject);
begin
    //Enviar Email com arquivos compactados.
    //Os XMLs são separados e compactados agora, com o filtro de modelo atual da grade
    if (not FDMemTable1.Active) or FDMemTable1.IsEmpty then
    begin
        messagedlg('Sem arquivos para enviar!', mtInformation	, [mbOk], 0);
        Exit;
    end;

    ComprimirArquivos();
    EnviaArquivo(Trim(EditEmailEnviar.Text), 'Projeto Pro XML - XMLs de Nota Fiscal');
end;

procedure TFormPrincipal.AtualizarTotais;
begin
    //Recalcula os totais a partir das notas da grade (respeita o filtro ativo)
    FTotais := CalcularTotais(FDMemTable1);

    LabelValorTotal.Caption := FormatarMoeda(FTotais.ValorTotal);
    LabelbaseICMS.Caption   := FormatarMoeda(FTotais.BaseICMS);
    LabelValorICMS.Caption  := FormatarMoeda(FTotais.ValorICMS);
    LabelValorIBS.Caption   := FormatarMoeda(FTotais.IBS);
    LabelValorCBS.Caption   := FormatarMoeda(FTotais.CBS);

    //Sem notas no filtro: valores em cinza e peso normal; valor grande diminui para caber
    AtualizarVisualCards;

    //A tela Relatórios mostra o filtro e as contagens: acompanha o filtro de modelo e o Processar
    AtualizarTelaRelatorios;
end;

function TFormPrincipal.DescricaoFiltroModelo: string;
begin
    //Texto do seletor de modelo para o subtítulo dos relatórios; vazio em "Todos"
    if ModeloSelecionado = FILTRO_MODELO_TODOS then
        Result := ''
    else
        Result := SeletorModelo.Itens[SeletorModelo.ItemIndex];
end;

procedure TFormPrincipal.AjustarAlturaLinhasGrade;
begin
    //Linhas da grade com 25 px. Não chamar no OnDrawColumnCell: alterar DefaultRowHeight
    //invalida a grade e ela fica se repintando sem parar.
    //O DBGrid recalcula a altura quando o layout muda (ex.: abrir o DataSet), por isso
    //reaplica depois de processar e de trocar o filtro.
    if TDBGridPadrao(DBGrid1).DefaultRowHeight <> 25 then
        TDBGridPadrao(DBGrid1).DefaultRowHeight := 25;
end;

function TFormPrincipal.ModeloSelecionado: Integer;
begin
    //Itens do seletor: 0 = Todos, 1 = NF-e 55, 2 = NFC-e 65
    case SeletorModelo.ItemIndex of
        1: Result := FILTRO_MODELO_NFE;
        2: Result := FILTRO_MODELO_NFCE;
    else
        Result := FILTRO_MODELO_TODOS;
    end;
end;

procedure TFormPrincipal.AplicarFiltroModelo;
var
    Modelo: Integer;
begin
    //Filtra a grade pelo modelo escolhido e recalcula todos os cards.
    //O mesmo filtro vai para o DMConfig, usado pelos relatórios (QryNotas e QryNotasIBSCBS).
    Modelo := ModeloSelecionado;

    FDMemTable1.DisableControls;
    try
        if Modelo = FILTRO_MODELO_TODOS then
        begin
            FDMemTable1.Filtered := False;
            FDMemTable1.Filter   := '';
        end
        else
        begin
            FDMemTable1.Filter   := 'modelo = ' + IntToStr(Modelo);
            FDMemTable1.Filtered := True;
        end;

        if FDMemTable1.Active then
            FDMemTable1.First;
    finally
        FDMemTable1.EnableControls;
    end;

    DMConfig.FiltroModelo := Modelo;
    AtualizarTotais;
    AjustarAlturaLinhasGrade;
end;

procedure TFormPrincipal.SeletorModeloChange(Sender: TObject);
begin
    //Troca do modelo no seletor
    AplicarFiltroModelo;
end;

procedure TFormPrincipal.btnSalvarConfigClick(Sender: TObject);
begin
    //Salvar dados Config       
    ConfigEmail.SMTP        := EditSMTP.Text;
    ConfigEmail.Porta       := EditPorta.Text;
    ConfigEmail.Email       := EditEmail.Text;
    ConfigEmail.Senha       := EditPass.Text;
    ConfigEmail.Mensagem    := MemoMsg.Text;
    ConfigEmail.SSL         := CheckBoxSSL.Checked;
    ConfigEmail.TSL         := CheckBoxTSl.Checked;
    try
        DMConfig.UpdateConfig(ConfigEmail);
        //Etapa 4.4 (N5): salvar não troca de tela. A mensagem muda na 4.7 (glossário)
        messagedlg('Configuração salva com sucesso !!', mtInformation	, [mbOk], 0);
    except
    end;
end;

function TFormPrincipal.CreateProcessSimple(cmd: string): boolean;
var
  SUInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
begin
  FillChar(SUInfo, SizeOf(SUInfo), #0);
  SUInfo.cb      := SizeOf(SUInfo);
  SUInfo.dwFlags := STARTF_USESHOWWINDOW;
  SUInfo.wShowWindow := SW_HIDE;

  Result := CreateProcess(nil,
                          PChar(cmd),
                          nil,
                          nil,
                          false,
                          CREATE_NEW_CONSOLE or
                          NORMAL_PRIORITY_CLASS,
                          nil,
                          nil,
                          SUInfo,
                          ProcInfo);

  if (Result) then
  begin
    WaitForSingleObject(ProcInfo.hProcess, INFINITE);

    CloseHandle(ProcInfo.hProcess);
    CloseHandle(ProcInfo.hThread);
  end;

end;

procedure TFormPrincipal.FinalizaRelatorio(const Relatorio: TTipoRelatorio);
begin
   //Finaliza o relatório
   //Garante que o relatório use o mesmo modelo da grade e dos cards
   DMConfig.FiltroModelo := ModeloSelecionado;

   if Relatorio = trIBSCBS then
   begin
        AbrirRelatorioIBSCBS;
        Exit;
   end;

   FormRelatorio := TFormRelatorios.Create(Nil);
   try
        FormRelatorio.SetTotal(LabelValorTotal.Caption);
        FormRelatorio.SetTotalBC(LabelbaseICMS.Caption);
        FormRelatorio.SetTotalICMS(LabelValorICMS.Caption);
        FormRelatorio.SetQtRegistros(IntToStr(FDMemTable1.RecordCount));
        FormRelatorio.SetDescricaoFiltro(DescricaoFiltroModelo);
        FormRelatorio.GerarRelatorio;
        //Visualização fechada: GravarNotasDB fecha a tela Carregando e volta para Relatórios
   finally
        FreeAndNil(FormRelatorio);
   end

end;

procedure TFormPrincipal.AbrirRelatorioIBSCBS;
var
    FormIBSCBS: TFormRelatorioIBSCBS;
begin
    //Relatório IBS/CBS: só as notas com o grupo IBSCBSTot, no modelo escolhido.
    //Os totais do rodapé vêm de FTotais (calculados na grade filtrada), não de SUM no banco.
    FormIBSCBS := TFormRelatorioIBSCBS.Create(Nil);
    try
        FormIBSCBS.SetTotalBaseIBSCBS(FormatarMoeda(FTotais.BaseIBSCBS));
        FormIBSCBS.SetTotalIBSUF(FormatarMoeda(FTotais.IBSUF));
        FormIBSCBS.SetTotalIBSMun(FormatarMoeda(FTotais.IBSMun));
        FormIBSCBS.SetTotalIBS(FormatarMoeda(FTotais.IBS));
        FormIBSCBS.SetTotalCBS(FormatarMoeda(FTotais.CBS));
        FormIBSCBS.SetQtRegistros(IntToStr(FTotais.QuantidadeIBSCBS));
        FormIBSCBS.SetDescricaoFiltro(DescricaoFiltroModelo);

        if not FormIBSCBS.GerarRelatorio then
        begin
            //Nenhuma nota do filtro atual tem IBS/CBS: não abre a visualização (glossário 8.10).
            //Com o botão desabilitado nesse caso, a caixa só aparece se o relatório for pedido mesmo assim
            EncerrarCarregando(tlRelatorios);
            messagedlg('Nenhuma nota do modelo selecionado tem IBS/CBS.', mtInformation, [mbOk], 0);
        end;

        //Visualização fechada: GravarNotasDB fecha a tela Carregando e volta para Relatórios
    finally
        FreeAndNil(FormIBSCBS);
    end;
end;

procedure TFormPrincipal.GerarRelatorio(const Relatorio: TTipoRelatorio);
begin
    //Confere se a grade (filtrada) tem notas, grava no banco e abre o relatório escolhido.
    //Na tela Relatórios os botões ficam desabilitados nesses casos (dicas 8.8 e 8.10): as caixas
    //abaixo só aparecem se o relatório for pedido mesmo assim (glossário 8.9 e 8.10)
    if not TemNotaNaGrade then
    begin
       messagedlg('Nenhuma nota para o relatório. Processe uma pasta primeiro.', mtInformation	, [mbOk], 0);
       Exit;
    end;

    if (Relatorio = trIBSCBS) and (FTotais.QuantidadeIBSCBS = 0) then
    begin
       //Sem nota com IBS/CBS no filtro: não grava nada no banco
       messagedlg('Nenhuma nota do modelo selecionado tem IBS/CBS.', mtInformation, [mbOk], 0);
       Exit;
    end;

    GravarNotasDB(Relatorio);
end;

procedure TFormPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //Guarda a pasta e a janela para a próxima execução
  SalvarPreferencias;

  try
    action := cafree;
  except
  end;
  Application.Terminate;
end;

procedure TFormPrincipal.FormCreate(Sender: TObject);
begin
   //Create do Form
   //Application.OnException := DMConfig.GravaLog;

   //Tema (fonte base), botões e atalhos criados em runtime e rolagem nas telas
   //Enviar e Configurações quando a janela fica menor que o layout atual
   AplicarTema(Self);
   FixarTamanhoMinimo;
   CriarBotoes;
   CriarAtalhos;
   //Etapa 4.4: menu lateral (só navega), tela Relatórios e tela Carregando
   CriarMenu;
   PrepararTelaRelatorios;
   PrepararTelaCarregando;
   //Etapa 4.3: cabeçalho, barra de pasta (campo, Selecionar…, seletor de modelo) e cards
   AplicarVisualCabecalho;
   CriarBarraPasta;
   PrepararCards;
   FRolagemEnviar := CriarRolagem(Panel10);
   FRolagemConfig := CriarRolagem(PanelCorpoConfig);

   try          
    ConfigEmail := DMConfig.GetConfig;

    EditSMTP.Text        := ConfigEmail.SMTP;
    EditPorta.Text       := ConfigEmail.Porta;
    EditEmail.Text       := ConfigEmail.Email;
    EditPass.Text        := ConfigEmail.Senha;
    MemoMsg.Text         := ConfigEmail.Mensagem;
    CheckBoxSSL.Checked  := ConfigEmail.SSL;
    CheckBoxTSl.Checked  := ConfigEmail.TSL;
   except
   end;

   //Seletor de modelo começa em "Todos"
   SeletorModelo.ItemIndex := 0;
   AplicarFiltroModelo;

   //Última pasta e janela da execução anterior
   RestaurarPreferencias;

   //Sem pasta, Processar começa desabilitado
   AtualizarEstadoProcessar;
end;

procedure TFormPrincipal.FormDestroy(Sender: TObject);
begin
  //ConfigEmail.Free;
  //Devolve o WindowProc original do PageControl1 (trocado em PrepararTelaRelatorios)
  if Assigned(FJanelaPaginas) then
    PageControl1.WindowProc := FJanelaPaginas;
end;

procedure TFormPrincipal.ComprimirArquivos();
var
  varPath: string;
  varDestino: string;
  Marcador: TBookmark;
begin
    //Comprime os arquivos XML
    varPath := ExtractFilePath(ParamStr(0));

    if TDirectory.Exists(varPath + 'NFCe\ProXML') then
    begin
      // Deleta a pasta e todo o seu conteúdo
      TDirectory.Delete(varPath + 'NFCe\ProXML', True);  // O segundo parâmetro True indica exclusão recursiva
    end;

    if not SysUtils.DirectoryExists(varPath + 'NFCe\ProXML') then SysUtils.ForceDirectories(varPath + '\NFCe\ProXML');

    //Copia as notas visíveis na grade (filtro atual) sem mexer na tela e
    //sem perder o registro selecionado
    FDMemTable1.DisableControls;
    try
        Marcador := FDMemTable1.GetBookmark;
        try
            FDMemTable1.First;
            while not FDMemTable1.Eof do
            begin
                varDestino := varPath + 'NFCe\ProXML\'+FDMemTable1.FieldByName('chave').AsString+'-nfe.xml';

                CopyFile(PChar(FDMemTable1.FieldByName('xml').AsString), PChar(varDestino), False);
                FDMemTable1.Next;
            end;
        finally
            if (Marcador <> nil) and FDMemTable1.BookmarkValid(Marcador) then
                FDMemTable1.GotoBookmark(Marcador);
            FDMemTable1.FreeBookmark(Marcador);
        end;
    finally
        FDMemTable1.EnableControls;
    end;

    if FileExists(varPath + 'NFCe\NFCe_ProXML.rar') then
        DeleteFile(varPath + 'NFCe\NFCe_ProXML.rar');

    createProcessSimple('cmd.exe /c' + varPath + 'WinRAR.exe a -ep '
                + varPath + 'NFCe\NFCe_ProXML.rar '
                + varPath + 'NFCe\ProXML\*-nfe.xml' );

end;

procedure TFormPrincipal.ConfigACBR();
var
  varPath: string;
begin
    //Configurações ACBR
    //ACBrNFe.Configuracoes.Geral.FormaEmissao := teNormal;
    varPath := ExtractFilePath(ParamStr(0));

    if not SysUtils.DirectoryExists(varPath + 'NFCe\EnvioResposta') then SysUtils.ForceDirectories(varPath + '\NFCe\EnvioResposta');
    if not SysUtils.DirectoryExists(varPath + '\NFCe\danfePDF') then SysUtils.ForceDirectories(varPath + '\NFCe\danfePDF');

    ACBrNFe.Configuracoes.Arquivos.PathSalvar      := varPath + 'NFCe\EnvioResposta';
    ACBrNFe.DANFE.PathPDF                          := varPath + 'NFCe\danfePDF';
    ACBrNFe.Configuracoes.Arquivos.PathSchemas     := varPath + 'Schemas\NFe';

    ACBrNFe.Configuracoes.Geral.Salvar             := False;
    ACBrNFe.Configuracoes.Arquivos.EmissaoPathNFe  := True;
    ACBrNFe.Configuracoes.Arquivos.SepararPorMes   := True;
    ACBrNFe.Configuracoes.Arquivos.SalvarEvento    := False;
    ACBrNFe.Configuracoes.Arquivos.Salvar          := True;

//    ACBrNFe.Configuracoes.Geral.Salvar        := True;
//    ACBrNFe.Configuracoes.Geral.ModeloDF      := moNFCe;
//    ACBrNFe.Configuracoes.Geral.VersaoDF      := ve400;
//    ACBrNFe.Configuracoes.Geral.VersaoQRCode  := veqr200;

    ACBrNFe.Configuracoes.Geral.ExibirErroSchema := True;
    ACBrNFe.Configuracoes.Geral.FormatoAlerta    := '[ %TAGNIVEL%%TAG% ] %DESCRICAO% - %MSG%';

    ACBrNFeDANFEFR.ExibeCampoDePagamento := eipQuadro;
    //O layout do DANFE (FastFile, FastFileEvento e TipoDANFE) é escolhido por nota em
    //GerarDanfe (ConfigurarLayoutDanfe), conforme o modelo e o tpImp do XML

//    ACBrNFeDANFeFPDF1.ExibeCampoDePagamento := eipQuadro;

    ACBrNFeDANFeFPDF1.PathPDF := varPath + '\NFCe\danfePDF';
    //ACBrNFeDANFeFPDF1.        := varPath + 'Report\NFe\DANFeNFCeA4.fr3'; //DANFeNFCe5_00.fr3 // DANFeNFCeA4.fr3
    //ACBrNFeDANFeFPDF1.FastFileEvento  := varPath + 'Report\NFe\EventosNFCe.fr3';
end;

procedure TFormPrincipal.FormShow(Sender: TObject);
begin
   //Ajustar linhas DBGrid
   try
    AjustarAlturaLinhasGrade;
   except
   end;

   try
    DataSource1.DataSet.First;
   except
   end;

   //Abre no Resumo, com o item do menu sincronizado
   MostrarTela(tlResumo);

   try
    ConfigACBR();
   except
   end;

   //Janela salva maximizada: maximiza só agora, com a janela já criada no tamanho normal.
   //Maximizando no FormCreate, a VCL cria a janela com o tamanho do .dfm (ClientWidth/ClientHeight)
   //e o tamanho normal salvo se perde ao restaurar.
   if FMaximizarAoMostrar then
   begin
       FMaximizarAoMostrar := False;
       WindowState := wsMaximized;
   end;
end;

procedure TFormPrincipal.SetTextoTranferencia(const Text: String);
begin
    //Setar texto do NCM na area de transferencia
    Clipboard.AsText := Text;
end;

function TFormPrincipal.ConfigurarLayoutDanfe(out Mensagem: string): Boolean;
var
    PathReport : string;
    Modelo     : Integer;
    TipoImp    : TACBrTipoImpressao;
begin
    //Escolhe o layout do DANFE pela nota carregada no ACBr (NotasFiscais.Items[0]):
    //  modelo 65 -> NFC-e (DANFeNFCeA4.fr3);
    //  modelo 55 -> segue o tpImp do XML: 1 retrato (DANFeRetrato.fr3), 2 paisagem (DANFePaisagem.fr3).
    //Outro tpImp no modelo 55 (3 simplificado, 4, 5 ...) não tem layout definido: a geração é recusada.
    //Obs.: o DM do FastReport decide o que montar pelo Ide.modelo/Ide.tpImp do XML e não usa
    //Configuracoes.Geral.ModeloDF; o FastFileEvento só é usado na impressão de eventos.
    Result     := False;
    Mensagem   := '';
    PathReport := ExtractFilePath(ParamStr(0)) + 'Report\NFe\';
    Modelo     := ACBrNFe.NotasFiscais.Items[0].NFe.Ide.modelo;
    TipoImp    := ACBrNFe.NotasFiscais.Items[0].NFe.Ide.tpImp;

    case Modelo of
        65:
        begin
            ACBrNFeDANFEFR.FastFile       := PathReport + 'DANFeNFCeA4.fr3';
            ACBrNFeDANFEFR.FastFileEvento := PathReport + 'EventosNFCe.fr3';
            ACBrNFe.DANFE.TipoDANFE       := tiNFCe;
        end;

        55:
        begin
            case TipoImp of
                tiRetrato:
                begin
                    ACBrNFeDANFEFR.FastFile := PathReport + 'DANFeRetrato.fr3';
                    ACBrNFe.DANFE.TipoDANFE := tiRetrato;
                end;

                tiPaisagem:
                begin
                    ACBrNFeDANFEFR.FastFile := PathReport + 'DANFePaisagem.fr3';
                    ACBrNFe.DANFE.TipoDANFE := tiPaisagem;
                end;
            else
                Mensagem := 'Layout de DANFE não suportado (tpImp ' + TpImpToStr(TipoImp) + ').' + sLineBreak +
                            'O ProXML gera o DANFE da NF-e (modelo 55) apenas nos layouts retrato (tpImp 1) ' +
                            'e paisagem (tpImp 2).';
                Exit;
            end;

            ACBrNFeDANFEFR.FastFileEvento := PathReport + 'EVENTOS.fr3';
        end;
    else
        Mensagem := 'Modelo de documento não suportado para gerar o DANFE (modelo ' + IntToStr(Modelo) + ').';
        Exit;
    end;

    Result := True;
end;

function TFormPrincipal.AguardarArquivoPDF(const Caminhos: array of string; out CaminhoGerado: string): Boolean;
var
    Inicio : Cardinal;
    I      : Integer;
begin
    //Espera o PDF aparecer em um dos caminhos, processando as mensagens da tela,
    //por no máximo TEMPO_LIMITE_PDF_MS
    Result        := False;
    CaminhoGerado := '';
    Inicio        := GetTickCount;

    while True do
    begin
        for I := Low(Caminhos) to High(Caminhos) do
        begin
            if (Caminhos[I] <> '') and FileExists(Caminhos[I]) then
            begin
                CaminhoGerado := Caminhos[I];
                Result := True;
                Exit;
            end;
        end;

        if ((GetTickCount - Inicio) >= TEMPO_LIMITE_PDF_MS) or Application.Terminated then
            Exit;

        Application.ProcessMessages;
        Sleep(50);
    end;
end;

procedure TFormPrincipal.GerarDanfe(const CaminhoArq, Numero: String);
var
    Chave         : string;
    Mensagem      : string;
    CaminhoGerado : string;
    CaminhosPDF   : array[0..2] of string;
    I             : Integer;
begin
    //Gera o DANFE (PDF) do XML da nota e abre o arquivo gerado.
    //A espera do PDF processa mensagens da tela: não deixa iniciar outra geração no meio.
    if FGerandoDanfe then
        Exit;

    FGerandoDanfe := True;
    GerarDANFe1.Enabled := False;
    //Tela Carregando com a animação durante a geração e a espera do PDF (glossário 7.8 e 7.9).
    //Em qualquer caminho (sucesso, erro ou exceção) o finally volta para Notas e reabilita o menu;
    //nos erros a tela volta antes da mensagem, para a caixa aparecer sobre a tela Notas
    IniciarCarregando('Gerando o DANFE da nota ' + Numero + #$2026,
                      'O PDF abre sozinho quando ficar pronto (até ' + IntToStr(TEMPO_LIMITE_PDF_MS div 1000) +
                      ' segundos).');
    try
        //Carrega o XML (sem validar a assinatura)
        ACBrNFe.NotasFiscais.Clear;
        try
            if (not ACBrNFe.NotasFiscais.LoadFromFile(CaminhoArq, False)) or
               (ACBrNFe.NotasFiscais.Count = 0) then
                raise Exception.Create('O arquivo não contém uma Nota Fiscal válida.');
        except
            on E: Exception do
            begin
                DMConfig.CreateLog(E.ClassName, E.Message);
                EncerrarCarregando(tlNotas);
                messagedlg('Não foi possível carregar o XML da nota:' + sLineBreak + CaminhoArq + sLineBreak +
                           sLineBreak + E.Message, mtError, [mbOk], 0);
                Exit;
            end;
        end;

        //Escolhe o layout pelo modelo e pelo tpImp da nota
        if not ConfigurarLayoutDanfe(Mensagem) then
        begin
            EncerrarCarregando(tlNotas);
            messagedlg(Mensagem, mtWarning, [mbOk], 0);
            Exit;
        end;

        //Caminhos possíveis do PDF. O ACBr grava '<chave>-nfe.pdf', com a chave do Id da nota
        //(não depende do nome do arquivo XML); os outros dois são os nomes usados até a versão 1.0
        Chave := Trim(ACBrNFe.NotasFiscais.Items[0].NFe.infNFe.ID);
        if UpperCase(Copy(Chave, 1, 3)) = 'NFE' then
            Delete(Chave, 1, 3);

        CaminhosPDF[0] := '';
        if Chave <> '' then
            CaminhosPDF[0] := ACBrNFe.DANFE.PathPDF + Chave + '-nfe.pdf';
        CaminhosPDF[1] := ACBrNFe.DANFE.PathPDF + ChangeFileExt(ExtractFileName(CaminhoArq), '.pdf');
        CaminhosPDF[2] := ACBrNFe.DANFE.PathPDF + ChangeFileExt(ExtractFileName(CaminhoArq), '-nfe.pdf');

        //Apaga PDFs de gerações anteriores para não abrir um arquivo antigo
        for I := Low(CaminhosPDF) to High(CaminhosPDF) do
        begin
            if (CaminhosPDF[I] <> '') and FileExists(CaminhosPDF[I]) then
                DeleteFile(CaminhosPDF[I]);
        end;

        try
            ACBrNFe.NotasFiscais.ImprimirPDF;
        except
            on E: Exception do
            begin
                DMConfig.CreateLog(E.ClassName, E.Message);
                EncerrarCarregando(tlNotas);
                messagedlg('Erro ao gerar o DANFE:' + sLineBreak + sLineBreak + E.Message, mtError, [mbOk], 0);
                Exit;
            end;
        end;

        if not AguardarArquivoPDF(CaminhosPDF, CaminhoGerado) then
        begin
            if Application.Terminated then
                Exit;

            DMConfig.CreateLog('GerarDanfe', 'PDF do DANFE não gerado: ' + CaminhoArq);
            EncerrarCarregando(tlNotas);
            messagedlg('O PDF do DANFE não foi gerado em ' + IntToStr(TEMPO_LIMITE_PDF_MS div 1000) +
                       ' segundos.' + sLineBreak + sLineBreak + 'Pasta esperada: ' + ACBrNFe.DANFE.PathPDF,
                       mtError, [mbOk], 0);
            Exit;
        end;

        ShellExecute(0, 'open', PChar(CaminhoGerado), nil, nil, SW_SHOWNORMAL);
    finally
        EncerrarCarregando(tlNotas);
        GerarDANFe1.Enabled := True;
        FGerandoDanfe := False;
    end;
end;

procedure TFormPrincipal.GerarDANFe1Click(Sender: TObject);
begin
  if DBGrid1.DataSource.DataSet.IsEmpty then
    Exit;

  GerarDanfe(DBGrid1.DataSource.DataSet.FieldByName('xml').AsString,
             DBGrid1.DataSource.DataSet.FieldByName('numero').AsString);
end;

procedure TFormPrincipal.GerarPDF1Click(Sender: TObject);
begin
   SetTextoTranferencia(DBGrid1.DataSource.DataSet.FieldByName('chave').Value);
end;

procedure TFormPrincipal.GravarNotasDB(const Relatorio: TTipoRelatorio);
var
  Titulo : string;
  Legenda: string;
begin
  //Grava as notas no banco de dados SQLite e abre o relatório escolhido (notas ou IBS/CBS).
  //A gravação roda na thread principal, numa transação: a conexão DMConfig.Conexao também
  //é usada pela tela e o FireDAC não permite usar a mesma conexão em duas threads ao mesmo tempo.
  //Só roda no clique em "Gerar relatório": abrir a tela Relatórios não grava nada (N1).

  if not FDMemTable1.Active then
    FDMemTable1.Open;

  //Tela Carregando antes de começar a gravar (glossário 8.15 e 8.16). Fluxo: Carregando ->
  //visualização do QuickReport -> volta para Relatórios, com sucesso ou erro (o finally garante
  //a volta e o menu reabilitado; nos erros a tela volta antes da mensagem)
  if Relatorio = trIBSCBS then
    Titulo := 'Gerando o Relatório IBS/CBS' + #$2026
  else
    Titulo := 'Gerando o Relatório de Notas' + #$2026;
  if FDMemTable1.RecordCount = 1 then
    Legenda := 'Gravando 1 nota e montando a visualização.'
  else
    Legenda := 'Gravando ' + IntToStr(FDMemTable1.RecordCount) + ' notas e montando a visualização.';

  IniciarCarregando(Titulo, Legenda);
  try
    Screen.Cursor := crHourGlass;
    try
      try
        DMConfig.GravarNotas(FDMemTable1);
      except
        on E: Exception do
        begin
          //GravarNotas já desfez a transação: o banco continua como estava (glossário 8.12)
          Screen.Cursor := crDefault;
          EncerrarCarregando(tlRelatorios);
          messagedlg('Não foi possível gravar as notas no banco de dados. O relatório não foi gerado.' +
                     sLineBreak + sLineBreak + 'Motivo: ' + E.Message, mtError, [mbOk], 0);
          Exit;
        end;
      end;
    finally
      Screen.Cursor := crDefault;
    end;

    //Gravação concluída: abre o relatório.
    //Se a geração ou a prévia falhar (ex.: 'Sem registros no banco de dados!'),
    //volta para Relatórios e mostra o erro (glossário 8.13)
    try
      FinalizaRelatorio(Relatorio);
    except
      on E: Exception do
      begin
        EncerrarCarregando(tlRelatorios);
        messagedlg('Não foi possível gerar o relatório.' + sLineBreak + sLineBreak + 'Motivo: ' + E.Message,
                   mtError, [mbOk], 0);
        DMConfig.CreateLog(E.ClassName, E.Message);
      end;
    end;
  finally
    EncerrarCarregando(tlRelatorios);
  end;
end;

procedure TFormPrincipal.LerConfigEmail;             
begin
    //Configurações do email
    ConfigEmail := DMConfig.GetConfig;

    ACBrMail1.Host        := Trim(ConfigEmail.SMTP);
    ACBrMail1.Port        := Trim(ConfigEmail.Porta);
    ACBrMail1.Username    := Trim(ConfigEmail.Email);
    ACBrMail1.Password    := Trim(ConfigEmail.Senha);
    ACBrMail1.From        := Trim(ConfigEmail.Email);
    ACBrMail1.SetSSL      := ConfigEmail.SSL; // SSL - Conexao Segura
    ACBrMail1.SetTLS      := ConfigEmail.TSL; // Auto TLS
    ACBrMail1.ReadingConfirmation := False; // Pede confirmacao de leitura do email
    ACBrMail1.UseThread := False;           // Aguarda Envio do Email(nao usa thread)
    ACBrMail1.FromName  := 'Projeto Pro XML';

    MemoMensagem.Text := ConfigEmail.Mensagem;
end;

procedure TFormPrincipal.EnviaArquivo(const Email, Assunto: string);
var
    ListaArquivos : TStringList;
    varPath: String;
begin
    //Envia arquivos
    varPath := ExtractFilePath(ParamStr(0));
    ListaArquivos := TStringList.Create;
    try
        if FileExists(varPath + 'NFCe\NFCe_ProXML.rar') then
            ListaArquivos.Add(varPath + 'NFCe\NFCe_ProXML.rar');

        if ListaArquivos.Count > 0 then
        begin
            ACBrNFe.EnviarEmail(Email, Assunto, MemoMensagem.Lines, nil, ListaArquivos, nil, '', nil);
            messagedlg('Email enviado com sucesso!!', mtInformation	, [mbOk], 0);
        end
        else
            messagedlg('Sem arquivos para enviar!', mtInformation	, [mbOk], 0);
    finally
        ListaArquivos.Free;
    end;
end;

procedure TFormPrincipal.SelecionarPastaClick(Sender: TObject);
begin
  //Clique no campo da pasta (ou no ícone dele) e no botão Selecionar…
  SelecionarPasta;
end;

procedure TFormPrincipal.SelecionarPasta;
begin
  //Selecionando a pasta de arquivos (cancelar não muda o campo)
  {$IFDEF MSWINDOWS}
    if FileOpenDialog1.Execute then
    begin
        EditCaminho.Text := FileOpenDialog1.FileName;
        GuardarUltimaPasta(EditCaminho.Text);
    end;
  {$ENDIF}
end;

procedure TFormPrincipal.SkSvg5Click(Sender: TObject);
begin
   //Ver senha
   if EditPass.PasswordChar = '*' then
        EditPass.PasswordChar := #0
    else
        EditPass.PasswordChar := '*';
end;

procedure TFormPrincipal.SpeedButton1Click(Sender: TObject);
var
  CalculadoraXML : TCalculadoraXML;
begin
  btnProcessar.Enabled := false;
  //Processar mostra o Resumo (log da leitura), com o item do menu sincronizado
  MostrarTela(tlResumo);

  Memo1.Lines.Clear;
  CalculadoraXML:=  TCalculadoraXML.Create;
  try

    //P3: "há pasta?" só olha se o campo está preenchido (a instrução fica no TextHint)
    if TemPasta then
    begin
      //Nova pasta: o seletor de modelo volta para "Todos" (grade, cards e relatórios)
      SeletorModelo.ItemIndex := 0;
      AplicarFiltroModelo;

      CalculadoraXML.CaminhoDiretorio := Trim(EditCaminho.Text);
      CalculadoraXML.ProcessarXMLs;
      AjustarAlturaLinhasGrade;
      DBGrid1.Refresh;
    end else
    begin
         //Só por segurança: sem pasta o botão fica desabilitado (glossário 2.13)
         messagedlg('Selecione uma pasta com XMLs.', mtInformation	, [mbOk], 0);
    end;

  finally
    CalculadoraXML.Free;
  end;
  MostrarTela(tlResumo);
  AtualizarEstadoProcessar;
  Gauge1.Progress := 0;
  Memo1.SetFocus;
end;

{ Plano 4, etapa 4.2: botões TProBotao, atalhos de teclado, rolagem e preferências da janela }

procedure TFormPrincipal.CriarBotoes;
begin
    //Os painéis Panel7, Panel11 e Panel9 do .dfm são só o ponto de encaixe.
    //Mesmos OnClick e textos de antes (os textos do glossário entram na etapa 4.7)
    btnProcessar    := TProBotao.CriarEm(Panel7,  'Processar', ebPrimario, SpeedButton1Click);
    btnEnviarEmail  := TProBotao.CriarEm(Panel11, 'Enviar',    ebPrimario, btnEnviarEmailClick);
    btnSalvarConfig := TProBotao.CriarEm(Panel9,  'Salvar',    ebPrimario, btnSalvarConfigClick);
end;

procedure TFormPrincipal.CriarAtalhos;

    function NovaAcao(const Atalho: TShortCut; const Executar, Atualizar: TNotifyEvent): TAction;
    begin
        Result := TAction.Create(Acoes);
        Result.ActionList := Acoes;
        Result.ShortCut   := Atalho;
        Result.OnExecute  := Executar;
        Result.OnUpdate   := Atualizar;
    end;

begin
    //Atalhos ligados às rotinas que já existem. As ações não têm texto: não aparecem na tela
    Acoes := TActionList.Create(Self);
    actSelecionarPasta := NovaAcao(Vcl.Menus.ShortCut(Ord('O'), [ssCtrl]), AcaoSelecionarPastaExecute, nil);
    actProcessar       := NovaAcao(Vcl.Menus.ShortCut(VK_F5, []), AcaoProcessarExecute, AcaoProcessarUpdate);
    actBuscar          := NovaAcao(Vcl.Menus.ShortCut(Ord('F'), [ssCtrl]), AcaoBuscarExecute, nil);
    actCopiarChave     := NovaAcao(Vcl.Menus.ShortCut(Ord('C'), [ssCtrl]), AcaoCopiarChaveExecute, AcaoCopiarChaveUpdate);
    actGerarDanfe      := NovaAcao(Vcl.Menus.ShortCut(Ord('D'), [ssCtrl]), AcaoGerarDanfeExecute, AcaoGerarDanfeUpdate);
end;

function TFormPrincipal.TemNotaNaGrade: Boolean;
begin
    Result := FDMemTable1.Active and (not FDMemTable1.IsEmpty);
end;

procedure TFormPrincipal.AcaoSelecionarPastaExecute(Sender: TObject);
begin
    //Ctrl+O: mesmo que clicar no campo da pasta ou em Selecionar…
    SelecionarPasta;
end;

procedure TFormPrincipal.AcaoProcessarExecute(Sender: TObject);
begin
    //F5: mesmo que clicar em Processar
    btnProcessar.Click;
end;

procedure TFormPrincipal.AcaoProcessarUpdate(Sender: TObject);
begin
    actProcessar.Enabled := btnProcessar.Enabled;
end;

procedure TFormPrincipal.AcaoBuscarExecute(Sender: TObject);
begin
    //Ctrl+F: a busca chega na etapa 4.5; por enquanto leva para a tela Notas (com o menu
    //sincronizado) e o foco para a grade de notas
    MostrarTela(tlNotas);
    if DBGrid1.CanFocus then
        DBGrid1.SetFocus;
end;

procedure TFormPrincipal.AcaoCopiarChaveExecute(Sender: TObject);
begin
    //Ctrl+C: mesmo que "Copiar Chave" do menu da grade
    GerarPDF1Click(GerarPDF1);
end;

procedure TFormPrincipal.AcaoCopiarChaveUpdate(Sender: TObject);
begin
    //Só com a grade em foco: nos campos de texto o Ctrl+C continua copiando o texto
    actCopiarChave.Enabled := (ActiveControl = DBGrid1) and TemNotaNaGrade;
end;

procedure TFormPrincipal.AcaoGerarDanfeExecute(Sender: TObject);
begin
    //Ctrl+D: mesmo que "Gerar DANFe" do menu da grade
    GerarDANFe1Click(GerarDANFe1);
end;

procedure TFormPrincipal.AcaoGerarDanfeUpdate(Sender: TObject);
begin
    //Só na tela Notas, com nota na grade e sem outro DANFE em andamento
    actGerarDanfe.Enabled := (TelaAtual = tlNotas) and TemNotaNaGrade and (not FGerandoDanfe);
end;

function TFormPrincipal.CriarRolagem(Painel: TPanel): TScrollBox;
var
    I        : Integer;
    Largura  : Integer;
    Altura   : Integer;
    Controle : TControl;
begin
    //Com a janela menor que o tamanho antigo (1136x699) as telas Enviar e Configurações não
    //cabem. O painel passa para dentro de uma caixa com rolagem e nunca fica menor que o
    //necessário para os seus controles: abaixo disso aparecem as barras de rolagem.
    //Provisório até o novo layout dessas telas (etapa 4.7).
    Largura := 0;
    Altura  := 0;
    for I := 0 to Painel.ControlCount - 1 do
    begin
        Controle := Painel.Controls[I];
        if Controle.Align = alNone then
        begin
            Largura := Max(Largura, Controle.Left + Controle.Width);
            Altura  := Max(Altura, Controle.Top + Controle.Height);
        end;
    end;

    Result := TScrollBox.Create(Self);
    Result.Parent           := Painel.Parent;
    Result.Align            := alClient;
    Result.BorderStyle      := bsNone;
    Result.ParentBackground := True;
    Result.HorzScrollBar.Tracking := True;
    Result.VertScrollBar.Tracking := True;

    Painel.Constraints.MinWidth  := Largura + Espaco1;
    Painel.Constraints.MinHeight := Altura + Espaco1;
    Painel.Align  := alNone;
    Painel.Parent := Result;
    Painel.SetBounds(0, 0, Max(Painel.Width, Painel.Constraints.MinWidth), Max(Painel.Height, Painel.Constraints.MinHeight));
    Result.OnResize := RolagemResize;
end;

procedure TFormPrincipal.RolagemResize(Sender: TObject);
var
    Caixa  : TScrollBox;
    Painel : TControl;
begin
    //O painel ocupa a caixa inteira, mas não encolhe abaixo do mínimo (aí entra a rolagem)
    Caixa := Sender as TScrollBox;
    if Caixa.ControlCount = 0 then
        Exit;

    Painel := Caixa.Controls[0];
    Painel.SetBounds(Painel.Left, Painel.Top,
                     Max(Caixa.ClientWidth, Painel.Constraints.MinWidth),
                     Max(Caixa.ClientHeight, Painel.Constraints.MinHeight));
end;

procedure TFormPrincipal.RegistrarFalhaPreferencias(E: Exception);
begin
    //As preferências não são essenciais: a falha vai para o LOG e a tela segue normalmente.
    //Se nem o LOG puder ser gravado (banco indisponível), resta a saída de depuração
    try
        DMConfig.CreateLog(E.ClassName, 'Preferências da tela: ' + E.Message);
    except
        on ELog: Exception do
            OutputDebugString(PChar('ProXML: ' + ELog.Message));
    end;
end;

procedure TFormPrincipal.GuardarUltimaPasta(const Pasta: string);
begin
    try
        DMConfig.GravarUltimaPasta(Pasta);
    except
        on E: Exception do
            RegistrarFalhaPreferencias(E);
    end;
end;

function TFormPrincipal.AjustarAreaVisivel(const Janela: TRect): TRect;
var
    Monitor : TMonitor;
    Area    : TRect;
    Largura : Integer;
    Altura  : Integer;
begin
    //Monitor onde a janela estava. Se ele não existe mais (a janela não toca nenhum monitor),
    //a janela é centralizada no monitor principal
    Monitor := Screen.MonitorFromRect(Janela, mdNull);
    if Monitor = nil then
    begin
        Area    := Screen.PrimaryMonitor.WorkareaRect;
        Largura := Min(Janela.Width, Area.Width);
        Altura  := Min(Janela.Height, Area.Height);
        Result  := Bounds(Area.Left + (Area.Width - Largura) div 2,
                          Area.Top + (Area.Height - Altura) div 2, Largura, Altura);
        Exit;
    end;

    //O monitor existe: a janela inteira fica dentro da área de trabalho dele
    Area    := Monitor.WorkareaRect;
    Largura := Min(Janela.Width, Area.Width);
    Altura  := Min(Janela.Height, Area.Height);
    Result  := Bounds(EnsureRange(Janela.Left, Area.Left, Area.Right - Largura),
                      EnsureRange(Janela.Top, Area.Top, Area.Bottom - Altura), Largura, Altura);
end;

procedure TFormPrincipal.RestaurarPreferencias;
var
    Pref   : TPreferencias;
    Janela : TRect;
begin
    try
        Pref := DMConfig.GetPreferencias;
    except
        on E: Exception do
        begin
            //Sem preferências a tela abre como antes (centralizada e sem pasta)
            RegistrarFalhaPreferencias(E);
            Exit;
        end;
    end;

    //Última pasta, se ela ainda existir. Se não existe mais, o campo fica vazio e o Resumo
    //mostra o aviso 2.14 numa faixa (sem caixa de diálogo ao abrir o app)
    if (Pref.UltimaPasta <> '') and SysUtils.DirectoryExists(Pref.UltimaPasta) then
        EditCaminho.Text := Pref.UltimaPasta
    else if Trim(Pref.UltimaPasta) <> '' then
        MostrarAvisoPastaNaoEncontrada(Pref.UltimaPasta);

    //Janela: tamanho e posição do estado normal, sempre dentro da área visível
    if Pref.TemJanela then
    begin
        Janela := AjustarAreaVisivel(Bounds(Pref.JanelaEsquerda, Pref.JanelaTopo,
                                            Pref.JanelaLargura, Pref.JanelaAltura));
        Position      := poDesigned;
        BoundsRect    := Janela;
        FJanelaNormal := BoundsRect;

        //Maximizada no monitor da posição normal (no principal, se aquele não existe mais).
        //A maximização fica para o FormShow (ver lá o motivo)
        FMaximizarAoMostrar := Pref.JanelaMaximizada;
    end;
end;

procedure TFormPrincipal.SalvarPreferencias;
var
    Maximizada : Boolean;
    Posicao    : TWindowPlacement;
begin
    if not HandleAllocated then
        Exit;

    //Maximizada agora, ou minimizada a partir do estado maximizado
    Maximizada := IsZoomed(Handle);
    if IsIconic(Handle) then
    begin
        FillChar(Posicao, SizeOf(Posicao), 0);
        Posicao.length := SizeOf(Posicao);
        if GetWindowPlacement(Handle, @Posicao) then
            Maximizada := (Posicao.flags and WPF_RESTORETOMAXIMIZED) <> 0;
    end;

    if FJanelaNormal.IsEmpty then
        FJanelaNormal := BoundsRect;

    try
        DMConfig.GravarJanela(FJanelaNormal.Left, FJanelaNormal.Top, FJanelaNormal.Width,
                              FJanelaNormal.Height, Maximizada);

        if SysUtils.DirectoryExists(EditCaminho.Text) then
            DMConfig.GravarUltimaPasta(EditCaminho.Text);
    except
        on E: Exception do
            RegistrarFalhaPreferencias(E);
    end;
end;

procedure TFormPrincipal.RegistrarJanelaNormal;
begin
    //Guarda posição e tamanho só no estado normal (maximizada ou minimizada não conta)
    if HandleAllocated and (not IsIconic(Handle)) and (not IsZoomed(Handle)) then
        FJanelaNormal := BoundsRect;
end;

procedure TFormPrincipal.WMMove(var Message: TWMMove);
begin
    inherited;
    RegistrarJanelaNormal;
end;

procedure TFormPrincipal.WMSize(var Message: TWMSize);
begin
    inherited;
    RegistrarJanelaNormal;
end;

{ Plano 4, etapa 4.3: cabeçalho, barra de pasta (arrastar e soltar, seletor segmentado) e cards }

function TFormPrincipal.PPIAtual: Integer;
begin
    //Escala atual da tela: a do último ScaleForPPI/WM_DPICHANGED; antes disso, a do .dfm
    Result := FPPIAtual;
    if Result < 30 then
        Result := PixelsPerInch;
end;

procedure TFormPrincipal.WMProXMLPPI(var Message: TMessage);
begin
    //Consulta dos controles próprios (TProBotao, TProSegmentado) via ProXML.Tema.PPIDoControle
    Message.Result := PPIAtual;
end;

function TFormPrincipal.Escalar(const Valor: Integer): Integer;
begin
    //Medidas do tema estão a 96 dpi
    Result := MulDiv(Valor, PPIAtual, 96);
end;

procedure TFormPrincipal.FonteNaEscala(Fonte: TFont; const Tamanho: Integer);
begin
    //Tamanho em pontos na escala atual da tela (Font.Size usaria a escala do sistema)
    Fonte.Height := -MulDiv(Tamanho, PPIAtual, 72);
end;

procedure TFormPrincipal.FixarTamanhoMinimo;
begin
    //Decisão de 20/10/2026: o mínimo é sempre 1024x640 pixels reais da tela, em qualquer escala
    //do Windows. A VCL multiplica as Constraints pelo DPI ao carregar o .dfm e ao trocar de
    //monitor (ChangeScale); aqui elas voltam para o valor do tema, sem escala
    Constraints.MinWidth  := JanelaLarguraMinima;
    Constraints.MinHeight := JanelaAlturaMinima;
end;

procedure TFormPrincipal.ScaleForPPI(NewPPI: Integer);
begin
    //Carga do .dfm (Loaded -> ScaleForCurrentDpi) e mudança de escala pedida pelo código
    inherited;
    if NewPPI >= 30 then
        FPPIAtual := NewPPI;
    AposMudarEscala;
end;

procedure TFormPrincipal.WMDpiChanged(var Message: TWMDpi);
begin
    //Janela levada para um monitor com outra escala: a VCL escala a tela sem passar pelo ScaleForPPI
    inherited;
    if Scaled and (Message.YDpi >= 30) then
        FPPIAtual := Message.YDpi;
    AposMudarEscala;
end;

procedure TFormPrincipal.AposMudarEscala;
begin
    FixarTamanhoMinimo;

    //Medidas calculadas no código (larguras da barra de pasta e borda do campo) seguem a nova escala
    if (not (csLoading in ComponentState)) and (SeletorModelo <> nil) then
    begin
        AjustarLargurasBarraPasta;
        AtualizarBordaCampoPasta(EditCaminho.Focused);
        AjustarFonteValoresCards;
        //Etapa 4.4: tela Relatórios e tela Carregando
        AjustarIndicadorFiltro;
        AjustarLayoutRelatorios;
        AjustarLayoutCarregando;
    end;
end;

procedure TFormPrincipal.CreateWnd;
begin
    inherited;
    //Aceita pastas e arquivos arrastados do Explorer (WM_DROPFILES). Refeito sempre que a
    //janela é recriada pela VCL
    DragAcceptFiles(Handle, True);
end;

procedure TFormPrincipal.DestroyWnd;
begin
    DragAcceptFiles(Handle, False);
    inherited;
end;

procedure TFormPrincipal.WMDropFiles(var Message: TWMDropFiles);
var
    Quantidade : Integer;
    Tamanho    : Integer;
    Caminho    : string;
begin
    //Itens soltos na janela: vale só o primeiro (pasta, ou a pasta do arquivo)
    try
        //Durante a espera do PDF do DANFE a tela processa mensagens: não troca a pasta no meio
        if FGerandoDanfe then
            Exit;

        Quantidade := DragQueryFile(Message.Drop, $FFFFFFFF, nil, 0);
        if Quantidade <= 0 then
            Exit;

        Tamanho := DragQueryFile(Message.Drop, 0, nil, 0);
        SetLength(Caminho, Tamanho);
        if Tamanho > 0 then
            DragQueryFile(Message.Drop, 0, PChar(Caminho), Tamanho + 1);

        UsarItemSolto(Caminho);
    finally
        DragFinish(Message.Drop);
        Message.Result := 0;
    end;
end;

function TFormPrincipal.UsarItemSolto(const Caminho: string): Boolean;
var
    Pasta: string;
begin
    //Pasta: usa ela mesma. Arquivo: usa a pasta onde ele está. Outra coisa: ignora
    Result := False;
    if SysUtils.DirectoryExists(Caminho) then
        Pasta := Caminho
    else if FileExists(Caminho) then
        Pasta := ExtractFileDir(Caminho)
    else
        Exit;

    EditCaminho.Text := Pasta;
    GuardarUltimaPasta(Pasta);
    Result := True;
end;

function TFormPrincipal.TemPasta: Boolean;
begin
    Result := Trim(EditCaminho.Text) <> '';
end;

procedure TFormPrincipal.AtualizarEstadoProcessar;
begin
    //Sem pasta, Processar fica desabilitado. A dica "Selecione uma pasta primeiro." fica no painel
    //de encaixe (Panel7): a VCL não mostra o hint de um controle desabilitado, mas mostra o do pai
    if btnProcessar <> nil then
        btnProcessar.Enabled := TemPasta;
end;

procedure TFormPrincipal.EditCaminhoChange(Sender: TObject);
begin
    AtualizarEstadoProcessar;

    //Dica do campo: o caminho completo (o campo pode cortar caminhos longos) + glossário 2.3
    if TemPasta then
        EditCaminho.Hint := Trim(EditCaminho.Text) + sLineBreak + 'Clique para escolher a pasta (Ctrl+O)'
    else
        EditCaminho.Hint := 'Clique para escolher a pasta (Ctrl+O)';

    //Outra pasta escolhida: o aviso de pasta não encontrada deixa de valer
    if TemPasta then
        PnlAvisoPasta.Visible := False;
end;

procedure TFormPrincipal.MostrarAvisoPastaNaoEncontrada(const Pasta: string);
var
    Medida: TBitmap;
begin
    //Faixa de aviso (tokens.md 5.8): fundo CorAvisoSuave, barra de 4 px e ícone triangle-alert
    //em CorAviso, texto 10 pt CorTexto. Texto do glossário 2.14, sem a linha em branco
    PnlAvisoPasta.Color      := CorAvisoSuave;
    PnlAvisoPastaBarra.Color := CorAviso;
    SkSvgAvisoPasta.Svg.Source        := IconeAviso;
    SkSvgAvisoPasta.Svg.OverrideColor := CorAlpha(CorAviso);
    AplicarFonte(LabelAvisoPasta.Font, FonteTexto, TamanhoCorpo, CorTexto);
    FPastaNaoEncontrada := Pasta;
    PnlAvisoPasta.Hint      := Pasta;
    PnlAvisoPasta.ShowHint  := True;
    PnlAvisoPasta.OnResize  := PnlAvisoPastaResize;
    PnlAvisoPastaResize(PnlAvisoPasta);

    //Altura para as 3 linhas + padding da faixa em cima e embaixo
    Medida := TBitmap.Create;
    try
        Medida.Canvas.Font.Assign(LabelAvisoPasta.Font);
        PnlAvisoPasta.Height := 3 * Medida.Canvas.TextHeight('Ag') + 2 * Escalar(PaddingFaixaVertical);
    finally
        Medida.Free;
    end;
    SkSvgAvisoPasta.Margins.Bottom := PnlAvisoPasta.Height - Escalar(PaddingFaixaVertical) - Escalar(TamanhoIconeMenu);

    PnlAvisoPasta.Visible := True;
end;

procedure TFormPrincipal.PnlAvisoPastaResize(Sender: TObject);
var
    Medida: TBitmap;
begin
    //Caminho longo sem espaços não quebra linha: encurta no meio ("C:\...\pasta") para caber
    //na largura da faixa; o caminho completo fica na dica
    if FPastaNaoEncontrada = '' then
        Exit;

    Medida := TBitmap.Create;
    try
        Medida.Canvas.Font.Assign(LabelAvisoPasta.Font);
        LabelAvisoPasta.Caption := 'A pasta não foi encontrada:' + sLineBreak +
                                   MinimizeName(FPastaNaoEncontrada, Medida.Canvas, LabelAvisoPasta.Width) +
                                   sLineBreak + 'Selecione outra pasta.';
    finally
        Medida.Free;
    end;
end;

procedure TFormPrincipal.EditCaminhoEnter(Sender: TObject);
begin
    AtualizarBordaCampoPasta(True);
end;

procedure TFormPrincipal.EditCaminhoExit(Sender: TObject);
begin
    AtualizarBordaCampoPasta(False);
end;

procedure TFormPrincipal.AtualizarBordaCampoPasta(const ComFoco: Boolean);
var
    Borda      : Integer;
    Diferenca  : Integer;
    Interno    : Integer;
    AlturaTexto: Integer;
    Medida     : TBitmap;
begin
    //Campo (tokens.md 5.3): borda de 1 px CorBordaCampo; com foco, 2 px CorPrimaria.
    //A borda é o painel de fora (cor + Padding); ao engrossar, o espaço interno diminui o mesmo
    //tanto para o ícone e o texto não mudarem de lugar
    if ComFoco then
    begin
        Borda := Escalar(BordaCampoFoco);
        PnlCampoPasta.Color := CorPrimaria;
    end
    else
    begin
        Borda := Escalar(BordaCampo);
        PnlCampoPasta.Color := CorBordaCampo;
    end;
    Diferenca := Borda - Escalar(BordaCampo);
    PnlCampoPasta.Padding.SetBounds(Borda, Borda, Borda, Borda);

    //Ícone de 16 px e texto centralizados na altura interna do campo
    Interno := Escalar(AlturaCampo) - 2 * Escalar(BordaCampo);
    Medida := TBitmap.Create;
    try
        Medida.Canvas.Font.Assign(EditCaminho.Font);
        AlturaTexto := Medida.Canvas.TextHeight('Ag');
    finally
        Medida.Free;
    end;

    SkSvgPasta.Margins.SetBounds(Escalar(PaddingCampo) - Diferenca,
                                 Max(0, (Interno - Escalar(TamanhoIconePequeno)) div 2 - Diferenca),
                                 0,
                                 Max(0, (Interno - Escalar(TamanhoIconePequeno)) div 2 - Diferenca));
    EditCaminho.Margins.SetBounds(Escalar(Espaco1),
                                  Max(0, (Interno - AlturaTexto) div 2 - Diferenca),
                                  Escalar(PaddingCampo) - Diferenca,
                                  Max(0, Interno - AlturaTexto - (Interno - AlturaTexto) div 2 - Diferenca));
end;

procedure TFormPrincipal.AplicarVisualCabecalho;
begin
    //Cabeçalho marinho de 48 px (tokens.md 4.1): logo vetorial à esquerda (SVG embutido no .dfm,
    //com as cores próprias do logo) e "Sobre" à direita
    PnlCabecalho.Color := CorMarinho;
    PnlSobre.Color     := CorMarinho;

    SkSvgSobre.Svg.Source        := IconeInfo;
    SkSvgSobre.Svg.OverrideColor := CorAlpha(CorMarinhoTexto);
    AplicarFonte(LabelSobre.Font, FonteTexto, TamanhoLegenda, CorMarinhoTexto);
    LabelSobre.Caption := 'Sobre';
    PnlSobre.Hint      := 'Sobre o ProXML';
    PnlSobre.ShowHint  := True;

    //A tela Sobre chega na etapa 4.7: por enquanto o link aparece, mas não tem ação
    PnlSobre.Enabled := False;
end;

procedure TFormPrincipal.CriarBarraPasta;
begin
    //Barra de pasta de 56 px (tokens.md 4.1): campo que estica, Selecionar…, Modelo e Processar
    PnlBarraPasta.Color      := CorSuperficie;
    PnlBarraPastaBorda.Color := CorBorda;
    PnlSelecionar.Color      := CorSuperficie;
    PnlModelo.Color          := CorSuperficie;
    Panel7.Color             := CorSuperficie;

    //Campo da pasta: clique no campo (ou no ícone) abre o seletor; a instrução fica só no TextHint
    PnlCampoPasta.Color      := CorBordaCampo;
    PnlCampoPastaFundo.Color := CorSuperficie;
    EditCaminho.Color        := CorSuperficie;
    AplicarFonte(EditCaminho.Font, FonteTexto, TamanhoCorpo, CorTexto);
    EditCaminho.TextHint := 'Selecione ou arraste uma pasta com XMLs de Nota Fiscal';
    EditCaminho.Hint     := 'Clique para escolher a pasta (Ctrl+O)';
    EditCaminho.ShowHint := True;
    EditCaminho.OnClick  := SelecionarPastaClick;
    EditCaminho.OnChange := EditCaminhoChange;
    EditCaminho.OnEnter  := EditCaminhoEnter;
    EditCaminho.OnExit   := EditCaminhoExit;
    PnlCampoPastaFundo.OnClick := SelecionarPastaClick;
    SkSvgPasta.OnClick         := SelecionarPastaClick;
    SkSvgPasta.Svg.Source        := IconePasta;
    SkSvgPasta.Svg.OverrideColor := CorAlpha(CorTextoSecundario);

    //Selecionar… (secundário) e Processar (primário, criado em CriarBotoes)
    btnSelecionar := TProBotao.CriarEm(PnlSelecionar, 'Selecionar'#$2026, ebSecundario, SelecionarPastaClick);
    btnSelecionar.IconeSvg := IconePastaAberta;
    btnSelecionar.Hint     := 'Escolher a pasta dos XMLs (Ctrl+O)';
    btnSelecionar.ShowHint := True;

    btnProcessar.IconeSvg := IconeProcessar;
    btnProcessar.Hint     := 'Ler os XMLs da pasta (F5)';
    btnProcessar.ShowHint := True;
    Panel7.Hint     := 'Selecione uma pasta primeiro.';
    Panel7.ShowHint := True;

    //Seletor de modelo em botões segmentados (D6): mesma ordem do seletor do Plano 1
    AplicarFonte(LabelFiltroModelo.Font, FonteTexto, TamanhoLegenda, CorTextoSecundario);
    LabelFiltroModelo.Caption := 'Modelo';
    SeletorModelo := TProSegmentado.Create(Self);
    SeletorModelo.Parent := PnlModelo;
    SeletorModelo.Align  := alClient;
    SeletorModelo.Itens.Add('Todos');
    SeletorModelo.Itens.Add('NF-e 55');
    SeletorModelo.Itens.Add('NFC-e 65');
    SeletorModelo.Dicas.Add('Todos: NF-e (55) e NFC-e (65)');
    SeletorModelo.Dicas.Add('Só NF-e (modelo 55)');
    SeletorModelo.Dicas.Add('Só NFC-e (modelo 65)');
    SeletorModelo.OnChange := SeletorModeloChange;

    AjustarLargurasBarraPasta;
    AtualizarBordaCampoPasta(False);
end;

procedure TFormPrincipal.AjustarLargurasBarraPasta;
begin
    //Os painéis de encaixe têm a largura do conteúdo; o campo da pasta fica com o resto.
    //A VCL ordena os controles alRight pela borda direita (Left + Width): ao mudar a largura a
    //ordem poderia trocar. Por isso a ordem (da direita para a esquerda: Processar, seletor,
    //"Modelo", Selecionar…) é fixada pelo Left antes de realinhar
    PnlBarraPasta.DisableAlign;
    try
        PnlSelecionar.Width := btnSelecionar.LarguraIdeal;
        PnlModelo.Width     := SeletorModelo.LarguraIdeal;
        Panel7.Width        := Escalar(LarguraBotaoDestaque) + 2 * btnProcessar.MargemFoco;

        Panel7.Left            := 30000;
        PnlModelo.Left         := 20000;
        LabelFiltroModelo.Left := 10000;
        PnlSelecionar.Left     := 0;
    finally
        PnlBarraPasta.EnableAlign;
    end;

    PnlSobre.Width := SkSvgSobre.Margins.Left + SkSvgSobre.Width + LabelSobre.Margins.Left +
                      LabelSobre.Width + LabelSobre.Margins.Right;
end;

procedure TFormPrincipal.PrepararCards;
var
    Cartoes : array[0..4] of TPanel;
    Fundos  : array[0..4] of TPanel;
    Rotulos : array[0..4] of TPanel;
    Icones  : array[0..4] of TSkSvg;
    Titulos : array[0..4] of TLabel;
    I       : Integer;
begin
    //Faixa de 5 cards no topo da área de conteúdo (D1; tokens.md 5.5): contêiner CorBorda com
    //1 px de Padding (a borda) e fundo CorSuperficie; ícone CorPrimaria + rótulo 9 pt na linha 1
    //e o valor 13 pt Semibold na linha 2
    PnlConteudo.Color := CorFundo;
    PnlCards.Color    := CorFundo;

    Cartoes[0] := PnlCardValorTotal; Fundos[0] := PnlCardValorTotalFundo; Rotulos[0] := PnlCardValorTotalRotulo;
    Cartoes[1] := PnlCardBaseICMS;   Fundos[1] := PnlCardBaseICMSFundo;   Rotulos[1] := PnlCardBaseICMSRotulo;
    Cartoes[2] := PnlCardICMS;       Fundos[2] := PnlCardICMSFundo;       Rotulos[2] := PnlCardICMSRotulo;
    Cartoes[3] := PnlCardIBS;        Fundos[3] := PnlCardIBSFundo;        Rotulos[3] := PnlCardIBSRotulo;
    Cartoes[4] := PnlCardCBS;        Fundos[4] := PnlCardCBSFundo;        Rotulos[4] := PnlCardCBSRotulo;
    Icones[0] := SkSvgCardValorTotal; Titulos[0] := LabelTituloValorTotal;
    Icones[1] := SkSvgCardBaseICMS;   Titulos[1] := LabelTituloBaseICMS;
    Icones[2] := SkSvgCardICMS;       Titulos[2] := LabelTituloICMS;
    Icones[3] := SkSvgCardIBS;        Titulos[3] := LabelTituloIBS;
    Icones[4] := SkSvgCardCBS;        Titulos[4] := LabelTituloCBS;

    Icones[0].Svg.Source := IconeValorTotal;
    Icones[1].Svg.Source := IconeBaseICMS;
    Icones[2].Svg.Source := IconeICMS;
    Icones[3].Svg.Source := IconeIBS;
    Icones[4].Svg.Source := IconeCBS;

    //Rótulos do glossário (4.1 a 4.5)
    Titulos[0].Caption := 'Valor Total';
    Titulos[1].Caption := 'Base ICMS';
    Titulos[2].Caption := 'ICMS';
    Titulos[3].Caption := 'IBS';
    Titulos[4].Caption := 'CBS';

    for I := Low(Cartoes) to High(Cartoes) do
    begin
        Cartoes[I].Color := CorBorda;
        Fundos[I].Color  := CorSuperficie;
        Rotulos[I].Color := CorSuperficie;
        Icones[I].Svg.OverrideColor := CorAlpha(CorPrimaria);
        AplicarFonte(Titulos[I].Font, FonteTexto, TamanhoLegenda, CorTextoSecundario);
    end;

    PnlCards.OnResize := PnlCardsResize;

    //D2: cards visíveis em Resumo, Notas, Relatórios e Carregando; ocultos em Enviar e Configurações.
    //O OnShow da aba dispara também quando a troca vem do código (ActivePageIndex)
    TabSheet1.OnShow  := PaginaShow;
    TabSheet2.OnShow  := PaginaShow;
    Relatorios.OnShow := PaginaShow;
    Loading.OnShow    := PaginaShow;
    Enviar.OnShow     := PaginaShow;
    Config.OnShow     := PaginaShow;
end;

procedure TFormPrincipal.PaginaShow(Sender: TObject);
var
    Tela: TTela;
begin
    //Sender é a aba que acabou de aparecer (o ActivePage ainda pode ser a anterior)
    Tela := TelaDaAba(Sender as TTabSheet);
    PnlCards.Visible := not (Tela in [tlEnviar, tlConfiguracoes]);

    //Garantia extra: o item ativo do menu acompanha a aba mesmo se ela for trocada direto no
    //PageControl (a troca normal passa por MostrarTela)
    SincronizarMenu(Tela);
end;

procedure TFormPrincipal.PnlCardsResize(Sender: TObject);
var
    Cartoes : array[0..4] of TPanel;
    Espaco  : Integer;
    Largura : Integer;
    Sobra   : Integer;
    X       : Integer;
    W       : Integer;
    I       : Integer;
begin
    //Os 5 cards têm a mesma largura e crescem com a janela; espaço de 8 px entre eles.
    //Os pixels que sobram da divisão vão 1 a 1 para os primeiros cards
    Cartoes[0] := PnlCardValorTotal;
    Cartoes[1] := PnlCardBaseICMS;
    Cartoes[2] := PnlCardICMS;
    Cartoes[3] := PnlCardIBS;
    Cartoes[4] := PnlCardCBS;

    Espaco  := Escalar(Espaco1);
    Largura := (PnlCards.ClientWidth - 4 * Espaco) div 5;
    Sobra   := PnlCards.ClientWidth - 4 * Espaco - 5 * Largura;
    X := 0;
    for I := Low(Cartoes) to High(Cartoes) do
    begin
        W := Largura;
        if I < Sobra then
            Inc(W);
        Cartoes[I].SetBounds(X, 0, W, PnlCards.ClientHeight);
        Inc(X, W + Espaco);
    end;

    AjustarFonteValoresCards;
end;

procedure TFormPrincipal.AtualizarVisualCards;
var
    Valores : array[0..4] of TLabel;
    I       : Integer;
begin
    //Com notas no filtro: valor 13 pt Semibold CorTexto. Sem notas: "R$ 0,00" 13 pt Regular
    //CorTextoSecundario (tokens.md 5.5). Um total zero com notas (ex.: IBS) continua em destaque
    Valores[0] := LabelValorTotal;
    Valores[1] := LabelbaseICMS;
    Valores[2] := LabelValorICMS;
    Valores[3] := LabelValorIBS;
    Valores[4] := LabelValorCBS;

    for I := Low(Valores) to High(Valores) do
    begin
        if TemNotaNaGrade then
            AplicarFonte(Valores[I].Font, FonteDestaque, TamanhoValorCard, CorTexto)
        else
            AplicarFonte(Valores[I].Font, FonteTexto, TamanhoValorCard, CorTextoSecundario);
        FonteNaEscala(Valores[I].Font, TamanhoValorCard);
    end;

    AjustarFonteValoresCards;
end;

procedure TFormPrincipal.AjustarFonteValoresCards;
var
    Valores : array[0..4] of TLabel;
    Medida  : TBitmap;
    I       : Integer;
    Tamanho : Integer;
begin
    //Valor maior que o card (ex.: R$ 10.000.000,00 em 1024 px): a fonte diminui 1 pt por vez,
    //até TamanhoValorCardMinimo, para o número nunca ser cortado (tokens.md 5.5)
    Valores[0] := LabelValorTotal;
    Valores[1] := LabelbaseICMS;
    Valores[2] := LabelValorICMS;
    Valores[3] := LabelValorIBS;
    Valores[4] := LabelValorCBS;

    Medida := TBitmap.Create;
    try
        for I := Low(Valores) to High(Valores) do
        begin
            Tamanho := TamanhoValorCard;
            FonteNaEscala(Valores[I].Font, Tamanho);
            Medida.Canvas.Font.Assign(Valores[I].Font);
            while (Medida.Canvas.TextWidth(Valores[I].Caption) > Valores[I].Width) and
                  (Tamanho > TamanhoValorCardMinimo) do
            begin
                Dec(Tamanho);
                FonteNaEscala(Valores[I].Font, Tamanho);
                Medida.Canvas.Font.Assign(Valores[I].Font);
            end;
        end;
    finally
        Medida.Free;
    end;
end;

{ Plano 4, etapa 4.4: menu lateral, navegação, tela Relatórios e tela Carregando }

procedure TFormPrincipal.CriarMenu;
const
    //Glossário 3.2 a 3.7 (sem o cabeçalho "Opções" e sem o espaço de 'Notas ')
    TEXTOS: array[TTelaMenu] of string = ('Resumo', 'Notas', 'Relatórios', 'Enviar', 'Configurações');
    ICONES: array[TTelaMenu] of string = (IconeResumo, IconeNotas, IconeRelatorios, IconeEnviar,
                                          IconeConfiguracoes);
    NOMES : array[TTelaMenu] of string = ('ItemMenuResumo', 'ItemMenuNotas', 'ItemMenuRelatorios',
                                          'ItemMenuEnviar', 'ItemMenuConfiguracoes');
var
    Tela: TTelaMenu;
begin
    //Menu lateral de 200 px (tokens.md 4.1 e 5.6): fundo CorSuperficie, divisória CorBorda à direita
    //e 5 itens de 40 px, o primeiro 8 px abaixo do topo. O menu só navega: abrir uma tela não grava,
    //não compacta e não envia nada (N1)
    PanelMenus.Color   := CorSuperficie;
    PnlMenuItens.Color := CorSuperficie;
    PnlMenuBorda.Color := CorBorda;
    PnlMenuBorda.Width := Escalar(BordaMenu);
    PnlMenuItens.Padding.Top := Escalar(TopoMenu);

    for Tela := Low(TTelaMenu) to High(TTelaMenu) do
    begin
        ItensMenu[Tela] := TProItemMenu.CriarNoMenu(PnlMenuItens, TEXTOS[Tela], ICONES[Tela], ItemMenuClick);
        ItensMenu[Tela].Name := NOMES[Tela];
        ItensMenu[Tela].Tag  := Ord(Tela);
    end;
    TProItemMenu.AjustarParadaTab(PnlMenuItens);

    //Ordem do Tab: barra de pasta -> menu (uma parada) -> conteúdo da tela. O PageControl1 não
    //recebe foco pelo Tab: as abas ficam escondidas e o foco nele não aparece na tela
    PageControl1.TabStop := False;
end;

procedure TFormPrincipal.ItemMenuClick(Sender: TObject);
var
    Tela: TTela;
begin
    //Clique, Enter ou Espaço num item do menu: só abre a tela
    Tela := TTela((Sender as TComponent).Tag);

    //Enviar: carrega a configuração do e-mail; os XMLs só são separados e compactados no
    //clique em "Enviar" da própria tela (btnEnviarEmailClick)
    if Tela = tlEnviar then
        LerConfigEmail;

    MostrarTela(Tela);
end;

function TFormPrincipal.AbaDaTela(const Tela: TTela): TTabSheet;
begin
    case Tela of
        tlResumo        : Result := TabSheet1;
        tlNotas         : Result := TabSheet2;
        tlRelatorios    : Result := Relatorios;
        tlEnviar        : Result := Enviar;
        tlConfiguracoes : Result := Config;
    else
        Result := Loading;
    end;
end;

function TFormPrincipal.TelaDaAba(const Aba: TTabSheet): TTela;
begin
    if Aba = TabSheet2 then
        Result := tlNotas
    else if Aba = Relatorios then
        Result := tlRelatorios
    else if Aba = Enviar then
        Result := tlEnviar
    else if Aba = Config then
        Result := tlConfiguracoes
    else if Aba = Loading then
        Result := tlCarregando
    else
        Result := tlResumo;
end;

function TFormPrincipal.TelaAtual: TTela;
begin
    Result := TelaDaAba(PageControl1.ActivePage);
end;

procedure TFormPrincipal.MostrarTela(const Tela: TTela);
var
    Aba: TTabSheet;
begin
    //Única rotina de troca de tela: mostra a aba da tela e sincroniza o item ativo do menu.
    //Nenhum outro ponto do código troca a aba do PageControl1
    Aba := AbaDaTela(Tela);
    if PageControl1.ActivePage <> Aba then
        PageControl1.ActivePage := Aba;

    //Relatórios e Carregando ocupam o PageControl inteiro (sem a moldura): realinha as abas
    PageControl1.Realign;

    //D2: os cards só somem em Enviar e Configurações
    PnlCards.Visible := not (Tela in [tlEnviar, tlConfiguracoes]);
    SincronizarMenu(Tela);

    if Tela = tlRelatorios then
        AtualizarTelaRelatorios;
end;

procedure TFormPrincipal.SincronizarMenu(const Tela: TTela);
var
    Item: TTelaMenu;
begin
    //Carregando não tem item no menu: o item da tela de origem continua destacado (mockup carregando.html)
    if Tela = tlCarregando then
        Exit;

    //Item ativo = tela exibida. Uma tela sem item (ex.: Sobre, etapa 4.7) deixa todos inativos
    for Item := Low(TTelaMenu) to High(TTelaMenu) do
        if ItensMenu[Item] <> nil then
            ItensMenu[Item].Ativo := (Ord(Item) = Ord(Tela));

    TProItemMenu.AjustarParadaTab(PnlMenuItens);
end;

procedure TFormPrincipal.HabilitarMenu(const Habilitar: Boolean);
var
    Item: TTelaMenu;
begin
    //Tokens 5.13: durante a tela Carregando os itens do menu ficam desabilitados
    for Item := Low(TTelaMenu) to High(TTelaMenu) do
        if ItensMenu[Item] <> nil then
            ItensMenu[Item].Enabled := Habilitar;
end;

function TFormPrincipal.TelaSemMoldura(const Tela: TTela): Boolean;
begin
    //Telas no visual novo, com os próprios quadros sobre CorFundo (mockups relatorios.html e
    //carregando.html): ocupam a área inteira do PageControl1, sem a moldura do controle.
    //As outras telas mantêm a moldura até as etapas delas (4.5 e 4.7)
    Result := Tela in [tlRelatorios, tlCarregando];
end;

procedure TFormPrincipal.JanelaPaginas(var Message: TMessage);
begin
    FJanelaPaginas(Message);

    //TCM_ADJUSTRECT (wParam = 0): área das abas dentro do controle. Nas telas sem moldura a aba
    //cobre o controle inteiro (a VCL soma 2 px no topo depois da mensagem: por isso o -2)
    if (Message.Msg = TCM_ADJUSTRECT) and (Message.WParam = 0) and (PageControl1.ActivePage <> nil) and
       TelaSemMoldura(TelaDaAba(PageControl1.ActivePage)) then
        PRect(Message.LParam)^ := Rect(0, -2, PageControl1.ClientWidth, PageControl1.ClientHeight);
end;

function TFormPrincipal.AlturaTextoQuebrado(Rotulo: TLabel; const Largura: Integer): Integer;
var
    Medida : TBitmap;
    Area   : TRect;
    Texto  : string;
begin
    //Altura do texto do rótulo quebrado em linhas na largura informada
    Medida := TBitmap.Create;
    try
        Medida.Canvas.Font.Assign(Rotulo.Font);
        Texto := Rotulo.Caption;
        if Texto = '' then
            Texto := 'Ag';
        Area := Rect(0, 0, Max(1, Largura), 0);
        DrawText(Medida.Canvas.Handle, PChar(Texto), Length(Texto), Area,
                 DT_CALCRECT or DT_WORDBREAK or DT_NOPREFIX);
        Result := Area.Bottom - Area.Top;
    finally
        Medida.Free;
    end;
end;

procedure TFormPrincipal.PrepararTelaRelatorios;
var
    Medida: TBitmap;
begin
    //Tela Relatórios (mockup relatorios.html; glossário 8.1 a 8.11): título e indicador do filtro,
    //um quadro para cada relatório com "Gerar relatório" e o rodapé 8.11. Abrir a tela não grava nada
    FJanelaPaginas := PageControl1.WindowProc;
    PageControl1.WindowProc := JanelaPaginas;

    PnlRelatorios.Color := CorFundo;
    PnlOpcoes.Color     := CorFundo;
    PnlOpcoes.OnResize  := PnlOpcoesResize;

    //Título 14 pt Semibold (8.1) numa linha de 32 px, 16 px acima dos quadros
    PnlRelatoriosTitulo.Color := CorFundo;
    PnlRelatoriosTitulo.AlignWithMargins := True;
    PnlRelatoriosTitulo.Margins.SetBounds(0, 0, 0, Escalar(Espaco2));
    PnlRelatoriosTitulo.Height := Escalar(AlturaTituloTela);
    AplicarFonte(LabelRelatoriosTitulo.Font, FonteDestaque, TamanhoTituloTela, CorTexto);
    LabelRelatoriosTitulo.Layout  := tlCenter;
    LabelRelatoriosTitulo.Caption := 'Relatórios';

    //Indicador do filtro à direita do título (8.2): borda CorBorda, fundo CorFundo, ícone file-text
    //de 14 px e texto 9 pt CorTexto
    PnlRelatoriosFiltro.Color := CorBorda;
    PnlRelatoriosFiltro.Padding.SetBounds(Escalar(BordaQuadro), Escalar(BordaQuadro), Escalar(BordaQuadro), Escalar(BordaQuadro));
    PnlRelatoriosFiltro.AlignWithMargins := True;
    PnlRelatoriosFiltroFundo.Color := CorFundo;
    PnlRelatoriosFiltroFundo.Padding.SetBounds(Escalar(PaddingChipHorizontal), Escalar(PaddingChipVertical),
                                               Escalar(PaddingChipHorizontal), Escalar(PaddingChipVertical));
    SkSvgRelatoriosFiltro.Svg.Source        := IconeNotas;
    SkSvgRelatoriosFiltro.Svg.OverrideColor := CorAlpha(CorTexto);
    SkSvgRelatoriosFiltro.Width             := Escalar(TamanhoIconeDica);
    SkSvgRelatoriosFiltro.AlignWithMargins  := True;
    AplicarFonte(LabelRelatoriosFiltro.Font, FonteTexto, TamanhoLegenda, CorTexto);
    LabelRelatoriosFiltro.AlignWithMargins := True;
    LabelRelatoriosFiltro.Margins.SetBounds(Escalar(EspacoIconeChip), 0, 0, 0);
    LabelRelatoriosFiltro.Layout := tlCenter;

    //Quadros dos dois relatórios (8.3 a 8.7). "Gerar relatório" é TProBotao primário com printer
    btnGerarRelNotas  := TProBotao.CriarEm(PnlGerarNotas,  'Gerar relatório', ebPrimario, GerarRelatorioNotasClick);
    btnGerarRelIBSCBS := TProBotao.CriarEm(PnlGerarIBSCBS, 'Gerar relatório', ebPrimario, GerarRelatorioIBSCBSClick);
    PrepararOpcaoRelatorio(PnlOpcaoNotas, PnlOpcaoNotasFundo, PnlOpcaoNotasTitulo, SkSvgOpcaoNotas,
                           LabelOpcaoNotasTitulo, LabelOpcaoNotasDescricao, PnlOpcaoNotasRodape, PnlGerarNotas,
                           SkSvgDicaNotas, LabelDicaNotas, btnGerarRelNotas);
    PrepararOpcaoRelatorio(PnlOpcaoIBSCBS, PnlOpcaoIBSCBSFundo, PnlOpcaoIBSCBSTitulo, SkSvgOpcaoIBSCBS,
                           LabelOpcaoIBSCBSTitulo, LabelOpcaoIBSCBSDescricao, PnlOpcaoIBSCBSRodape, PnlGerarIBSCBS,
                           SkSvgDicaIBSCBS, LabelDicaIBSCBS, btnGerarRelIBSCBS);
    SkSvgOpcaoNotas.Svg.Source  := IconeNotas;
    SkSvgOpcaoIBSCBS.Svg.Source := IconeIBS;
    LabelOpcaoNotasTitulo.Caption    := 'Relatório de Notas';
    LabelOpcaoNotasDescricao.Caption := 'Nº, modelo, data, chave, valor da nota, base de cálculo do ICMS e ICMS ' +
                                        'de cada nota, com os totais no fim.';
    LabelOpcaoIBSCBSTitulo.Caption   := 'Relatório IBS/CBS';

    //Linha do título do quadro: a maior entre o ícone de 20 px e o texto de 12 pt
    Medida := TBitmap.Create;
    try
        Medida.Canvas.Font.Assign(LabelOpcaoNotasTitulo.Font);
        PnlOpcaoNotasTitulo.Height := Max(Escalar(TamanhoIconeMenu), Medida.Canvas.TextHeight('Ag'));
        PnlOpcaoIBSCBSTitulo.Height := PnlOpcaoNotasTitulo.Height;
    finally
        Medida.Free;
    end;
    SkSvgOpcaoNotas.Margins.SetBounds(0, (PnlOpcaoNotasTitulo.Height - Escalar(TamanhoIconeMenu)) div 2, 0,
        PnlOpcaoNotasTitulo.Height - Escalar(TamanhoIconeMenu) - (PnlOpcaoNotasTitulo.Height - Escalar(TamanhoIconeMenu)) div 2);
    SkSvgOpcaoIBSCBS.Margins.Assign(SkSvgOpcaoNotas.Margins);

    //Rodapé da tela (8.11): legenda 9 pt CorTextoSecundario, 16 px abaixo dos quadros
    AplicarFonte(LabelRelatoriosRodape.Font, FonteTexto, TamanhoLegenda, CorTextoSecundario);
    LabelRelatoriosRodape.AlignWithMargins := True;
    LabelRelatoriosRodape.Margins.SetBounds(0, Escalar(Espaco2), 0, 0);
    LabelRelatoriosRodape.WordWrap := True;
    LabelRelatoriosRodape.Caption  := 'Os relatórios usam as notas do modelo selecionado na barra de cima. ' +
                                      'A busca da tela Notas não é aplicada.';
end;

procedure TFormPrincipal.PrepararOpcaoRelatorio(Borda, Fundo, Titulo: TPanel; Icone: TSkSvg; Rotulo,
  Descricao: TLabel; Rodape, Encaixe: TPanel; IconeDica: TSkSvg; Dica: TLabel; Botao: TProBotao);
var
    Margem: Integer;
begin
    //Quadro de um relatório (mockup .opc): borda CorBorda de 1 px, fundo CorSuperficie e padding 16;
    //título 12 pt Semibold com ícone de 20 px CorPrimaria, descrição 10 pt CorTextoSecundario e, embaixo,
    //"Gerar relatório" com a dica visível ao lado (ícone info 14 px + texto 9 pt CorTextoSecundario).
    //O painel de encaixe do botão tem a margem do contorno de foco em volta da face: o padding esquerdo
    //e o de baixo do quadro descontam essa margem para a face ficar alinhada ao texto
    Margem := Botao.MargemFoco;
    Borda.Color := CorBorda;
    Borda.Padding.SetBounds(Escalar(BordaQuadro), Escalar(BordaQuadro), Escalar(BordaQuadro), Escalar(BordaQuadro));
    Fundo.Color := CorSuperficie;
    Fundo.Padding.SetBounds(Escalar(PaddingOpcao) - Margem, Escalar(PaddingOpcao), Escalar(PaddingOpcao),
                            Escalar(PaddingOpcao) - Margem);

    Titulo.Color := CorSuperficie;
    Titulo.AlignWithMargins := True;
    Titulo.Margins.SetBounds(Margem, 0, 0, Escalar(Espaco1));
    Icone.Width := Escalar(TamanhoIconeMenu);
    Icone.AlignWithMargins := True;
    Icone.Svg.OverrideColor := CorAlpha(CorPrimaria);
    AplicarFonte(Rotulo.Font, FonteDestaque, TamanhoSubtitulo, CorTexto);
    Rotulo.AlignWithMargins := True;
    Rotulo.Margins.SetBounds(Escalar(Espaco1), 0, 0, 0);
    Rotulo.Layout := tlCenter;

    AplicarFonte(Descricao.Font, FonteTexto, TamanhoCorpo, CorTextoSecundario);
    Descricao.AlignWithMargins := True;
    Descricao.Margins.SetBounds(Margem, 0, 0, Escalar(Espaco1) - Margem);
    Descricao.AutoSize := False;
    Descricao.WordWrap := True;

    Rodape.Color  := CorSuperficie;
    Encaixe.Color := CorSuperficie;
    Encaixe.AlignWithMargins := True;
    Botao.IconeSvg := IconeRelatorios;
    Botao.Hint     := 'Gravar as notas e abrir a visualização do relatório';
    Botao.ShowHint := True;
    Encaixe.Width  := Botao.LarguraIdeal;

    IconeDica.Svg.Source        := IconeInfo;
    IconeDica.Svg.OverrideColor := CorAlpha(CorTextoSecundario);
    IconeDica.Width             := Escalar(TamanhoIconeDica);
    IconeDica.AlignWithMargins  := True;
    AplicarFonte(Dica.Font, FonteTexto, TamanhoLegenda, CorTextoSecundario);
    Dica.AlignWithMargins := True;
    Dica.Margins.SetBounds(Escalar(EspacoMeio), 0, 0, 0);
    Dica.Layout   := tlCenter;
    Dica.WordWrap := True;

    //Ordem da esquerda para a direita: botão, ícone da dica, texto da dica
    Encaixe.Left   := 0;
    IconeDica.Left := Encaixe.Left + Encaixe.Width + 1;
end;

procedure TFormPrincipal.MostrarDica(IconeDica: TSkSvg; Dica: TLabel; const Texto: string);
begin
    //Dica visível ao lado do botão desabilitado (tokens.md 5.12: o hint de um controle desabilitado
    //não aparece na VCL). Texto vazio: sem dica
    Dica.Caption      := Texto;
    Dica.Visible      := Texto <> '';
    IconeDica.Visible := Texto <> '';
    //alLeft: o ícone volta sempre depois do botão
    if IconeDica.Visible then
        IconeDica.Left := IconeDica.Parent.ClientWidth;
end;

procedure TFormPrincipal.AtualizarTelaRelatorios;
var
    Carregadas: Integer;
    Total     : Integer;
    ComIBSCBS : Integer;
    Descricao : string;

    function QuantidadeNotas(const N: Integer): string;
    begin
        if N = 1 then
            Result := '1 nota'
        else
            Result := IntToStr(N) + ' notas';
    end;

begin
    //Glossário 8.2 a 8.10, sempre com as notas do filtro de modelo atual (a busca da tela Notas não
    //entra: decisão D5). Só atualiza a tela: nada é gravado ao abrir ou atualizar a tela Relatórios
    if (SeletorModelo = nil) or (btnGerarRelNotas = nil) or (btnGerarRelIBSCBS = nil) then
        Exit;

    Carregadas := 0;
    Total      := 0;
    if FDMemTable1.Active then
    begin
        Carregadas := FDMemTable1.Table.Rows.Count;   //todas as notas lidas, sem o filtro de modelo
        Total      := FDMemTable1.RecordCount;        //notas do filtro de modelo atual
    end;
    ComIBSCBS := FTotais.QuantidadeIBSCBS;

    //Indicador do filtro (8.2)
    if Carregadas = 0 then
        LabelRelatoriosFiltro.Caption := 'Nenhuma nota carregada'
    else
        LabelRelatoriosFiltro.Caption := 'Modelo: ' + SeletorModelo.Itens[SeletorModelo.ItemIndex] + ' ' + #$00B7 +
                                         ' ' + QuantidadeNotas(Total);

    //Relatório IBS/CBS (8.6): a contagem só aparece com notas no filtro (mockup, estado sem dados)
    Descricao := 'Base IBS/CBS, IBS UF, IBS municipal, IBS e CBS das notas que têm o grupo IBS/CBS.';
    if Total = 1 then
        Descricao := Descricao + ' ' + IntToStr(ComIBSCBS) + ' de 1 nota tem IBS/CBS.'
    else if Total > 1 then
        Descricao := Descricao + ' ' + IntToStr(ComIBSCBS) + ' de ' + IntToStr(Total) + ' notas têm IBS/CBS.';
    LabelOpcaoIBSCBSDescricao.Caption := Descricao;

    //Botões e dicas visíveis: sem notas carregadas, os dois desabilitados (8.8); com notas carregadas
    //mas nenhuma no filtro de modelo, os dois desabilitados (8.8a); com notas e nenhuma com
    //IBS/CBS no filtro, só o IBS/CBS (8.10)
    btnGerarRelNotas.Enabled  := Total > 0;
    btnGerarRelIBSCBS.Enabled := (Total > 0) and (ComIBSCBS > 0);
    if (Total = 0) and (Carregadas > 0) then
    begin
        MostrarDica(SkSvgDicaNotas,  LabelDicaNotas,  'Nenhuma nota do modelo selecionado. Escolha outro modelo na barra de cima.');
        MostrarDica(SkSvgDicaIBSCBS, LabelDicaIBSCBS, 'Nenhuma nota do modelo selecionado. Escolha outro modelo na barra de cima.');
    end
    else if Total = 0 then
    begin
        MostrarDica(SkSvgDicaNotas,  LabelDicaNotas,  'Processe uma pasta para gerar relatórios.');
        MostrarDica(SkSvgDicaIBSCBS, LabelDicaIBSCBS, 'Processe uma pasta para gerar relatórios.');
    end
    else
    begin
        MostrarDica(SkSvgDicaNotas, LabelDicaNotas, '');
        if ComIBSCBS = 0 then
            MostrarDica(SkSvgDicaIBSCBS, LabelDicaIBSCBS, 'Nenhuma nota do modelo selecionado tem IBS/CBS.')
        else
            MostrarDica(SkSvgDicaIBSCBS, LabelDicaIBSCBS, '');
    end;

    AjustarIndicadorFiltro;
    AjustarLayoutRelatorios;
end;

procedure TFormPrincipal.AjustarIndicadorFiltro;
var
    Medida      : TBitmap;
    LarguraTexto: Integer;
    AlturaTexto : Integer;
    Altura      : Integer;
    Interno     : Integer;
    Folga       : Integer;
begin
    //Indicador do filtro (mockup .chip): largura do texto + ícone + paddings, centralizado na linha do título
    Medida := TBitmap.Create;
    try
        Medida.Canvas.Font.Assign(LabelRelatoriosFiltro.Font);
        LarguraTexto := Medida.Canvas.TextWidth(LabelRelatoriosFiltro.Caption);
        AlturaTexto  := Medida.Canvas.TextHeight('Ag');
    finally
        Medida.Free;
    end;

    Interno := Max(Escalar(TamanhoIconeDica), AlturaTexto);
    Altura  := Interno + 2 * Escalar(PaddingChipVertical) + 2 * Escalar(BordaQuadro);
    Folga   := Max(0, PnlRelatoriosTitulo.Height - Altura);
    PnlRelatoriosFiltro.Margins.SetBounds(0, Folga div 2, 0, Folga - Folga div 2);
    PnlRelatoriosFiltro.Width := 2 * Escalar(BordaQuadro) + 2 * Escalar(PaddingChipHorizontal) +
                                 Escalar(TamanhoIconeDica) + Escalar(EspacoIconeChip) + LarguraTexto;
    SkSvgRelatoriosFiltro.Margins.SetBounds(0, (Interno - Escalar(TamanhoIconeDica)) div 2, 0,
                                            Interno - Escalar(TamanhoIconeDica) - (Interno - Escalar(TamanhoIconeDica)) div 2);
end;

procedure TFormPrincipal.AjustarLayoutRelatorios;
var
    Margem          : Integer;
    Espaco          : Integer;
    Largura         : Integer;
    LarguraTexto    : Integer;
    LarguraDica     : Integer;
    AlturaDescricao : Integer;
    AlturaBotaoEncx : Integer;
    AlturaRodape    : Integer;
    Altura          : Integer;

    procedure AjustarRodape(Rodape, Encaixe: TPanel; IconeDica: TSkSvg);
    var
        Folga: Integer;
    begin
        Rodape.Height := AlturaRodape;
        Folga := AlturaRodape - AlturaBotaoEncx;
        Encaixe.Margins.SetBounds(0, Folga div 2, 0, Folga - Folga div 2);
        Folga := AlturaRodape - Escalar(TamanhoIconeDica);
        IconeDica.Margins.SetBounds(Escalar(EspacoDica) - Margem, Folga div 2, 0, Folga - Folga div 2);
    end;

begin
    //Dois quadros lado a lado com a mesma largura e a mesma altura (espaço de 16 px entre eles).
    //A altura vem da maior descrição e da dica, que pode quebrar em duas linhas em 1024 px
    if (btnGerarRelNotas = nil) or FAjustandoRelatorios then
        Exit;

    FAjustandoRelatorios := True;
    try
        Margem  := btnGerarRelNotas.MargemFoco;
        Espaco  := Escalar(Espaco2);
        Largura := (PnlOpcoes.ClientWidth - Espaco) div 2;
        if Largura <= 0 then
            Exit;

        //Largura do texto dentro do quadro: borda e padding dos dois lados
        LarguraTexto := Largura - 2 * Escalar(BordaQuadro) - 2 * Escalar(PaddingOpcao);
        AlturaDescricao := Max(AlturaTextoQuebrado(LabelOpcaoNotasDescricao, LarguraTexto),
                               AlturaTextoQuebrado(LabelOpcaoIBSCBSDescricao, LarguraTexto));
        LabelOpcaoNotasDescricao.Height  := AlturaDescricao;
        LabelOpcaoIBSCBSDescricao.Height := AlturaDescricao;

        //Rodapé: face do botão (32 px) com a margem do foco; a dica pode precisar de mais altura
        AlturaBotaoEncx := Escalar(AlturaBotao) + 2 * Margem;
        AlturaRodape    := AlturaBotaoEncx;
        LarguraDica := LarguraTexto + Margem - PnlGerarNotas.Width - (Escalar(EspacoDica) - Margem) -
                       Escalar(TamanhoIconeDica) - Escalar(EspacoMeio);
        if LabelDicaNotas.Visible then
            AlturaRodape := Max(AlturaRodape, AlturaTextoQuebrado(LabelDicaNotas, LarguraDica));
        LarguraDica := LarguraTexto + Margem - PnlGerarIBSCBS.Width - (Escalar(EspacoDica) - Margem) -
                       Escalar(TamanhoIconeDica) - Escalar(EspacoMeio);
        if LabelDicaIBSCBS.Visible then
            AlturaRodape := Max(AlturaRodape, AlturaTextoQuebrado(LabelDicaIBSCBS, LarguraDica));
        AjustarRodape(PnlOpcaoNotasRodape, PnlGerarNotas, SkSvgDicaNotas);
        AjustarRodape(PnlOpcaoIBSCBSRodape, PnlGerarIBSCBS, SkSvgDicaIBSCBS);

        Altura := 2 * Escalar(BordaQuadro) + PnlOpcaoNotasFundo.Padding.Top +
                  PnlOpcaoNotasTitulo.Height + PnlOpcaoNotasTitulo.Margins.Bottom +
                  AlturaDescricao + LabelOpcaoNotasDescricao.Margins.Bottom +
                  AlturaRodape + PnlOpcaoNotasFundo.Padding.Bottom;

        PnlOpcoes.Height := Altura;
        PnlOpcaoNotas.SetBounds(0, 0, Largura, Altura);
        PnlOpcaoIBSCBS.SetBounds(Largura + Espaco, 0, PnlOpcoes.ClientWidth - Largura - Espaco, Altura);
    finally
        FAjustandoRelatorios := False;
    end;
end;

procedure TFormPrincipal.PnlOpcoesResize(Sender: TObject);
begin
    AjustarLayoutRelatorios;
end;

procedure TFormPrincipal.GerarRelatorioNotasClick(Sender: TObject);
begin
    //"Gerar relatório" do Relatório de Notas: grava as notas do filtro e abre a visualização
    GerarRelatorio(trNotas);
end;

procedure TFormPrincipal.GerarRelatorioIBSCBSClick(Sender: TObject);
begin
    //"Gerar relatório" do Relatório IBS/CBS
    GerarRelatorio(trIBSCBS);
end;

procedure TFormPrincipal.PrepararTelaCarregando;
begin
    //Tela Carregando (tokens.md 5.14; mockup carregando.html): quadro CorSuperficie com borda CorBorda,
    //animação Lottie do ProXML.FrameLoad (160x134) centralizada, a operação em 12 pt Semibold e a
    //legenda em 10 pt CorTextoSecundario
    PnlCarregando.Color := CorBorda;
    PnlCarregando.Padding.SetBounds(Escalar(BordaQuadro), Escalar(BordaQuadro), Escalar(BordaQuadro), Escalar(BordaQuadro));
    PnlCarregandoFundo.Color    := CorSuperficie;
    PnlCarregandoFundo.OnResize := PnlCarregandoFundoResize;
    PnlAnimacao.Color := CorSuperficie;
    PnlAnimacao.SetBounds(0, 0, Escalar(LarguraAnimacao), Escalar(AlturaAnimacao));
    AplicarFonte(LabelCarregandoTitulo.Font, FonteDestaque, TamanhoSubtitulo, CorTexto);
    AplicarFonte(LabelCarregandoLegenda.Font, FonteTexto, TamanhoCorpo, CorTextoSecundario);
    LabelCarregandoTitulo.Caption  := '';
    LabelCarregandoLegenda.Caption := '';

    //Frame com a animação (TSkAnimatedImage), criado aqui e ocupando o painel da animação
    FFrameCarregando := TFrameLoad.Create(Self);
    FFrameCarregando.Parent := PnlAnimacao;
    FFrameCarregando.Align  := alClient;
    FFrameCarregando.Panel1.ParentBackground := False;
    FFrameCarregando.Panel1.Color := CorSuperficie;
    FFrameCarregando.SkAnimatedImage1.Anchors := [akLeft, akTop];
    FFrameCarregando.SkAnimatedImage1.Align   := alClient;
    FFrameCarregando.SkAnimatedImage1.Animation.Loop := True;
end;

procedure TFormPrincipal.AjustarLayoutCarregando;
var
    Medida        : TBitmap;
    Espaco        : Integer;
    AlturaTitulo  : Integer;
    AlturaLegenda : Integer;
    Topo          : Integer;
    Largura       : Integer;
begin
    //Animação, operação e legenda empilhadas (12 px entre elas) no centro do quadro
    Medida := TBitmap.Create;
    try
        Medida.Canvas.Font.Assign(LabelCarregandoTitulo.Font);
        AlturaTitulo := Medida.Canvas.TextHeight('Ag');
        Medida.Canvas.Font.Assign(LabelCarregandoLegenda.Font);
        AlturaLegenda := Medida.Canvas.TextHeight('Ag');
    finally
        Medida.Free;
    end;

    Espaco  := Escalar(EspacoCarregando);
    Largura := PnlCarregandoFundo.ClientWidth;
    Topo    := Max(0, (PnlCarregandoFundo.ClientHeight -
                       (PnlAnimacao.Height + Espaco + AlturaTitulo + Espaco + AlturaLegenda)) div 2);
    PnlAnimacao.SetBounds((Largura - PnlAnimacao.Width) div 2, Topo, PnlAnimacao.Width, PnlAnimacao.Height);
    LabelCarregandoTitulo.SetBounds(0, Topo + PnlAnimacao.Height + Espaco, Largura, AlturaTitulo);
    LabelCarregandoLegenda.SetBounds(0, LabelCarregandoTitulo.Top + AlturaTitulo + Espaco, Largura, AlturaLegenda);
end;

procedure TFormPrincipal.PnlCarregandoFundoResize(Sender: TObject);
begin
    AjustarLayoutCarregando;
end;

procedure TFormPrincipal.IniciarCarregando(const Titulo, Legenda: string);
begin
    //Abre a tela Carregando. Enquanto ela estiver aberta só os itens do menu ficam bloqueados
    //(decisão da 4.4; o bloqueio da barra de pasta, do Processar e do filtro, H4, fica para a 4.6).
    //Quem abre a tela chama EncerrarCarregando num finally: o menu volta em qualquer caminho
    FFocoAntesCarregando := ActiveControl;
    LabelCarregandoTitulo.Caption  := Titulo;
    LabelCarregandoLegenda.Caption := Legenda;
    FCarregando := True;
    HabilitarMenu(False);
    MostrarTela(tlCarregando);
    AjustarLayoutCarregando;
    if FFrameCarregando <> nil then
        FFrameCarregando.SkAnimatedImage1.Animation.Start;

    //A gravação no banco e a montagem do relatório rodam na thread principal sem processar
    //mensagens: a tela é pintada agora, antes do trabalho pesado. Na espera do PDF do DANFE as
    //mensagens são processadas e a animação continua rodando
    if PnlCorpo.HandleAllocated then
        RedrawWindow(PnlCorpo.Handle, nil, 0, RDW_INVALIDATE or RDW_ERASE or RDW_ALLCHILDREN or RDW_UPDATENOW);
end;

procedure TFormPrincipal.EncerrarCarregando(const Destino: TTela);
begin
    //Fecha a tela Carregando e volta para a tela de origem (só na primeira chamada)
    if not FCarregando then
        Exit;

    FCarregando := False;
    try
        if FFrameCarregando <> nil then
            FFrameCarregando.SkAnimatedImage1.Animation.Stop;
        MostrarTela(Destino);
    finally
        HabilitarMenu(True);
    end;

    //O foco volta para onde estava (grade de notas, botão "Gerar relatório"), se ainda puder
    if (FFocoAntesCarregando <> nil) and FFocoAntesCarregando.CanFocus then
        FFocoAntesCarregando.SetFocus;
    FFocoAntesCarregando := nil;
end;

end.
