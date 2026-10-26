unit ProXML.Tema;

{ Tema visual do ProXML (Plano 4, etapa 4.2).

  Fonte única de cores, fontes e medidas da interface. Os valores são os de docs/ui/tokens.md,
  com os mesmos nomes: qualquer mudança é feita primeiro lá e depois aqui.
  Nenhuma tela declara cor, fonte ou medida própria (regra 1 de UI do Plano 4).
  Só existe o tema claro; as cores ficam todas aqui para permitir um tema escuro no futuro. }

interface

uses
  System.SysUtils,
  System.UITypes,
  Winapi.Messages,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms;

const
  //--- Paleta (tokens.md, seção 1) ------------------------------------------------------
  //O TColor do Delphi é BGR. RGB() de Winapi.Windows é uma função e não pode ser usada numa
  //declaração const, por isso cada cor é escrita com a mesma conta do RGB(r, g, b):
  //r or (g shl 8) or (b shl 16). O comentário traz o RGB() e o hexadecimal do tokens.md.
  CorMarinho              = TColor( 23 or ( 26 shl 8) or ( 33 shl 16)); //RGB(23, 26, 33)    #171A21
  CorMarinhoTexto         = TColor(201 or (206 shl 8) or (214 shl 16)); //RGB(201, 206, 214) #C9CED6
  CorPrimaria             = TColor( 32 or (103 shl 8) or (202 shl 16)); //RGB(32, 103, 202)  #2067CA
  CorPrimariaHover        = TColor( 26 or ( 86 shl 8) or (171 shl 16)); //RGB(26, 86, 171)   #1A56AB
  CorPrimariaPressionada  = TColor( 22 or ( 74 shl 8) or (147 shl 16)); //RGB(22, 74, 147)   #164A93
  CorPrimariaSuave        = TColor(232 or (240 shl 8) or (251 shl 16)); //RGB(232, 240, 251) #E8F0FB
  CorFundo                = TColor(242 or (243 shl 8) or (245 shl 16)); //RGB(242, 243, 245) #F2F3F5
  CorSuperficie           = TColor(255 or (255 shl 8) or (255 shl 16)); //RGB(255, 255, 255) #FFFFFF
  CorZebra                = TColor(247 or (248 shl 8) or (250 shl 16)); //RGB(247, 248, 250) #F7F8FA
  CorBorda                = TColor(218 or (221 shl 8) or (227 shl 16)); //RGB(218, 221, 227) #DADDE3
  CorBordaCampo           = TColor(135 or (142 shl 8) or (155 shl 16)); //RGB(135, 142, 155) #878E9B
  CorTexto                = TColor( 31 or ( 36 shl 8) or ( 48 shl 16)); //RGB(31, 36, 48)    #1F2430
  CorTextoSecundario      = TColor( 91 or ( 98 shl 8) or (112 shl 16)); //RGB(91, 98, 112)   #5B6270
  CorTextoDesabilitado    = TColor(140 or (147 shl 8) or (160 shl 16)); //RGB(140, 147, 160) #8C93A0
  CorFundoDesabilitado    = TColor(237 or (240 shl 8) or (244 shl 16)); //RGB(237, 240, 244) #EDF0F4
  CorSucesso              = TColor( 24 or (121 shl 8) or ( 58 shl 16)); //RGB(24, 121, 58)   #18793A
  CorSucessoSuave         = TColor(231 or (244 shl 8) or (234 shl 16)); //RGB(231, 244, 234) #E7F4EA
  CorAviso                = TColor(143 or ( 86 shl 8) or (  0 shl 16)); //RGB(143, 86, 0)    #8F5600
  CorAvisoSuave           = TColor(255 or (244 shl 8) or (224 shl 16)); //RGB(255, 244, 224) #FFF4E0
  CorErro                 = TColor(198 or ( 40 shl 8) or ( 40 shl 16)); //RGB(198, 40, 40)   #C62828
  CorErroSuave            = TColor(253 or (236 shl 8) or (234 shl 16)); //RGB(253, 236, 234) #FDECEA
  CorSucessoSobreMarinho  = TColor(127 or (217 shl 8) or (154 shl 16)); //RGB(127, 217, 154) #7FD99A

  //Texto e ícone do botão primário: o "branco" da tabela 5.1 do tokens.md (mesmo valor de CorSuperficie)
  CorTextoSobrePrimaria   = CorSuperficie;
  //Texto do aviso flutuante sobre o marinho: o "branco" da tabela 2.1 do tokens.md
  CorTextoSobreMarinho    = CorSuperficie;

  //--- Tipografia (tokens.md, seção 3) --------------------------------------------------
  //Semibold: usar FonteDestaque com Font.Style = []. fsBold na "Segoe UI" vira Bold (700), mais pesado
  FonteTexto              = 'Segoe UI';
  FonteDestaque           = 'Segoe UI Semibold';

  //Tamanhos em pontos
  TamanhoTituloTela       = 14;   //"Notas", "Enviar por e-mail" (Semibold)
  TamanhoSubtitulo        = 12;   //estado vazio, "Lendo os XMLs..." (Semibold)
  TamanhoValorCard        = 13;   //R$ 1.234.567,89 (Semibold)
  TamanhoContador         = 16;   //contadores do Resumo (Semibold)
  TamanhoCorpo            = 10;   //texto, campos, grade, menu
  TamanhoBotao            = 10;   //botão, item ativo do menu, título de coluna (Semibold)
  TamanhoRotuloCampo      = 9;    //"Servidor SMTP" (Semibold)
  TamanhoLegenda          = 9;    //rótulo do card, legenda, dica, log
  TamanhoRelatorioTitulo  = 16;   //título do relatório (Semibold)
  TamanhoRelatorioDados   = 9;    //dados e títulos de coluna do relatório
  TamanhoRelatorioRodape  = 8;    //rodapé do relatório

  //--- Espaçamento (tokens.md, seção 4): grade de 8 px a 96 dpi -------------------------
  EspacoMeio              = 4;    //meio passo: rótulo -> campo, ícone -> texto em legenda
  Espaco1                 = 8;
  Espaco2                 = 16;
  Espaco3                 = 24;
  Espaco4                 = 32;

  //--- Medidas (tokens.md, seção 4.1), em pixels a 96 dpi -------------------------------
  JanelaLarguraMinima     = 1024;
  JanelaAlturaMinima      = 640;
  AlturaCabecalho         = 48;
  AlturaBarraPasta        = 56;
  LarguraMenu             = 200;
  AlturaItemMenu          = 40;
  AlturaCard              = 64;
  AlturaTituloTela        = 32;
  AlturaBotao             = 32;
  PaddingBotao            = 16;   //padding horizontal do botão
  LarguraMinimaBotao      = 96;
  LarguraBotaoDestaque    = 120;  //Processar e Salvar
  AlturaCampo             = 32;
  AlturaTituloGrade       = 32;
  AlturaLinhaGrade        = 28;

  //Botão (tokens.md, seção 5.1)
  RaioBotao               = 4;    //cantos arredondados
  EspessuraFoco           = 2;    //contorno de foco
  AfastamentoFoco         = 2;    //distância entre o botão e o contorno de foco

  //Seletor segmentado (tokens.md, seção 5.2)
  PaddingSegmento         = 12;   //padding horizontal de cada segmento

  //Campo (tokens.md, seção 5.3)
  PaddingCampo            = 8;    //padding horizontal dentro do campo
  BordaCampo              = 1;    //borda normal
  BordaCampoFoco          = 2;    //borda com foco

  //Quadros (cards, quadros das telas, indicador do filtro): contorno de 1 px CorBorda
  BordaQuadro             = 1;

  //Card de total (tokens.md, seção 5.5)
  PaddingCardVertical     = 10;
  PaddingCardHorizontal   = 12;
  AlturaRotuloCard        = 16;   //linha 1: ícone + rótulo
  AlturaValorCard         = 22;   //linha 2: valor
  TamanhoValorCardMinimo  = 9;    //o valor diminui até aqui para nunca ser cortado

  //Faixa de status (tokens.md, seção 5.8)
  PaddingFaixaVertical    = 12;
  PaddingFaixaHorizontal  = 16;
  BarraFaixa              = 4;    //barra colorida à esquerda

  //Cabeçalho (tokens.md, seção 4.1; logo vetorial 157x32 mostrado a 28 px de altura)
  LarguraLogo             = 137;
  AlturaLogo              = 28;

  //Menu lateral (tokens.md, seções 4.1 e 5.6; mockups: classe .mi)
  TopoMenu                = 8;    //primeiro item 8 px abaixo do topo do menu
  BarraItemMenu           = 4;    //barra à esquerda do item (transparente; ativo: CorPrimaria)
  PaddingItemMenu         = 16;   //da barra até o ícone
  EspacoIconeMenu         = 12;   //ícone -> texto do item
  BordaMenu               = 1;    //divisória à direita do menu (CorBorda)

  //Tela Relatórios (mockup relatorios.html: .opc, .rod, .dica e .chip)
  PaddingOpcao            = 16;   //padding do quadro de cada relatório
  EspacoDica              = 12;   //botão -> dica visível ao lado
  PaddingChipHorizontal   = 8;    //indicador do filtro ("Modelo: Todos · 19 notas")
  PaddingChipVertical     = 2;
  EspacoIconeChip         = 6;    //ícone -> texto do indicador

  //Tela Carregando (tokens.md, seção 5.14; mockup carregando.html)
  LarguraAnimacao         = 160;
  AlturaAnimacao          = 134;
  EspacoCarregando        = 12;   //animação -> texto -> legenda

  //Tela Notas (tokens.md, seções 4.1 e 5.7; mockup notas.html)
  LarguraCampoBusca       = 248;  //campo Buscar na linha de título
  LarguraMinimaCampoBusca = 160;  //o campo encolhe até aqui quando a linha de título não cabe
  PaddingCelulaGrade      = 8;    //padding horizontal do texto nas células e nos títulos
  MarcaSelecaoGrade       = 3;    //marca CorPrimaria na borda esquerda da 1ª célula da linha selecionada
  DivisoriaGrade          = 1;    //linha inferior de cada linha e do título (CorBorda)
  LarguraColunaNumero     = 72;   //Nº
  LarguraColunaModelo     = 64;
  LarguraColunaData       = 88;
  LarguraColunaChaveMin   = 330;  //Chave: o resto da largura, no mínimo isto
  LarguraColunaValor      = 120;
  LarguraColunaBaseICMS   = 120;
  LarguraColunaICMS       = 104;
  LarguraColunaIBS        = 88;
  LarguraColunaCBS        = 96;
  LarguraTextoVazio       = 420;  //largura máxima do texto do estado vazio (mockup .vazio .t2)
  EspacoVazio             = 8;    //ícone -> título -> texto -> botão no estado vazio

  //Aviso flutuante (tokens.md, seção 5.11)
  PaddingAvisoVertical    = 8;
  PaddingAvisoHorizontal  = 16;
  DistanciaAvisoBorda     = 16;   //acima da borda inferior da grade
  DuracaoAvisoMs          = 2000; //some sozinho depois disto

  //Resumo (tokens.md, seções 5.8 a 5.10; mockup resumo.html), etapa 4.6
  EspacoBlocos            = 16;   //entre os blocos do Resumo (contadores, faixa, log)
  PaddingFaixaCompacta    = 8;    //padding vertical da faixa de aviso entre os contadores e o log
  PaddingProgressoVertical   = 32;  //quadro "Lendo os XMLs…"
  PaddingProgressoHorizontal = 48;
  EspacoProgresso         = 12;   //título -> barra -> contagem -> Cancelar
  EspacoAcoesProgresso    = 8;    //espaço extra acima da linha do Cancelar
  AlturaBarraProgresso    = 8;    //trilho CorBorda + preenchimento CorPrimaria (tokens.md 5.10)
  AlturaLinhaProgresso    = 32;   //linha "{x} de {n} arquivos" + nome do arquivo
  EspacoContadores        = 8;    //entre os 4 contadores
  BordaSuperiorContador   = 4;    //borda superior na cor do status (tokens.md 5.9)
  PaddingContadorVertical    = 8;
  PaddingContadorHorizontal  = 12;
  EspacoIconeContador     = 12;   //ícone -> número
  PaddingTituloLogVertical   = 8; //linha "Detalhes da leitura · Processado em …"
  PaddingTituloLogHorizontal = 12;
  PaddingLog              = 4;    //respiro acima e abaixo da lista do log
  AlturaLinhaLog          = 24;   //linha da lista do log (owner-draw, decisão da 4.6)
  PaddingLinhaLog         = 12;   //padding horizontal da linha do log
  EspacoIconeLog          = 8;    //ícone -> texto na linha do log
  EspacoAtalhosVazio      = 4;    //botão -> legenda dos atalhos no estado vazio do Resumo
  EspacoIconeFaixa        = 12;   //ícone -> texto nas faixas de status (mockup .banner)

  //Telas Enviar, Configurações e Sobre (mockups enviar.html, configuracoes.html e sobre.html), etapa 4.7
  PaddingPainelVertical   = 16;   //quadro da tela (mockup .panel: padding 16 24)
  PaddingPainelHorizontal = 24;
  EspacoFormulario        = 12;   //entre os blocos do quadro e entre as linhas do formulário (gap 12)
  EspacoColunasFormulario = 16;   //entre as colunas do formulário (gap 12 16)
  EspacoAcoesFormulario   = 4;    //espaço extra acima da linha de botões de Configurações (margin-top 4)
  LarguraMinimaFormulario = 600;  //abaixo disto aparece a rolagem de reserva (Enviar e Configurações)
  LarguraCampoPorta       = 120;  //coluna Porta
  LarguraColunaSeguranca  = 200;  //coluna Segurança (SSL e TLS)
  EspacoCaixasSelecao     = 24;   //entre as caixas SSL e TLS
  AlturaMensagemEnviar    = 72;   //campo Mensagem da tela Enviar
  AlturaMensagemConfig    = 56;   //campo "Mensagem padrão do e-mail"
  PaddingAnexoVertical    = 12;   //quadro do anexo (mockup .anexo: padding 12 16, gap 12)
  PaddingAnexoHorizontal  = 16;
  EspacoIconeAnexo        = 12;
  TamanhoIconeErroCampo   = 14;   //circle-alert da mensagem de erro do campo (tokens.md 5.3)
  DuracaoConfigSalvaMs    = 3000; //"Configurações salvas" (tokens.md 5.11)
  LarguraLogoSobre        = 216;  //logo claro da tela Sobre (mockup .sobre .lg img)
  AlturaLogoSobre         = 44;
  PaddingLogoSobre        = 8;    //respiro do logo em cima e embaixo (.lg: padding 8 0, margin-bottom 8)
  EspacoSobre             = 8;    //entre as linhas da tela Sobre (gap 8)
  EspacoAutorSobre        = 8;    //espaço extra acima de "Desenvolvido por" (margin-top 8)
  EspacoCreditosSobre     = 16;   //espaço extra acima dos créditos (margin-top 16)
  MarcaSobreAtivo         = 2;    //linha CorPrimaria embaixo do "Sobre" do cabeçalho com a tela aberta

  //Relatórios A4 no QuickReport (tokens.md, seção 6; mockup relatorio-a4.html), etapa 4.8.
  //Pixels a 96 dpi; o relatório converte para milímetros (não depende da escala da tela)
  LarguraUtilRelatorio    = 718;  //A4 retrato com margens de 10 mm
  AlturaTituloRelatorio   = 26;   //linha do título "Relatório de Notas" (16 pt Semibold)
  AlturaLinhaInfoRelatorio = 17;  //linhas "Período · Modelo · quantidade" e "Pasta" (9 pt)
  LinhaCabecalhoRelatorio = 2;    //linha CorMarinho embaixo do cabeçalho da 1ª página
  LarguraLogoRelatorio    = 98;   //logo claro à direita do cabeçalho (mockup .wm img)
  AlturaLogoRelatorio     = 20;
  ResolucaoLogoRelatorio  = 600;  //dpi da imagem do logo desenhada pelo Skia (nítida no papel)
  EspacoLogoRelatorio     = 16;   //texto do cabeçalho -> logo (a pasta é cortada antes disto)
  TamanhoMarcaRelatorio   = 12;   //"ProXML" em texto, se o logo não puder ser desenhado (Semibold)
  PaddingCelulaRelatorio  = 6;    //padding horizontal do texto nas colunas (mockup .rt td)
  //Colunas do Relatório de Notas: Nº · Mod. · Data · Chave (o resto) · Valor · Base ICMS · ICMS
  LarguraRelNumero        = 64;   //52 no tokens.md; 64 por decisão do usuário (nNF de até 9 dígitos), tirados da Chave
  LarguraRelModelo        = 36;
  LarguraRelData          = 68;
  LarguraRelValor         = 92;
  LarguraRelBaseICMS      = 96;
  LarguraRelICMS          = 80;
  //Colunas do Relatório IBS/CBS (decisão D9): Nº · Modelo · Data · Base IBS/CBS (o resto) · IBS UF ·
  //IBS Mun. · IBS · CBS
  LarguraRelIBSNumero     = 60;
  LarguraRelIBSModelo     = 56;
  LarguraRelIBSData       = 76;
  LarguraRelIBSUF         = 96;
  LarguraRelIBSMun        = 100;
  LarguraRelIBS           = 88;
  LarguraRelCBS           = 88;
  //"Mod." e as datas são um pouco mais largos que a coluna menos o padding: nessas colunas o texto
  //usa só este padding (título e dado continuam com o mesmo Left/Width)
  PaddingCelulaEstreita   = 2;

  //Ícones
  TamanhoIconePequeno     = 16;   //botões, campos, cards
  TamanhoIconeDica        = 14;   //dicas visíveis, indicador do filtro e "Configurações salvas"
  TamanhoIconeMenu        = 20;   //menu, faixas, título das opções de relatório
  TamanhoIconeContador    = 24;   //contadores do Resumo
  TamanhoIconeVazio       = 48;   //estados vazios

