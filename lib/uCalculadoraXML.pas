unit uCalculadoraXML;

{ Leitura dos XMLs de Nota Fiscal (NF-e modelo 55 e NFC-e modelo 65) e cálculo dos totais.

  Plano 4, etapa 4.6: a unit não acessa a tela nem o banco. A leitura devolve um resultado
  (TResultadoLeitura: notas autorizadas, linhas do log e contadores) e avisa o progresso por
  callback. TThreadLeituraXML faz a leitura fora da thread principal; quem a cria recebe os avisos
  de progresso e o fim na thread principal (TThread.Queue e OnTerminate) e só então mexe na tela. }

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  Data.DB;

type
  //Dados lidos de um XML de Nota Fiscal (NF-e modelo 55 ou NFC-e modelo 65)
  TDadosNotaXML = record
    NumeroNF     : String;
    Chave        : String;   //chave de acesso: NFe/infNFe/@Id sem o prefixo "NFe" (44 dígitos, decisão D4)
    DataEmissao  : String;   //ide/dhEmi como veio no XML
    Modelo       : String;   //ide/mod
    FalhaModelo  : Boolean;  //não foi possível ler ide/mod
    ModeloValido : Boolean;  //modelo 55 ou 65
    cStat        : String;   //protNFe/infProt/cStat
    Autorizada   : Boolean;  //cStat 100 ou 150
    Homologacao  : Boolean;  //ide/tpAmb = 2 (ambiente de homologação); só informativo (glossário 5.29 a 5.32)
    Entrada      : Boolean;  //NF-e (55) com ide/tpNF = 0; só informativo (glossário 5.30, 5.31 e 5.33)
    vNF          : Double;
    vBC          : Double;
    vICMS        : Double;
    TemIBSCBS    : Boolean;  //existe o grupo total/IBSCBSTot
    vBCIBSCBS    : Double;
    vIBSUF       : Double;
    vIBSMun      : Double;
    vIBS         : Double;
    vCBS         : Double;
  end;

  //Totais das notas da grade (respeitando o filtro ativo)
  TTotaisNotas = record
    Quantidade       : Integer;
    ValorTotal       : Double;
    BaseICMS         : Double;
    ValorICMS        : Double;
    QuantidadeIBSCBS : Integer;
    BaseIBSCBS       : Double;
    IBSUF            : Double;
    IBSMun           : Double;
    IBS              : Double;
    CBS              : Double;
  end;

  //Chave de acesso inválida (decisão D4): a nota vira "não processada" com o motivo no log
  //(glossário 5.20, com os motivos 5.34 e 5.35)
  EChaveNotaInvalida = class(Exception);

  //Tipo da linha do log do Resumo: define o ícone e a cor na lista (tokens.md 5.8 e mockup resumo.html)
  TTipoLinhaLog = (llSucesso, llAviso, llErro);

  //Uma linha do log "Detalhes da leitura" (glossário 5.16 a 5.27 e 5.32 a 5.35)
  TLinhaLog = record
    Tipo : TTipoLinhaLog;
    Texto: String;
  end;

  //Nota autorizada lida de um XML: vai para a grade quando a leitura termina
  TNotaLida = record
    Caminho : String;    //caminho completo do XML
    Numero  : Integer;   //ide/nNF convertido
    Modelo  : Integer;   //ide/mod convertido
    Dados   : TDadosNotaXML;
  end;

  //Resultado da leitura de uma pasta. Preenchido pela thread de leitura e usado pela tela depois
  //que a thread termina (nunca pelas duas ao mesmo tempo)
  TResultadoLeitura = class
  public
    Pasta         : String;
    Notas         : TList<TNotaLida>;
    Log           : TList<TLinhaLog>;
    TotalArquivos : Integer;   //XMLs encontrados na pasta
    ArquivosLidos : Integer;   //XMLs já lidos (menor que o total quando a leitura foi cancelada)
    Autorizadas   : Integer;   //notas autorizadas carregadas
    Ignoradas     : Integer;   //não autorizadas ou de outro modelo
    ComErro       : Integer;   //não foi possível ler o arquivo
    Homologacao   : Integer;   //autorizadas com tpAmb 2 (somadas aos totais)
    Entrada       : Integer;   //NF-e autorizadas com tpNF 0 (somadas aos totais)
    Cancelado     : Boolean;   //a leitura parou antes do último arquivo
    DuracaoMs     : Cardinal;  //tempo da leitura
    constructor Create;
    destructor Destroy; override;
    procedure AdicionarLog(const Tipo: TTipoLinhaLog; const Texto: String);
  end;

  //Aviso de progresso: Lidos de Total arquivos, Arquivo = nome do arquivo que está sendo lido.
  //Chamado na thread de leitura (TThreadLeituraXML repassa para a thread principal)
  TAvisoProgressoLeitura = procedure(const Lidos, Total: Integer; const Arquivo: String) of object;

  //Pergunta à leitura se ela deve parar (cancelamento cooperativo, conferido a cada arquivo)
  TConsultaCancelamento = function: Boolean of object;

  TCalculadoraXML = class
  public
    //Lê os XMLs da pasta e preenche o Resultado (notas autorizadas, log e contadores).
    //Não acessa a tela nem o banco: pode rodar fora da thread principal (com o COM inicializado
    //na thread, por causa do TXMLDocument). Exceção fora da leitura de um arquivo (ex.: pasta que
    //não existe mais) sobe para quem chamou
    class procedure ProcessarXMLs(const Pasta: String; Resultado: TResultadoLeitura;
      const AoProgredir: TAvisoProgressoLeitura; const Cancelado: TConsultaCancelamento);
  end;

  { Leitura dos XMLs numa thread própria (Plano 4, etapa 4.6).
    - Cancelamento cooperativo: Terminate faz a leitura parar antes do próximo arquivo.
    - Progresso: AoProgredir é chamado na thread principal (TThread.Queue), no máximo a cada
      INTERVALO_PROGRESSO_MS e nunca com dois avisos na fila (1000+ arquivos não travam a tela).
    - Fim: o OnTerminate (thread principal) pega o resultado com ExtrairResultado.
    - A thread não acessa a tela nem o banco (a conexão FireDAC é da thread principal). }
  TThreadLeituraXML = class(TThread)
  private
    FPasta       : String;
    FResultado   : TResultadoLeitura;
    FErro        : String;
    FClasseErro  : String;
    FAoProgredir : TAvisoProgressoLeitura;
    FAvisoNaFila : Integer;    //1 = um aviso de progresso ainda espera a thread principal
    FUltimoAviso : Cardinal;
    procedure AvisarProgresso(const Lidos, Total: Integer; const Arquivo: String);
    function  Cancelada: Boolean;
  protected
    procedure Execute; override;
  public
    //Criada suspensa: quem cria liga o OnTerminate e chama Start
    constructor Create(const Pasta: String; const AoProgredir: TAvisoProgressoLeitura);
    destructor Destroy; override;
    //Entrega o resultado para quem chamou, que passa a ser o dono (só depois do fim da thread)
    function ExtrairResultado: TResultadoLeitura;
    //Erro fora da leitura de um arquivo (vazio se não houve)
    property Erro: String read FErro;
    property ClasseErro: String read FClasseErro;
  end;

  //Converte um valor numérico do XML (sempre com ponto decimal), sem depender do idioma do Windows
  function XMLParaFloat(const Valor: String): Double;

  //Lê os dados de um XML de Nota Fiscal, sem acessar a tela
  function LerNotaXML(const CaminhoXML: String): TDadosNotaXML;

  //Data de emissão (ide/dhEmi, "aaaa-mm-dd...") como número aaaammdd, usado para ordenar a grade
  //por data real. Data fora do formato vale 0
  function DataParaOrdem(const DataEmissao: String): Integer;

  //Data de emissão (ide/dhEmi, "aaaa-mm-dd...") no padrão dd/mm/aaaa da grade
  function FormatarDataNota(const DataEmissao: String): String;

  //Soma as notas do DataSet (só os registros visíveis pelo filtro ativo)
  function CalcularTotais(DataSet: TDataSet): TTotaisNotas;

  //Motivo de um erro de leitura para a linha 5.20 do log: mensagem numa linha só, sem o ponto final
  function MotivoDoErro(E: Exception): String;

