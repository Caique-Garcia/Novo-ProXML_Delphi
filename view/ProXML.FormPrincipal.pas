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
  Vcl.CategoryButtons,
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
  ProXML.Tema;

type
  //Relatório aberto depois de gravar as notas no banco (GravarNotasDB)
  TTipoRelatorio = (trNotas, trIBSCBS);

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
    PanelMenus: TPanel;
    CategoryButtons1: TCategoryButtons;
    Panel8: TPanel;
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
    procedure SelecionarPastaClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CategoryButtons1Categories0Items0Click(Sender: TObject);
    procedure CategoryButtons1Categories0Items1Click(Sender: TObject);
    procedure GerarPDF1Click(Sender: TObject);
    procedure CategoryButtons1Categories0Items2Click(Sender: TObject);
    procedure GravarNotasDB(const Relatorio: TTipoRelatorio);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CategoryButtons1Categories0Items3Click(Sender: TObject);
    procedure GerarDANFe1Click(Sender: TObject);
    procedure CategoryButtons1Categories0Items4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSalvarConfigClick(Sender: TObject);
    procedure SkSvg5Click(Sender: TObject);
    procedure btnEnviarEmailClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SeletorModeloChange(Sender: TObject);
    procedure CategoryButtons1RelatorioIBSCBSClick(Sender: TObject);
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
    procedure SetTextoTranferencia(const Text: String);
    procedure AjustarAlturaLinhasGrade;
    procedure GerarRelatorio(const Relatorio: TTipoRelatorio);
    procedure FinalizaRelatorio(const Relatorio: TTipoRelatorio);
    procedure AbrirRelatorioIBSCBS;
    function  DescricaoFiltroModelo: string;
    procedure ConfigACBR;
    procedure GerarDanfe(const CaminhoArq: String);
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
        messagedlg('Configuração salva com sucesso !!', mtInformation	, [mbOk], 0);
        PageControl1.ActivePageIndex := 0;
    except
    end;
end;

procedure TFormPrincipal.CategoryButtons1Categories0Items0Click(
  Sender: TObject);
begin
   PageControl1.ActivePageIndex := 0;
end;

procedure TFormPrincipal.CategoryButtons1Categories0Items1Click(
  Sender: TObject);
begin
   PageControl1.ActivePageIndex := 1;
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
        //Relatório fechado: volta para a aba Notas
        PageControl1.ActivePageIndex := 1;
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
            //Nenhuma nota do filtro atual tem IBS/CBS: não abre a visualização
            PageControl1.ActivePageIndex := 1;
            messagedlg('Nenhuma nota com IBS/CBS', mtInformation, [mbOk], 0);
        end;

        //Relatório fechado: volta para a aba Notas
        PageControl1.ActivePageIndex := 1;
    finally
        FreeAndNil(FormIBSCBS);
    end;
end;

procedure TFormPrincipal.GerarRelatorio(const Relatorio: TTipoRelatorio);
begin
    //Confere se a grade (filtrada) tem notas, grava no banco e abre o relatório escolhido
    if DataSource1.DataSet.RecordCount <= 0 then
    begin
       messagedlg('Sem dados para gerar relatório !!', mtInformation	, [mbOk], 0);
       Exit;
    end
    else
        GravarNotasDB(Relatorio);
end;

procedure TFormPrincipal.CategoryButtons1Categories0Items2Click(
  Sender: TObject);
begin
    //Geração de relatóeio
    GerarRelatorio(trNotas);
end;

procedure TFormPrincipal.CategoryButtons1RelatorioIBSCBSClick(
  Sender: TObject);
begin
    //Relatório IBS/CBS (item do menu lateral logo abaixo de "Relatório")
    GerarRelatorio(trIBSCBS);
end;

procedure TFormPrincipal.CategoryButtons1Categories0Items3Click(
  Sender: TObject);
begin
    //PageControl1.ActivePageIndex := 2;
    //SkAnimatedImage1.Animation.Start;
    //Só abre a aba e carrega a configuração do email: os XMLs são separados e
    //compactados no clique em "Enviar Email" (btnEnviarEmailClick)
    LerConfigEmail();
    PageControl1.ActivePageIndex := 3;
end;

procedure TFormPrincipal.CategoryButtons1Categories0Items4Click(
  Sender: TObject);
begin
  //Configurações
  try
    PageControl1.ActivePageIndex := 4;
  except
  end;
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

   try
    PageControl1.ActivePageIndex := 0;
   except
   end;

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

