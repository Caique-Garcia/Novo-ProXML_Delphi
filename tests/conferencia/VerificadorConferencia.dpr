program VerificadorConferencia;

{ Verificador da conferência de IBS/CBS (Plano 7, etapa 7.3), sem VCL.

    Lê as pastas com a mesma leitura do app (lib/uCalculadoraXML.pas, que chama lib/uConferenciaIBSCBS.pas)
    e grava as divergências no formato de tests/gabarito/divergencias.csv, para comparar com o gabarito
    (comparar.ps1). Grava também, ao lado do CSV, o bloco do log da conferência (arquivo -log.txt), com as
    linhas que o Resumo mostraria lendo as pastas juntas.

    Uso:
        VerificadorConferencia.exe <pasta> [<pasta> ...] [-o <saida.csv>]

    Cada pasta é lida sem recursão (só os *.xml do próprio nível), como no app e no gerar_divergencias.py.
    Sem -o, grava divergencias.csv no diretório atual. Instruções em tests/conferencia/README.md. }

{$APPTYPE CONSOLE}

uses
    Winapi.Windows,
    Winapi.ActiveX,
    System.SysUtils,
    System.Classes,
    System.Math,
    System.Generics.Collections,
    System.Generics.Defaults,
    Xml.Win.msxmldom,
    uConferenciaIBSCBS in '..\..\lib\uConferenciaIBSCBS.pas',
    uCalculadoraXML in '..\..\lib\uCalculadoraXML.pas';

type
    //Uma linha do CSV com a chave de ordenação do gerar_divergencias.py
    TLinhaCSV = record
        Modelo     : String;
        Numero     : Int64;
        ChaveFinal : String;
        Item       : Integer;   //'total' = 1000000, como no script
        Nivel      : String;
        Regra      : String;
        Tag        : String;
        Ordem      : Integer;   //ordem de leitura (o sort do Python é estável)
        Texto      : String;    //linha pronta do CSV
    end;

const
    COLUNAS = 'modelo;nNF;chave_final;item;nivel;tipo;regra;campo;valor_xml;valor_esperado;origem';
    ITEM_TOTAL_CSV = 1000000;

function CompararLinhasCSV(const A, B: TLinhaCSV): Integer;
begin
    //Mesma ordem do script: modelo, nNF (número), chave_final, item (número, total por último), nível,
    //regra e campo, com comparação ordinal de texto
    Result := CompareStr(A.Modelo, B.Modelo);
    if Result = 0 then
        Result := CompareValue(A.Numero, B.Numero);
    if Result = 0 then
        Result := CompareStr(A.ChaveFinal, B.ChaveFinal);
    if Result = 0 then
        Result := CompareValue(A.Item, B.Item);
    if Result = 0 then
        Result := CompareStr(A.Nivel, B.Nivel);
    if Result = 0 then
        Result := CompareStr(A.Regra, B.Regra);
    if Result = 0 then
        Result := CompareStr(A.Tag, B.Tag);
    if Result = 0 then
        Result := CompareValue(A.Ordem, B.Ordem);
end;