const
  //Intervalo mínimo entre dois avisos de progresso da thread de leitura (milissegundos)
  INTERVALO_PROGRESSO_MS = 50;

implementation

uses
  Winapi.Windows,
  Winapi.ActiveX,
  Xml.XMLIntf,
  Xml.XMLDoc,
  System.IOUtils,
  System.Variants,
  System.SyncObjs,
  System.Types,
  System.StrUtils;

var
  //Formato dos números no XML: ponto decimal e sem separador de milhar
  FormatoNumeroXML: TFormatSettings;

function NFeAutorizada(const cStat: string): Boolean;
begin
  //Nota autorizada: cStat 100 (autorizado o uso) ou 150 (autorizado fora de prazo)
  Result := (cStat = '100') or (cStat = '150');
end;

function XMLParaFloat(const Valor: String): Double;
begin
  Result := StrToFloat(Trim(Valor), FormatoNumeroXML);
end;

function SoDigitos(const Texto: String; const Tamanho: Integer): Boolean;
var
  I: Integer;
begin
  //Texto com exatamente Tamanho caracteres, todos algarismos de 0 a 9
  Result := Length(Texto) = Tamanho;
  if not Result then
    Exit;
  for I := 1 to Length(Texto) do
    if not CharInSet(Texto[I], ['0'..'9']) then
      Exit(False);
