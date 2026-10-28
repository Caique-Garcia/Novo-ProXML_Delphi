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

const
  //Erro ao ler as configurações de e-mail no FormCreate: a caixa 12.18 aparece depois que a janela abre
  WM_PROXML_ERRO_CONFIG = WM_APP + 44;

type

  //Telas da área de conteúdo (Plano 4, etapa 4.4). Cada tela é uma aba do PageControl1 e toda
  //troca de tela passa por TFormPrincipal.MostrarTela, que também sincroniza o item ativo do menu
  TTela = (tlResumo, tlNotas, tlRelatorios, tlEnviar, tlConfiguracoes, tlCarregando, tlSobre);
  //Telas com item no menu lateral. Carregando não tem item (o item da tela de origem continua
  //destacado) e a tela Sobre (etapa 4.7, aberta pelo cabeçalho) deixa o menu sem item ativo
  TTelaMenu = tlResumo..tlConfiguracoes;

  //Motivos de bloqueio da tela (tokens.md 5.13; etapas 4.6 e 4.7): leitura dos XMLs, envio do e-mail,
  //tela Carregando (DANFE e relatórios, H4) e Testar conexão. Com qualquer motivo ativo ficam
  //desabilitados o menu, a barra de pasta (campo, Selecionar…, modelo e Processar), o "Sobre" do
  //cabeçalho e os atalhos
  TMotivoBloqueio = (blLeitura, blEnvio, blCarregando, blTeste);
  TBloqueios = set of TMotivoBloqueio;

  //Tipo da faixa de status (tokens.md 5.8): cor do fundo, da barra e do ícone
  TTipoFaixa = (tfSucesso, tfAviso, tfErro, tfInformacao);

  //Validação de um campo de formulário: devolve a mensagem de erro do glossário ('' = válido)
  TValidarCampo = function(const Texto: string): string of object;

  { Campo de formulário com borda própria (Plano 4, etapa 4.7; tokens.md 5.3): contêiner com a cor da
    borda (Padding = espessura), fundo, ícone opcional à esquerda, ícone clicável opcional à direita
    (olho da senha), o TEdit/TMemo sem borda e a linha de erro abaixo (circle-alert 14 px + texto 9 pt
    CorErro). Só guarda as referências e o estado: o visual e a posição ficam na tela. }
  TCampoFormulario = class
  public
    Borda     : TPanel;
    Fundo     : TPanel;
    Icone     : TSkSvg;        //nil: sem ícone à esquerda
    Edit      : TCustomEdit;   //TEdit ou TMemo
    Acao      : TSkSvg;        //nil: sem ícone à direita
    IconeErro : TSkSvg;        //nil: campo sem validação
    LabelErro : TLabel;
    Validar   : TValidarCampo;
    Validando : Boolean;       //saiu do campo com erro: passa a validar a cada digitação
    Erro      : string;        //mensagem de erro visível ('' = sem erro na tela)
    //O texto atual passa na validação (independe de o erro estar visível)
    function Valido: Boolean;
  end;

  //Resumo sem leitura em andamento: nenhuma pasta processada ainda ou o resultado da última leitura
  TEstadoResumo = (esrVazio, esrConcluido);

  //Trecho de texto das faixas de status do Resumo (tokens.md 5.8: primeira frase em Semibold)
  TEstiloTrecho = (etrNormal, etrDestaque, etrLegenda);
  TTrechoTexto = record
    Texto     : string;
    Estilo    : TEstiloTrecho;
    NovaLinha : Boolean;   //o trecho começa numa linha nova
  end;
  TTrechosTexto = array of TTrechoTexto;

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
    //Resumo (etapa 4.6; mockup resumo.html e glossário 5.1 a 5.36): faixa de status, estado vazio,
    //leitura em andamento (progresso + Cancelar) e resultado (contadores, aviso e log com ícones)
    PnlResumo: TPanel;
    PnlFaixaResumo: TPanel;
    PnlFaixaResumoBarra: TPanel;
    SkSvgFaixaResumo: TSkSvg;
    PbxFaixaResumo: TPaintBox;
    PnlResumoVazio: TPanel;
    PnlResumoVazioFundo: TPanel;
    SkSvgResumoVazio: TSkSvg;
    LabelResumoVazioTitulo: TLabel;
    LabelResumoVazioTexto: TLabel;
    PnlResumoVazioBotao: TPanel;
    LabelResumoVazioAtalhos: TLabel;
    PnlProgresso: TPanel;
    PnlProgressoFundo: TPanel;
    LabelProgressoTitulo: TLabel;
    PnlProgressoTrilho: TPanel;
    PnlProgressoBarra: TPanel;
    LabelProgressoContagem: TLabel;
    LabelProgressoArquivo: TLabel;
    PnlCancelar: TPanel;
    LabelProgressoDica: TLabel;
    PnlConcluido: TPanel;
    PnlContadores: TPanel;
    PnlContadorAutorizadas: TPanel;
    PnlContadorAutorizadasTopo: TPanel;
    PnlContadorAutorizadasFundo: TPanel;
    SkSvgContadorAutorizadas: TSkSvg;
    LabelNumeroAutorizadas: TLabel;
    LabelRotuloAutorizadas: TLabel;
    PnlContadorIgnoradas: TPanel;
    PnlContadorIgnoradasTopo: TPanel;
    PnlContadorIgnoradasFundo: TPanel;
    SkSvgContadorIgnoradas: TSkSvg;
    LabelNumeroIgnoradas: TLabel;
    LabelRotuloIgnoradas: TLabel;
    PnlContadorComErro: TPanel;
    PnlContadorComErroTopo: TPanel;
    PnlContadorComErroFundo: TPanel;
    SkSvgContadorComErro: TSkSvg;
    LabelNumeroComErro: TLabel;
    LabelRotuloComErro: TLabel;
    PnlContadorTempo: TPanel;
    PnlContadorTempoTopo: TPanel;
    PnlContadorTempoFundo: TPanel;
    SkSvgContadorTempo: TSkSvg;
    LabelNumeroTempo: TLabel;
    LabelRotuloTempo: TLabel;
    PnlAvisoResumo: TPanel;
    PnlAvisoResumoBarra: TPanel;
    SkSvgAvisoResumo: TSkSvg;
    PbxAvisoResumo: TPaintBox;
    PnlLog: TPanel;
    PnlLogFundo: TPanel;
    PnlLogTitulo: TPanel;
    LabelLogTitulo: TLabel;
    LabelLogData: TLabel;
    PnlLogDivisoria: TPanel;
    ListBoxLog: TListBox;
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
    //Tela Enviar (etapa 4.7; mockup enviar.html e glossário 11.1 a 11.22): quadro com borda (Panel10,
    //dentro da rolagem de reserva), título, faixa de resultado, anexo, Para, Mensagem, remetente e Enviar
    Enviar: TTabSheet;
    Panel10: TPanel;
    PnlEnviarFundo: TPanel;
    Label11: TLabel;
    PnlFaixaEnviar: TPanel;
    PnlFaixaEnviarBarra: TPanel;
    SkSvgFaixaEnviar: TSkSvg;
    PbxFaixaEnviar: TPaintBox;
    PnlAnexo: TPanel;
    PnlAnexoFundo: TPanel;
    SkSvgAnexo: TSkSvg;
    LabelAnexoTitulo: TLabel;
    LabelAnexoDetalhe: TLabel;
    Label15: TLabel;
    PnlCampoPara: TPanel;
    PnlCampoParaFundo: TPanel;
    SkSvgPara: TSkSvg;
    EditEmailEnviar: TEdit;
    SkSvgErroPara: TSkSvg;
    LabelErroPara: TLabel;
    Label17: TLabel;
    PnlCampoMensagem: TPanel;
    PnlCampoMensagemFundo: TPanel;
    MemoMensagem: TMemo;
    LabelRemetente: TLabel;
    PnlAlterarConfig: TPanel;
    Panel11: TPanel;
    LabelEnviando: TLabel;
    //Tela Configurações (etapa 4.7; mockup configuracoes.html e glossário 12.1 a 12.25)
    Config: TTabSheet;
    PanelCorpoConfig: TPanel;
    PnlConfigFundo: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    PnlFaixaConfig: TPanel;
    PnlFaixaConfigBarra: TPanel;
    SkSvgFaixaConfig: TSkSvg;
    PbxFaixaConfig: TPaintBox;
    Label4: TLabel;
    PnlCampoSMTP: TPanel;
    PnlCampoSMTPFundo: TPanel;
    EditSMTP: TEdit;
    SkSvgErroSMTP: TSkSvg;
    LabelErroSMTP: TLabel;
    Label7: TLabel;
    PnlCampoPorta: TPanel;
    PnlCampoPortaFundo: TPanel;
    EditPorta: TEdit;
    SkSvgErroPorta: TSkSvg;
    LabelErroPorta: TLabel;
    LabelSeguranca: TLabel;
    CheckBoxSSL: TCheckBox;
    CheckBoxTSL: TCheckBox;
    LabelAjudaSeguranca: TLabel;
    Label8: TLabel;
    PnlCampoEmail: TPanel;
    PnlCampoEmailFundo: TPanel;
    SkSvgEmail: TSkSvg;
    EditEmail: TEdit;
    SkSvgErroEmail: TSkSvg;
    LabelErroEmail: TLabel;
    Label9: TLabel;
    PnlCampoSenha: TPanel;
    PnlCampoSenhaFundo: TPanel;
    SkSvg5: TSkSvg;
    EditPass: TEdit;
    LabelAjudaSenha: TLabel;
    Label10: TLabel;
    PnlCampoMsg: TPanel;
    PnlCampoMsgFundo: TPanel;
    MemoMsg: TMemo;
    PnlTestarConexao: TPanel;
    LabelTestando: TLabel;
    SkSvgConfigSalva: TSkSvg;
    LabelConfigSalva: TLabel;
    Panel9: TPanel;
    TimerConfigSalva: TTimer;
    TimerTesteConexao: TTimer;
    //Tela Sobre (etapa 4.7; mockup sobre.html e glossário 13.1 a 13.6), aberta pelo "Sobre" do cabeçalho
    TelaSobre: TTabSheet;
    PnlTelaSobre: TPanel;
    PnlTelaSobreFundo: TPanel;
    SkSvgSobreLogo: TSkSvg;
    LabelSobreVersao: TLabel;
    LabelSobreDescricao: TLabel;
    LabelSobreAutor: TLabel;
    PnlSobreLink: TPanel;
    LabelSobreCreditos: TLabel;
    PnlSobreAtivo: TPanel;
    ACBrMail1: TACBrMail;
    ACBrNFeDANFEFR: TACBrNFeDANFEFR;
    LabelFiltroModelo: TLabel;
    //Faixa de aviso no Resumo (etapa 4.3): pasta salva que não existe mais (glossário 2.14)
    PnlAvisoPasta: TPanel;
    PnlAvisoPastaBarra: TPanel;
    SkSvgAvisoPasta: TSkSvg;
    PbxAvisoPasta: TPaintBox;
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
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
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
    FPastaNaoEncontrada: string;   //pasta do aviso 2.14 (o texto da faixa encurta o caminho)
    FTrechosAvisoPasta : TTrechosTexto;  //texto da faixa 2.14 (etapa 4.9: mesmo desenho das outras faixas)
    FJanelaCampoPasta  : TWndMethod;     //WindowProc original do campo da pasta (etapa 4.9, A1)       //escala atual da tela (o PixelsPerInch do 10.2 fica com o valor do .dfm)
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
    //Etapa 4.6: leitura e envio em segundo plano, bloqueio e Resumo
    FBloqueios          : TBloqueios;     //motivos de bloqueio ativos (vazio = tela livre)
    FLeitura            : TThreadLeituraXML;  //thread da última leitura (liberada na próxima ou no fim do app)
    FLendo              : Boolean;        //leitura em andamento (do Processar até o fim da thread)
    FCancelamentoPedido : Boolean;        //Cancelar ou Esc durante a leitura (PD-3: descarta o que foi lido)
    FFechando           : Boolean;        //a janela vai fechar (pergunta 5.28 respondida com Sim)
    FProgressoLidos     : Integer;        //último progresso recebido da thread
    FProgressoTotal     : Integer;
    FProgressoArquivo   : string;
    FEstadoResumo       : TEstadoResumo;  //o que o Resumo mostra quando não há leitura em andamento
    FTrechosFaixaResumo : TTrechosTexto;  //texto da faixa de status (cancelado, nenhum XML)
    FTrechosAvisoResumo : TTrechosTexto;  //texto da faixa de aviso (homologação e entrada)
    FAjustandoResumo    : Boolean;        //evita reentrada no layout do Resumo
    FVazioAposCancelar  : Boolean;        //estado vazio depois de cancelar no primeiro uso (texto 5.37, sem botão)
    FIconesLog          : array[TTipoLinhaLog] of TBitmap;   //ícones do log já desenhados na escala atual
    FEnvio              : TThread;        //thread do último envio de e-mail
    FEnviando           : Boolean;        //envio do e-mail em andamento
    //Etapa 4.7: campos com borda própria, Enviar, Configurações, Testar conexão e Sobre
    FCampos             : array of TCampoFormulario;  //todos os campos com borda própria (liberados no fim)
    FCampoPara          : TCampoFormulario;
    FCampoMensagemEnviar: TCampoFormulario;
    FCampoServidor      : TCampoFormulario;
    FCampoPorta         : TCampoFormulario;
    FCampoEmail         : TCampoFormulario;
    FCampoSenha         : TCampoFormulario;
    FCampoMensagemConfig: TCampoFormulario;
    FAjustandoRolagem   : Boolean;        //evita reentrada no ajuste das telas com rolagem de reserva
    FTrechosFaixaEnviar : TTrechosTexto;  //texto da faixa da tela Enviar
    FPastaFaixaEnviar   : string;         //pasta do WinRAR na faixa 11.20 (cortada no meio na largura da faixa)
    FResultadoEnvio     : Boolean;        //a faixa mostra o resultado do último envio (fica até sair da tela)
    FAnexoQuantidade    : Integer;        //XMLs do filtro de modelo (quadro do anexo, 11.3)
    FAnexoBytes         : Int64;          //soma do tamanho dos XMLs, sem compactar (11.4)
    FTrechosFaixaConfig : TTrechosTexto;  //texto da faixa de Configurações (resultado do Testar conexão)
    FTeste              : TThread;        //thread do Testar conexão em andamento (TThreadTesteSMTP)
    FTestesEncerrados   : TList;          //testes que passaram do limite de 15 s e ainda não terminaram
    FTestando           : Boolean;        //Testar conexão em andamento
    FErroLeituraConfig  : string;         //12.18 no FormCreate: a caixa aparece depois que a janela abre
    FPastaLeitura       : string;         //pasta do último Processar (texto 5.38)
    FPastaNotas         : string;         //pasta das notas carregadas na grade (linha "Pasta:" dos relatórios)
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
    procedure AtualizarBordaCampo(Borda: TPanel; Icone: TSkSvg; Edit: TCustomEdit; const Margem: Integer;
      const ComFoco: Boolean; const ComErro: Boolean = False; Acao: TSkSvg = nil);
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
    procedure ConfigACBR;
    procedure GerarDanfe(const CaminhoArq, Numero: String);
    function  ConfigurarLayoutDanfe(out Mensagem: string): Boolean;
    function  AguardarArquivoPDF(const Caminhos: array of string; out CaminhoGerado: string): Boolean;
    procedure LerConfigEmail();
    procedure ApplicationException(Sender: TObject; E: Exception);
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
    procedure PbxAvisoPastaPaint(Sender: TObject);
    procedure JanelaCampoPasta(var Message: TMessage);
    function  LarguraTextoFaixa(const LarguraFaixa: Integer): Integer;
    procedure MontarTrechosSemWinRAR;
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
    //Plano 4, etapa 4.6: leitura e envio em segundo plano, bloqueio da tela e Resumo
    procedure DefinirBloqueio(const Motivo: TMotivoBloqueio; const Ativo: Boolean);
    procedure AplicarBloqueio;
    procedure AcaoSelecionarPastaUpdate(Sender: TObject);
    procedure AcaoBuscarUpdate(Sender: TObject);
    procedure AcaoCancelarLeituraExecute(Sender: TObject);
    procedure AcaoCancelarLeituraUpdate(Sender: TObject);
    procedure PrepararResumo;
    procedure PrepararContador(Borda, Topo, Fundo: TPanel; Icone: TSkSvg; Numero, Rotulo: TLabel;
      const CorStatus, CorNumero: TColor; const IconeSvg, TextoRotulo: string);
    procedure PrepararFaixa(Faixa, Barra: TPanel; Icone: TSkSvg; const CorDoFundo, CorDaBarra: TColor;
      const IconeSvg: string);
    procedure AjustarFaixa(Faixa, Barra: TPanel; Icone: TSkSvg; Texto: TPaintBox; const Trechos: TTrechosTexto;
      const PaddingVertical: Integer);
    procedure AjustarLayoutResumo;
    procedure AjustarLayoutResumoVazio;
    procedure AjustarLayoutProgresso;
    procedure AjustarContadores;
    procedure AjustarTituloLog;
    procedure PnlResumoVazioFundoResize(Sender: TObject);
    procedure PnlProgressoFundoResize(Sender: TObject);
    procedure PnlContadoresResize(Sender: TObject);
    procedure PnlFaixaResumoResize(Sender: TObject);
    procedure PnlAvisoResumoResize(Sender: TObject);
    procedure PbxFaixaResumoPaint(Sender: TObject);
    procedure PbxAvisoResumoPaint(Sender: TObject);
    procedure FonteDoTrecho(Fonte: TFont; const Estilo: TEstiloTrecho);
    function  DesenharTrechos(Tela: TCanvas; const Trechos: TTrechosTexto; const Area: TRect;
      const Desenhar: Boolean): Integer;
    function  MedirTrechos(const Trechos: TTrechosTexto; const Largura: Integer): Integer;
    procedure MostrarFaixaResumo(const Trechos: TTrechosTexto);
    procedure OcultarFaixaResumo;
    procedure MostrarEstadoResumo;
    procedure IniciarLeitura(const Pasta: string);
    procedure LiberarThreadLeitura;
    procedure CancelarLeitura;
    procedure CancelarLeituraClick(Sender: TObject);
    procedure ResumoSelecionarPastaClick(Sender: TObject);
    procedure LeituraProgresso(const Lidos, Total: Integer; const Arquivo: string);
    procedure AtualizarProgresso;
    procedure LeituraTerminada(Sender: TObject);
    procedure EncerrarLeituraParaFechar;
    procedure CarregarNotasLidas(Resultado: TResultadoLeitura);
    procedure MostrarResultadoLeitura(Resultado: TResultadoLeitura);
    procedure MostrarAvisoResumo(const Homologacao, Entrada: Integer);
    procedure MostrarCancelamento(const Lidos, Total: Integer);
    function  TextoArquivosLidos(const Quantidade: Integer): string;
    function  EncurtarNoMeio(Fonte: TFont; const Texto: string; const Largura: Integer): string;
    function  IconeLog(const Tipo: TTipoLinhaLog): TBitmap;
    procedure LiberarIconesLog;
    procedure ListBoxLogDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure ListBoxLogMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure IniciarEnvio;
    procedure LiberarThreadEnvio;
    procedure EnvioTerminado(Sender: TObject);
    procedure RestaurarBotaoEnviar;
    //Plano 4, etapa 4.7: campos com borda própria, Enviar, Configurações, Testar conexão e Sobre
    function  CriarCampo(Borda, Fundo: TPanel; Icone: TSkSvg; Edit: TCustomEdit; Acao, IconeErro: TSkSvg;
      LabelErro: TLabel; const Validar: TValidarCampo): TCampoFormulario;
    function  CampoDoControle(Controle: TObject): TCampoFormulario;
    procedure AtualizarCampo(Campo: TCampoFormulario);
    procedure HabilitarCampo(Campo: TCampoFormulario; const Habilitar: Boolean);
    procedure ValidarCampo(Campo: TCampoFormulario);
    function  PosicionarCampo(Campo: TCampoFormulario; Rotulo: TLabel; const X, Y, Largura, Altura: Integer): Integer;
    function  PosicionarLegenda(Rotulo: TLabel; const X, Y, Largura: Integer): Integer;
    procedure CampoEnter(Sender: TObject);
    procedure CampoExit(Sender: TObject);
    procedure CampoChange(Sender: TObject);
    function  ValidarEmailDestino(const Texto: string): string;
    function  ValidarServidor(const Texto: string): string;
    function  ValidarPorta(const Texto: string): string;
    function  ValidarEmailRemetente(const Texto: string): string;
    procedure DefinirTipoFaixa(Faixa, Barra: TPanel; Icone: TSkSvg; const Tipo: TTipoFaixa);
    procedure AjustarRolagem(Caixa: TScrollBox);
    procedure GravarLog(const Classe, Texto: string);
    procedure PrepararTelaEnviar;
    function  AjustarLayoutEnviar: Integer;
    procedure AtualizarAnexoEnviar;
    procedure AtualizarTelaEnviar;
    procedure MostrarFaixaEnviar(const Tipo: TTipoFaixa; const Trechos: TTrechosTexto; const Resultado: Boolean);
    procedure OcultarResultadoEnvio;
    procedure PbxFaixaEnviarPaint(Sender: TObject);
    procedure AlterarConfigClick(Sender: TObject);
    function  SMTPConfigurado: Boolean;
    procedure PrepararTelaConfig;
    function  AjustarLayoutConfig: Integer;
    procedure CarregarConfigNaTela;
    procedure AtualizarEstadoConfig;
    procedure MostrarFaixaConfig(const Tipo: TTipoFaixa; const Trechos: TTrechosTexto);
    procedure OcultarFaixaConfig;
    procedure PbxFaixaConfigPaint(Sender: TObject);
    procedure TimerConfigSalvaTimer(Sender: TObject);
    procedure TestarConexaoClick(Sender: TObject);
    procedure IniciarTesteConexao;
    procedure TesteConexaoTerminado(Sender: TObject);
    procedure TimerTesteConexaoTimer(Sender: TObject);
    procedure EncerrarTesteConexao;
    procedure LiberarThreadsTeste(const Fechando: Boolean);
    procedure PrepararTelaSobre;
    procedure AjustarLayoutSobre;
    procedure PnlTelaSobreFundoResize(Sender: TObject);
    procedure SobreClick(Sender: TObject);
    procedure LinkGitHubClick(Sender: TObject);
    procedure AtualizarVisualSobre;
    procedure WMProXMLErroConfig(var Message: TMessage); message WM_PROXML_ERRO_CONFIG;

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
    actCancelarLeitura : TAction;   //Esc (durante a leitura dos XMLs)
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
    //Resumo (etapa 4.6): Cancelar da leitura e "Selecionar pasta…" do estado vazio (PrepararResumo)
    btnCancelar        : TProBotao;
    btnResumoVazio     : TProBotao;
    //Etapa 4.7: Testar conexão (Configurações), "alterar em Configurações" (Enviar) e o link do GitHub (Sobre)
    btnTestarConexao   : TProBotao;
    btnAlterarConfig   : TProBotao;
    btnLinkGitHub      : TProBotao;
    //Leitura dos XMLs em andamento (thread) e envio do e-mail em andamento
    property  Lendo: Boolean read FLendo;
    property  Enviando: Boolean read FEnviando;
    //Testar conexão em andamento (thread)
    property  Testando: Boolean read FTestando;
    //Versão do executável (VersionInfo), ex.: "1.1.0" (tela Sobre, glossário 13.1)
    function  VersaoDoExecutavel: string;
    //Algum motivo de bloqueio ativo (leitura, envio ou tela Carregando)
    function  Bloqueado: Boolean;
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
  Winapi.ActiveX,
  //Synapse (o mesmo do ACBrMail): Testar conexão sem enviar e-mail (etapa 4.7)
  synsock,
  blcksock,
  smtpsend,
  ssl_openssl,
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

  //Testar conexão (etapa 4.7, glossário 12.22): sem resposta do servidor em 15 s, o teste acaba com o
  //texto "não respondeu"
  TEMPO_LIMITE_TESTE_MS = 15000;

  //Título de todas as caixas de mensagem (glossário 15.1)
  TITULO_CAIXAS = 'ProXML';

  //Link da tela Sobre (glossário 13.4)
  URL_GITHUB   = 'https://github.com/Caique-Garcia/Novo-ProXML_Delphi';
  TEXTO_GITHUB = 'github.com/Caique-Garcia/Novo-ProXML_Delphi';

type
  //Resultado do envio do e-mail, mostrado na thread principal. reSemWinRAR: o WinRAR.exe não está na
  //pasta do ProXML (11.20); reSemAnexo: o WinRAR rodou, mas o .rar não foi gerado
  TResultadoEnvio = (reEnviado, reSemWinRAR, reSemAnexo, reErro);

  //Acesso às propriedades protegidas de TCustomEdit (Font, Color e eventos) para TEdit e TMemo
  TEditAcesso = class(TCustomEdit);

  { Compactação (WinRAR) e envio do e-mail numa thread própria (Plano 4, etapa 4.6).
    TThread própria em vez de ACBrMail.UseThread: a compactação também precisa sair da thread principal
    e o resultado (enviado, sem anexo ou erro) volta num ponto só, o OnTerminate, já na thread principal.
    Os dados da tela (XMLs do filtro, destino, assunto e mensagem) são copiados na thread principal antes
    do Start: aqui nada toca em controles, no DataSet nem no banco. }
  TThreadEnvioEmail = class(TThread)
  private
    FACBrNFe    : TACBrNFe;
    FPastaApp   : string;
    FPara       : string;
    FAssunto    : string;
    FMensagem   : TStringList;
    FOrigens    : TStringList;   //XMLs das notas (caminho completo)
    FNomes      : TStringList;   //nome de cada XML dentro do anexo (<chave>-nfe.xml)
    FResultado  : TResultadoEnvio;
    FErro       : string;
    FClasseErro : string;
    procedure Compactar;
  protected
    procedure Execute; override;
  public
    //Criada suspensa: quem cria acrescenta os XMLs, liga o OnTerminate e chama Start
    constructor Create(ACBrNFe: TACBrNFe; const PastaApp, Para, Assunto: string; Mensagem: TStrings);
    destructor Destroy; override;
    procedure AdicionarXML(const Origem, Nome: string);
    //Destino (um só endereço, 11.18) e assunto (11.21; definido antes do Start)
    property Para: string read FPara;
    property Assunto: string read FAssunto write FAssunto;
    property Resultado: TResultadoEnvio read FResultado;
    property Erro: string read FErro;
    property ClasseErro: string read FClasseErro;
  end;

  { Testar conexão (Plano 4, etapa 4.7; PD-4 e glossário 12.19 a 12.22): só conecta e autentica no
    servidor SMTP com o TSMTPSend do Synapse (o mesmo que o ACBrMail usa), sem enviar e-mail.
    Os dados vêm da tela (copiados na thread principal antes do Start) e nada é gravado.
    Limite de 15 s: o socket do Synapse tem 15 s para cada resposta (a conexão é bloqueante, para a porta
    fechada voltar na hora), e a tela tem um cronômetro próprio de 15 s. Se ele vencer antes, a tela mostra "não respondeu" e chama Abortar, que
    fecha o socket para a thread terminar logo. Aqui nada toca em controles nem no banco. }
  TThreadTesteSMTP = class(TThread)
  private
    FSMTP      : TSMTPSend;
    FServidor  : string;
    FPorta     : string;
    FConectou  : Boolean;   //conectou e o servidor aceitou o usuário e a senha
    FRespondeu : Boolean;   //o servidor mandou alguma resposta SMTP (False: não respondeu)
    FSemAuth   : Boolean;   //conectou, mas o servidor não ofereceu autenticação (AUTH) nesta conexão
    FMotivo    : string;    //resposta do servidor (ou do socket) quando não conectou
    FAbortado  : Boolean;   //a tela desistiu do teste (limite de 15 s ou fim do app)
  protected
    procedure Execute; override;
  public
    //Criada suspensa: quem cria liga o OnTerminate e chama Start
    constructor Create(const Servidor, Porta, Usuario, Senha: string; const SSL, TLS: Boolean);
    destructor Destroy; override;
    //Thread principal: fecha o socket em uso para a conexão, a leitura ou o SSL pararem na hora
    procedure Abortar;
    property Servidor: string read FServidor;
    property Porta: string read FPorta;
    property Conectou: Boolean read FConectou;
    property Respondeu: Boolean read FRespondeu;
    property SemAutenticacao: Boolean read FSemAuth;
    property Motivo: string read FMotivo;
    property Abortado: Boolean read FAbortado;
  end;