function CampoCSV(const Valor: String): String;
begin
    //Aspas só quando preciso, como o csv.writer do Python (QUOTE_MINIMAL)
    if (Pos(';', Valor) > 0) or (Pos('"', Valor) > 0) or (Pos(#13, Valor) > 0) or (Pos(#10, Valor) > 0) then
        Result := '"' + StringReplace(Valor, '"', '""', [rfReplaceAll]) + '"'
    else
        Result := Valor;
end;

function OrigemDaNota(const Caminho: String): String;
var
    Pasta: String;
begin
    //"sintetico" quando a pasta lida começa com "sinteticos"; senão "real" (mesma regra do script)
    Pasta := LowerCase(ExtractFileName(ExcludeTrailingPathDelimiter(ExtractFilePath(Caminho))));
    if Copy(Pasta, 1, Length('sinteticos')) = 'sinteticos' then
        Result := 'sintetico'
    else
        Result := 'real';
end;

procedure GravarUTF8(const Arquivo, Texto: String);
var
    Bytes : TBytes;
    Stream: TFileStream;
begin
    //UTF-8 sem BOM e com quebra de linha LF, como o gabarito
    Bytes := TEncoding.UTF8.GetBytes(Texto);
    Stream := TFileStream.Create(Arquivo, fmCreate);
    try
        if Length(Bytes) > 0 then
            Stream.WriteBuffer(Bytes[0], Length(Bytes));
    finally
        Stream.Free;
    end;
end;

function TipoDoLog(const Tipo: TTipoLinhaLog): String;
begin
    case Tipo of
        llSucesso: Result := '[Sucesso] ';
        llAviso  : Result := '[Aviso] ';
    else
        Result := '[Erro] ';
    end;
end;

procedure Executar;
var
    Pastas     : TStringList;
    Saida      : String;
    I, J       : Integer;
    Resultado  : TResultadoLeitura;
    Nota       : TNotaLida;
    D          : TDivergenciaIBSCBS;
    Linhas     : TList<TLinhaCSV>;
    L          : TLinhaCSV;
    Texto      : TStringBuilder;
    Origem     : String;
    ChaveFinal : String;
    Ordem      : Integer;
    Conferidas : array[0..1] of Integer;   //0 = 55, 1 = 65
    Filtro     : Integer;
    Modelo     : String;
    QtdNivel   : array[1..4] of Integer;
    Qtd, ComErro, SoAlerta, N: Integer;
    Arquivos   : Integer;
begin
    Pastas := TStringList.Create;
    Linhas := TList<TLinhaCSV>.Create(TComparer<TLinhaCSV>.Construct(CompararLinhasCSV));
    Resultado := TResultadoLeitura.Create;
    try
        Saida := 'divergencias.csv';
        I := 1;
        while I <= ParamCount do
        begin
            if ParamStr(I) = '-o' then
            begin
                Inc(I);
                Saida := ParamStr(I);
            end
            else
                Pastas.Add(ParamStr(I));
            Inc(I);
        end;
        if Pastas.Count = 0 then
        begin
            Writeln('Uso: VerificadorConferencia.exe <pasta> [<pasta> ...] [-o <saida.csv>]');
            ExitCode := 1;
            Exit;
        end;

        //Mesma leitura do app, pasta por pasta, acumulando as notas no mesmo resultado
        Arquivos := 0;
        for I := 0 to Pastas.Count - 1 do
        begin
            TCalculadoraXML.ProcessarXMLs(ExcludeTrailingPathDelimiter(Pastas[I]), Resultado, nil, nil);
            Inc(Arquivos, Resultado.ArquivosLidos);
        end;

        //Arquivos não processados (o script também pula esses arquivos, com um AVISO)
        for I := 0 to Resultado.Log.Count - 1 do
            if Resultado.Log[I].Tipo = llErro then
                Writeln(ErrOutput, 'AVISO: ' + Resultado.Log[I].Texto);

        Conferidas[0] := 0;
        Conferidas[1] := 0;
        Ordem := 0;
        for I := 0 to Resultado.Notas.Count - 1 do
        begin
            Nota := Resultado.Notas[I];
            if Nota.Dados.Conferencia.Situacao = scVazia then
                Continue;
            if Nota.Dados.Modelo = '55' then
                Inc(Conferidas[0])
            else
                Inc(Conferidas[1]);
            Origem := OrigemDaNota(Nota.Caminho);
            ChaveFinal := Copy(Nota.Dados.Chave, Length(Nota.Dados.Chave) - 5, 6);
            for J := 0 to High(Nota.Dados.Conferencia.Divergencias) do
            begin
                D := Nota.Dados.Conferencia.Divergencias[J];
                L.Modelo     := Nota.Dados.Modelo;
                L.Numero     := StrToInt64(Nota.Dados.NumeroNF);
                L.ChaveFinal := ChaveFinal;
                if D.Item = ITEM_TOTAL_IBSCBS then
                    L.Item := ITEM_TOTAL_CSV
                else
                    L.Item := D.Item;
                L.Nivel := IntToStr(D.Nivel);
                L.Regra := D.Regra;
                L.Tag   := D.Tag;
                Inc(Ordem);
                L.Ordem := Ordem;
                if D.Item = ITEM_TOTAL_IBSCBS then
                    L.Texto := 'total'
                else
                    L.Texto := IntToStr(D.Item);
                if D.Tipo = tdErro then
                    L.Texto := CampoCSV(L.Modelo) + ';' + CampoCSV(Nota.Dados.NumeroNF) + ';' + CampoCSV(ChaveFinal) + ';' +
                                          L.Texto + ';' + L.Nivel + ';Erro;'
                else
                    L.Texto := CampoCSV(L.Modelo) + ';' + CampoCSV(Nota.Dados.NumeroNF) + ';' + CampoCSV(ChaveFinal) + ';' +
                                          L.Texto + ';' + L.Nivel + ';Alerta;';
                L.Texto := L.Texto + CampoCSV(D.Regra) + ';' + CampoCSV(D.Tag) + ';' + CampoCSV(D.ValorXML) + ';' +
                                      CampoCSV(D.Esperado) + ';' + Origem;
                Linhas.Add(L);
            end;
        end;
        Linhas.Sort;

        Texto := TStringBuilder.Create;
        try
            Texto.Append(COLUNAS).Append(#10);
            for I := 0 to Linhas.Count - 1 do
                Texto.Append(Linhas[I].Texto).Append(#10);
            GravarUTF8(Saida, Texto.ToString);

            //Bloco do log da conferência (o que o Resumo mostraria depois de "N notas autorizadas carregadas.")
            Texto.Clear;
            for I := 0 to Resultado.LogConferencia.Count - 1 do
                Texto.Append(TipoDoLog(Resultado.LogConferencia[I].Tipo)).Append(Resultado.LogConferencia[I].Texto).Append(#10);
            GravarUTF8(ChangeFileExt(Saida, '') + '-log.txt', Texto.ToString);
        finally
            Texto.Free;
        end;

        //Resumo no console, no mesmo formato do gerar_divergencias.py
        Writeln(Format('Arquivos lidos=%d, autorizadas=%d, ignoradas=%d, com erro=%d',
                                      [Arquivos, Resultado.Autorizadas, Resultado.Ignoradas, Resultado.ComErro]));
        Writeln(Format('Notas conferidas: 55=%d, 65=%d, total=%d',
                                      [Conferidas[0], Conferidas[1], Conferidas[0] + Conferidas[1]]));
        for Filtro := 0 to 2 do
        begin
            case Filtro of
                0: Modelo := '55';
                1: Modelo := '65';
            else
                Modelo := 'Todos';
            end;
            Qtd := 0;
            for N := 1 to 4 do
                QtdNivel[N] := 0;
            ComErro  := 0;
            SoAlerta := 0;
            for I := 0 to Resultado.Notas.Count - 1 do
            begin
                Nota := Resultado.Notas[I];
                if (Modelo <> 'Todos') and (Nota.Dados.Modelo <> Modelo) then
                    Continue;
                for J := 0 to High(Nota.Dados.Conferencia.Divergencias) do
                begin
                    Inc(Qtd);
                    Inc(QtdNivel[Nota.Dados.Conferencia.Divergencias[J].Nivel]);
                end;
                case Nota.Dados.Conferencia.Situacao of
                    scErro  : Inc(ComErro);
                    scAlerta: Inc(SoAlerta);
                end;
            end;
            Writeln(Format('%-5s divergencias=%d (N1=%d, N2=%d, N3=%d, N4=%d); notas com Erro=%d, so com Alerta=%d',
                                          [Modelo, Qtd, QtdNivel[1], QtdNivel[2], QtdNivel[3], QtdNivel[4], ComErro, SoAlerta]));
        end;
        Writeln('Gravado em ' + Saida + ' e ' + ChangeFileExt(Saida, '') + '-log.txt');
    finally
        Resultado.Free;
        Linhas.Free;
        Pastas.Free;
    end;
end;

var
    ResultadoCOM: HResult;

begin
    //O TXMLDocument usa o MSXML (COM), como na thread de leitura do app
    ResultadoCOM := CoInitialize(nil);
    try
        try
            Executar;
        except
            on E: Exception do
            begin
                Writeln(ErrOutput, E.ClassName + ': ' + E.Message);
                ExitCode := 2;
            end;
        end;
    finally
        if Succeeded(ResultadoCOM) then
            CoUninitialize;
    end;
end.