end;

function DataParaOrdem(const DataEmissao: String): Integer;
var
  Texto: String;
begin
  //"2026-10-21T14:32:00-03:00" -> 20261021
  Texto := Copy(DataEmissao, 1, 4) + Copy(DataEmissao, 6, 2) + Copy(DataEmissao, 9, 2);
  if SoDigitos(Texto, 8) then
    Result := StrToInt(Texto)
  else
    Result := 0;
end;

function FormatarDataNota(const DataEmissao: String): String;
var
  DataStr : String;
begin
  //Formata a data no padrão dd/mm/aaaa a partir de "aaaa-mm-dd..." (mesma conta de antes da 4.6)
  DataStr := Copy(DataEmissao, 1, 10);
  Result  := Copy(DataStr, 9, 2) + '/' + Copy(DataStr, 6, 2) + '/' + Copy(DataStr, 1, 4);
end;

function ChaveDoId(NodeinfNFe: IXMLNode): String;
begin
  //Decisão D4: a chave vem do atributo Id de infNFe ("NFe" + 44 dígitos), não do nome do arquivo
  Result := '';
  if NodeinfNFe.HasAttribute('Id') then
    Result := Trim(VarToStr(NodeinfNFe.Attributes['Id']));
  if SameText(Copy(Result, 1, 3), 'NFe') then
    Delete(Result, 1, 3);

  //Glossário 5.34
  if not SoDigitos(Result, 44) then
    raise EChaveNotaInvalida.Create('a chave de acesso da nota (atributo Id de infNFe) não tem 44 dígitos');
end;

function NoFilho(Node: IXMLNode; const Nome: String): IXMLNode;
begin
  //Retorna o nó filho ou nil (também quando o pai não existe)
  Result := nil;
  if Node <> nil then
    Result := Node.ChildNodes.FindNode(Nome);
end;

function NoFilhoObrigatorio(Node: IXMLNode; const Nome: String): IXMLNode;
begin
  Result := NoFilho(Node, Nome);
  //Glossário 5.24 (vira o motivo da linha 5.20 do log)
  if Result = nil then
    raise Exception.Create('falta a tag ' + Nome);
end;

function TextoOpcional(Node: IXMLNode; const Nome: String): String;
var
  NodeTexto: IXMLNode;
begin
  //Texto da tag ou vazio quando ela (ou o grupo pai) não existe
  Result := '';
  NodeTexto := NoFilho(Node, Nome);
  if NodeTexto <> nil then
    Result := Trim(NodeTexto.Text);
end;

function ValorObrigatorio(Node: IXMLNode; const Nome: String): Double;
begin
  Result := XMLParaFloat(NoFilhoObrigatorio(Node, Nome).Text);
end;

function ValorOpcional(Node: IXMLNode; const Nome: String): Double;
var
  NodeValor: IXMLNode;
begin
  //Tag ausente (ou grupo pai ausente) vale 0
  Result := 0;
  NodeValor := NoFilho(Node, Nome);
  if NodeValor <> nil then
    Result := XMLParaFloat(NodeValor.Text);
end;

function LerNotaXML(const CaminhoXML: String): TDadosNotaXML;
var
  XMLDocument: IXMLDocument;
  NodenfeProc, NodeinfNFe, NodeprotNFe, NodeIde, NodeTotal, NodeICMSTot, NodeIBSCBSTot, NodegIBS : IXMLNode;
  NodeinfProt, NodechNFe : IXMLNode;
