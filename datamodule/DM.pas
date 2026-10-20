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

const
  //Valores do filtro de modelo (FiltroModelo)
  FILTRO_MODELO_TODOS = 0;
  FILTRO_MODELO_NFE   = 55;
  FILTRO_MODELO_NFCE  = 65;

type
  //Preferências da tela guardadas na tabela config (última pasta e janela)
  TPreferencias = record
    UltimaPasta      : String;
    TemJanela        : Boolean;   //False: a janela nunca foi salva (abre centralizada)
    JanelaEsquerda   : Integer;
    JanelaTopo       : Integer;
    JanelaLargura    : Integer;
    JanelaAltura     : Integer;
    JanelaMaximizada : Boolean;
  end;

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
    QryNotasMODELO: TIntegerField;
    QryNotasIBSCBS: TFDQuery;
    QryNotasIBSCBSNUMERO: TWideStringField;
    QryNotasIBSCBSCHAVE: TWideStringField;
    QryNotasIBSCBSDATA: TWideStringField;
    QryNotasIBSCBSMODELO: TIntegerField;
    QryNotasIBSCBSVBCIBSCBS: TWideStringField;
    QryNotasIBSCBSVIBSUF: TWideStringField;
    QryNotasIBSCBSVIBSMUN: TWideStringField;
    QryNotasIBSCBSVIBS: TWideStringField;
    QryNotasIBSCBSVCBS: TWideStringField;
    procedure DataModuleCreate(Sender: TObject);
    procedure ConexaoBeforeConnect(Sender: TObject);
    procedure ConexaoAfterConnect(Sender: TObject);
    procedure QryNotasBeforeOpen(DataSet: TDataSet);
  private
    FFiltroModelo: Integer;
    procedure GravarConfig(const Config: TConfig);
    procedure AdicionarColunasFaltantes(const Tabela: String; const Colunas, Definicoes: array of String);
    procedure MigrarTabelaNF;
    procedure MigrarTabelaConfig;
    function  ConfigVazia: Boolean;
    procedure SetFiltroModelo(const Value: Integer);
  public
    procedure CreateLog(const Classe, Msg: String);
    procedure InserirNotaDB(const Numero, Chave, Data, Valor, ICMS, BC, XML: String;
      const Modelo: Integer; const TemIBSCBS: Boolean;
      const BCIBSCBS, IBSUF, IBSMun, IBS, CBS: String);
    procedure GravarNotas(DataSet: TDataSet);
    procedure DeleteDados;
    function GetConfig: TConfig;
    procedure UpdateConfig(const Config: TConfig);
    procedure GravaLog(Sender: TObject; E: Exception);
    //Preferências da tela (colunas ULTIMA_PASTA e JANELA_* da tabela config)
    function  GetPreferencias: TPreferencias;
    procedure GravarUltimaPasta(const Pasta: String);
    procedure GravarJanela(const Esquerda, Topo, Largura, Altura: Integer; const Maximizada: Boolean);
    //Filtro de modelo usado por QryNotas e QryNotasIBSCBS: 0 = Todos, 55 = NF-e, 65 = NFC-e
    //Vale na próxima abertura das queries
    property FiltroModelo: Integer read FFiltroModelo write SetFiltroModelo;
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
                                'XML              TEXT (200), '  +
                                'MODELO           INTEGER, '  +
                                'TEM_IBSCBS       INTEGER DEFAULT 0, '  +
                                'VBCIBSCBS        TEXT (30), '  +
                                'VIBSUF           TEXT (30), '  +
                                'VIBSMUN          TEXT (30), '  +
                                'VIBS             TEXT (30), '  +
                                'VCBS             TEXT (30) '  +
                                ' ); ');

   //Bancos criados pela versão 1.0 não têm as colunas novas
   MigrarTabelaNF;

   Conexao.ExecSQL('CREATE TABLE IF NOT EXISTS config ( ' +
                                'SMTP             TEXT (32), '  +
                                'EMAIL            TEXT (54), '  +
                                'SENHA            TEXT (32), '  +
                                'PORTA            TEXT (36), '  +
                                'SSL              TEXT (36), '  +
                                'TSL              TEXT (36), '  +
                                'MSG              TEXT (200), '  +
                                'ULTIMA_PASTA     TEXT, '  +
                                'JANELA_ESQUERDA  INTEGER, '  +
                                'JANELA_TOPO      INTEGER, '  +
                                'JANELA_LARGURA   INTEGER, '  +
                                'JANELA_ALTURA    INTEGER, '  +
                                'JANELA_MAXIMIZADA INTEGER DEFAULT 0 '  +
                                ' ); ');

   //Bancos criados até a versão 1.1 sem as preferências da tela
   MigrarTabelaConfig;

  Conexao.ExecSQL('CREATE TABLE IF NOT EXISTS LOG ( ' +
                                'CLASSE           TEXT (200), '  +
                                'MSG              TEXT (2000), '  +
                                'DT               TEXT (32) '  +
                                ' ); ');
