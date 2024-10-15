unit uCalculadoraXML;

interface

type
  TCalculadoraXML = class
  private
    FValorTotal: String;
    FValorBaseICMS: String;
    FValorICMS: String;
    FCaminhoDiretorio: String;
    FValorTotalFloat: Double;
    FValorTotalBCFloat: Double;
    FValorTotalICMSFloat: Double;
    procedure SetValorTotal(const Value: String);
    procedure SetValorBaseICMS(const Value: String);
    procedure SetValorICMS(const Value: String);
    procedure SetCaminhoDiretorio(const Value: String);
    procedure SetValorTotalFloat(const Value: Double);
    procedure SetValorTotalBCFloat(const Value: Double);
    procedure SetValorTotalICMSFloat(const Value: Double);
    function FormataDataStr(const DataStr: String): String;


  public
    property ValorTotal : String read FValorTotal write SetValorTotal;
    property ValorTotalFloat : Double read FValorTotalFloat Write SetValorTotalFloat;
    property ValorTotalBCFloat : Double read FValorTotalBCFloat Write SetValorTotalBCFloat;
    property ValorTotalICMSFloat : Double read FValorTotalICMSFloat Write SetValorTotalICMSFloat;
    property ValorICMS : String read FValorICMS write SetValorICMS;
    property ValorBaseICMS : String read FValorBaseICMS write SetValorBaseICMS;
    property CaminhoDiretorio : String read FCaminhoDiretorio write SetCaminhoDiretorio;
    procedure ProcessarXMLs;
    procedure GetTagValueFromXML(var CaminhoXML: string);
  end;

  var
     AValorTotal: String;
     ContadorXML, ContadorXMLErro, ErroNaLeitura: Integer;


implementation

uses
  Vcl.FileCtrl,
  Xml.XMLIntf,
  Xml.XMLDoc,
  System.IOUtils,
  System.SysUtils,
  Vcl.Dialogs,
  ProXML.FormPrincipal,
  System.Types,
  DB;

{ TCalculadoraXML }

procedure TCalculadoraXML.GetTagValueFromXML(var CaminhoXML: string);
  var
    XMLDocument: IXMLDocument;
    NodeinfNFe, NodeprotNFe, NodeIde : IXMLNode;
    BValorString, TagAutorizado, NumeroNF, DataEm, ModeloXML: String;
    AValorFloat, BValorFloat, AValorFloatBC, AValorFloatICMS: Double;
    posicao: Integer;
begin
    //Função que trabalha os dados do arquivo
   XMLDocument := TXMLDocument.Create(Nil);

  try
    //Aqui carregamos o arquivo XML no objeto XMLDocument
    XMLDocument.LoadFromFile(CaminhoXML);
    NodeIde  := XMLDocument.ChildNodes.FindNode('nfeProc').ChildNodes.FindNode('NFe').ChildNodes.FindNode('infNFe').ChildNodes.FindNode('ide');
    NumeroNF := NodeIde.ChildValues['nNF'];

    //Tentando recuperar a data do XML
    try
      DataEm := NodeIde.ChildValues['dhEmi'];
    except
      DataEm := '0000-00-00';
    end;

    try
      ModeloXML := NodeIde.ChildValues['mod'];
      if ModeloXML <> '65' then
      begin
          FormPrincipal.Memo1.Lines.Add('XML ' + ExtractFileName(CaminhoXML) + ' - modelo diferente de 65');
          Exit;
      end;

    except on e: Exception do
        begin
            FormPrincipal.Memo1.Lines.Add('XML ' + ExtractFileName(CaminhoXML) + ' - Falha ao recuperar modelo');
            Exit;
        end;
    end;

    //Aqui vamos tentar pegar o Valor da Tag de Autorização
    NodeprotNFe := XMLDocument.ChildNodes.FindNode('nfeProc').ChildNodes.FindNode('protNFe');
    try
      TagAutorizado := NodeprotNFe.ChildNodes.FindNode('infProt').ChildValues['xMotivo'];
    except
      //Caso não consiga acessar o nó atribui vazio
      TagAutorizado := '';
    end;


    //Aqui vamos verificar se existe a tag de autorização no XML
    if TagAutorizado = 'Autorizado o uso da NF-e' then
    begin

      //Aqui Selecionamos e recuperando o valor da tag(nó)
      NodeinfNFe := XMLDocument.ChildNodes.FindNode('nfeProc').ChildNodes.FindNode('NFe').ChildNodes.FindNode('infNFe');
      AValorFloat := NodeinfNFe.ChildNodes.FindNode('total').ChildNodes.FindNode('ICMSTot').ChildValues['vNF'];

      ContadorXML := ContadorXML + 1;
      BValorFloat := AValorFloat/100;
      BValorString := FloatToStrF(BValorFloat, ffFixed, 15, 2);

      //Aqui Vamos passar pra variavel global o valor somado
      ValorTotalFloat := ValorTotalFloat + BValorFloat;


      //Aqui estamos calculando o calor da base de ICMS
      AValorFloatBC := NodeinfNFe.ChildNodes.FindNode('total').ChildNodes.FindNode('ICMSTot').ChildValues['vBC'];
      AValorFloatBC := AValorFloatBC/100;

      ValorTotalBCFloat := ValorTotalBCFloat + AValorFloatBC;

      //Aqui estamos calculando o valor do ICMS
      AValorFloatICMS := NodeinfNFe.ChildNodes.FindNode('total').ChildNodes.FindNode('ICMSTot').ChildValues['vICMS'];
      AValorFloatICMS := AValorFloatICMS/100;

      ValorTotalICMSFloat := ValorTotalICMSFloat + AValorFloatICMS;

      posicao := Pos('-nfe', ExtractFileName(CaminhoXML));

      //Aqui exibimos os registros no grid
      FormPrincipal.FDMemTable1.Append;

      FormPrincipal.FDMemTable1.FieldByName('numero').AsInteger := StrToInt(NumeroNF);
      FormPrincipal.FDMemTable1.FieldByName('chave').AsString := Copy(ExtractFileName(CaminhoXML), 1, posicao - 1);;

      FormPrincipal.FDMemTable1.FieldByName('data').AsString := FormataDataStr(Copy(DataEm, 1, 10));

      TFloatField(FormPrincipal.FDMemTable1.FieldByName('vlicms')).DisplayFormat := '#,##0.00';
      FormPrincipal.FDMemTable1.FieldByName('vlicms').AsFloat := AValorFloatICMS;

      TFloatField(FormPrincipal.FDMemTable1.FieldByName('bcicms')).DisplayFormat := '#,##0.00';
      FormPrincipal.FDMemTable1.FieldByName('bcicms').AsFloat := AValorFloatBC;

      TFloatField(FormPrincipal.FDMemTable1.FieldByName('vtotal')).DisplayFormat := '#,##0.00';
      FormPrincipal.FDMemTable1.FieldByName('vtotal').AsFloat := BValorFloat;

      FormPrincipal.FDMemTable1.FieldByName('xml').AsString := CaminhoXML;

      FormPrincipal.FDMemTable1.Post;
      FormPrincipal.DataSource1.DataSet.First;
    end
    else
    begin
      // Aqui executamos caso o XMl não tenha a tag de autorização
      ContadorXMLErro := ContadorXMLErro +1;
      FormPrincipal.Memo1.Lines.Add('NFCe ' +NumeroNF + ' - XML sem Tag de Autorização');
    end;

  finally
    //XMLDocument.Free;
  end;