begin
  //Função que lê os dados do arquivo XML
  //XML fora da estrutura esperada (ex.: sem nfeProc) gera exceção
  Result.NumeroNF     := '';
  Result.Chave        := '';
  Result.DataEmissao  := '';
  Result.Modelo       := '';
  Result.FalhaModelo  := False;
  Result.ModeloValido := False;
  Result.cStat        := '';
  Result.Autorizada   := False;
  Result.Homologacao  := False;
  Result.Entrada      := False;
  Result.vNF          := 0;
  Result.vBC          := 0;
  Result.vICMS        := 0;
  Result.TemIBSCBS    := False;
  Result.vBCIBSCBS    := 0;
  Result.vIBSUF       := 0;
  Result.vIBSMun      := 0;
  Result.vIBS         := 0;
  Result.vCBS         := 0;

  XMLDocument := TXMLDocument.Create(Nil);

  //Aqui carregamos o arquivo XML no objeto XMLDocument
  XMLDocument.LoadFromFile(CaminhoXML);
  //Sem nfeProc (ou sem NFe/infNFe/ide) o arquivo não é processado: a exceção vira a linha 5.20
  //do log ("não foi possível ler o arquivo"), com o motivo do glossário (5.24 a 5.26)
  NodenfeProc := XMLDocument.ChildNodes.FindNode('nfeProc');
  if NodenfeProc = nil then
    raise Exception.Create('o arquivo não é uma Nota Fiscal com protocolo de autorização (falta a tag nfeProc)');
  NodeinfNFe  := NoFilhoObrigatorio(NoFilhoObrigatorio(NodenfeProc, 'NFe'), 'infNFe');
  NodeIde     := NoFilhoObrigatorio(NodeinfNFe, 'ide');
  //nNF obrigatório: tag ausente ou vazia gera exceção (arquivo não processado)
  Result.NumeroNF := Trim(NoFilhoObrigatorio(NodeIde, 'nNF').Text);
  if Result.NumeroNF = '' then
    raise Exception.Create('tag nNF vazia');

  //Tentando recuperar a data do XML
  try
    Result.DataEmissao := NodeIde.ChildValues['dhEmi'];
  except
    Result.DataEmissao := '0000-00-00';
  end;

  try
    Result.Modelo := NodeIde.ChildValues['mod'];
  except
    Result.FalhaModelo := True;
    Exit;
  end;

  Result.ModeloValido := (Result.Modelo = '55') or (Result.Modelo = '65');
  if not Result.ModeloValido then
    Exit;

  //Chave de acesso (decisão D4): Id sem 44 dígitos gera exceção ("não processada", motivo 5.34)
  Result.Chave := ChaveDoId(NodeinfNFe);

  //Aqui vamos pegar o cStat do protocolo de autorização.
  //nfeProc sem protNFe: nota sem protocolo (cStat vazio, não autorizada).
  //protNFe sem infProt/cStat é XML fora da estrutura esperada: gera exceção
  NodeprotNFe := NoFilho(NodenfeProc, 'protNFe');
  if NodeprotNFe = nil then
    Result.cStat := ''
  else
  begin
    NodeinfProt  := NoFilhoObrigatorio(NodeprotNFe, 'infProt');
    Result.cStat := Trim(NoFilhoObrigatorio(NodeinfProt, 'cStat').Text);

    //chNFe do protocolo só confere a chave (D4): diferente do Id, a nota não é processada (5.35).
    //Protocolo sem chNFe não é conferido
    NodechNFe := NoFilho(NodeinfProt, 'chNFe');
    if (NodechNFe <> nil) and (Trim(NodechNFe.Text) <> Result.Chave) then
      raise EChaveNotaInvalida.Create('a chave do protocolo de autorização (chNFe) é diferente da chave da nota');
  end;

  Result.Autorizada := NFeAutorizada(Result.cStat);
  if not Result.Autorizada then
    Exit;

  //Ambiente (tpAmb) e tipo da operação (tpNF): só informativos, para os avisos do Resumo
  //(glossário 5.29 a 5.33). Não mudam os totais nem os contadores; tag ausente não gera aviso.
  //Entrada vale só para a NF-e (modelo 55), como no glossário 5.30
  Result.Homologacao := TextoOpcional(NodeIde, 'tpAmb') = '2';
  Result.Entrada     := (Result.Modelo = '55') and (TextoOpcional(NodeIde, 'tpNF') = '0');

  //Totais do ICMS (obrigatórios)
  NodeTotal   := NoFilhoObrigatorio(NodeinfNFe, 'total');
  NodeICMSTot := NoFilhoObrigatorio(NodeTotal, 'ICMSTot');
  Result.vNF   := ValorObrigatorio(NodeICMSTot, 'vNF');
  Result.vBC   := ValorObrigatorio(NodeICMSTot, 'vBC');
  Result.vICMS := ValorObrigatorio(NodeICMSTot, 'vICMS');

  //Totais do IBS/CBS (Reforma Tributária). gIBS, gIBSUF, gIBSMun e gCBS são opcionais: ausentes valem 0
  NodeIBSCBSTot := NoFilho(NodeTotal, 'IBSCBSTot');
  if NodeIBSCBSTot <> nil then
  begin
    Result.TemIBSCBS := True;
    Result.vBCIBSCBS := ValorOpcional(NodeIBSCBSTot, 'vBCIBSCBS');

    NodegIBS := NoFilho(NodeIBSCBSTot, 'gIBS');
    Result.vIBSUF  := ValorOpcional(NoFilho(NodegIBS, 'gIBSUF'), 'vIBSUF');
    Result.vIBSMun := ValorOpcional(NoFilho(NodegIBS, 'gIBSMun'), 'vIBSMun');
    Result.vIBS    := ValorOpcional(NodegIBS, 'vIBS');

    Result.vCBS    := ValorOpcional(NoFilho(NodeIBSCBSTot, 'gCBS'), 'vCBS');
  end;