procedure TFormPrincipal.GerarDanfe(const CaminhoArq: String);
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
    try
        PageControl1.ActivePageIndex := 2;
        //SkAnimatedImage1.Animation.Start;

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
                PageControl1.ActivePageIndex := 1;
                messagedlg('Não foi possível carregar o XML da nota:' + sLineBreak + CaminhoArq + sLineBreak +
                           sLineBreak + E.Message, mtError, [mbOk], 0);
                Exit;
            end;
        end;

        //Escolhe o layout pelo modelo e pelo tpImp da nota
        if not ConfigurarLayoutDanfe(Mensagem) then
        begin
            PageControl1.ActivePageIndex := 1;
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
                PageControl1.ActivePageIndex := 1;
                messagedlg('Erro ao gerar o DANFE:' + sLineBreak + sLineBreak + E.Message, mtError, [mbOk], 0);
                Exit;
            end;
        end;

        if not AguardarArquivoPDF(CaminhosPDF, CaminhoGerado) then
        begin
            if Application.Terminated then
                Exit;

            DMConfig.CreateLog('GerarDanfe', 'PDF do DANFE não gerado: ' + CaminhoArq);
            PageControl1.ActivePageIndex := 1;
            messagedlg('O PDF do DANFE não foi gerado em ' + IntToStr(TEMPO_LIMITE_PDF_MS div 1000) +
                       ' segundos.' + sLineBreak + sLineBreak + 'Pasta esperada: ' + ACBrNFe.DANFE.PathPDF,
                       mtError, [mbOk], 0);
            Exit;
        end;

        ShellExecute(0, 'open', PChar(CaminhoGerado), nil, nil, SW_SHOWNORMAL);
        PageControl1.ActivePageIndex := 1;
    finally
        GerarDANFe1.Enabled := True;
        FGerandoDanfe := False;
    end;
end;

procedure TFormPrincipal.GerarDANFe1Click(Sender: TObject);
begin
  if DBGrid1.DataSource.DataSet.IsEmpty then
    Exit;

  GerarDanfe(DBGrid1.DataSource.DataSet.FieldByName('xml').AsString);
end;

procedure TFormPrincipal.GerarPDF1Click(Sender: TObject);
begin
   SetTextoTranferencia(DBGrid1.DataSource.DataSet.FieldByName('chave').Value);
end;

procedure TFormPrincipal.GravarNotasDB(const Relatorio: TTipoRelatorio);
begin
  //Grava as notas no banco de dados SQLite e abre o relatório escolhido (notas ou IBS/CBS).
  //A gravação roda na thread principal, numa transação: a conexão DMConfig.Conexao também
  //é usada pela tela e o FireDAC não permite usar a mesma conexão em duas threads ao mesmo tempo.

  if not FDMemTable1.Active then
    FDMemTable1.Open;

  //Mostra a tela de carregamento antes de começar a gravar
  PageControl1.ActivePageIndex := 2;
  PageControl1.Update;
  Screen.Cursor := crHourGlass;
  try
    try
      DMConfig.GravarNotas(FDMemTable1);
    except
      on E: Exception do
      begin
        //GravarNotas já desfez a transação: o banco continua como estava
        Screen.Cursor := crDefault;
        PageControl1.ActivePageIndex := 1;
        messagedlg('Erro ao gravar as notas no banco de dados. O relatório não foi gerado.' + sLineBreak +
                   E.Message, mtError, [mbOk], 0);
        Exit;
      end;
    end;
  finally
    Screen.Cursor := crDefault;
  end;

  //Gravação concluída: abre o relatório.
  //Se a geração ou a prévia falhar (ex.: 'Sem registros no banco de dados!'),
  //sai da aba Loading, volta para a aba Notas e mostra o erro
  try
    FinalizaRelatorio(Relatorio);
  except
    on E: Exception do
    begin
      PageControl1.ActivePageIndex := 1;
      messagedlg('Erro ao gerar o relatório:' + sLineBreak + sLineBreak + E.Message, mtError, [mbOk], 0);
      DMConfig.CreateLog(E.ClassName, E.Message);
    end;
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
  //PageControl1.ActivePageIndex := 0;
  CategoryButtons1Categories0Items0Click(Self);

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
  PageControl1.ActivePageIndex := 0;
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
    //Ctrl+F: a busca chega na etapa 4.5; por enquanto leva o foco para a grade de notas
    PageControl1.ActivePageIndex := 1;
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
    actGerarDanfe.Enabled := (PageControl1.ActivePageIndex = 1) and TemNotaNaGrade and (not FGerandoDanfe);
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

    //D2: cards visíveis em Resumo, Notas e Carregando; ocultos em Enviar e Configurações.
    //O OnShow da aba dispara também quando a troca vem do código (ActivePageIndex)
    TabSheet1.OnShow := PaginaShow;
    TabSheet2.OnShow := PaginaShow;
    Loading.OnShow   := PaginaShow;
    Enviar.OnShow    := PaginaShow;
    Config.OnShow    := PaginaShow;
end;

procedure TFormPrincipal.PaginaShow(Sender: TObject);
begin
    //Sender é a aba que acabou de aparecer (o ActivePage ainda pode ser a anterior)
    PnlCards.Visible := (Sender <> Enviar) and (Sender <> Config);
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

end.
