unit ProXML.Botao;

{ TProBotao: botão próprio do ProXML (Plano 4, etapa 4.2; visual em docs/ui/tokens.md, seção 5.1).

  - Estilos primário e secundário; estados normal, hover, pressionado, foco e desabilitado.
  - Recebe foco por Tab e é acionado por Enter ou Espaço.
  - Action opcional (herdada de TControl) e ícone SVG opcional, desenhado com o Skia.
  - Criado em runtime (TProBotao.CriarEm): nada é instalado na IDE. No .dfm fica só o painel
    de encaixe, e o botão ocupa o painel inteiro.

  O botão reserva em volta da face uma margem (AfastamentoFoco + EspessuraFoco) para o contorno
  de foco, que fica afastado da face como no tokens.md. Por isso o painel de encaixe é maior que
  a face visível. O contorno só aparece quando o foco chega pelo teclado (como no Windows).

  Cores, fontes e medidas vêm de ProXML.Tema. }

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.Classes,
  System.Types,
  System.UITypes,
  Vcl.Controls,
  Vcl.Graphics,
  Skia,
  Skia.Vcl;

type
  //Estilo do botão (tokens.md 5.1). Um único primário por tela
  TEstiloBotao = (ebPrimario, ebSecundario);

  TProBotao = class(TCustomControl)
  private
    FEstilo          : TEstiloBotao;
    FMouseSobre      : Boolean;   //hover
    FPressionadoMouse: Boolean;   //botão esquerdo do mouse pressionado sobre o botão
    FPressionadoTecla: Boolean;   //Espaço pressionado (o clique sai ao soltar)
    FFocoPeloMouse   : Boolean;   //o foco está chegando por um clique
    FMostrarFoco     : Boolean;   //contorno de foco visível (foco veio do teclado)
    FIcone           : TSkSvgBrush;
    FIconeSvg        : string;
    procedure SetEstilo(const Value: TEstiloBotao);
    procedure SetIconeSvg(const Value: string);
    function  Escalar(const Valor: Integer): Integer;
    function  Pressionado: Boolean;
    procedure CoresDoEstado(out Fundo, Borda, Texto: TColor);
    procedure DesenharFundoDoPai;
    procedure DesenharIcone(const Destino: TRect; const Cor: TColor);
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure DoEnter; override;
    procedure DoExit; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    //Dispara o OnClick (ou a Action). Não faz nada com o botão desabilitado
    procedure Click; override;
    //Cria o botão dentro do painel de encaixe do .dfm, ocupando o painel inteiro.
    //O dono é o dono do painel (o formulário), que libera o botão junto com a tela.
    class function CriarEm(Painel: TWinControl; const Texto: string; const Estilo: TEstiloBotao;
      const AoClicar: TNotifyEvent): TProBotao;
    //Margem em volta da face reservada para o contorno de foco (pixels, já na escala da tela)
    function MargemFoco: Integer;
    //Largura do painel de encaixe para mostrar ícone e texto inteiros (padding, largura mínima
    //do tema e margem do foco incluídos)
    function LarguraIdeal: Integer;
    property Estilo: TEstiloBotao read FEstilo write SetEstilo;
    //Conteúdo SVG do ícone (ex.: um arquivo de docs/ui/icones). Vazio = sem ícone.
    //O traço é pintado com a cor do texto do estado atual (OverrideColor do Skia)
    property IconeSvg: string read FIconeSvg write SetIconeSvg;
    //Contorno de foco visível agora (foco chegou pelo teclado)
    property MostrandoFoco: Boolean read FMostrarFoco;
    property Caption;
    property Font;
    property OnClick;
  end;

  { TProSegmentado: seletor de opções em botões segmentados (Plano 4, etapa 4.3; decisão D6;
    visual em docs/ui/tokens.md, seção 5.2). Usado no seletor de modelo (Todos / NF-e 55 / NFC-e 65).

    - Um só controle com N segmentos colados (borda sobreposta em 1 px), cantos arredondados só
      nas pontas. O segmento escolhido fica em CorPrimariaSuave com borda CorPrimaria e texto Semibold.
    - Teclado: o seletor é uma única parada do Tab (como um grupo de opções do Windows);
      Seta para a esquerda/cima e para a direita/baixo, Home e End trocam a opção na hora.
    - Mouse: clique num segmento escolhe a opção. Cada segmento tem a própria dica (Dicas).
    - OnChange só dispara quando o usuário troca a opção (mouse ou teclado). Mudar ItemIndex
      pelo código não dispara o evento, como no TComboBox.
    - Mesma margem do contorno de foco do TProBotao: os dois ficam alinhados na mesma barra. }
  TProSegmentado = class(TCustomControl)
  private
    FItens           : TStrings;
    FDicas           : TStrings;
    FItemIndex       : Integer;
    FSobre           : Integer;   //segmento sob o mouse (-1 = nenhum)
    FFocoPeloMouse   : Boolean;
    FMostrarFoco     : Boolean;
    FOnChange        : TNotifyEvent;
    procedure SetItemIndex(const Value: Integer);
    procedure ItensAlterados(Sender: TObject);
    function  Escalar(const Valor: Integer): Integer;
    function  LarguraSegmento(const Indice: Integer): Integer;
    procedure Escolher(const Indice: Integer);
    procedure DesenharFundoDoPai;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMHintShow(var Message: TCMHintShow); message CM_HINTSHOW;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure DoEnter; override;
    procedure DoExit; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    //Margem em volta dos segmentos reservada para o contorno de foco (igual à do TProBotao)
    function MargemFoco: Integer;
    //Retângulo do segmento (coordenadas do controle). Vazio se o índice não existe
    function RetanguloSegmento(const Indice: Integer): TRect;
    //Segmento no ponto (coordenadas do controle) ou -1
    function SegmentoEm(const X, Y: Integer): Integer;
    //Largura necessária para mostrar todos os segmentos (com a margem do foco)
    function LarguraIdeal: Integer;
    //Textos dos segmentos (um por linha) e dicas de cada um (mesma ordem)
    property Itens: TStrings read FItens;
    property Dicas: TStrings read FDicas;
    property ItemIndex: Integer read FItemIndex write SetItemIndex;
    property MostrandoFoco: Boolean read FMostrarFoco;
    property Font;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

