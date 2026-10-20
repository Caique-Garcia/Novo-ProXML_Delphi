unit ProXML.Tema;

{ Tema visual do ProXML (Plano 4, etapa 4.2).

  Fonte única de cores, fontes e medidas da interface. Os valores são os de docs/ui/tokens.md,
  com os mesmos nomes: qualquer mudança é feita primeiro lá e depois aqui.
  Nenhuma tela declara cor, fonte ou medida própria (regra 1 de UI do Plano 4).
  Só existe o tema claro; as cores ficam todas aqui para permitir um tema escuro no futuro. }

interface

uses
  System.UITypes,
  Vcl.Graphics,
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

  //Ícones
  TamanhoIconePequeno     = 16;   //botões, campos, cards
  TamanhoIconeMenu        = 20;   //menu, faixas
  TamanhoIconeContador    = 24;   //contadores do Resumo
  TamanhoIconeVazio       = 48;   //estados vazios

//Aplica nome, tamanho (pt) e cor numa fonte, sem estilo (Semibold vem do nome da fonte)
procedure AplicarFonte(Fonte: TFont; const Nome: string; const Tamanho: Integer; const Cor: TColor);

//Padroniza a fonte do formulário (Segoe UI 10 pt, CorTexto) e troca as fontes antigas
//(Tahoma, MS Sans Serif) que ainda estejam nos controles pela fonte do tema, mantendo
//tamanho, cor e estilo de cada controle. Não mexe em cores nem em posições.
procedure AplicarTema(Form: TForm);

//Converte um TColor (BGR, aceita cores do sistema) em TAlphaColor opaco (ARGB), usado pelo Skia
function CorAlpha(const Cor: TColor): TAlphaColor;

implementation

uses
  System.SysUtils,
  System.Classes,
  Winapi.Windows,
  Vcl.Controls;

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
    //Fontes que o tema substitui na tela. O Courier New dos relatórios fica para a etapa 4.8
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

end.