end;

procedure TDMConfig.AdicionarColunasFaltantes(const Tabela: String; const Colunas, Definicoes: array of String);
var
  QryAux: TFDQuery;
  ColunasExistentes: TStringList;
  I: Integer;
begin
  //Migração idempotente: só adiciona as colunas que ainda não existem na tabela
  ColunasExistentes := TStringList.Create;
  QryAux := TFDQuery.Create(Nil);
  try
    ColunasExistentes.CaseSensitive := False;

    QryAux.Connection := Conexao;
    QryAux.Open('PRAGMA table_info(' + Tabela + ')');
    while not QryAux.Eof do
    begin
      ColunasExistentes.Add(QryAux.FieldByName('name').AsString);
      QryAux.Next;
    end;
    QryAux.Close;

    for I := Low(Colunas) to High(Colunas) do
    begin
      if ColunasExistentes.IndexOf(Colunas[I]) < 0 then
        Conexao.ExecSQL('ALTER TABLE ' + Tabela + ' ADD COLUMN ' + Colunas[I] + ' ' + Definicoes[I]);
    end;
  finally
    FreeAndNil(QryAux);
    FreeAndNil(ColunasExistentes);
  end;
end;

procedure TDMConfig.MigrarTabelaNF;
const
  //Colunas novas da tabela nf (versão 1.1) e suas definições
  ColunasNovas: array[0..6] of String = ('MODELO', 'TEM_IBSCBS', 'VBCIBSCBS', 'VIBSUF', 'VIBSMUN', 'VIBS', 'VCBS');
  DefColunas: array[0..6] of String = ('INTEGER', 'INTEGER DEFAULT 0', 'TEXT (30)', 'TEXT (30)', 'TEXT (30)', 'TEXT (30)', 'TEXT (30)');
begin
  AdicionarColunasFaltantes('nf', ColunasNovas, DefColunas);
end;

procedure TDMConfig.MigrarTabelaConfig;
const
  //Preferências da tela (Plano 4): última pasta e tamanho/posição/estado da janela
  ColunasNovas: array[0..5] of String = ('ULTIMA_PASTA', 'JANELA_ESQUERDA', 'JANELA_TOPO', 'JANELA_LARGURA',
                                         'JANELA_ALTURA', 'JANELA_MAXIMIZADA');
  DefColunas: array[0..5] of String = ('TEXT', 'INTEGER', 'INTEGER', 'INTEGER', 'INTEGER', 'INTEGER DEFAULT 0');
begin
  AdicionarColunasFaltantes('config', ColunasNovas, DefColunas);
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

    FFiltroModelo := FILTRO_MODELO_TODOS;

    Diretorio := System.SysUtils.GetCurrentDir + '\db';

    if not DirectoryExists(Diretorio) then
        CreateDir(Diretorio);

    Conexao.Connected := True;
end;

procedure TDMConfig.DeleteDados();
begin
    Conexao.ExecSQL('DELETE FROM nf ;');
end;

procedure TDMConfig.InserirNotaDB(const Numero, Chave, Data, Valor, ICMS, BC, XML: String;
  const Modelo: Integer; const TemIBSCBS: Boolean;
  const BCIBSCBS, IBSUF, IBSMun, IBS, CBS: String);