implementation

uses
  Vcl.Forms,
  Vcl.Menus,
  Vcl.Themes,
  ProXML.Tema;

type
  //Acesso à cor do controle pai (protegida em TControl)
  TControleAcesso = class(TControl);

{ TProBotao }

constructor TProBotao.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    ControlStyle := ControlStyle + [csOpaque] - [csDoubleClicks, csSetCaption];
    FEstilo := ebPrimario;
    FIcone  := TSkSvgBrush.Create;
    TabStop := True;
    Cursor  := crHandPoint;
    DoubleBuffered := True;
    ParentFont := False;
    AplicarFonte(Font, FonteDestaque, TamanhoBotao, CorTextoSobrePrimaria);
    Width  := LarguraMinimaBotao + 2 * (AfastamentoFoco + EspessuraFoco);
    Height := AlturaBotao + 2 * (AfastamentoFoco + EspessuraFoco);
end;

destructor TProBotao.Destroy;
begin
    FIcone.Free;
    inherited;
end;

class function TProBotao.CriarEm(Painel: TWinControl; const Texto: string;
  const Estilo: TEstiloBotao; const AoClicar: TNotifyEvent): TProBotao;
begin
    Result := TProBotao.Create(Painel.Owner);
    Result.Estilo  := Estilo;
    Result.Caption := Texto;
    Result.OnClick := AoClicar;
    Result.Align   := alClient;
    Result.Parent  := Painel;
end;

