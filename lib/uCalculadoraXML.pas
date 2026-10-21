unit uCalculadoraXML;

interface

uses
  System.SysUtils,
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

  TCalculadoraXML = class
  private
    FCaminhoDiretorio: String;
    procedure SetCaminhoDiretorio(const Value: String);
    function FormataDataStr(const DataStr: String): String;


  public
    property CaminhoDiretorio : String read FCaminhoDiretorio write SetCaminhoDiretorio;
    procedure ProcessarXMLs;
    procedure GetTagValueFromXML(var CaminhoXML: string);
  end;

  //Converte um valor numérico do XML (sempre com ponto decimal), sem depender do idioma do Windows
  function XMLParaFloat(const Valor: String): Double;

  //Lê os dados de um XML de Nota Fiscal, sem acessar a tela
  function LerNotaXML(const CaminhoXML: String): TDadosNotaXML;

  //Data de emissão (ide/dhEmi, "aaaa-mm-dd...") como número aaaammdd, usado para ordenar a grade
  //por data real. Data fora do formato vale 0
  function DataParaOrdem(const DataEmissao: String): Integer;

  //Soma as notas do DataSet (só os registros visíveis pelo filtro ativo)
  function CalcularTotais(DataSet: TDataSet): TTotaisNotas;

  var
     ContadorXML, ErroNaLeitura: Integer;


implementation

uses

  {$IFDEF MSWINDOWS}
    Vcl.FileCtrl,
  {$ENDIF}
  Xml.XMLIntf,
  Xml.XMLDoc,
  System.IOUtils,
  System.Variants,
  Vcl.Dialogs,
  ProXML.FormPrincipal,
  System.Types,
  System.StrUtils;

var
  //Formato dos números no XML: ponto decimal e sem separador de milhar
  FormatoNumeroXML: TFormatSettings;

{ TCalculadoraXML }

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
  if Result = nil then
    raise Exception.Create('Tag ' + Nome + ' não encontrada no XML');
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
  //Sem nfeProc (ou sem NFe/infNFe/ide) o arquivo não é processado: a exceção vira
  //"Arquivo não processado" em ProcessarXMLs
  NodenfeProc := XMLDocument.ChildNodes.FindNode('nfeProc');
  if NodenfeProc = nil then
    raise Exception.Create('Tag nfeProc não encontrada no XML');
  NodeinfNFe  := NoFilhoObrigatorio(NoFilhoObrigatorio(NodenfeProc, 'NFe'), 'infNFe');
  NodeIde     := NoFilhoObrigatorio(NodeinfNFe, 'ide');
  //nNF obrigatório: tag ausente ou vazia gera exceção ("Arquivo não processado")
  Result.NumeroNF := Trim(NoFilhoObrigatorio(NodeIde, 'nNF').Text);
  if Result.NumeroNF = '' then
    raise Exception.Create('Tag nNF vazia no XML');

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

procedure TCalculadoraXML.GetTagValueFromXML(var CaminhoXML: string);
  var
    Dados: TDadosNotaXML;
    Numero, Modelo: Integer;
begin
    //Função que trabalha os dados do arquivo
    Dados := LerNotaXML(CaminhoXML);

    if Dados.FalhaModelo then
    begin
        FormPrincipal.Memo1.Lines.Add('XML ' + ExtractFileName(CaminhoXML) + ' - Falha ao recuperar modelo');
        Exit;
    end;

    if not Dados.ModeloValido then
    begin
        FormPrincipal.Memo1.Lines.Add('XML ' + ExtractFileName(CaminhoXML) + ' - modelo diferente de 55/65');
        Exit;
    end;

    //Aqui vamos verificar se a nota foi autorizada (cStat 100 ou 150)
    if Dados.Autorizada then
    begin
      //Conversões antes do Append para não deixar registro pela metade em caso de erro
      Numero := StrToInt(Dados.NumeroNF);
      Modelo := StrToInt(Dados.Modelo);

      //Aqui exibimos os registros no grid
      FormPrincipal.FDMemTable1.Append;
      try
          FormPrincipal.FDMemTable1.FieldByName('numero').AsInteger := Numero;
          FormPrincipal.FDMemTable1.FieldByName('modelo').AsInteger := Modelo;

          //Chave de 44 dígitos do Id da nota (D4), não o nome do arquivo
          FormPrincipal.FDMemTable1.FieldByName('chave').AsString := Dados.Chave;

          FormPrincipal.FDMemTable1.FieldByName('data').AsString := FormataDataStr(Copy(Dados.DataEmissao, 1, 10));
          //Data como aaaammdd: a grade ordena a coluna Data pela data real (etapa 4.5)
          FormPrincipal.FDMemTable1.FieldByName('data_ordem').AsInteger := DataParaOrdem(Dados.DataEmissao);

          //Na tela os valores aparecem com FormatarMoeda (pt-BR explícito, OnGetText dos campos)
          FormPrincipal.FDMemTable1.FieldByName('vlicms').AsFloat := Dados.vICMS;
          FormPrincipal.FDMemTable1.FieldByName('bcicms').AsFloat := Dados.vBC;
          FormPrincipal.FDMemTable1.FieldByName('vtotal').AsFloat := Dados.vNF;

          FormPrincipal.FDMemTable1.FieldByName('xml').AsString := CaminhoXML;

          //IBS/CBS (zerados quando a nota não tem o grupo IBSCBSTot)
          FormPrincipal.FDMemTable1.FieldByName('tem_ibscbs').AsBoolean := Dados.TemIBSCBS;
          FormPrincipal.FDMemTable1.FieldByName('vbcibscbs').AsFloat   := Dados.vBCIBSCBS;
          FormPrincipal.FDMemTable1.FieldByName('vibsuf').AsFloat      := Dados.vIBSUF;
          FormPrincipal.FDMemTable1.FieldByName('vibsmun').AsFloat     := Dados.vIBSMun;
          FormPrincipal.FDMemTable1.FieldByName('vibs').AsFloat        := Dados.vIBS;
          FormPrincipal.FDMemTable1.FieldByName('vcbs').AsFloat        := Dados.vCBS;

          FormPrincipal.FDMemTable1.Post;
      except
          //Não deixa a linha em edição: desfaz o Append e o arquivo vira "Arquivo não processado"
          FormPrincipal.FDMemTable1.Cancel;
          raise;
      end;

      //Só conta como processado depois que o registro foi gravado na grade
      ContadorXML := ContadorXML + 1;

      FormPrincipal.DataSource1.DataSet.First;
    end
    else
    begin
      // Aqui executamos caso a nota não esteja autorizada (cStat diferente de 100/150)
      if Dados.cStat = '' then
        FormPrincipal.Memo1.Lines.Add('Nota Fiscal ' +Dados.NumeroNF + ' - não autorizada (sem protocolo)')
      else
        FormPrincipal.Memo1.Lines.Add('Nota Fiscal ' +Dados.NumeroNF + ' - não autorizada (cStat ' + Dados.cStat + ')');
    end;
