unit ProXML.FormPrincipal;

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
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Skia,
  Skia.Vcl,
  Vcl.FileCtrl,
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
  Vcl.Menus, DM;

type
  TFormPrincipal = class(TForm)
    PnlContainer: TPanel;
    PnlCabecalho: TPanel;
    PnlCorpo: TPanel;
    PnlInfo: TPanel;
    PnlLocal: TPanel;
    PnlLogo: TPanel;
    PnlImg: TPanel;
    PnlInfoLocal: TPanel;
    FileOpenDialog1: TFileOpenDialog;
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
    SkAnimatedImage1: TSkAnimatedImage;
    ProgressBar: TProgressBar;
    procedure SkSvg1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormShow(Sender: TObject);
    procedure CategoryButtons1Categories0Items0Click(Sender: TObject);
    procedure CategoryButtons1Categories0Items1Click(Sender: TObject);
    procedure GerarPDF1Click(Sender: TObject);
    procedure CategoryButtons1Categories0Items2Click(Sender: TObject);
    procedure GravarNotasDB();
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CategoryButtons1Categories0Items3Click(Sender: TObject);
  private
    procedure SetTextoTranferencia(const Text: String);
    procedure FinalizaRelatorio(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

Type
  TDBGridPadrao = class(TDBGrid);

var
  FormPrincipal: TFormPrincipal;

implementation

uses
  uCalculadoraXML, Vcl.Clipbrd;

{$R *.dfm}


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

procedure TFormPrincipal.FinalizaRelatorio(Sender: TObject);
begin
   //
   while Not DMConfig.QryNotas.RecordCount = FDMemTable1.RecordCount do
   begin
      ProgressBar.Position := DMConfig.QryNotas.RecordCount;
   end;

   ProgressBar.Position := DMConfig.QryNotas.RecordCount;
   PageControl1.ActivePageIndex := 0;
end;

procedure TFormPrincipal.CategoryButtons1Categories0Items2Click(
  Sender: TObject);
var
    T : TThread;
begin
    //Geração de relatóeio
    if DataSource1.DataSet.RecordCount <= 0 then
    begin
       messagedlg('Sem dados para gerar relatório !!', mtInformation	, [mbOk], 0);
       Exit;
    end;

    GravarNotasDB;

end;

procedure TFormPrincipal.CategoryButtons1Categories0Items3Click(
  Sender: TObject);
begin
    //PageControl1.ActivePageIndex := 2;
    //SkAnimatedImage1.Animation.Start;
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
   TDBGridPadrao(DBGrid1).DefaultRowHeight := 25;
end;

procedure TFormPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := cafree;
end;

procedure TFormPrincipal.FormShow(Sender: TObject);
begin
   //Ajustar linhas DBGrid
   TDBGridPadrao(DBGrid1).DefaultRowHeight := 25;
   DataSource1.DataSet.First;
   PageControl1.ActivePageIndex := 0;
end;

procedure TFormPrincipal.SetTextoTranferencia(const Text: String);
begin
    //Setar texto do NCM na area de transferencia
    Clipboard.AsText := Text;
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
  SkAnimatedImage1.Animation.Start;


  ProgressBar.Max := FDMemTable1.RecordCount;

  T:= TThread.CreateAnonymousThread(procedure
  begin
      while not FDMemTable1.Eof do
      begin

         DMConfig.InserirNotaDB(
          FDMemTable1.FieldByName('numero').AsString,
          FDMemTable1.FieldByName('chave').AsString,
          FDMemTable1.FieldByName('data').AsString,
          FDMemTable1.FieldByName('vtotal').AsString,
          FDMemTable1.FieldByName('vlicms').AsString,
          FDMemTable1.FieldByName('bcicms').AsString
        );

        FDMemTable1.Next;
      end;
  end
  );

  T.OnTerminate := FinalizaRelatorio;
  T.Start;


end;

procedure TFormPrincipal.SkSvg1Click(Sender: TObject);
begin
  //Selecionando a pasta de arquivos
  FileOpenDialog1.Execute;
  EditCaminho.Text := FileOpenDialog1.FileName;
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

    if EditCaminho.Text <> '' then
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