//Aplica nome, tamanho (pt) e cor numa fonte, sem estilo (Semibold vem do nome da fonte)
procedure AplicarFonte(Fonte: TFont; const Nome: string; const Tamanho: Integer; const Cor: TColor);

//Padroniza a fonte do formulário (Segoe UI 10 pt, CorTexto) e troca as fontes antigas
//(Tahoma, MS Sans Serif) que ainda estejam nos controles pela fonte do tema, mantendo
//tamanho, cor e estilo de cada controle. Não mexe em cores nem em posições.
procedure AplicarTema(Form: TForm);

//Escala atual (DPI) da tela de um controle. No Delphi 10.2 o PixelsPerInch do formulário fica
//com o valor do .dfm (96) mesmo depois de a VCL escalar a tela para o monitor (125%, 150%): a tela
//principal guarda a escala atual e responde a WM_PROXML_PPI. Sem resposta, vale o PixelsPerInch
const
  WM_PROXML_PPI = WM_APP + 43;
function PPIDoControle(Controle: TControl): Integer;

//Medida do tema (96 dpi) convertida para a escala atual da tela do controle
function EscalarPara(Controle: TControl; const Valor: Integer): Integer;

//Converte um TColor (BGR, aceita cores do sistema) em TAlphaColor opaco (ARGB), usado pelo Skia
function CorAlpha(const Cor: TColor): TAlphaColor;

