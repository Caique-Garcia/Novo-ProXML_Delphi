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
  Vcl.Buttons,
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
  uCalculadoraXML;

type
  //Relatório aberto depois de gravar as notas no banco (GravarNotasDB)
  TTipoRelatorio = (trNotas, trIBSCBS);

  TFormPrincipal = class(TForm)
    PnlContainer: TPanel;
    PnlCabecalho: TPanel;
    PnlCorpo: TPanel;
    PnlInfo: TPanel;
    PnlLocal: TPanel;
    PnlLogo: TPanel;
    PnlInfoLocal: TPanel;
    {$IFDEF MSWINDOWS}
      FileOpenDialog1: TFileOpenDialog;
    {$ENDIF}
    PanelVaorICMS: TPanel;
    PanelValorBaseICMS: TPanel;
    PanelValorTotal: TPanel;
    PanelIMGValorTotal: TPanel;
    PanelTextoValorTotal: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Label3: TLabel;
    LabelValorTotal: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    LabelbaseICMS: TLabel;
    LabelValorICMS: TLabel;
    SkSvg2: TSkSvg;
    SkSvg3: TSkSvg;
    SkSvg4: TSkSvg;
    Image1: TImage;
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
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Panel6: TPanel;
    Shape8: TShape;
    SkSvg1: TSkSvg;
    Shape1: TShape;
    EditCaminho: TEdit;
    Panel7: TPanel;
    SpeedButton1: TSpeedButton;
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
    btnSalvarConfig: TSpeedButton;
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
    btnEnviarEmail: TSpeedButton;
    ACBrNFeDANFEFR: TACBrNFeDANFEFR;
    PanelValorIBS: TPanel;
    ShapeValorIBS: TShape;
    PanelIMGValorIBS: TPanel;
    SkSvgValorIBS: TSkSvg;
    PanelTextoValorIBS: TPanel;
    LabelTituloIBS: TLabel;
    LabelValorIBS: TLabel;
    PanelValorCBS: TPanel;
    ShapeValorCBS: TShape;
    PanelIMGValorCBS: TPanel;
    SkSvgValorCBS: TSkSvg;
    PanelTextoValorCBS: TPanel;
    LabelTituloCBS: TLabel;
    LabelValorCBS: TLabel;
    LabelFiltroModelo: TLabel;
    ComboFiltroModelo: TComboBox;
    procedure SkSvg1Click(Sender: TObject);
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
    procedure ComboFiltroModeloChange(Sender: TObject);
    procedure CategoryButtons1RelatorioIBSCBSClick(Sender: TObject);
  private
    ConfigEmail : TConfig;
    FTotais : TTotaisNotas;
    FGerandoDanfe : Boolean;   //evita gerar dois DANFEs ao mesmo tempo (a espera do PDF processa mensagens)
    procedure SetTextoTranferencia(const Text: String);
    procedure AjustarAlturaLinhasGrade;
    procedure GerarRelatorio(const Relatorio: TTipoRelatorio);
    procedure FinalizaRelatorio(const Relatorio: TTipoRelatorio);
    procedure AbrirRelatorioIBSCBS;
    function  FormatarValor(const Valor: Double): string;
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

  public
    procedure AtualizarTotais;
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
  System.IOUtils;

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
    //Enviar Email com arquivos compactados
    EnviaArquivo(Trim(EditEmailEnviar.Text), 'Projeto Pro XML - XMLs de Nota Fiscal');
end;

procedure TFormPrincipal.AtualizarTotais;
begin
    //Recalcula os totais a partir das notas da grade (respeita o filtro ativo)
    FTotais := CalcularTotais(FDMemTable1);

    LabelValorTotal.Caption := FormatarValor(FTotais.ValorTotal);
    LabelbaseICMS.Caption   := FormatarValor(FTotais.BaseICMS);
    LabelValorICMS.Caption  := FormatarValor(FTotais.ValorICMS);
    LabelValorIBS.Caption   := FormatarValor(FTotais.IBS);
    LabelValorCBS.Caption   := FormatarValor(FTotais.CBS);
end;

function TFormPrincipal.DescricaoFiltroModelo: string;
begin
    //Texto do seletor de modelo para o subtítulo dos relatórios; vazio em "Todos"
    if ModeloSelecionado = FILTRO_MODELO_TODOS then
        Result := ''
    else
        Result := ComboFiltroModelo.Text;
end;

