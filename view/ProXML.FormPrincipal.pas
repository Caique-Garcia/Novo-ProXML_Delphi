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
  MidasLib;

type
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
    procedure SkSvg1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CategoryButtons1Categories0Items0Click(Sender: TObject);
    procedure CategoryButtons1Categories0Items1Click(Sender: TObject);
    procedure GerarPDF1Click(Sender: TObject);
    procedure CategoryButtons1Categories0Items2Click(Sender: TObject);
    procedure GravarNotasDB();
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CategoryButtons1Categories0Items3Click(Sender: TObject);
    procedure GerarDANFe1Click(Sender: TObject);
    procedure CategoryButtons1Categories0Items4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSalvarConfigClick(Sender: TObject);
    procedure SkSvg5Click(Sender: TObject);
    procedure btnEnviarEmailClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    ConfigEmail : TConfig;
    procedure SetTextoTranferencia(const Text: String);
    procedure FinalizaRelatorio(Sender: TObject);
    procedure ConfigACBR;
    procedure GerarDanfe(const CaminhoArq: String);
    procedure ComprimirArquivos();
    procedure LerConfigEmail();
    procedure EnviaArquivo(const Email, Assunto: string);
    procedure ApplicationException(Sender: TObject; E: Exception);
    function  CreateProcessSimple(cmd: string): boolean;

  public

  end;

Type
  TDBGridPadrao = class(TDBGrid);

var
  FormPrincipal: TFormPrincipal;

implementation

uses
  uCalculadoraXML,
  Vcl.Clipbrd,
  pcnConversao,
  pcnConversaoNFe,
  {$IFDEF MSWINDOWS}
    Vcl.FileCtrl,
  {$ENDIF}
  System.IOUtils;

{$R *.dfm}

procedure TFormPrincipal.ApplicationException(Sender: TObject; E: Exception);
begin
  // Grava no log o erro com detalhes
  DMConfig.CreateLog(E.ClassName, E.Message);
end;

procedure TFormPrincipal.btnEnviarEmailClick(Sender: TObject);
begin
    //Enviar Email com arquivos compactados
    EnviaArquivo(Trim(EditEmailEnviar.Text), 'Projeto Pro XML - NFCe XMLs');
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

procedure TFormPrincipal.FinalizaRelatorio(Sender: TObject);
begin
   //Finaliza o relatório
   FormRelatorio := TFormRelatorios.Create(Nil);
   try
        FormRelatorio.SetTotal(LabelValorTotal.Caption);
        FormRelatorio.SetTotalBC(LabelbaseICMS.Caption);
        FormRelatorio.SetTotalICMS(LabelValorICMS.Caption);
        FormRelatorio.SetQtRegistros(IntToStr(FDMemTable1.RecordCount));
        FormRelatorio.GerarRelatorio;
        PageControl1.ActivePageIndex := 0;
   finally
        FreeAndNil(FormRelatorio);
   end

end;

procedure TFormPrincipal.CategoryButtons1Categories0Items2Click(
  Sender: TObject);
begin
    //Geração de relatóeio
    if DataSource1.DataSet.RecordCount <= 0 then
    begin
       messagedlg('Sem dados para gerar relatório !!', mtInformation	, [mbOk], 0);
       Exit;
    end
    else
        GravarNotasDB;

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

procedure TFormPrincipal.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
//    //Mudando cor da seleção
//    if (gdSelected in State) then
//    begin
//      //Cor da Seleção
//      DBGrid1.Canvas.Brush.Color :=$00FCDDC9; //$00E9E5E4;
//
//      //Cor da Fonte
//      //DBGCaixa.Canvas.Font.Color := clHighlightText;
//    end;
//
//    //Alinha textos na linha do grid
//   DBGrid1.Canvas.TextRect(Rect, Rect.Left + 28, Rect.Top + 6, Column.Field.DisplayText);
 //Ajustar linhas DBGrid
 try
    TDBGridPadrao(DBGrid1).DefaultRowHeight := 25;
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
   Application.OnException := DMConfig.GravaLog;

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
    AcbrNfeDanfeFR.FastFile        := varPath + 'Report\NFe\DANFeNFCeA4.fr3'; //DANFeNFCe5_00.fr3 // DANFeNFCeA4.fr3
    AcbrNfeDanfeFR.FastFileEvento  := varPath + 'Report\NFe\EventosNFCe.fr3';