function CaixaMensagem(const Texto: string; const Tipo: TMsgDlgType;
  const Botoes: TMsgDlgButtons = [mbOK]; const Padrao: TMsgDlgBtn = mbOK): Integer;
var
    Opcoes: Cardinal;
begin
    //Caixa de mensagem única do app (glossário 15.1 a 15.3). O MessageDlg do Delphi 10.2 usa os textos
    //da VCL (título "Information"/"Error"/"Warning"/"Confirm" e botões "Yes"/"No" em inglês, de
    //Vcl.Consts); o MessageBox do Windows usa o título informado ("ProXML") e os botões no idioma do
    //Windows (Sim / Não). O ícone continua o do Windows para cada tipo
    case Tipo of
        mtWarning      : Opcoes := MB_ICONWARNING;
        mtError        : Opcoes := MB_ICONERROR;
        mtConfirmation : Opcoes := MB_ICONQUESTION;
    else
        Opcoes := MB_ICONINFORMATION;
    end;

    //Sim / Não só na pergunta 5.28; nas outras caixas, OK
    if (mbYes in Botoes) and (mbNo in Botoes) then
    begin
        Opcoes := Opcoes or MB_YESNO;
        if Padrao = mbNo then
            Opcoes := Opcoes or MB_DEFBUTTON2;
    end
    else
        Opcoes := Opcoes or MB_OK;

    case Application.MessageBox(PChar(Texto), PChar(TITULO_CAIXAS), Opcoes) of
        IDYES : Result := mrYes;
        IDNO  : Result := mrNo;
    else
        Result := mrOk;
    end;
end;

function EmailValido(const Texto: string): Boolean;
var
    Arroba  : Integer;
    Usuario : string;
    Dominio : string;
    I       : Integer;