function TProBotao.Escalar(const Valor: Integer): Integer;
begin
    //Medidas do tema estão a 96 dpi; a escala atual vem da tela (ver PPIDoControle)
    Result := EscalarPara(Self, Valor);
end;

function TProBotao.MargemFoco: Integer;
begin
    Result := Escalar(AfastamentoFoco + EspessuraFoco);
end;

function TProBotao.LarguraIdeal: Integer;
var
    Medida : TBitmap;
    Largura: Integer;
begin
    Medida := TBitmap.Create;
    try
        Medida.Canvas.Font.Assign(Font);
        Largura := Medida.Canvas.TextWidth(StripHotkey(Caption));
    finally
        Medida.Free;
    end;

    if FIconeSvg <> '' then
    begin
        Inc(Largura, Escalar(TamanhoIconePequeno));
        if Caption <> '' then
            Inc(Largura, Escalar(Espaco1));
    end;
    Inc(Largura, 2 * Escalar(PaddingBotao));
    if Largura < Escalar(LarguraMinimaBotao) then
        Largura := Escalar(LarguraMinimaBotao);
    Result := Largura + 2 * MargemFoco;
end;

function TProBotao.Pressionado: Boolean;
begin
    Result := FPressionadoTecla or (FPressionadoMouse and FMouseSobre);
end;

procedure TProBotao.SetEstilo(const Value: TEstiloBotao);
begin
    if FEstilo <> Value then
    begin
        FEstilo := Value;
        Invalidate;
    end;
end;

procedure TProBotao.SetIconeSvg(const Value: string);
begin
    if FIconeSvg <> Value then
    begin
        FIconeSvg := Value;
        FIcone.Source := Value;
        Invalidate;
    end;
end;

procedure TProBotao.CoresDoEstado(out Fundo, Borda, Texto: TColor);
begin
    //Tabela 5.1 do tokens.md: fundo / borda / texto (o ícone usa a cor do texto)
    if not Enabled then
    begin
        Fundo := CorFundoDesabilitado;
        Borda := CorBorda;
        Texto := CorTextoDesabilitado;
        Exit;
    end;

    if FEstilo = ebPrimario then
    begin
        Texto := CorTextoSobrePrimaria;
        if Pressionado then
            Fundo := CorPrimariaPressionada
        else if FMouseSobre then
            Fundo := CorPrimariaHover
        else
            Fundo := CorPrimaria;
        Borda := Fundo;
    end
    else
    begin
        Texto := CorTexto;
        Borda := CorBordaCampo;
        if Pressionado then
            Fundo := CorBorda
        else if FMouseSobre then
            Fundo := CorFundo
        else
            Fundo := CorSuperficie;
    end;
end;

procedure TProBotao.DesenharFundoDoPai;
begin
    //Os cantos arredondados e a margem do contorno de foco mostram o fundo do painel de encaixe
    if StyleServices.Enabled and StyleServices.DrawParentBackground(Handle, Canvas.Handle, nil, False) then
        Exit;

    if Parent <> nil then
        Canvas.Brush.Color := TControleAcesso(Parent).Color
    else
        Canvas.Brush.Color := CorSuperficie;
    Canvas.Brush.Style := bsSolid;
    Canvas.FillRect(ClientRect);
end;

procedure TProBotao.DesenharIcone(const Destino: TRect; const Cor: TColor);
var
    Bitmap  : TBitmap;
    Pincel  : TSkSvgBrush;
    Largura : Integer;
    Altura  : Integer;
begin
    //O Skia desenha o SVG num bitmap de 32 bits (alfa pré-multiplicado), que a VCL mistura com o fundo
    Largura := Destino.Right - Destino.Left;
    Altura  := Destino.Bottom - Destino.Top;
    if (Largura <= 0) or (Altura <= 0) then
        Exit;

    FIcone.OverrideColor := CorAlpha(Cor);
    Pincel := FIcone;

    Bitmap := TBitmap.Create;
    try
        Bitmap.SetSize(Largura, Altura);
        Bitmap.SkiaDraw(
            procedure (const ACanvas: ISkCanvas)
            begin
                Pincel.Render(ACanvas, RectF(0, 0, Largura, Altura), 1);
            end);
        Canvas.Draw(Destino.Left, Destino.Top, Bitmap);
    finally
        Bitmap.Free;
    end;