//    ACBrNFeDANFeFPDF1.ExibeCampoDePagamento := eipQuadro;

    ACBrNFeDANFeFPDF1.PathPDF := varPath + '\NFCe\danfePDF';
    //ACBrNFeDANFeFPDF1.        := varPath + 'Report\NFe\DANFeNFCeA4.fr3'; //DANFeNFCe5_00.fr3 // DANFeNFCeA4.fr3
    //ACBrNFeDANFeFPDF1.FastFileEvento  := varPath + 'Report\NFe\EventosNFCe.fr3';

    ACBrNFe.DANFE.TipoDANFE  := tiNFCe;
end;

procedure TFormPrincipal.FormShow(Sender: TObject);
begin
   //Ajustar linhas DBGrid
   try
    TDBGridPadrao(DBGrid1).DefaultRowHeight := 25;
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

procedure TFormPrincipal.GerarDanfe(const CaminhoArq: String);
var
    Result :Boolean;
    CaminhoPDF : String;
    NomeArqPDF : String;
    AuxNomeArqPDF: string;
    AuxCaminhoPDF: string;
begin
    //Gera danfe do arquivo da nfce
    PageControl1.ActivePageIndex := 2;
    //SkAnimatedImage1.Animation.Start;

    NomeArqPDF      :=  ExtractFileName(CaminhoArq);
    NomeArqPDF      :=  ChangeFileExt(NomeArqPDF, '.pdf');
    AuxNomeArqPDF   := ChangeFileExt(NomeArqPDF, '-nfe.pdf');
    CaminhoPDF      :=  ACBrNFe.DANFE.PathPDF + NomeArqPDF;
    AuxCaminhoPDF   :=  ACBrNFe.DANFE.PathPDF + AuxNomeArqPDF;

    if FileExists(CaminhoPDF) then
    begin
        try
            DeleteFile(CaminhoPDF);
        except
        end
    end;

    if FileExists(AuxCaminhoPDF) then
    begin
        try
            DeleteFile(AuxCaminhoPDF);
        except
        end
    end;

    ACBrNFe.NotasFiscais.Clear;

    //ACBrNFe.NotasFiscais.LoadFromString('');
    Result := ACBrNFe.NotasFiscais.LoadFromFile(CaminhoArq, False);

    if Result then
        ACBrNFe.NotasFiscais.ImprimirPDF
    else
    begin
        PageControl1.ActivePageIndex := 1;
        Exit;
    end;

    while (Not FileExists(CaminhoPDF)) and (Not FileExists(AuxCaminhoPDF)) do
    begin

    end;

    if FileExists(CaminhoPDF) then
    begin
        try
            ShellExecute(0, 'open', PChar(CaminhoPDF), nil, nil, SW_SHOWNORMAL);
            PageControl1.ActivePageIndex := 1;
        except
        end
    end;

    if FileExists(AuxCaminhoPDF) then
    begin
        try
            ShellExecute(0, 'open', PChar(AuxCaminhoPDF), nil, nil, SW_SHOWNORMAL);
            PageControl1.ActivePageIndex := 1;
        except
        end
    end;
end;

procedure TFormPrincipal.GerarDANFe1Click(Sender: TObject);
begin
  GerarDanfe(DBGrid1.DataSource.DataSet.FieldByName('xml').Value);
end;

procedure TFormPrincipal.GerarPDF1Click(Sender: TObject);
begin
   SetTextoTranferencia(DBGrid1.DataSource.DataSet.FieldByName('chave').Value);
end;

procedure TFormPrincipal.GravarNotasDB;
var
    T: TThread;
begin
  //Grava as notas no banco de dados SQLIte

  if not FDMemTable1.Active then
    FDMemTable1.Open;

  DMConfig.DeleteDados;

  FDMemTable1.First;
  PageControl1.ActivePageIndex := 2;
  //SkAnimatedImage1.Animation.Start;

  T:= TThread.CreateAnonymousThread(procedure
  begin
      while not FDMemTable1.Eof do
      begin

         DMConfig.InserirNotaDB(
          FDMemTable1.FieldByName('numero').AsString,
          FDMemTable1.FieldByName('chave').AsString,
          FDMemTable1.FieldByName('data').AsString,
          FormatFloat('0.00',FDMemTable1.FieldByName('vtotal').AsFloat),
          FormatFloat('0.00',FDMemTable1.FieldByName('vlicms').AsFloat),
          FormatFloat('0.00',FDMemTable1.FieldByName('bcicms').AsFloat),
          FDMemTable1.FieldByName('xml').AsString
        );

        FDMemTable1.Next;
      end;
  end
  );

  //Ao terminar de executar chama a função FinalizarRelatorio
  T.OnTerminate := FinalizaRelatorio;
  T.Start;

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

    if EditCaminho.Text <> 'Selecione uma pasta contendo XMLs de NFCe' then
    begin
      CalculadoraXML.CaminhoDiretorio := EditCaminho.Text;
      CalculadoraXML.ProcessarXMLs;
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
