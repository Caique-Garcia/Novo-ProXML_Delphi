unit uConferenciaIBSCBS;

{ Conferência dos cálculos de IBS/CBS das notas autorizadas (Plano 7, etapa 7.3).

  - A unit não acessa a tela, o banco nem o XML: recebe os dados já lidos (TNotaIBSCBS, montada pelo
    uCalculadoraXML na thread de leitura) e devolve as divergências e a situação da nota.
  - Regras: docs/planos/plano-7-regras-ibs-cbs.md (níveis 1 a 4, seção 5.1 do Simples Nacional e casos
    sem conferência), com as decisões D1 a D24 na opção (a). A implementação de referência é o
    tests/gabarito/gerar_divergencias.py: esta unit deve produzir as mesmas linhas do divergencias.csv.
  - Textos das linhas do log e da coluna Campo do relatório: glossário, seções 17 e 18.
  - Valores: guardados como inteiros em décimos de milésimo (4 casas, ESCALA_IBSCBS) e calculados com
    inteiros de 128 bits, sem ponto flutuante. Os valores calculados são arredondados como o
    ROUND_HALF_UP do script (metade para longe do zero).
  - Tolerância: R$ 0,01 nos níveis 1 e 3, zero no nível 2 (D5 e D17) e 0,0001 nas alíquotas.
  - Fontes: NT 2025.002-RTC v1.53, NT 2026.005 v1.00 (Simples Nacional), NT 2026.008 v1.01 e tabela de
    CST/cClassTrib do IT 2025.002 v1.71 (constantes geradas de tests/gabarito/tabela_cst_ibscbs.csv e
    tabela_cclasstrib.csv). Quando a tabela ou a NT mudar, gere as constantes de novo e atualize as
    versões abaixo. }

{$OVERFLOWCHECKS OFF}
{$RANGECHECKS OFF}

interface

uses
    System.SysUtils;

const
    //Versões das fontes usadas pela conferência (glossário 17.11 e 18.25)
    VERSAO_NT_2025_002       = '1.53';
    VERSAO_NT_2026_005       = '1.00';
    VERSAO_NT_2026_008       = '1.01';
    VERSAO_TABELA_CCLASSTRIB = '1.71';

    //Os valores da conferência são inteiros em décimos de milésimo: 1,2345 = 12345
    ESCALA_IBSCBS = 10000;

    //Item das divergências do nível 2 (totais da nota)
    ITEM_TOTAL_IBSCBS = 0;

type
    //Esferas do IBS/CBS no item e no total
    TEsferaIBSCBS = (esIBSUF, esIBSMun, esCBS);

    //Erro (níveis 1 e 2) ou Alerta (níveis 3 e 4)
    TTipoDivergenciaIBSCBS = (tdErro, tdAlerta);

    //Situação da nota na conferência (glossário 16.2): vazia = nota sem IBS/CBS. Erro prevalece sobre Alerta
    TSituacaoConferenciaIBSCBS = (scVazia, scOK, scAlerta, scErro);

    //Grupo de uma esfera do item: gIBSCBS/gIBSUF, gIBSMun ou gCBS
    TEsferaItemIBSCBS = record
        Presente    : Boolean;
        pAliq       : Int64;     //pIBSUF, pIBSMun ou pCBS
        vTributo    : Int64;     //vIBSUF, vIBSMun ou vCBS
        TemRed      : Boolean;   //gRed
        pRedAliq    : Int64;
        pAliqEfet   : Int64;
        TemDif      : Boolean;   //gDif
        pDif        : Int64;
        vDif        : Int64;
        TemDevTrib  : Boolean;   //gDevTrib
        TempDevTrib : Boolean;   //pDevTrib informado (é 0-1 no grupo)
        pDevTrib    : Int64;
        vDevTrib    : Int64;
        TemALCZFM   : Boolean;   //só na CBS: gALCZFMCBS
    end;

    //Campos do item usados na composição da base do nível 3 (NT UB16-10 e LC 214, art. 12)
    TComposicaoBaseIBSCBS = record
        vProd        : Int64;
        vFrete       : Int64;
        vSeg         : Int64;
        vOutro       : Int64;
        vDesc        : Int64;
        vII          : Int64;
        vIS          : Int64;
        vICMS        : Int64;    //soma do vICMS do grupo ICMS (ICMS00, ICMS20 etc.)
        vFCP         : Int64;
        vICMSMono    : Int64;
        vICMSUFDest  : Int64;
        vFCPUFDest   : Int64;
        vISSQN       : Int64;
        vPIS         : Int64;    //soma do vPIS do grupo PIS
        vCOFINS      : Int64;
        TemPISST     : Boolean;
        SomaPISST    : Boolean;  //indSomaPISST = 1: o PIS-ST não sai da base
        vPISST       : Int64;
        TemCOFINSST  : Boolean;
        SomaCOFINSST : Boolean;
        vCOFINSST    : Int64;
    end;

    //Item com det/imposto/IBSCBS
    TItemIBSCBS = record
        NumeroItem          : Integer;   //det/@nItem
        CST                 : String;
        cClassTrib          : String;
        TemgIBSCBS          : Boolean;
        vBC                 : Int64;     //gIBSCBS/vBC (0 sem gIBSCBS)
        Esferas             : array[TEsferaIBSCBS] of TEsferaItemIBSCBS;
        vIBS                : Int64;     //gIBSCBS/vIBS
        TemTribRegular      : Boolean;   //gIBSCBS/gTribRegular
        pAliqEfetReg        : array[TEsferaIBSCBS] of Int64;
        vTribReg            : array[TEsferaIBSCBS] of Int64;
        TemTribCompraGov    : Boolean;   //gIBSCBS/gTribCompraGov
        vCredPresIBS        : Int64;     //gCredPresOper/gIBSCredPres/vCredPres
        vCredPresCondSusIBS : Int64;
        vCredPresCBS        : Int64;     //gCredPresOper/gCBSCredPres/vCredPres
        vCredPresCondSusCBS : Int64;
        TemCredPresIBSZFM   : Boolean;   //gCredPresIBSZFM
        TemgTribSN          : Boolean;   //gTribSN (NT 2026.005)
        TemgIBSSN           : Boolean;
        TemgCBSSN           : Boolean;
        vIBSSN              : Int64;     //gTribSN/gIBSSN/vIBSSN (subgrupo ausente vale 0)
        vCBSSN              : Int64;
        TemComposicao       : Boolean;   //composição lida (só quando o nível 3 roda no item)
        Composicao          : TComposicaoBaseIBSCBS;
    end;

    //Grupo total/IBSCBSTot. Subgrupos ausentes valem 0
    TTotalIBSCBS = record
        Presente            : Boolean;
        vBCIBSCBS           : Int64;
        vDif                : array[TEsferaIBSCBS] of Int64;
        vDevTrib            : array[TEsferaIBSCBS] of Int64;
        vTributo            : array[TEsferaIBSCBS] of Int64;   //vIBSUF, vIBSMun e vCBS
        vIBS                : Int64;
        vCredPresIBS        : Int64;
        vCredPresCondSusIBS : Int64;
        vCredPresCBS        : Int64;
        vCredPresCondSusCBS : Int64;
        TemgTribSN          : Boolean;
        vIBSSN              : Int64;
        vCBSSN              : Int64;
        TemgMono            : Boolean;
        TemgEstornoCred     : Boolean;
    end;

    //Dados de uma nota autorizada para a conferência
    TNotaIBSCBS = record
        NumeroNF     : String;   //ide/nNF
        Modelo       : String;   //ide/mod (55 ou 65)
        DataEmissao  : String;   //ide/dhEmi como veio no XML (vazio se ausente)
        finNFe       : String;   //vazio vale 1
        tpNFCredito  : String;
        UFEmitente   : String;   //emit/enderEmit/UF
        TemCompraGov : Boolean;  //ide/gCompraGov
        pRedutor     : Int64;    //ide/gCompraGov/pRedutor
        Itens        : TArray<TItemIBSCBS>;   //só os itens com IBSCBS
        Total        : TTotalIBSCBS;
    end;

    //Uma divergência (uma linha do log, do relatório e do gabarito)
    TDivergenciaIBSCBS = record
        Item            : Integer;  //det/@nItem; ITEM_TOTAL_IBSCBS nas divergências do nível 2
        Nivel           : Integer;  //1 a 4
        Tipo            : TTipoDivergenciaIBSCBS;
        Regra           : String;   //código da regra (N1-vIBSUF, N2-vCBS, N3-vBC, N4-pRedAliq...)
        Tag             : String;   //caminho da tag, como na coluna campo do divergencias.csv
        Campo           : String;   //nome curto e tag para o relatório (glossário 18.C, P7-13 e P7-16)
        ValorXML        : String;   //valor no XML como no gabarito (ponto decimal, ausente/presente)
        Esperado        : String;   //valor esperado como no gabarito
        ValorXMLExibido : String;   //valor no XML para o relatório (glossário 18.20)
        EsperadoExibido : String;
        TextoLog        : String;   //linha do log do Resumo (glossário 17.1 a 17.20a)
    end;

    //Casos sem conferência (D9, D14 e D22; glossário 17.21 e 17.22)
    TMotivoSemConferenciaIBSCBS = (
        msMonofasica,       //item com CST 620
        msTransfCredito,    //item com CST 800
        msAjusteZFM,        //item com CST 810
        msAjusteCompet,     //item com CST 811
        msCompraGov,        //item com gTribCompraGov
        msCredPresZFM,      //item com gCredPresIBSZFM
        msDevolucao,        //nota com finNFe 4
        msOutraFinalidade,  //nota com finNFe 2, 3, 5 ou 6 (D3)
        msNotaCredito,      //nota com tpNFCredito 03, 04 ou 06
        msAliquotaCBSAno,   //ano sem alíquota da CBS fixada em lei (D8)
        msAliquotaIBSAno,   //ano sem alíquota do IBS fixada em lei (D8)
        msTotalMono,        //IBSCBSTot/gMono
        msTotalEstorno);    //IBSCBSTot/gEstornoCred

    TItemSemConferenciaIBSCBS = record
        Item   : Integer;   //det/@nItem; ITEM_TOTAL_IBSCBS quando o motivo é da nota
        Motivo : TMotivoSemConferenciaIBSCBS;
    end;

    //Resultado da conferência de uma nota
    TConferenciaIBSCBS = record
        Situacao            : TSituacaoConferenciaIBSCBS;
        Divergencias        : TArray<TDivergenciaIBSCBS>;   //na ordem em que as regras rodam
        QuantidadeErros     : Integer;
        QuantidadeAlertas   : Integer;
        SemConferencia      : TArray<TItemSemConferenciaIBSCBS>;
        TextoSemConferencia : String;    //linha 17.21 do log (vazia quando não há caso sem conferência)
        SimplesNacional     : Boolean;   //algum item com gTribSN e sem gIBSCBS (D22, glossário 16.5a e 17.23b)
    end;

    //Confere uma nota autorizada. Nota sem IBS/CBS (nenhum item com IBSCBS e sem IBSCBSTot) volta com a
    //situação vazia (fora da conferência)
    function ConferirNotaIBSCBS(const Nota: TNotaIBSCBS): TConferenciaIBSCBS;

    //O nível 3 (base de cálculo) roda neste item? Quem lê o XML só precisa ler a composição nesse caso
    function ItemTemNivel3IBSCBS(const TemgIBSCBS: Boolean; const CST, finNFe: String): Boolean;

    //Converte um número do XML (ponto decimal, sem milhar) em décimos de milésimo, sem ponto flutuante.
    //Texto vazio vale 0. Mais de 4 casas: arredondado na 4ª (ROUND_HALF_UP). Falso se o texto não é um
    //número nesse formato
    function TextoParaValorIBSCBS(const Texto: String; out Valor: Int64): Boolean;

    //Valor no formato do gabarito: ponto decimal, 2 ou 4 casas ("10.00", "0.9000")
    function FormatarValorGabaritoIBSCBS(const Valor: Int64; const Casas: Integer): String;

    //Linha de resumo da conferência (glossário 17.23, 17.23a e 17.23b)
    function TextoResumoConferenciaIBSCBS(const Conferidas, ComErro, ComAlerta, Simples: Integer): String;

    //Texto da situação para a grade e o CSV (glossário 16.2 e 16.11)
    function TextoSituacaoIBSCBS(const Situacao: TSituacaoConferenciaIBSCBS): String;