end;

function TCalculadoraXML.FormataDataStr(const DataStr: String): String;
var
  DateStr       : string;
  //FormattedDate : string;
  Dia           : string;
  Mes           : string;
  Ano           : string;

begin
  //Função que formata data no padrão dd/mm/yyyy
  Result:= '';

  // String de data no formato YYYY-MM-DD
  DateStr := DataStr;

  Ano := Copy(DateStr, 1, 4);
  Mes := Copy(DateStr, 6, 2);
  Dia := Copy(DateStr, 9, 2);

  // Exibir o resultado
  Result := Dia+'/'+Mes+'/'+Ano;
end;

procedure TCalculadoraXML.ProcessarXMLs;
var
  //files: TArray<string>;
  files: TStringDynArray;
  i: integer;
begin
  //Função que processar XMLS no diretorio
  ContadorXML           := 0;
  ErroNaLeitura         := 0;

  //Limpa a grade: cards e relatório refletem só a pasta atual
  if FormPrincipal.FDMemTable1.Active then
    FormPrincipal.FDMemTable1.EmptyDataSet
  else
    FormPrincipal.FDMemTable1.CreateDataSet;
  FormPrincipal.AtualizarTotais;

  //Pegando arquivos e jogando num array de nomes de arquivos
  files := TDirectory.GetFiles(CaminhoDiretorio + '\', '*.xml');

  try
    FormPrincipal.Gauge1.MaxValue := High(files);
  except
    begin
      FormPrincipal.Memo1.Lines.Add('Não encontrado arquivos XMLs no diretótio selecionado!');
      Exit;
    end;
  end;

    //Passando pelo Arraay com os nomes dos XMLs
    for  i := 0 to High(files) do
    begin
        ////Aqui executamos a função que faz a leitura dos dados do arquivo XML
        try
            GetTagValueFromXML(files[i]);
        except
            on E: EChaveNotaInvalida do
            begin
                //Decisão D4: linha no formato 5.20 do glossário, com o motivo 5.34 ou 5.35
                ErroNaLeitura:= ErroNaLeitura + 1;
                FormPrincipal.Memo1.Lines.Add(ExtractFileName(files[i]) + ': não foi possível ler o arquivo (' +
                                              E.Message + ').');
            end;
            on E: Exception do
            begin
                ErroNaLeitura:= ErroNaLeitura + 1;
                FormPrincipal.Memo1.Lines.Add('Arquivo não processado: ' + ExtractFileName(files[i]));
            end;
        end;
        FormPrincipal.Gauge1.Progress := FormPrincipal.Gauge1.Progress + 1;
    end;

    //Aqui vamos exibir a Soma (calculada a partir das notas da grade)
    FormPrincipal.AtualizarTotais;

    FormPrincipal.Memo1.Lines.Add('Foram processasdos ' + IntToSTr(ContadorXML) + ' Arquivos XMLs');
    FormPrincipal.Memo1.Lines.Add(IntToStr(ErroNaLeitura) + ' Arquivos com problemas para serem processados.');
end;

procedure TCalculadoraXML.SetCaminhoDiretorio(const Value: String);
begin
  FCaminhoDiretorio := Value;
end;

initialization
  FormatoNumeroXML := TFormatSettings.Create;
  FormatoNumeroXML.DecimalSeparator  := '.';
  FormatoNumeroXML.ThousandSeparator := #0;

end.