end;

function CalcularTotais(DataSet: TDataSet): TTotaisNotas;
var
  Marcador: TBookmark;
begin
  Result.Quantidade       := 0;
  Result.ValorTotal       := 0;
  Result.BaseICMS         := 0;
  Result.ValorICMS        := 0;
  Result.QuantidadeIBSCBS := 0;
  Result.BaseIBSCBS       := 0;
  Result.IBSUF            := 0;
  Result.IBSMun           := 0;
  Result.IBS              := 0;
  Result.CBS              := 0;

  if (DataSet = nil) or (not DataSet.Active) then
    Exit;

  DataSet.DisableControls;
  try
    //Guarda o registro corrente para voltar a ele no final
    Marcador := DataSet.GetBookmark;
    try
      DataSet.First;
      while not DataSet.Eof do
      begin
        Result.Quantidade := Result.Quantidade + 1;
        Result.ValorTotal := Result.ValorTotal + DataSet.FieldByName('vtotal').AsFloat;
        Result.BaseICMS   := Result.BaseICMS   + DataSet.FieldByName('bcicms').AsFloat;
        Result.ValorICMS  := Result.ValorICMS  + DataSet.FieldByName('vlicms').AsFloat;

        if DataSet.FieldByName('tem_ibscbs').AsBoolean then
        begin
          Result.QuantidadeIBSCBS := Result.QuantidadeIBSCBS + 1;
          Result.BaseIBSCBS := Result.BaseIBSCBS + DataSet.FieldByName('vbcibscbs').AsFloat;
          Result.IBSUF      := Result.IBSUF      + DataSet.FieldByName('vibsuf').AsFloat;
          Result.IBSMun     := Result.IBSMun     + DataSet.FieldByName('vibsmun').AsFloat;
          Result.IBS        := Result.IBS        + DataSet.FieldByName('vibs').AsFloat;
          Result.CBS        := Result.CBS        + DataSet.FieldByName('vcbs').AsFloat;
        end;

        DataSet.Next;
      end;
    finally
      if (Marcador <> nil) and DataSet.BookmarkValid(Marcador) then
        DataSet.GotoBookmark(Marcador);
      DataSet.FreeBookmark(Marcador);
    end;
  finally
    DataSet.EnableControls;
  end;
end;