end;

procedure TProBotao.Paint;
var
    Face        : TRect;
    Contorno    : TRect;
    Fundo       : TColor;
    Borda       : TColor;
    Texto       : TColor;
    Raio        : Integer;
    I           : Integer;
    Icone       : Integer;
    EspacoIcone : Integer;
    LarguraTexto: Integer;
    LarguraTotal: Integer;
    X           : Integer;
    AreaTexto   : TRect;
    TextoBotao  : string;
begin
    DesenharFundoDoPai;

    //Face do botão: a área toda menos a margem do contorno de foco
    Face := ClientRect;
    InflateRect(Face, -MargemFoco, -MargemFoco);
    if (Face.Right <= Face.Left) or (Face.Bottom <= Face.Top) then
        Exit;

    CoresDoEstado(Fundo, Borda, Texto);
    Raio := Escalar(RaioBotao);

    Canvas.Pen.Style   := psSolid;
    Canvas.Pen.Width   := 1;
    Canvas.Pen.Color   := Borda;
    Canvas.Brush.Style := bsSolid;
    Canvas.Brush.Color := Fundo;
    Canvas.RoundRect(Face.Left, Face.Top, Face.Right, Face.Bottom, 2 * Raio, 2 * Raio);

    //Contorno de foco: EspessuraFoco px em CorPrimaria, afastado AfastamentoFoco px da face
    if Focused and FMostrarFoco and Enabled then
    begin
        Canvas.Brush.Style := bsClear;
        Canvas.Pen.Color   := CorPrimaria;
        for I := 1 to Escalar(EspessuraFoco) do
        begin
            Contorno := Face;
            InflateRect(Contorno, Escalar(AfastamentoFoco) + I, Escalar(AfastamentoFoco) + I);
            Canvas.RoundRect(Contorno.Left, Contorno.Top, Contorno.Right, Contorno.Bottom,
                             2 * (Raio + Escalar(AfastamentoFoco) + I), 2 * (Raio + Escalar(AfastamentoFoco) + I));
        end;
    end;

    //Ícone (opcional) + texto, centralizados na face
    Canvas.Font.Assign(Font);
    Canvas.Font.Color  := Texto;
    Canvas.Brush.Style := bsClear;
    TextoBotao := Caption;

    Icone       := 0;
    EspacoIcone := 0;
    if FIconeSvg <> '' then
    begin
        Icone := Escalar(TamanhoIconePequeno);
        if TextoBotao <> '' then
            EspacoIcone := Escalar(Espaco1);
    end;

    LarguraTexto := Canvas.TextWidth(StripHotkey(TextoBotao));
    LarguraTotal := Icone + EspacoIcone + LarguraTexto;
    if LarguraTotal > Face.Right - Face.Left - 2 * Escalar(PaddingBotao) then
        LarguraTotal := Face.Right - Face.Left - 2 * Escalar(PaddingBotao);
    X := Face.Left + ((Face.Right - Face.Left) - LarguraTotal) div 2;

    if Icone > 0 then
    begin
        DesenharIcone(Rect(X, Face.Top + ((Face.Bottom - Face.Top) - Icone) div 2,
                           X + Icone, Face.Top + ((Face.Bottom - Face.Top) - Icone) div 2 + Icone), Texto);
        Inc(X, Icone + EspacoIcone);
    end;

    if TextoBotao <> '' then
    begin
        AreaTexto := Rect(X, Face.Top, Face.Right - Escalar(PaddingBotao), Face.Bottom);
        if AreaTexto.Right < AreaTexto.Left + LarguraTexto then
            AreaTexto.Right := Face.Right;
        DrawText(Canvas.Handle, PChar(TextoBotao), Length(TextoBotao), AreaTexto,
                 DT_LEFT or DT_VCENTER or DT_SINGLELINE or DT_END_ELLIPSIS);
    end;