//Formato monetário único da interface (glossário 4.6, P7): "R$ 1.234.567,89".
//Usa um TFormatSettings pt-BR próprio, nunca a configuração regional do Windows.
//Vale para os cards, a grade (4.5) e os relatórios (4.8)
function FormatarMoeda(const Valor: Double): string;

//Configuração pt-BR usada por FormatarMoeda (vírgula decimal, ponto de milhar)
function FormatoPtBR: TFormatSettings;

//Valor sem o "R$", no mesmo formato pt-BR: "1.234.567,89". Colunas e totais dos relatórios
//impressos (decisão D11: o "(R$)" fica só no título da coluna)
function FormatarValor(const Valor: Double): string;

implementation

uses
  System.Classes,
  Winapi.Windows;

type
  //Acesso à Font e à ParentFont (protegidas em TControl)
  TControleAcesso = class(TControl);

procedure AplicarFonte(Fonte: TFont; const Nome: string; const Tamanho: Integer; const Cor: TColor);
begin
    Fonte.Name  := Nome;
    Fonte.Size  := Tamanho;
    Fonte.Color := Cor;
    Fonte.Style := [];
end;

function FonteAntiga(const Nome: string): Boolean;
begin
    //Fontes que o tema substitui na tela. Os relatórios definem as fontes deles (etapa 4.8)
    Result := SameText(Nome, 'Tahoma') or SameText(Nome, 'MS Sans Serif');
