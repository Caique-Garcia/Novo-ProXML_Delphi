unit DM;

interface

uses
  System.SysUtils,
  System.Classes,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs,
  FireDAC.VCLUI.Wait,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Comp.DataSet;

type
  TDMConfig = class(TDataModule)
    Conxao: TFDConnection;
    Query: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure ConxaoBeforeConnect(Sender: TObject);
    procedure ConxaoAfterConnect(Sender: TObject);
  private
  public
  end;

var
  DMConfig: TDMConfig;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDMConfig.ConxaoAfterConnect(Sender: TObject);
begin
     Conxao.ExecSQL('CREATE TABLE IF NOT EXISTS nf ( ' +
                                'NUMERO           TEXT (20), '  +
                                'CHAVE            TEXT (50), '  +
                                'VALOR            TEXT (20), '  +
                                'DATA             TEXT (36), '  +
                                'BCICMS           TEXT (30), '  +
                                'VLICMS           TEXT (30)  '  +
                                ' ); ');
end;

procedure TDMConfig.ConxaoBeforeConnect(Sender: TObject);
begin
   Conxao.DriverName := 'SQLite';

  {$IFDEF MSWINDOWS}
   Conxao.Params.Values['Database'] := System.SysUtils.GetCurrentDir + '\db\notas.db';
  {$ELSE}
   Conxao.Params.Values['Database'] := TPath.Combine( TPath.GetDocumentsPath, '\notas.db');
  {$ENDIF}


end;

procedure TDMConfig.DataModuleCreate(Sender: TObject);
var
  Diretorio: string;
begin
    Diretorio := System.SysUtils.GetCurrentDir + '\db';

    if not DirectoryExists(Diretorio) then
        CreateDir(Diretorio);

    Conxao.Connected := True;
end;

end.