end;

procedure TProBotao.Click;
begin
    if not Enabled then
        Exit;

    //Volta ao visual normal antes de executar (o OnClick pode demorar ou abrir um diálogo)
    FPressionadoMouse := False;
    FPressionadoTecla := False;
    Invalidate;
    inherited Click;
end;

procedure TProBotao.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Enabled and (Button = mbLeft) then
    begin
        if CanFocus and not Focused then
        begin
            FFocoPeloMouse := True;
            try
                SetFocus;
            finally
                FFocoPeloMouse := False;
            end;
        end;
        FPressionadoMouse := True;
        Invalidate;
    end;
    inherited;
end;

procedure TProBotao.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Button = mbLeft then
    begin
        FPressionadoMouse := False;
        Invalidate;
    end;
    inherited;
end;

procedure TProBotao.KeyDown(var Key: Word; Shift: TShiftState);
begin
    if Enabled then
    begin
        //Qualquer tecla com o botão em foco mostra o contorno (uso por teclado)
        if not FMostrarFoco then
        begin
            FMostrarFoco := True;
            Invalidate;
        end;

        case Key of
            VK_SPACE:
            begin
                Key := 0;
                if not FPressionadoTecla then
                begin
                    FPressionadoTecla := True;
                    Invalidate;
                end;
            end;

            VK_RETURN:
            begin
                Key := 0;
                Click;
            end;
        end;
    end;
    inherited;
end;

procedure TProBotao.KeyUp(var Key: Word; Shift: TShiftState);
begin
    if (Key = VK_SPACE) and FPressionadoTecla then
    begin
        Key := 0;
        FPressionadoTecla := False;
        Invalidate;
        Click;
    end;
    inherited;
end;

procedure TProBotao.DoEnter;
begin
    FMostrarFoco := not FFocoPeloMouse;
    Invalidate;
    inherited;
end;

procedure TProBotao.DoExit;
begin
    FPressionadoTecla := False;
    FMostrarFoco := False;
    Invalidate;
    inherited;
end;

procedure TProBotao.CMMouseEnter(var Message: TMessage);
begin
    inherited;
    FMouseSobre := True;
    Invalidate;
end;

procedure TProBotao.CMMouseLeave(var Message: TMessage);
begin
    inherited;
    FMouseSobre := False;
    Invalidate;
end;

procedure TProBotao.CMEnabledChanged(var Message: TMessage);
begin
    inherited;
    if not Enabled then
    begin
        FPressionadoMouse := False;
        FPressionadoTecla := False;
    end;
    Invalidate;
end;

procedure TProBotao.CMTextChanged(var Message: TMessage);
begin
    inherited;
    Invalidate;
end;

procedure TProBotao.CMFontChanged(var Message: TMessage);
begin
    inherited;
    Invalidate;
end;

procedure TProBotao.CMDialogChar(var Message: TCMDialogChar);
begin
    //Tecla de acesso (&) no texto do botão, como no TButton
    if Enabled and Visible and IsAccel(Message.CharCode, Caption) and CanFocus then
    begin
        Click;
        Message.Result := 1;
    end
    else
        inherited;
end;

procedure TProBotao.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
    //O Paint desenha tudo (inclusive o fundo do pai): evita piscar
    Message.Result := 1;
end;

{ TProSegmentado }