function TFormPrincipal.FormatarValor(const Valor: Double): string;
begin
    //Formato dos valores nos cards e nos totais dos relatórios
    Result := 'R$ ' + FloatToStrF(Valor, ffFixed, 15, 2);
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
    case ComboFiltroModelo.ItemIndex of
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

procedure TFormPrincipal.ComboFiltroModeloChange(Sender: TObject);
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
        PageControl1.ActivePageIndex := 0;
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
        FormIBSCBS.SetTotalBaseIBSCBS(FormatarValor(FTotais.BaseIBSCBS));
        FormIBSCBS.SetTotalIBSUF(FormatarValor(FTotais.IBSUF));
        FormIBSCBS.SetTotalIBSMun(FormatarValor(FTotais.IBSMun));
        FormIBSCBS.SetTotalIBS(FormatarValor(FTotais.IBS));
        FormIBSCBS.SetTotalCBS(FormatarValor(FTotais.CBS));
        FormIBSCBS.SetQtRegistros(IntToStr(FTotais.QuantidadeIBSCBS));
        FormIBSCBS.SetDescricaoFiltro(DescricaoFiltroModelo);

        if not FormIBSCBS.GerarRelatorio then
        begin
            //Nenhuma nota do filtro atual tem IBS/CBS: não abre a visualização
            PageControl1.ActivePageIndex := 0;
            messagedlg('Nenhuma nota com IBS/CBS', mtInformation, [mbOk], 0);
        end;

        PageControl1.ActivePageIndex := 0;
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
    ComprimirArquivos();
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
   ComboFiltroModelo.ItemIndex := 0;
   AplicarFiltroModelo;
end;

procedure TFormPrincipal.FormDestroy(Sender: TObject);
begin
  //ConfigEmail.Free;
end;

procedure TFormPrincipal.ComprimirArquivos();
var
  varPath: string;
  varDestino: string;
begin
    //Comprime os arquivos XML
    varPath := ExtractFilePath(ParamStr(0));

    if TDirectory.Exists(varPath + 'NFCe\ProXML') then
    begin
      // Deleta a pasta e todo o seu conteúdo
      TDirectory.Delete(varPath + 'NFCe\ProXML', True);  // O segundo parâmetro True indica exclusão recursiva
    end;

    if not SysUtils.DirectoryExists(varPath + 'NFCe\ProXML') then SysUtils.ForceDirectories(varPath + '\NFCe\ProXML');

    FDMemTable1.First;
    while not FDMemTable1.Eof do
    begin
        varDestino := varPath + 'NFCe\ProXML\'+FDMemTable1.FieldByName('chave').AsString+'-nfe.xml';

        CopyFile(PChar(FDMemTable1.FieldByName('xml').AsString), PChar(varDestino), False);
        FDMemTable1.Next;
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
        PageControl1.ActivePageIndex := 0;
        messagedlg('Erro ao gravar as notas no banco de dados. O relatório não foi gerado.' + sLineBreak +
                   E.Message, mtError, [mbOk], 0);
        Exit;
      end;
    end;
  finally
    Screen.Cursor := crDefault;
  end;

  //Gravação concluída: abre o relatório
  FinalizaRelatorio(Relatorio);
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

procedure TFormPrincipal.SkSvg1Click(Sender: TObject);
begin
  //Selecionando a pasta de arquivos
  {$IFDEF MSWINDOWS}
    FileOpenDialog1.Execute;   
    EditCaminho.Text := FileOpenDialog1.FileName;
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
  SpeedButton1.Enabled := false;
  //PageControl1.ActivePageIndex := 0;
  CategoryButtons1Categories0Items0Click(Self);

  Memo1.Lines.Clear;
  CalculadoraXML:=  TCalculadoraXML.Create;
  try

    if EditCaminho.Text <> 'Selecione uma pasta contendo XMLs de Nota Fiscal' then
    begin
      //Nova pasta: o seletor de modelo volta para "Todos" (grade, cards e relatórios)
      ComboFiltroModelo.ItemIndex := 0;
      AplicarFiltroModelo;

      CalculadoraXML.CaminhoDiretorio := EditCaminho.Text;
      CalculadoraXML.ProcessarXMLs;
      AjustarAlturaLinhasGrade;
      DBGrid1.Refresh;
    end else
    begin
         messagedlg('Por favor selecione um repositório !!', mtInformation	, [mbOk], 0);
    end;
    
  finally
    CalculadoraXML.Free;
  end;
  PageControl1.ActivePageIndex := 0;
  SpeedButton1.Enabled := true;
  Gauge1.Progress := 0;
  Memo1.SetFocus;
end;

end.