end;

procedure AplicarTema(Form: TForm);
var
    I: Integer;
    Controle: TControleAcesso;
begin
    //Fonte base do formulário (fim do Tahoma)
    AplicarFonte(Form.Font, FonteTexto, TamanhoCorpo, CorTexto);

    //Controles com fonte própria antiga passam para a fonte do tema (só o nome muda)
    for I := 0 to Form.ComponentCount - 1 do
    begin
        if not (Form.Components[I] is TControl) then
            Continue;

        Controle := TControleAcesso(Form.Components[I]);
        if (not Controle.ParentFont) and FonteAntiga(Controle.Font.Name) then
            Controle.Font.Name := FonteTexto;
    end;
end;

function CorAlpha(const Cor: TColor): TAlphaColor;
var
    RGBCor: Longint;
begin
    RGBCor := ColorToRGB(Cor);
    Result := $FF000000 or
              (TAlphaColor(GetRValue(RGBCor)) shl 16) or
              (TAlphaColor(GetGValue(RGBCor)) shl 8) or
              TAlphaColor(GetBValue(RGBCor));
end;

function PPIDoControle(Controle: TControl): Integer;
var
    Form: TCustomForm;
begin
    Result := 0;
    Form   := nil;
    if Controle <> nil then
        Form := GetParentForm(Controle);
    if Form <> nil then
        Result := Form.Perform(WM_PROXML_PPI, 0, 0);
    if Result < 30 then
    begin
        if (Form <> nil) and (Form is TForm) and (TForm(Form).PixelsPerInch > 0) then
            Result := TForm(Form).PixelsPerInch
        else
            Result := Screen.PixelsPerInch;
    end;
end;

function EscalarPara(Controle: TControl; const Valor: Integer): Integer;
begin
    Result := MulDiv(Valor, PPIDoControle(Controle), 96);
end;

var
    FFormatoPtBR: TFormatSettings;

function FormatoPtBR: TFormatSettings;
begin
    Result := FFormatoPtBR;
end;

function FormatarMoeda(const Valor: Double): string;
begin
    Result := FormatFloat('"R$ "#,##0.00', Valor, FFormatoPtBR);
end;

function FormatarValor(const Valor: Double): string;
begin
    Result := FormatFloat('#,##0.00', Valor, FFormatoPtBR);
end;

initialization
    //pt-BR explícito: os separadores são fixados aqui e não dependem do Windows
    FFormatoPtBR := TFormatSettings.Create('pt-BR');
    FFormatoPtBR.DecimalSeparator  := ',';
    FFormatoPtBR.ThousandSeparator := '.';

end.