constructor TProSegmentado.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    ControlStyle := ControlStyle + [csOpaque] - [csDoubleClicks, csSetCaption];
    FItens := TStringList.Create;
    TStringList(FItens).OnChange := ItensAlterados;
    FDicas := TStringList.Create;
    FItemIndex := -1;
    FSobre := -1;
    TabStop := True;
    Cursor := crHandPoint;
    DoubleBuffered := True;
    ShowHint := True;
    ParentFont := False;
    AplicarFonte(Font, FonteTexto, TamanhoBotao, CorTexto);
    Height := AlturaBotao + 2 * (AfastamentoFoco + EspessuraFoco);
end;

destructor TProSegmentado.Destroy;
begin
    FItens.Free;
    FDicas.Free;
    inherited;
end;

function TProSegmentado.Escalar(const Valor: Integer): Integer;
begin
    //Medidas do tema estão a 96 dpi (mesma regra do TProBotao)
    Result := EscalarPara(Self, Valor);
end;

function TProSegmentado.MargemFoco: Integer;
begin
    Result := Escalar(AfastamentoFoco + EspessuraFoco);
end;

function TProSegmentado.LarguraSegmento(const Indice: Integer): Integer;
var
    Medida: TBitmap;
begin
    //Largura medida sempre com a fonte Semibold: o segmento não muda de tamanho ao ser escolhido
    Medida := TBitmap.Create;
    try
        Medida.Canvas.Font.Assign(Font);
        Medida.Canvas.Font.Name := FonteDestaque;
        Result := Medida.Canvas.TextWidth(FItens[Indice]) + 2 * Escalar(PaddingSegmento);
    finally
        Medida.Free;
    end;
end;

function TProSegmentado.LarguraIdeal: Integer;
var
    I: Integer;
begin
    //Segmentos colados: cada borda interna é compartilhada (1 px a menos por segmento)
    Result := 2 * MargemFoco;
    for I := 0 to FItens.Count - 1 do
        Inc(Result, LarguraSegmento(I) - 1);
    if FItens.Count > 0 then
        Inc(Result);
end;

function TProSegmentado.RetanguloSegmento(const Indice: Integer): TRect;
var
    I: Integer;
    X: Integer;
begin
    Result := Rect(0, 0, 0, 0);
    if (Indice < 0) or (Indice >= FItens.Count) then
        Exit;

    X := MargemFoco;
    for I := 0 to Indice - 1 do
        Inc(X, LarguraSegmento(I) - 1);
    Result := Rect(X, MargemFoco, X + LarguraSegmento(Indice), ClientHeight - MargemFoco);
end;

function TProSegmentado.SegmentoEm(const X, Y: Integer): Integer;
var
    I: Integer;
begin
    Result := -1;
    for I := 0 to FItens.Count - 1 do
        if PtInRect(RetanguloSegmento(I), Point(X, Y)) then
            Result := I;   //na borda compartilhada vale o segmento da direita
end;

procedure TProSegmentado.SetItemIndex(const Value: Integer);
begin
    //Mudança pelo código: não dispara OnChange
    if (Value >= -1) and (Value < FItens.Count) and (Value <> FItemIndex) then
    begin
        FItemIndex := Value;
        Invalidate;
    end;
end;

procedure TProSegmentado.ItensAlterados(Sender: TObject);
begin
    if FItemIndex >= FItens.Count then
        FItemIndex := FItens.Count - 1;
    Invalidate;
end;

procedure TProSegmentado.Escolher(const Indice: Integer);
begin
    //Troca feita pelo usuário: aplica e avisa
    if (Indice < 0) or (Indice >= FItens.Count) or (Indice = FItemIndex) then
        Exit;

    FItemIndex := Indice;
    Invalidate;
    if Assigned(FOnChange) then
        FOnChange(Self);
end;

procedure TProSegmentado.DesenharFundoDoPai;
begin
    //Cantos arredondados e margem do contorno de foco mostram o fundo do painel pai
    if StyleServices.Enabled and StyleServices.DrawParentBackground(Handle, Canvas.Handle, nil, False) then
        Exit;

    if Parent <> nil then
        Canvas.Brush.Color := TControleAcesso(Parent).Color
    else
        Canvas.Brush.Color := CorSuperficie;
    Canvas.Brush.Style := bsSolid;
    Canvas.FillRect(ClientRect);