begin
    Query.Active := False;
    Query.SQL.Clear;

    Query.SQL.Add('insert into nf ( NUMERO, CHAVE, VALOR, DATA, BCICMS, VLICMS, XML, ');
    Query.SQL.Add('                 MODELO, TEM_IBSCBS, VBCIBSCBS, VIBSUF, VIBSMUN, VIBS, VCBS ) ');
    Query.SQL.Add('values( :NUMERO, :CHAVE, :VALOR, :DATA, :BCICMS, :VLICMS, :XML, ');
    Query.SQL.Add('        :MODELO, :TEM_IBSCBS, :VBCIBSCBS, :VIBSUF, :VIBSMUN, :VIBS, :VCBS )');
    Query.Params.ParamByName('NUMERO').AsString         := Trim(Numero);
    Query.Params.ParamByName('CHAVE').AsString          := Trim(Chave);
    Query.Params.ParamByName('VALOR').AsString          := Trim(Valor);
    Query.Params.ParamByName('DATA').AsString           := Trim(Data);
    Query.Params.ParamByName('BCICMS').AsString         := Trim(BC);
    Query.Params.ParamByName('VLICMS').AsString         := Trim(ICMS);
    Query.Params.ParamByName('XML').AsString            := Trim(XML);
    Query.Params.ParamByName('MODELO').AsInteger        := Modelo;
    if TemIBSCBS then
        Query.Params.ParamByName('TEM_IBSCBS').AsInteger := 1
    else
        Query.Params.ParamByName('TEM_IBSCBS').AsInteger := 0;
    Query.Params.ParamByName('VBCIBSCBS').AsString      := Trim(BCIBSCBS);
    Query.Params.ParamByName('VIBSUF').AsString         := Trim(IBSUF);
    Query.Params.ParamByName('VIBSMUN').AsString        := Trim(IBSMun);
    Query.Params.ParamByName('VIBS').AsString           := Trim(IBS);
    Query.Params.ParamByName('VCBS').AsString           := Trim(CBS);

    try
        Query.ExecSQL;
    except on e: Exception do
        raise Exception.Create('Erro na gravação de dados: '+ e.message);
    end;
end;

procedure TDMConfig.GravarNotas(DataSet: TDataSet);
var
    Marcador: TBookmark;
    FiltroAtivo: Boolean;
begin
    //Grava as notas do DataSet (grade de notas) na tabela nf, numa transação.
    //Deve ser chamada na thread principal: a conexão também é usada pela tela.
    //Grava todas as notas, mesmo com filtro ativo: o filtro de modelo é aplicado nas queries (FiltroModelo).
    //Em caso de erro desfaz tudo (inclusive a limpeza da tabela) e repassa a exceção.
    DataSet.DisableControls;
    try
        Marcador    := DataSet.GetBookmark;
        FiltroAtivo := DataSet.Filtered;
        try
            DataSet.Filtered := False;

            Conexao.StartTransaction;
            try
                DeleteDados;

                DataSet.First;
                while not DataSet.Eof do
                begin
                    InserirNotaDB(
                        DataSet.FieldByName('numero').AsString,
                        DataSet.FieldByName('chave').AsString,
                        DataSet.FieldByName('data').AsString,
                        FormatFloat('0.00', DataSet.FieldByName('vtotal').AsFloat),
                        FormatFloat('0.00', DataSet.FieldByName('vlicms').AsFloat),
                        FormatFloat('0.00', DataSet.FieldByName('bcicms').AsFloat),
                        DataSet.FieldByName('xml').AsString,
                        DataSet.FieldByName('modelo').AsInteger,
                        DataSet.FieldByName('tem_ibscbs').AsBoolean,
                        FormatFloat('0.00', DataSet.FieldByName('vbcibscbs').AsFloat),
                        FormatFloat('0.00', DataSet.FieldByName('vibsuf').AsFloat),
                        FormatFloat('0.00', DataSet.FieldByName('vibsmun').AsFloat),
                        FormatFloat('0.00', DataSet.FieldByName('vibs').AsFloat),
                        FormatFloat('0.00', DataSet.FieldByName('vcbs').AsFloat)
                    );

                    DataSet.Next;
                end;

                Conexao.Commit;
            except
                Conexao.Rollback;
                raise;
            end;
        finally
            DataSet.Filtered := FiltroAtivo;
            if (Marcador <> nil) and DataSet.BookmarkValid(Marcador) then
                DataSet.GotoBookmark(Marcador);
            DataSet.FreeBookmark(Marcador);
        end;
    finally
        DataSet.EnableControls;
    end;
end;

procedure TDMConfig.QryNotasBeforeOpen(DataSet: TDataSet);
begin
    //Aplica o filtro de modelo (0 = Todos) em QryNotas e QryNotasIBSCBS
    TFDQuery(DataSet).ParamByName('MODELO').AsInteger := FFiltroModelo;
end;

procedure TDMConfig.SetFiltroModelo(const Value: Integer);
begin
    if (Value <> FILTRO_MODELO_TODOS) and (Value <> FILTRO_MODELO_NFE) and (Value <> FILTRO_MODELO_NFCE) then
        raise Exception.Create('Filtro de modelo inválido: ' + IntToStr(Value));

    FFiltroModelo := Value;
