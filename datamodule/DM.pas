unit DM;

interface

uses
  System.SysUtils,
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
  FireDAC.Comp.DataSet,
  ProXML.Classes,
  System.Classes;

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
  public
    procedure CreateLog(const Classe, Msg: String);
    procedure InserirNotaDB(const Numero, Chave, Data, Valor, ICMS, BC, XML: String);
    procedure DeleteDados;
    function GetConfig: TConfig;
    procedure UpdateConfig(const Config: TConfig);
    procedure GravaLog(Sender: TObject; E: Exception);
  end;

var
  DMConfig: TDMConfig;

implementation

uses
  System.IOUtils,
  Vcl.Forms;

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

  Conexao.ExecSQL('CREATE TABLE IF NOT EXISTS LOG ( ' +
                                'CLASSE           TEXT (200), '  +
                                'MSG              TEXT (2000), '  +
                                'DT               TEXT (32) '  +
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
    //Create do Form
    //Application.OnException := GravaLog;

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

procedure TDMConfig.CreateLog(const Classe, Msg: String);
begin
    Query.Active := False;
    Query.SQL.Clear;

    Query.SQL.Add('insert into LOG ');
    Query.SQL.Add('values( :CLASSE, :MSG, :DT )');
    Query.Params.ParamByName('CLASSE').AsString         := Trim(Classe);
    Query.Params.ParamByName('MSG').AsString            := Trim(Msg);
    Query.Params.ParamByName('DT').AsString             := FormatDateTime('dd/mm/yyyy hh:nn:ss', Now);


    try
        Query.ExecSQL;
    except on e: Exception do
        raise Exception.Create('Erro na gravação de dados: '+ e.message);
    end;
end;

procedure TDMConfig.GravaLog(Sender: TObject; E: Exception);
begin
    // Grava no log o erro com detalhes
    //DMConfig.CreateLog(E.ClassName, E.Message);
    TFile.AppendAllText(System.SysUtils.GetCurrentDir +'\ErroLog.txt', Format('%s: %s%s', [DateTimeToStr(Now), E.Message, sLineBreak]));
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

    Query.SQL.Add('insert into config ');
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

procedure TDMConfig.UpdateConfig(const Config: TConfig);
var
    TSL, SSL: String;
    QryAux: TFDQuery;
begin
    Query.Active := False;
    Query.SQL.Clear;

    TSL := '0';
    SSL := '0';

    if Config.TSL then TSL := '1';
    if Config.SSL then SSL := '1';

    QryAux := TFDQuery.Create(Nil);
    try
        QryAux.Active := False;
        QryAux.Connection := Conexao;
        QryAux.SQL.Clear;
        QryAux.SQL.Add('SELECT SMTP, EMAIL, SENHA, PORTA, SSL, TSL, MSG FROM CONFIG ');
        try
           QryAux.Active := True;

           if QryAux.IsEmpty then
           begin
               GravarConfig(Config);
               Exit;
           end;
        except on e:Exception do
           raise Exception.Create('Erro na gravação de dados: '+ e.message);
        end;

    finally
       FreeAndNil(QryAux);
    end;


    Query.SQL.Add('UPDATE CONFIG SET SMTP = :SMTP, EMAIL = :EMAIL, SENHA = :SENHA, ');
    Query.SQL.Add('PORTA = :PORTA, SSL = :SSL , TSL = :TSL, MSG = :MSG ');
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
begin
    Result := TConfig.Create;
    try
      Query.Active := False;
      Query.SQL.Clear;

      Query.SQL.Add('SELECT SMTP, EMAIL, SENHA, PORTA, SSL, TSL, MSG FROM CONFIG ');

      try
        Query.Active := True;
        if Not Query.IsEmpty then
        begin
            Result.SMTP     := Query.FieldByName('SMTP').AsString;
            Result.Email    := Query.FieldByName('EMAIL').AsString;
            Result.Senha    := Query.FieldByName('SENHA').AsString;
            Result.Porta    := Query.FieldByName('PORTA').AsString;
            Result.Mensagem := Query.FieldByName('MSG').AsString;
            if Query.FieldByName('SSL').AsString = '1' then Result.SSL := True;
            if Query.FieldByName('TSL').AsString = '1' then Result.TSL := True;

        end;

      except on e: Exception do
        raise Exception.Create('Erro na gravação de dados: '+ e.message);
      end;

    finally

    end;

end;

end.