end;

procedure TProSegmentado.Paint;
var
    Raio     : Integer;
    Ordem    : Integer;
    I        : Integer;
    J        : Integer;
    R        : TRect;
    Contorno : TRect;
    Fundo    : TColor;
    Borda    : TColor;
    Texto    : TColor;
    Estado   : Integer;
    Escolhido: Boolean;
    TextoSeg : string;
begin
    DesenharFundoDoPai;
    if FItens.Count = 0 then
        Exit;

    Raio := Escalar(RaioBotao);

    //O segmento escolhido é desenhado por último: a borda CorPrimaria fica por cima das vizinhas
    for Ordem := 0 to FItens.Count do
    begin
        if Ordem < FItens.Count then
        begin
            I := Ordem;
            if I = FItemIndex then
                Continue;
        end
        else
        begin
            I := FItemIndex;
            if I < 0 then
                Break;
        end;

        R := RetanguloSegmento(I);
        Escolhido := (I = FItemIndex);

        //Tabela 5.2 do tokens.md: fundo / borda / texto
        if not Enabled then
        begin
            Fundo := CorFundoDesabilitado;
            Borda := CorBorda;
            Texto := CorTextoDesabilitado;
        end
        else if Escolhido then
        begin
            Fundo := CorPrimariaSuave;
            Borda := CorPrimaria;
            Texto := CorTexto;
        end
        else
        begin
            if I = FSobre then
                Fundo := CorFundo
            else
                Fundo := CorSuperficie;
            Borda := CorBordaCampo;
            Texto := CorTexto;
        end;

        Canvas.Pen.Style   := psSolid;
        Canvas.Pen.Width   := 1;
        Canvas.Pen.Color   := Borda;
        Canvas.Brush.Style := bsSolid;
        Canvas.Brush.Color := Fundo;

        //Cantos arredondados só nas pontas: desenha o retângulo arredondado estendido para dentro,
        //recortado no segmento, e completa a borda interna com uma linha
        Estado := SaveDC(Canvas.Handle);
        try
            IntersectClipRect(Canvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
            if FItens.Count = 1 then
                Canvas.RoundRect(R.Left, R.Top, R.Right, R.Bottom, 2 * Raio, 2 * Raio)
            else if I = 0 then
            begin
                Canvas.RoundRect(R.Left, R.Top, R.Right + 2 * Raio, R.Bottom, 2 * Raio, 2 * Raio);
                Canvas.MoveTo(R.Right - 1, R.Top);
                Canvas.LineTo(R.Right - 1, R.Bottom);
            end
            else if I = FItens.Count - 1 then
            begin
                Canvas.RoundRect(R.Left - 2 * Raio, R.Top, R.Right, R.Bottom, 2 * Raio, 2 * Raio);
                Canvas.MoveTo(R.Left, R.Top);
                Canvas.LineTo(R.Left, R.Bottom);
            end
            else
                Canvas.Rectangle(R.Left, R.Top, R.Right, R.Bottom);
        finally
            RestoreDC(Canvas.Handle, Estado);
        end;

        //Texto centralizado: Semibold no escolhido
        Canvas.Font.Assign(Font);
        if Escolhido then
            Canvas.Font.Name := FonteDestaque;
        Canvas.Font.Color  := Texto;
        Canvas.Brush.Style := bsClear;
        TextoSeg := FItens[I];
        DrawText(Canvas.Handle, PChar(TextoSeg), Length(TextoSeg), R,
                 DT_CENTER or DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX);

        //Contorno de foco no segmento escolhido (só quando o foco veio do teclado)
        if Escolhido and Focused and FMostrarFoco and Enabled then
        begin
            Canvas.Brush.Style := bsClear;
            Canvas.Pen.Color   := CorPrimaria;
            for J := 1 to Escalar(EspessuraFoco) do
            begin
                Contorno := R;
                InflateRect(Contorno, Escalar(AfastamentoFoco) + J, Escalar(AfastamentoFoco) + J);
                Canvas.RoundRect(Contorno.Left, Contorno.Top, Contorno.Right, Contorno.Bottom,
                                 2 * (Raio + Escalar(AfastamentoFoco) + J), 2 * (Raio + Escalar(AfastamentoFoco) + J));
            end;
        end;
    end;
end;

procedure TProSegmentado.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Enabled and (Button = mbLeft) then
    begin
        if CanFocus and not Focused then
        begin
            FFocoPeloMouse := True;
            try
                SetFocus;
            finally
                FFocoPeloMouse := False;
            end;
        end;
        Escolher(SegmentoEm(X, Y));
    end;
    inherited;
end;

procedure TProSegmentado.MouseMove(Shift: TShiftState; X, Y: Integer);
var
    Novo: Integer;
begin
    Novo := SegmentoEm(X, Y);
    if Novo <> FSobre then
    begin
        FSobre := Novo;
        Invalidate;
    end;
    inherited;
end;

procedure TProSegmentado.KeyDown(var Key: Word; Shift: TShiftState);
begin
    if Enabled and (FItens.Count > 0) then
    begin
        //Tecla com o seletor em foco: mostra o contorno (uso por teclado)
        if not FMostrarFoco then
        begin
            FMostrarFoco := True;
            Invalidate;
        end;

        case Key of
            VK_LEFT, VK_UP:
            begin
                Key := 0;
                if FItemIndex > 0 then
                    Escolher(FItemIndex - 1)
                else if FItemIndex < 0 then
                    Escolher(0);
            end;

            VK_RIGHT, VK_DOWN:
            begin
                Key := 0;
                if FItemIndex < FItens.Count - 1 then
                    Escolher(FItemIndex + 1);
            end;

            VK_HOME:
            begin
                Key := 0;
                Escolher(0);
            end;

            VK_END:
            begin
                Key := 0;
                Escolher(FItens.Count - 1);
            end;
        end;
    end;
    inherited;
end;

procedure TProSegmentado.DoEnter;
begin
    FMostrarFoco := not FFocoPeloMouse;
    Invalidate;
    inherited;
end;

procedure TProSegmentado.DoExit;
begin
    FMostrarFoco := False;
    Invalidate;
    inherited;
end;

procedure TProSegmentado.CMMouseLeave(var Message: TMessage);
begin
    inherited;
    FSobre := -1;
    Invalidate;
end;

procedure TProSegmentado.CMEnabledChanged(var Message: TMessage);
begin
    inherited;
    Invalidate;
end;

procedure TProSegmentado.CMFontChanged(var Message: TMessage);
begin
    inherited;
    Invalidate;
end;

procedure TProSegmentado.CMHintShow(var Message: TCMHintShow);
var
    Indice: Integer;
begin
    //Uma dica por segmento (glossário 2.9); ao passar para outro segmento a dica é trocada
    Indice := SegmentoEm(Message.HintInfo^.CursorPos.X, Message.HintInfo^.CursorPos.Y);
    if (Indice >= 0) and (Indice < FDicas.Count) and (FDicas[Indice] <> '') then
    begin
        Message.HintInfo^.HintStr    := FDicas[Indice];
        Message.HintInfo^.CursorRect := RetanguloSegmento(Indice);
        Message.Result := 0;
    end
    else
        Message.Result := 1;
end;

procedure TProSegmentado.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
    //As setas trocam a opção (sem isso o formulário as usa para mover o foco)
    inherited;
    Message.Result := Message.Result or DLGC_WANTARROWS;
end;

procedure TProSegmentado.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
    //O Paint desenha tudo (inclusive o fundo do pai): evita piscar
    Message.Result := 1;
end;

end.