end;

procedure TDMConfig.CreateLog(const Classe, Msg: String);
begin
    Query.Active := False;
    Query.SQL.Clear;

    Query.SQL.Add('insert into LOG ( CLASSE, MSG, DT ) ');
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

    Query.SQL.Add('insert into config ( SMTP, EMAIL, SENHA, PORTA, SSL, TSL, MSG ) ');
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

function TDMConfig.ConfigVazia: Boolean;
begin
    //A tabela config tem uma linha só (e-mail + preferências); pode ainda não existir
    Result := Conexao.ExecSQLScalar('SELECT COUNT(*) FROM config') = 0;
end;

function TDMConfig.GetPreferencias: TPreferencias;
var
    QryAux: TFDQuery;
begin
    Result.UltimaPasta      := '';
    Result.TemJanela        := False;
    Result.JanelaEsquerda   := 0;
    Result.JanelaTopo       := 0;
    Result.JanelaLargura    := 0;
    Result.JanelaAltura     := 0;
    Result.JanelaMaximizada := False;

    QryAux := TFDQuery.Create(Nil);
    try
        QryAux.Connection := Conexao;
        QryAux.Open('SELECT ULTIMA_PASTA, JANELA_ESQUERDA, JANELA_TOPO, JANELA_LARGURA, JANELA_ALTURA, ' +
                    'JANELA_MAXIMIZADA FROM config');
        if not QryAux.IsEmpty then
        begin
            Result.UltimaPasta := QryAux.FieldByName('ULTIMA_PASTA').AsString;

            //Janela só conta como salva com as quatro medidas preenchidas
            Result.TemJanela := (not QryAux.FieldByName('JANELA_ESQUERDA').IsNull) and
                                (not QryAux.FieldByName('JANELA_TOPO').IsNull) and
                                (not QryAux.FieldByName('JANELA_LARGURA').IsNull) and
                                (not QryAux.FieldByName('JANELA_ALTURA').IsNull) and
                                (QryAux.FieldByName('JANELA_LARGURA').AsInteger > 0) and
                                (QryAux.FieldByName('JANELA_ALTURA').AsInteger > 0);
            if Result.TemJanela then
            begin
                Result.JanelaEsquerda   := QryAux.FieldByName('JANELA_ESQUERDA').AsInteger;
                Result.JanelaTopo       := QryAux.FieldByName('JANELA_TOPO').AsInteger;
                Result.JanelaLargura    := QryAux.FieldByName('JANELA_LARGURA').AsInteger;
                Result.JanelaAltura     := QryAux.FieldByName('JANELA_ALTURA').AsInteger;
                Result.JanelaMaximizada := QryAux.FieldByName('JANELA_MAXIMIZADA').AsInteger = 1;
            end;
        end;
    finally
        FreeAndNil(QryAux);
    end;
end;

procedure TDMConfig.GravarUltimaPasta(const Pasta: String);
begin
    //Grava na linha da config (cria a linha se o e-mail ainda não foi configurado)
    if ConfigVazia then
        Conexao.ExecSQL('INSERT INTO config ( ULTIMA_PASTA ) VALUES ( :ULTIMA_PASTA )', [Pasta])
    else
        Conexao.ExecSQL('UPDATE config SET ULTIMA_PASTA = :ULTIMA_PASTA', [Pasta]);
end;

procedure TDMConfig.GravarJanela(const Esquerda, Topo, Largura, Altura: Integer; const Maximizada: Boolean);
var
    Estado: Integer;
begin
    //Posição e tamanho da janela no estado normal (restaurada) e se estava maximizada
    Estado := 0;
    if Maximizada then
        Estado := 1;

    if ConfigVazia then
        Conexao.ExecSQL('INSERT INTO config ( JANELA_ESQUERDA, JANELA_TOPO, JANELA_LARGURA, JANELA_ALTURA, ' +
                        'JANELA_MAXIMIZADA ) VALUES ( :ESQUERDA, :TOPO, :LARGURA, :ALTURA, :MAXIMIZADA )',
                        [Esquerda, Topo, Largura, Altura, Estado])
    else
        Conexao.ExecSQL('UPDATE config SET JANELA_ESQUERDA = :ESQUERDA, JANELA_TOPO = :TOPO, ' +
                        'JANELA_LARGURA = :LARGURA, JANELA_ALTURA = :ALTURA, JANELA_MAXIMIZADA = :MAXIMIZADA',
                        [Esquerda, Topo, Largura, Altura, Estado]);
end;

end.
