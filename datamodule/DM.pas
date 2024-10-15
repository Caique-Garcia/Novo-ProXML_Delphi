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
  FireDAC.Comp.DataSet, ProXML.Classes;

type
  TDMConfig = class(TDataModule)
    Conexao: TFDConnection;
    Query: TFDQuery;
    QryNotas: TFDQuery;
    QryNotasCHAVE: TWideStringField;
    QryNotasVALOR: TWideStringField;
    QryNotasDATA: TWideStringField;
    QryNotasBCICMS: TWideStringField;
    QryNotasVLICMS: TWideStringField;
    QryNotasNUMERO: TWideStringField;
    procedure DataModuleCreate(Sender: TObject);
    procedure ConexaoBeforeConnect(Sender: TObject);
    procedure ConexaoAfterConnect(Sender: TObject);
  private
    procedure GravarConfig(const Config: TConfig);
    function GetConfig: TConfig;

  public
    procedure InserirNotaDB(const Numero, Chave, Data, Valor, ICMS, BC, XML: String);
    procedure DeleteDados;
  end;

var
  DMConfig: TDMConfig;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDMConfig.ConexaoAfterConnect(Sender: TObject);
begin
     Conexao.ExecSQL('CREATE TABLE IF NOT EXISTS nf ( ' +
                                'NUMERO           TEXT (20), '  +
                                'CHAVE            TEXT (50), '  +
                                'VALOR            TEXT (20), '  +
                                'DATA             TEXT (36), '  +
                                'BCICMS           TEXT (30), '  +
                                'VLICMS           TEXT (30), '  +
                                'XML              TEXT (200) '  +
                                ' ); ');

   Conexao.ExecSQL('CREATE TABLE IF NOT EXISTS config ( ' +
                                'SMTP             TEXT (32), '  +
                                'EMAIL            TEXT (54), '  +
                                'SENHA            TEXT (32), '  +
                                'PORTA            TEXT (36), '  +
                                'SSL              TEXT (36), '  +
                                'TSL              TEXT (36), '  +
                                'MSG              TEXT (200) '  +
                                ' ); ');
end;

procedure TDMConfig.ConexaoBeforeConnect(Sender: TObject);
begin
   Conexao.DriverName := 'SQLite';

  {$IFDEF MSWINDOWS}
   Conexao.Params.Values['Database'] := System.SysUtils.GetCurrentDir + '\db\notas.db';
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

    Conexao.Connected := True;
end;

procedure TDMConfig.DeleteDados();
begin
    Conexao.ExecSQL('DELETE FROM nf ;');
end;

procedure TDMConfig.InserirNotaDB(const Numero, Chave, Data, Valor, ICMS, BC, XML: String);
begin
    Query.Active := False;
    Query.SQL.Clear;

    Query.SQL.Add('insert into nf ');
    Query.SQL.Add('values( :NUMERO, :CHAVE, :VALOR, :DATA, :BCICMS, :VLICMS, :XML )');
    Query.Params.ParamByName('NUMERO').AsString         := Trim(Numero);
    Query.Params.ParamByName('CHAVE').AsString          := Trim(Chave);
    Query.Params.ParamByName('VALOR').AsString          := Trim(Valor);
    Query.Params.ParamByName('DATA').AsString           := Trim(Data);
    Query.Params.ParamByName('BCICMS').AsString         := Trim(BC);
    Query.Params.ParamByName('VLICMS').AsString         := Trim(ICMS);
    Query.Params.ParamByName('XML').AsString            := Trim(XML);

    try
        Query.ExecSQL;
    except on e: Exception do
        raise Exception.Create('Erro na gravação de dados: '+ e.message);
    end;
end;

procedure TDMConfig.GravarConfig(const Config: TConfig);
var
    TSL, SSL: String;
begin
    Query.Active := False;
    Query.SQL.Clear;

    TSL := '0';
    SSL := '0';

    if Config.TSL then TSL := '1';
    if Config.SSL then SSL := '1';

    Query.SQL.Add('insert into nf ');
    Query.SQL.Add('values( :SMTP, :EMAIL, :SENHA, :PORTA, :SSL, :TSL, :MSG )');
    Query.Params.ParamByName('SMTP').AsString    := Trim(Config.SMTP);
    Query.Params.ParamByName('EMAIL').AsString   := Trim(Config.Email);
    Query.Params.ParamByName('SENHA').AsString   := Trim(Config.Senha);
    Query.Params.ParamByName('PORTA').AsString   := Trim(Config.Porta);
    Query.Params.ParamByName('SSL').AsString     := Trim(SSL);
    Query.Params.ParamByName('TSL').AsString     := Trim(TSL);
    Query.Params.ParamByName('MSG').AsString     := Trim(Config.Mensagem);

    try
        Query.ExecSQL;
    except on e: Exception do
        raise Exception.Create('Erro na gravação de dados: '+ e.message);
    end;
end;

function TDMConfig.GetConfig(): TConfig;
var
    TSL, SSL: String;
begin
    Result := TConfig.New;

    Query.Active := False;
    Query.SQL.Clear;

    Query.SQL.Add('insert into nf ');
    Query.SQL.Add('values( :SMTP, :EMAIL, :SENHA, :PORTA, :SSL, :TSL, :MSG )');
    Query.Params.ParamByName('SMTP').AsString    := Trim(Config.SMTP);
    Query.Params.ParamByName('EMAIL').AsString   := Trim(Config.Email);
    Query.Params.ParamByName('SENHA').AsString   := Trim(Config.Senha);
    Query.Params.ParamByName('PORTA').AsString   := Trim(Config.Porta);
    Query.Params.ParamByName('SSL').AsString     := Trim(SSL);
    Query.Params.ParamByName('TSL').AsString     := Trim(TSL);
    Query.Params.ParamByName('MSG').AsString     := Trim(Config.Mensagem);


    if Config.TSL then TSL := '1';
    if Config.SSL then SSL := '1';

    try
        Query.ExecSQL;
    except on e: Exception do
        raise Exception.Create('Erro na gravação de dados: '+ e.message);
    end;
end;

end.