begin
    //Validação simples de um único endereço (glossário 11.18 e 12.24): usuario@dominio.ext, sem espaços,
    //sem segundo destinatário (vírgula ou ponto e vírgula) e com um ponto no domínio
    Result := False;
    if (Texto = '') or (Pos('@', Texto) = 0) then
        Exit;
    for I := 1 to Length(Texto) do
        if CharInSet(Texto[I], [' ', #9, ',', ';', '<', '>', '"', '(', ')', '[', ']', '\', ':']) then
            Exit;

    Arroba  := Pos('@', Texto);
    Usuario := Copy(Texto, 1, Arroba - 1);
    Dominio := Copy(Texto, Arroba + 1, MaxInt);
    if (Usuario = '') or (Dominio = '') or (Pos('@', Dominio) > 0) then
        Exit;
    if (Pos('.', Dominio) = 0) or (Dominio[1] = '.') or (Dominio[Length(Dominio)] = '.') or
       (Pos('..', Dominio) > 0) or (Usuario[1] = '.') or (Usuario[Length(Usuario)] = '.') then
        Exit;

    Result := True;
end;

function TamanhoArquivo(const Caminho: string): Int64;
var
    Dados: TWin32FileAttributeData;
begin
    //Tamanho do arquivo em bytes, sem abrir o arquivo; 0 se ele não existe mais
    Result := 0;
    if GetFileAttributesEx(PChar(Caminho), GetFileExInfoStandard, @Dados) and
       ((Dados.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0) then
        Result := (Int64(Dados.nFileSizeHigh) shl 32) or Dados.nFileSizeLow;
end;

function FormatarTamanho(const Bytes: Int64): string;
begin
    //Glossário 11.4: KB ou MB com vírgula e uma casa ("845,3 KB", "3,4 MB"), base 1024
    if Bytes < 1024 * 1024 then
        Result := FormatFloat('0.0', Bytes / 1024, FormatoPtBR) + ' KB'
    else
        Result := FormatFloat('0.0', Bytes / (1024 * 1024), FormatoPtBR) + ' MB';
end;

function MotivoNumaLinha(const Texto: string): string;
begin
    //Motivo técnico (servidor, ACBr, Synapse) numa linha só, sem espaços repetidos e sem o ponto final
    //(a frase do glossário põe a pontuação)
    Result := StringReplace(Texto, #13#10, ' ', [rfReplaceAll]);
    Result := StringReplace(Result, #13, ' ', [rfReplaceAll]);
    Result := StringReplace(Result, #10, ' ', [rfReplaceAll]);
    while Pos('  ', Result) > 0 do
        Result := StringReplace(Result, '  ', ' ', [rfReplaceAll]);
    Result := Trim(Result);
    while (Result <> '') and (Result[Length(Result)] = '.') do
        Delete(Result, Length(Result), 1);
end;

procedure AdicionarTrecho(var Trechos: TTrechosTexto; const Texto: string; const Estilo: TEstiloTrecho;
  const NovaLinha: Boolean = False);
begin
    //Acrescenta um trecho ao texto de uma faixa de status
    SetLength(Trechos, Length(Trechos) + 1);
    Trechos[High(Trechos)].Texto     := Texto;
    Trechos[High(Trechos)].Estilo    := Estilo;
    Trechos[High(Trechos)].NovaLinha := NovaLinha;
end;

function PosicaoCodigoSMTP(const Linha: string): Integer;
var
    P: Integer;
begin
    //Posição do código de resposta SMTP (3 dígitos de 200 a 599, sozinho, seguido de espaço, "-" ou fim
    //da linha) ou 0. "10061 - Connection refused" (erro de socket) não conta
    Result := 0;
    for P := 1 to Length(Linha) - 2 do
        if CharInSet(Linha[P], ['2'..'5']) and CharInSet(Linha[P + 1], ['0'..'9']) and
           CharInSet(Linha[P + 2], ['0'..'9']) and ((P = 1) or (Linha[P - 1] = ' ')) and
           ((P + 3 > Length(Linha)) or CharInSet(Linha[P + 3], [' ', '-'])) then
            Exit(P);
end;

function RespostaDoServidor(const Texto: string): string;
var
    Linhas : TStringList;
    I, P   : Integer;
    Linha  : string;
begin
    //Glossário 11.17 (revisão da 4.9): só a resposta do servidor, a partir do código de 3 dígitos (ex.:
    //"530 5.7.0 ..."), sem o prefixo do ACBr ("SMTP Error: Unable to send MailFrom."). Vale a última linha
    //com código; sem código (ex.: falha de conexão), a mensagem original. O LOG guarda o texto completo
    Result := Texto;
    Linhas := TStringList.Create;
    try
        Linhas.Text := Texto;
        for I := Linhas.Count - 1 downto 0 do
        begin
            Linha := Trim(Linhas[I]);
            P := PosicaoCodigoSMTP(Linha);
            if P > 0 then
                Exit(Copy(Linha, P, MaxInt));
        end;
    finally
        Linhas.Free;
    end;
end;

{ TCampoFormulario }

function TCampoFormulario.Valido: Boolean;
begin
    Result := (not Assigned(Validar)) or (Validar(Edit.Text) = '');
end;

{ TThreadTesteSMTP }

constructor TThreadTesteSMTP.Create(const Servidor, Porta, Usuario, Senha: string; const SSL, TLS: Boolean);
begin
    inherited Create(True);
    FreeOnTerminate := False;
    FServidor := Servidor;
    FPorta    := Porta;
    //Mesma configuração do ACBrMail (LerConfigEmail): SSL = conexão segura desde o início (FullSSL),
    //TLS = STARTTLS quando o servidor oferece (AutoTLS)
    FSMTP := TSMTPSend.Create;
    FSMTP.TargetHost := Servidor;
    FSMTP.TargetPort := Porta;
    FSMTP.UserName   := Usuario;
    FSMTP.Password   := Senha;
    FSMTP.FullSSL    := SSL;
    FSMTP.AutoTLS    := TLS;
    FSMTP.Sock.SSL.SSLType := LT_all;
    //15 s para cada resposta do servidor. A conexão fica bloqueante (sem ConnectionTimeout): no Windows o
    //connect com prazo do Synapse não percebe a recusa (porta fechada) e esperaria os 15 s inteiros. O
    //limite total continua garantido pelo cronômetro da tela, que fecha o socket (Abortar)
    FSMTP.Timeout := TEMPO_LIMITE_TESTE_MS;
end;

destructor TThreadTesteSMTP.Destroy;
begin
    inherited;
    FSMTP.Free;
end;

procedure TThreadTesteSMTP.Abortar;
var
    Socket: TSocket;
begin
    //Só fecha o socket do sistema (a thread recebe erro na operação em andamento e termina); o objeto do
    //Synapse continua sendo da thread
    FAbortado := True;
    Socket := FSMTP.Sock.Socket;
    if Socket <> INVALID_SOCKET then
        synsock.CloseSocket(Socket);
end;

procedure TThreadTesteSMTP.Execute;
begin
    NameThreadForDebugging('ProXML.TesteConexao');

    //Liberada sem ter sido iniciada (a VCL a inicia já terminada): não conecta
    if Terminated then
        Exit;

    try
        //Login: conecta, lê a saudação, EHLO, STARTTLS (TLS) e AUTH com o usuário e a senha. O Login do
        //Synapse devolve True mesmo se a autenticação falhar: o resultado da AUTH fica em AuthDone
        if FSMTP.Login then
        begin
            if FSMTP.AuthDone or ((FSMTP.UserName = '') and (FSMTP.Password = '')) then
            begin
                FConectou := True;
                FSMTP.Logout;
                Exit;
            end;

            //Conectou, mas o servidor não ofereceu AUTH (ex.: Gmail sem TLS na porta 587): glossário 12.22a
            if (FSMTP.FindCap('AUTH ') = '') and (FSMTP.FindCap('AUTH=') = '') then
            begin
                FRespondeu := True;
                FSemAuth   := True;
                FSMTP.Logout;
                Exit;
            end;
        end;

        //Sem nenhuma resposta SMTP (endereço errado, porta fechada, sem internet, tempo esgotado ou SSL
        //recusado): "não respondeu" (12.22). Com resposta: o texto do servidor vira o motivo
        FRespondeu := FSMTP.ResultCode <> 0;
        FMotivo    := Trim(FSMTP.ResultString);
        if FMotivo = '' then
            FMotivo := Trim(FSMTP.Sock.LastErrorDesc);
        if FRespondeu then
            FSMTP.Logout;
    except
        on E: Exception do
        begin
            FConectou  := False;
            FRespondeu := False;
            FMotivo    := E.Message;
        end;
    end;
end;

function ExecutarOculto(const Comando: string): Boolean;
var
  SUInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
begin
  //Executa o comando sem janela e espera terminar (WinRAR). Não acessa a tela
  FillChar(SUInfo, SizeOf(SUInfo), #0);
  SUInfo.cb      := SizeOf(SUInfo);
  SUInfo.dwFlags := STARTF_USESHOWWINDOW;
  SUInfo.wShowWindow := SW_HIDE;

  Result := CreateProcess(nil,
                          PChar(Comando),
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

{ TThreadEnvioEmail }

constructor TThreadEnvioEmail.Create(ACBrNFe: TACBrNFe; const PastaApp, Para, Assunto: string; Mensagem: TStrings);
begin
    inherited Create(True);
    FreeOnTerminate := False;
    FACBrNFe  := ACBrNFe;
    FPastaApp := PastaApp;
    FPara     := Para;
    FAssunto  := Assunto;
    FMensagem := TStringList.Create;
    FMensagem.Assign(Mensagem);
    FOrigens  := TStringList.Create;
    FNomes    := TStringList.Create;
    FResultado := reErro;
end;

destructor TThreadEnvioEmail.Destroy;
begin
    inherited;
    FNomes.Free;
    FOrigens.Free;
    FMensagem.Free;
end;

procedure TThreadEnvioEmail.AdicionarXML(const Origem, Nome: string);
begin
    FOrigens.Add(Origem);
    FNomes.Add(Nome);
end;

procedure TThreadEnvioEmail.Compactar;
var
    Pasta : string;
    Anexo : string;
    I     : Integer;
begin
    //Mesma compactação de antes da 4.6 (pasta NFCe\ProXML e WinRAR), agora fora da thread principal
    Pasta := FPastaApp + 'NFCe\ProXML';
    if TDirectory.Exists(Pasta) then
        TDirectory.Delete(Pasta, True);   //apaga a pasta e todo o seu conteúdo

    if not SysUtils.DirectoryExists(Pasta) then
        SysUtils.ForceDirectories(FPastaApp + '\NFCe\ProXML');

    for I := 0 to FOrigens.Count - 1 do
        CopyFile(PChar(FOrigens[I]), PChar(Pasta + '\' + FNomes[I]), False);

    Anexo := FPastaApp + 'NFCe\NFCe_ProXML.rar';
    if FileExists(Anexo) then
        SysUtils.DeleteFile(Anexo);

    ExecutarOculto('cmd.exe /c' + FPastaApp + 'WinRAR.exe a -ep ' + Anexo + ' ' +
                   FPastaApp + 'NFCe\ProXML\*-nfe.xml');
end;

procedure TThreadEnvioEmail.Execute;
var
    Anexos       : TStringList;
    Anexo        : string;
    ResultadoCOM : HResult;
begin
    NameThreadForDebugging('ProXML.EnvioEmail');

    //Liberada sem ter sido iniciada (a VCL a inicia já terminada): não compacta nem envia
    if Terminated then
        Exit;

    ResultadoCOM := CoInitialize(nil);
    try
        try
            //WinRAR fora da pasta do ProXML: não compacta nem envia (glossário 11.20)
            if not FileExists(FPastaApp + 'WinRAR.exe') then
            begin
                FResultado := reSemWinRAR;
                Exit;
            end;

            Compactar;

            //WinRAR com falha (o .rar não foi gerado): não envia
            Anexo := FPastaApp + 'NFCe\NFCe_ProXML.rar';
            if not FileExists(Anexo) then
            begin
                FResultado := reSemAnexo;
                Exit;
            end;

            Anexos := TStringList.Create;
            try
                Anexos.Add(Anexo);
                FACBrNFe.EnviarEmail(FPara, FAssunto, FMensagem, nil, Anexos, nil, '', nil);
            finally
                Anexos.Free;
            end;
            FResultado := reEnviado;
        except
            on E: Exception do
            begin
                FResultado  := reErro;
                FErro       := E.Message;
                FClasseErro := E.ClassName;
            end;
        end;
    finally
        if Succeeded(ResultadoCOM) then
            CoUninitialize;
    end;
end;

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
    //Enviar e-mail com os XMLs compactados. Etapa 4.6: a compactação e o envio rodam numa thread
    //(TThreadEnvioEmail) e a tela continua respondendo, com o botão em "Enviando…".
    //Os XMLs são separados e compactados agora, com o filtro de modelo atual (a busca da tela
    //Notas não vale para o Enviar: decisão D5)
    //Etapa 4.7: sem notas, sem e-mail de envio configurado ou com o "Para" inválido o botão fica
    //desabilitado e a tela mostra o motivo (11.5/11.6, 11.19 e 11.18): aqui só a conferência de segurança
    if FEnviando or Bloqueado or (not TemNotaNoModelo) or (not SMTPConfigurado) then
        Exit;

    if not FCampoPara.Valido then
    begin
        FCampoPara.Validando := True;
        ValidarCampo(FCampoPara);
        if EditEmailEnviar.CanFocus then
            EditEmailEnviar.SetFocus;
        Exit;
    end;

    IniciarEnvio;
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

    //Tela Enviar aberta (etapa 4.7): o anexo acompanha o filtro de modelo e as notas carregadas
    if (PageControl1.ActivePage = Enviar) and (not FEnviando) then
    begin
        AtualizarAnexoEnviar;
        AtualizarTelaEnviar;
    end;
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
var
    Config: TConfig;
begin
    //Salvar (glossário 12.15 a 12.17). Habilitado só com servidor, porta (1 a 65535) e e-mail válidos;
    //senha e mensagem podem ficar vazias. Salvar não troca de tela (N5): a confirmação "Configurações
    //salvas" aparece 3 s ao lado do botão. Erro: caixa 12.17 e LOG (fim do except vazio, E1)
    if FTestando or (not FCampoServidor.Valido) or (not FCampoPorta.Valido) or (not FCampoEmail.Valido) then
        Exit;

    Config := TConfig.Create;
    try
        Config.SMTP     := Trim(EditSMTP.Text);
        Config.Porta    := Trim(EditPorta.Text);
        Config.Email    := Trim(EditEmail.Text);
        Config.Senha    := EditPass.Text;
        Config.Mensagem := MemoMsg.Text;
        Config.SSL      := CheckBoxSSL.Checked;
        Config.TSL      := CheckBoxTSL.Checked;   //rótulo "TLS" na tela; o nome interno TSL não muda
        try
            DMConfig.UpdateConfig(Config);
        except
            on E: Exception do
            begin
                GravarLog(E.ClassName, 'Salvar configurações: ' + E.Message);
                CaixaMensagem('Não foi possível salvar as configurações.' + sLineBreak + sLineBreak +
                              'Motivo: ' + E.Message, mtError);
                Exit;
            end;
        end;

        //Salvo: a configuração em memória acompanha o banco (a tela Enviar usa o e-mail de envio)
        ConfigEmail.SMTP     := Config.SMTP;
        ConfigEmail.Porta    := Config.Porta;
        ConfigEmail.Email    := Config.Email;
        ConfigEmail.Senha    := Config.Senha;
        ConfigEmail.Mensagem := Config.Mensagem;
        ConfigEmail.SSL      := Config.SSL;
        ConfigEmail.TSL      := Config.TSL;
    finally
        Config.Free;
    end;

    //"Configurações salvas" (tokens.md 5.11): check 14 px + 9 pt Semibold CorSucesso, por 3 s
    TimerConfigSalva.Enabled := False;
    SkSvgConfigSalva.Visible := True;
    LabelConfigSalva.Visible := True;
    AjustarRolagem(FRolagemConfig);
    TimerConfigSalva.Enabled := True;
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
        //Totais da memória (cards), com o filtro de modelo; o modelo vem de DMConfig.FiltroModelo
        FormRelatorio.SetTotais(FTotais);
        FormRelatorio.SetPasta(FPastaNotas);
        FormRelatorio.SetVersao(VersaoDoExecutavel);
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
        //Totais da memória (cards), com o filtro de modelo; o modelo vem de DMConfig.FiltroModelo
        FormIBSCBS.SetTotais(FTotais);
        FormIBSCBS.SetPasta(FPastaNotas);
        FormIBSCBS.SetVersao(VersaoDoExecutavel);

        if not FormIBSCBS.GerarRelatorio then
        begin
            //Nenhuma nota do filtro atual tem IBS/CBS: não abre a visualização (glossário 8.10).
            //Com o botão desabilitado nesse caso, a caixa só aparece se o relatório for pedido mesmo assim
            EncerrarCarregando(tlRelatorios);
            CaixaMensagem('Nenhuma nota do modelo selecionado tem IBS/CBS.', mtInformation);
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
       CaixaMensagem('Nenhuma nota para o relatório. Processe uma pasta primeiro.', mtInformation);
       Exit;
    end;

    if (Relatorio = trIBSCBS) and (FTotais.QuantidadeIBSCBS = 0) then
    begin
       //Sem nota com IBS/CBS no filtro: não grava nada no banco
       CaixaMensagem('Nenhuma nota do modelo selecionado tem IBS/CBS.', mtInformation);
       Exit;
    end;

    GravarNotasDB(Relatorio);
end;

procedure TFormPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //Guarda a pasta e a janela para a próxima execução
  SalvarPreferencias;

  Action := caFree;
  Application.Terminate;
end;

procedure TFormPrincipal.FormCreate(Sender: TObject);
begin
   //Create do Form
   //Application.OnException := DMConfig.GravaLog;

   //Tema (fonte base), botões e atalhos criados em runtime e rolagem de reserva nas telas
   //Enviar e Configurações (só aparece se o conteúdo não couber, ex.: 150% na janela mínima)
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
   //Etapa 4.6: Resumo (estado vazio, leitura em andamento, contadores, avisos e log)
   PrepararResumo;
   //Etapa 4.7: telas Enviar, Configurações e Sobre
   PrepararTelaEnviar;
   PrepararTelaConfig;
   PrepararTelaSobre;
   FRolagemEnviar := CriarRolagem(Panel10);
   FRolagemConfig := CriarRolagem(PanelCorpoConfig);

   //Configurações de e-mail do banco. Erro: LOG e a caixa 12.18 depois que a janela abre (fim do except
   //vazio, E1); a tela continua com os campos vazios
   try
    ConfigEmail := DMConfig.GetConfig;
   except
    on E: Exception do
    begin
        ConfigEmail := TConfig.Create;
        FErroLeituraConfig := E.Message;
        GravarLog(E.ClassName, 'Ler configurações de e-mail: ' + E.Message);
    end;
   end;
   CarregarConfigNaTela;

   //Seletor de modelo começa em "Todos"
   SeletorModelo.ItemIndex := 0;
   AplicarFiltroModelo;

   //Última pasta e janela da execução anterior
   RestaurarPreferencias;

   //Sem pasta, Processar começa desabilitado
   AtualizarEstadoProcessar;
end;

procedure TFormPrincipal.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  //Threads que ainda existam. Normalmente já terminaram: o FormCloseQuery espera a leitura e não deixa
  //fechar durante o envio. O fim delas não mexe mais na tela.
  //Testar conexão em andamento (etapa 4.7): o app fecha sem perguntar; o teste é abortado (o socket é
  //fechado) e a thread é esperada aqui, para não ficar processo pendurado
  FFechando := True;
  TimerTesteConexao.Enabled := False;
  TimerConfigSalva.Enabled  := False;
  if FLeitura <> nil then
    FLeitura.OnTerminate := nil;
  if FEnvio <> nil then
    FEnvio.OnTerminate := nil;
  LiberarThreadLeitura;
  LiberarThreadEnvio;
  LiberarThreadsTeste(True);
  FreeAndNil(FTestesEncerrados);
  LiberarIconesLog;
  for I := 0 to High(FCampos) do
    FCampos[I].Free;
  FCampos := nil;
  FreeAndNil(ConfigEmail);
  //Devolve o WindowProc original do PageControl1 (trocado em PrepararTelaRelatorios)
  if Assigned(FJanelaPaginas) then
    PageControl1.WindowProc := FJanelaPaginas;
  //... e o do campo da pasta (trocado na preparação da barra de pasta)
  if Assigned(FJanelaCampoPasta) then
    EditCaminho.WindowProc := FJanelaCampoPasta;
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
   if (DataSource1.DataSet <> nil) and DataSource1.DataSet.Active then
    DataSource1.DataSet.First;

   //Abre no Resumo, com o item do menu sincronizado
   MostrarTela(tlResumo);

   //Etapa 4.9 (A1): o foco inicial fica em "Selecionar…" (primeiro passo do fluxo pelo teclado: Enter
   //abre o seletor; depois F5 processa). Com o foco no campo da pasta o Windows esconde o TextHint 2.2
   if (btnSelecionar <> nil) and btnSelecionar.CanFocus then
       ActiveControl := btnSelecionar;

   //Pastas e caminhos do ACBr (DANFE). Falha aqui não impede o app de abrir: vai para o LOG e o erro
   //aparece ao gerar o DANFE
   try
    ConfigACBR();
   except
    on E: Exception do
      GravarLog(E.ClassName, 'Configurar o ACBr: ' + E.Message);
   end;

   //12.18: as configurações de e-mail não puderam ser lidas no FormCreate. A caixa aparece depois que a
   //janela estiver na tela
   if FErroLeituraConfig <> '' then
    PostMessage(Handle, WM_PROXML_ERRO_CONFIG, 0, 0);

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
        CaixaMensagem('Não foi possível copiar a chave: outro programa está usando a área de transferência. ' +
                      'Tente de novo em alguns segundos.', mtWarning);
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
                //Glossário 7.3
                Mensagem := 'Esta NF-e usa um layout de DANFE que o ProXML não gera (tpImp ' + TpImpToStr(TipoImp) +
                            ').' + sLineBreak + sLineBreak + 'O ProXML gera o DANFE da NF-e (55) só nos layouts ' +
                            'retrato (tpImp 1) e paisagem (tpImp 2).';
                Exit;
            end;

            ACBrNFeDANFEFR.FastFileEvento := PathReport + 'EVENTOS.fr3';
        end;
    else
        //Glossário 7.4
        Mensagem := 'O ProXML não gera DANFE para o modelo ' + IntToStr(Modelo) + '. Só NF-e (55) e NFC-e (65).';
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
                //Glossário 7.1 (o motivo pode ser o texto 7.2)
                CaixaMensagem('Não foi possível abrir o XML da nota.' + sLineBreak + sLineBreak + 'Arquivo: ' +
                              CaminhoArq + sLineBreak + 'Motivo: ' + E.Message, mtError);
                Exit;
            end;
        end;

        //Escolhe o layout pelo modelo e pelo tpImp da nota
        if not ConfigurarLayoutDanfe(Mensagem) then
        begin
            EncerrarCarregando(tlNotas);
            CaixaMensagem(Mensagem, mtWarning);
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
                //Glossário 7.5
                CaixaMensagem('Não foi possível gerar o DANFE.' + sLineBreak + sLineBreak + 'Motivo: ' + E.Message,
                              mtError);
                Exit;
            end;
        end;

        if not AguardarArquivoPDF(CaminhosPDF, CaminhoGerado) then
        begin
            if Application.Terminated then
                Exit;

            //Glossário 7.7 (LOG) e 7.6 (caixa)
            GravarLog('GerarDanfe', 'PDF do DANFE não ficou pronto em ' + IntToStr(TEMPO_LIMITE_PDF_MS div 1000) +
                                    ' s: ' + CaminhoArq);
            EncerrarCarregando(tlNotas);
            CaixaMensagem('O PDF do DANFE não ficou pronto em ' + IntToStr(TEMPO_LIMITE_PDF_MS div 1000) +
                          ' segundos.' + sLineBreak + sLineBreak + 'Confira a pasta: ' + ACBrNFe.DANFE.PathPDF,
                          mtError);
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
          CaixaMensagem('Não foi possível gravar as notas no banco de dados. O relatório não foi gerado.' +
                        sLineBreak + sLineBreak + 'Motivo: ' + E.Message, mtError);
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
        CaixaMensagem('Não foi possível gerar o relatório.' + sLineBreak + sLineBreak + 'Motivo: ' + E.Message,
                      mtError);
        DMConfig.CreateLog(E.ClassName, E.Message);
      end;
    end;
  finally
    EncerrarCarregando(tlRelatorios);
  end;
end;

procedure TFormPrincipal.LerConfigEmail;
var
    Nova: TConfig;
begin
    //Configurações do e-mail salvas no banco (as da tela Configurações só valem depois de Salvar).
    //Erro sobe como exceção (quem chama mostra a caixa 12.18)
    Nova := DMConfig.GetConfig;
    ConfigEmail.Free;
    ConfigEmail := Nova;

    ACBrMail1.Host        := Trim(ConfigEmail.SMTP);
    ACBrMail1.Port        := Trim(ConfigEmail.Porta);
    ACBrMail1.Username    := Trim(ConfigEmail.Email);
    ACBrMail1.Password    := Trim(ConfigEmail.Senha);
    ACBrMail1.From        := Trim(ConfigEmail.Email);
    ACBrMail1.SetSSL      := ConfigEmail.SSL; // SSL - Conexao Segura
    ACBrMail1.SetTLS      := ConfigEmail.TSL; // Auto TLS
    ACBrMail1.ReadingConfirmation := False; // Pede confirmacao de leitura do email
    ACBrMail1.UseThread := False;           // O envio já roda numa thread própria (TThreadEnvioEmail, etapa 4.6)
    ACBrMail1.FromName  := 'ProXML';        // Nome do remetente visto pelo destinatário (glossário 11.22)

    MemoMensagem.Text := ConfigEmail.Mensagem;
end;

procedure TFormPrincipal.SelecionarPastaClick(Sender: TObject);
begin
  //Clique no campo da pasta (ou no ícone dele) e no botão Selecionar…
  SelecionarPasta;
end;

procedure TFormPrincipal.SelecionarPasta;
begin
  //Durante a leitura, o envio ou a tela Carregando a pasta não muda (tokens.md 5.13)
  if Bloqueado then
    Exit;

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
    //Olho da senha (tokens.md 5.3; glossário 12.12): eye mostra a senha, eye-off volta a ocultar.
    //O hint acompanha a ação do próximo clique
    if (not PnlCampoSenha.Enabled) or FTestando then
        Exit;

    if EditPass.PasswordChar <> #0 then
    begin
        EditPass.PasswordChar := #0;
        SkSvg5.Svg.Source := IconeOcultarSenha;
        SkSvg5.Hint       := 'Ocultar senha';
    end
    else
    begin
        EditPass.PasswordChar := #$2022;
        SkSvg5.Svg.Source := IconeMostrarSenha;
        SkSvg5.Hint       := 'Mostrar senha';
    end;
    Application.CancelHint;
end;

procedure TFormPrincipal.SpeedButton1Click(Sender: TObject);
begin
  //Processar (etapa 4.6): a leitura roda numa thread (IniciarLeitura). O Resumo mostra o progresso
  //com Cancelar e, no fim, o resultado; o Processar volta habilitado em qualquer caminho (LeituraTerminada)
  if FLendo or Bloqueado then
    Exit;

  //P3: "há pasta?" só olha se o campo está preenchido (a instrução fica no TextHint)
  if not TemPasta then
  begin
    //Só por segurança: sem pasta o botão fica desabilitado (glossário 2.13)
    CaixaMensagem('Selecione uma pasta com XMLs.', mtInformation);
    Exit;
  end;

  IniciarLeitura(Trim(EditCaminho.Text));
end;

{ Plano 4, etapa 4.2: botões TProBotao, atalhos de teclado, rolagem e preferências da janela }

procedure TFormPrincipal.CriarBotoes;
begin
    //Os painéis Panel7, Panel11 e Panel9 do .dfm são só o ponto de encaixe.
    //Ícones e dicas do Enviar e do Salvar (glossário 11.11, 11.12 e 12.15) ficam em PrepararTelaEnviar e
    //PrepararTelaConfig (etapa 4.7)
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
    actSelecionarPasta := NovaAcao(Vcl.Menus.ShortCut(Ord('O'), [ssCtrl]), AcaoSelecionarPastaExecute, AcaoSelecionarPastaUpdate);
    actProcessar       := NovaAcao(Vcl.Menus.ShortCut(VK_F5, []), AcaoProcessarExecute, AcaoProcessarUpdate);
    actBuscar          := NovaAcao(Vcl.Menus.ShortCut(Ord('F'), [ssCtrl]), AcaoBuscarExecute, AcaoBuscarUpdate);
    actCopiarChave     := NovaAcao(Vcl.Menus.ShortCut(Ord('C'), [ssCtrl]), AcaoCopiarChaveExecute, AcaoCopiarChaveUpdate);
    actGerarDanfe      := NovaAcao(Vcl.Menus.ShortCut(Ord('D'), [ssCtrl]), AcaoGerarDanfeExecute, AcaoGerarDanfeUpdate);
    //Etapa 4.6: Esc cancela a leitura dos XMLs (só fica ativo durante a leitura)
    actCancelarLeitura := NovaAcao(Vcl.Menus.ShortCut(VK_ESCAPE, []), AcaoCancelarLeituraExecute, AcaoCancelarLeituraUpdate);
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
    actCopiarChave.Enabled := (ActiveControl = DBGrid1) and NotaSelecionada and (not Bloqueado);
end;

procedure TFormPrincipal.AcaoGerarDanfeExecute(Sender: TObject);
begin
    //Ctrl+D: mesmo que "Gerar DANFE" do botão e do menu da grade
    GerarDanfeSelecionada;
end;

procedure TFormPrincipal.AcaoGerarDanfeUpdate(Sender: TObject);
begin
    //Só na tela Notas, com uma nota escolhida e sem outro DANFE em andamento
    actGerarDanfe.Enabled := (TelaAtual = tlNotas) and NotaSelecionada and (not FGerandoDanfe) and (not Bloqueado);
end;

function TFormPrincipal.CriarRolagem(Painel: TPanel): TScrollBox;
begin
    //Rolagem de reserva das telas Enviar e Configurações (etapa 4.7): o layout cabe em 1024x640 a 100%
    //sem barra; a caixa de rolagem só mostra barras se o conteúdo não couber (ex.: 150% na janela
    //mínima). O quadro da tela fica dentro da caixa, com a largura da caixa (no mínimo
    //LarguraMinimaFormulario) e a altura que o layout pedir (AjustarRolagem)
    Result := TScrollBox.Create(Self);
    Result.Parent           := Painel.Parent;
    Result.Align            := alClient;
    Result.BorderStyle      := bsNone;
    Result.ParentBackground := True;
    Result.HorzScrollBar.Tracking := True;
    Result.VertScrollBar.Tracking := True;

    Painel.Align  := alNone;
    Painel.Parent := Result;
    Painel.SetBounds(0, 0, Painel.Width, Painel.Height);
    Result.OnResize := RolagemResize;
end;

procedure TFormPrincipal.RolagemResize(Sender: TObject);
begin
    AjustarRolagem(Sender as TScrollBox);
end;

procedure TFormPrincipal.AjustarRolagem(Caixa: TScrollBox);
var
    Painel : TControl;
    Largura: Integer;
    Altura : Integer;
    Passo  : Integer;
begin
    //O quadro ocupa a caixa inteira; o layout da tela devolve a altura de que precisa. Se ela for maior
    //que a caixa, aparece a barra vertical, a largura útil diminui e o layout é refeito (segundo passo)
    if (Caixa = nil) or (Caixa.ControlCount = 0) or FAjustandoRolagem then
        Exit;

    FAjustandoRolagem := True;
    try
        Painel := Caixa.Controls[0];
        for Passo := 1 to 2 do
        begin
            Largura := Max(Caixa.ClientWidth, Escalar(LarguraMinimaFormulario));
            Painel.SetBounds(Painel.Left, Painel.Top, Largura, Max(Painel.Height, Caixa.ClientHeight));
            if Painel = Panel10 then
                Altura := AjustarLayoutEnviar
            else
                Altura := AjustarLayoutConfig;
            Painel.SetBounds(Painel.Left, Painel.Top, Largura, Max(Caixa.ClientHeight, Altura));
            if Max(Caixa.ClientWidth, Escalar(LarguraMinimaFormulario)) = Largura then
                Break;
        end;
    finally
        FAjustandoRolagem := False;
    end;
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
var
    I: Integer;
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
        //Etapa 4.6: Resumo (ícones do log refeitos no tamanho novo)
        LiberarIconesLog;
        ListBoxLog.ItemHeight := Escalar(AlturaLinhaLog);
        AjustarLayoutResumo;
        //Etapa 4.7: campos com borda própria, telas Enviar, Configurações e Sobre
        for I := 0 to High(FCampos) do
            AtualizarCampo(FCampos[I]);
        AjustarRolagem(FRolagemEnviar);
        AjustarRolagem(FRolagemConfig);
        AjustarLayoutSobre;
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
        //Durante a leitura, o envio ou a tela Carregando (a espera do PDF do DANFE processa mensagens)
        //a pasta não muda (tokens.md 5.13)
        if FGerandoDanfe or Bloqueado then
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
        btnProcessar.Enabled := TemPasta and (FBloqueios = []);

    //Etapa 4.6: bloqueado pela leitura, pelo envio ou pela tela Carregando, a dica de pasta não vale
    if FBloqueios = [] then
        Panel7.Hint := 'Selecione uma pasta primeiro.'
    else
        Panel7.Hint := '';
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
begin
    //Faixa de aviso (tokens.md 5.8), com o mesmo desenho das outras faixas (etapa 4.9, A3): barra de 4 px,
    //ícone triangle-alert 16 px depois dela e texto 12 px depois do ícone. Glossário 2.14 sem a linha em
    //branco, com "A pasta não foi encontrada:" em Semibold
    PrepararFaixa(PnlAvisoPasta, PnlAvisoPastaBarra, SkSvgAvisoPasta, CorAvisoSuave, CorAviso, IconeAviso);
    PbxAvisoPasta.OnPaint  := PbxAvisoPastaPaint;
    FPastaNaoEncontrada    := Pasta;
    PnlAvisoPasta.Hint     := Pasta;
    PnlAvisoPasta.ShowHint := True;
    PnlAvisoPasta.OnResize := PnlAvisoPastaResize;
    PnlAvisoPasta.Visible  := True;
    PnlAvisoPastaResize(PnlAvisoPasta);
end;

procedure TFormPrincipal.PnlAvisoPastaResize(Sender: TObject);
var
    Fonte: TFont;
begin
    //Caminho longo: cortado no meio com "…" na largura do texto da faixa, numa linha só; o caminho
    //completo fica na dica
    if (FPastaNaoEncontrada = '') or (not PnlAvisoPasta.Visible) then
        Exit;

    Fonte := TFont.Create;
    try
        FonteDoTrecho(Fonte, etrNormal);
        FTrechosAvisoPasta := nil;
        AdicionarTrecho(FTrechosAvisoPasta, 'A pasta não foi encontrada:', etrDestaque);
        AdicionarTrecho(FTrechosAvisoPasta, EncurtarNoMeio(Fonte, FPastaNaoEncontrada,
                        LarguraTextoFaixa(PnlAvisoPasta.ClientWidth)), etrNormal, True);
        AdicionarTrecho(FTrechosAvisoPasta, 'Selecione outra pasta.', etrNormal, True);
    finally
        Fonte.Free;
    end;
    AjustarFaixa(PnlAvisoPasta, PnlAvisoPastaBarra, SkSvgAvisoPasta, PbxAvisoPasta, FTrechosAvisoPasta,
                 PaddingFaixaVertical);
    PbxAvisoPasta.Invalidate;
end;

procedure TFormPrincipal.PbxAvisoPastaPaint(Sender: TObject);
begin
    DesenharTrechos(PbxAvisoPasta.Canvas, FTrechosAvisoPasta, PbxAvisoPasta.ClientRect, True);
end;

function TFormPrincipal.LarguraTextoFaixa(const LarguraFaixa: Integer): Integer;
begin
    //Largura do texto de uma faixa de status (a mesma conta do AjustarFaixa): barra, padding de 16 px,
    //ícone de 20 px, 12 px até o texto e 16 px antes da borda direita
    Result := Max(1, LarguraFaixa - Escalar(BarraFaixa) - 2 * Escalar(PaddingFaixaHorizontal) -
                     Escalar(TamanhoIconeMenu) - Escalar(EspacoIconeFaixa));
end;

procedure TFormPrincipal.JanelaCampoPasta(var Message: TMessage);
begin
    //Etapa 4.9 (A1): campo da pasta sem ReadOnly (para o Windows mostrar o TextHint 2.2), mas sem edição:
    //a pasta só muda pelo seletor, pelo arrastar e soltar ou pelo código. Continuam o Ctrl+A (selecionar)
    //e o Ctrl+C (copiar o caminho)
    case Message.Msg of
        WM_CHAR, WM_IME_CHAR:
            if (Message.WParam <> 1) and (Message.WParam <> 3) then
                Exit;
        WM_KEYDOWN:
            if (Message.WParam = VK_DELETE) or ((Message.WParam = VK_INSERT) and (GetKeyState(VK_SHIFT) < 0)) then
                Exit;
        WM_PASTE, WM_CUT, WM_CLEAR, WM_UNDO, EM_UNDO, EM_REPLACESEL, WM_CONTEXTMENU:
            Exit;
    end;
    FJanelaCampoPasta(Message);
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
    AtualizarBordaCampo(PnlCampoPasta, SkSvgPasta, EditCaminho, 0, ComFoco and PnlCampoPasta.Enabled);

    //Bloqueado (leitura, envio ou tela Carregando; tokens.md 5.3 e 5.13): borda de 1 px CorBorda, fundo
    //CorFundoDesabilitado, texto e ícone CorTextoDesabilitado
    if PnlCampoPasta.Enabled then
    begin
        PnlCampoPastaFundo.Color := CorSuperficie;
        EditCaminho.Color        := CorSuperficie;
        EditCaminho.Font.Color   := CorTexto;
        SkSvgPasta.Svg.OverrideColor := CorAlpha(CorTextoSecundario);
    end
    else
    begin
        PnlCampoPasta.Color      := CorBorda;
        PnlCampoPastaFundo.Color := CorFundoDesabilitado;
        EditCaminho.Color        := CorFundoDesabilitado;
        EditCaminho.Font.Color   := CorTextoDesabilitado;
        SkSvgPasta.Svg.OverrideColor := CorAlpha(CorTextoDesabilitado);
    end;
end;

procedure TFormPrincipal.AtualizarBordaCampo(Borda: TPanel; Icone: TSkSvg; Edit: TCustomEdit; const Margem: Integer;
  const ComFoco: Boolean; const ComErro: Boolean = False; Acao: TSkSvg = nil);
var
    Espessura  : Integer;
    Diferenca  : Integer;
    Interno    : Integer;
    AlturaTexto: Integer;
    Medida     : TBitmap;
    Direita    : Integer;
begin
    //Campo (tokens.md 5.3): borda de 1 px CorBordaCampo; com foco, 2 px CorPrimaria; com erro (etapa 4.7),
    //2 px CorErro, mesmo com foco. A borda é o painel de fora (cor + Padding); ao engrossar, o espaço
    //interno diminui o mesmo tanto para o ícone e o texto não mudarem de lugar. Margem: reservado (0).
    //Icone (à esquerda) e Acao (à direita, ex.: olho da senha) são opcionais; o TMemo fica alinhado ao
    //topo com o padding do campo (mockup .fld.area)
    if ComErro then
    begin
        Espessura := Escalar(BordaCampoFoco);
        Borda.Color := CorErro;
    end
    else if ComFoco then
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

    //Ícones de 16 px e texto centralizados na altura interna do campo
    Interno := Escalar(AlturaCampo) - 2 * Escalar(BordaCampo);
    Medida := TBitmap.Create;
    try
        Medida.Canvas.Font.Assign(TEditAcesso(Edit).Font);
        AlturaTexto := Medida.Canvas.TextHeight('Ag');
    finally
        Medida.Free;
    end;

    if Icone <> nil then
        Icone.Margins.SetBounds(Escalar(PaddingCampo) - Diferenca,
                                Max(0, (Interno - Escalar(TamanhoIconePequeno)) div 2 - Diferenca),
                                0,
                                Max(0, (Interno - Escalar(TamanhoIconePequeno)) div 2 - Diferenca));
    if Acao <> nil then
    begin
        Acao.Margins.SetBounds(0,
                               Max(0, (Interno - Escalar(TamanhoIconePequeno)) div 2 - Diferenca),
                               Escalar(PaddingCampo) - Diferenca,
                               Max(0, (Interno - Escalar(TamanhoIconePequeno)) div 2 - Diferenca));
        Direita := Escalar(Espaco1);
    end
    else
        Direita := Escalar(PaddingCampo) - Diferenca;

    if Edit is TCustomMemo then
        Edit.Margins.SetBounds(Escalar(PaddingCampo) - Diferenca, Escalar(PaddingCampo) - Diferenca,
                               Direita, Escalar(PaddingCampo) - Diferenca)
    else if Icone <> nil then
        Edit.Margins.SetBounds(Escalar(Espaco1),
                               Max(0, (Interno - AlturaTexto) div 2 - Diferenca),
                               Direita,
                               Max(0, Interno - AlturaTexto - (Interno - AlturaTexto) div 2 - Diferenca))
    else
        Edit.Margins.SetBounds(Escalar(PaddingCampo) - Diferenca,
                               Max(0, (Interno - AlturaTexto) div 2 - Diferenca),
                               Direita,
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

    //Etapa 4.7: o link abre a tela Sobre (clique no painel, no ícone ou no texto). Com a tela aberta, o
    //texto fica branco com a linha de 2 px CorPrimaria embaixo (mockup sobre.html, .hlink.on)
    PnlSobre.Cursor   := crHandPoint;
    SkSvgSobre.Cursor := crHandPoint;
    LabelSobre.Cursor := crHandPoint;
    PnlSobre.OnClick   := SobreClick;
    SkSvgSobre.OnClick := SobreClick;
    LabelSobre.OnClick := SobreClick;
    PnlSobreAtivo.Color   := CorPrimaria;
    PnlSobreAtivo.Visible := False;
    PnlSobre.Enabled := True;
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
    //Etapa 4.9 (A1): o Windows não mostra o TextHint de campo somente leitura. O campo deixa de ser
    //ReadOnly e a edição pelo teclado fica bloqueada no WindowProc (JanelaCampoPasta)
    EditCaminho.ReadOnly := False;
    FJanelaCampoPasta    := EditCaminho.WindowProc;
    EditCaminho.WindowProc := JanelaCampoPasta;
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
    PnlSobreAtivo.SetBounds(0, PnlSobre.ClientHeight - Escalar(MarcaSobreAtivo), PnlSobre.ClientWidth,
                            Escalar(MarcaSobreAtivo));
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

    //D2: cards visíveis em Resumo, Notas, Relatórios e Carregando; ocultos em Enviar, Configurações e
    //Sobre. O OnShow da aba dispara também quando a troca vem do código (ActivePageIndex)
    TabSheet1.OnShow  := PaginaShow;
    TabSheet2.OnShow  := PaginaShow;
    Relatorios.OnShow := PaginaShow;
    Loading.OnShow    := PaginaShow;
    Enviar.OnShow     := PaginaShow;
    Config.OnShow     := PaginaShow;
    TelaSobre.OnShow  := PaginaShow;
end;

procedure TFormPrincipal.PaginaShow(Sender: TObject);
var
    Tela: TTela;
begin
    //Sender é a aba que acabou de aparecer (o ActivePage ainda pode ser a anterior)
    Tela := TelaDaAba(Sender as TTabSheet);
    PnlCards.Visible := not (Tela in [tlEnviar, tlConfiguracoes, tlSobre]);
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
    //Clique, Enter ou Espaço num item do menu: só abre a tela. Enviar carrega a configuração do e-mail ao
    //abrir (MostrarTela); os XMLs só são separados e compactados no clique em "Enviar" da própria tela
    Tela := TTela((Sender as TComponent).Tag);
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
        tlSobre         : Result := TelaSobre;
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
    else if Aba = TelaSobre then
        Result := tlSobre
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

    //Etapa 4.7: saindo de Enviar, a faixa do último envio (sucesso ou erro) deixa de valer; saindo de
    //Configurações, a faixa do Testar conexão também
    if (PageControl1.ActivePage = Enviar) and (Aba <> Enviar) then
        OcultarResultadoEnvio;
    if (PageControl1.ActivePage = Config) and (Aba <> Config) then
        OcultarFaixaConfig;

    if PageControl1.ActivePage <> Aba then
        PageControl1.ActivePage := Aba;

    //Todas as telas ocupam o PageControl inteiro (sem a moldura): realinha as abas
    PageControl1.Realign;

    //D2: os cards somem em Enviar, Configurações e Sobre
    PnlCards.Visible := not (Tela in [tlEnviar, tlConfiguracoes, tlSobre]);
    AjustarEspacoCards(Tela);
    SincronizarMenu(Tela);
    AtualizarVisualSobre;

    if Tela = tlRelatorios then
        AtualizarTelaRelatorios;

    //Enviar: configuração de e-mail salva (remetente e 11.19), anexo do filtro de modelo e estado da tela
    if (Tela = tlEnviar) and (not FEnviando) then
    begin
        try
            LerConfigEmail;
        except
            on E: Exception do
            begin
                GravarLog(E.ClassName, 'Ler configurações de e-mail: ' + E.Message);
                CaixaMensagem('Não foi possível ler as configurações de e-mail.' + sLineBreak + sLineBreak +
                              'Motivo: ' + E.Message, mtError);
            end;
        end;
        AtualizarAnexoEnviar;
        AtualizarTelaEnviar;
    end;

    if Tela = tlConfiguracoes then
        AtualizarEstadoConfig;
end;

procedure TFormPrincipal.SincronizarMenu(const Tela: TTela);
var
    Item: TTelaMenu;
begin
    //Carregando não tem item no menu: o item da tela de origem continua destacado (mockup carregando.html)
    if Tela = tlCarregando then
        Exit;

    //Item ativo = tela exibida. Uma tela sem item (Sobre, etapa 4.7) deixa todos inativos
    for Item := Low(TTelaMenu) to High(TTelaMenu) do
        if ItensMenu[Item] <> nil then
            ItensMenu[Item].Ativo := (Ord(Item) = Ord(Tela));

    TProItemMenu.AjustarParadaTab(PnlMenuItens);
end;

procedure TFormPrincipal.HabilitarMenu(const Habilitar: Boolean);
var
    Item: TTelaMenu;
begin
    //Tokens 5.13: itens do menu desabilitados durante a leitura, o envio e a tela Carregando (AplicarBloqueio)
    for Item := Low(TTelaMenu) to High(TTelaMenu) do
        if ItensMenu[Item] <> nil then
            ItensMenu[Item].Enabled := Habilitar;
end;

function TFormPrincipal.TelaSemMoldura(const Tela: TTela): Boolean;
begin
    //Telas no visual novo, com os próprios quadros sobre CorFundo (mockups resumo.html, notas.html,
    //relatorios.html, carregando.html e, desde a etapa 4.7, enviar.html, configuracoes.html e sobre.html):
    //ocupam a área inteira do PageControl1, sem a moldura do controle
    Result := Tela in [tlResumo, tlNotas, tlRelatorios, tlCarregando, tlEnviar, tlConfiguracoes, tlSobre];
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
    btnGerarRelNotas.Enabled  := (Total > 0) and (not Bloqueado);
    btnGerarRelIBSCBS.Enabled := (Total > 0) and (ComIBSCBS > 0) and (not Bloqueado);
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
    //Abre a tela Carregando. Enquanto ela estiver aberta ficam bloqueados o menu, a barra de pasta
    //(campo, Selecionar…, modelo e Processar), os relatórios e os atalhos (H4, etapa 4.6; tokens.md 5.13).
    //Quem abre a tela chama EncerrarCarregando num finally: tudo volta em qualquer caminho
    FFocoAntesCarregando := ActiveControl;
    LabelCarregandoTitulo.Caption  := Titulo;
    LabelCarregandoLegenda.Caption := Legenda;
    FCarregando := True;
    DefinirBloqueio(blCarregando, True);
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
        DefinirBloqueio(blCarregando, False);
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
    btnGerarDanfe.Enabled  := Selecionada and (not FGerandoDanfe) and (not Bloqueado);
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
    GerarDANFe1.Enabled    := NotaSelecionada and (not FGerandoDanfe) and (not Bloqueado);
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
                CaixaMensagem('Não foi possível salvar o arquivo CSV.' + sLineBreak + sLineBreak + 'Motivo: ' +
                              E.Message, mtError);
                Exit;
            end;
        end;

        CaixaMensagem('Arquivo CSV salvo:' + sLineBreak + Dialogo.FileName, mtInformation);
    finally
        Dialogo.Free;
    end;
end;

{ Plano 4, etapa 4.6: leitura e envio em segundo plano, bloqueio da tela e Resumo }

function TFormPrincipal.Bloqueado: Boolean;
begin
    Result := FBloqueios <> [];
end;

procedure TFormPrincipal.DefinirBloqueio(const Motivo: TMotivoBloqueio; const Ativo: Boolean);
begin
    //Cada operação liga o próprio motivo ao começar e desliga num finally ao terminar: a tela só volta
    //quando nenhum motivo está ativo
    if Ativo then
        Include(FBloqueios, Motivo)
    else
        Exclude(FBloqueios, Motivo);
    AplicarBloqueio;
end;

procedure TFormPrincipal.AplicarBloqueio;
var
    Livre: Boolean;
begin
    //Tokens.md 5.13: menu, barra de pasta (campo, Selecionar…, modelo e Processar) e o "Sobre" do
    //cabeçalho. Os atalhos (Ctrl+O, F5, Ctrl+F, Ctrl+C e Ctrl+D) conferem o bloqueio no OnUpdate das
    //ações e o arrastar pasta, no WM_DROPFILES. Durante a leitura só o Cancelar continua ativo
    Livre := FBloqueios = [];
    HabilitarMenu(Livre);
    PnlCampoPasta.Enabled := Livre;
    AtualizarBordaCampoPasta(Livre and EditCaminho.Focused);
    if btnSelecionar <> nil then
        btnSelecionar.Enabled := Livre;
    if SeletorModelo <> nil then
        SeletorModelo.Enabled := Livre;
    //"Sobre" bloqueado em CorTextoDesabilitado (decisão da 4.6); livre, volta para CorMarinhoTexto (ou
    //branco com a linha CorPrimaria, se a tela Sobre estiver aberta)
    PnlSobre.Enabled := Livre;
    AtualizarVisualSobre;
    AtualizarEstadoProcessar;

    //Botões que abrem trabalho nas telas Relatórios e Notas (H4) e o estado das telas Enviar e
    //Configurações (etapa 4.7: Enviar, Testar conexão, Salvar e o link "alterar em Configurações")
    AtualizarTelaRelatorios;
    AtualizarTelaNotas;
    AtualizarTelaEnviar;
    AtualizarEstadoConfig;
end;

procedure TFormPrincipal.AcaoSelecionarPastaUpdate(Sender: TObject);
begin
    actSelecionarPasta.Enabled := not Bloqueado;
end;

procedure TFormPrincipal.AcaoBuscarUpdate(Sender: TObject);
begin
    //Ctrl+F troca de tela: bloqueado junto com o menu
    actBuscar.Enabled := not Bloqueado;
end;

procedure TFormPrincipal.AcaoCancelarLeituraExecute(Sender: TObject);
begin
    //Esc durante a leitura: mesmo que clicar em Cancelar (glossário 5.8 e 5.9)
    CancelarLeitura;
end;

procedure TFormPrincipal.AcaoCancelarLeituraUpdate(Sender: TObject);
begin
    actCancelarLeitura.Enabled := FLendo and (not FCancelamentoPedido);
end;

procedure TFormPrincipal.PrepararFaixa(Faixa, Barra: TPanel; Icone: TSkSvg; const CorDoFundo, CorDaBarra: TColor;
  const IconeSvg: string);
begin
    //Faixa de status (tokens.md 5.8): fundo suave, barra de 4 px e ícone de 20 px na cor do tipo
    Faixa.Color := CorDoFundo;
    Barra.Color := CorDaBarra;
    Barra.Width := Escalar(BarraFaixa);
    Icone.Svg.Source        := IconeSvg;
    Icone.Svg.OverrideColor := CorAlpha(CorDaBarra);
    Icone.Width := Escalar(TamanhoIconeMenu);
end;

procedure TFormPrincipal.PrepararContador(Borda, Topo, Fundo: TPanel; Icone: TSkSvg; Numero, Rotulo: TLabel;
  const CorStatus, CorNumero: TColor; const IconeSvg, TextoRotulo: string);
begin
    //Contador (tokens.md 5.9): borda de 1 px CorBorda com a borda superior de 4 px na cor do status,
    //fundo CorSuperficie, ícone de 24 px e número 16 pt Semibold na cor do status, rótulo 9 pt
    //CorTextoSecundario. As posições internas ficam em AjustarContadores
    Borda.Color := CorBorda;
    Borda.Padding.SetBounds(Escalar(BordaQuadro), 0, Escalar(BordaQuadro), Escalar(BordaQuadro));
    Topo.Color  := CorStatus;
    Topo.Height := Escalar(BordaSuperiorContador);
    Fundo.Color := CorSuperficie;
    Icone.Svg.Source        := IconeSvg;
    Icone.Svg.OverrideColor := CorAlpha(CorNumero);
    AplicarFonte(Numero.Font, FonteDestaque, TamanhoContador, CorNumero);
    AplicarFonte(Rotulo.Font, FonteTexto, TamanhoLegenda, CorTextoSecundario);
    Numero.Caption := '0';
    Rotulo.Caption := TextoRotulo;
end;

procedure TFormPrincipal.PrepararResumo;
begin
    //Resumo sem moldura, sobre CorFundo (mockup resumo.html): faixa de status, estado vazio, leitura
    //em andamento e resultado da leitura. Os blocos ficam 16 px um do outro
    PnlResumo.Color := CorFundo;

    //Faixa de status no topo (tokens.md 5.8): processamento cancelado (5.10 e 5.11) e nenhum XML (2.15)
    PrepararFaixa(PnlFaixaResumo, PnlFaixaResumoBarra, SkSvgFaixaResumo, CorAvisoSuave, CorAviso, IconeAviso);
    PnlFaixaResumo.AlignWithMargins := True;
    PnlFaixaResumo.Margins.SetBounds(0, 0, 0, Escalar(EspacoBlocos));
    PnlFaixaResumo.OnResize := PnlFaixaResumoResize;
    PbxFaixaResumo.OnPaint  := PbxFaixaResumoPaint;
    PnlFaixaResumo.Visible  := False;

    //Estado vazio (glossário 5.1 a 5.4): quadro com borda, ícone folder-input de 48 px, título 12 pt
    //Semibold, texto 10 pt, "Selecionar pasta…" e a legenda dos atalhos
    PnlResumoVazio.Color := CorBorda;
    PnlResumoVazio.Padding.SetBounds(Escalar(BordaQuadro), Escalar(BordaQuadro), Escalar(BordaQuadro), Escalar(BordaQuadro));
    PnlResumoVazioFundo.Color    := CorSuperficie;
    PnlResumoVazioFundo.OnResize := PnlResumoVazioFundoResize;
    SkSvgResumoVazio.Svg.Source        := IconePastaEntrada;
    SkSvgResumoVazio.Svg.OverrideColor := CorAlpha(CorTextoSecundario);
    AplicarFonte(LabelResumoVazioTitulo.Font, FonteDestaque, TamanhoSubtitulo, CorTexto);
    AplicarFonte(LabelResumoVazioTexto.Font, FonteTexto, TamanhoCorpo, CorTextoSecundario);
    AplicarFonte(LabelResumoVazioAtalhos.Font, FonteTexto, TamanhoLegenda, CorTextoSecundario);
    LabelResumoVazioTitulo.Caption  := 'Nenhuma pasta processada';
    LabelResumoVazioTexto.Caption   := 'Selecione uma pasta com XMLs de NF-e (55) ou NFC-e (65), ou arraste a ' +
                                       'pasta para esta janela, e clique em Processar.';
    LabelResumoVazioAtalhos.Caption := 'Atalhos: Ctrl+O seleciona a pasta ' + #$00B7 + ' F5 processa';
    PnlResumoVazioBotao.Color := CorSuperficie;
    btnResumoVazio := TProBotao.CriarEm(PnlResumoVazioBotao, 'Selecionar pasta' + #$2026, ebSecundario,
                                        ResumoSelecionarPastaClick);
    btnResumoVazio.IconeSvg := IconePastaAberta;

    //Leitura em andamento (glossário 5.5 a 5.9; tokens.md 5.10): título, barra própria (trilho CorBorda
    //de 8 px + preenchimento CorPrimaria), "{x} de {n} arquivos" com o nome do arquivo atual em legenda
    //(cortado no meio) e Cancelar com a legenda do Esc
    PnlProgresso.Color := CorBorda;
    PnlProgresso.Padding.SetBounds(Escalar(BordaQuadro), Escalar(BordaQuadro), Escalar(BordaQuadro), Escalar(BordaQuadro));
    PnlProgressoFundo.Color    := CorSuperficie;
    PnlProgressoFundo.OnResize := PnlProgressoFundoResize;
    AplicarFonte(LabelProgressoTitulo.Font, FonteDestaque, TamanhoSubtitulo, CorTexto);
    LabelProgressoTitulo.Caption := 'Lendo os XMLs' + #$2026;
    PnlProgressoTrilho.Color := CorBorda;
    PnlProgressoBarra.Color  := CorPrimaria;
    PnlProgressoBarra.Width  := 0;
    AplicarFonte(LabelProgressoContagem.Font, FonteTexto, TamanhoCorpo, CorTexto);
    AplicarFonte(LabelProgressoArquivo.Font, FonteTexto, TamanhoLegenda, CorTextoSecundario);
    AplicarFonte(LabelProgressoDica.Font, FonteTexto, TamanhoLegenda, CorTextoSecundario);
    LabelProgressoContagem.Caption := '';
    LabelProgressoArquivo.Caption  := '';
    LabelProgressoDica.Caption     := 'Esc também cancela. As notas só aparecem quando a leitura termina.';
    PnlCancelar.Color := CorSuperficie;
    btnCancelar := TProBotao.CriarEm(PnlCancelar, 'Cancelar', ebSecundario, CancelarLeituraClick);
    btnCancelar.IconeSvg := IconeLimpar;
    btnCancelar.Hint     := 'Parar a leitura (Esc)';
    btnCancelar.ShowHint := True;

    //Resultado (glossário 5.12 a 5.15; tokens.md 5.9): 4 contadores, faixa de aviso e log
    PnlConcluido.Color  := CorFundo;
    PnlContadores.Color := CorFundo;
    PnlContadores.AlignWithMargins := True;
    PnlContadores.Margins.SetBounds(0, 0, 0, Escalar(EspacoBlocos));
    PnlContadores.OnResize := PnlContadoresResize;
    PrepararContador(PnlContadorAutorizadas, PnlContadorAutorizadasTopo, PnlContadorAutorizadasFundo,
                     SkSvgContadorAutorizadas, LabelNumeroAutorizadas, LabelRotuloAutorizadas,
                     CorSucesso, CorSucesso, IconeSucesso, 'Autorizadas');
    PrepararContador(PnlContadorIgnoradas, PnlContadorIgnoradasTopo, PnlContadorIgnoradasFundo,
                     SkSvgContadorIgnoradas, LabelNumeroIgnoradas, LabelRotuloIgnoradas,
                     CorAviso, CorAviso, IconeAviso, 'Ignoradas');
    PrepararContador(PnlContadorComErro, PnlContadorComErroTopo, PnlContadorComErroFundo,
                     SkSvgContadorComErro, LabelNumeroComErro, LabelRotuloComErro,
                     CorErro, CorErro, IconeErro, 'Com erro');
    //O 4º contador é neutro (borda superior CorBorda): tempo total em 12 pt, como no mockup, e a
    //quantidade de arquivos lidos no rótulo (5.13)
    PrepararContador(PnlContadorTempo, PnlContadorTempoTopo, PnlContadorTempoFundo,
                     SkSvgContadorTempo, LabelNumeroTempo, LabelRotuloTempo,
                     CorBorda, CorTexto, IconeTempo, '');
    AplicarFonte(LabelNumeroTempo.Font, FonteDestaque, TamanhoSubtitulo, CorTexto);

    //Faixa de aviso de homologação e entrada (glossário 5.29 a 5.31), com padding vertical de 8 px (mockup)
    PrepararFaixa(PnlAvisoResumo, PnlAvisoResumoBarra, SkSvgAvisoResumo, CorAvisoSuave, CorAviso, IconeAviso);
    PnlAvisoResumo.AlignWithMargins := True;
    PnlAvisoResumo.Margins.SetBounds(0, 0, 0, Escalar(EspacoBlocos));
    PnlAvisoResumo.OnResize := PnlAvisoResumoResize;
    PbxAvisoResumo.OnPaint  := PbxAvisoResumoPaint;
    PnlAvisoResumo.Visible  := False;

    //Log "Detalhes da leitura" (5.14 e 5.15): quadro com borda, linha de título com divisória e a lista
    //owner-draw com um ícone colorido por tipo de linha (decisão da 4.6), linhas de 24 px
    PnlLog.Color := CorBorda;
    PnlLog.Padding.SetBounds(Escalar(BordaQuadro), Escalar(BordaQuadro), Escalar(BordaQuadro), Escalar(BordaQuadro));
    PnlLogFundo.Color := CorSuperficie;
    PnlLogFundo.Padding.SetBounds(0, 0, 0, Escalar(PaddingLog));
    PnlLogTitulo.Color    := CorSuperficie;
    PnlLogDivisoria.Color := CorBorda;
    AplicarFonte(LabelLogTitulo.Font, FonteDestaque, TamanhoRotuloCampo, CorTexto);
    AplicarFonte(LabelLogData.Font, FonteTexto, TamanhoLegenda, CorTextoSecundario);
    LabelLogTitulo.Caption := 'Detalhes da leitura';
    LabelLogData.Caption   := '';
    ListBoxLog.Color := CorSuperficie;
    AplicarFonte(ListBoxLog.Font, FonteTexto, TamanhoLegenda, CorTexto);
    ListBoxLog.Style       := lbOwnerDrawFixed;
    ListBoxLog.ItemHeight  := Escalar(AlturaLinhaLog);
    ListBoxLog.OnDrawItem  := ListBoxLogDrawItem;
    ListBoxLog.OnMouseMove := ListBoxLogMouseMove;
    ListBoxLog.ShowHint    := True;
    ListBoxLog.AlignWithMargins := True;

    //Primeiro uso: nenhuma pasta processada
    FEstadoResumo := esrVazio;
    MostrarEstadoResumo;
end;

procedure TFormPrincipal.AjustarLayoutResumo;
begin
    //Medidas calculadas do Resumo (criação, troca de escala e mudança de estado)
    if (btnCancelar = nil) or FAjustandoResumo then
        Exit;

    FAjustandoResumo := True;
    try
        PnlFaixaResumo.Margins.Bottom := Escalar(EspacoBlocos);
        PnlContadores.Margins.Bottom  := Escalar(EspacoBlocos);
        PnlAvisoResumo.Margins.Bottom := Escalar(EspacoBlocos);
        PnlLogDivisoria.Height := Escalar(DivisoriaGrade);
        ListBoxLog.Margins.SetBounds(0, Escalar(PaddingLog), 0, 0);
        if PnlFaixaResumo.Visible then
            AjustarFaixa(PnlFaixaResumo, PnlFaixaResumoBarra, SkSvgFaixaResumo, PbxFaixaResumo,
                         FTrechosFaixaResumo, PaddingFaixaVertical);
        if PnlAvisoResumo.Visible then
            AjustarFaixa(PnlAvisoResumo, PnlAvisoResumoBarra, SkSvgAvisoResumo, PbxAvisoResumo,
                         FTrechosAvisoResumo, PaddingFaixaVertical);
        AjustarLayoutResumoVazio;
        AjustarLayoutProgresso;
        AjustarContadores;
        AjustarTituloLog;
    finally
        FAjustandoResumo := False;
    end;
end;

procedure TFormPrincipal.AjustarLayoutResumoVazio;
var
    Largura       : Integer;
    LarguraTitulo : Integer;
    AlturaTitulo  : Integer;
    AlturaTexto   : Integer;
    AlturaAtalhos : Integer;
    AlturaEncaixe : Integer;
    Icone         : Integer;
    Espaco        : Integer;
    Margem        : Integer;
    Total         : Integer;
    Topo          : Integer;
    W             : Integer;
begin
    //Estado vazio (mockup .vazio): ícone 48 px, título, texto (até 420 px), botão e legenda dos atalhos,
    //8 px entre eles (o botão tem mais 8 px em cima e a legenda mais 4 px), tudo no centro do quadro
    if btnResumoVazio = nil then
        Exit;

    //Cancelado no primeiro uso (mockup, estado cancelado): 5.37 no lugar da 5.2, sem botão e sem atalhos
    if FVazioAposCancelar then
        LabelResumoVazioTexto.Caption := 'As notas e os totais continuam como estavam antes de Processar.'
    else
        LabelResumoVazioTexto.Caption := 'Selecione uma pasta com XMLs de NF-e (55) ou NFC-e (65), ou arraste a ' +
                                         'pasta para esta janela, e clique em Processar.';
    PnlResumoVazioBotao.Visible     := not FVazioAposCancelar;
    LabelResumoVazioAtalhos.Visible := not FVazioAposCancelar;

    W       := PnlResumoVazioFundo.ClientWidth;
    Espaco  := Escalar(EspacoVazio);
    Icone   := Escalar(TamanhoIconeVazio);
    Margem  := btnResumoVazio.MargemFoco;
    LarguraTitulo := Max(1, W - 2 * Escalar(Espaco2));
    Largura := Min(Escalar(LarguraTextoVazio), LarguraTitulo);
    AlturaTitulo  := AlturaTextoQuebrado(LabelResumoVazioTitulo, LarguraTitulo);
    AlturaTexto   := AlturaTextoQuebrado(LabelResumoVazioTexto, Largura);
    AlturaAtalhos := AlturaTextoQuebrado(LabelResumoVazioAtalhos, LarguraTitulo);
    AlturaEncaixe := Escalar(AlturaBotao) + 2 * Margem;
    PnlResumoVazioBotao.Width  := btnResumoVazio.LarguraIdeal;
    PnlResumoVazioBotao.Height := AlturaEncaixe;

    Total := Icone + Espaco + AlturaTitulo + Espaco + AlturaTexto;
    if not FVazioAposCancelar then
        Inc(Total, 2 * Espaco + Escalar(AlturaBotao) + Espaco + Escalar(EspacoAtalhosVazio) + AlturaAtalhos);
    Topo  := Max(0, (PnlResumoVazioFundo.ClientHeight - Total) div 2);
    SkSvgResumoVazio.SetBounds((W - Icone) div 2, Topo, Icone, Icone);
    Inc(Topo, Icone + Espaco);
    LabelResumoVazioTitulo.SetBounds((W - LarguraTitulo) div 2, Topo, LarguraTitulo, AlturaTitulo);
    Inc(Topo, AlturaTitulo + Espaco);
    LabelResumoVazioTexto.SetBounds((W - Largura) div 2, Topo, Largura, AlturaTexto);
    Inc(Topo, AlturaTexto + 2 * Espaco);
    PnlResumoVazioBotao.SetBounds((W - PnlResumoVazioBotao.Width) div 2, Topo - Margem, PnlResumoVazioBotao.Width,
                                  AlturaEncaixe);
    Inc(Topo, Escalar(AlturaBotao) + Espaco + Escalar(EspacoAtalhosVazio));
    LabelResumoVazioAtalhos.SetBounds((W - LarguraTitulo) div 2, Topo, LarguraTitulo, AlturaAtalhos);
end;

procedure TFormPrincipal.AjustarLayoutProgresso;
var
    Medida          : TBitmap;
    Esquerda        : Integer;
    Largura         : Integer;
    Espaco          : Integer;
    Margem          : Integer;
    AlturaTitulo    : Integer;
    AlturaLinha     : Integer;
    AlturaEncaixe   : Integer;
    LarguraContagem : Integer;
    Total           : Integer;
    Topo            : Integer;
    Preenchido      : Integer;
begin
    //Quadro "Lendo os XMLs…" (mockup, estado processando): padding 32 x 48, blocos com 12 px entre eles
    //(a linha do Cancelar tem mais 8 px em cima), tudo centralizado na altura do quadro
    if btnCancelar = nil then
        Exit;

    Medida := TBitmap.Create;
    try
        Medida.Canvas.Font.Assign(LabelProgressoTitulo.Font);
        AlturaTitulo := Medida.Canvas.TextHeight('Ag');
        Medida.Canvas.Font.Assign(LabelProgressoContagem.Font);
        LarguraContagem := Medida.Canvas.TextWidth(LabelProgressoContagem.Caption);
    finally
        Medida.Free;
    end;

    Esquerda      := Escalar(PaddingProgressoHorizontal);
    Largura       := Max(1, PnlProgressoFundo.ClientWidth - 2 * Esquerda);
    Espaco        := Escalar(EspacoProgresso);
    Margem        := btnCancelar.MargemFoco;
    AlturaLinha   := Escalar(AlturaLinhaProgresso);
    AlturaEncaixe := Escalar(AlturaBotao) + 2 * Margem;

    Total := AlturaTitulo + Espaco + Escalar(AlturaBarraProgresso) + Espaco + AlturaLinha + Espaco +
             Escalar(EspacoAcoesProgresso) + Escalar(AlturaBotao);
    Topo  := Max(Escalar(PaddingProgressoVertical), (PnlProgressoFundo.ClientHeight - Total) div 2);

    LabelProgressoTitulo.SetBounds(Esquerda, Topo, Largura, AlturaTitulo);
    Inc(Topo, AlturaTitulo + Espaco);

    //Barra (tokens.md 5.10): o preenchimento acompanha "{x} de {n}" (N = quantidade de arquivos)
    PnlProgressoTrilho.SetBounds(Esquerda, Topo, Largura, Escalar(AlturaBarraProgresso));
    Preenchido := 0;
    if FProgressoTotal > 0 then
        Preenchido := MulDiv(Largura, Min(FProgressoLidos, FProgressoTotal), FProgressoTotal);
    PnlProgressoBarra.Width := Preenchido;
    Inc(Topo, Escalar(AlturaBarraProgresso) + Espaco);

    //"{x} de {n} arquivos" à esquerda e o nome do arquivo em legenda à direita, cortado no meio com "…"
    LabelProgressoContagem.SetBounds(Esquerda, Topo, Min(Largura, LarguraContagem), AlturaLinha);
    LabelProgressoArquivo.SetBounds(Esquerda + LarguraContagem + Escalar(Espaco2), Topo,
                                    Max(0, Largura - LarguraContagem - Escalar(Espaco2)), AlturaLinha);
    LabelProgressoArquivo.Caption := EncurtarNoMeio(LabelProgressoArquivo.Font, FProgressoArquivo,
                                                    LabelProgressoArquivo.Width);
    LabelProgressoArquivo.Hint     := FProgressoArquivo;
    LabelProgressoArquivo.ShowHint := FProgressoArquivo <> '';
    Inc(Topo, AlturaLinha + Espaco + Escalar(EspacoAcoesProgresso));

    //Cancelar (a face alinhada ao texto; o painel de encaixe tem a margem do contorno de foco) e a legenda
    PnlCancelar.SetBounds(Esquerda - Margem, Topo - Margem, btnCancelar.LarguraIdeal, AlturaEncaixe);
    LabelProgressoDica.SetBounds(PnlCancelar.Left + PnlCancelar.Width - Margem + Escalar(Espaco1), Topo,
                                 Max(0, Esquerda + Largura - (PnlCancelar.Left + PnlCancelar.Width - Margem +
                                        Escalar(Espaco1))), Escalar(AlturaBotao));
end;

procedure TFormPrincipal.AjustarContadores;
var
    Contadores : array[0..3] of TPanel;
    Fundos     : array[0..3] of TPanel;
    Icones     : array[0..3] of TSkSvg;
    Numeros    : array[0..3] of TLabel;
    Rotulos    : array[0..3] of TLabel;
    Medida     : TBitmap;
    AlturaNum  : array[0..3] of Integer;
    AlturaRot  : Integer;
    Conteudo   : Integer;
    Altura     : Integer;
    AlturaFundo: Integer;
    Espaco     : Integer;
    Largura    : Integer;
    Sobra      : Integer;
    Icone      : Integer;
    Esquerda   : Integer;
    Topo       : Integer;
    X, W, I    : Integer;
begin
    //4 contadores com a mesma largura e 8 px entre eles (mockup .cnts); padding 8 x 12, ícone de 24 px
    //e, 12 px à direita, o número com o rótulo embaixo, centralizados na altura
    if btnCancelar = nil then
        Exit;

    Contadores[0] := PnlContadorAutorizadas; Fundos[0] := PnlContadorAutorizadasFundo;
    Contadores[1] := PnlContadorIgnoradas;   Fundos[1] := PnlContadorIgnoradasFundo;
    Contadores[2] := PnlContadorComErro;     Fundos[2] := PnlContadorComErroFundo;
    Contadores[3] := PnlContadorTempo;       Fundos[3] := PnlContadorTempoFundo;
    Icones[0] := SkSvgContadorAutorizadas; Numeros[0] := LabelNumeroAutorizadas; Rotulos[0] := LabelRotuloAutorizadas;
    Icones[1] := SkSvgContadorIgnoradas;   Numeros[1] := LabelNumeroIgnoradas;   Rotulos[1] := LabelRotuloIgnoradas;
    Icones[2] := SkSvgContadorComErro;     Numeros[2] := LabelNumeroComErro;     Rotulos[2] := LabelRotuloComErro;
    Icones[3] := SkSvgContadorTempo;       Numeros[3] := LabelNumeroTempo;       Rotulos[3] := LabelRotuloTempo;

    Medida := TBitmap.Create;
    try
        for I := Low(Numeros) to High(Numeros) do
        begin
            Medida.Canvas.Font.Assign(Numeros[I].Font);
            AlturaNum[I] := Medida.Canvas.TextHeight('0');
        end;
        Medida.Canvas.Font.Assign(LabelRotuloAutorizadas.Font);
        AlturaRot := Medida.Canvas.TextHeight('Ag');
    finally
        Medida.Free;
    end;

    Icone    := Escalar(TamanhoIconeContador);
    Conteudo := Max(Icone, AlturaNum[0] + AlturaRot);
    AlturaFundo := Conteudo + 2 * Escalar(PaddingContadorVertical);
    Altura   := Escalar(BordaSuperiorContador) + AlturaFundo + Escalar(BordaQuadro);
    if PnlContadores.Height <> Altura then
        PnlContadores.Height := Altura;

    Espaco  := Escalar(EspacoContadores);
    Largura := (PnlContadores.ClientWidth - 3 * Espaco) div 4;
    Sobra   := PnlContadores.ClientWidth - 3 * Espaco - 4 * Largura;
    X := 0;
    for I := Low(Contadores) to High(Contadores) do
    begin
        W := Largura;
        if I < Sobra then
            Inc(W);
        Contadores[I].SetBounds(X, 0, W, Altura);
        Contadores[I].Padding.SetBounds(Escalar(BordaQuadro), 0, Escalar(BordaQuadro), Escalar(BordaQuadro));
        Inc(X, W + Espaco);

        Esquerda := Escalar(PaddingContadorHorizontal);
        Icones[I].SetBounds(Esquerda, (AlturaFundo - Icone) div 2, Icone, Icone);
        Inc(Esquerda, Icone + Escalar(EspacoIconeContador));
        Topo := (AlturaFundo - (AlturaNum[I] + AlturaRot)) div 2;
        Numeros[I].SetBounds(Esquerda, Topo, Max(0, W - 2 * Escalar(BordaQuadro) - Esquerda -
                             Escalar(PaddingContadorHorizontal)), AlturaNum[I]);
        Rotulos[I].SetBounds(Esquerda, Topo + AlturaNum[I], Numeros[I].Width, AlturaRot);
    end;
end;

procedure TFormPrincipal.AjustarTituloLog;
var
    Medida : TBitmap;
    Altura : Integer;
begin
    //Linha de título do log (mockup): padding 8 x 12, "Detalhes da leitura" à esquerda e "Processado em…"
    //à direita, divisória de 1 px CorBorda embaixo
    if btnCancelar = nil then
        Exit;

    Medida := TBitmap.Create;
    try
        Medida.Canvas.Font.Assign(LabelLogTitulo.Font);
        Altura := Medida.Canvas.TextHeight('Ag');
    finally
        Medida.Free;
    end;
    PnlLogTitulo.Height := Altura + 2 * Escalar(PaddingTituloLogVertical);
    LabelLogTitulo.Margins.SetBounds(Escalar(PaddingTituloLogHorizontal), 0, 0, 0);
    LabelLogData.Margins.SetBounds(0, 0, Escalar(PaddingTituloLogHorizontal), 0);
end;

procedure TFormPrincipal.AjustarFaixa(Faixa, Barra: TPanel; Icone: TSkSvg; Texto: TPaintBox;
  const Trechos: TTrechosTexto; const PaddingVertical: Integer);
var
    Padding : Integer;
    Tamanho : Integer;
    Largura : Integer;
    Altura  : Integer;
begin
    //Barra de 4 px, ícone 16 px depois dela, texto 12 px depois do ícone e 16 px antes da borda direita.
    //A altura acompanha o texto quebrado na largura da faixa, com o padding vertical em cima e embaixo
    Padding := Escalar(PaddingVertical);
    Tamanho := Escalar(TamanhoIconeMenu);
    Barra.Width := Escalar(BarraFaixa);
    Icone.Width := Tamanho;
    Texto.Margins.SetBounds(Escalar(EspacoIconeFaixa), Padding, Escalar(PaddingFaixaHorizontal), Padding);
    Largura := Faixa.ClientWidth - Barra.Width - Escalar(PaddingFaixaHorizontal) - Tamanho -
               Texto.Margins.Left - Texto.Margins.Right;
    Altura  := Max(Tamanho, MedirTrechos(Trechos, Largura));
    Icone.Margins.SetBounds(Escalar(PaddingFaixaHorizontal), Padding, 0, Altura - Tamanho + Padding);
    if Faixa.Height <> Altura + 2 * Padding then
        Faixa.Height := Altura + 2 * Padding;
    Texto.Invalidate;
end;

procedure TFormPrincipal.PnlResumoVazioFundoResize(Sender: TObject);
begin
    AjustarLayoutResumoVazio;
end;

procedure TFormPrincipal.PnlProgressoFundoResize(Sender: TObject);
begin
    AjustarLayoutProgresso;
end;

procedure TFormPrincipal.PnlContadoresResize(Sender: TObject);
begin
    AjustarContadores;
end;

procedure TFormPrincipal.PnlFaixaResumoResize(Sender: TObject);
begin
    if PnlFaixaResumo.Visible then
        AjustarFaixa(PnlFaixaResumo, PnlFaixaResumoBarra, SkSvgFaixaResumo, PbxFaixaResumo, FTrechosFaixaResumo,
                     PaddingFaixaVertical);
end;

procedure TFormPrincipal.PnlAvisoResumoResize(Sender: TObject);
begin
    if PnlAvisoResumo.Visible then
        AjustarFaixa(PnlAvisoResumo, PnlAvisoResumoBarra, SkSvgAvisoResumo, PbxAvisoResumo, FTrechosAvisoResumo,
                     PaddingFaixaVertical);
end;

procedure TFormPrincipal.FonteDoTrecho(Fonte: TFont; const Estilo: TEstiloTrecho);
begin
    //Faixa de status (tokens.md 5.8): texto 10 pt CorTexto, primeira frase em Semibold; a legenda da
    //segunda linha (ex.: 5.11) em 9 pt CorTextoSecundario
    case Estilo of
        etrDestaque:
        begin
            AplicarFonte(Fonte, FonteDestaque, TamanhoCorpo, CorTexto);
            FonteNaEscala(Fonte, TamanhoCorpo);
        end;
        etrLegenda:
        begin
            AplicarFonte(Fonte, FonteTexto, TamanhoLegenda, CorTextoSecundario);
            FonteNaEscala(Fonte, TamanhoLegenda);
        end;
    else
        AplicarFonte(Fonte, FonteTexto, TamanhoCorpo, CorTexto);
        FonteNaEscala(Fonte, TamanhoCorpo);
    end;
end;

function TFormPrincipal.DesenharTrechos(Tela: TCanvas; const Trechos: TTrechosTexto; const Area: TRect;
  const Desenhar: Boolean): Integer;
var
    X, Y           : Integer;
    AlturaLinha    : Integer;
    LarguraEspaco  : Integer;
    Largura        : Integer;
    Inicio, P, I   : Integer;
    EspacoPendente : Boolean;
    Texto          : string;
    Palavra        : string;
begin
    //Texto com trechos em estilos diferentes, quebrado por palavras na largura da área (a VCL não tem
    //rótulo com Semibold só na primeira frase). Desenhar = False só mede: devolve a altura usada
    X := Area.Left;
    Y := Area.Top;
    AlturaLinha    := 0;
    EspacoPendente := False;
    Tela.Brush.Style := bsClear;
    for I := 0 to High(Trechos) do
    begin
        FonteDoTrecho(Tela.Font, Trechos[I].Estilo);
        if Trechos[I].NovaLinha and ((X > Area.Left) or (AlturaLinha > 0)) then
        begin
            Inc(Y, AlturaLinha);
            X := Area.Left;
            AlturaLinha    := 0;
            EspacoPendente := False;
        end;
        LarguraEspaco := Tela.TextWidth(' ');

        Texto := Trechos[I].Texto;
        P := 1;
        while P <= Length(Texto) do
        begin
            if Texto[P] = ' ' then
            begin
                EspacoPendente := True;
                Inc(P);
                Continue;
            end;

            Inicio := P;
            while (P <= Length(Texto)) and (Texto[P] <> ' ') do
                Inc(P);
            Palavra := Copy(Texto, Inicio, P - Inicio);
            Largura := Tela.TextWidth(Palavra);

            //Palavra que não cabe vai para a linha de baixo (palavras coladas a outro trecho seguem juntas)
            if EspacoPendente and (X > Area.Left) then
            begin
                if X + LarguraEspaco + Largura > Area.Right then
                begin
                    Inc(Y, AlturaLinha);
                    X := Area.Left;
                    AlturaLinha := 0;
                end
                else
                    Inc(X, LarguraEspaco);
            end;
            EspacoPendente := False;

            AlturaLinha := Max(AlturaLinha, Tela.TextHeight('Ag'));
            if Desenhar then
                Tela.TextOut(X, Y, Palavra);
            Inc(X, Largura);
        end;
    end;
    Tela.Brush.Style := bsSolid;
    Result := Y + AlturaLinha - Area.Top;
end;

function TFormPrincipal.MedirTrechos(const Trechos: TTrechosTexto; const Largura: Integer): Integer;
var
    Medida: TBitmap;
begin
    Medida := TBitmap.Create;
    try
        Result := DesenharTrechos(Medida.Canvas, Trechos, Rect(0, 0, Max(1, Largura), 0), False);
    finally
        Medida.Free;
    end;
end;

procedure TFormPrincipal.PbxFaixaResumoPaint(Sender: TObject);
begin
    DesenharTrechos(PbxFaixaResumo.Canvas, FTrechosFaixaResumo, PbxFaixaResumo.ClientRect, True);
end;

procedure TFormPrincipal.PbxAvisoResumoPaint(Sender: TObject);
begin
    DesenharTrechos(PbxAvisoResumo.Canvas, FTrechosAvisoResumo, PbxAvisoResumo.ClientRect, True);
end;

procedure TFormPrincipal.MostrarFaixaResumo(const Trechos: TTrechosTexto);
begin
    //Faixa de aviso no topo do Resumo, logo abaixo do aviso de pasta não encontrada (2.14), se houver
    FTrechosFaixaResumo := Trechos;
    PnlFaixaResumo.Top := PnlAvisoPasta.Top + PnlAvisoPasta.Height + 1;
    PnlFaixaResumo.Visible := True;
    AjustarFaixa(PnlFaixaResumo, PnlFaixaResumoBarra, SkSvgFaixaResumo, PbxFaixaResumo, FTrechosFaixaResumo,
                 PaddingFaixaVertical);
    PbxFaixaResumo.Invalidate;
end;

procedure TFormPrincipal.OcultarFaixaResumo;
begin
    PnlFaixaResumo.Visible := False;
    FTrechosFaixaResumo := nil;
end;

procedure TFormPrincipal.MostrarEstadoResumo;
begin
    //Um só bloco por vez: leitura em andamento, resultado da última leitura ou estado vazio
    PnlProgresso.Visible   := FLendo;
    PnlConcluido.Visible   := (not FLendo) and (FEstadoResumo = esrConcluido);
    PnlResumoVazio.Visible := (not FLendo) and (FEstadoResumo = esrVazio);
    AjustarLayoutResumo;
end;

procedure TFormPrincipal.MostrarAvisoResumo(const Homologacao, Entrada: Integer);
var
    Trechos     : TTrechosTexto;
    NotasHomolog: string;
begin
    //Faixa de aviso entre os contadores e o log (glossário 5.29 a 5.31, aprovados em 20/10/2026)
    Trechos := nil;
    if Homologacao = 1 then
        NotasHomolog := '1 nota de homologação'
    else
        NotasHomolog := IntToStr(Homologacao) + ' notas de homologação';

    if (Homologacao > 0) and (Entrada > 0) then
    begin
        //5.31
        AdicionarTrecho(Trechos, 'Os totais incluem ' + NotasHomolog, etrDestaque);
        AdicionarTrecho(Trechos, ' (ambiente de testes, sem valor fiscal) ', etrNormal);
        AdicionarTrecho(Trechos, 'e ' + IntToStr(Entrada) + ' NF-e de entrada.', etrDestaque);
        AdicionarTrecho(Trechos, ' Confira se a pasta é a certa.', etrNormal);
    end
    else if Homologacao > 0 then
    begin
        //5.29
        AdicionarTrecho(Trechos, 'Os totais incluem ' + NotasHomolog, etrDestaque);
        AdicionarTrecho(Trechos, ' (ambiente de testes, sem valor fiscal). Confira se a pasta é a certa.', etrNormal);
    end
    else if Entrada > 0 then
    begin
        //5.30 (singular: "somada às de saída")
        AdicionarTrecho(Trechos, 'Os totais incluem ' + IntToStr(Entrada) + ' NF-e de entrada', etrDestaque);
        if Entrada = 1 then
            AdicionarTrecho(Trechos, ', somada às de saída. Confira se a pasta é a certa.', etrNormal)
        else
            AdicionarTrecho(Trechos, ', somadas às de saída. Confira se a pasta é a certa.', etrNormal);
    end;

    FTrechosAvisoResumo := Trechos;
    PnlAvisoResumo.Visible := Length(Trechos) > 0;
    if PnlAvisoResumo.Visible then
    begin
        //Entre os contadores e o log
        PnlAvisoResumo.Top := PnlContadores.Top + PnlContadores.Height + 1;
        AjustarFaixa(PnlAvisoResumo, PnlAvisoResumoBarra, SkSvgAvisoResumo, PbxAvisoResumo, FTrechosAvisoResumo,
                     PaddingFaixaVertical);
        PbxAvisoResumo.Invalidate;
    end;
end;

procedure TFormPrincipal.MostrarCancelamento(const Lidos, Total: Integer);
var
    Trechos: TTrechosTexto;
begin
    //Glossário 5.10 e 5.11 (PD-3): nada mudou na grade, nos cards, em Relatórios nem em Enviar.
    //Sem pasta processada antes, o estado vazio abaixo da faixa mostra a 5.37, sem botão
    if FEstadoResumo = esrVazio then
        FVazioAposCancelar := True;
    Trechos := nil;
    AdicionarTrecho(Trechos, 'Processamento cancelado.', etrDestaque);
    AdicionarTrecho(Trechos, ' Nenhuma nota foi alterada.', etrNormal);
    AdicionarTrecho(Trechos, IntToStr(Lidos) + ' de ' + IntToStr(Total) + ' arquivos tinham sido lidos. ' +
                             'Clique em Processar para começar de novo.', etrLegenda, True);
    MostrarFaixaResumo(Trechos);
end;

function TFormPrincipal.TextoArquivosLidos(const Quantidade: Integer): string;
begin
    //Rótulo do 4º contador (glossário 5.13), com singular e plural
    if Quantidade = 1 then
        Result := '1 arquivo lido'
    else
        Result := IntToStr(Quantidade) + ' arquivos lidos';
end;

function TFormPrincipal.EncurtarNoMeio(Fonte: TFont; const Texto: string; const Largura: Integer): string;
var
    Medida    : TBitmap;
    Esquerda  : Integer;
    Direita   : Integer;
    Tentativa : string;
begin
    //Nome longo: tira caracteres do meio e põe "…" no lugar, mantendo o começo e o fim (extensão)
    Result := Texto;
    if (Texto = '') or (Largura <= 0) then
        Exit;

    Medida := TBitmap.Create;
    try
        Medida.Canvas.Font.Assign(Fonte);
        if Medida.Canvas.TextWidth(Texto) <= Largura then
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
            if Medida.Canvas.TextWidth(Tentativa) <= Largura then
                Exit(Tentativa);
        end;
        Result := #$2026;
    finally
        Medida.Free;
    end;
end;

function TFormPrincipal.IconeLog(const Tipo: TTipoLinhaLog): TBitmap;
var
    Pincel  : TSkSvgBrush;
    Tamanho : Integer;
    Cor     : TColor;
    Svg     : string;
begin
    //Ícone de 16 px de cada tipo de linha do log, desenhado uma vez na escala atual (Skia) e reaproveitado
    //em todas as linhas: sucesso circle-check CorSucesso, aviso triangle-alert CorAviso, erro circle-x CorErro
    if FIconesLog[Tipo] = nil then
    begin
        case Tipo of
            llSucesso:
            begin
                Svg := IconeSucesso;
                Cor := CorSucesso;
            end;
            llAviso:
            begin
                Svg := IconeAviso;
                Cor := CorAviso;
            end;
        else
            Svg := IconeErro;
            Cor := CorErro;
        end;

        Tamanho := Escalar(TamanhoIconePequeno);
        Pincel  := TSkSvgBrush.Create;
        try
            Pincel.Source        := Svg;
            Pincel.OverrideColor := CorAlpha(Cor);
            FIconesLog[Tipo] := TBitmap.Create;
            FIconesLog[Tipo].SetSize(Tamanho, Tamanho);
            FIconesLog[Tipo].SkiaDraw(
                procedure (const ACanvas: ISkCanvas)
                begin
                    Pincel.Render(ACanvas, RectF(0, 0, Tamanho, Tamanho), 1);
                end);
        finally
            Pincel.Free;
        end;
    end;
    Result := FIconesLog[Tipo];
end;

procedure TFormPrincipal.LiberarIconesLog;
var
    Tipo: TTipoLinhaLog;
begin
    //Troca de escala (os ícones são refeitos no tamanho novo) e fim do app
    for Tipo := Low(TTipoLinhaLog) to High(TTipoLinhaLog) do
        FreeAndNil(FIconesLog[Tipo]);
end;

procedure TFormPrincipal.ListBoxLogDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
var
    Tela    : TCanvas;
    Tipo    : TTipoLinhaLog;
    Icone   : TBitmap;
    Area    : TRect;
    Texto   : string;
    Padding : Integer;
begin
    //Linha do log (mockup .log): padding 3 x 12, ícone de 16 px colorido pelo tipo, 8 px, texto 9 pt
    //CorTexto numa linha só (a linha inteira aparece na dica). Linha escolhida pelo teclado em CorPrimariaSuave
    Tela := ListBoxLog.Canvas;
    Tela.Brush.Style := bsSolid;
    if (odSelected in State) and ListBoxLog.Focused then
        Tela.Brush.Color := CorPrimariaSuave
    else
        Tela.Brush.Color := CorSuperficie;
    Tela.FillRect(Rect);
    if (Index < 0) or (Index >= ListBoxLog.Items.Count) then
        Exit;

    Tipo    := TTipoLinhaLog(NativeInt(ListBoxLog.Items.Objects[Index]));
    Padding := Escalar(PaddingLinhaLog);
    Icone   := IconeLog(Tipo);
    Tela.Draw(Rect.Left + Padding, Rect.Top + (Rect.Height - Icone.Height) div 2, Icone);

    Texto := ListBoxLog.Items[Index];
    Area  := System.Types.Rect(Rect.Left + Padding + Icone.Width + Escalar(EspacoIconeLog), Rect.Top,
                          Rect.Right - Padding, Rect.Bottom);
    Tela.Font.Assign(ListBoxLog.Font);
    Tela.Font.Color  := CorTexto;
    Tela.Brush.Style := bsClear;
    DrawText(Tela.Handle, PChar(Texto), Length(Texto), Area,
             DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX or DT_END_ELLIPSIS or DT_LEFT);
    Tela.Brush.Style := bsSolid;
end;

procedure TFormPrincipal.ListBoxLogMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
    Indice  : Integer;
    Texto   : string;
    Medida  : TBitmap;
    Largura : Integer;
begin
    //Dica com a linha inteira do log sob o mouse, só quando a lista corta a linha com "…" (revisão da
    //4.9, A6). A largura do texto é a mesma do ListBoxLogDrawItem
    Indice := ListBoxLog.ItemAtPos(Point(X, Y), True);
    Texto  := '';
    if Indice >= 0 then
    begin
        Medida := TBitmap.Create;
        try
            Medida.Canvas.Font.Assign(ListBoxLog.Font);
            Largura := ListBoxLog.ClientWidth - 2 * Escalar(PaddingLinhaLog) -
                       IconeLog(TTipoLinhaLog(NativeInt(ListBoxLog.Items.Objects[Indice]))).Width - Escalar(EspacoIconeLog);
            if Medida.Canvas.TextWidth(ListBoxLog.Items[Indice]) > Largura then
                Texto := ListBoxLog.Items[Indice];
        finally
            Medida.Free;
        end;
    end;
    if ListBoxLog.Hint <> Texto then
    begin
        ListBoxLog.Hint := Texto;
        Application.CancelHint;
    end;
end;

procedure TFormPrincipal.ResumoSelecionarPastaClick(Sender: TObject);
begin
    //"Selecionar pasta…" do estado vazio do Resumo (5.3): mesmo seletor do Ctrl+O
    SelecionarPasta;
end;

procedure TFormPrincipal.IniciarLeitura(const Pasta: string);
begin
    //Processar (P1): a leitura roda numa thread e a tela continua respondendo. O Resumo mostra o
    //progresso; grade, cards, Relatórios e Enviar ficam como estavam até a leitura terminar (PD-3)
    LiberarThreadLeitura;
    FPastaLeitura       := Pasta;
    FCancelamentoPedido := False;
    FVazioAposCancelar  := False;
    FProgressoLidos     := 0;
    FProgressoTotal     := 0;
    FProgressoArquivo   := '';
    LabelProgressoContagem.Caption := '';

    MostrarTela(tlResumo);
    OcultarFaixaResumo;
    FLendo := True;
    MostrarEstadoResumo;
    if btnCancelar.CanFocus then
        btnCancelar.SetFocus;
    DefinirBloqueio(blLeitura, True);
    try
        FLeitura := TThreadLeituraXML.Create(Pasta, LeituraProgresso);
        FLeitura.OnTerminate := LeituraTerminada;
        FLeitura.Start;
    except
        //A thread não pôde ser criada: a tela volta como estava, inclusive o Processar
        FreeAndNil(FLeitura);
        FLendo := False;
        MostrarEstadoResumo;
        DefinirBloqueio(blLeitura, False);
        raise;
    end;
end;

procedure TFormPrincipal.LiberarThreadLeitura;
begin
    //A thread da leitura anterior já terminou (o fim dela devolveu a tela); falta liberar o objeto.
    //No fim do app ela é cancelada antes (Terminate) e esperada aqui
    if FLeitura <> nil then
    begin
        FLeitura.Terminate;
        FLeitura.WaitFor;
        FreeAndNil(FLeitura);
    end;
end;

procedure TFormPrincipal.CancelarLeitura;
begin
    //Cancelamento cooperativo: a thread para antes do próximo arquivo (Terminated) e o fim dela mostra
    //a faixa 5.10/5.11. Tudo o que foi lido é descartado (PD-3)
    if (not FLendo) or (FLeitura = nil) then
        Exit;

    FCancelamentoPedido := True;
    FLeitura.Terminate;
end;

procedure TFormPrincipal.CancelarLeituraClick(Sender: TObject);
begin
    CancelarLeitura;
end;

procedure TFormPrincipal.LeituraProgresso(const Lidos, Total: Integer; const Arquivo: string);
begin
    //Aviso da thread de leitura, já na thread principal (TThread.Queue; no máximo um a cada 50 ms)
    if (not FLendo) or FFechando then
        Exit;

    FProgressoLidos   := Lidos;
    FProgressoTotal   := Total;
    FProgressoArquivo := Arquivo;
    AtualizarProgresso;
end;

procedure TFormPrincipal.AtualizarProgresso;
begin
    //Glossário 5.6: "{x} de {n} arquivos" (vazio até a thread contar os arquivos da pasta)
    if FProgressoTotal > 0 then
        LabelProgressoContagem.Caption := IntToStr(FProgressoLidos) + ' de ' + IntToStr(FProgressoTotal) + ' arquivos'
    else
        LabelProgressoContagem.Caption := '';
    AjustarLayoutProgresso;
end;

procedure TFormPrincipal.LeituraTerminada(Sender: TObject);
var
    Resultado  : TResultadoLeitura;
    Erro       : string;
    ClasseErro : string;
    Concluida  : Boolean;
    Trechos    : TTrechosTexto;
begin
    //OnTerminate da thread de leitura: roda na thread principal. Nenhuma exceção pode sair daqui (o
    //Synchronize a levaria de volta para a thread): o erro é mostrado aqui mesmo
    try
        Resultado  := nil;
        Erro       := '';
        ClasseErro := '';
        Concluida  := False;
        try
            try
                if FLeitura <> nil then
                begin
                    Resultado  := FLeitura.ExtrairResultado;
                    Erro       := FLeitura.Erro;
                    ClasseErro := FLeitura.ClasseErro;
                end;

                //A janela vai fechar (pergunta 5.28 respondida com Sim): nada muda na tela
                if FFechando or (Resultado = nil) then
                    Exit;

                //Erro fora da leitura de um arquivo (ex.: pasta apagada): tudo fica como estava
                if Erro = '' then
                begin
                    if FCancelamentoPedido or Resultado.Cancelado then
                        //PD-3: as notas lidas são descartadas; grade, cards, Relatórios e Enviar ficam como estavam
                        MostrarCancelamento(Resultado.ArquivosLidos, Resultado.TotalArquivos)
                    else if Resultado.TotalArquivos = 0 then
                    begin
                        //Pasta sem XML: como antes da 4.6, a grade fica vazia (cards e relatórios refletem só
                        //a pasta atual) e o Resumo mostra a faixa 2.15 sobre o estado vazio
                        CarregarNotasLidas(Resultado);
                        FEstadoResumo := esrVazio;
                        Trechos := nil;
                        AdicionarTrecho(Trechos, 'Nenhum XML encontrado na pasta selecionada.', etrDestaque);
                        MostrarFaixaResumo(Trechos);
                    end
                    else
                    begin
                        //Leitura concluída: as notas novas vão para a grade e o Resumo mostra o resultado
                        CarregarNotasLidas(Resultado);
                        MostrarResultadoLeitura(Resultado);
                        Concluida := True;
                    end;
                end;
            finally
                Resultado.Free;
            end;
        finally
            //Em qualquer caminho (inclusive erro) a leitura acaba e a tela volta: menu, barra de pasta,
            //atalhos e o Processar (antes ele ficava travado depois de um erro)
            FLendo := False;
            if not FFechando then
                MostrarEstadoResumo;
            DefinirBloqueio(blLeitura, False);
        end;

        if FFechando then
            Exit;

        if Erro <> '' then
        begin
            //Erro fora da leitura de um arquivo (pasta apagada ou sem acesso durante o Processar): caixa de
            //erro 5.38 com a pasta e o motivo, e LOG. As notas carregadas antes continuam na tela
            GravarLog(ClasseErro, 'Processar: ' + FPastaLeitura + ': ' + Erro);
            CaixaMensagem('Não foi possível ler a pasta selecionada.' + sLineBreak + FPastaLeitura + sLineBreak +
                          sLineBreak + 'Motivo: ' + Erro + sLineBreak + sLineBreak +
                          'As notas carregadas antes continuam na tela.', mtError);
        end
        else if Concluida and ListBoxLog.CanFocus then
            //O app continua no Resumo, com o foco no log
            ListBoxLog.SetFocus
        else if btnProcessar.CanFocus then
            btnProcessar.SetFocus;
    except
        on E: Exception do
            CaixaMensagem(E.Message, mtError);
    end;
end;

procedure TFormPrincipal.EncerrarLeituraParaFechar;
begin
    //"Sim" na pergunta 5.28: cancela e espera a thread terminar. O WaitFor da thread principal executa
    //os avisos que ainda estão na fila e o OnTerminate, que não mexem mais na tela
    FFechando := True;
    FCancelamentoPedido := True;
    if FLeitura <> nil then
    begin
        FLeitura.Terminate;
        FLeitura.WaitFor;
    end;
end;

procedure TFormPrincipal.CarregarNotasLidas(Resultado: TResultadoLeitura);
var
    I    : Integer;
    Nota : TNotaLida;
begin
    //Leitura concluída: as notas lidas substituem as anteriores na grade, na thread principal. Pasta
    //nova: o seletor de modelo volta para "Todos" e a busca da tela Notas é limpa (as notas novas
    //aparecem todas)
    SeletorModelo.ItemIndex := 0;
    LimparBusca;
    //Pasta destas notas: os relatórios mostram de onde elas vieram (cancelar ou falhar não chega aqui)
    FPastaNotas := FPastaLeitura;

    FDMemTable1.DisableControls;
    try
        //Limpa a grade: cards e relatórios refletem só a pasta atual
        if FDMemTable1.Active then
            FDMemTable1.EmptyDataSet
        else
            FDMemTable1.CreateDataSet;

        for I := 0 to Resultado.Notas.Count - 1 do
        begin
            Nota := Resultado.Notas[I];
            FDMemTable1.Append;
            try
                FDMemTable1.FieldByName('numero').AsInteger := Nota.Numero;
                FDMemTable1.FieldByName('modelo').AsInteger := Nota.Modelo;

                //Chave de 44 dígitos do Id da nota (D4), não o nome do arquivo
                FDMemTable1.FieldByName('chave').AsString := Nota.Dados.Chave;

                FDMemTable1.FieldByName('data').AsString := FormatarDataNota(Nota.Dados.DataEmissao);
                //Data como aaaammdd: a grade ordena a coluna Data pela data real (etapa 4.5)
                FDMemTable1.FieldByName('data_ordem').AsInteger := DataParaOrdem(Nota.Dados.DataEmissao);

                //Na tela os valores aparecem com FormatarMoeda (pt-BR explícito, OnGetText dos campos)
                FDMemTable1.FieldByName('vlicms').AsFloat := Nota.Dados.vICMS;
                FDMemTable1.FieldByName('bcicms').AsFloat := Nota.Dados.vBC;
                FDMemTable1.FieldByName('vtotal').AsFloat := Nota.Dados.vNF;

                FDMemTable1.FieldByName('xml').AsString := Nota.Caminho;

                //IBS/CBS (zerados quando a nota não tem o grupo IBSCBSTot)
                FDMemTable1.FieldByName('tem_ibscbs').AsBoolean := Nota.Dados.TemIBSCBS;
                FDMemTable1.FieldByName('vbcibscbs').AsFloat   := Nota.Dados.vBCIBSCBS;
                FDMemTable1.FieldByName('vibsuf').AsFloat      := Nota.Dados.vIBSUF;
                FDMemTable1.FieldByName('vibsmun').AsFloat     := Nota.Dados.vIBSMun;
                FDMemTable1.FieldByName('vibs').AsFloat        := Nota.Dados.vIBS;
                FDMemTable1.FieldByName('vcbs').AsFloat        := Nota.Dados.vCBS;

                FDMemTable1.Post;
            except
                on E: Exception do
                begin
                    //Não deixa a linha em edição: a nota sai das autorizadas e o arquivo vira "não foi
                    //possível ler" (5.20), como acontecia antes da 4.6
                    FDMemTable1.Cancel;
                    Dec(Resultado.Autorizadas);
                    Inc(Resultado.ComErro);
                    if Nota.Dados.Homologacao then
                        Dec(Resultado.Homologacao);
                    if Nota.Dados.Entrada then
                        Dec(Resultado.Entrada);
                    Resultado.AdicionarLog(llErro, ExtractFileName(Nota.Caminho) +
                                                   ': não foi possível ler o arquivo (' + MotivoDoErro(E) + ').');
                end;
            end;
        end;
    finally
        FDMemTable1.EnableControls;
    end;

    //Filtro "Todos" na grade, nos cards e nos relatórios: os cards passam a somar as notas novas
    AplicarFiltroModelo;

    //Pasta nova: nenhuma nota escolhida, lista no começo
    FNotaSelecionada := False;
    if FDMemTable1.Active then
        FDMemTable1.First;
    AtualizarTelaNotas;
    DBGrid1.Refresh;
end;

procedure TFormPrincipal.MostrarResultadoLeitura(Resultado: TResultadoLeitura);
var
    I     : Integer;
    Linha : TLinhaLog;
begin
    //Contadores (glossário 5.12 e 5.13): autorizadas, ignoradas, com erro e "{t} s · {n} arquivos lidos"
    LabelNumeroAutorizadas.Caption := IntToStr(Resultado.Autorizadas);
    LabelNumeroIgnoradas.Caption   := IntToStr(Resultado.Ignoradas);
    LabelNumeroComErro.Caption     := IntToStr(Resultado.ComErro);
    //5.13 (revisão da 4.9): menos de 0,1 s aparece como "< 0,1 s"
    if Resultado.DuracaoMs < 100 then
        LabelNumeroTempo.Caption := '< 0,1 s'
    else
        LabelNumeroTempo.Caption := FormatFloat('0.0', Resultado.DuracaoMs / 1000, FormatoPtBR) + ' s';
    LabelRotuloTempo.Caption       := TextoArquivosLidos(Resultado.ArquivosLidos);

    //"Processado em dd/mm/aaaa hh:mm" (5.15)
    LabelLogData.Caption := 'Processado em ' + FormatDateTime('dd"/"mm"/"yyyy hh":"nn', Now, FormatoPtBR);

    //Log: uma linha por ocorrência, na ordem de leitura, e o fechamento (5.23 e 5.21)
    ListBoxLog.Items.BeginUpdate;
    try
        ListBoxLog.Items.Clear;
        for I := 0 to Resultado.Log.Count - 1 do
        begin
            Linha := Resultado.Log[I];
            ListBoxLog.Items.AddObject(Linha.Texto, TObject(NativeInt(Ord(Linha.Tipo))));
        end;

        //5.23: só quando não há ignoradas nem erros (no plural: com 1 arquivo fica só a 5.21)
        if (Resultado.Ignoradas = 0) and (Resultado.ComErro = 0) and (Resultado.ArquivosLidos > 1) then
            ListBoxLog.Items.AddObject('Todos os ' + IntToStr(Resultado.ArquivosLidos) +
                                       ' arquivos foram lidos sem ocorrências.', TObject(NativeInt(Ord(llSucesso))));

        //5.21, com singular
        if Resultado.Autorizadas = 1 then
            ListBoxLog.Items.AddObject('1 nota autorizada carregada.', TObject(NativeInt(Ord(llSucesso))))
        else
            ListBoxLog.Items.AddObject(IntToStr(Resultado.Autorizadas) + ' notas autorizadas carregadas.',
                                       TObject(NativeInt(Ord(llSucesso))));
    finally
        ListBoxLog.Items.EndUpdate;
    end;
    ListBoxLog.TopIndex := 0;

    //Aviso de homologação e entrada (5.29 a 5.31) entre os contadores e o log
    MostrarAvisoResumo(Resultado.Homologacao, Resultado.Entrada);

    FEstadoResumo := esrConcluido;
end;

{ Envio do e-mail em segundo plano (etapas 4.6 e 4.7) }

procedure TFormPrincipal.IniciarEnvio;
var
    Envio      : TThreadEnvioEmail;
    Notas      : TFDMemTable;
    Marcador   : TBookmark;
    Quantidade : Integer;
    DataMenor  : Integer;
    DataMaior  : Integer;
    DataNota   : Integer;
    Assunto    : string;

    function DataDaOrdem(const Ordem: Integer): string;
    begin
        //aaaammdd -> dd/mm/aaaa
        Result := Format('%.2d/%.2d/%.4d', [Ordem mod 100, (Ordem div 100) mod 100, Ordem div 10000]);
    end;

begin
    //Tudo o que vem da tela é lido aqui, na thread principal: os XMLs das notas do filtro de modelo (a
    //busca da tela Notas não vale para o Enviar: D5), o destino, o assunto e a mensagem. A configuração do
    //ACBrMail já foi carregada ao abrir a tela Enviar (LerConfigEmail)
    LiberarThreadEnvio;
    OcultarResultadoEnvio;

    Quantidade := 0;
    DataMenor  := 0;
    DataMaior  := 0;
    Envio := TThreadEnvioEmail.Create(ACBrNFe, ExtractFilePath(ParamStr(0)), Trim(EditEmailEnviar.Text), '',
                                      MemoMensagem.Lines);
    try
        Notas := NotasDoModelo;
        Notas.DisableControls;
        try
            Marcador := Notas.GetBookmark;
            try
                Notas.First;
                while not Notas.Eof do
                begin
                    //A chave tem 44 dígitos (D4): o arquivo sai como <chave>-nfe.xml (H3)
                    Envio.AdicionarXML(Notas.FieldByName('xml').AsString,
                                       Notas.FieldByName('chave').AsString + '-nfe.xml');
                    Inc(Quantidade);

                    //Período do assunto: menor e maior data das notas enviadas (data_ordem = aaaammdd)
                    DataNota := Notas.FieldByName('data_ordem').AsInteger;
                    if DataNota > 0 then
                    begin
                        if (DataMenor = 0) or (DataNota < DataMenor) then
                            DataMenor := DataNota;
                        if DataNota > DataMaior then
                            DataMaior := DataNota;
                    end;
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

        //Assunto (glossário 11.21): "XMLs de Nota Fiscal · {período} · {n} notas"; todas as notas com a mesma
        //data: a data única (decisão de 26/10/2026). Sem nenhuma data válida, o período fica de fora
        Assunto := 'XMLs de Nota Fiscal ' + #$00B7 + ' ';
        if DataMenor > 0 then
        begin
            if DataMenor = DataMaior then
                Assunto := Assunto + DataDaOrdem(DataMenor)
            else
                Assunto := Assunto + DataDaOrdem(DataMenor) + ' a ' + DataDaOrdem(DataMaior);
            Assunto := Assunto + ' ' + #$00B7 + ' ';
        end;
        Envio.Assunto := Assunto + TextoQuantidadeNotas(Quantidade);
        Envio.OnTerminate := EnvioTerminado;
    except
        //A thread ainda não começou: ao ser liberada ela termina sem compactar nem enviar
        Envio.Free;
        raise;
    end;

    //"Enviando…" (glossário 11.13 e 11.14; tokens.md 5.1, estado ocupado): botão desabilitado com o ícone
    //loader-circle estático e a legenda ao lado. Campos, menu e barra de pasta ficam bloqueados até o fim
    FEnvio    := Envio;
    FEnviando := True;
    btnEnviarEmail.Caption  := 'Enviando' + #$2026;
    btnEnviarEmail.IconeSvg := IconeOcupado;
    btnEnviarEmail.Enabled  := False;
    if Quantidade = 1 then
        LabelEnviando.Caption := 'Compactando e enviando 1 XML. Isso pode levar alguns segundos.'
    else
        LabelEnviando.Caption := 'Compactando e enviando ' + IntToStr(Quantidade) +
                                 ' XMLs. Isso pode levar alguns segundos.';
    LabelEnviando.Visible := True;
    //O bloqueio atualiza a tela Enviar (campos desabilitados e a largura do botão no layout)
    DefinirBloqueio(blEnvio, True);
    try
        Envio.Start;
    except
        FEnvio    := nil;
        FEnviando := False;
        Envio.Free;
        RestaurarBotaoEnviar;
        DefinirBloqueio(blEnvio, False);
        raise;
    end;
end;

procedure TFormPrincipal.RestaurarBotaoEnviar;
begin
    //Botão Enviar como antes do envio (glossário 11.11 e 11.12)
    btnEnviarEmail.Caption  := 'Enviar';
    btnEnviarEmail.IconeSvg := IconeEnviar;
    LabelEnviando.Visible := False;
    AtualizarTelaEnviar;
end;

procedure TFormPrincipal.LiberarThreadEnvio;
begin
    //A thread do envio anterior já terminou (o fim dela devolveu a tela); falta liberar o objeto
    if FEnvio <> nil then
    begin
        FEnvio.WaitFor;
        FreeAndNil(FEnvio);
    end;
end;

procedure TFormPrincipal.EnvioTerminado(Sender: TObject);
var
    Envio      : TThreadEnvioEmail;
    Resultado  : TResultadoEnvio;
    Erro       : string;
    ClasseErro : string;
    Trechos    : TTrechosTexto;
begin
    //OnTerminate da thread de envio: roda na thread principal; nenhuma exceção sai daqui
    try
        Envio      := Sender as TThreadEnvioEmail;
        Resultado  := Envio.Resultado;
        Erro       := Envio.Erro;
        ClasseErro := Envio.ClasseErro;
        try
            FEnviando := False;
            if not FFechando then
                RestaurarBotaoEnviar;
        finally
            //Menu e barra de pasta voltam em qualquer caminho
            DefinirBloqueio(blEnvio, False);
        end;

        if FFechando then
            Exit;

        //Resultado numa faixa da própria tela (etapa 4.7), sem caixa de diálogo. Fica até sair da tela ou
        //enviar de novo. Os erros também vão para o LOG
        Trechos := nil;
        FPastaFaixaEnviar := '';
        PnlFaixaEnviar.Hint := '';
        case Resultado of
            reEnviado:
            begin
                //11.16
                AdicionarTrecho(Trechos, 'E-mail enviado', etrDestaque);
                AdicionarTrecho(Trechos, ' para ' + Envio.Para + ' às ' +
                                         FormatDateTime('hh":"nn', Now, FormatoPtBR) + '.', etrNormal);
                MostrarFaixaEnviar(tfSucesso, Trechos, True);
            end;
            reSemWinRAR:
            begin
                //11.20
                GravarLog('Enviar e-mail', 'WinRAR não encontrado em ' + ExtractFilePath(ParamStr(0)));
                //Revisão da 4.9 (A5): a pasta é cortada no meio com "…" na largura da faixa (o ponto final
                //continua) e o caminho completo fica na dica da faixa
                FPastaFaixaEnviar := ExcludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
                PnlFaixaEnviar.Hint     := FPastaFaixaEnviar;
                PnlFaixaEnviar.ShowHint := True;
                MontarTrechosSemWinRAR;
                MostrarFaixaEnviar(tfErro, FTrechosFaixaEnviar, True);
            end;
            reSemAnexo:
            begin
                //11.20a: o WinRAR rodou, mas o .rar não foi gerado
                GravarLog('Enviar e-mail', 'O WinRAR não gerou o arquivo ' + ExtractFilePath(ParamStr(0)) +
                                           'NFCe\NFCe_ProXML.rar');
                AdicionarTrecho(Trechos, 'Não foi possível compactar os XMLs.', etrDestaque);
                AdicionarTrecho(Trechos, ' O arquivo .rar não foi gerado. Tente de novo; se continuar, confira o ' +
                                         'espaço em disco e a pasta do ProXML.', etrNormal);
                MostrarFaixaEnviar(tfErro, Trechos, True);
            end;
        else
            //11.17
            GravarLog(ClasseErro, 'Enviar e-mail: ' + Erro);
            AdicionarTrecho(Trechos, 'Não foi possível enviar o e-mail.', etrDestaque);
            AdicionarTrecho(Trechos, 'O servidor respondeu: ' + MotivoNumaLinha(RespostaDoServidor(Erro)) +
                                     '. Confira os dados em ' +
                                     'Configurações e use Testar conexão.', etrNormal, True);
            MostrarFaixaEnviar(tfErro, Trechos, True);
        end;

        if btnEnviarEmail.CanFocus then
            btnEnviarEmail.SetFocus;
    except
        on E: Exception do
            CaixaMensagem(E.Message, mtError);
    end;
end;

procedure TFormPrincipal.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    //Envio do e-mail em andamento: o app não fecha (glossário 5.36, aviso com OK)
    if FEnviando then
    begin
        CanClose := False;
        CaixaMensagem('O e-mail ainda está sendo enviado. Aguarde terminar para fechar o ProXML.', mtWarning);
        Exit;
    end;

    //Testar conexão em andamento (etapa 4.7): fecha sem perguntar. O FormDestroy aborta o teste (fecha o
    //socket) e espera a thread terminar

    //Leitura em andamento (glossário 5.28, Sim / Não): Sim cancela, espera a thread terminar e fecha
    if FLendo then
    begin
        CanClose := CaixaMensagem('A leitura dos XMLs ainda está em andamento.' + sLineBreak +
                                  'Deseja cancelar e fechar o ProXML?', mtConfirmation, [mbYes, mbNo], mbNo) = mrYes;
        if CanClose then
            EncerrarLeituraParaFechar;
    end;
end;

{ Plano 4, etapa 4.7: campos com borda própria, Enviar, Configurações, Testar conexão e Sobre }

procedure TFormPrincipal.GravarLog(const Classe, Texto: string);
begin
    //LOG no banco sem deixar exceção sair (o banco pode ser a causa do erro). Se nem o LOG puder ser
    //gravado, resta a saída de depuração
    try
        DMConfig.CreateLog(Classe, Texto);
    except
        on ELog: Exception do
            OutputDebugString(PChar('ProXML: ' + Texto + ' (' + ELog.Message + ')'));
    end;
end;

procedure TFormPrincipal.WMProXMLErroConfig(var Message: TMessage);
begin
    //Glossário 12.18: as configurações de e-mail não puderam ser lidas no FormCreate (já foi para o LOG)
    if FErroLeituraConfig = '' then
        Exit;
    CaixaMensagem('Não foi possível ler as configurações de e-mail.' + sLineBreak + sLineBreak + 'Motivo: ' +
                  FErroLeituraConfig, mtError);
    FErroLeituraConfig := '';
end;

{ Campos com borda própria (tokens.md 5.3) }

function TFormPrincipal.CriarCampo(Borda, Fundo: TPanel; Icone: TSkSvg; Edit: TCustomEdit; Acao, IconeErro: TSkSvg;
  LabelErro: TLabel; const Validar: TValidarCampo): TCampoFormulario;
begin
    //Liga o campo do .dfm ao visual do tema: fundo CorSuperficie, texto 10 pt CorTexto, ícones de 16 px
    //CorTextoSecundario e a linha de erro (circle-alert 14 px + texto 9 pt CorErro), escondida
    Result := TCampoFormulario.Create;
    Result.Borda     := Borda;
    Result.Fundo     := Fundo;
    Result.Icone     := Icone;
    Result.Edit      := Edit;
    Result.Acao      := Acao;
    Result.IconeErro := IconeErro;
    Result.LabelErro := LabelErro;
    Result.Validar   := Validar;
    SetLength(FCampos, Length(FCampos) + 1);
    FCampos[High(FCampos)] := Result;

    AplicarFonte(TEditAcesso(Edit).Font, FonteTexto, TamanhoCorpo, CorTexto);
    TEditAcesso(Edit).OnEnter  := CampoEnter;
    TEditAcesso(Edit).OnExit   := CampoExit;
    TEditAcesso(Edit).OnChange := CampoChange;
    if Icone <> nil then
        Icone.Width := Escalar(TamanhoIconePequeno);
    if Acao <> nil then
        Acao.Width := Escalar(TamanhoIconePequeno);
    if IconeErro <> nil then
    begin
        IconeErro.Svg.Source        := IconeErroCampo;
        IconeErro.Svg.OverrideColor := CorAlpha(CorErro);
        IconeErro.Visible := False;
        AplicarFonte(LabelErro.Font, FonteTexto, TamanhoLegenda, CorErro);
        LabelErro.WordWrap := True;
        LabelErro.Visible  := False;
    end;
    AtualizarCampo(Result);
end;

function TFormPrincipal.CampoDoControle(Controle: TObject): TCampoFormulario;
var
    I: Integer;
begin
    Result := nil;
    for I := 0 to High(FCampos) do
        if FCampos[I].Edit = Controle then
            Exit(FCampos[I]);
end;

procedure TFormPrincipal.AtualizarCampo(Campo: TCampoFormulario);
var
    Habilitado : Boolean;
    ComErro    : Boolean;
    CorIcone   : TColor;
begin
    //Estados do campo (tokens.md 5.3): normal, foco (2 px CorPrimaria), erro (2 px CorErro, mensagem
    //abaixo) e desabilitado (1 px CorBorda, fundo CorFundoDesabilitado, texto CorTextoDesabilitado).
    //Desabilitado é o contêiner da borda (o TEdit continua habilitado, como no campo da pasta)
    if Campo = nil then
        Exit;

    Habilitado := Campo.Borda.Enabled;
    ComErro    := Habilitado and (Campo.Erro <> '');
    AtualizarBordaCampo(Campo.Borda, Campo.Icone, Campo.Edit, 0, Habilitado and Campo.Edit.Focused, ComErro,
                        Campo.Acao);

    if Habilitado then
    begin
        Campo.Fundo.Color := CorSuperficie;
        TEditAcesso(Campo.Edit).Color      := CorSuperficie;
        TEditAcesso(Campo.Edit).Font.Color := CorTexto;
        CorIcone := CorTextoSecundario;
    end
    else
    begin
        Campo.Borda.Color := CorBorda;
        Campo.Fundo.Color := CorFundoDesabilitado;
        TEditAcesso(Campo.Edit).Color      := CorFundoDesabilitado;
        TEditAcesso(Campo.Edit).Font.Color := CorTextoDesabilitado;
        CorIcone := CorTextoDesabilitado;
    end;
    if Campo.Icone <> nil then
        Campo.Icone.Svg.OverrideColor := CorAlpha(CorIcone);
    if Campo.Acao <> nil then
        Campo.Acao.Svg.OverrideColor := CorAlpha(CorIcone);

    if Campo.IconeErro <> nil then
    begin
        Campo.LabelErro.Caption   := Campo.Erro;
        Campo.LabelErro.Visible   := ComErro;
        Campo.IconeErro.Visible   := ComErro;
        Campo.IconeErro.Width     := Escalar(TamanhoIconeErroCampo);
        Campo.IconeErro.Height    := Escalar(TamanhoIconeErroCampo);
    end;
end;

procedure TFormPrincipal.HabilitarCampo(Campo: TCampoFormulario; const Habilitar: Boolean);
begin
    if (Campo <> nil) and (Campo.Borda.Enabled <> Habilitar) then
    begin
        Campo.Borda.Enabled := Habilitar;
        AtualizarCampo(Campo);
    end;
end;

procedure TFormPrincipal.ValidarCampo(Campo: TCampoFormulario);
begin
    //A mensagem só aparece depois que o usuário sai do campo com erro (Validando); a partir daí ela
    //acompanha cada digitação (tokens.md 5.3)
    if Campo = nil then
        Exit;

    if Assigned(Campo.Validar) and Campo.Validando then
        Campo.Erro := Campo.Validar(Campo.Edit.Text)
    else
        Campo.Erro := '';
    AtualizarCampo(Campo);
end;

procedure TFormPrincipal.CampoEnter(Sender: TObject);
begin
    //Foco: borda de 2 px CorPrimaria (ou CorErro, se o campo estiver com erro)
    AtualizarCampo(CampoDoControle(Sender));
end;

procedure TFormPrincipal.CampoExit(Sender: TObject);
var
    Campo: TCampoFormulario;
begin
    //Validação ao sair do campo: com erro, a mensagem aparece e o campo passa a validar a cada digitação
    Campo := CampoDoControle(Sender);
    if Campo = nil then
        Exit;

    if Assigned(Campo.Validar) and (Campo.Validar(Campo.Edit.Text) <> '') then
        Campo.Validando := True;
    ValidarCampo(Campo);

    if Campo.Borda.Parent = PnlEnviarFundo then
        AtualizarTelaEnviar
    else
        AtualizarEstadoConfig;
end;

procedure TFormPrincipal.CampoChange(Sender: TObject);
var
    Campo: TCampoFormulario;
begin
    //Digitação: revalida (se o campo já mostrou erro) e atualiza o Enviar ou o Salvar, que só ficam
    //habilitados com os campos válidos
    Campo := CampoDoControle(Sender);
    if Campo = nil then
        Exit;

    if Campo.Validando then
        ValidarCampo(Campo);

    if Campo.Borda.Parent = PnlEnviarFundo then
        AtualizarTelaEnviar
    else
        AtualizarEstadoConfig;
end;

function TFormPrincipal.ValidarEmailDestino(const Texto: string): string;
begin
    //Glossário 11.18 (um só destinatário, decisão de 26/10/2026)
    if EmailValido(Trim(Texto)) then
        Result := ''
    else
        Result := 'Informe um e-mail válido. Exemplo: nome@empresa.com.br';
end;

function TFormPrincipal.ValidarServidor(const Texto: string): string;
begin
    //Glossário 12.25
    if Trim(Texto) <> '' then
        Result := ''
    else
        Result := 'Informe o servidor SMTP.';
end;

function TFormPrincipal.ValidarPorta(const Texto: string): string;
var
    Porta: Integer;
    I    : Integer;
begin
    //Glossário 12.23: só algarismos, de 1 a 65535
    Result := 'Informe uma porta entre 1 e 65535.';
    if (Trim(Texto) = '') or (Length(Trim(Texto)) > 5) then
        Exit;
    for I := 1 to Length(Trim(Texto)) do
        if not CharInSet(Trim(Texto)[I], ['0'..'9']) then
            Exit;
    Porta := StrToIntDef(Trim(Texto), 0);
    if (Porta >= 1) and (Porta <= 65535) then
        Result := '';
end;

function TFormPrincipal.ValidarEmailRemetente(const Texto: string): string;
begin
    //Glossário 12.24
    if EmailValido(Trim(Texto)) then
        Result := ''
    else
        Result := 'Informe um e-mail válido.';
end;

function TFormPrincipal.PosicionarCampo(Campo: TCampoFormulario; Rotulo: TLabel; const X, Y, Largura,
  Altura: Integer): Integer;
var
    Medida      : TBitmap;
    AlturaRotulo: Integer;
    AlturaErro  : Integer;
    Topo        : Integer;
    Icone       : Integer;
begin
    //Rótulo (9 pt Semibold), 4 px, o campo e, com erro, 4 px e a mensagem (ícone 14 px + texto que quebra
    //na largura do campo). Devolve a altura usada
    Medida := TBitmap.Create;
    try
        Medida.Canvas.Font.Assign(Rotulo.Font);
        AlturaRotulo := Medida.Canvas.TextHeight('Ag');
    finally
        Medida.Free;
    end;
    Rotulo.SetBounds(X, Y, Largura, AlturaRotulo);
    Topo := Y + AlturaRotulo + Escalar(EspacoMeio);
    Campo.Borda.SetBounds(X, Topo, Largura, Altura);
    Inc(Topo, Altura);

    if (Campo.IconeErro <> nil) and Campo.LabelErro.Visible then
    begin
        Icone := Escalar(TamanhoIconeErroCampo);
        Inc(Topo, Escalar(EspacoMeio));
        AlturaErro := AlturaTextoQuebrado(Campo.LabelErro, Largura - Icone - Escalar(EspacoMeio));
        Campo.LabelErro.SetBounds(X + Icone + Escalar(EspacoMeio), Topo, Max(1, Largura - Icone - Escalar(EspacoMeio)),
                                  AlturaErro);
        //Ícone centralizado na primeira linha da mensagem
        Medida := TBitmap.Create;
        try
            Medida.Canvas.Font.Assign(Campo.LabelErro.Font);
            Campo.IconeErro.SetBounds(X, Topo + Max(0, (Medida.Canvas.TextHeight('Ag') - Icone) div 2), Icone, Icone);
        finally
            Medida.Free;
        end;
        Inc(Topo, AlturaErro);
    end;

    Result := Topo - Y;
end;

function TFormPrincipal.PosicionarLegenda(Rotulo: TLabel; const X, Y, Largura: Integer): Integer;
begin
    //Legenda 9 pt que quebra na largura da coluna; devolve a altura
    Result := AlturaTextoQuebrado(Rotulo, Largura);
    Rotulo.SetBounds(X, Y, Max(1, Largura), Result);
end;

procedure TFormPrincipal.DefinirTipoFaixa(Faixa, Barra: TPanel; Icone: TSkSvg; const Tipo: TTipoFaixa);
begin
    //Faixa de status (tokens.md 5.8): sucesso, aviso, erro ou informação
    case Tipo of
        tfSucesso : PrepararFaixa(Faixa, Barra, Icone, CorSucessoSuave, CorSucesso, IconeSucesso);
        tfAviso   : PrepararFaixa(Faixa, Barra, Icone, CorAvisoSuave, CorAviso, IconeAviso);
        tfErro    : PrepararFaixa(Faixa, Barra, Icone, CorErroSuave, CorErro, IconeErro);
    else
        PrepararFaixa(Faixa, Barra, Icone, CorPrimariaSuave, CorPrimaria, IconeInfo);
    end;
end;

{ Tela Enviar (mockup enviar.html; glossário 11.1 a 11.22) }

procedure TFormPrincipal.PrepararTelaEnviar;
begin
    //Quadro com borda de 1 px CorBorda e fundo CorSuperficie (mockup .panel), padding 16 x 24 e 12 px
    //entre os blocos. As posições ficam em AjustarLayoutEnviar
    Panel10.Color := CorBorda;
    Panel10.Padding.SetBounds(Escalar(BordaQuadro), Escalar(BordaQuadro), Escalar(BordaQuadro), Escalar(BordaQuadro));
    PnlEnviarFundo.Color := CorSuperficie;

    //Título (11.1)
    AplicarFonte(Label11.Font, FonteDestaque, TamanhoTituloTela, CorTexto);
    Label11.Layout  := tlCenter;
    Label11.Caption := 'Enviar por e-mail';

    //Faixa de resultado e de e-mail de envio não configurado (11.16, 11.17, 11.19 e 11.20)
    DefinirTipoFaixa(PnlFaixaEnviar, PnlFaixaEnviarBarra, SkSvgFaixaEnviar, tfInformacao);
    PbxFaixaEnviar.OnPaint := PbxFaixaEnviarPaint;
    PnlFaixaEnviar.Visible := False;

    //Quadro do anexo (mockup .anexo): borda CorBorda, fundo CorFundo, paperclip 20 px CorPrimaria, título
    //10 pt Semibold e detalhe 9 pt CorTextoSecundario (11.3 a 11.6)
    PnlAnexo.Color := CorBorda;
    PnlAnexo.Padding.SetBounds(Escalar(BordaQuadro), Escalar(BordaQuadro), Escalar(BordaQuadro), Escalar(BordaQuadro));
    PnlAnexoFundo.Color := CorFundo;
    SkSvgAnexo.Svg.Source        := IconeAnexo;
    SkSvgAnexo.Svg.OverrideColor := CorAlpha(CorPrimaria);
    AplicarFonte(LabelAnexoTitulo.Font, FonteDestaque, TamanhoCorpo, CorTexto);
    AplicarFonte(LabelAnexoDetalhe.Font, FonteTexto, TamanhoLegenda, CorTextoSecundario);
    LabelAnexoDetalhe.WordWrap := True;

    //Para (11.7, 11.8 e 11.18) e Mensagem (11.9)
    AplicarFonte(Label15.Font, FonteDestaque, TamanhoRotuloCampo, CorTexto);
    Label15.Caption := 'Para';
    AplicarFonte(Label17.Font, FonteDestaque, TamanhoRotuloCampo, CorTexto);
    Label17.Caption := 'Mensagem';
    SkSvgPara.Svg.Source := IconeEmail;
    EditEmailEnviar.TextHint := 'nome@empresa.com.br';
    FCampoPara := CriarCampo(PnlCampoPara, PnlCampoParaFundo, SkSvgPara, EditEmailEnviar, nil, SkSvgErroPara,
                             LabelErroPara, ValidarEmailDestino);
    FCampoMensagemEnviar := CriarCampo(PnlCampoMensagem, PnlCampoMensagemFundo, nil, MemoMensagem, nil, nil, nil, nil);

    //Remetente com o link para Configurações (11.10)
    AplicarFonte(LabelRemetente.Font, FonteTexto, TamanhoLegenda, CorTextoSecundario);
    LabelRemetente.Caption := '';
    PnlAlterarConfig.Color := CorSuperficie;
    btnAlterarConfig := TProBotao.CriarEm(PnlAlterarConfig, 'alterar em Configurações', ebLink, AlterarConfigClick);
    AplicarFonte(btnAlterarConfig.Font, FonteTexto, TamanhoLegenda, CorPrimaria);

    //Enviar (11.11 e 11.12) e a legenda do "Enviando…" (11.14)
    Panel11.Color := CorSuperficie;
    btnEnviarEmail.IconeSvg := IconeEnviar;
    btnEnviarEmail.Hint     := 'Compactar os XMLs e enviar por e-mail';
    btnEnviarEmail.ShowHint := True;
    AplicarFonte(LabelEnviando.Font, FonteTexto, TamanhoLegenda, CorTextoSecundario);
    LabelEnviando.Layout  := tlCenter;
    LabelEnviando.Visible := False;
end;

function TFormPrincipal.SMTPConfigurado: Boolean;
begin
    //E-mail de envio salvo em Configurações com servidor, porta e e-mail válidos (mesma regra do Salvar)
    Result := (ConfigEmail <> nil) and (ValidarServidor(ConfigEmail.SMTP) = '') and
              (ValidarPorta(ConfigEmail.Porta) = '') and EmailValido(Trim(ConfigEmail.Email));
end;

procedure TFormPrincipal.AtualizarAnexoEnviar;
var
    Notas    : TFDMemTable;
    Marcador : TBookmark;
begin
    //Quadro do anexo (11.3 e 11.4): quantidade de XMLs do filtro de modelo e a soma do tamanho dos XMLs,
    //sem compactar (o .rar só é gerado no clique em Enviar). XML apagado depois da leitura conta 0 byte
    FAnexoQuantidade := 0;
    FAnexoBytes      := 0;
    if not TemNotaNoModelo then
        Exit;

    Notas := NotasDoModelo;
    Notas.DisableControls;
    try
        Marcador := Notas.GetBookmark;
        try
            Notas.First;
            while not Notas.Eof do
            begin
                Inc(FAnexoQuantidade);
                Inc(FAnexoBytes, TamanhoArquivo(Notas.FieldByName('xml').AsString));
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
end;

procedure TFormPrincipal.AtualizarTelaEnviar;
var
    TemNotas   : Boolean;
    Carregadas : Boolean;
    Trechos    : TTrechosTexto;
begin
    //Estado da tela Enviar: anexo (ou "Nenhuma nota para enviar"), faixa 11.19 sem e-mail de envio,
    //remetente, campos e o botão Enviar (habilitado só com notas, e-mail de envio configurado e o "Para"
    //válido; tokens.md 5.12: o motivo do bloqueio fica visível na tela)
    if (btnEnviarEmail = nil) or (FCampoPara = nil) or (btnAlterarConfig = nil) or (SeletorModelo = nil) then
        Exit;

    TemNotas   := TemNotaNoModelo;
    Carregadas := FDMemTable1.Active and (FDMemTable1.Table.Rows.Count > 0);

    if TemNotas then
    begin
        if FAnexoQuantidade = 1 then
            LabelAnexoTitulo.Caption := 'Anexo: 1 XML (.rar)'
        else
            LabelAnexoTitulo.Caption := 'Anexo: ' + IntToStr(FAnexoQuantidade) + ' XMLs (.rar)';
        LabelAnexoDetalhe.Caption := 'Modelo: ' + SeletorModelo.Itens[SeletorModelo.ItemIndex] + ' ' + #$00B7 +
                                     ' os XMLs somam ' + FormatarTamanho(FAnexoBytes) + ' ' + #$00B7 +
                                     ' compactado só ao clicar em Enviar';
    end
    else
    begin
        LabelAnexoTitulo.Caption := 'Nenhuma nota para enviar';
        //Há notas carregadas, mas nenhuma no modelo escolhido: o mesmo texto 8.8a das telas Notas e Relatórios
        if Carregadas then
            LabelAnexoDetalhe.Caption := 'Nenhuma nota do modelo selecionado. Escolha outro modelo na barra de cima.'
        else
            LabelAnexoDetalhe.Caption := 'Processe uma pasta para gerar o anexo.';
    end;

    //Sem resultado de envio na tela: faixa informativa 11.19 enquanto o e-mail de envio não estiver configurado
    if not FResultadoEnvio then
    begin
        if SMTPConfigurado then
        begin
            PnlFaixaEnviar.Visible := False;
            FTrechosFaixaEnviar := nil;
        end
        else
        begin
            Trechos := nil;
            AdicionarTrecho(Trechos, 'Configure o e-mail de envio em Configurações antes de enviar.', etrDestaque);
            FTrechosFaixaEnviar := Trechos;
            DefinirTipoFaixa(PnlFaixaEnviar, PnlFaixaEnviarBarra, SkSvgFaixaEnviar, tfInformacao);
            PnlFaixaEnviar.Visible := True;
            PbxFaixaEnviar.Invalidate;
        end;
    end;

    //Remetente (11.10): só com o e-mail de envio configurado
    LabelRemetente.Visible   := SMTPConfigurado;
    PnlAlterarConfig.Visible := SMTPConfigurado;
    if SMTPConfigurado then
        LabelRemetente.Caption := 'Enviado de ' + Trim(ConfigEmail.Email) + ' ' + #$00B7 + ' ';

    //Sem notas os campos ficam desabilitados (mockup, estado sem notas); durante o envio também
    HabilitarCampo(FCampoPara, TemNotas and (not Bloqueado));
    HabilitarCampo(FCampoMensagemEnviar, TemNotas and (not Bloqueado));
    btnEnviarEmail.Enabled   := TemNotas and SMTPConfigurado and FCampoPara.Valido and (not Bloqueado);
    btnAlterarConfig.Enabled := not Bloqueado;

    AjustarRolagem(FRolagemEnviar);
end;

function TFormPrincipal.AjustarLayoutEnviar: Integer;
var
    Medida        : TBitmap;
    X, Y, W       : Integer;
    Espaco        : Integer;
    Margem        : Integer;
    AlturaTitulo  : Integer;
    AlturaDetalhe : Integer;
    AlturaLegenda : Integer;
    Conteudo      : Integer;
    Interno       : Integer;
    Icone         : Integer;
    AlturaAnexo   : Integer;
    LarguraTexto  : Integer;
    Esquerda      : Integer;
begin
    //Blocos empilhados no quadro (mockup enviar.html): título 32 px, faixa, anexo, Para, Mensagem (72 px),
    //remetente e a linha do Enviar, 12 px entre eles. Devolve a altura do quadro (com a borda)
    Result := 0;
    if (btnEnviarEmail = nil) or (FCampoPara = nil) or (btnAlterarConfig = nil) then
        Exit;

    //Largura pelo quadro (Panel10): antes de a aba aparecer pela primeira vez o painel interno ainda não
    //foi realinhado
    X      := Escalar(PaddingPainelHorizontal);
    W      := Max(1, Panel10.Width - 2 * Escalar(BordaQuadro) - 2 * X);
    Y      := Escalar(PaddingPainelVertical);
    Espaco := Escalar(EspacoFormulario);
    Margem := btnEnviarEmail.MargemFoco;

    Label11.SetBounds(X, Y, W, Escalar(AlturaTituloTela));
    Inc(Y, Escalar(AlturaTituloTela) + Espaco);

    if PnlFaixaEnviar.Visible then
    begin
        PnlFaixaEnviar.SetBounds(X, Y, W, PnlFaixaEnviar.Height);
        //11.20: a pasta é cortada de novo na largura atual da faixa
        if FPastaFaixaEnviar <> '' then
            MontarTrechosSemWinRAR;
        AjustarFaixa(PnlFaixaEnviar, PnlFaixaEnviarBarra, SkSvgFaixaEnviar, PbxFaixaEnviar, FTrechosFaixaEnviar,
                     PaddingFaixaVertical);
        Inc(Y, PnlFaixaEnviar.Height + Espaco);
    end;

    //Anexo: ícone 20 px, 12 px e as duas linhas de texto centralizadas na altura
    Icone   := Escalar(TamanhoIconeMenu);
    Interno := Max(1, W - 2 * Escalar(BordaQuadro) - 2 * Escalar(PaddingAnexoHorizontal) - Icone -
                      Escalar(EspacoIconeAnexo));
    Medida := TBitmap.Create;
    try
        Medida.Canvas.Font.Assign(LabelAnexoTitulo.Font);
        AlturaTitulo := Medida.Canvas.TextHeight('Ag');
    finally
        Medida.Free;
    end;
    AlturaDetalhe := AlturaTextoQuebrado(LabelAnexoDetalhe, Interno);
    Conteudo      := Max(Icone, AlturaTitulo + AlturaDetalhe);
    AlturaAnexo   := 2 * Escalar(BordaQuadro) + 2 * Escalar(PaddingAnexoVertical) + Conteudo;
    PnlAnexo.SetBounds(X, Y, W, AlturaAnexo);
    Esquerda := Escalar(PaddingAnexoHorizontal);
    SkSvgAnexo.SetBounds(Esquerda, Escalar(PaddingAnexoVertical) + (Conteudo - Icone) div 2, Icone, Icone);
    Inc(Esquerda, Icone + Escalar(EspacoIconeAnexo));
    LabelAnexoTitulo.SetBounds(Esquerda, Escalar(PaddingAnexoVertical) + (Conteudo - AlturaTitulo - AlturaDetalhe) div 2,
                               Interno, AlturaTitulo);
    LabelAnexoDetalhe.SetBounds(Esquerda, LabelAnexoTitulo.Top + AlturaTitulo, Interno, AlturaDetalhe);
    Inc(Y, AlturaAnexo + Espaco);

    //Para e Mensagem
    Inc(Y, PosicionarCampo(FCampoPara, Label15, X, Y, W, Escalar(AlturaCampo)) + Espaco);
    Inc(Y, PosicionarCampo(FCampoMensagemEnviar, Label17, X, Y, W, Escalar(AlturaMensagemEnviar)) + Espaco);

    //"Enviado de {e-mail} · alterar em Configurações": legenda e o link logo depois, na mesma linha
    if LabelRemetente.Visible then
    begin
        Medida := TBitmap.Create;
        try
            Medida.Canvas.Font.Assign(LabelRemetente.Font);
            AlturaLegenda := Medida.Canvas.TextHeight('Ag');
            LarguraTexto  := Medida.Canvas.TextWidth(LabelRemetente.Caption);
        finally
            Medida.Free;
        end;
        LabelRemetente.SetBounds(X, Y, Min(LarguraTexto, W), AlturaLegenda);
        PnlAlterarConfig.SetBounds(X + LabelRemetente.Width - btnAlterarConfig.MargemFoco,
                                   Y + (AlturaLegenda - btnAlterarConfig.AlturaIdeal) div 2,
                                   btnAlterarConfig.LarguraIdeal, btnAlterarConfig.AlturaIdeal);
        Inc(Y, AlturaLegenda + Espaco);
    end;

    //Enviar (120 px; "Enviando…" pode precisar de mais) e a legenda 11.14 ao lado, 8 px depois
    Panel11.SetBounds(X - Margem, Y - Margem, Max(Escalar(LarguraBotaoDestaque) + 2 * Margem, btnEnviarEmail.LarguraIdeal),
                      Escalar(AlturaBotao) + 2 * Margem);
    LabelEnviando.SetBounds(Panel11.Left + Panel11.Width - Margem + Escalar(Espaco1), Y,
                            Max(0, X + W - (Panel11.Left + Panel11.Width - Margem + Escalar(Espaco1))),
                            Escalar(AlturaBotao));
    Inc(Y, Escalar(AlturaBotao) + Escalar(PaddingPainelVertical));

    Result := Y + 2 * Escalar(BordaQuadro);
end;

procedure TFormPrincipal.MostrarFaixaEnviar(const Tipo: TTipoFaixa; const Trechos: TTrechosTexto;
  const Resultado: Boolean);
begin
    //Faixa entre o título e o anexo (mockup enviar.html, estados Enviado e Erro). Resultado do envio: fica
    //até sair da tela ou enviar de novo
    FTrechosFaixaEnviar := Trechos;
    FResultadoEnvio     := Resultado;
    DefinirTipoFaixa(PnlFaixaEnviar, PnlFaixaEnviarBarra, SkSvgFaixaEnviar, Tipo);
    PnlFaixaEnviar.Visible := True;
    AjustarRolagem(FRolagemEnviar);
    PbxFaixaEnviar.Invalidate;
end;

procedure TFormPrincipal.MontarTrechosSemWinRAR;
var
    Medida: TBitmap;
begin
    //11.20 com a pasta do ProXML cortada no meio para caber numa linha do texto da faixa (com o ponto final)
    Medida := TBitmap.Create;
    try
        FonteDoTrecho(Medida.Canvas.Font, etrNormal);
        FTrechosFaixaEnviar := nil;
        AdicionarTrecho(FTrechosFaixaEnviar, 'Não foi possível compactar os XMLs.', etrDestaque);
        AdicionarTrecho(FTrechosFaixaEnviar, ' WinRAR não encontrado em ' +
                        EncurtarNoMeio(Medida.Canvas.Font, FPastaFaixaEnviar, LarguraTextoFaixa(PnlFaixaEnviar.ClientWidth) -
                                       Medida.Canvas.TextWidth('.')) + '.', etrNormal);
    finally
        Medida.Free;
    end;
end;

procedure TFormPrincipal.OcultarResultadoEnvio;
begin
    //Saiu da tela Enviar ou enviou de novo: a faixa do último envio some (a 11.19 pode voltar)
    if not FResultadoEnvio then
        Exit;

    FResultadoEnvio := False;
    FTrechosFaixaEnviar := nil;
    FPastaFaixaEnviar := '';
    PnlFaixaEnviar.Hint := '';
    PnlFaixaEnviar.Visible := False;
    AtualizarTelaEnviar;
end;

procedure TFormPrincipal.PbxFaixaEnviarPaint(Sender: TObject);
begin
    DesenharTrechos(PbxFaixaEnviar.Canvas, FTrechosFaixaEnviar, PbxFaixaEnviar.ClientRect, True);
end;

procedure TFormPrincipal.AlterarConfigClick(Sender: TObject);
begin
    //"alterar em Configurações" (11.10): abre a tela Configurações, com o menu sincronizado
    if Bloqueado then
        Exit;
    MostrarTela(tlConfiguracoes);
    if EditSMTP.CanFocus then
        EditSMTP.SetFocus;
end;

{ Tela Configurações (mockup configuracoes.html; glossário 12.1 a 12.25) }

procedure TFormPrincipal.PrepararTelaConfig;
begin
    //Quadro com borda (mockup .panel). Linha 1: Servidor SMTP (resto), Porta (120 px) e Segurança (200 px);
    //linha 2: E-mail (usuário) e Senha, metade cada; linha 3: Mensagem padrão (56 px); embaixo, Testar
    //conexão à esquerda e Salvar à direita. As posições ficam em AjustarLayoutConfig
    PanelCorpoConfig.Color := CorBorda;
    PanelCorpoConfig.Padding.SetBounds(Escalar(BordaQuadro), Escalar(BordaQuadro), Escalar(BordaQuadro),
                                       Escalar(BordaQuadro));
    PnlConfigFundo.Color := CorSuperficie;

    //Título (12.1) e subtítulo (12.2)
    AplicarFonte(Label1.Font, FonteDestaque, TamanhoTituloTela, CorTexto);
    Label1.Layout  := tlCenter;
    Label1.Caption := 'Configurações';
    AplicarFonte(Label2.Font, FonteTexto, TamanhoLegenda, CorTextoSecundario);
    Label2.Layout  := tlCenter;
    Label2.Caption := 'E-mail de envio (SMTP)';

    //Rótulos dos campos (12.3, 12.5, 12.6, 12.10, 12.11 e 12.14): 9 pt Semibold
    AplicarFonte(Label4.Font, FonteDestaque, TamanhoRotuloCampo, CorTexto);
    Label4.Caption := 'Servidor SMTP';
    AplicarFonte(Label7.Font, FonteDestaque, TamanhoRotuloCampo, CorTexto);
    Label7.Caption := 'Porta';
    AplicarFonte(LabelSeguranca.Font, FonteDestaque, TamanhoRotuloCampo, CorTexto);
    LabelSeguranca.Caption := 'Segurança';
    AplicarFonte(Label8.Font, FonteDestaque, TamanhoRotuloCampo, CorTexto);
    Label8.Caption := 'E-mail (usuário)';
    AplicarFonte(Label9.Font, FonteDestaque, TamanhoRotuloCampo, CorTexto);
    Label9.Caption := 'Senha';
    AplicarFonte(Label10.Font, FonteDestaque, TamanhoRotuloCampo, CorTexto);
    Label10.Caption := 'Mensagem padrão do e-mail';

    //Legendas (12.9 e 12.13): 9 pt CorTextoSecundario
    AplicarFonte(LabelAjudaSeguranca.Font, FonteTexto, TamanhoLegenda, CorTextoSecundario);
    LabelAjudaSeguranca.WordWrap := True;
    LabelAjudaSeguranca.Caption  := 'Porta 587 usa TLS; porta 465 usa SSL.';
    AplicarFonte(LabelAjudaSenha.Font, FonteTexto, TamanhoLegenda, CorTextoSecundario);
    LabelAjudaSenha.WordWrap := True;
    LabelAjudaSenha.Caption  := 'No Gmail, use uma senha de app.';

    //Campos (12.4, 12.5, 12.10 e 12.11) com validação de servidor (12.25), porta (12.23) e e-mail (12.24)
    EditSMTP.TextHint  := 'Ex.: smtp.gmail.com';
    EditPorta.TextHint := '587';
    SkSvgEmail.Svg.Source := IconeEmail;
    FCampoServidor := CriarCampo(PnlCampoSMTP, PnlCampoSMTPFundo, nil, EditSMTP, nil, SkSvgErroSMTP, LabelErroSMTP,
                                 ValidarServidor);
    FCampoPorta    := CriarCampo(PnlCampoPorta, PnlCampoPortaFundo, nil, EditPorta, nil, SkSvgErroPorta,
                                 LabelErroPorta, ValidarPorta);
    FCampoEmail    := CriarCampo(PnlCampoEmail, PnlCampoEmailFundo, SkSvgEmail, EditEmail, nil, SkSvgErroEmail,
                                 LabelErroEmail, ValidarEmailRemetente);

    //Senha com o olho à direita (12.12): eye mostra, eye-off oculta
    EditPass.PasswordChar := #$2022;
    SkSvg5.Svg.Source := IconeMostrarSenha;
    SkSvg5.Hint       := 'Mostrar senha';
    SkSvg5.ShowHint   := True;
    SkSvg5.Cursor     := crHandPoint;
    FCampoSenha := CriarCampo(PnlCampoSenha, PnlCampoSenhaFundo, nil, EditPass, SkSvg5, nil, nil, nil);
    FCampoMensagemConfig := CriarCampo(PnlCampoMsg, PnlCampoMsgFundo, nil, MemoMsg, nil, nil, nil, nil);

    //SSL e TLS (12.7 e 12.8; tokens.md 5.4): TCheckBox nativo, 10 pt CorTexto. O nome interno TSL
    //(CheckBoxTSL, TConfig.TSL e a coluna do banco) não muda
    AplicarFonte(CheckBoxSSL.Font, FonteTexto, TamanhoCorpo, CorTexto);
    AplicarFonte(CheckBoxTSL.Font, FonteTexto, TamanhoCorpo, CorTexto);
    CheckBoxSSL.Caption := 'SSL';
    CheckBoxTSL.Caption := 'TLS';

    //Testar conexão (12.19, secundário com plug-zap) e Salvar (12.15, primário com save, 120 px)
    PnlTestarConexao.Color := CorSuperficie;
    Panel9.Color := CorSuperficie;
    btnTestarConexao := TProBotao.CriarEm(PnlTestarConexao, 'Testar conexão', ebSecundario, TestarConexaoClick);
    btnTestarConexao.IconeSvg := IconeTestarConexao;
    btnTestarConexao.Hint     := 'Conectar e autenticar no servidor, sem enviar e-mail';
    btnTestarConexao.ShowHint := True;
    btnSalvarConfig.IconeSvg := IconeSalvar;
    btnSalvarConfig.Hint     := 'Salvar as configurações de e-mail';
    btnSalvarConfig.ShowHint := True;

    //"Conectando a {servidor}:{porta}…" ao lado do Testar conexão (12.20)
    AplicarFonte(LabelTestando.Font, FonteTexto, TamanhoLegenda, CorTextoSecundario);
    LabelTestando.Layout  := tlCenter;
    LabelTestando.Visible := False;

    //"Configurações salvas" (12.16; tokens.md 5.11): check 14 px + 9 pt Semibold CorSucesso, 3 s
    SkSvgConfigSalva.Svg.Source        := IconeConfirmar;
    SkSvgConfigSalva.Svg.OverrideColor := CorAlpha(CorSucesso);
    SkSvgConfigSalva.Visible := False;
    AplicarFonte(LabelConfigSalva.Font, FonteDestaque, TamanhoLegenda, CorSucesso);
    LabelConfigSalva.Layout  := tlCenter;
    LabelConfigSalva.Caption := 'Configurações salvas';
    LabelConfigSalva.Visible := False;
    TimerConfigSalva.Enabled  := False;
    TimerConfigSalva.Interval := DuracaoConfigSalvaMs;
    TimerConfigSalva.OnTimer  := TimerConfigSalvaTimer;

    //Resultado do Testar conexão (12.21 e 12.22) numa faixa abaixo do título
    DefinirTipoFaixa(PnlFaixaConfig, PnlFaixaConfigBarra, SkSvgFaixaConfig, tfSucesso);
    PbxFaixaConfig.OnPaint := PbxFaixaConfigPaint;
    PnlFaixaConfig.Visible := False;

    //Limite de 15 s do Testar conexão (cronômetro da tela)
    TimerTesteConexao.Enabled  := False;
    TimerTesteConexao.Interval := TEMPO_LIMITE_TESTE_MS;
    TimerTesteConexao.OnTimer  := TimerTesteConexaoTimer;
    FTestesEncerrados := TList.Create;
end;

procedure TFormPrincipal.CarregarConfigNaTela;
var
    I: Integer;
begin
    //Valores salvos no banco (TConfig). Os campos começam sem mensagem de erro
    EditSMTP.Text       := ConfigEmail.SMTP;
    EditPorta.Text      := ConfigEmail.Porta;
    EditEmail.Text      := ConfigEmail.Email;
    EditPass.Text       := ConfigEmail.Senha;
    MemoMsg.Text        := ConfigEmail.Mensagem;
    CheckBoxSSL.Checked := ConfigEmail.SSL;
    CheckBoxTSL.Checked := ConfigEmail.TSL;
    for I := 0 to High(FCampos) do
        if FCampos[I].Borda.Parent = PnlConfigFundo then
        begin
            FCampos[I].Validando := False;
            ValidarCampo(FCampos[I]);
        end;
    AtualizarEstadoConfig;
end;

procedure TFormPrincipal.AtualizarEstadoConfig;
var
    Livre: Boolean;
begin
    //Durante o Testar conexão: campos, caixas, olho e Salvar bloqueados (mockup, estado testando). Salvar
    //habilitado só com servidor, porta (1 a 65535) e e-mail válidos (decisão de 26/10/2026)
    if (btnTestarConexao = nil) or (btnSalvarConfig = nil) or (FCampoServidor = nil) then
        Exit;

    Livre := not FTestando;
    HabilitarCampo(FCampoServidor, Livre);
    HabilitarCampo(FCampoPorta, Livre);
    HabilitarCampo(FCampoEmail, Livre);
    HabilitarCampo(FCampoSenha, Livre);
    HabilitarCampo(FCampoMensagemConfig, Livre);
    CheckBoxSSL.Enabled := Livre;
    CheckBoxTSL.Enabled := Livre;

    btnSalvarConfig.Enabled  := Livre and (not Bloqueado) and FCampoServidor.Valido and FCampoPorta.Valido and
                                FCampoEmail.Valido;
    btnTestarConexao.Enabled := not Bloqueado;
    LabelTestando.Visible    := FTestando;

    AjustarRolagem(FRolagemConfig);
end;

function TFormPrincipal.AjustarLayoutConfig: Integer;
var
    Medida         : TBitmap;
    X, Y, W        : Integer;
    Espaco         : Integer;
    Coluna         : Integer;
    Margem         : Integer;
    LarguraPorta   : Integer;
    LarguraSeg     : Integer;
    LarguraServ    : Integer;
    LarguraMetade  : Integer;
    XSeg           : Integer;
    X2             : Integer;
    AlturaRotulo   : Integer;
    AlturaCaixa    : Integer;
    AlturaLinha    : Integer;
    Altura         : Integer;
    LarguraTexto   : Integer;
    Caixa          : Integer;
begin
    //Formulário em grade (mockup configuracoes.html): colunas com 16 px entre elas e linhas com 12 px.
    //Devolve a altura do quadro (com a borda)
    Result := 0;
    if (btnTestarConexao = nil) or (btnSalvarConfig = nil) or (FCampoServidor = nil) then
        Exit;

    //Largura pelo quadro (PanelCorpoConfig), como em AjustarLayoutEnviar
    X      := Escalar(PaddingPainelHorizontal);
    W      := Max(1, PanelCorpoConfig.Width - 2 * Escalar(BordaQuadro) - 2 * X);
    Y      := Escalar(PaddingPainelVertical);
    Espaco := Escalar(EspacoFormulario);
    Coluna := Escalar(EspacoColunasFormulario);
    Margem := btnSalvarConfig.MargemFoco;

    //Título e subtítulo na mesma linha de 32 px, 16 px entre eles (mockup; revisão da 4.9, A7)
    Medida := TBitmap.Create;
    try
        Medida.Canvas.Font.Assign(Label1.Font);
        LarguraTexto := Medida.Canvas.TextWidth(Label1.Caption);
        Label1.SetBounds(X, Y, LarguraTexto, Escalar(AlturaTituloTela));
        Medida.Canvas.Font.Assign(Label2.Font);
        Label2.SetBounds(X + LarguraTexto + Escalar(Espaco2), Y, Medida.Canvas.TextWidth(Label2.Caption),
                         Escalar(AlturaTituloTela));
        Medida.Canvas.Font.Assign(LabelSeguranca.Font);
        AlturaRotulo := Medida.Canvas.TextHeight('Ag');
        Medida.Canvas.Font.Assign(CheckBoxSSL.Font);
        AlturaCaixa := Max(Medida.Canvas.TextHeight('Ag'), Escalar(TamanhoIconePequeno));
        //Caixa do Windows (13 px a 100%) + 4 px + texto
        Caixa := MulDiv(GetSystemMetrics(SM_CXMENUCHECK), PPIAtual, Screen.PixelsPerInch) + Escalar(EspacoMeio) +
                 Escalar(EspacoMeio);
        CheckBoxSSL.Width := Caixa + Medida.Canvas.TextWidth(CheckBoxSSL.Caption);
        CheckBoxTSL.Width := Caixa + Medida.Canvas.TextWidth(CheckBoxTSL.Caption);
    finally
        Medida.Free;
    end;
    Inc(Y, Escalar(AlturaTituloTela) + Espaco);

    if PnlFaixaConfig.Visible then
    begin
        PnlFaixaConfig.SetBounds(X, Y, W, PnlFaixaConfig.Height);
        AjustarFaixa(PnlFaixaConfig, PnlFaixaConfigBarra, SkSvgFaixaConfig, PbxFaixaConfig, FTrechosFaixaConfig,
                     PaddingFaixaVertical);
        Inc(Y, PnlFaixaConfig.Height + Espaco);
    end;

    //Linha 1: Servidor SMTP | Porta | Segurança (SSL e TLS numa linha de 32 px e a legenda 12.9 embaixo)
    LarguraPorta := Escalar(LarguraCampoPorta);
    LarguraSeg   := Escalar(LarguraColunaSeguranca);
    LarguraServ  := Max(1, W - LarguraPorta - LarguraSeg - 2 * Coluna);
    AlturaLinha  := PosicionarCampo(FCampoServidor, Label4, X, Y, LarguraServ, Escalar(AlturaCampo));
    AlturaLinha  := Max(AlturaLinha, PosicionarCampo(FCampoPorta, Label7, X + LarguraServ + Coluna, Y, LarguraPorta,
                                                     Escalar(AlturaCampo)));
    XSeg := X + LarguraServ + Coluna + LarguraPorta + Coluna;
    LabelSeguranca.SetBounds(XSeg, Y, LarguraSeg, AlturaRotulo);
    Altura := AlturaRotulo + Escalar(EspacoMeio);
    CheckBoxSSL.SetBounds(XSeg, Y + Altura + (Escalar(AlturaCampo) - AlturaCaixa) div 2, CheckBoxSSL.Width, AlturaCaixa);
    CheckBoxTSL.SetBounds(XSeg + CheckBoxSSL.Width + Escalar(EspacoCaixasSelecao), CheckBoxSSL.Top, CheckBoxTSL.Width,
                          AlturaCaixa);
    Inc(Altura, Escalar(AlturaCampo) + Escalar(EspacoMeio));
    Inc(Altura, PosicionarLegenda(LabelAjudaSeguranca, XSeg, Y + Altura, LarguraSeg));
    AlturaLinha := Max(AlturaLinha, Altura);
    Inc(Y, AlturaLinha + Espaco);

    //Linha 2: E-mail (usuário) | Senha (com a legenda 12.13 embaixo)
    LarguraMetade := Max(1, (W - Coluna) div 2);
    X2 := X + LarguraMetade + Coluna;
    AlturaLinha := PosicionarCampo(FCampoEmail, Label8, X, Y, LarguraMetade, Escalar(AlturaCampo));
    Altura := PosicionarCampo(FCampoSenha, Label9, X2, Y, Max(1, X + W - X2), Escalar(AlturaCampo));
    Inc(Altura, Escalar(EspacoMeio));
    Inc(Altura, PosicionarLegenda(LabelAjudaSenha, X2, Y + Altura, Max(1, X + W - X2)));
    AlturaLinha := Max(AlturaLinha, Altura);
    Inc(Y, AlturaLinha + Espaco);

    //Linha 3: Mensagem padrão do e-mail, largura inteira
    Inc(Y, PosicionarCampo(FCampoMensagemConfig, Label10, X, Y, W, Escalar(AlturaMensagemConfig)) + Espaco +
           Escalar(EspacoAcoesFormulario));

    //Botões: Testar conexão (e a legenda 12.20) à esquerda; "Configurações salvas" e Salvar (120 px) à direita
    PnlTestarConexao.SetBounds(X - Margem, Y - Margem, btnTestarConexao.LarguraIdeal, Escalar(AlturaBotao) + 2 * Margem);
    Panel9.Width := Max(Escalar(LarguraBotaoDestaque) + 2 * Margem, btnSalvarConfig.LarguraIdeal);
    Panel9.SetBounds(X + W + Margem - Panel9.Width, Y - Margem, Panel9.Width, Escalar(AlturaBotao) + 2 * Margem);
    Medida := TBitmap.Create;
    try
        Medida.Canvas.Font.Assign(LabelConfigSalva.Font);
        LarguraTexto := Medida.Canvas.TextWidth(LabelConfigSalva.Caption);
    finally
        Medida.Free;
    end;
    LabelConfigSalva.SetBounds(Panel9.Left + Margem - Escalar(Espaco1) - LarguraTexto, Y, LarguraTexto,
                               Escalar(AlturaBotao));
    SkSvgConfigSalva.SetBounds(LabelConfigSalva.Left - Escalar(EspacoMeio) - Escalar(TamanhoIconeDica),
                               Y + (Escalar(AlturaBotao) - Escalar(TamanhoIconeDica)) div 2,
                               Escalar(TamanhoIconeDica), Escalar(TamanhoIconeDica));
    LabelTestando.SetBounds(PnlTestarConexao.Left + PnlTestarConexao.Width - Margem + Escalar(Espaco1), Y,
                            Max(0, SkSvgConfigSalva.Left - Escalar(Espaco1) -
                                   (PnlTestarConexao.Left + PnlTestarConexao.Width - Margem + Escalar(Espaco1))),
                            Escalar(AlturaBotao));
    Inc(Y, Escalar(AlturaBotao) + Escalar(PaddingPainelVertical));

    Result := Y + 2 * Escalar(BordaQuadro);
end;

procedure TFormPrincipal.MostrarFaixaConfig(const Tipo: TTipoFaixa; const Trechos: TTrechosTexto);
begin
    //Resultado do Testar conexão entre o título e o formulário (mockup, estados Conexão OK e falhou)
    FTrechosFaixaConfig := Trechos;
    DefinirTipoFaixa(PnlFaixaConfig, PnlFaixaConfigBarra, SkSvgFaixaConfig, Tipo);
    PnlFaixaConfig.Visible := True;
    AjustarRolagem(FRolagemConfig);
    PbxFaixaConfig.Invalidate;
end;

procedure TFormPrincipal.OcultarFaixaConfig;
begin
    if (PnlFaixaConfig = nil) or (not PnlFaixaConfig.Visible) then
        Exit;
    PnlFaixaConfig.Visible := False;
    FTrechosFaixaConfig := nil;
    AjustarRolagem(FRolagemConfig);
end;

procedure TFormPrincipal.PbxFaixaConfigPaint(Sender: TObject);
begin
    DesenharTrechos(PbxFaixaConfig.Canvas, FTrechosFaixaConfig, PbxFaixaConfig.ClientRect, True);
end;

procedure TFormPrincipal.TimerConfigSalvaTimer(Sender: TObject);
begin
    //"Configurações salvas" some depois de 3 s
    TimerConfigSalva.Enabled := False;
    SkSvgConfigSalva.Visible := False;
    LabelConfigSalva.Visible := False;
end;

{ Testar conexão (PD-4; glossário 12.19 a 12.22) }

procedure TFormPrincipal.TestarConexaoClick(Sender: TObject);
var
    Campos   : array[0..2] of TCampoFormulario;
    Primeiro : TCampoFormulario;
    I        : Integer;
begin
    //Usa os dados digitados na tela, sem salvar (decisão de 26/10/2026). Servidor, porta ou e-mail
    //inválidos: as mensagens dos campos aparecem e o teste não começa
    if FTestando or Bloqueado then
        Exit;

    Campos[0] := FCampoServidor;
    Campos[1] := FCampoPorta;
    Campos[2] := FCampoEmail;
    Primeiro  := nil;
    for I := Low(Campos) to High(Campos) do
        if not Campos[I].Valido then
        begin
            Campos[I].Validando := True;
            ValidarCampo(Campos[I]);
            if Primeiro = nil then
                Primeiro := Campos[I];
        end;

    if Primeiro <> nil then
    begin
        AtualizarEstadoConfig;
        if Primeiro.Edit.CanFocus then
            Primeiro.Edit.SetFocus;
        Exit;
    end;

    IniciarTesteConexao;
end;

procedure TFormPrincipal.IniciarTesteConexao;
var
    Teste    : TThreadTesteSMTP;
    Servidor : string;
    Porta    : string;
begin
    //Thread própria (TThreadTesteSMTP): a tela continua respondendo. "Testando…" com loader-circle
    //estático, a legenda 12.20, campos e Salvar bloqueados e o menu, a barra de pasta e o "Sobre"
    //bloqueados como no envio (tokens.md 5.13). O cronômetro de 15 s fecha o teste sem resposta
    LiberarThreadsTeste(False);
    OcultarFaixaConfig;

    Servidor := Trim(EditSMTP.Text);
    Porta    := Trim(EditPorta.Text);
    Teste := TThreadTesteSMTP.Create(Servidor, Porta, Trim(EditEmail.Text), Trim(EditPass.Text),
                                     CheckBoxSSL.Checked, CheckBoxTSL.Checked);
    Teste.OnTerminate := TesteConexaoTerminado;

    FTeste    := Teste;
    FTestando := True;
    btnTestarConexao.Caption  := 'Testando' + #$2026;
    btnTestarConexao.IconeSvg := IconeOcupado;
    LabelTestando.Caption     := 'Conectando a ' + Servidor + ':' + Porta + #$2026;
    DefinirBloqueio(blTeste, True);
    TimerTesteConexao.Enabled := False;
    TimerTesteConexao.Enabled := True;
    try
        Teste.Start;
    except
        FTeste := nil;
        Teste.Free;
        EncerrarTesteConexao;
        raise;
    end;
end;

procedure TFormPrincipal.EncerrarTesteConexao;
begin
    //Fim do teste (resposta, limite de 15 s ou erro ao iniciar): tudo volta como antes
    TimerTesteConexao.Enabled := False;
    FTestando := False;
    btnTestarConexao.Caption  := 'Testar conexão';
    btnTestarConexao.IconeSvg := IconeTestarConexao;
    LabelTestando.Visible     := False;
    DefinirBloqueio(blTeste, False);
end;

procedure TFormPrincipal.TesteConexaoTerminado(Sender: TObject);
var
    Teste   : TThreadTesteSMTP;
    Trechos : TTrechosTexto;
begin
    //OnTerminate da thread do teste: roda na thread principal; nenhuma exceção sai daqui. Teste que já
    //passou do limite de 15 s (a tela já mostrou "não respondeu") ou fim do app: nada muda na tela
    try
        Teste := Sender as TThreadTesteSMTP;
        if FFechando or (Sender <> FTeste) or Teste.Abortado then
            Exit;

        EncerrarTesteConexao;

        Trechos := nil;
        if Teste.Conectou then
        begin
            //12.21
            AdicionarTrecho(Trechos, 'Conexão OK.', etrDestaque);
            AdicionarTrecho(Trechos, ' O servidor ' + Teste.Servidor + ':' + Teste.Porta + ' aceitou o usuário e a ' +
                                     'senha. Nenhum e-mail foi enviado.', etrNormal);
            MostrarFaixaConfig(tfSucesso, Trechos);
        end
        else
        begin
            //12.22: com resposta do servidor, o motivo; sem resposta, "não respondeu"
            if Teste.SemAutenticacao then
            begin
                //12.22a: o servidor não pediu usuário e senha nesta conexão
                AdicionarTrecho(Trechos, 'Não foi possível autenticar.', etrDestaque);
                AdicionarTrecho(Trechos, ' O servidor ' + Teste.Servidor + ':' + Teste.Porta + ' não pediu usuário ' +
                                         'e senha nesta conexão. Confira a porta e as opções SSL e TLS.', etrNormal);
                MostrarFaixaConfig(tfErro, Trechos);
                if btnTestarConexao.CanFocus then
                    btnTestarConexao.SetFocus;
                Exit;
            end;

            AdicionarTrecho(Trechos, 'Não foi possível conectar.', etrDestaque);
            if Teste.Respondeu then
                AdicionarTrecho(Trechos, 'O servidor respondeu: ' + MotivoNumaLinha(Teste.Motivo), etrNormal, True)
            else
                AdicionarTrecho(Trechos, 'O servidor ' + Teste.Servidor + ':' + Teste.Porta + ' não respondeu. Confira ' +
                                         'o endereço, a porta e a conexão com a internet.', etrNormal, True);
            MostrarFaixaConfig(tfErro, Trechos);
        end;

        if btnTestarConexao.CanFocus then
            btnTestarConexao.SetFocus;
    except
        on E: Exception do
            CaixaMensagem(E.Message, mtError);
    end;
end;

procedure TFormPrincipal.TimerTesteConexaoTimer(Sender: TObject);
var
    Teste   : TThreadTesteSMTP;
    Trechos : TTrechosTexto;
begin
    //15 s sem resposta (glossário 12.22, "não respondeu"): o teste é abortado (o socket é fechado) e a tela
    //volta na hora. A thread termina sozinha e é liberada depois (LiberarThreadsTeste)
    TimerTesteConexao.Enabled := False;
    if (not FTestando) or (FTeste = nil) then
        Exit;

    Teste := TThreadTesteSMTP(FTeste);
    Teste.Abortar;
    FTestesEncerrados.Add(Teste);
    FTeste := nil;
    EncerrarTesteConexao;

    Trechos := nil;
    AdicionarTrecho(Trechos, 'Não foi possível conectar.', etrDestaque);
    AdicionarTrecho(Trechos, 'O servidor ' + Teste.Servidor + ':' + Teste.Porta + ' não respondeu. Confira o ' +
                             'endereço, a porta e a conexão com a internet.', etrNormal, True);
    MostrarFaixaConfig(tfErro, Trechos);
    if btnTestarConexao.CanFocus then
        btnTestarConexao.SetFocus;
end;

procedure TFormPrincipal.LiberarThreadsTeste(const Fechando: Boolean);
var
    Teste : TThreadTesteSMTP;
    I     : Integer;
begin
    //Teste anterior que já terminou: falta liberar o objeto. Testes abortados pelo limite de 15 s são
    //liberados quando a thread terminar. No fim do app (Fechando) tudo é abortado e esperado aqui
    if (FTeste <> nil) and (Fechando or (not FTestando)) then
    begin
        Teste := TThreadTesteSMTP(FTeste);
        if Fechando then
        begin
            Teste.OnTerminate := nil;
            Teste.Abortar;
        end;
        Teste.WaitFor;
        FreeAndNil(FTeste);
    end;

    if FTestesEncerrados = nil then
        Exit;
    for I := FTestesEncerrados.Count - 1 downto 0 do
    begin
        Teste := TThreadTesteSMTP(FTestesEncerrados[I]);
        if Fechando then
        begin
            Teste.OnTerminate := nil;
            Teste.Abortar;
        end;
        if Fechando or Teste.Finished then
        begin
            Teste.WaitFor;
            Teste.Free;
            FTestesEncerrados.Delete(I);
        end;
    end;
end;

{ Tela Sobre (mockup sobre.html; glossário 13.1 a 13.6) }

function TFormPrincipal.VersaoDoExecutavel: string;
var
    Tamanho : DWORD;
    Ignorar : DWORD;
    Dados   : TBytes;
    Info    : PVSFixedFileInfo;
    Largura : UINT;
begin
    //VersionInfo do executável (o mesmo do .dproj), no formato "1.1.0" (maior.menor.revisão). Sem
    //VersionInfo: vazio
    Result  := '';
    Tamanho := GetFileVersionInfoSize(PChar(ParamStr(0)), Ignorar);
    if Tamanho = 0 then
        Exit;

    SetLength(Dados, Tamanho);
    if GetFileVersionInfo(PChar(ParamStr(0)), 0, Tamanho, @Dados[0]) and
       VerQueryValue(@Dados[0], '\', Pointer(Info), Largura) and (Largura >= SizeOf(TVSFixedFileInfo)) then
        Result := IntToStr(HiWord(Info^.dwFileVersionMS)) + '.' + IntToStr(LoWord(Info^.dwFileVersionMS)) + '.' +
                  IntToStr(HiWord(Info^.dwFileVersionLS));
end;

procedure TFormPrincipal.PrepararTelaSobre;
var
    Versao: string;
begin
    //Quadro com borda (mockup .panel.sobre) e o conteúdo centralizado: logo claro vetorial (216 x 44, no
    //.dfm), "ProXML v{versão}" 14 pt Semibold, descrição 10 pt CorTextoSecundario, autor 10 pt, link do
    //GitHub (external-link) e os créditos 9 pt. As posições ficam em AjustarLayoutSobre
    PnlTelaSobre.Color := CorBorda;
    PnlTelaSobre.Padding.SetBounds(Escalar(BordaQuadro), Escalar(BordaQuadro), Escalar(BordaQuadro), Escalar(BordaQuadro));
    PnlTelaSobreFundo.Color    := CorSuperficie;
    PnlTelaSobreFundo.OnResize := PnlTelaSobreFundoResize;

    //13.1: versão lida do VersionInfo, nunca escrita no código
    Versao := VersaoDoExecutavel;
    AplicarFonte(LabelSobreVersao.Font, FonteDestaque, TamanhoTituloTela, CorTexto);
    if Versao <> '' then
        LabelSobreVersao.Caption := 'ProXML v' + Versao
    else
        LabelSobreVersao.Caption := 'ProXML';

    AplicarFonte(LabelSobreDescricao.Font, FonteTexto, TamanhoCorpo, CorTextoSecundario);
    LabelSobreDescricao.Caption := 'Totalizador de XMLs de NF-e (55) e NFC-e (65) com IBS/CBS, DANFE e relatórios.';
    AplicarFonte(LabelSobreAutor.Font, FonteTexto, TamanhoCorpo, CorTexto);
    LabelSobreAutor.Caption := 'Desenvolvido por Caique Garcia';
    AplicarFonte(LabelSobreCreditos.Font, FonteTexto, TamanhoLegenda, CorTextoSecundario);
    LabelSobreCreditos.Caption := 'Ícones: Lucide (licença ISC) ' + #$00B7 + ' Componentes: ACBr, Skia4Delphi';

    //13.4 e 13.5: link que abre o navegador
    PnlSobreLink.Color := CorSuperficie;
    btnLinkGitHub := TProBotao.CriarEm(PnlSobreLink, TEXTO_GITHUB, ebLink, LinkGitHubClick);
    AplicarFonte(btnLinkGitHub.Font, FonteTexto, TamanhoCorpo, CorPrimaria);
    btnLinkGitHub.IconeSvg := IconeLinkExterno;
    btnLinkGitHub.Hint     := 'Abrir no navegador';
    btnLinkGitHub.ShowHint := True;
end;

procedure TFormPrincipal.AjustarLayoutSobre;
var
    Medida        : TBitmap;
    W, H          : Integer;
    Largura       : Integer;
    Espaco        : Integer;
    AlturaVersao  : Integer;
    AlturaDescr   : Integer;
    AlturaAutor   : Integer;
    AlturaLink    : Integer;
    AlturaCredito : Integer;
    Total         : Integer;
    Topo          : Integer;
begin
    //Coluna centralizada na largura e na altura do quadro (mockup .sobre: gap 8; logo com 8 px em cima e
    //embaixo e mais 8 de margem; autor com mais 8 em cima; créditos com mais 16 em cima)
    if btnLinkGitHub = nil then
        Exit;

    W       := PnlTelaSobreFundo.ClientWidth;
    H       := PnlTelaSobreFundo.ClientHeight;
    Largura := Max(1, W - 2 * Escalar(PaddingPainelHorizontal));
    Espaco  := Escalar(EspacoSobre);

    Medida := TBitmap.Create;
    try
        Medida.Canvas.Font.Assign(LabelSobreVersao.Font);
        AlturaVersao := Medida.Canvas.TextHeight('Ag');
        Medida.Canvas.Font.Assign(LabelSobreAutor.Font);
        AlturaAutor := Medida.Canvas.TextHeight('Ag');
    finally
        Medida.Free;
    end;
    AlturaDescr   := AlturaTextoQuebrado(LabelSobreDescricao, Largura);
    AlturaCredito := AlturaTextoQuebrado(LabelSobreCreditos, Largura);
    AlturaLink    := btnLinkGitHub.AlturaIdeal - 2 * btnLinkGitHub.MargemFoco;

    Total := 2 * Escalar(PaddingLogoSobre) + Escalar(AlturaLogoSobre) + Escalar(PaddingLogoSobre) + Espaco +
             AlturaVersao + Espaco + AlturaDescr + Espaco + Escalar(EspacoAutorSobre) + AlturaAutor + Espaco +
             AlturaLink + Espaco + Escalar(EspacoCreditosSobre) + AlturaCredito;
    Topo := Max(0, (H - Total) div 2);

    Inc(Topo, Escalar(PaddingLogoSobre));
    SkSvgSobreLogo.SetBounds((W - Escalar(LarguraLogoSobre)) div 2, Topo, Escalar(LarguraLogoSobre),
                             Escalar(AlturaLogoSobre));
    Inc(Topo, Escalar(AlturaLogoSobre) + 2 * Escalar(PaddingLogoSobre) + Espaco);
    LabelSobreVersao.SetBounds((W - Largura) div 2, Topo, Largura, AlturaVersao);
    Inc(Topo, AlturaVersao + Espaco);
    LabelSobreDescricao.SetBounds((W - Largura) div 2, Topo, Largura, AlturaDescr);
    Inc(Topo, AlturaDescr + Espaco + Escalar(EspacoAutorSobre));
    LabelSobreAutor.SetBounds((W - Largura) div 2, Topo, Largura, AlturaAutor);
    Inc(Topo, AlturaAutor + Espaco);
    PnlSobreLink.SetBounds((W - btnLinkGitHub.LarguraIdeal) div 2, Topo - btnLinkGitHub.MargemFoco,
                           btnLinkGitHub.LarguraIdeal, btnLinkGitHub.AlturaIdeal);
    Inc(Topo, AlturaLink + Espaco + Escalar(EspacoCreditosSobre));
    LabelSobreCreditos.SetBounds((W - Largura) div 2, Topo, Largura, AlturaCredito);
end;

procedure TFormPrincipal.PnlTelaSobreFundoResize(Sender: TObject);
begin
    AjustarLayoutSobre;
end;

procedure TFormPrincipal.SobreClick(Sender: TObject);
begin
    //"Sobre" do cabeçalho (glossário 1.3): abre a tela Sobre, sem item ativo no menu e sem os cards (D2).
    //Bloqueado durante a leitura, o envio, o teste de conexão e a tela Carregando (tokens.md 5.13)
    if Bloqueado then
        Exit;
    MostrarTela(tlSobre);
end;

procedure TFormPrincipal.LinkGitHubClick(Sender: TObject);
begin
    //13.4: abre o repositório no navegador padrão
    ShellExecute(Handle, 'open', PChar(URL_GITHUB), nil, nil, SW_SHOWNORMAL);
end;

procedure TFormPrincipal.AtualizarVisualSobre;
begin
    //"Sobre" do cabeçalho: CorMarinhoTexto; com a tela Sobre aberta, branco com a linha de 2 px
    //CorPrimaria embaixo (mockup .hlink.on); bloqueado, CorTextoDesabilitado (decisão da 4.6)
    if (LabelSobre = nil) or (PnlSobreAtivo = nil) then
        Exit;

    if not PnlSobre.Enabled then
    begin
        LabelSobre.Font.Color := CorTextoDesabilitado;
        SkSvgSobre.Svg.OverrideColor := CorAlpha(CorTextoDesabilitado);
        PnlSobreAtivo.Visible := False;
    end
    else if PageControl1.ActivePage = TelaSobre then
    begin
        LabelSobre.Font.Color := CorTextoSobreMarinho;
        SkSvgSobre.Svg.OverrideColor := CorAlpha(CorTextoSobreMarinho);
        PnlSobreAtivo.Visible := True;
    end
    else
    begin
        LabelSobre.Font.Color := CorMarinhoTexto;
        SkSvgSobre.Svg.OverrideColor := CorAlpha(CorMarinhoTexto);
        PnlSobreAtivo.Visible := False;
    end;
end;

end.