end;

function TCalculadoraXML.FormataDataStr(const DataStr: String): String;
var
  DateStr       : string;
  FormattedDate : string;
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
  AValorTotal, AValorTotalBC, AValorTotalICMS: String;
begin
  //Função que processar XMLS no diretorio
  ValorTotalFloat       := 0.00;
  ValorTotalBCFloat     := 0.00;
  ValorTotalICMSFloat   := 0.00;
  ContadorXML           := 0;
  ErroNaLeitura         := 0;
  ValorTotal            := '0.00';


  //Pegando arquivos e jogando num array de nomes de arquivos
  files := TDirectory.GetFiles(CaminhoDiretorio + '\', '*.xml');

  FormPrincipal.Gauge1.MaxValue := High(files);

    //Passando pelo Arraay com os nomes dos XMLs
    for  i := 0 to High(files) do
    begin
        ////Aqui executamos a função que faz a leitura dos dados do arquivo XML
        try
            GetTagValueFromXML(files[i]);
        except
            ErroNaLeitura:= ErroNaLeitura + 1;
            FormPrincipal.Memo1.Lines.Add('Arquivo não processado: ' + ExtractFileName(files[i]));
        end;
        FormPrincipal.Gauge1.Progress := FormPrincipal.Gauge1.Progress + 1;
    end;

    //Aqui estamos transformando os valores Double em String
    AValortotal := FloatToStrF(ValorTotalFloat, ffFixed, 15, 2);
    AValorTotalBC := FloatToStrF(ValorTotalBCFloat, ffFixed, 15, 2);
    AValorTotalICMS := FloatToStrF(ValorTotalICMSFloat, ffFixed, 15, 2);;

    //Aqui vamos exibir a Soma
    FormPrincipal.LabelValorTotal.Caption := 'R$ ' +AValorTotal;
    FormPrincipal.LabelbaseICMS.Caption := 'R$ ' +AValorTotalBC;
    FormPrincipal.LabelValorICMS.Caption := 'R$ ' +AValorTotalICMS;

    FormPrincipal.Memo1.Lines.Add('Foram processasdos ' + IntToSTr(ContadorXML) + ' Arquivos XMLs');
    FormPrincipal.Memo1.Lines.Add(IntToStr(ErroNaLeitura) + ' Arquivos com problemas para serem processados.');
end;

procedure TCalculadoraXML.SetCaminhoDiretorio(const Value: String);
begin
  FCaminhoDiretorio := Value;
end;

procedure TCalculadoraXML.SetValorBaseICMS(const Value: String);
begin
  FValorBaseICMS := Value;
end;

procedure TCalculadoraXML.SetValorICMS(const Value: String);
begin
  FValorICMS := Value;
end;

procedure TCalculadoraXML.SetValorTotal(const Value: String);
begin
  FValorTotal := Value;
end;

procedure TCalculadoraXML.SetValorTotalBCFloat(const Value: Double);
begin
  FValorTotalBCFloat := Value;
end;

procedure TCalculadoraXML.SetValorTotalFloat(const Value: Double);
begin
  FValorTotalFloat := Value;
end;

procedure TCalculadoraXML.SetValorTotalICMSFloat(const Value: Double);
begin
  FValorTotalICMSFloat := Value;
end;

end.
