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
var
    Form: TCustomForm;
    PPI: Integer;
begin
    //Medidas do tema estão a 96 dpi
    PPI  := Screen.PixelsPerInch;
    Form := GetParentForm(Self);
    if (Form <> nil) and (Form is TForm) and (TForm(Form).PixelsPerInch > 0) then
        PPI := TForm(Form).PixelsPerInch;
    Result := MulDiv(Valor, PPI, 96);
end;

function TProBotao.MargemFoco: Integer;
begin
    Result := Escalar(AfastamentoFoco + EspessuraFoco);
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

end.