function MotivoDoErro(E: Exception): String;
begin
  //Motivo da linha 5.20 do log: a mensagem da exceção numa linha só (as do MSXML vêm com quebras
  //de linha) e sem o ponto final, que já fecha a frase do log
  Result := StringReplace(E.Message, #13#10, ' ', [rfReplaceAll]);
  Result := StringReplace(Result, #13, ' ', [rfReplaceAll]);
  Result := StringReplace(Result, #10, ' ', [rfReplaceAll]);
  Result := StringReplace(Result, #9, ' ', [rfReplaceAll]);
  while Pos('  ', Result) > 0 do
    Result := StringReplace(Result, '  ', ' ', [rfReplaceAll]);
  Result := Trim(Result);
  if (Result <> '') and (Result[Length(Result)] = '.') then
    Delete(Result, Length(Result), 1);
end;

procedure LerArquivoXML(const CaminhoXML: String; Resultado: TResultadoLeitura);
var
  Dados  : TDadosNotaXML;
  Nota   : TNotaLida;
  Arquivo: String;
begin
  //Lê um XML e registra no resultado: nota autorizada, ignorada ou com erro, com a linha do log
  Arquivo := ExtractFileName(CaminhoXML);
  try
    Dados := LerNotaXML(CaminhoXML);

    if Dados.FalhaModelo then
    begin
      //Glossário 5.16: conta como "Com erro"
      Inc(Resultado.ComErro);
      Resultado.AdicionarLog(llErro, Arquivo + ': não foi possível identificar o modelo.');
      Exit;
    end;

    if not Dados.ModeloValido then
    begin
      //Glossário 5.17: conta como "Ignorada"
      Inc(Resultado.Ignoradas);
      Resultado.AdicionarLog(llAviso, Arquivo + ': modelo ' + Dados.Modelo +
                                      ' ignorado (o ProXML lê só os modelos 55 e 65).');
      Exit;
    end;

    //Aqui vamos verificar se a nota foi autorizada (cStat 100 ou 150)
    if not Dados.Autorizada then
    begin
      //Glossário 5.18 e 5.19: contam como "Ignorada"
      Inc(Resultado.Ignoradas);
      if Dados.cStat = '' then
        Resultado.AdicionarLog(llAviso, 'Nota Fiscal ' + Dados.NumeroNF +
                                        ': não autorizada (sem protocolo de autorização).')
      else
        Resultado.AdicionarLog(llAviso, 'Nota Fiscal ' + Dados.NumeroNF + ': não autorizada (cStat ' +
                                        Dados.cStat + ').');
      Exit;
    end;

    //Conversões antes de registrar a nota: número ou modelo inválido vira "não foi possível ler"
    Nota.Numero  := StrToInt(Dados.NumeroNF);
    Nota.Modelo  := StrToInt(Dados.Modelo);
    Nota.Caminho := CaminhoXML;
    Nota.Dados   := Dados;
    Resultado.Notas.Add(Nota);
    Inc(Resultado.Autorizadas);

    //Avisos da nota somada aos totais (glossário 5.32 e 5.33): não mudam os contadores
    if Dados.Homologacao then
    begin
      Inc(Resultado.Homologacao);
      Resultado.AdicionarLog(llAviso, 'Nota Fiscal ' + Dados.NumeroNF +
                                      ': homologação (tpAmb 2), somada aos totais.');
    end;
    if Dados.Entrada then
    begin
      Inc(Resultado.Entrada);
      Resultado.AdicionarLog(llAviso, 'Nota Fiscal ' + Dados.NumeroNF +
                                      ': NF-e de entrada (tpNF 0), somada aos totais.');
    end;
  except
    on E: Exception do
    begin
      //Glossário 5.20, com o motivo 5.24 a 5.27, 5.34 ou 5.35: conta como "Com erro"
      Inc(Resultado.ComErro);
      Resultado.AdicionarLog(llErro, Arquivo + ': não foi possível ler o arquivo (' + MotivoDoErro(E) + ').');
    end;
  end;
end;

{ TResultadoLeitura }

constructor TResultadoLeitura.Create;
begin
  inherited Create;
  Notas := TList<TNotaLida>.Create;
  Log   := TList<TLinhaLog>.Create;
end;

destructor TResultadoLeitura.Destroy;
begin
  Log.Free;
  Notas.Free;
  inherited;
end;

procedure TResultadoLeitura.AdicionarLog(const Tipo: TTipoLinhaLog; const Texto: String);
var
  Linha: TLinhaLog;
begin
  Linha.Tipo  := Tipo;
  Linha.Texto := Texto;
  Log.Add(Linha);
end;

{ TCalculadoraXML }

class procedure TCalculadoraXML.ProcessarXMLs(const Pasta: String; Resultado: TResultadoLeitura;
  const AoProgredir: TAvisoProgressoLeitura; const Cancelado: TConsultaCancelamento);
var
  Arquivos: TStringDynArray;
  Inicio  : Cardinal;
  I       : Integer;
begin
  //Função que processa os XMLs da pasta (só leitura: a tela recebe o resultado no fim)
  Inicio := GetTickCount;
  Resultado.Pasta := Pasta;
  try
    //Pegando arquivos e jogando num array de nomes de arquivos
    Arquivos := TDirectory.GetFiles(Pasta + '\', '*.xml');
    Resultado.TotalArquivos := Length(Arquivos);

    //Passando pelo array com os nomes dos XMLs
    for I := 0 to High(Arquivos) do
    begin
      //Cancelamento cooperativo: conferido antes de cada arquivo
      if Assigned(Cancelado) and Cancelado then
      begin
        Resultado.Cancelado := True;
        Break;
      end;

      if Assigned(AoProgredir) then
        AoProgredir(I, Resultado.TotalArquivos, ExtractFileName(Arquivos[I]));

      LerArquivoXML(Arquivos[I], Resultado);
      Resultado.ArquivosLidos := I + 1;
    end;
  finally
    Resultado.DuracaoMs := GetTickCount - Inicio;
  end;
end;

{ TThreadLeituraXML }

constructor TThreadLeituraXML.Create(const Pasta: String; const AoProgredir: TAvisoProgressoLeitura);
begin
  inherited Create(True);
  FreeOnTerminate := False;
  FPasta       := Pasta;
  FAoProgredir := AoProgredir;
  FResultado   := TResultadoLeitura.Create;
end;

destructor TThreadLeituraXML.Destroy;
begin
  //O resultado que não foi entregue (ExtrairResultado) é liberado junto com a thread
  inherited;
  FResultado.Free;
end;

function TThreadLeituraXML.ExtrairResultado: TResultadoLeitura;
begin
  Result     := FResultado;
  FResultado := nil;
end;

function TThreadLeituraXML.Cancelada: Boolean;
begin
  Result := Terminated;
end;

procedure TThreadLeituraXML.AvisarProgresso(const Lidos, Total: Integer; const Arquivo: String);
var
  Agora   : Cardinal;
  LidosQ  : Integer;
  TotalQ  : Integer;
  ArquivoQ: String;
begin
  //Roda na thread de leitura. O primeiro aviso sai sempre; os outros, no máximo a cada
  //INTERVALO_PROGRESSO_MS e só quando a thread principal já mostrou o anterior
  if not Assigned(FAoProgredir) then
    Exit;

  Agora := GetTickCount;
  if (Lidos > 0) and ((Agora - FUltimoAviso) < INTERVALO_PROGRESSO_MS) then
    Exit;
  if TInterlocked.CompareExchange(FAvisoNaFila, 1, 0) <> 0 then
    Exit;
  FUltimoAviso := Agora;

  //Cópias dos valores: o aviso roda depois, na thread principal
  LidosQ   := Lidos;
  TotalQ   := Total;
  ArquivoQ := Arquivo;
  Queue(
    procedure
    begin
      TInterlocked.Exchange(FAvisoNaFila, 0);
      FAoProgredir(LidosQ, TotalQ, ArquivoQ);
    end);
end;

procedure TThreadLeituraXML.Execute;
var
  ResultadoCOM: HResult;
begin
  NameThreadForDebugging('ProXML.LeituraXML');

  //Liberada sem ter sido iniciada (a VCL a inicia já terminada): não lê nada
  if Terminated then
    Exit;

  //O TXMLDocument usa o MSXML (COM): a thread inicializa o COM para si e encerra no fim
  ResultadoCOM := CoInitialize(nil);
  try
    try
      TCalculadoraXML.ProcessarXMLs(FPasta, FResultado, AvisarProgresso, Cancelada);
    except
      on E: Exception do
      begin
        //Erro fora da leitura de um arquivo (ex.: pasta apagada): a tela mostra na thread principal
        FClasseErro := E.ClassName;
        FErro       := E.Message;
      end;
    end;
  finally
    if Succeeded(ResultadoCOM) then
      CoUninitialize;
  end;
end;

initialization
  FormatoNumeroXML := TFormatSettings.Create;
  FormatoNumeroXML.DecimalSeparator  := '.';
  FormatoNumeroXML.ThousandSeparator := #0;

end.