implementation

type
    //Inteiro de 128 bits em complemento de dois (as contas do nível 1 passam de 64 bits com valores grandes)
    TInt128 = record
        Lo : UInt64;
        Hi : UInt64;
    end;

    TLinhaCST = record
        CST             : String;
        ExigeGrupo      : Boolean;   //exige gIBSCBS
        ReducaoAliquota : Boolean;
        ReducaoBC       : Boolean;
        Diferimento     : Boolean;
        Monofasica      : Boolean;
        TransfCredito   : Boolean;
        AjusteCompet    : Boolean;
        CredPresIBSZFM  : Boolean;
    end;

    TLinhaCClassTrib = record
        Codigo      : String;
        CST         : String;
        pRedIBS     : Int64;     //décimos de milésimo
        pRedCBS     : Int64;
        TribRegular : Boolean;
        NFe         : Boolean;   //permitido no modelo 55
        NFCe        : Boolean;   //permitido no modelo 65
        IniVig      : String;    //aaaa-mm-dd
        FimVig      : String;    //aaaa-mm-dd ou vazio
    end;

const
    MASCARA_16 : UInt64 = $FFFF;
    MASCARA_32 : UInt64 = $FFFFFFFF;

    //Tolerâncias, em décimos de milésimo
    TOL_VALOR = 100;   //R$ 0,01 nos níveis 1 e 3
    TOL_N2    = 0;     //nível 2: soma exata (D5 e D17)
    TOL_ALIQ  = 1;     //0,0001 nas alíquotas

    //Sinal de menos da conta do glossário 17.1c (U+2212, fora do Windows-1252)
    SINAL_MENOS = #$2212;

    //D21 (a): o pCBS não é conferido no item com gCBSSN e sem gIBSSN (decidido em 11/11/2026;
    //o gerar_divergencias.py faz o mesmo)
    IGNORAR_PCBS_SO_CBSSN = True;

    //Alíquotas fixadas na LC 214/2025 (arts. 343, 344 e 346) e na NT (UB18-10, UB37-10 e UB56-10).
    //Ano fora da tabela: alíquota sem conferência (D8)
    ALIQ_ANO_UF  : array[2025..2028] of Int64 = (1000, 1000, 500, 500);   //0,1000 / 0,0500
    ALIQ_ANO_MUN : array[2025..2028] of Int64 = (0, 0, 500, 500);         //0,0000 / 0,0500
    ALIQ_ANO_CBS : array[2025..2026] of Int64 = (9000, 9000);             //0,9000

    UF_ZFM_ALC : array[0..4] of String = ('AC', 'AM', 'RO', 'RR', 'AP');  //NT UB56-10, exceção 3 (D13)

    //Esferas: tags do XML e nomes do glossário (convenção 4 do Plano 7)
    GRUPO_ESFERA     : array[TEsferaIBSCBS] of String = ('gIBSUF', 'gIBSMun', 'gCBS');
    TAG_ALIQ_ESFERA  : array[TEsferaIBSCBS] of String = ('pIBSUF', 'pIBSMun', 'pCBS');
    TAG_VALOR_ESFERA : array[TEsferaIBSCBS] of String = ('vIBSUF', 'vIBSMun', 'vCBS');
    SUFIXO_REG       : array[TEsferaIBSCBS] of String = ('IBSUF', 'IBSMun', 'CBS');
    NOME_ESFERA      : array[TEsferaIBSCBS] of String = ('IBS UF', 'IBS municipal', 'CBS');
    DO_ESFERA        : array[TEsferaIBSCBS] of String = ('do IBS UF', 'do IBS municipal', 'da CBS');
    CURTO_ESFERA     : array[TEsferaIBSCBS] of String = ('IBS UF', 'IBS Mun.', 'CBS');

    //Nível 2: campos do IBSCBSTot comparados com a soma dos itens (mesma ordem do gerar_divergencias.py)
    QTD_CAMPOS_TOTAL = 15;
    TAG_TOTAL : array[0..QTD_CAMPOS_TOTAL - 1] of String = (
        'vBCIBSCBS',
        'gIBS/gIBSUF/vDif', 'gIBS/gIBSUF/vDevTrib', 'gIBS/gIBSUF/vIBSUF',
        'gIBS/gIBSMun/vDif', 'gIBS/gIBSMun/vDevTrib', 'gIBS/gIBSMun/vIBSMun',
        'gIBS/vIBS', 'gIBS/vCredPres', 'gIBS/vCredPresCondSus',
        'gCBS/vDif', 'gCBS/vDevTrib', 'gCBS/vCBS', 'gCBS/vCredPres', 'gCBS/vCredPresCondSus');
    REGRA_TOTAL : array[0..QTD_CAMPOS_TOTAL - 1] of String = (
        'N2-vBCIBSCBS',
        'N2-vDif', 'N2-vDevTrib', 'N2-vIBSUF',
        'N2-vDif', 'N2-vDevTrib', 'N2-vIBSMun',
        'N2-vIBS', 'N2-vCredPres', 'N2-vCredPresCondSus',
        'N2-vDif', 'N2-vDevTrib', 'N2-vCBS', 'N2-vCredPres', 'N2-vCredPresCondSus');
    //Glossário 17.7a
    DO_CAMPO_TOTAL : array[0..QTD_CAMPOS_TOTAL - 1] of String = (
        'da base de IBS/CBS',
        'do diferimento do IBS UF', 'da devolução de tributo do IBS UF', 'do IBS UF',
        'do diferimento do IBS municipal', 'da devolução de tributo do IBS municipal', 'do IBS municipal',
        'do IBS', 'do crédito presumido do IBS', 'do crédito presumido do IBS em condição suspensiva',
        'do diferimento da CBS', 'da devolução de tributo da CBS', 'da CBS', 'do crédito presumido da CBS',
        'do crédito presumido da CBS em condição suspensiva');
    //Glossário 18.C
    CAMPO_TOTAL : array[0..QTD_CAMPOS_TOTAL - 1] of String = (
        'Base IBS/CBS (vBCIBSCBS)',
        'Diferimento IBS UF (vDif)', 'Devolução trib. IBS UF (vDevTrib)', 'IBS UF (vIBSUF)',
        'Diferimento IBS Mun. (vDif)', 'Devolução trib. IBS Mun. (vDevTrib)', 'IBS Mun. (vIBSMun)',
        'IBS (vIBS)', 'Créd. presumido IBS (vCredPres)', 'Créd. pres. susp. IBS (vCredPresCondSus)',
        'Diferimento CBS (vDif)', 'Devolução trib. CBS (vDevTrib)', 'CBS (vCBS)',
        'Créd. presumido CBS (vCredPres)', 'Créd. pres. susp. CBS (vCredPresCondSus)');

    //Tabela de CST do IBS/CBS (IT 2025.002 v1.71): 18 linhas, gerada de tests/gabarito/tabela_cst_ibscbs.csv
    TABELA_CST: array[0..17] of TLinhaCST = (
        (CST: '000'; ExigeGrupo: True; ReducaoAliquota: False; ReducaoBC: False; Diferimento: False; Monofasica: False; TransfCredito: False; AjusteCompet: False; CredPresIBSZFM: False),
        (CST: '010'; ExigeGrupo: True; ReducaoAliquota: False; ReducaoBC: False; Diferimento: False; Monofasica: False; TransfCredito: False; AjusteCompet: False; CredPresIBSZFM: False),
        (CST: '011'; ExigeGrupo: True; ReducaoAliquota: True; ReducaoBC: False; Diferimento: False; Monofasica: False; TransfCredito: False; AjusteCompet: False; CredPresIBSZFM: False),
        (CST: '200'; ExigeGrupo: True; ReducaoAliquota: True; ReducaoBC: False; Diferimento: False; Monofasica: False; TransfCredito: False; AjusteCompet: False; CredPresIBSZFM: False),
        (CST: '220'; ExigeGrupo: True; ReducaoAliquota: False; ReducaoBC: False; Diferimento: False; Monofasica: False; TransfCredito: False; AjusteCompet: False; CredPresIBSZFM: False),
        (CST: '221'; ExigeGrupo: True; ReducaoAliquota: False; ReducaoBC: False; Diferimento: False; Monofasica: False; TransfCredito: False; AjusteCompet: False; CredPresIBSZFM: False),
        (CST: '222'; ExigeGrupo: True; ReducaoAliquota: False; ReducaoBC: True; Diferimento: False; Monofasica: False; TransfCredito: False; AjusteCompet: False; CredPresIBSZFM: False),
        (CST: '400'; ExigeGrupo: False; ReducaoAliquota: False; ReducaoBC: False; Diferimento: False; Monofasica: False; TransfCredito: False; AjusteCompet: False; CredPresIBSZFM: False),
        (CST: '410'; ExigeGrupo: False; ReducaoAliquota: False; ReducaoBC: False; Diferimento: False; Monofasica: False; TransfCredito: False; AjusteCompet: False; CredPresIBSZFM: False),
        (CST: '510'; ExigeGrupo: True; ReducaoAliquota: False; ReducaoBC: False; Diferimento: True; Monofasica: False; TransfCredito: False; AjusteCompet: False; CredPresIBSZFM: False),
        (CST: '515'; ExigeGrupo: True; ReducaoAliquota: True; ReducaoBC: False; Diferimento: True; Monofasica: False; TransfCredito: False; AjusteCompet: False; CredPresIBSZFM: False),
        (CST: '550'; ExigeGrupo: True; ReducaoAliquota: False; ReducaoBC: False; Diferimento: False; Monofasica: False; TransfCredito: False; AjusteCompet: False; CredPresIBSZFM: False),
        (CST: '620'; ExigeGrupo: False; ReducaoAliquota: False; ReducaoBC: False; Diferimento: False; Monofasica: True; TransfCredito: False; AjusteCompet: False; CredPresIBSZFM: False),
        (CST: '800'; ExigeGrupo: False; ReducaoAliquota: False; ReducaoBC: False; Diferimento: False; Monofasica: False; TransfCredito: True; AjusteCompet: False; CredPresIBSZFM: False),
        (CST: '810'; ExigeGrupo: False; ReducaoAliquota: False; ReducaoBC: False; Diferimento: False; Monofasica: False; TransfCredito: False; AjusteCompet: False; CredPresIBSZFM: True),
        (CST: '811'; ExigeGrupo: False; ReducaoAliquota: False; ReducaoBC: False; Diferimento: False; Monofasica: False; TransfCredito: False; AjusteCompet: True; CredPresIBSZFM: False),
        (CST: '820'; ExigeGrupo: False; ReducaoAliquota: False; ReducaoBC: False; Diferimento: False; Monofasica: False; TransfCredito: False; AjusteCompet: False; CredPresIBSZFM: False),
        (CST: '830'; ExigeGrupo: True; ReducaoAliquota: False; ReducaoBC: False; Diferimento: False; Monofasica: False; TransfCredito: False; AjusteCompet: False; CredPresIBSZFM: False)
    );

    //Tabela de cClassTrib (IT 2025.002 v1.71), só os códigos válidos para NF-e ou NFC-e: 104 linhas em ordem de
    //código (busca binária), gerada de tests/gabarito/tabela_cclasstrib.csv. Reduções em décimos de milésimo (60% = 600000)
    TABELA_CCLASSTRIB: array[0..103] of TLinhaCClassTrib = (
        (Codigo: '000001'; CST: '000'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '000003'; CST: '000'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '000004'; CST: '000'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '000005'; CST: '000'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: False; IniVig: '2026-01-01'; FimVig: ''),
        (Codigo: '200002'; CST: '200'; pRedIBS: 1000000; pRedCBS: 1000000; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '200003'; CST: '200'; pRedIBS: 1000000; pRedCBS: 1000000; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '200004'; CST: '200'; pRedIBS: 1000000; pRedCBS: 1000000; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '200005'; CST: '200'; pRedIBS: 1000000; pRedCBS: 1000000; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '200006'; CST: '200'; pRedIBS: 1000000; pRedCBS: 1000000; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '200007'; CST: '200'; pRedIBS: 1000000; pRedCBS: 1000000; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '200008'; CST: '200'; pRedIBS: 1000000; pRedCBS: 1000000; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '200009'; CST: '200'; pRedIBS: 1000000; pRedCBS: 1000000; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '200010'; CST: '200'; pRedIBS: 1000000; pRedCBS: 1000000; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '200011'; CST: '200'; pRedIBS: 1000000; pRedCBS: 1000000; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '200012'; CST: '200'; pRedIBS: 1000000; pRedCBS: 1000000; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '200013'; CST: '200'; pRedIBS: 1000000; pRedCBS: 1000000; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '200014'; CST: '200'; pRedIBS: 1000000; pRedCBS: 1000000; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '200015'; CST: '200'; pRedIBS: 1000000; pRedCBS: 1000000; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '200020'; CST: '200'; pRedIBS: 1000000; pRedCBS: 1000000; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '200022'; CST: '200'; pRedIBS: 1000000; pRedCBS: 1000000; TribRegular: True; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '200023'; CST: '200'; pRedIBS: 1000000; pRedCBS: 1000000; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '200024'; CST: '200'; pRedIBS: 1000000; pRedCBS: 1000000; TribRegular: True; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '200030'; CST: '200'; pRedIBS: 600000; pRedCBS: 600000; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '200031'; CST: '200'; pRedIBS: 600000; pRedCBS: 600000; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '200032'; CST: '200'; pRedIBS: 600000; pRedCBS: 600000; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '200033'; CST: '200'; pRedIBS: 600000; pRedCBS: 600000; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '200034'; CST: '200'; pRedIBS: 600000; pRedCBS: 600000; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '200035'; CST: '200'; pRedIBS: 600000; pRedCBS: 600000; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '200036'; CST: '200'; pRedIBS: 600000; pRedCBS: 600000; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '200038'; CST: '200'; pRedIBS: 600000; pRedCBS: 600000; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '200039'; CST: '200'; pRedIBS: 600000; pRedCBS: 600000; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '200043'; CST: '200'; pRedIBS: 600000; pRedCBS: 600000; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '200047'; CST: '200'; pRedIBS: 400000; pRedCBS: 400000; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '200053'; CST: '200'; pRedIBS: 1000000; pRedCBS: 1000000; TribRegular: False; NFe: True; NFCe: True; IniVig: '2026-01-01'; FimVig: ''),
        (Codigo: '200054'; CST: '200'; pRedIBS: 1000000; pRedCBS: 1000000; TribRegular: False; NFe: True; NFCe: True; IniVig: '2026-01-01'; FimVig: ''),
        (Codigo: '410001'; CST: '410'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '410002'; CST: '410'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '410003'; CST: '410'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '410004'; CST: '410'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '410005'; CST: '410'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '410006'; CST: '410'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '410007'; CST: '410'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '410008'; CST: '410'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '410009'; CST: '410'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '410012'; CST: '410'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '410013'; CST: '410'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '410014'; CST: '410'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '410016'; CST: '410'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '410017'; CST: '410'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '410019'; CST: '410'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '410020'; CST: '410'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '410022'; CST: '410'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-09-30'; FimVig: ''),
        (Codigo: '410023'; CST: '410'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-09-30'; FimVig: ''),
        (Codigo: '410024'; CST: '410'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-09-30'; FimVig: ''),
        (Codigo: '410025'; CST: '410'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-09-30'; FimVig: ''),
        (Codigo: '410026'; CST: '410'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-09-30'; FimVig: ''),
        (Codigo: '410027'; CST: '410'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-11-19'; FimVig: ''),
        (Codigo: '410029'; CST: '410'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-11-19'; FimVig: ''),
        (Codigo: '410030'; CST: '410'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-11-19'; FimVig: ''),
        (Codigo: '410031'; CST: '410'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-11-19'; FimVig: ''),
        (Codigo: '410035'; CST: '410'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: True; IniVig: '2026-01-01'; FimVig: ''),
        (Codigo: '410999'; CST: '410'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '510001'; CST: '510'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '515001'; CST: '515'; pRedIBS: 600000; pRedCBS: 600000; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-09-30'; FimVig: ''),
        (Codigo: '550001'; CST: '550'; pRedIBS: 0; pRedCBS: 0; TribRegular: True; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '550003'; CST: '550'; pRedIBS: 0; pRedCBS: 0; TribRegular: True; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '550004'; CST: '550'; pRedIBS: 0; pRedCBS: 0; TribRegular: True; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '550005'; CST: '550'; pRedIBS: 0; pRedCBS: 0; TribRegular: True; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '550006'; CST: '550'; pRedIBS: 0; pRedCBS: 0; TribRegular: True; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '550007'; CST: '550'; pRedIBS: 0; pRedCBS: 0; TribRegular: True; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '550008'; CST: '550'; pRedIBS: 0; pRedCBS: 0; TribRegular: True; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '550009'; CST: '550'; pRedIBS: 0; pRedCBS: 0; TribRegular: True; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '550010'; CST: '550'; pRedIBS: 0; pRedCBS: 0; TribRegular: True; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '550011'; CST: '550'; pRedIBS: 0; pRedCBS: 0; TribRegular: True; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '550012'; CST: '550'; pRedIBS: 0; pRedCBS: 0; TribRegular: True; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '550013'; CST: '550'; pRedIBS: 0; pRedCBS: 0; TribRegular: True; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '550014'; CST: '550'; pRedIBS: 0; pRedCBS: 0; TribRegular: True; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '550015'; CST: '550'; pRedIBS: 0; pRedCBS: 0; TribRegular: True; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '550016'; CST: '550'; pRedIBS: 0; pRedCBS: 0; TribRegular: True; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '550017'; CST: '550'; pRedIBS: 0; pRedCBS: 0; TribRegular: True; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '550018'; CST: '550'; pRedIBS: 0; pRedCBS: 0; TribRegular: True; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '550019'; CST: '550'; pRedIBS: 0; pRedCBS: 0; TribRegular: True; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '550020'; CST: '550'; pRedIBS: 0; pRedCBS: 0; TribRegular: True; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '550021'; CST: '550'; pRedIBS: 0; pRedCBS: 0; TribRegular: True; NFe: True; NFCe: False; IniVig: '2025-09-30'; FimVig: ''),
        (Codigo: '550022'; CST: '550'; pRedIBS: 0; pRedCBS: 0; TribRegular: True; NFe: True; NFCe: False; IniVig: '2026-01-01'; FimVig: ''),
        (Codigo: '550023'; CST: '550'; pRedIBS: 0; pRedCBS: 0; TribRegular: True; NFe: True; NFCe: False; IniVig: '2026-01-01'; FimVig: ''),
        (Codigo: '550026'; CST: '550'; pRedIBS: 0; pRedCBS: 0; TribRegular: True; NFe: True; NFCe: False; IniVig: '2026-01-01'; FimVig: ''),
        (Codigo: '550027'; CST: '550'; pRedIBS: 0; pRedCBS: 0; TribRegular: True; NFe: True; NFCe: False; IniVig: '2026-01-01'; FimVig: ''),
        (Codigo: '550028'; CST: '550'; pRedIBS: 0; pRedCBS: 0; TribRegular: True; NFe: True; NFCe: False; IniVig: '2026-01-01'; FimVig: ''),
        (Codigo: '550029'; CST: '550'; pRedIBS: 0; pRedCBS: 0; TribRegular: True; NFe: True; NFCe: False; IniVig: '2026-01-01'; FimVig: ''),
        (Codigo: '620001'; CST: '620'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '620002'; CST: '620'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '620003'; CST: '620'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '620004'; CST: '620'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '620005'; CST: '620'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '620006'; CST: '620'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: True; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '620007'; CST: '620'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: False; IniVig: '2026-01-01'; FimVig: ''),
        (Codigo: '800001'; CST: '800'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '800002'; CST: '800'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '810001'; CST: '810'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: ''),
        (Codigo: '811001'; CST: '811'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-09-30'; FimVig: ''),
        (Codigo: '811002'; CST: '811'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-09-30'; FimVig: ''),
        (Codigo: '811003'; CST: '811'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-09-30'; FimVig: ''),
        (Codigo: '830001'; CST: '830'; pRedIBS: 0; pRedCBS: 0; TribRegular: False; NFe: True; NFCe: False; IniVig: '2025-05-05'; FimVig: '')
    );

{ Aritmética exata }

function I128(const Valor: Int64): TInt128;
begin
    Result.Lo := UInt64(Valor);
    if Valor < 0 then
        Result.Hi := High(UInt64)
    else
        Result.Hi := 0;
end;

function Negativo128(const A: TInt128): Boolean;
begin
    Result := (A.Hi shr 63) <> 0;
end;

function Negar128(const A: TInt128): TInt128;
begin
    //Complemento de dois: inverte os bits e soma 1
    Result.Lo := not A.Lo;
    Result.Hi := not A.Hi;
    Result.Lo := Result.Lo + 1;
    if Result.Lo = 0 then
        Result.Hi := Result.Hi + 1;
end;

function Somar128(const A, B: TInt128): TInt128;
begin
    Result.Lo := A.Lo + B.Lo;
    Result.Hi := A.Hi + B.Hi;
    if Result.Lo < A.Lo then
        Result.Hi := Result.Hi + 1;
end;

function MultiplicarU64(const A, B: UInt64): TInt128;
var
    A0, A1, B0, B1, P00, P01, P10, P11, Meio: UInt64;
begin
    //Produto completo de dois inteiros sem sinal de 64 bits, em partes de 32 bits
    A0 := A and MASCARA_32;
    A1 := A shr 32;
    B0 := B and MASCARA_32;
    B1 := B shr 32;
    P00 := A0 * B0;
    P01 := A0 * B1;
    P10 := A1 * B0;
    P11 := A1 * B1;
    Meio := (P00 shr 32) + (P01 and MASCARA_32) + (P10 and MASCARA_32);
    Result.Lo := (Meio shl 32) or (P00 and MASCARA_32);
    Result.Hi := P11 + (P01 shr 32) + (P10 shr 32) + (Meio shr 32);
end;

function Multiplicar128(const A: TInt128; const B: Int64): TInt128;
var
    Negativo: Boolean;
    MA      : TInt128;
    MB      : UInt64;
begin
    //Produto com sinal (os valores do XML cabem com folga em 128 bits)
    Negativo := Negativo128(A) <> (B < 0);
    if Negativo128(A) then
        MA := Negar128(A)
    else
        MA := A;
    if B < 0 then
        MB := UInt64(-B)
    else
        MB := UInt64(B);
    Result := MultiplicarU64(MA.Lo, MB);
    Result.Hi := Result.Hi + MA.Hi * MB;
    if Negativo then
        Result := Negar128(Result);
end;

function DividirArredondando(const Numerador: TInt128; const Divisor: UInt64): Int64;
var
    Negativo: Boolean;
    M       : TInt128;
    Resto, Atual, Parte, Q, QLo, QHi: UInt64;
    I       : Integer;
begin
    //Numerador / Divisor arredondado como o ROUND_HALF_UP do Python (metade para longe do zero).
    //Divisão longa em partes de 16 bits: o Divisor fica abaixo de 2^48, então o resto deslocado cabe em 64 bits
    Negativo := Negativo128(Numerador);
    if Negativo then
        M := Negar128(Numerador)
    else
        M := Numerador;
    Resto := 0;
    QLo   := 0;
    QHi   := 0;
    for I := 7 downto 0 do
    begin
        if I >= 4 then
            Parte := (M.Hi shr ((I - 4) * 16)) and MASCARA_16
        else
            Parte := (M.Lo shr (I * 16)) and MASCARA_16;
        Atual := (Resto shl 16) or Parte;
        Q     := Atual div Divisor;
        Resto := Atual mod Divisor;
        if I >= 4 then
            QHi := QHi or (Q shl ((I - 4) * 16))
        else
            QLo := QLo or (Q shl (I * 16));
    end;
    if Resto * 2 >= Divisor then
        QLo := QLo + 1;
    Result := Int64(QLo);
    if Negativo then
        Result := -Result;
end;

function DividirInt64(const Valor, Divisor: Int64): Int64;
var
    Resto: Int64;
begin
    //Valor / Divisor (Divisor positivo) com ROUND_HALF_UP
    Result := Abs(Valor) div Divisor;
    Resto  := Abs(Valor) mod Divisor;
    if Resto * 2 >= Divisor then
        Inc(Result);
    if Valor < 0 then
        Result := -Result;
end;

function ValorTributoEsperado(const vBC, Aliquota, Deducoes: Int64): Int64;
begin
    //r2(vBC × alíquota / 100 - vDif - vDevTrib), em centavos: (vBC × alíq - deduções × 10^6) / 10^8
    Result := DividirArredondando(Somar128(Multiplicar128(I128(vBC), Aliquota),
                                           Multiplicar128(I128(Deducoes), -1000000)), 100000000) * 100;
end;

function ValorPercentualEsperado(const vBC, Aliquota, Percentual: Int64): Int64;
begin
    //r2(vBC × alíquota / 100 × percentual / 100) (vDif e vDevTrib), em centavos: produto / 10^14
    Result := DividirArredondando(Multiplicar128(Multiplicar128(I128(vBC), Aliquota), Percentual),
                                  100000000000000) * 100;
end;

function ValorRegularEsperado(const vBC, Aliquota: Int64): Int64;
begin
    //r2(vBC × pAliqEfetReg / 100), em centavos: produto / 10^8
    Result := DividirArredondando(Multiplicar128(I128(vBC), Aliquota), 100000000) * 100;
end;

function AliquotaEfetivaEsperada(const Aliquota, pRedAliq, pRedutor: Int64): Int64;
begin
    //r4(p × (1 - pRedAliq/100) × (1 - pRedutor/100)), em décimos de milésimo: produto / 10^12
    Result := DividirArredondando(Multiplicar128(Multiplicar128(I128(Aliquota), 1000000 - pRedAliq),
                                                 1000000 - pRedutor), 1000000000000);
end;

{ Conversão e formatação }

function TextoParaValorIBSCBS(const Texto: String; out Valor: Int64): Boolean;
var
    S          : String;
    I, Casas   : Integer;
    Negativo   : Boolean;
    TemDigito  : Boolean;
    PassouPonto: Boolean;
    Arredondar : Boolean;
    Digito     : Integer;
begin
    Result := False;
    Valor  := 0;
    S := Trim(Texto);
    if S = '' then
        Exit(True);

    I := 1;
    Negativo := False;
    if CharInSet(S[1], ['+', '-']) then
    begin
        Negativo := S[1] = '-';
        Inc(I);
    end;

    Casas       := 0;
    TemDigito   := False;
    PassouPonto := False;
    Arredondar  := False;
    while I <= Length(S) do
    begin
        if S[I] = '.' then
        begin
            if PassouPonto then
                Exit;
            PassouPonto := True;
        end
        else if CharInSet(S[I], ['0'..'9']) then
        begin
            TemDigito := True;
            Digito := Ord(S[I]) - Ord('0');
            if not PassouPonto then
            begin
                //Até 14 dígitos inteiros (o XML usa no máximo 13)
                if Valor >= 100000000000000 then
                    Exit;
                Valor := Valor * 10 + Digito;
            end
            else if Casas < 4 then
            begin
                Valor := Valor * 10 + Digito;
                Inc(Casas);
            end
            else if Casas = 4 then
            begin
                //5ª casa decide o arredondamento (ROUND_HALF_UP); as seguintes não mudam o resultado
                Arredondar := Digito >= 5;
                Inc(Casas);
            end;
        end
        else
            Exit;
        Inc(I);
    end;
    if not TemDigito then
        Exit;

    while Casas < 4 do
    begin
        Valor := Valor * 10;
        Inc(Casas);
    end;
    if Arredondar then
        Inc(Valor);
    if Negativo then
        Valor := -Valor;
    Result := True;
end;

function ZerosEsquerda(const Valor: Int64; const Tamanho: Integer): String;
begin
    Result := IntToStr(Valor);
    while Length(Result) < Tamanho do
        Result := '0' + Result;
end;

function FormatarValorGabaritoIBSCBS(const Valor: Int64; const Casas: Integer): String;
var
    V: Int64;
begin
    //Como o str(Decimal) do script: "10.00", "-1.50", "0.9000"
    if Casas = 2 then
    begin
        V := DividirInt64(Valor, 100);
        Result := IntToStr(Abs(V) div 100) + '.' + ZerosEsquerda(Abs(V) mod 100, 2);
    end
    else
    begin
        V := Valor;
        Result := IntToStr(Abs(V) div ESCALA_IBSCBS) + '.' + ZerosEsquerda(Abs(V) mod ESCALA_IBSCBS, 4);
    end;
    if V < 0 then
        Result := '-' + Result;
end;

function MilharPtBR(const Valor: Int64): String;
var
    Texto: String;
    I    : Integer;
begin
    //Parte inteira com o ponto de milhar do pt-BR
    Texto  := IntToStr(Valor);
    Result := '';
    I := Length(Texto);
    while I > 3 do
    begin
        Result := '.' + Copy(Texto, I - 2, 3) + Result;
        Dec(I, 3);
    end;
    Result := Copy(Texto, 1, I) + Result;
end;

function FormatarReais(const Valor: Int64): String;
var
    Centavos: Int64;
begin
    //Moeda no formato do app (glossário, convenção 3): "R$ 1.234,56"; negativo como no FormatFloat: "-R$ 1,00"
    Centavos := DividirInt64(Valor, 100);
    Result := 'R$ ' + MilharPtBR(Abs(Centavos) div 100) + ',' + ZerosEsquerda(Abs(Centavos) mod 100, 2);
    if Centavos < 0 then
        Result := '-' + Result;
end;

function FormatarAliquota(const Valor: Int64): String;
begin
    //Alíquota com 4 casas e %: "0,1000%"
    Result := IntToStr(Abs(Valor) div ESCALA_IBSCBS) + ',' + ZerosEsquerda(Abs(Valor) mod ESCALA_IBSCBS, 4) + '%';
    if Valor < 0 then
        Result := '-' + Result;
end;

function FormatarPercentual(const Valor: Int64): String;
var
    Casas: String;
begin
    //Percentual de redução, diferimento e devolução: sem casas quando inteiro ("60%"), senão até 4 casas
    //sem zeros no fim ("12,5%")
    Result := IntToStr(Abs(Valor) div ESCALA_IBSCBS);
    if Abs(Valor) mod ESCALA_IBSCBS <> 0 then
    begin
        Casas := ZerosEsquerda(Abs(Valor) mod ESCALA_IBSCBS, 4);
        while (Casas <> '') and (Casas[Length(Casas)] = '0') do
            Delete(Casas, Length(Casas), 1);
        Result := Result + ',' + Casas;
    end;
    Result := Result + '%';
    if Valor < 0 then
        Result := '-' + Result;
end;

function FormatarDataISO(const Data: String): String;
begin
    //"aaaa-mm-dd" -> "dd/mm/aaaa"
    Result := Copy(Data, 9, 2) + '/' + Copy(Data, 6, 2) + '/' + Copy(Data, 1, 4);
end;

function Singular(const Quantidade: Integer; const TextoSingular, TextoPlural: String): String;
begin
    if Quantidade = 1 then
        Result := TextoSingular
    else
        Result := TextoPlural;
end;

{ Tabelas }

function BuscarCST(const CST: String; out Linha: TLinhaCST): Boolean;
var
    I: Integer;
begin
    for I := Low(TABELA_CST) to High(TABELA_CST) do
        if TABELA_CST[I].CST = CST then
        begin
            Linha := TABELA_CST[I];
            Exit(True);
        end;
    Result := False;
end;

function BuscarCClassTrib(const Codigo: String; out Linha: TLinhaCClassTrib): Boolean;
var
    Inicio, Fim, Meio, Comparacao: Integer;
begin
    //Busca binária: a tabela está em ordem de código
    Inicio := Low(TABELA_CCLASSTRIB);
    Fim    := High(TABELA_CCLASSTRIB);
    while Inicio <= Fim do
    begin
        Meio := (Inicio + Fim) div 2;
        Comparacao := CompareStr(TABELA_CCLASSTRIB[Meio].Codigo, Codigo);
        if Comparacao = 0 then
        begin
            Linha := TABELA_CCLASSTRIB[Meio];
            Exit(True);
        end;
        if Comparacao < 0 then
            Inicio := Meio + 1
        else
            Fim := Meio - 1;
    end;
    Result := False;
end;

function AliquotaDoAno(const Esfera: TEsferaIBSCBS; const Ano: String; out Aliquota: Int64): Boolean;
var
    NumeroAno: Integer;
begin
    //Alíquota fixada em lei para o ano da emissão (seção 7.1 das regras). Falso = ano sem conferência (D8)
    Result   := False;
    Aliquota := 0;
    NumeroAno := StrToIntDef(Ano, 0);
    case Esfera of
        esIBSUF:
            if (NumeroAno >= Low(ALIQ_ANO_UF)) and (NumeroAno <= High(ALIQ_ANO_UF)) then
            begin
                Aliquota := ALIQ_ANO_UF[NumeroAno];
                Result   := True;
            end;
        esIBSMun:
            if (NumeroAno >= Low(ALIQ_ANO_MUN)) and (NumeroAno <= High(ALIQ_ANO_MUN)) then
            begin
                Aliquota := ALIQ_ANO_MUN[NumeroAno];
                Result   := True;
            end;
        esCBS:
            if (NumeroAno >= Low(ALIQ_ANO_CBS)) and (NumeroAno <= High(ALIQ_ANO_CBS)) then
            begin
                Aliquota := ALIQ_ANO_CBS[NumeroAno];
                Result   := True;
            end;
    end;
    //Ano com 4 dígitos exatos, como a chave '2026' do script
    if Length(Ano) <> 4 then
        Result := False;
end;

function UFZonaFranca(const UF: String): Boolean;
var
    I: Integer;
begin
    for I := Low(UF_ZFM_ALC) to High(UF_ZFM_ALC) do
        if UF_ZFM_ALC[I] = UF then
            Exit(True);
    Result := False;
end;

function FinalidadeNota(const Nota: TNotaIBSCBS): String;
begin
    //finNFe ausente vale 1 (nota normal), como no script
    Result := Nota.finNFe;
    if Result = '' then
        Result := '1';
end;

function ItemTemNivel3IBSCBS(const TemgIBSCBS: Boolean; const CST, finNFe: String): Boolean;
begin
    //Seção 6.5 das regras: só com gIBSCBS, fora dos CST 222 e 830 e só em nota normal (finNFe 1, D3)
    Result := TemgIBSCBS and (CST <> '222') and (CST <> '830') and ((finNFe = '1') or (finNFe = ''));
end;

{ Coleta das divergências }

procedure AdicionarDivergencia(var R: TConferenciaIBSCBS; const Item, Nivel: Integer;
    const Regra, Tag, Campo, ValorXML, Esperado, ValorXMLExibido, EsperadoExibido, TextoLog: String);
var
    D: TDivergenciaIBSCBS;
begin
    D.Item  := Item;
    D.Nivel := Nivel;
    if Nivel <= 2 then
    begin
        D.Tipo := tdErro;
        Inc(R.QuantidadeErros);
    end
    else
    begin
        D.Tipo := tdAlerta;
        Inc(R.QuantidadeAlertas);
    end;
    D.Regra           := Regra;
    D.Tag             := Tag;
    D.Campo           := Campo;
    D.ValorXML        := ValorXML;
    D.Esperado        := Esperado;
    D.ValorXMLExibido := ValorXMLExibido;
    D.EsperadoExibido := EsperadoExibido;
    D.TextoLog        := TextoLog;
    SetLength(R.Divergencias, Length(R.Divergencias) + 1);
    R.Divergencias[High(R.Divergencias)] := D;
end;

procedure AdicionarSemConferencia(var R: TConferenciaIBSCBS; const Item: Integer;
    const Motivo: TMotivoSemConferenciaIBSCBS);
var
    I: Integer;
begin
    //Sem repetir o mesmo motivo no mesmo item (ou na nota)
    for I := 0 to High(R.SemConferencia) do
        if (R.SemConferencia[I].Item = Item) and (R.SemConferencia[I].Motivo = Motivo) then
            Exit;
    SetLength(R.SemConferencia, Length(R.SemConferencia) + 1);
    R.SemConferencia[High(R.SemConferencia)].Item   := Item;
    R.SemConferencia[High(R.SemConferencia)].Motivo := Motivo;
end;

function PrefixoItem(const Nota: TNotaIBSCBS; const It: TItemIBSCBS): String;
begin
    Result := 'Nota Fiscal ' + Nota.NumeroNF + ', item ' + IntToStr(It.NumeroItem) + ': ';
end;

function PrefixoNota(const Nota: TNotaIBSCBS): String;
begin
    Result := 'Nota Fiscal ' + Nota.NumeroNF + ': ';
end;

{ Nível 1: conta do item (Erro) }

procedure ConferirNivel1(var R: TConferenciaIBSCBS; const Nota: TNotaIBSCBS; const It: TItemIBSCBS);
var
    E         : TEsferaIBSCBS;
    G         : TEsferaItemIBSCBS;
    Valores   : array[TEsferaIBSCBS] of Int64;
    Aliquota  : Int64;
    EspEfet   : Int64;
    vDif, vDev: Int64;
    Esperado  : Int64;
    Conta     : String;
    Reducao   : String;
    SomaIBS   : Int64;
    Pref      : String;
begin
    Pref := PrefixoItem(Nota, It);
    for E := Low(TEsferaIBSCBS) to High(TEsferaIBSCBS) do
    begin
        G := It.Esferas[E];
        if not G.Presente then
        begin
            Valores[E] := 0;
            Continue;
        end;

        //N1-pAliqEfet (UB27-10, D4): com gRed, a conta usa a alíquota efetiva informada
        Aliquota := G.pAliq;
        if G.TemRed then
        begin
            EspEfet := AliquotaEfetivaEsperada(G.pAliq, G.pRedAliq, Nota.pRedutor);
            if Abs(G.pAliqEfet - EspEfet) > TOL_ALIQ then
            begin
                //Glossário 17.3 e 17.3a
                Reducao := FormatarAliquota(G.pAliq) + ' com redução de ' + FormatarPercentual(G.pRedAliq);
                if Nota.TemCompraGov then
                    Reducao := Reducao + ' e redutor de compra governamental de ' + FormatarPercentual(Nota.pRedutor);
                AdicionarDivergencia(R, It.NumeroItem, 1, 'N1-pAliqEfet', GRUPO_ESFERA[E] + '/gRed/pAliqEfet',
                    'Alíq. efetiva ' + CURTO_ESFERA[E] + ' (pAliqEfet)',
                    FormatarValorGabaritoIBSCBS(G.pAliqEfet, 4), FormatarValorGabaritoIBSCBS(EspEfet, 4),
                    FormatarAliquota(G.pAliqEfet), FormatarAliquota(EspEfet),
                    Pref + 'alíquota efetiva ' + DO_ESFERA[E] + ' ' + FormatarAliquota(G.pAliqEfet) +
                    ', esperado ' + FormatarAliquota(EspEfet) + ' (' + Reducao + ') (erro).');
            end;
            Aliquota := G.pAliqEfet;
        end;

        //N1-vDif (UB24-10)
        vDif := 0;
        vDev := 0;
        if G.TemDif then
        begin
            vDif := G.vDif;
            Esperado := ValorPercentualEsperado(It.vBC, Aliquota, G.pDif);
            if Abs(vDif - Esperado) > TOL_VALOR then
                //Glossário 17.4
                AdicionarDivergencia(R, It.NumeroItem, 1, 'N1-vDif', GRUPO_ESFERA[E] + '/gDif/vDif',
                    'Diferimento ' + CURTO_ESFERA[E] + ' (vDif)',
                    FormatarValorGabaritoIBSCBS(vDif, 2), FormatarValorGabaritoIBSCBS(Esperado, 2),
                    FormatarReais(vDif), FormatarReais(Esperado),
                    Pref + 'diferimento ' + DO_ESFERA[E] + ' ' + FormatarReais(vDif) + ', esperado ' +
                    FormatarReais(Esperado) + ' (' + FormatarPercentual(G.pDif) + ' do imposto) (erro).');
        end;

        //N1-vDevTrib (UB63-10): só quando o pDevTrib vem informado
        if G.TemDevTrib then
        begin
            vDev := G.vDevTrib;
            if G.TempDevTrib then
            begin
                Esperado := ValorPercentualEsperado(It.vBC, Aliquota, G.pDevTrib);
                if Abs(vDev - Esperado) > TOL_VALOR then
                    //Glossário 17.5
                    AdicionarDivergencia(R, It.NumeroItem, 1, 'N1-vDevTrib', GRUPO_ESFERA[E] + '/gDevTrib/vDevTrib',
                        'Devolução trib. ' + CURTO_ESFERA[E] + ' (vDevTrib)',
                        FormatarValorGabaritoIBSCBS(vDev, 2), FormatarValorGabaritoIBSCBS(Esperado, 2),
                        FormatarReais(vDev), FormatarReais(Esperado),
                        Pref + 'devolução de tributo ' + DO_ESFERA[E] + ' ' + FormatarReais(vDev) + ', esperado ' +
                        FormatarReais(Esperado) + ' (' + FormatarPercentual(G.pDevTrib) + ' do imposto) (erro).');
            end;
        end;

        //N1-vIBSUF, N1-vIBSMun e N1-vCBS (UB37-10, UB54-10 e UB67-10)
        Esperado := ValorTributoEsperado(It.vBC, Aliquota, vDif + vDev);
        if Abs(G.vTributo - Esperado) > TOL_VALOR then
        begin
            //Glossário 17.1, 17.1a, 17.1b e 17.1c
            Conta := FormatarReais(It.vBC) + ' × ' + FormatarAliquota(Aliquota);
            if G.TemRed then
                Conta := Conta + ', alíquota efetiva';
            if G.TemDif then
                Conta := Conta + ' ' + SINAL_MENOS + ' ' + FormatarReais(vDif) + ' de diferimento';
            if G.TemDevTrib then
                Conta := Conta + ' ' + SINAL_MENOS + ' ' + FormatarReais(vDev) + ' de devolução de tributo';
            AdicionarDivergencia(R, It.NumeroItem, 1, 'N1-' + TAG_VALOR_ESFERA[E],
                GRUPO_ESFERA[E] + '/' + TAG_VALOR_ESFERA[E],
                CURTO_ESFERA[E] + ' (' + TAG_VALOR_ESFERA[E] + ')',
                FormatarValorGabaritoIBSCBS(G.vTributo, 2), FormatarValorGabaritoIBSCBS(Esperado, 2),
                FormatarReais(G.vTributo), FormatarReais(Esperado),
                Pref + NOME_ESFERA[E] + ' ' + FormatarReais(G.vTributo) + ', esperado ' + FormatarReais(Esperado) +
                ' (' + Conta + ') (erro).');
        end;
        Valores[E] := G.vTributo;
    end;

    //N1-vIBS (UB54a-10): vIBSUF + vIBSMun; com crédito presumido do IBS também vale a soma menos o crédito (D10)
    SomaIBS := Valores[esIBSUF] + Valores[esIBSMun];
    if not ((Abs(It.vIBS - SomaIBS) <= TOL_VALOR) or
            ((It.vCredPresIBS <> 0) and (Abs(It.vIBS - (SomaIBS - It.vCredPresIBS)) <= TOL_VALOR))) then
    begin
        //Glossário 17.2 e 17.2a
        if It.vCredPresIBS <> 0 then
            Conta := 'IBS UF + IBS municipal, com ou sem o crédito presumido de ' + FormatarReais(It.vCredPresIBS)
        else
            Conta := 'IBS UF + IBS municipal';
        AdicionarDivergencia(R, It.NumeroItem, 1, 'N1-vIBS', 'gIBSCBS/vIBS', 'IBS (vIBS)',
            FormatarValorGabaritoIBSCBS(It.vIBS, 2), FormatarValorGabaritoIBSCBS(SomaIBS, 2),
            FormatarReais(It.vIBS), FormatarReais(SomaIBS),
            Pref + 'IBS ' + FormatarReais(It.vIBS) + ', esperado ' + FormatarReais(SomaIBS) + ' (' + Conta + ') (erro).');
    end;

    //N1-vTribReg (UB72-10, UB72b-10 e UB72d-10)
    if It.TemTribRegular then
        for E := Low(TEsferaIBSCBS) to High(TEsferaIBSCBS) do
        begin
            Esperado := ValorRegularEsperado(It.vBC, It.pAliqEfetReg[E]);
            if Abs(It.vTribReg[E] - Esperado) > TOL_VALOR then
                //Glossário 17.6
                AdicionarDivergencia(R, It.NumeroItem, 1, 'N1-vTribReg', 'gTribRegular/vTribReg' + SUFIXO_REG[E],
                    'Trib. regular ' + CURTO_ESFERA[E] + ' (vTribReg' + SUFIXO_REG[E] + ')',
                    FormatarValorGabaritoIBSCBS(It.vTribReg[E], 2), FormatarValorGabaritoIBSCBS(Esperado, 2),
                    FormatarReais(It.vTribReg[E]), FormatarReais(Esperado),
                    Pref + 'tributação regular ' + DO_ESFERA[E] + ' ' + FormatarReais(It.vTribReg[E]) +
                    ', esperado ' + FormatarReais(Esperado) + ' (' + FormatarReais(It.vBC) + ' × ' +
                    FormatarAliquota(It.pAliqEfetReg[E]) + ') (erro).');
        end;
end;

{ Nível 3: base de cálculo (Alerta) }

function BaseEsperada(const C: TComposicaoBaseIBSCBS): Int64;
begin
    //NT 2025.002 UB16-10 (composição da base) e LC 214, art. 12 (D1, D2 e D15), por item
    Result := C.vProd + C.vFrete + C.vSeg + C.vOutro + C.vII + C.vIS;
    Result := Result - C.vDesc - C.vPIS - C.vCOFINS - C.vICMS - C.vFCP - C.vICMSMono;
    Result := Result - C.vICMSUFDest - C.vFCPUFDest - C.vISSQN;
    if C.TemPISST and not C.SomaPISST then
        Result := Result - C.vPISST;
    if C.TemCOFINSST and not C.SomaCOFINSST then
        Result := Result - C.vCOFINSST;
end;

procedure ConferirNivel3(var R: TConferenciaIBSCBS; const Nota: TNotaIBSCBS; const It: TItemIBSCBS);
var
    Esperado: Int64;
begin
    if not (It.TemComposicao and ItemTemNivel3IBSCBS(It.TemgIBSCBS, It.CST, FinalidadeNota(Nota))) then
        Exit;
    Esperado := BaseEsperada(It.Composicao);
    if Abs(It.vBC - Esperado) > TOL_VALOR then
        //Glossário 17.10
        AdicionarDivergencia(R, It.NumeroItem, 3, 'N3-vBC', 'gIBSCBS/vBC', 'Base IBS/CBS (vBC)',
            FormatarValorGabaritoIBSCBS(It.vBC, 2), FormatarValorGabaritoIBSCBS(Esperado, 2),
            FormatarReais(It.vBC), FormatarReais(Esperado),
            PrefixoItem(Nota, It) + 'base de IBS/CBS ' + FormatarReais(It.vBC) + ' no XML e ' +
            FormatarReais(Esperado) + ' pela composição do item; confira (alerta).');
end;

{ Nível 4: alíquota, redução e CST (Alerta) }

procedure ConferirNivel4(var R: TConferenciaIBSCBS; const Nota: TNotaIBSCBS; const It: TItemIBSCBS);
var
    LinhaCCl     : TLinhaCClassTrib;
    LinhaCST     : TLinhaCST;
    Pref, Data   : String;
    Ano, Fin, Tp : String;
    E            : TEsferaIBSCBS;
    G            : TEsferaItemIBSCBS;
    TribReg      : Boolean;
    ConfereAliq  : Boolean;
    TemEsperado  : Boolean;
    AnoSemAliq   : Boolean;
    Esperado     : Int64;
    pRedTabela   : Int64;
    TextoEsp     : String;
begin
    Pref := PrefixoItem(Nota, It);
    Data := Copy(Nota.DataEmissao, 1, 10);

    //N4-cClassTrib: o código existe na tabela (glossário 17.11)
    if not BuscarCClassTrib(It.cClassTrib, LinhaCCl) then
    begin
        AdicionarDivergencia(R, It.NumeroItem, 4, 'N4-cClassTrib', 'IBSCBS/cClassTrib', 'cClassTrib',
            It.cClassTrib, 'codigo da tabela cClassTrib',
            It.cClassTrib, 'na tabela v' + VERSAO_TABELA_CCLASSTRIB,
            Pref + 'o cClassTrib ' + It.cClassTrib + ' não está na tabela oficial (v' + VERSAO_TABELA_CCLASSTRIB +
            '); confira (alerta).');
        Exit;
    end;

    //N4-CSTxcClassTrib: o cClassTrib pertence ao CST; se falhar, as outras regras do item não rodam (17.12)
    if (Copy(It.cClassTrib, 1, 3) <> It.CST) or (LinhaCCl.CST <> It.CST) then
    begin
        AdicionarDivergencia(R, It.NumeroItem, 4, 'N4-CSTxcClassTrib', 'IBSCBS/cClassTrib', 'cClassTrib × CST',
            It.cClassTrib + ' (CST ' + It.CST + ')', 'cClassTrib do CST ' + It.CST,
            It.cClassTrib, 'do CST ' + It.CST,
            Pref + 'pela tabela oficial, o cClassTrib ' + It.cClassTrib + ' não pertence ao CST ' + It.CST +
            '; confira (alerta).');
        Exit;
    end;

    //N4-cClassTribModelo (17.13)
    if ((Nota.Modelo = '55') and not LinhaCCl.NFe) or ((Nota.Modelo = '65') and not LinhaCCl.NFCe) then
    begin
        if Nota.Modelo = '55' then
            TextoEsp := 'só NFC-e (65)'
        else
            TextoEsp := 'só NF-e (55)';
        if Nota.Modelo = '55' then
            Tp := 'NF-e (55)'
        else
            Tp := 'NFC-e (65)';
        AdicionarDivergencia(R, It.NumeroItem, 4, 'N4-cClassTribModelo', 'IBSCBS/cClassTrib', 'cClassTrib × modelo',
            It.cClassTrib, 'cClassTrib permitido no modelo ' + Nota.Modelo,
            It.cClassTrib, TextoEsp,
            Pref + 'pela tabela oficial, o cClassTrib ' + It.cClassTrib + ' não é usado na ' + Tp +
            '; confira (alerta).');
    end;

    //N4-cClassTribVigencia (17.14)
    if (Data < LinhaCCl.IniVig) or ((LinhaCCl.FimVig <> '') and (Data > LinhaCCl.FimVig)) then
    begin
        if Data < LinhaCCl.IniVig then
            TextoEsp := 'desde ' + FormatarDataISO(LinhaCCl.IniVig)
        else
            TextoEsp := 'até ' + FormatarDataISO(LinhaCCl.FimVig);
        if LinhaCCl.FimVig <> '' then
            Tp := LinhaCCl.FimVig
        else
            Tp := '-';
        AdicionarDivergencia(R, It.NumeroItem, 4, 'N4-cClassTribVigencia', 'IBSCBS/cClassTrib', 'cClassTrib × vigência',
            It.cClassTrib, 'vigente de ' + LinhaCCl.IniVig + ' a ' + Tp,
            FormatarDataISO(Data), TextoEsp,
            Pref + 'pela tabela oficial, o cClassTrib ' + It.cClassTrib + ' não estava vigente em ' +
            FormatarDataISO(Data) + '; confira (alerta).');
    end;

    if not BuscarCST(It.CST, LinhaCST) then
        Exit;

    //N4-gIBSCBS (17.15 e 17.15a)
    if LinhaCST.ExigeGrupo and not It.TemgIBSCBS then
    begin
        //D20 (a): o Simples Nacional sem regime regular informa gTribSN no lugar do gIBSCBS, sem alerta
        if not It.TemgTribSN then
            AdicionarDivergencia(R, It.NumeroItem, 4, 'N4-gIBSCBS', 'IBSCBS/gIBSCBS', 'Grupo IBS/CBS (gIBSCBS)',
                'ausente', 'presente', 'ausente', 'presente',
                Pref + 'sem o grupo de cálculo do IBS/CBS (gIBSCBS) no XML, e o CST ' + It.CST +
                ' prevê esse grupo; confira (alerta).');
        Exit;
    end;
    if (not LinhaCST.ExigeGrupo) and It.TemgIBSCBS then
        AdicionarDivergencia(R, It.NumeroItem, 4, 'N4-gIBSCBS', 'IBSCBS/gIBSCBS', 'Grupo IBS/CBS (gIBSCBS)',
            'presente', 'ausente', 'presente', 'ausente',
            Pref + 'grupo de cálculo do IBS/CBS (gIBSCBS) no XML, e o CST ' + It.CST +
            ' não prevê esse grupo; confira (alerta).');
    if not It.TemgIBSCBS then
        Exit;

    TribReg := LinhaCCl.TribRegular;
    Fin := FinalidadeNota(Nota);
    //Exceções da NT (UB18-10): sem conferir alíquota na devolução e nas notas de crédito 03, 04 e 06
    ConfereAliq := (Fin <> '4') and (Nota.tpNFCredito <> '03') and (Nota.tpNFCredito <> '04') and
                   (Nota.tpNFCredito <> '06');
    Ano := Copy(Data, 1, 4);

    for E := Low(TEsferaIBSCBS) to High(TEsferaIBSCBS) do
    begin
        G := It.Esferas[E];
        if not G.Presente then
            Continue;

        //N4-pIBSUF, N4-pIBSMun e N4-pCBS (17.16, 17.16a e 17.16b)
        if ConfereAliq and not (IGNORAR_PCBS_SO_CBSSN and (E = esCBS) and It.TemgCBSSN and not It.TemgIBSSN) then
        begin
            AnoSemAliq := False;
            if TribReg then
            begin
                Esperado := 0;
                TemEsperado := True;
            end
            else
            begin
                TemEsperado := AliquotaDoAno(E, Ano, Esperado);
                AnoSemAliq := not TemEsperado;
            end;
            if (E = esCBS) and G.TemALCZFM then
            begin
                Esperado := 0;
                TemEsperado := True;
                AnoSemAliq := False;
            end;
            //Exceção 3 da CBS (ZFM/ALC), simplificada pela D13
            if (E = esCBS) and (G.pAliq = 0) and UFZonaFranca(Nota.UFEmitente) then
                TemEsperado := False;

            if AnoSemAliq then
            begin
                if E = esCBS then
                    AdicionarSemConferencia(R, ITEM_TOTAL_IBSCBS, msAliquotaCBSAno)
                else
                    AdicionarSemConferencia(R, ITEM_TOTAL_IBSCBS, msAliquotaIBSAno);
            end;

            if TemEsperado and (Abs(G.pAliq - Esperado) > TOL_ALIQ) then
            begin
                if (E = esCBS) and G.TemALCZFM then
                    TextoEsp := Pref + 'alíquota da CBS ' + FormatarAliquota(G.pAliq) +
                                ' no XML e 0,0000% com o grupo da ZFM/ALC (gALCZFMCBS); confira (alerta).'
                else if TribReg then
                    TextoEsp := Pref + 'alíquota ' + DO_ESFERA[E] + ' ' + FormatarAliquota(G.pAliq) +
                                ' no XML e 0,0000% para o cClassTrib ' + It.cClassTrib +
                                ' (tributação regular); confira (alerta).'
                else
                    TextoEsp := Pref + 'alíquota ' + DO_ESFERA[E] + ' ' + FormatarAliquota(G.pAliq) + ' no XML e ' +
                                FormatarAliquota(Esperado) + ' para ' + Ano + '; confira (alerta).';
                AdicionarDivergencia(R, It.NumeroItem, 4, 'N4-' + TAG_ALIQ_ESFERA[E],
                    GRUPO_ESFERA[E] + '/' + TAG_ALIQ_ESFERA[E],
                    'Alíquota ' + CURTO_ESFERA[E] + ' (' + TAG_ALIQ_ESFERA[E] + ')',
                    FormatarValorGabaritoIBSCBS(G.pAliq, 4), FormatarValorGabaritoIBSCBS(Esperado, 4),
                    FormatarAliquota(G.pAliq), FormatarAliquota(Esperado), TextoEsp);
            end;
        end;

        //N4-gRed e N4-pRedAliq (17.17, 17.18 e 17.18a)
        if E = esCBS then
            pRedTabela := LinhaCCl.pRedCBS
        else
            pRedTabela := LinhaCCl.pRedIBS;
        if LinhaCST.ReducaoAliquota then
        begin
            if not G.TemRed then
                AdicionarDivergencia(R, It.NumeroItem, 4, 'N4-gRed', GRUPO_ESFERA[E] + '/gRed',
                    'Redução ' + CURTO_ESFERA[E] + ' (gRed)',
                    'ausente', 'pRedAliq ' + FormatarValorGabaritoIBSCBS(pRedTabela, 4),
                    'ausente', FormatarPercentual(pRedTabela),
                    Pref + 'sem redução ' + DO_ESFERA[E] + ' no XML, e a tabela prevê ' +
                    FormatarPercentual(pRedTabela) + ' para o cClassTrib ' + It.cClassTrib + '; confira (alerta).')
            else if Abs(G.pRedAliq - pRedTabela) > TOL_ALIQ then
                AdicionarDivergencia(R, It.NumeroItem, 4, 'N4-pRedAliq', GRUPO_ESFERA[E] + '/gRed/pRedAliq',
                    'Redução ' + CURTO_ESFERA[E] + ' (pRedAliq)',
                    FormatarValorGabaritoIBSCBS(G.pRedAliq, 4), FormatarValorGabaritoIBSCBS(pRedTabela, 4),
                    FormatarPercentual(G.pRedAliq), FormatarPercentual(pRedTabela),
                    Pref + 'redução ' + DO_ESFERA[E] + ' de ' + FormatarPercentual(G.pRedAliq) + ' no XML e ' +
                    FormatarPercentual(pRedTabela) + ' pela tabela do cClassTrib ' + It.cClassTrib +
                    '; confira (alerta).');
        end
        else if G.TemRed and not (Nota.TemCompraGov and (G.pRedAliq = 0)) then
            AdicionarDivergencia(R, It.NumeroItem, 4, 'N4-gRed', GRUPO_ESFERA[E] + '/gRed',
                'Redução ' + CURTO_ESFERA[E] + ' (gRed)',
                'pRedAliq ' + FormatarValorGabaritoIBSCBS(G.pRedAliq, 4),
                'ausente (CST ' + It.CST + ' nao permite reducao)',
                FormatarPercentual(G.pRedAliq), 'ausente',
                Pref + 'redução ' + DO_ESFERA[E] + ' de ' + FormatarPercentual(G.pRedAliq) + ' no XML, e o CST ' +
                It.CST + ' não prevê redução; confira (alerta).');

        //N4-gDif (17.19 e 17.19a)
        if LinhaCST.Diferimento and not G.TemDif then
            AdicionarDivergencia(R, It.NumeroItem, 4, 'N4-gDif', GRUPO_ESFERA[E] + '/gDif',
                'Diferimento ' + CURTO_ESFERA[E] + ' (gDif)',
                'ausente', 'presente', 'ausente', 'presente',
                Pref + 'sem diferimento ' + DO_ESFERA[E] + ' no XML, e o CST ' + It.CST +
                ' prevê diferimento; confira (alerta).')
        else if (not LinhaCST.Diferimento) and G.TemDif then
            AdicionarDivergencia(R, It.NumeroItem, 4, 'N4-gDif', GRUPO_ESFERA[E] + '/gDif',
                'Diferimento ' + CURTO_ESFERA[E] + ' (gDif)',
                'presente', 'ausente (CST ' + It.CST + ' nao permite diferimento)', 'presente', 'ausente',
                Pref + 'diferimento ' + DO_ESFERA[E] + ' no XML, e o CST ' + It.CST +
                ' não prevê diferimento; confira (alerta).');
    end;

    //N4-gTribRegular (17.20 e 17.20a)
    if TribReg <> It.TemTribRegular then
    begin
        if It.TemTribRegular then
            AdicionarDivergencia(R, It.NumeroItem, 4, 'N4-gTribRegular', 'gIBSCBS/gTribRegular',
                'Trib. regular (gTribRegular)', 'presente', 'ausente', 'presente', 'ausente',
                Pref + 'tributação regular (gTribRegular) no XML, e o cClassTrib ' + It.cClassTrib +
                ' não prevê esse grupo; confira (alerta).')
        else
            AdicionarDivergencia(R, It.NumeroItem, 4, 'N4-gTribRegular', 'gIBSCBS/gTribRegular',
                'Trib. regular (gTribRegular)', 'ausente', 'presente', 'ausente', 'presente',
                Pref + 'sem tributação regular (gTribRegular) no XML, e o cClassTrib ' + It.cClassTrib +
                ' prevê esse grupo; confira (alerta).');
    end;
end;

{ Nível 2: itens × totais (Erro) }

function ValorItemCampoTotal(const It: TItemIBSCBS; const Indice: Integer): Int64;
begin
    //Campo do item que corresponde ao campo do IBSCBSTot (tabela 2.2 das regras)
    case Indice of
        0 : Result := It.vBC;
        1 : Result := It.Esferas[esIBSUF].vDif;
        2 : Result := It.Esferas[esIBSUF].vDevTrib;
        3 : Result := It.Esferas[esIBSUF].vTributo;
        4 : Result := It.Esferas[esIBSMun].vDif;
        5 : Result := It.Esferas[esIBSMun].vDevTrib;
        6 : Result := It.Esferas[esIBSMun].vTributo;
        7 : Result := It.vIBS;
        8 : Result := It.vCredPresIBS;
        9 : Result := It.vCredPresCondSusIBS;
        10: Result := It.Esferas[esCBS].vDif;
        11: Result := It.Esferas[esCBS].vDevTrib;
        12: Result := It.Esferas[esCBS].vTributo;
        13: Result := It.vCredPresCBS;
        14: Result := It.vCredPresCondSusCBS;
    else
        Result := 0;
    end;
end;

function ValorTotalCampo(const T: TTotalIBSCBS; const Indice: Integer): Int64;
begin
    case Indice of
        0 : Result := T.vBCIBSCBS;
        1 : Result := T.vDif[esIBSUF];
        2 : Result := T.vDevTrib[esIBSUF];
        3 : Result := T.vTributo[esIBSUF];
        4 : Result := T.vDif[esIBSMun];
        5 : Result := T.vDevTrib[esIBSMun];
        6 : Result := T.vTributo[esIBSMun];
        7 : Result := T.vIBS;
        8 : Result := T.vCredPresIBS;
        9 : Result := T.vCredPresCondSusIBS;
        10: Result := T.vDif[esCBS];
        11: Result := T.vDevTrib[esCBS];
        12: Result := T.vTributo[esCBS];
        13: Result := T.vCredPresCBS;
        14: Result := T.vCredPresCondSusCBS;
    else
        Result := 0;
    end;
end;

procedure AdicionarDivergenciaTotal(var R: TConferenciaIBSCBS; const Nota: TNotaIBSCBS;
    const Regra, Tag, Campo, DoCampo: String; const ValorTotal, Soma: Int64);
begin
    //Glossário 17.7, 17.7a e 17.7b
    AdicionarDivergencia(R, ITEM_TOTAL_IBSCBS, 2, Regra, Tag, Campo,
        FormatarValorGabaritoIBSCBS(ValorTotal, 2), FormatarValorGabaritoIBSCBS(Soma, 2),
        FormatarReais(ValorTotal), FormatarReais(Soma),
        PrefixoNota(Nota) + 'total ' + DoCampo + ' ' + FormatarReais(ValorTotal) + ', soma dos itens ' +
        FormatarReais(Soma) + ' (erro).');
end;

procedure ConferirNivel2(var R: TConferenciaIBSCBS; const Nota: TNotaIBSCBS);
var
    I, Campo     : Integer;
    Soma         : Int64;
    QtdItensSN   : Integer;
    SomaIBSSN    : Int64;
    SomaCBSSN    : Int64;
begin
    if (Length(Nota.Itens) > 0) and not Nota.Total.Presente then
    begin
        //W53-10: itens com IBS/CBS e nota sem IBSCBSTot (17.8). Com gTribSN, sai só esta linha
        AdicionarDivergencia(R, ITEM_TOTAL_IBSCBS, 2, 'N2-IBSCBSTot', 'total/IBSCBSTot', 'Total IBS/CBS (IBSCBSTot)',
            'ausente', 'presente', 'ausente', 'presente',
            PrefixoNota(Nota) + 'itens com IBS/CBS e nota sem o total de IBS/CBS (IBSCBSTot) (erro).');
        Exit;
    end;
    if Nota.Total.Presente and (Length(Nota.Itens) = 0) then
    begin
        //W44-10 e D6: IBSCBSTot sem nenhum item com IBS/CBS (17.9)
        AdicionarDivergencia(R, ITEM_TOTAL_IBSCBS, 2, 'N2-IBSCBSTot', 'total/IBSCBSTot', 'Total IBS/CBS (IBSCBSTot)',
            'presente', 'ausente', 'presente', 'ausente',
            PrefixoNota(Nota) + 'total de IBS/CBS (IBSCBSTot) informado e nenhum item com IBS/CBS (erro).');
        Exit;
    end;
    if not Nota.Total.Presente then
        Exit;

    //W58-10 e seguintes: cada campo do total é a soma dos itens, sem tolerância (D5)
    for Campo := 0 to QTD_CAMPOS_TOTAL - 1 do
    begin
        Soma := 0;
        for I := 0 to High(Nota.Itens) do
            Soma := Soma + ValorItemCampoTotal(Nota.Itens[I], Campo);
        if Abs(ValorTotalCampo(Nota.Total, Campo) - Soma) > TOL_N2 then
            AdicionarDivergenciaTotal(R, Nota, REGRA_TOTAL[Campo], 'IBSCBSTot/' + TAG_TOTAL[Campo],
                CAMPO_TOTAL[Campo], DO_CAMPO_TOTAL[Campo], ValorTotalCampo(Nota.Total, Campo), Soma);
    end;

    //Simples Nacional (NT 2026.005, D17)
    QtdItensSN := 0;
    SomaIBSSN  := 0;
    SomaCBSSN  := 0;
    for I := 0 to High(Nota.Itens) do
        if Nota.Itens[I].TemgTribSN then
        begin
            Inc(QtdItensSN);
            SomaIBSSN := SomaIBSSN + Nota.Itens[I].vIBSSN;
            SomaCBSSN := SomaCBSSN + Nota.Itens[I].vCBSSN;
        end;
    if (QtdItensSN > 0) and not Nota.Total.TemgTribSN then
        //W59h-10, rejeição 1275 (17.8a)
        AdicionarDivergencia(R, ITEM_TOTAL_IBSCBS, 2, 'N2-gTribSN', 'IBSCBSTot/gTribSN', 'Total Simples (gTribSN)',
            'ausente', 'presente', 'ausente', 'presente',
            PrefixoNota(Nota) + 'itens com IBS/CBS do Simples Nacional e nota sem o total do Simples Nacional ' +
            '(gTribSN) (erro).')
    else if Nota.Total.TemgTribSN and (QtdItensSN = 0) then
        //W59h-20, rejeição 1276 (17.9a)
        AdicionarDivergencia(R, ITEM_TOTAL_IBSCBS, 2, 'N2-gTribSN', 'IBSCBSTot/gTribSN', 'Total Simples (gTribSN)',
            'presente', 'ausente', 'presente', 'ausente',
            PrefixoNota(Nota) + 'total do Simples Nacional (gTribSN) informado e nenhum item com IBS/CBS do ' +
            'Simples Nacional (erro).')
    else if Nota.Total.TemgTribSN then
    begin
        //W59i-10 (1277) e W59j-10 (1284)
        if Abs(Nota.Total.vIBSSN - SomaIBSSN) > TOL_N2 then
            AdicionarDivergenciaTotal(R, Nota, 'N2-vIBSSN', 'IBSCBSTot/gTribSN/vIBSSN', 'IBS Simples (vIBSSN)',
                'do IBS do Simples Nacional', Nota.Total.vIBSSN, SomaIBSSN);
        if Abs(Nota.Total.vCBSSN - SomaCBSSN) > TOL_N2 then
            AdicionarDivergenciaTotal(R, Nota, 'N2-vCBSSN', 'IBSCBSTot/gTribSN/vCBSSN', 'CBS Simples (vCBSSN)',
                'da CBS do Simples Nacional', Nota.Total.vCBSSN, SomaCBSSN);
    end;
end;

{ Casos sem conferência (D9 e D14) }

procedure ColetarSemConferencia(var R: TConferenciaIBSCBS; const Nota: TNotaIBSCBS);
var
    I         : Integer;
    It        : TItemIBSCBS;
    Fin       : String;
    TemGrupo  : Boolean;
    TemBase   : Boolean;
begin
    Fin := FinalidadeNota(Nota);
    TemGrupo := False;
    TemBase  := False;
    for I := 0 to High(Nota.Itens) do
    begin
        It := Nota.Itens[I];
        //Glossário 17.22a e 17.22b
        if It.CST = '620' then
            AdicionarSemConferencia(R, It.NumeroItem, msMonofasica)
        else if It.CST = '800' then
            AdicionarSemConferencia(R, It.NumeroItem, msTransfCredito)
        else if It.CST = '810' then
            AdicionarSemConferencia(R, It.NumeroItem, msAjusteZFM)
        else if It.CST = '811' then
            AdicionarSemConferencia(R, It.NumeroItem, msAjusteCompet);
        //17.22c e 17.22d
        if It.TemTribCompraGov then
            AdicionarSemConferencia(R, It.NumeroItem, msCompraGov);
        if It.TemCredPresIBSZFM then
            AdicionarSemConferencia(R, It.NumeroItem, msCredPresZFM);
        if It.TemgIBSCBS then
        begin
            TemGrupo := True;
            if (It.CST <> '222') and (It.CST <> '830') then
                TemBase := True;
        end;
    end;

    //17.22e e 17.22f: base (e, na devolução, alíquotas) fora da conferência nas notas que não são normais (D3)
    if TemGrupo and (Fin = '4') then
        AdicionarSemConferencia(R, ITEM_TOTAL_IBSCBS, msDevolucao)
    else if TemBase and ((Fin = '2') or (Fin = '3') or (Fin = '5') or (Fin = '6')) then
        AdicionarSemConferencia(R, ITEM_TOTAL_IBSCBS, msOutraFinalidade);
    //17.22g
    if TemGrupo and (Fin <> '4') and
       ((Nota.tpNFCredito = '03') or (Nota.tpNFCredito = '04') or (Nota.tpNFCredito = '06')) then
        AdicionarSemConferencia(R, ITEM_TOTAL_IBSCBS, msNotaCredito);
    //17.22i (D14)
    if Nota.Total.TemgMono then
        AdicionarSemConferencia(R, ITEM_TOTAL_IBSCBS, msTotalMono);
    if Nota.Total.TemgEstornoCred then
        AdicionarSemConferencia(R, ITEM_TOTAL_IBSCBS, msTotalEstorno);
end;

function ListaDeItens(const Itens: TArray<Integer>): String;
var
    I: Integer;
begin
    //"item 1", "itens 1 e 3", "itens 1, 3 e 4" (glossário 17.22a)
    if Length(Itens) = 1 then
        Exit('item ' + IntToStr(Itens[0]));
    Result := 'itens ';
    for I := 0 to High(Itens) do
    begin
        if I = High(Itens) then
            Result := Result + ' e '
        else if I > 0 then
            Result := Result + ', ';
        Result := Result + IntToStr(Itens[I]);
    end;
end;

function DescricaoMotivo(const Nota: TNotaIBSCBS; const Motivo: TMotivoSemConferenciaIBSCBS): String;
var
    Fin: String;
begin
    Fin := FinalidadeNota(Nota);
    case Motivo of
        msMonofasica    : Result := 'tributação monofásica, CST 620';
        msTransfCredito : Result := 'transferência de crédito, CST 800';
        msAjusteZFM     : Result := 'ajuste de IBS na ZFM, CST 810';
        msAjusteCompet  : Result := 'ajuste de competência, CST 811';
        msCompraGov     : Result := 'compra governamental, valores sem o redutor';
        msCredPresZFM   : Result := 'crédito presumido da ZFM';
        msDevolucao     : Result := 'base e alíquotas (devolução, finNFe 4)';
        msOutraFinalidade:
            if Fin = '2' then
                Result := 'base (nota complementar, finNFe 2)'
            else if Fin = '3' then
                Result := 'base (nota de ajuste, finNFe 3)'
            else if Fin = '5' then
                Result := 'base (nota de crédito, finNFe 5)'
            else
                Result := 'base (nota de débito, finNFe 6)';
        msNotaCredito   : Result := 'alíquotas (nota de crédito, tpNFCredito ' + Nota.tpNFCredito + ')';
        msAliquotaCBSAno: Result := 'alíquota da CBS de ' + Copy(Nota.DataEmissao, 1, 4) +
                                    ' (depende da alíquota de referência)';
        msAliquotaIBSAno: Result := 'alíquotas do IBS de ' + Copy(Nota.DataEmissao, 1, 4) +
                                    ' (dependem da lei de cada ente)';
        msTotalMono     : Result := 'totais de IBS/CBS monofásico (gMono)';
        msTotalEstorno  : Result := 'totais de estorno de crédito (gEstornoCred)';
    else
        Result := '';
    end;
end;

function TextoSemConferencia(const R: TConferenciaIBSCBS; const Nota: TNotaIBSCBS): String;
const
    MOTIVOS_ITEM = [msMonofasica, msTransfCredito, msAjusteZFM, msAjusteCompet, msCompraGov, msCredPresZFM];
var
    M      : TMotivoSemConferenciaIBSCBS;
    I      : Integer;
    Itens  : TArray<Integer>;
    TemNota: Boolean;
    Partes : String;
begin
    //Glossário 17.21: uma linha por nota, com os motivos separados por "; "
    Partes := '';
    for M := Low(TMotivoSemConferenciaIBSCBS) to High(TMotivoSemConferenciaIBSCBS) do
    begin
        SetLength(Itens, 0);
        TemNota := False;
        for I := 0 to High(R.SemConferencia) do
            if R.SemConferencia[I].Motivo = M then
            begin
                if M in MOTIVOS_ITEM then
                begin
                    SetLength(Itens, Length(Itens) + 1);
                    Itens[High(Itens)] := R.SemConferencia[I].Item;
                end
                else
                    TemNota := True;
            end;
        if Length(Itens) > 0 then
        begin
            if Partes <> '' then
                Partes := Partes + '; ';
            Partes := Partes + ListaDeItens(Itens) + ' (' + DescricaoMotivo(Nota, M) + ')';
        end
        else if TemNota then
        begin
            if Partes <> '' then
                Partes := Partes + '; ';
            Partes := Partes + DescricaoMotivo(Nota, M);
        end;
    end;
    if Partes = '' then
        Result := ''
    else
        Result := 'Nota Fiscal ' + Nota.NumeroNF + ', sem conferência de IBS/CBS: ' + Partes + '.';
end;

{ Conferência da nota }

function ConferirNotaIBSCBS(const Nota: TNotaIBSCBS): TConferenciaIBSCBS;
var
    I: Integer;
begin
    Result.Situacao            := scVazia;
    SetLength(Result.Divergencias, 0);
    Result.QuantidadeErros     := 0;
    Result.QuantidadeAlertas   := 0;
    SetLength(Result.SemConferencia, 0);
    Result.TextoSemConferencia := '';
    Result.SimplesNacional     := False;

    //Fora da conferência: nota sem item com IBSCBS e sem IBSCBSTot
    if (Length(Nota.Itens) = 0) and not Nota.Total.Presente then
        Exit;

    //Por item, na ordem do script: níveis 1 e 3 (só com gIBSCBS) e nível 4 (todo item com IBSCBS)
    for I := 0 to High(Nota.Itens) do
    begin
        if Nota.Itens[I].TemgIBSCBS then
        begin
            ConferirNivel1(Result, Nota, Nota.Itens[I]);
            ConferirNivel3(Result, Nota, Nota.Itens[I]);
        end;
        ConferirNivel4(Result, Nota, Nota.Itens[I]);
        //D22: item do Simples Nacional sem gIBSCBS (só totais e cClassTrib conferidos)
        if Nota.Itens[I].TemgTribSN and not Nota.Itens[I].TemgIBSCBS then
            Result.SimplesNacional := True;
    end;
    ConferirNivel2(Result, Nota);

    ColetarSemConferencia(Result, Nota);
    Result.TextoSemConferencia := TextoSemConferencia(Result, Nota);

    if Result.QuantidadeErros > 0 then
        Result.Situacao := scErro
    else if Result.QuantidadeAlertas > 0 then
        Result.Situacao := scAlerta
    else
        Result.Situacao := scOK;
end;

function TextoResumoConferenciaIBSCBS(const Conferidas, ComErro, ComAlerta, Simples: Integer): String;
var
    TextoSimples: String;
begin
    //17.23b: menção do Simples Nacional no fim da linha (D22, P7-15)
    if Simples = 0 then
        TextoSimples := ''
    else if Simples = Conferidas then
    begin
        if Conferidas = 1 then
            TextoSimples := '; do Simples Nacional, sem conferir base e alíquota'
        else
            TextoSimples := '; todas do Simples Nacional, sem conferir base e alíquota';
    end
    else
        TextoSimples := '; ' + IntToStr(Simples) + ' do Simples Nacional, sem conferir base e alíquota';

    Result := 'Conferência de IBS/CBS: ' + IntToStr(Conferidas) +
              Singular(Conferidas, ' nota conferida', ' notas conferidas');
    if (ComErro = 0) and (ComAlerta = 0) then
        //17.23a
        Result := Result + ', sem divergência'
    else if ComAlerta = 0 then
        Result := Result + ', ' + IntToStr(ComErro) + ' com Erro'
    else if ComErro = 0 then
        Result := Result + ', ' + IntToStr(ComAlerta) + ' com Alerta'
    else
        Result := Result + ', ' + IntToStr(ComErro) + ' com Erro e ' + IntToStr(ComAlerta) + ' com Alerta';
    Result := Result + TextoSimples + '.';
end;

function TextoSituacaoIBSCBS(const Situacao: TSituacaoConferenciaIBSCBS): String;
begin
    case Situacao of
        scOK    : Result := 'OK';
        scAlerta: Result := 'Alerta';
        scErro  : Result := 'Erro';
    else
        Result := '';
    end;
end;

end.
