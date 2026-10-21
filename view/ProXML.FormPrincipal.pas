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

  //Pintura do título de uma coluna da grade de notas (feita pela tela, com as cores do tema)
  TDesenharTituloGrade = procedure(Sender: TObject; const Area: TRect; Coluna: TColumn) of object;

  { Grade de notas (Plano 4, etapa 4.5; tokens.md 5.7). Classe intermediária com o mesmo nome do
    TDBGrid da VCL: o .dfm continua declarando um TDBGrid comum e, em runtime, a grade ganha:
    - altura fixa do título e das linhas, reaplicada sempre que a VCL recalcula as alturas (o TDBGrid
      mede o título pela fonte a cada mudança de layout); fora do OnDrawColumnCell;
    - título desenhado pela tela (OnDesenharTitulo): o TDBGrid não tem evento de pintura do título
      e escreve o texto colado no topo da célula;
    - aviso de redimensionamento (OnRedimensionar), inclusive quando a barra de rolagem aparece;
    - aviso de clique numa nota (OnCliqueNota), com o botão esquerdo ou o direito: o TDBGrid move a
      nota atual no clique, mas não dispara o OnMouseDown nas linhas de dados. }
  TDBGrid = class(Vcl.DBGrids.TDBGrid)
  private
    FAlturaTitulo     : Integer;
    FAlturaLinha      : Integer;
    FAplicandoAlturas : Boolean;
    FUltimoClique     : TPoint;
    FOnDesenharTitulo : TDesenharTituloGrade;
    FOnRedimensionar  : TNotifyEvent;
    FOnCliqueNota     : TNotifyEvent;
    procedure AplicarAlturas;
  protected
    procedure RowHeightsChanged; override;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
    procedure Resize; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    //Alturas em pixels (já na escala da tela) do título e das linhas de dados
    procedure DefinirAlturas(const AlturaTitulo, AlturaLinha: Integer);
    //Linha de dados no ponto (coordenadas da grade): True se o ponto está sobre uma nota
    function PontoEmNota(const X, Y: Integer): Boolean;
    //O último clique (inclusive o duplo) foi sobre uma nota
    function UltimoCliqueEmNota: Boolean;
    property OnDesenharTitulo: TDesenharTituloGrade read FOnDesenharTitulo write FOnDesenharTitulo;
    property OnRedimensionar: TNotifyEvent read FOnRedimensionar write FOnRedimensionar;
    property OnCliqueNota: TNotifyEvent read FOnCliqueNota write FOnCliqueNota;
  end;

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
    //Tela Notas (etapa 4.5; mockup notas.html e glossário 6.1 a 6.32): linha de título com contador,
    //ações e busca; grade com estado vazio e aviso flutuante "Chave copiada" por cima
    PnlNotas: TPanel;
    PnlNotasTitulo: TPanel;
    LabelNotasTitulo: TLabel;
    LabelNotasContador: TLabel;
    PnlCopiarChave: TPanel;
    PnlGerarDanfe: TPanel;
    PnlExportarCSV: TPanel;
    PnlCampoBusca: TPanel;
    PnlCampoBuscaFundo: TPanel;
    SkSvgBusca: TSkSvg;
    EditBusca: TEdit;
    Panel5: TPanel;
    DBGrid1: TDBGrid;
    PnlNotasVazio: TPanel;
    SkSvgNotasVazio: TSkSvg;
    LabelNotasVazioTitulo: TLabel;
    LabelNotasVazioTexto: TLabel;
    PnlNotasVazioBotao: TPanel;
    PnlChaveCopiada: TPanel;
    SkSvgChaveCopiada: TSkSvg;
    LabelChaveCopiada: TLabel;
    TimerChaveCopiada: TTimer;
    FDMemTable1data_ordem: TIntegerField;
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
    mnuCopiarChave: TMenuItem;
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
    procedure mnuCopiarChaveClick(Sender: TObject);
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
    //Etapa 4.5: tela Notas
    FNotasModelo        : TFDMemTable;    //cópia do cursor da FDMemTable1 só com o filtro de modelo (cards, relatórios, Enviar)
    FBusca              : string;         //texto da busca já normalizado (sem espaços); vazio = sem busca
    FNotaSelecionada    : Boolean;        //o usuário escolheu uma nota na grade (clique ou teclado)
    FColunaOrdem        : string;         //campo da coluna ordenada
    FOrdemDecrescente   : Boolean;
    FAjustandoColunas   : Boolean;        //evita reentrada no ajuste das colunas da grade
    FAjustandoTituloNotas: Boolean;       //evita reentrada no layout da linha de título da tela Notas
    function  CopiarTextoTolerante(const Texto: string): Boolean;
    procedure AjustarAlturaLinhasGrade;
    procedure PrepararTelaNotas;
    procedure PrepararColuna(Coluna: TColumn; const Largura: Integer; const Alinhamento: TAlignment);
    procedure AtualizarTelaNotas;
    procedure AtualizarFiltroGrade;
    procedure AplicarBusca;
    procedure LimparBusca;
    procedure AplicarOrdenacao;
    procedure AjustarLinhaTituloNotas;
    procedure AjustarColunasGrade;
    procedure AjustarEstadoVazio;
    procedure AjustarAvisoChaveCopiada;
    procedure AjustarEspacoCards(const Tela: TTela);
    procedure MarcarNotaSelecionada(const Selecionada: Boolean);
    procedure MostrarAvisoChaveCopiada;
    procedure AtualizarBordaCampo(Borda: TPanel; Icone: TSkSvg; Edit: TEdit; const Margem: Integer;
      const ComFoco: Boolean);
    function  TituloColuna(const Campo: string): string;
    function  TextoQuantidadeNotas(const Quantidade: Integer): string;
    procedure FDMemTable1FiltrarBusca(DataSet: TDataSet; var Accept: Boolean);
    procedure CampoMoedaGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Area: TRect; DataCol: Integer;
      Column: TColumn; State: TGridDrawState);
    procedure DBGrid1DesenharTitulo(Sender: TObject; const Area: TRect; Coluna: TColumn);
    procedure DBGrid1Redimensionar(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure DBGrid1CliqueNota(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Panel5Resize(Sender: TObject);
    procedure PnlNotasTituloResize(Sender: TObject);
    procedure EditBuscaChange(Sender: TObject);
    procedure EditBuscaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditBuscaEnter(Sender: TObject);
    procedure EditBuscaExit(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure TimerChaveCopiadaTimer(Sender: TObject);
    procedure CopiarChaveClick(Sender: TObject);
    procedure GerarDanfeClick(Sender: TObject);
    procedure ExportarCSVClick(Sender: TObject);
    procedure NotasVazioSelecionarPastaClick(Sender: TObject);
    procedure NotasVazioLimparBuscaClick(Sender: TObject);
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
    //Tela Notas (etapa 4.5): ações da linha de título e botão do estado vazio (PrepararTelaNotas)
    btnCopiarChave     : TProBotao;
    btnGerarDanfe      : TProBotao;
    btnExportarCSV     : TProBotao;
    btnNotasVazio      : TProBotao;
    //Notas do filtro de modelo (sem a busca): cards, relatórios, Enviar (PD-1 e D5)
    function  NotasDoModelo: TFDMemTable;
    function  TemNotaNoModelo: Boolean;
    //Há linhas visíveis na grade (filtro de modelo + busca)
    function  TemNotaVisivel: Boolean;
    //Há uma nota escolhida pelo usuário na grade (Copiar chave e Gerar DANFE)
    function  NotaSelecionada: Boolean;
    //Copia a chave da nota selecionada (botão, menu da grade e Ctrl+C)
    procedure CopiarChaveSelecionada;
    //Gera o DANFE da nota selecionada (botão, menu da grade, duplo clique e Ctrl+D)
    procedure GerarDanfeSelecionada;
    //Conteúdo do CSV das linhas visíveis da grade (filtro + busca, na ordem da grade; PD-2)
    function  MontarCSV: string;
    //Grava o CSV em UTF-8 com BOM. Erros sobem como exceção
    procedure ExportarCSV(const Caminho: string);
    //Texto da busca já aplicado na grade
    property  Busca: string read FBusca;
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
  System.Types,
  Winapi.CommCtrl,
  ProXML.Icones;

{$R *.dfm}

const
  //Tempo máximo de espera pelo PDF do DANFE (milissegundos)
  TEMPO_LIMITE_PDF_MS = 15000;

  //Copiar chave com a área de transferência presa por outro programa: tenta de novo por cerca de
  //1 s (decisão da 4.2; glossário 6.32)
  TEMPO_AREA_TRANSFERENCIA_MS     = 1000;
  INTERVALO_AREA_TRANSFERENCIA_MS = 50;

  //Seta no fim do título da coluna ordenada (tokens.md 5.7; glossário 6.10): triângulo para cima (U+25B2) crescente, para baixo (U+25BC) decrescente
  SETA_CRESCENTE   = #$25B2;
  SETA_DECRESCENTE = #$25BC;

{ TDBGrid (grade de notas, etapa 4.5) }

procedure TDBGrid.DefinirAlturas(const AlturaTitulo, AlturaLinha: Integer);
begin
    FAlturaTitulo := AlturaTitulo;
    FAlturaLinha  := AlturaLinha;
    AplicarAlturas;
end;

procedure TDBGrid.AplicarAlturas;
begin
    //A VCL mede de novo o título e as linhas a cada mudança de layout (abrir o DataSet, filtro,
    //colunas, fonte, escala): as alturas da tela voltam logo em seguida. Alterar DefaultRowHeight
    //zera as alturas individuais, por isso a do título vem depois
    if FAplicandoAlturas or (FAlturaLinha <= 0) or (([csLoading, csDestroying] * ComponentState) <> []) then
        Exit;

    FAplicandoAlturas := True;
    try
        if DefaultRowHeight <> FAlturaLinha then
            DefaultRowHeight := FAlturaLinha;
        if (dgTitles in Options) and (RowCount > 0) and (RowHeights[0] <> FAlturaTitulo) then
            RowHeights[0] := FAlturaTitulo;
    finally
        FAplicandoAlturas := False;
    end;
end;

procedure TDBGrid.RowHeightsChanged;
begin
    inherited;
    AplicarAlturas;
end;

procedure TDBGrid.DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState);
var
    Coluna: TColumn;
begin
    //Título: pintado pela tela (fundo, texto centralizado na altura, seta e divisória)
    if (ARow = 0) and (dgTitles in Options) and Assigned(FOnDesenharTitulo) and
       (ACol >= IndicatorOffset) and (RawToDataColumn(ACol) < Columns.Count) then
    begin
        Coluna := Columns[RawToDataColumn(ACol)];
        if Coluna.Showing then
        begin
            FOnDesenharTitulo(Self, ARect, Coluna);
            Exit;
        end;
    end;

    inherited;
end;

procedure TDBGrid.Resize;
begin
    inherited;
    if Assigned(FOnRedimensionar) then
        FOnRedimensionar(Self);
end;

function TDBGrid.PontoEmNota(const X, Y: Integer): Boolean;
var
    Celula: TGridCoord;
begin
    Celula := MouseCoord(X, Y);
    Result := DataLink.Active and (not DataLink.DataSet.IsEmpty) and (Celula.X >= IndicatorOffset) and
              (Celula.Y >= 1) and (Celula.Y < RowCount);
end;

function TDBGrid.UltimoCliqueEmNota: Boolean;
begin
    Result := PontoEmNota(FUltimoClique.X, FUltimoClique.Y);
end;

procedure TDBGrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    //O TDBGrid move a nota atual para a linha clicada (botão esquerdo ou direito) e, no duplo
    //clique, chama o DblClick: o ponto fica guardado para a tela saber onde foi o clique
    FUltimoClique := Point(X, Y);
    inherited;
    if (not (ssDouble in Shift)) and (Button in [mbLeft, mbRight]) and PontoEmNota(X, Y) and
       Assigned(FOnCliqueNota) then
        FOnCliqueNota(Self);
end;

procedure TFormPrincipal.ApplicationException(Sender: TObject; E: Exception);
begin
  // Grava no log o erro com detalhes
  DMConfig.CreateLog(E.ClassName, E.Message);
end;

procedure TFormPrincipal.btnEnviarEmailClick(Sender: TObject);
begin
    //Enviar Email com arquivos compactados.
    //Os XMLs são separados e compactados agora, com o filtro de modelo atual (a busca da tela
    //Notas não vale para o Enviar: decisão D5)
    if not TemNotaNoModelo then
    begin
        messagedlg('Sem arquivos para enviar!', mtInformation	, [mbOk], 0);
        Exit;
    end;

    ComprimirArquivos();
    EnviaArquivo(Trim(EditEmailEnviar.Text), 'Projeto Pro XML - XMLs de Nota Fiscal');
end;

procedure TFormPrincipal.AtualizarTotais;
begin
    //Recalcula os totais a partir das notas do filtro de modelo. A busca da tela Notas não entra
    //nos cards (PD-1): por isso a soma usa a cópia do cursor só com o filtro de modelo
    FTotais := CalcularTotais(NotasDoModelo);

    LabelValorTotal.Caption := FormatarMoeda(FTotais.ValorTotal);
    LabelbaseICMS.Caption   := FormatarMoeda(FTotais.BaseICMS);
    LabelValorICMS.Caption  := FormatarMoeda(FTotais.ValorICMS);
    LabelValorIBS.Caption   := FormatarMoeda(FTotais.IBS);
    LabelValorCBS.Caption   := FormatarMoeda(FTotais.CBS);

    //Sem notas no filtro: valores em cinza e peso normal; valor grande diminui para caber
    AtualizarVisualCards;

    //A tela Relatórios mostra o filtro e as contagens: acompanha o filtro de modelo e o Processar
    AtualizarTelaRelatorios;

    //Tela Notas: contador, ações e estado vazio (etapa 4.5)
    AtualizarTelaNotas;
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
    //Título de 32 px e linhas de 28 px (tokens.md 4.1 e 5.7), definidos uma vez aqui (FormCreate e
    //troca de escala), fora do OnDrawColumnCell: alterar a altura durante a pintura faz a grade se
    //repintar sem parar. A grade (TDBGrid desta unit) reaplica as alturas quando a VCL as recalcula
    DBGrid1.DefinirAlturas(Escalar(AlturaTituloGrade), Escalar(AlturaLinhaGrade));
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
    Modelo : Integer;
    Notas  : TFDMemTable;
begin
    //Filtra a grade pelo modelo escolhido (junto com a busca da tela Notas) e recalcula todos os cards.
    //O mesmo filtro vai para o DMConfig, usado pelos relatórios (QryNotas e QryNotasIBSCBS), e para a
    //cópia do cursor sem a busca (NotasDoModelo), usada nos cards, nos relatórios e no Enviar
    Modelo := ModeloSelecionado;

    Notas := NotasDoModelo;
    if Notas.Active then
    begin
        if Modelo = FILTRO_MODELO_TODOS then
        begin
            Notas.Filtered := False;
            Notas.Filter   := '';
        end
        else
        begin
            Notas.Filter   := 'modelo = ' + IntToStr(Modelo);
            Notas.Filtered := True;
        end;
    end;

    //Outro modelo: a nota escolhida deixa de valer
    FNotaSelecionada := False;
    AtualizarFiltroGrade;

    DMConfig.FiltroModelo := Modelo;
    AtualizarTotais;
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
   //Garante que o relatório use o mesmo modelo dos cards (a busca da tela Notas não entra: D5)
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
        FormRelatorio.SetQtRegistros(IntToStr(NotasDoModelo.RecordCount));
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
    if not TemNotaNoModelo then
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
   //Etapa 4.5: tela Notas (linha de título, busca, ordenação, grade, estado vazio, aviso)
   PrepararTelaNotas;
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
  Notas: TFDMemTable;
begin
    //Comprime os arquivos XML
    varPath := ExtractFilePath(ParamStr(0));

    if TDirectory.Exists(varPath + 'NFCe\ProXML') then
    begin
      // Deleta a pasta e todo o seu conteúdo
      TDirectory.Delete(varPath + 'NFCe\ProXML', True);  // O segundo parâmetro True indica exclusão recursiva
    end;

    if not SysUtils.DirectoryExists(varPath + 'NFCe\ProXML') then SysUtils.ForceDirectories(varPath + '\NFCe\ProXML');

    //Copia as notas do filtro de modelo (a busca da tela Notas não vale para o Enviar: D5), sem
    //mexer na grade. A chave tem 44 dígitos (D4): o arquivo sai como <chave>-nfe.xml (H3)
    Notas := NotasDoModelo;
    Notas.DisableControls;
    try
        Marcador := Notas.GetBookmark;
        try
            Notas.First;
            while not Notas.Eof do
            begin
                varDestino := varPath + 'NFCe\ProXML\'+Notas.FieldByName('chave').AsString+'-nfe.xml';

                CopyFile(PChar(Notas.FieldByName('xml').AsString), PChar(varDestino), False);
                Notas.Next;
            end;
        finally
            if (Marcador <> nil) and Notas.BookmarkValid(Marcador) then
                Notas.GotoBookmark(Marcador);
            Notas.FreeBookmark(Marcador);
        end;
    finally
        Notas.EnableControls;
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
   //A altura das linhas da grade é definida uma vez no FormCreate (PrepararTelaNotas)
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

function TFormPrincipal.CopiarTextoTolerante(const Texto: string): Boolean;
var
    Inicio: Cardinal;
begin
    //Copia o texto para a área de transferência. Se outro programa estiver com ela aberta, tenta
    //de novo por cerca de 1 s; se ainda falhar, avisa numa caixa com OK (glossário 6.32).
    //Nenhuma exceção sai daqui
    Result := False;
    Inicio := GetTickCount;
    repeat
        try
            Clipboard.AsText := Texto;
            Result := True;
        except
            on E: Exception do
            begin
                if (GetTickCount - Inicio) >= TEMPO_AREA_TRANSFERENCIA_MS then
                    Break;
                Sleep(INTERVALO_AREA_TRANSFERENCIA_MS);
            end;
        end;
    until Result;

    if not Result then
        messagedlg('Não foi possível copiar a chave: outro programa está usando a área de transferência. ' +
                   'Tente de novo em alguns segundos.', mtWarning, [mbOk], 0);
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
    AtualizarTelaNotas;
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
        AtualizarTelaNotas;
    end;
end;

procedure TFormPrincipal.GerarDANFe1Click(Sender: TObject);
begin
  //"Gerar DANFE" do menu da grade (glossário 6.12): mesmo caminho do botão, do duplo clique e do Ctrl+D
  GerarDanfeSelecionada;
end;

procedure TFormPrincipal.mnuCopiarChaveClick(Sender: TObject);
begin
  //"Copiar chave" do menu da grade (glossário 6.11): mesmo caminho do botão e do Ctrl+C
  CopiarChaveSelecionada;
end;

procedure TFormPrincipal.GerarDanfeSelecionada;
begin
  //A grade mostra só as notas do filtro de modelo e da busca: a nota atual é a escolhida na tela
  if not TemNotaVisivel then
    Exit;

  GerarDanfe(FDMemTable1.FieldByName('xml').AsString, FDMemTable1.FieldByName('numero').AsString);
end;

procedure TFormPrincipal.CopiarChaveSelecionada;
begin
  //Chave de 44 dígitos (D4). Copiou: aviso flutuante "Chave copiada" (glossário 6.19)
  if not TemNotaVisivel then
    Exit;

  if CopiarTextoTolerante(FDMemTable1.FieldByName('chave').AsString) then
    MostrarAvisoChaveCopiada;
end;

procedure TFormPrincipal.GravarNotasDB(const Relatorio: TTipoRelatorio);
var
  Titulo : string;
  Legenda: string;
  Notas  : TFDMemTable;
begin
  //Grava as notas no banco de dados SQLite e abre o relatório escolhido (notas ou IBS/CBS).
  //A gravação roda na thread principal, numa transação: a conexão DMConfig.Conexao também
  //é usada pela tela e o FireDAC não permite usar a mesma conexão em duas threads ao mesmo tempo.
  //Só roda no clique em "Gerar relatório": abrir a tela Relatórios não grava nada (N1).

  if not FDMemTable1.Active then
    FDMemTable1.Open;

  //Grava as notas lidas na ordem de leitura e conta só as do filtro de modelo: a busca e a ordenação
  //da tela Notas não valem para os relatórios (decisão D5)
  Notas := NotasDoModelo;

  //Tela Carregando antes de começar a gravar (glossário 8.15 e 8.16). Fluxo: Carregando ->
  //visualização do QuickReport -> volta para Relatórios, com sucesso ou erro (o finally garante
  //a volta e o menu reabilitado; nos erros a tela volta antes da mensagem)
  if Relatorio = trIBSCBS then
    Titulo := 'Gerando o Relatório IBS/CBS' + #$2026
  else
    Titulo := 'Gerando o Relatório de Notas' + #$2026;
  if Notas.RecordCount = 1 then
    Legenda := 'Gravando 1 nota e montando a visualização.'
  else
    Legenda := 'Gravando ' + IntToStr(Notas.RecordCount) + ' notas e montando a visualização.';

  IniciarCarregando(Titulo, Legenda);
  try
    Screen.Cursor := crHourGlass;
    try
      try
        DMConfig.GravarNotas(Notas);
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
      //Nova pasta: o seletor de modelo volta para "Todos" (grade, cards e relatórios) e a busca da
      //tela Notas é limpa (as notas novas aparecem todas)
      SeletorModelo.ItemIndex := 0;
      LimparBusca;
      AplicarFiltroModelo;

      CalculadoraXML.CaminhoDiretorio := Trim(EditCaminho.Text);
      CalculadoraXML.ProcessarXMLs;
      //Pasta nova: nenhuma nota escolhida, lista no começo
      FNotaSelecionada := False;
      if FDMemTable1.Active then
        FDMemTable1.First;
      AtualizarTelaNotas;
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

function TFormPrincipal.NotasDoModelo: TFDMemTable;
begin
    //Cópia do cursor da FDMemTable1 (mesmos dados, sem cópia de memória) com o seu próprio filtro,
    //só de modelo, sem a busca e sem a ordenação da grade (PD-1 e D5). Refeita se a FDMemTable1 for
    //recriada (outra tabela em memória)
    if FNotasModelo = nil then
        FNotasModelo := TFDMemTable.Create(Self);

    if FDMemTable1.Active and ((not FNotasModelo.Active) or (FNotasModelo.Table <> FDMemTable1.Table)) then
    begin
        //AReset = True: a cópia não herda o filtro, o índice nem o OnFilterRecord (busca) da grade
        FNotasModelo.CloneCursor(FDMemTable1, True, False);
        FNotasModelo.OnFilterRecord := nil;
        if (SeletorModelo <> nil) and (ModeloSelecionado <> FILTRO_MODELO_TODOS) then
        begin
            FNotasModelo.Filter   := 'modelo = ' + IntToStr(ModeloSelecionado);
            FNotasModelo.Filtered := True;
        end;
    end;

    Result := FNotasModelo;
end;

function TFormPrincipal.TemNotaNoModelo: Boolean;
begin
    Result := NotasDoModelo.Active and (not NotasDoModelo.IsEmpty);
end;

function TFormPrincipal.TemNotaVisivel: Boolean;
begin
    Result := FDMemTable1.Active and (not FDMemTable1.IsEmpty);
end;

function TFormPrincipal.NotaSelecionada: Boolean;
begin
    Result := FNotaSelecionada and TemNotaVisivel;
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
    //Ctrl+F: leva para a tela Notas (com o menu sincronizado) e põe o foco no campo Buscar
    //(glossário 6.18), com o texto selecionado para digitar outra busca por cima
    MostrarTela(tlNotas);
    if EditBusca.CanFocus then
    begin
        EditBusca.SetFocus;
        EditBusca.SelectAll;
    end;
end;

procedure TFormPrincipal.AcaoCopiarChaveExecute(Sender: TObject);
begin
    //Ctrl+C: mesmo que "Copiar chave" do botão e do menu da grade
    CopiarChaveSelecionada;
end;

procedure TFormPrincipal.AcaoCopiarChaveUpdate(Sender: TObject);
begin
    //Só com a grade em foco e uma nota escolhida: nos campos de texto o Ctrl+C continua copiando o texto
    actCopiarChave.Enabled := (ActiveControl = DBGrid1) and NotaSelecionada;
end;

procedure TFormPrincipal.AcaoGerarDanfeExecute(Sender: TObject);
begin
    //Ctrl+D: mesmo que "Gerar DANFE" do botão e do menu da grade
    GerarDanfeSelecionada;
end;

procedure TFormPrincipal.AcaoGerarDanfeUpdate(Sender: TObject);
begin
    //Só na tela Notas, com uma nota escolhida e sem outro DANFE em andamento
    actGerarDanfe.Enabled := (TelaAtual = tlNotas) and NotaSelecionada and (not FGerandoDanfe);
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
        //Etapa 4.5: tela Notas (alturas da grade, colunas, linha de título e campo Buscar)
        AjustarAlturaLinhasGrade;
        AtualizarBordaCampo(PnlCampoBusca, SkSvgBusca, EditBusca, 0, EditBusca.Focused);
        AjustarLinhaTituloNotas;
        AjustarColunasGrade;
        AjustarEstadoVazio;
        AjustarEspacoCards(TelaAtual);
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
begin
    //Campo da pasta (tokens.md 5.3; a rotina é a mesma do campo Buscar da tela Notas)
    AtualizarBordaCampo(PnlCampoPasta, SkSvgPasta, EditCaminho, 0, ComFoco);
end;

procedure TFormPrincipal.AtualizarBordaCampo(Borda: TPanel; Icone: TSkSvg; Edit: TEdit; const Margem: Integer;
  const ComFoco: Boolean);
var
    Espessura  : Integer;
    Diferenca  : Integer;
    Interno    : Integer;
    AlturaTexto: Integer;
    Medida     : TBitmap;
begin
    //Campo (tokens.md 5.3): borda de 1 px CorBordaCampo; com foco, 2 px CorPrimaria.
    //A borda é o painel de fora (cor + Padding); ao engrossar, o espaço interno diminui o mesmo
    //tanto para o ícone e o texto não mudarem de lugar. Margem: reservado (0 nos dois campos)
    if ComFoco then
    begin
        Espessura := Escalar(BordaCampoFoco);
        Borda.Color := CorPrimaria;
    end
    else
    begin
        Espessura := Escalar(BordaCampo);
        Borda.Color := CorBordaCampo;
    end;
    Diferenca := Espessura - Escalar(BordaCampo);
    Borda.Padding.SetBounds(Espessura, Espessura + Margem, Espessura, Espessura + Margem);

    //Ícone de 16 px e texto centralizados na altura interna do campo
    Interno := Escalar(AlturaCampo) - 2 * Escalar(BordaCampo);
    Medida := TBitmap.Create;
    try
        Medida.Canvas.Font.Assign(Edit.Font);
        AlturaTexto := Medida.Canvas.TextHeight('Ag');
    finally
        Medida.Free;
    end;

    Icone.Margins.SetBounds(Escalar(PaddingCampo) - Diferenca,
                            Max(0, (Interno - Escalar(TamanhoIconePequeno)) div 2 - Diferenca),
                            0,
                            Max(0, (Interno - Escalar(TamanhoIconePequeno)) div 2 - Diferenca));
    Edit.Margins.SetBounds(Escalar(Espaco1),
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
    AjustarEspacoCards(Tela);

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
        if TemNotaNoModelo then
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
    AjustarEspacoCards(Tela);
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
    //Telas no visual novo, com os próprios quadros sobre CorFundo (mockups notas.html, relatorios.html
    //e carregando.html): ocupam a área inteira do PageControl1, sem a moldura do controle.
    //As outras telas mantêm a moldura até a etapa delas (4.7)
    Result := Tela in [tlNotas, tlRelatorios, tlCarregando];
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
        Total      := NotasDoModelo.RecordCount;      //notas do filtro de modelo atual (sem a busca: D5)
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

{ Plano 4, etapa 4.5: tela Notas (barra de ações, busca, ordenação, grade, CSV, estado vazio, aviso) }

function TFormPrincipal.TituloColuna(const Campo: string): string;
begin
    //Títulos das colunas da grade (glossário 6.3 a 6.8)
    if Campo = 'numero' then
        Result := 'Nº'
    else if Campo = 'modelo' then
        Result := 'Modelo'
    else if Campo = 'data' then
        Result := 'Data'
    else if Campo = 'chave' then
        Result := 'Chave'
    else if Campo = 'vtotal' then
        Result := 'Valor'
    else if Campo = 'bcicms' then
        Result := 'Base ICMS'
    else if Campo = 'vlicms' then
        Result := 'ICMS'
    else if Campo = 'vibs' then
        Result := 'IBS'
    else if Campo = 'vcbs' then
        Result := 'CBS'
    else
        Result := Campo;
end;

function TFormPrincipal.TextoQuantidadeNotas(const Quantidade: Integer): string;
begin
    //Contagem com singular e plural (regra 6 de tom do glossário)
    if Quantidade = 1 then
        Result := '1 nota'
    else
        Result := IntToStr(Quantidade) + ' notas';
end;

procedure TFormPrincipal.PrepararColuna(Coluna: TColumn; const Largura: Integer; const Alinhamento: TAlignment);
begin
    //Coluna da grade (tokens.md 5.7): título com o mesmo alinhamento do dado, fundo CorFundo
    Coluna.Width           := Escalar(Largura);
    Coluna.Alignment       := Alinhamento;
    Coluna.Title.Alignment := Alinhamento;
    Coluna.Title.Color     := CorFundo;
    Coluna.Title.Caption   := TituloColuna(Coluna.FieldName);
end;

procedure TFormPrincipal.PrepararTelaNotas;
var
    I     : Integer;
    Coluna: TColumn;
begin
    //Tela Notas sem moldura, sobre CorFundo (mockup notas.html): linha de título de 32 px com título,
    //contador, ações e busca; 16 px abaixo, a grade com borda de 1 px CorBorda
    PnlNotas.Color       := CorFundo;
    PnlNotasTitulo.Color := CorFundo;
    PnlNotasTitulo.OnResize := PnlNotasTituloResize;

    //Título 14 pt Semibold (6.1) e contador 9 pt CorTextoSecundario (6.2)
    AplicarFonte(LabelNotasTitulo.Font, FonteDestaque, TamanhoTituloTela, CorTexto);
    LabelNotasTitulo.Layout  := tlCenter;
    LabelNotasTitulo.Caption := 'Notas';
    AplicarFonte(LabelNotasContador.Font, FonteTexto, TamanhoLegenda, CorTextoSecundario);
    LabelNotasContador.Layout  := tlCenter;
    LabelNotasContador.Caption := '';

    //Ações (6.13, 6.14 e 6.16): TProBotao secundários com ícone. Desabilitados, a dica 6.15 fica
    //no painel de encaixe (tokens.md 5.12: a VCL não mostra o hint de um controle desabilitado)
    PnlCopiarChave.Color := CorFundo;
    PnlGerarDanfe.Color  := CorFundo;
    PnlExportarCSV.Color := CorFundo;
    PnlCopiarChave.ShowHint := True;
    PnlGerarDanfe.ShowHint  := True;
    PnlExportarCSV.ShowHint := True;
    btnCopiarChave := TProBotao.CriarEm(PnlCopiarChave, 'Copiar chave', ebSecundario, CopiarChaveClick);
    btnCopiarChave.IconeSvg := IconeCopiar;
    btnCopiarChave.Hint     := 'Copiar a chave de acesso da nota selecionada (Ctrl+C)';
    btnCopiarChave.ShowHint := True;
    btnGerarDanfe := TProBotao.CriarEm(PnlGerarDanfe, 'Gerar DANFE', ebSecundario, GerarDanfeClick);
    btnGerarDanfe.IconeSvg := IconeGerarDanfe;
    btnGerarDanfe.Hint     := 'Gerar o PDF do DANFE da nota selecionada (Ctrl+D ou duplo clique)';
    btnGerarDanfe.ShowHint := True;
    btnExportarCSV := TProBotao.CriarEm(PnlExportarCSV, 'Exportar CSV', ebSecundario, ExportarCSVClick);
    btnExportarCSV.IconeSvg := IconeExportarCSV;
    btnExportarCSV.Hint     := 'Salvar as notas da lista num arquivo CSV (abre no Excel)';
    btnExportarCSV.ShowHint := True;

    //Campo Buscar (6.17 e 6.18): mesmo campo da barra de pasta (tokens.md 5.3), com o ícone search
    PnlCampoBuscaFundo.Color := CorSuperficie;
    EditBusca.Color := CorSuperficie;
    AplicarFonte(EditBusca.Font, FonteTexto, TamanhoCorpo, CorTexto);
    EditBusca.TextHint := 'Buscar por número ou chave';
    EditBusca.Hint     := 'Ctrl+F para buscar. Esc limpa.';
    EditBusca.ShowHint := True;
    EditBusca.OnChange  := EditBuscaChange;
    EditBusca.OnKeyDown := EditBuscaKeyDown;
    EditBusca.OnEnter   := EditBuscaEnter;
    EditBusca.OnExit    := EditBuscaExit;
    SkSvgBusca.Svg.Source        := IconeBuscar;
    SkSvgBusca.Svg.OverrideColor := CorAlpha(CorTextoSecundario);
    AtualizarBordaCampo(PnlCampoBusca, SkSvgBusca, EditBusca, 0, False);

    //Grade (tokens.md 5.7): borda de 1 px CorBorda no painel de fora; pintura própria das células
    //(DefaultDrawing = False no .dfm) e do título (TDBGrid desta unit)
    Panel5.Color := CorBorda;
    Panel5.Padding.SetBounds(Escalar(BordaQuadro), Escalar(BordaQuadro), Escalar(BordaQuadro), Escalar(BordaQuadro));
    Panel5.OnResize := Panel5Resize;
    DBGrid1.Color      := CorSuperficie;
    DBGrid1.FixedColor := CorFundo;
    AplicarFonte(DBGrid1.Font, FonteTexto, TamanhoCorpo, CorTexto);
    AplicarFonte(DBGrid1.TitleFont, FonteDestaque, TamanhoBotao, CorTexto);
    DBGrid1.OnDrawColumnCell := DBGrid1DrawColumnCell;
    DBGrid1.OnDesenharTitulo := DBGrid1DesenharTitulo;
    DBGrid1.OnRedimensionar  := DBGrid1Redimensionar;
    DBGrid1.OnCliqueNota     := DBGrid1CliqueNota;
    DBGrid1.OnTitleClick     := DBGrid1TitleClick;
    DBGrid1.OnDblClick       := DBGrid1DblClick;
    DBGrid1.OnKeyDown        := DBGrid1KeyDown;

    //Colunas: Nº e valores à direita, Modelo centralizado, Data e Chave à esquerda (larguras da 5.7;
    //a Chave fica com o resto e as colunas de valor extras entram conforme a largura, decisão D3)
    for I := 0 to DBGrid1.Columns.Count - 1 do
    begin
        Coluna := DBGrid1.Columns[I];
        if Coluna.FieldName = 'numero' then
            PrepararColuna(Coluna, LarguraColunaNumero, taRightJustify)
        else if Coluna.FieldName = 'modelo' then
            PrepararColuna(Coluna, LarguraColunaModelo, taCenter)
        else if Coluna.FieldName = 'data' then
            PrepararColuna(Coluna, LarguraColunaData, taLeftJustify)
        else if Coluna.FieldName = 'chave' then
            PrepararColuna(Coluna, LarguraColunaChaveMin, taLeftJustify)
        else if Coluna.FieldName = 'vtotal' then
            PrepararColuna(Coluna, LarguraColunaValor, taRightJustify)
        else if Coluna.FieldName = 'bcicms' then
            PrepararColuna(Coluna, LarguraColunaBaseICMS, taRightJustify)
        else if Coluna.FieldName = 'vlicms' then
            PrepararColuna(Coluna, LarguraColunaICMS, taRightJustify)
        else if Coluna.FieldName = 'vibs' then
            PrepararColuna(Coluna, LarguraColunaIBS, taRightJustify)
        else if Coluna.FieldName = 'vcbs' then
            PrepararColuna(Coluna, LarguraColunaCBS, taRightJustify);
    end;

    //Valores "R$ 1.234,56" com o formato pt-BR explícito da 4.3 (glossário 6.9), na grade e em
    //qualquer DisplayText: não dependem do separador decimal do Windows
    FDMemTable1vtotal.OnGetText    := CampoMoedaGetText;
    FDMemTable1bcicms.OnGetText    := CampoMoedaGetText;
    FDMemTable1vlicms.OnGetText    := CampoMoedaGetText;
    FDMemTable1vbcibscbs.OnGetText := CampoMoedaGetText;
    FDMemTable1vibsuf.OnGetText    := CampoMoedaGetText;
    FDMemTable1vibsmun.OnGetText   := CampoMoedaGetText;
    FDMemTable1vibs.OnGetText      := CampoMoedaGetText;
    FDMemTable1vcbs.OnGetText      := CampoMoedaGetText;

    //Busca (OnFilterRecord, junto com o filtro de modelo) e ordenação padrão por Nº crescente
    FDMemTable1.OnFilterRecord := FDMemTable1FiltrarBusca;
    FColunaOrdem      := 'numero';
    FOrdemDecrescente := False;
    AplicarOrdenacao;

    //Estado vazio e busca sem resultado (tokens.md 5.7): painel por cima da grade, abaixo do título
    PnlNotasVazio.Color := CorSuperficie;
    PnlNotasVazio.Visible := False;
    SkSvgNotasVazio.Svg.OverrideColor := CorAlpha(CorTextoSecundario);
    AplicarFonte(LabelNotasVazioTitulo.Font, FonteDestaque, TamanhoSubtitulo, CorTexto);
    AplicarFonte(LabelNotasVazioTexto.Font, FonteTexto, TamanhoCorpo, CorTextoSecundario);
    PnlNotasVazioBotao.Color := CorSuperficie;
    btnNotasVazio := TProBotao.CriarEm(PnlNotasVazioBotao, 'Selecionar pasta' + #$2026, ebSecundario,
                                       NotasVazioSelecionarPastaClick);
    btnNotasVazio.IconeSvg := IconePastaAberta;

    //Aviso flutuante "Chave copiada" (tokens.md 5.11; glossário 6.19)
    PnlChaveCopiada.Color   := CorMarinho;
    PnlChaveCopiada.Visible := False;
    SkSvgChaveCopiada.Svg.Source        := IconeConfirmar;
    SkSvgChaveCopiada.Svg.OverrideColor := CorAlpha(CorSucessoSobreMarinho);
    AplicarFonte(LabelChaveCopiada.Font, FonteDestaque, TamanhoLegenda, CorTextoSobreMarinho);
    LabelChaveCopiada.Caption := 'Chave copiada';
    TimerChaveCopiada.Enabled  := False;
    TimerChaveCopiada.Interval := DuracaoAvisoMs;
    TimerChaveCopiada.OnTimer  := TimerChaveCopiadaTimer;

    //Menu da grade (glossário 6.11 e 6.12): continua como atalho
    PopupMenu.OnPopup := PopupMenuPopup;

    AjustarAlturaLinhasGrade;
    AjustarLinhaTituloNotas;
    AjustarColunasGrade;
    AtualizarTelaNotas;
end;

procedure TFormPrincipal.AjustarEspacoCards(const Tela: TTela);
begin
    //Espaço de 16 px entre os cards e a tela. Na tela Notas a linha de título é mais alta que 32 px
    //(margem do contorno de foco dos botões em cima e embaixo): o espaço desconta essa margem para a
    //face dos botões, o campo Buscar e o título ficarem na mesma posição do mockup
    if btnCopiarChave = nil then
        Exit;

    if Tela = tlNotas then
        PnlCards.Margins.Bottom := Escalar(Espaco2) - btnCopiarChave.MargemFoco
    else
        PnlCards.Margins.Bottom := Escalar(Espaco2);
end;

procedure TFormPrincipal.AjustarLinhaTituloNotas;
var
    Margem : Integer;
    Livre  : Integer;
begin
    //Linha de título: "Notas" e o contador à esquerda; Copiar chave, Gerar DANFE, Exportar CSV e o
    //campo Buscar à direita, com 8 px entre eles (mockup .trow)
    if (btnCopiarChave = nil) or FAjustandoTituloNotas then
        Exit;

    FAjustandoTituloNotas := True;
    PnlNotasTitulo.DisableAlign;
    try
        Margem := btnCopiarChave.MargemFoco;
        PnlNotasTitulo.Height := Escalar(AlturaTituloTela) + 2 * Margem;
        PnlNotasTitulo.Margins.SetBounds(0, 0, 0, Escalar(Espaco2) - Margem);

        PnlCopiarChave.Width := btnCopiarChave.LarguraIdeal;
        PnlGerarDanfe.Width  := btnGerarDanfe.LarguraIdeal;
        PnlExportarCSV.Width := btnExportarCSV.LarguraIdeal;
        LabelNotasContador.Margins.SetBounds(Escalar(Espaco1), 0, 0, 0);
        PnlCampoBusca.Margins.SetBounds(Escalar(Espaco1) - Margem, Margem, 0, Margem);

        //Campo Buscar com 248 px; se a linha não couber (janela mínima, contador longo), ele encolhe
        //até LarguraMinimaCampoBusca
        Livre := PnlNotasTitulo.ClientWidth - LabelNotasTitulo.Width - LabelNotasContador.Margins.Left -
                 LabelNotasContador.Width - Escalar(Espaco1) - PnlCopiarChave.Width - PnlGerarDanfe.Width -
                 PnlExportarCSV.Width - PnlCampoBusca.Margins.Left;
        PnlCampoBusca.Width := Max(Escalar(LarguraMinimaCampoBusca), Min(Escalar(LarguraCampoBusca), Livre));

        //A VCL ordena os alRight pela borda direita: da direita para a esquerda ficam Buscar,
        //Exportar CSV, Gerar DANFE e Copiar chave. Os alLeft vão pela borda esquerda menos a margem:
        //o título primeiro e depois o contador (que tem 8 px de margem)
        PnlCampoBusca.Left  := 40000;
        PnlExportarCSV.Left := 30000;
        PnlGerarDanfe.Left  := 20000;
        PnlCopiarChave.Left := 10000;
        LabelNotasTitulo.Left   := 0;
        LabelNotasContador.Left := 5000;
    finally
        PnlNotasTitulo.EnableAlign;
        FAjustandoTituloNotas := False;
    end;
end;

procedure TFormPrincipal.PnlNotasTituloResize(Sender: TObject);
begin
    AjustarLinhaTituloNotas;
end;

procedure TFormPrincipal.AjustarColunasGrade;
var
    Coluna   : TColumn;
    Chave    : TColumn;
    Extras   : array[0..3] of TColumn;
    Larguras : array[0..3] of Integer;
    Ocupado  : Integer;
    Disponivel: Integer;
    Resto    : Integer;
    Cabe     : Boolean;
    I        : Integer;

    function ColunaDoCampo(const Campo: string): TColumn;
    var
        J: Integer;
    begin
        Result := nil;
        for J := 0 to DBGrid1.Columns.Count - 1 do
            if DBGrid1.Columns[J].FieldName = Campo then
                Exit(DBGrid1.Columns[J]);
    end;

begin
    //Decisão D3: Nº, Modelo, Data, Chave e Valor sempre. As colunas extras entram em pares, cada par
    //só quando couber inteiro sem a Chave ficar abaixo do mínimo: primeiro Base ICMS + ICMS, depois
    //IBS + CBS (nunca IBS sem CBS; decisão do usuário de 21/10/2026). A barra de rolagem vertical conta
    //sempre, para a coluna não aparecer e sumir junto com ela. A Chave fica com o resto da largura
    if FAjustandoColunas or (btnCopiarChave = nil) then
        Exit;

    Chave     := ColunaDoCampo('chave');
    Extras[0] := ColunaDoCampo('bcicms');
    Extras[1] := ColunaDoCampo('vlicms');
    Extras[2] := ColunaDoCampo('vibs');
    Extras[3] := ColunaDoCampo('vcbs');
    if (Chave = nil) or (Extras[0] = nil) or (Extras[1] = nil) or (Extras[2] = nil) or (Extras[3] = nil) then
        Exit;
    Larguras[0] := Escalar(LarguraColunaBaseICMS);
    Larguras[1] := Escalar(LarguraColunaICMS);
    Larguras[2] := Escalar(LarguraColunaIBS);
    Larguras[3] := Escalar(LarguraColunaCBS);

    FAjustandoColunas := True;
    DBGrid1.Columns.BeginUpdate;
    try
        Disponivel := DBGrid1.Width - MulDiv(GetSystemMetrics(SM_CXVSCROLL), PPIAtual, Screen.PixelsPerInch);
        Ocupado := Escalar(LarguraColunaNumero) + Escalar(LarguraColunaModelo) + Escalar(LarguraColunaData) +
                   Escalar(LarguraColunaChaveMin) + Escalar(LarguraColunaValor);
        Cabe := True;
        I := Low(Extras);
        while I < High(Extras) do
        begin
            //Par I e I + 1: (Base ICMS, ICMS) e (IBS, CBS)
            Cabe := Cabe and (Ocupado + Larguras[I] + Larguras[I + 1] <= Disponivel);
            if Cabe then
                Inc(Ocupado, Larguras[I] + Larguras[I + 1]);
            Extras[I].Width       := Larguras[I];
            Extras[I + 1].Width   := Larguras[I + 1];
            Extras[I].Visible     := Cabe;
            Extras[I + 1].Visible := Cabe;
            Inc(I, 2);
        end;

        Resto := DBGrid1.ClientWidth;
        for I := 0 to DBGrid1.Columns.Count - 1 do
        begin
            Coluna := DBGrid1.Columns[I];
            if (Coluna <> Chave) and Coluna.Visible then
                Dec(Resto, Coluna.Width);
        end;
        Chave.Width := Max(Escalar(LarguraColunaChaveMin), Resto);
    finally
        DBGrid1.Columns.EndUpdate;
        FAjustandoColunas := False;
    end;
end;

procedure TFormPrincipal.DBGrid1Redimensionar(Sender: TObject);
begin
    //Janela redimensionada ou barra de rolagem que aparece/some: colunas, estado vazio e aviso
    AjustarColunasGrade;
    AjustarEstadoVazio;
    AjustarAvisoChaveCopiada;
end;

procedure TFormPrincipal.Panel5Resize(Sender: TObject);
begin
    AjustarEstadoVazio;
    AjustarAvisoChaveCopiada;
end;

procedure TFormPrincipal.AtualizarTelaNotas;
var
    Total       : Integer;
    Visiveis    : Integer;
    Carregadas  : Integer;
    Selecionada : Boolean;
begin
    //Contador (6.2), ações (6.13 a 6.16) e estado vazio (6.20 a 6.25). Cards ficam de fora (PD-1)
    if (btnCopiarChave = nil) or (SeletorModelo = nil) then
        Exit;

    Total      := 0;
    Visiveis   := 0;
    Carregadas := 0;
    if FDMemTable1.Active then
    begin
        Carregadas := FDMemTable1.Table.Rows.Count;
        Total      := NotasDoModelo.RecordCount;
        Visiveis   := FDMemTable1.RecordCount;
    end;

    //"{n} notas"; com busca, "{x} de {n} notas" (n = notas do modelo, x = linhas visíveis)
    if Carregadas = 0 then
        LabelNotasContador.Caption := ''
    else if FBusca <> '' then
        LabelNotasContador.Caption := IntToStr(Visiveis) + ' de ' + TextoQuantidadeNotas(Total)
    else
        LabelNotasContador.Caption := TextoQuantidadeNotas(Total);

    //Copiar chave e Gerar DANFE só com uma nota escolhida; Exportar CSV só com linhas visíveis
    Selecionada := NotaSelecionada;
    btnCopiarChave.Enabled := Selecionada;
    btnGerarDanfe.Enabled  := Selecionada and (not FGerandoDanfe);
    btnExportarCSV.Enabled := Visiveis > 0;
    if Selecionada then
    begin
        PnlCopiarChave.Hint := '';
        PnlGerarDanfe.Hint  := '';
    end
    else
    begin
        PnlCopiarChave.Hint := 'Selecione uma nota na lista.';
        PnlGerarDanfe.Hint  := 'Selecione uma nota na lista.';
    end;

    AjustarLinhaTituloNotas;
    AjustarEstadoVazio;
    DBGrid1.Invalidate;
end;

procedure TFormPrincipal.AjustarEstadoVazio;
var
    Vazia         : Boolean;
    SemResultado  : Boolean;
    ModeloVazio   : Boolean;
    ComBotao      : Boolean;
    Largura       : Integer;
    LarguraTitulo : Integer;
    AlturaTitulo  : Integer;
    AlturaTexto   : Integer;
    Icone         : Integer;
    Espaco        : Integer;
    Margem        : Integer;
    AlturaEncaixe : Integer;
    Total         : Integer;
    Topo          : Integer;
    Modelo        : string;
begin
    //Nenhuma nota lida: estado vazio (6.20 a 6.22). Busca sem nenhuma linha: 6.23 a 6.25. Notas lidas,
    //mas nenhuma no modelo escolhido e sem busca: texto 8.8a, sem botão. O painel fica por cima da
    //grade, abaixo da linha de títulos (mockup notas.html)
    if (btnNotasVazio = nil) or (SeletorModelo = nil) then
        Exit;

    Vazia        := (not FDMemTable1.Active) or (FDMemTable1.Table.Rows.Count = 0);
    SemResultado := (not Vazia) and (FBusca <> '') and FDMemTable1.IsEmpty;
    ModeloVazio  := (not Vazia) and (FBusca = '') and FDMemTable1.IsEmpty;
    ComBotao     := not ModeloVazio;
    if not (Vazia or SemResultado or ModeloVazio) then
    begin
        PnlNotasVazio.Visible := False;
        Exit;
    end;

    if Vazia then
    begin
        SkSvgNotasVazio.Svg.Source    := IconeGradeVazia;
        LabelNotasVazioTitulo.Caption := 'Nenhuma nota carregada';
        LabelNotasVazioTexto.Caption  := 'Selecione uma pasta com XMLs e clique em Processar.';
        btnNotasVazio.Caption  := 'Selecionar pasta' + #$2026;
        btnNotasVazio.IconeSvg := IconePastaAberta;
        btnNotasVazio.OnClick  := NotasVazioSelecionarPastaClick;
    end
    else if ModeloVazio then
    begin
        //Glossário 8.8a (aprovado em 20/10/2026), em duas linhas como os outros estados: o que houve e
        //o que fazer. Sem botão (decisão do usuário de 21/10/2026)
        SkSvgNotasVazio.Svg.Source    := IconeGradeVazia;
        LabelNotasVazioTitulo.Caption := 'Nenhuma nota do modelo selecionado.';
        LabelNotasVazioTexto.Caption  := 'Escolha outro modelo na barra de cima.';
    end
    else
    begin
        Modelo := SeletorModelo.Itens[SeletorModelo.ItemIndex];
        SkSvgNotasVazio.Svg.Source    := IconeBuscaVazia;
        LabelNotasVazioTitulo.Caption := 'Nenhuma nota encontrada para ' + #$201C + Trim(EditBusca.Text) + #$201D;
        LabelNotasVazioTexto.Caption  := 'Confira o número ou a chave. A busca considera só o modelo selecionado (' +
                                         Modelo + ').';
        btnNotasVazio.Caption  := 'Limpar busca';
        btnNotasVazio.IconeSvg := IconeLimpar;
        btnNotasVazio.OnClick  := NotasVazioLimparBuscaClick;
    end;

    //Painel: a área da grade abaixo do título
    PnlNotasVazio.SetBounds(DBGrid1.Left, DBGrid1.Top + Escalar(AlturaTituloGrade), DBGrid1.Width,
                            Max(0, DBGrid1.Height - Escalar(AlturaTituloGrade)));

    //Ícone 48 px, título 12 pt Semibold, texto 10 pt (até 420 px) e o botão, 8 px entre eles, no centro
    Espaco  := Escalar(EspacoVazio);
    Icone   := Escalar(TamanhoIconeVazio);
    Margem  := btnNotasVazio.MargemFoco;
    LarguraTitulo := Max(1, PnlNotasVazio.ClientWidth - 2 * Escalar(Espaco2));
    Largura := Min(Escalar(LarguraTextoVazio), LarguraTitulo);
    AlturaTitulo := AlturaTextoQuebrado(LabelNotasVazioTitulo, LarguraTitulo);
    AlturaTexto  := AlturaTextoQuebrado(LabelNotasVazioTexto, Largura);
    AlturaEncaixe := Escalar(AlturaBotao) + 2 * Margem;
    PnlNotasVazioBotao.Width  := btnNotasVazio.LarguraIdeal;
    PnlNotasVazioBotao.Height := AlturaEncaixe;

    PnlNotasVazioBotao.Visible := ComBotao;
    Total := Icone + Espaco + AlturaTitulo + Espaco + AlturaTexto;
    if ComBotao then
        Inc(Total, Espaco - Margem + AlturaEncaixe - Margem);
    Topo  := Max(0, (PnlNotasVazio.ClientHeight - Total) div 2);
    SkSvgNotasVazio.SetBounds((PnlNotasVazio.ClientWidth - Icone) div 2, Topo, Icone, Icone);
    Inc(Topo, Icone + Espaco);
    LabelNotasVazioTitulo.SetBounds((PnlNotasVazio.ClientWidth - LarguraTitulo) div 2, Topo, LarguraTitulo, AlturaTitulo);
    Inc(Topo, AlturaTitulo + Espaco);
    LabelNotasVazioTexto.SetBounds((PnlNotasVazio.ClientWidth - Largura) div 2, Topo, Largura, AlturaTexto);
    Inc(Topo, AlturaTexto + Espaco - Margem);
    PnlNotasVazioBotao.SetBounds((PnlNotasVazio.ClientWidth - PnlNotasVazioBotao.Width) div 2, Topo,
                                 PnlNotasVazioBotao.Width, AlturaEncaixe);

    PnlNotasVazio.Visible := True;
    PnlNotasVazio.BringToFront;
end;

procedure TFormPrincipal.NotasVazioSelecionarPastaClick(Sender: TObject);
begin
    //"Selecionar pasta…" do estado vazio (6.22): mesmo seletor do Ctrl+O
    SelecionarPasta;
end;

procedure TFormPrincipal.NotasVazioLimparBuscaClick(Sender: TObject);
begin
    //"Limpar busca" (6.25): volta a mostrar todas as notas do modelo, com o foco no campo Buscar
    LimparBusca;
    if EditBusca.CanFocus then
        EditBusca.SetFocus;
end;

procedure TFormPrincipal.FDMemTable1FiltrarBusca(DataSet: TDataSet; var Accept: Boolean);
begin
    //Busca por número ou trecho da chave (glossário 6.17), somada ao filtro de modelo (Filter)
    Accept := (FBusca = '') or
              (Pos(FBusca, DataSet.FieldByName('chave').AsString) > 0) or
              (Pos(FBusca, DataSet.FieldByName('numero').AsString) > 0);
end;

procedure TFormPrincipal.AtualizarFiltroGrade;
var
    Modelo: Integer;
begin
    //Filtro da grade = modelo (Filter) + busca (OnFilterRecord). Desligar e religar o Filtered refaz
    //a busca com o texto novo. A cópia do cursor dos cards (NotasDoModelo) não é afetada
    if SeletorModelo = nil then
        Exit;

    Modelo := ModeloSelecionado;
    FDMemTable1.DisableControls;
    try
        if Modelo = FILTRO_MODELO_TODOS then
            FDMemTable1.Filter := ''
        else
            FDMemTable1.Filter := 'modelo = ' + IntToStr(Modelo);
        FDMemTable1.Filtered := False;
        FDMemTable1.Filtered := (FDMemTable1.Filter <> '') or (FBusca <> '');

        if FDMemTable1.Active then
            FDMemTable1.First;
    finally
        FDMemTable1.EnableControls;
    end;
end;

procedure TFormPrincipal.AplicarBusca;
var
    Texto: string;
begin
    //Filtra enquanto digita. Os espaços saem do texto: a chave copiada do DANFE vem em grupos de 4
    Texto := StringReplace(Trim(EditBusca.Text), ' ', '', [rfReplaceAll]);
    if Texto <> FBusca then
    begin
        FBusca := Texto;
        //Outra lista: a nota escolhida deixa de valer e a lista volta ao começo
        FNotaSelecionada := False;
        AtualizarFiltroGrade;
    end;
    AtualizarTelaNotas;
end;

procedure TFormPrincipal.LimparBusca;
begin
    //Esc no campo, "Limpar busca" e Processar (pasta nova)
    if EditBusca.Text <> '' then
        EditBusca.Text := ''   //o OnChange aplica a busca vazia
    else if FBusca <> '' then
        AplicarBusca;
end;

procedure TFormPrincipal.EditBuscaChange(Sender: TObject);
begin
    AplicarBusca;
end;

procedure TFormPrincipal.EditBuscaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    //Esc limpa a busca (glossário 6.18)
    if Key = VK_ESCAPE then
    begin
        LimparBusca;
        Key := 0;
    end;
end;

procedure TFormPrincipal.EditBuscaEnter(Sender: TObject);
begin
    AtualizarBordaCampo(PnlCampoBusca, SkSvgBusca, EditBusca, 0, True);
end;

procedure TFormPrincipal.EditBuscaExit(Sender: TObject);
begin
    AtualizarBordaCampo(PnlCampoBusca, SkSvgBusca, EditBusca, 0, False);
end;

procedure TFormPrincipal.AplicarOrdenacao;
var
    Campo   : string;
    Indice  : string;
    Seta    : string;
    Marcador: TBookmark;
    I       : Integer;
    Coluna  : TColumn;
begin
    //Ordenação pelo índice da FDMemTable1 (só a grade; a cópia dos cards não tem índice). Data pela
    //data real (data_ordem = aaaammdd); empate desfeito pelo Nº crescente
    Campo := FColunaOrdem;
    if Campo = 'data' then
        Campo := 'data_ordem';
    Indice := Campo;
    if FOrdemDecrescente then
        Indice := Indice + ':D';
    if Campo <> 'numero' then
        Indice := Indice + ';numero';

    FDMemTable1.DisableControls;
    try
        Marcador := nil;
        if NotaSelecionada then
            Marcador := FDMemTable1.GetBookmark;
        try
            FDMemTable1.IndexFieldNames := Indice;
            //Nota escolhida continua escolhida (a grade vai até ela); sem nota, a lista volta ao começo
            if (Marcador <> nil) and FDMemTable1.BookmarkValid(Marcador) then
                FDMemTable1.GotoBookmark(Marcador)
            else if FDMemTable1.Active then
                FDMemTable1.First;
        finally
            if Marcador <> nil then
                FDMemTable1.FreeBookmark(Marcador);
        end;
    finally
        FDMemTable1.EnableControls;
    end;

    //Seta (U+25B2/U+25BC) no fim do título da coluna ordenada (glossário 6.10); a cor vem na pintura do título
    if FOrdemDecrescente then
        Seta := SETA_DECRESCENTE
    else
        Seta := SETA_CRESCENTE;
    for I := 0 to DBGrid1.Columns.Count - 1 do
    begin
        Coluna := DBGrid1.Columns[I];
        if Coluna.FieldName = FColunaOrdem then
            Coluna.Title.Caption := TituloColuna(Coluna.FieldName) + ' ' + Seta
        else
            Coluna.Title.Caption := TituloColuna(Coluna.FieldName);
    end;
    DBGrid1.Invalidate;
end;

procedure TFormPrincipal.DBGrid1TitleClick(Column: TColumn);
begin
    //Clique no título: ordena pela coluna (crescente); de novo na mesma coluna, inverte
    if Column.FieldName = '' then
        Exit;

    if Column.FieldName = FColunaOrdem then
        FOrdemDecrescente := not FOrdemDecrescente
    else
    begin
        FColunaOrdem      := Column.FieldName;
        FOrdemDecrescente := False;
    end;
    AplicarOrdenacao;
end;

procedure TFormPrincipal.MarcarNotaSelecionada(const Selecionada: Boolean);
begin
    FNotaSelecionada := Selecionada and TemNotaVisivel;
    AtualizarTelaNotas;
end;

procedure TFormPrincipal.DBGrid1CliqueNota(Sender: TObject);
begin
    //Clique (esquerdo ou direito) numa nota: ela fica escolhida (o TDBGrid já a tornou a atual)
    MarcarNotaSelecionada(True);
end;

procedure TFormPrincipal.DBGrid1DblClick(Sender: TObject);
begin
    //Duplo clique numa nota = Gerar DANFE (glossário 6.14), pelo mesmo caminho do botão e do menu
    if DBGrid1.UltimoCliqueEmNota and NotaSelecionada then
        GerarDanfeSelecionada;
end;

procedure TFormPrincipal.DBGrid1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    //Teclado: sem nota escolhida, a primeira seta (ou Espaço) escolhe a nota atual sem andar;
    //depois, as teclas de navegação andam normalmente e a nota atual continua escolhida
    if not TemNotaVisivel then
        Exit;

    case Key of
        VK_UP, VK_DOWN, VK_SPACE:
            if not FNotaSelecionada then
            begin
                MarcarNotaSelecionada(True);
                Key := 0;
            end;
        VK_PRIOR, VK_NEXT, VK_HOME, VK_END:
            if not FNotaSelecionada then
                MarcarNotaSelecionada(True);
    end;
end;

procedure TFormPrincipal.PopupMenuPopup(Sender: TObject);
begin
    //Menu da grade: os itens seguem os botões da linha de título
    mnuCopiarChave.Enabled := NotaSelecionada;
    GerarDANFe1.Enabled    := NotaSelecionada and (not FGerandoDanfe);
end;

procedure TFormPrincipal.CopiarChaveClick(Sender: TObject);
begin
    CopiarChaveSelecionada;
end;

procedure TFormPrincipal.GerarDanfeClick(Sender: TObject);
begin
    GerarDanfeSelecionada;
end;

procedure TFormPrincipal.CampoMoedaGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
    //Valores em "R$ 1.234,56" com o formato pt-BR explícito (FormatarMoeda, etapa 4.3)
    if Sender.IsNull then
        Text := ''
    else if DisplayText then
        Text := FormatarMoeda(Sender.AsFloat)
    else
        Text := Sender.AsString;
end;

procedure TFormPrincipal.DBGrid1DesenharTitulo(Sender: TObject; const Area: TRect; Coluna: TColumn);
const
    ALINHAMENTO: array[TAlignment] of Cardinal = (DT_LEFT, DT_RIGHT, DT_CENTER);
var
    Tela  : TCanvas;
    Texto : TRect;
    Titulo: string;
begin
    //Título da coluna (tokens.md 5.7): fundo CorFundo, 10 pt Semibold CorTexto (a coluna ordenada em
    //CorPrimariaHover), alinhado como o dado, centralizado na altura, divisória inferior CorBorda
    Tela := DBGrid1.Canvas;
    Tela.Brush.Style := bsSolid;
    Tela.Brush.Color := CorFundo;
    Tela.FillRect(Rect(Area.Left, Area.Top, Area.Right, Area.Bottom - Escalar(DivisoriaGrade)));
    Tela.Brush.Color := CorBorda;
    Tela.FillRect(Rect(Area.Left, Area.Bottom - Escalar(DivisoriaGrade), Area.Right, Area.Bottom));

    Tela.Font.Assign(DBGrid1.TitleFont);
    if Coluna.FieldName = FColunaOrdem then
        Tela.Font.Color := CorPrimariaHover
    else
        Tela.Font.Color := CorTexto;
    Titulo := Coluna.Title.Caption;
    Texto  := Rect(Area.Left + Escalar(PaddingCelulaGrade), Area.Top, Area.Right - Escalar(PaddingCelulaGrade),
                   Area.Bottom - Escalar(DivisoriaGrade));
    Tela.Brush.Style := bsClear;
    DrawText(Tela.Handle, PChar(Titulo), Length(Titulo), Texto,
             DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX or DT_END_ELLIPSIS or ALINHAMENTO[Coluna.Title.Alignment]);
    Tela.Brush.Style := bsSolid;
end;

procedure TFormPrincipal.DBGrid1DrawColumnCell(Sender: TObject; const Area: TRect; DataCol: Integer;
  Column: TColumn; State: TGridDrawState);
const
    ALINHAMENTO: array[TAlignment] of Cardinal = (DT_LEFT, DT_RIGHT, DT_CENTER);
var
    Tela       : TCanvas;
    Fundo      : TColor;
    Selecionada: Boolean;
    Divisoria  : Integer;
    Texto      : TRect;
    Valor      : string;
begin
    //Linha (tokens.md 5.7): 10 pt CorTexto; linhas pares CorZebra; a nota escolhida em CorPrimariaSuave
    //com a marca de 3 px CorPrimaria na 1ª célula; divisória inferior de 1 px CorBorda
    Tela := DBGrid1.Canvas;
    Divisoria   := Escalar(DivisoriaGrade);
    Selecionada := FNotaSelecionada and (gdSelected in State);
    if Selecionada then
        Fundo := CorPrimariaSuave
    else if (DBGrid1.DataSource.DataSet.RecNo mod 2) = 0 then
        Fundo := CorZebra
    else
        Fundo := CorSuperficie;

    Tela.Brush.Style := bsSolid;
    Tela.Brush.Color := Fundo;
    Tela.FillRect(Rect(Area.Left, Area.Top, Area.Right, Area.Bottom - Divisoria));
    Tela.Brush.Color := CorBorda;
    Tela.FillRect(Rect(Area.Left, Area.Bottom - Divisoria, Area.Right, Area.Bottom));
    if Selecionada and (Column.Index = 0) then
    begin
        Tela.Brush.Color := CorPrimaria;
        Tela.FillRect(Rect(Area.Left, Area.Top, Area.Left + Escalar(MarcaSelecaoGrade), Area.Bottom - Divisoria));
    end;

    //Texto: valores pelo OnGetText (R$ pt-BR), centralizado na altura, com reticências se não couber
    Valor := '';
    if Column.Field <> nil then
        Valor := Column.Field.DisplayText;
    Tela.Font.Assign(DBGrid1.Font);
    Tela.Font.Color := CorTexto;
    Texto := Rect(Area.Left + Escalar(PaddingCelulaGrade), Area.Top, Area.Right - Escalar(PaddingCelulaGrade),
                  Area.Bottom - Divisoria);
    Tela.Brush.Style := bsClear;
    DrawText(Tela.Handle, PChar(Valor), Length(Valor), Texto,
             DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX or DT_END_ELLIPSIS or ALINHAMENTO[Column.Alignment]);
    Tela.Brush.Style := bsSolid;
end;

procedure TFormPrincipal.AjustarAvisoChaveCopiada;
var
    Medida      : TBitmap;
    LarguraTexto: Integer;
    AlturaTexto : Integer;
    Icone       : Integer;
    Largura     : Integer;
    Altura      : Integer;
begin
    //Aviso flutuante (tokens.md 5.11): padding 8 x 16, ícone check 16 px + 8 px + texto, centralizado
    //na base da grade, 16 px acima da borda
    Medida := TBitmap.Create;
    try
        Medida.Canvas.Font.Assign(LabelChaveCopiada.Font);
        LarguraTexto := Medida.Canvas.TextWidth(LabelChaveCopiada.Caption);
        AlturaTexto  := Medida.Canvas.TextHeight('Ag');
    finally
        Medida.Free;
    end;

    Icone   := Escalar(TamanhoIconePequeno);
    Largura := 2 * Escalar(PaddingAvisoHorizontal) + Icone + Escalar(Espaco1) + LarguraTexto;
    Altura  := 2 * Escalar(PaddingAvisoVertical) + Max(Icone, AlturaTexto);
    PnlChaveCopiada.SetBounds(DBGrid1.Left + (DBGrid1.Width - Largura) div 2,
                              DBGrid1.Top + DBGrid1.Height - Escalar(DistanciaAvisoBorda) - Altura, Largura, Altura);
    SkSvgChaveCopiada.SetBounds(Escalar(PaddingAvisoHorizontal), (Altura - Icone) div 2, Icone, Icone);
    LabelChaveCopiada.SetBounds(Escalar(PaddingAvisoHorizontal) + Icone + Escalar(Espaco1), (Altura - AlturaTexto) div 2,
                                LarguraTexto, AlturaTexto);
end;

procedure TFormPrincipal.MostrarAvisoChaveCopiada;
begin
    //"Chave copiada" (6.19) por 2 s; copiar de novo reinicia o tempo
    AjustarAvisoChaveCopiada;
    TimerChaveCopiada.Enabled := False;
    PnlChaveCopiada.Visible := True;
    PnlChaveCopiada.BringToFront;
    TimerChaveCopiada.Enabled := True;
end;

procedure TFormPrincipal.TimerChaveCopiadaTimer(Sender: TObject);
begin
    TimerChaveCopiada.Enabled := False;
    PnlChaveCopiada.Visible := False;
end;

function TFormPrincipal.MontarCSV: string;
var
    Linhas  : TStringBuilder;
    Marcador: TBookmark;

    function Valor(const Campo: string): string;
    begin
        //Vírgula decimal, sem "R$" e sem separador de milhar (PD-2), independente do Windows
        Result := FormatFloat('0.00', FDMemTable1.FieldByName(Campo).AsFloat, FormatoPtBR);
    end;

begin
    //Linhas visíveis na grade (filtro de modelo + busca), na ordem da grade; separador ";" (PD-2)
    Linhas := TStringBuilder.Create;
    try
        //Cabeçalho (glossário 6.29)
        Linhas.Append('Nº;Modelo;Data;Chave;Valor;Base ICMS;ICMS;Base IBS/CBS;IBS UF;IBS Mun.;IBS;CBS');
        Linhas.Append(sLineBreak);

        if TemNotaVisivel then
        begin
            FDMemTable1.DisableControls;
            try
                Marcador := FDMemTable1.GetBookmark;
                try
                    FDMemTable1.First;
                    while not FDMemTable1.Eof do
                    begin
                        Linhas.Append(FDMemTable1.FieldByName('numero').AsString).Append(';');
                        Linhas.Append(FDMemTable1.FieldByName('modelo').AsString).Append(';');
                        Linhas.Append(FDMemTable1.FieldByName('data').AsString).Append(';');
                        //Chave como texto (D4): ="..." faz o Excel mostrar os 44 dígitos, sem notação científica
                        Linhas.Append('="').Append(FDMemTable1.FieldByName('chave').AsString).Append('";');
                        Linhas.Append(Valor('vtotal')).Append(';');
                        Linhas.Append(Valor('bcicms')).Append(';');
                        Linhas.Append(Valor('vlicms')).Append(';');
                        Linhas.Append(Valor('vbcibscbs')).Append(';');
                        Linhas.Append(Valor('vibsuf')).Append(';');
                        Linhas.Append(Valor('vibsmun')).Append(';');
                        Linhas.Append(Valor('vibs')).Append(';');
                        Linhas.Append(Valor('vcbs'));
                        Linhas.Append(sLineBreak);
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
        end;

        Result := Linhas.ToString;
    finally
        Linhas.Free;
    end;
end;

procedure TFormPrincipal.ExportarCSV(const Caminho: string);
var
    Arquivo   : TFileStream;
    Preambulo : TBytes;
    Dados     : TBytes;
begin
    //UTF-8 com BOM: o Excel pt-BR abre direto, com os acentos do cabeçalho
    Preambulo := TEncoding.UTF8.GetPreamble;
    Dados     := TEncoding.UTF8.GetBytes(MontarCSV);
    Arquivo := TFileStream.Create(Caminho, fmCreate);
    try
        if Length(Preambulo) > 0 then
            Arquivo.WriteBuffer(Preambulo[0], Length(Preambulo));
        if Length(Dados) > 0 then
            Arquivo.WriteBuffer(Dados[0], Length(Dados));
    finally
        Arquivo.Free;
    end;
end;

procedure TFormPrincipal.ExportarCSVClick(Sender: TObject);
var
    Dialogo: TSaveDialog;
begin
    //Exportar CSV (glossário 6.26 a 6.31): pergunta onde salvar e grava as linhas visíveis
    if not TemNotaVisivel then
        Exit;

    Dialogo := TSaveDialog.Create(Self);
    try
        Dialogo.Title      := 'Exportar notas para CSV';
        Dialogo.Filter     := 'Arquivo CSV (separado por ;) (*.csv)|*.csv';
        Dialogo.DefaultExt := 'csv';
        Dialogo.FileName   := 'ProXML-notas-' + FormatDateTime('yyyy"-"mm"-"dd', Date, FormatoPtBR) + '.csv';
        Dialogo.Options    := [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofNoReadOnlyReturn, ofEnableSizing];
        if not Dialogo.Execute then
            Exit;

        try
            ExportarCSV(Dialogo.FileName);
        except
            on E: Exception do
            begin
                try
                    DMConfig.CreateLog(E.ClassName, 'Exportar CSV: ' + E.Message);
                except
                    on ELog: Exception do
                        OutputDebugString(PChar('ProXML: ' + ELog.Message));
                end;
                messagedlg('Não foi possível salvar o arquivo CSV.' + sLineBreak + sLineBreak + 'Motivo: ' + E.Message,
                           mtError, [mbOk], 0);
                Exit;
            end;
        end;

        messagedlg('Arquivo CSV salvo:' + sLineBreak + Dialogo.FileName, mtInformation, [mbOk], 0);
    finally
        Dialogo.Free;
    end;
end;

end.
