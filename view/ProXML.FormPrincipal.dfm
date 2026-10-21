object FormPrincipal: TFormPrincipal
  Left = 0
  Top = 0
  Caption = 'Pro XML'
  ClientHeight = 699
  ClientWidth = 1136
  Color = clBtnFace
  Constraints.MinHeight = 640
  Constraints.MinWidth = 1024
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 17
  object PnlContainer: TPanel
    Left = 0
    Top = 0
    Width = 1136
    Height = 699
    Align = alClient
    BevelOuter = bvNone
    Color = 15460841
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    object PnlCabecalho: TPanel
      Left = 0
      Top = 0
      Width = 1136
      Height = 48
      Align = alTop
      BevelOuter = bvNone
      ParentBackground = False
      ShowCaption = False
      TabOrder = 0
      object SkSvgLogo: TSkSvg
        AlignWithMargins = True
        Left = 16
        Top = 10
        Width = 137
        Height = 28
        Margins.Left = 16
        Margins.Top = 10
        Margins.Right = 0
        Margins.Bottom = 10
        Align = alLeft
        Svg.Source = 
          '<svg xmlns="http://www.w3.org/2000/svg" width="157" height="32" ' +
          'viewBox="0 0 157 32">'#13#10'  <title>ProXML (para fundo escuro)</titl' +
          'e>'#13#10'  <!-- Logo ProXML vetorial (redesenhado a partir de src/img' +
          '/Logo/Logo1.png). Sem fontes, filtros nem scripts. -->'#13#10'  <g><ci' +
          'rcle cx="13" cy="3" r="1.25" fill="#363B50"/><circle cx="18.5" c' +
          'y="3" r="1.25" fill="#363B50"/><circle cx="8.25" cy="7.75" r="1.' +
          '55" fill="#363B50"/><circle cx="13" cy="7.75" r="1.8" fill="#4A5' +
          'A7D"/><circle cx="18.5" cy="7.75" r="1.8" fill="#4A5A7D"/><circl' +
          'e cx="23.25" cy="7.75" r="1.55" fill="#363B50"/><circle cx="3.5"' +
          ' cy="12.75" r="1.25" fill="#363B50"/><circle cx="8.25" cy="12.75' +
          '" r="1.8" fill="#4A5A7D"/><circle cx="13" cy="12.75" r="2.1" fil' +
          'l="#46637F"/><circle cx="18.5" cy="12.75" r="2.1" fill="#46637F"' +
          '/><circle cx="23.25" cy="12.75" r="1.8" fill="#4A5A7D"/><circle ' +
          'cx="28" cy="12.75" r="1.25" fill="#363B50"/><circle cx="3.5" cy=' +
          '"18.25" r="1.25" fill="#363B50"/><circle cx="8.25" cy="18.25" r=' +
          '"1.8" fill="#4A5A7D"/><circle cx="13" cy="18.25" r="2.1" fill="#' +
          '46637F"/><circle cx="18.5" cy="18.25" r="2.1" fill="#46637F"/><c' +
          'ircle cx="23.25" cy="18.25" r="1.8" fill="#4A5A7D"/><circle cx="' +
          '28" cy="18.25" r="1.25" fill="#363B50"/><circle cx="8.25" cy="23' +
          '.25" r="1.55" fill="#363B50"/><circle cx="13" cy="23.25" r="1.8"' +
          ' fill="#4A5A7D"/><circle cx="18.5" cy="23.25" r="1.8" fill="#4A5' +
          'A7D"/><circle cx="23.25" cy="23.25" r="1.55" fill="#363B50"/><ci' +
          'rcle cx="13" cy="28" r="1.25" fill="#363B50"/><circle cx="18.5" ' +
          'cy="28" r="1.25" fill="#363B50"/></g>'#13#10'  <path d="M35 25V8.2A2.2' +
          ' 2.2 0 0 1 37.2 6H46A4 4 0 0 1 50 10V14A4 4 0 0 1 46 18H35M55 25' +
          'V11.8M55 15.6C55.4 13.3 57.4 12.3 60 12.3H62.4M91 5.6L106.2 25M1' +
          '06.4 5.6L91 25M112 25V11.2A5.75 5.75 0 0 1 123.5 11.2V25M123.5 1' +
          '1.2A5.75 5.75 0 0 1 135 11.2V25M140 5.6V22A3 3 0 0 0 143 25H153.' +
          '2" fill="none" stroke="#FFFFFF" stroke-width="2.5" stroke-lineca' +
          'p="round" stroke-linejoin="round"/>'#13#10'  <ellipse cx="72" cy="18.6' +
          '" rx="6.7" ry="6.4" fill="none" stroke="#FFFFFF" stroke-width="2' +
          '.5"/>'#13#10'</svg>'
      end
      object PnlSobre: TPanel
        AlignWithMargins = True
        Left = 1058
        Top = 10
        Width = 70
        Height = 28
        Margins.Left = 0
        Margins.Top = 10
        Margins.Right = 8
        Margins.Bottom = 10
        Align = alRight
        BevelOuter = bvNone
        ParentBackground = False
        ShowCaption = False
        TabOrder = 0
        object SkSvgSobre: TSkSvg
          AlignWithMargins = True
          Left = 8
          Top = 6
          Width = 16
          Height = 16
          Margins.Left = 8
          Margins.Top = 6
          Margins.Right = 0
          Margins.Bottom = 6
          Align = alLeft
        end
        object LabelSobre: TLabel
          AlignWithMargins = True
          Left = 32
          Top = 0
          Width = 30
          Height = 28
          Margins.Left = 8
          Margins.Top = 0
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alLeft
          Caption = 'Sobre'
          Layout = tlCenter
          ExplicitHeight = 13
        end
      end
    end
    object PnlBarraPasta: TPanel
      Left = 0
      Top = 48
      Width = 1136
      Height = 56
      Align = alTop
      BevelOuter = bvNone
      ParentBackground = False
      ShowCaption = False
      TabOrder = 1
      object LabelFiltroModelo: TLabel
        AlignWithMargins = True
        Left = 716
        Top = 8
        Width = 40
        Height = 40
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 4
        Margins.Bottom = 7
        Align = alRight
        Caption = 'Modelo'
        Layout = tlCenter
        ExplicitHeight = 13
      end
      object PnlBarraPastaBorda: TPanel
        Left = 0
        Top = 55
        Width = 1136
        Height = 1
        Align = alBottom
        BevelOuter = bvNone
        ParentBackground = False
        ShowCaption = False
        TabOrder = 2
      end
      object Panel7: TPanel
        AlignWithMargins = True
        Left = 996
        Top = 8
        Width = 128
        Height = 40
        Margins.Left = 0
        Margins.Top = 8
        Margins.Right = 12
        Margins.Bottom = 7
        Align = alRight
        BevelOuter = bvNone
        ParentBackground = False
        ShowCaption = False
        TabOrder = 4
      end
      object PnlModelo: TPanel
        AlignWithMargins = True
        Left = 760
        Top = 8
        Width = 236
        Height = 40
        Margins.Left = 0
        Margins.Top = 8
        Margins.Right = 0
        Margins.Bottom = 7
        Align = alRight
        BevelOuter = bvNone
        ParentBackground = False
        ShowCaption = False
        TabOrder = 3
      end
      object PnlSelecionar: TPanel
        AlignWithMargins = True
        Left = 568
        Top = 8
        Width = 140
        Height = 40
        Margins.Left = 0
        Margins.Top = 8
        Margins.Right = 0
        Margins.Bottom = 7
        Align = alRight
        BevelOuter = bvNone
        ParentBackground = False
        ShowCaption = False
        TabOrder = 1
      end
      object PnlCampoPasta: TPanel
        AlignWithMargins = True
        Left = 16
        Top = 12
        Width = 548
        Height = 32
        Margins.Left = 16
        Margins.Top = 12
        Margins.Right = 4
        Margins.Bottom = 11
        Align = alClient
        BevelOuter = bvNone
        Padding.Left = 1
        Padding.Top = 1
        Padding.Right = 1
        Padding.Bottom = 1
        ParentBackground = False
        ShowCaption = False
        TabOrder = 0
        object PnlCampoPastaFundo: TPanel
          Left = 1
          Top = 1
          Width = 546
          Height = 30
          Cursor = crHandPoint
          Align = alClient
          BevelOuter = bvNone
          ParentBackground = False
          ShowCaption = False
          TabOrder = 0
          object SkSvgPasta: TSkSvg
            AlignWithMargins = True
            Left = 8
            Top = 7
            Width = 16
            Height = 16
            Cursor = crHandPoint
            Margins.Left = 8
            Margins.Top = 7
            Margins.Right = 0
            Margins.Bottom = 7
            Align = alLeft
          end
          object EditCaminho: TEdit
            AlignWithMargins = True
            Left = 32
            Top = 6
            Width = 506
            Height = 18
            Cursor = crHandPoint
            Margins.Left = 8
            Margins.Top = 6
            Margins.Right = 8
            Margins.Bottom = 6
            Align = alClient
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            ReadOnly = True
            TabOrder = 0
            TextHint = 'Selecione ou arraste uma pasta com XMLs de Nota Fiscal'
          end
        end
      end
    end
    object PnlCorpo: TPanel
      Left = 0
      Top = 104
      Width = 1136
      Height = 595
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      object PnlLocal: TPanel
        Left = 0
        Top = 0
        Width = 1136
        Height = 595
        Align = alClient
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 0
        object PnlInfoLocal: TPanel
          Left = 0
          Top = 0
          Width = 1136
          Height = 595
          Align = alClient
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 2169367
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object PnlConteudo: TPanel
            Left = 200
            Top = 0
            Width = 936
            Height = 595
            Align = alClient
            BevelOuter = bvNone
            Padding.Left = 16
            Padding.Top = 16
            Padding.Right = 16
            Padding.Bottom = 16
            ParentBackground = False
            ShowCaption = False
            TabOrder = 1
            object PnlCards: TPanel
              AlignWithMargins = True
              Left = 16
              Top = 16
              Width = 904
              Height = 64
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 16
              Align = alTop
              BevelOuter = bvNone
              ParentBackground = False
              ShowCaption = False
              TabOrder = 0
              object PnlCardValorTotal: TPanel
                Left = 0
                Top = 0
                Width = 175
                Height = 64
                BevelOuter = bvNone
                Padding.Left = 1
                Padding.Top = 1
                Padding.Right = 1
                Padding.Bottom = 1
                ParentBackground = False
                ShowCaption = False
                TabOrder = 0
                object PnlCardValorTotalFundo: TPanel
                  Left = 1
                  Top = 1
                  Width = 173
                  Height = 62
                  Align = alClient
                  BevelOuter = bvNone
                  Padding.Left = 12
                  Padding.Top = 10
                  Padding.Right = 12
                  Padding.Bottom = 10
                  ParentBackground = False
                  ShowCaption = False
                  TabOrder = 0
                  object LabelValorTotal: TLabel
                    Left = 12
                    Top = 30
                    Width = 149
                    Height = 22
                    Align = alBottom
                    AutoSize = False
                    Caption = 'R$ 0,00'
                    Layout = tlCenter
                  end
                  object PnlCardValorTotalRotulo: TPanel
                    Left = 12
                    Top = 10
                    Width = 149
                    Height = 16
                    Align = alTop
                    BevelOuter = bvNone
                    ParentBackground = False
                    ShowCaption = False
                    TabOrder = 0
                    object SkSvgCardValorTotal: TSkSvg
                      Left = 0
                      Top = 0
                      Width = 16
                      Height = 16
                      Align = alLeft
                    end
                    object LabelTituloValorTotal: TLabel
                      AlignWithMargins = True
                      Left = 24
                      Top = 0
                      Width = 125
                      Height = 16
                      Margins.Left = 8
                      Margins.Top = 0
                      Margins.Right = 0
                      Margins.Bottom = 0
                      Align = alClient
                      AutoSize = False
                      Caption = 'Valor Total'
                      EllipsisPosition = epEndEllipsis
                      Layout = tlCenter
                    end
                  end
                end
              end
              object PnlCardBaseICMS: TPanel
                Left = 183
                Top = 0
                Width = 175
                Height = 64
                BevelOuter = bvNone
                Padding.Left = 1
                Padding.Top = 1
                Padding.Right = 1
                Padding.Bottom = 1
                ParentBackground = False
                ShowCaption = False
                TabOrder = 1
                object PnlCardBaseICMSFundo: TPanel
                  Left = 1
                  Top = 1
                  Width = 173
                  Height = 62
                  Align = alClient
                  BevelOuter = bvNone
                  Padding.Left = 12
                  Padding.Top = 10
                  Padding.Right = 12
                  Padding.Bottom = 10
                  ParentBackground = False
                  ShowCaption = False
                  TabOrder = 0
                  object LabelbaseICMS: TLabel
                    Left = 12
                    Top = 30
                    Width = 149
                    Height = 22
                    Align = alBottom
                    AutoSize = False
                    Caption = 'R$ 0,00'
                    Layout = tlCenter
                  end
                  object PnlCardBaseICMSRotulo: TPanel
                    Left = 12
                    Top = 10
                    Width = 149
                    Height = 16
                    Align = alTop
                    BevelOuter = bvNone
                    ParentBackground = False
                    ShowCaption = False
                    TabOrder = 0
                    object SkSvgCardBaseICMS: TSkSvg
                      Left = 0
                      Top = 0
                      Width = 16
                      Height = 16
                      Align = alLeft
                    end
                    object LabelTituloBaseICMS: TLabel
                      AlignWithMargins = True
                      Left = 24
                      Top = 0
                      Width = 125
                      Height = 16
                      Margins.Left = 8
                      Margins.Top = 0
                      Margins.Right = 0
                      Margins.Bottom = 0
                      Align = alClient
                      AutoSize = False
                      Caption = 'Base ICMS'
                      EllipsisPosition = epEndEllipsis
                      Layout = tlCenter
                    end
                  end
                end
              end
              object PnlCardICMS: TPanel
                Left = 366
                Top = 0
                Width = 175
                Height = 64
                BevelOuter = bvNone
                Padding.Left = 1
                Padding.Top = 1
                Padding.Right = 1
                Padding.Bottom = 1
                ParentBackground = False
                ShowCaption = False
                TabOrder = 2
                object PnlCardICMSFundo: TPanel
                  Left = 1
                  Top = 1
                  Width = 173
                  Height = 62
                  Align = alClient
                  BevelOuter = bvNone
                  Padding.Left = 12
                  Padding.Top = 10
                  Padding.Right = 12
                  Padding.Bottom = 10
                  ParentBackground = False
                  ShowCaption = False
                  TabOrder = 0
                  object LabelValorICMS: TLabel
                    Left = 12
                    Top = 30
                    Width = 149
                    Height = 22
                    Align = alBottom
                    AutoSize = False
                    Caption = 'R$ 0,00'
                    Layout = tlCenter
                  end
                  object PnlCardICMSRotulo: TPanel
                    Left = 12
                    Top = 10
                    Width = 149
                    Height = 16
                    Align = alTop
                    BevelOuter = bvNone
                    ParentBackground = False
                    ShowCaption = False
                    TabOrder = 0
                    object SkSvgCardICMS: TSkSvg
                      Left = 0
                      Top = 0
                      Width = 16
                      Height = 16
                      Align = alLeft
                    end
                    object LabelTituloICMS: TLabel
                      AlignWithMargins = True
                      Left = 24
                      Top = 0
                      Width = 125
                      Height = 16
                      Margins.Left = 8
                      Margins.Top = 0
                      Margins.Right = 0
                      Margins.Bottom = 0
                      Align = alClient
                      AutoSize = False
                      Caption = 'ICMS'
                      EllipsisPosition = epEndEllipsis
                      Layout = tlCenter
                    end
                  end
                end
              end
              object PnlCardIBS: TPanel
                Left = 549
                Top = 0
                Width = 175
                Height = 64
                BevelOuter = bvNone
                Padding.Left = 1
                Padding.Top = 1
                Padding.Right = 1
                Padding.Bottom = 1
                ParentBackground = False
                ShowCaption = False
                TabOrder = 3
                object PnlCardIBSFundo: TPanel
                  Left = 1
                  Top = 1
                  Width = 173
                  Height = 62
                  Align = alClient
                  BevelOuter = bvNone
                  Padding.Left = 12
                  Padding.Top = 10
                  Padding.Right = 12
                  Padding.Bottom = 10
                  ParentBackground = False
                  ShowCaption = False
                  TabOrder = 0
                  object LabelValorIBS: TLabel
                    Left = 12
                    Top = 30
                    Width = 149
                    Height = 22
                    Align = alBottom
                    AutoSize = False
                    Caption = 'R$ 0,00'
                    Layout = tlCenter
                  end
                  object PnlCardIBSRotulo: TPanel
                    Left = 12
                    Top = 10
                    Width = 149
                    Height = 16
                    Align = alTop
                    BevelOuter = bvNone
                    ParentBackground = False
                    ShowCaption = False
                    TabOrder = 0
                    object SkSvgCardIBS: TSkSvg
                      Left = 0
                      Top = 0
                      Width = 16
                      Height = 16
                      Align = alLeft
                    end
                    object LabelTituloIBS: TLabel
                      AlignWithMargins = True
                      Left = 24
                      Top = 0
                      Width = 125
                      Height = 16
                      Margins.Left = 8
                      Margins.Top = 0
                      Margins.Right = 0
                      Margins.Bottom = 0
                      Align = alClient
                      AutoSize = False
                      Caption = 'IBS'
                      EllipsisPosition = epEndEllipsis
                      Layout = tlCenter
                    end
                  end
                end
              end
              object PnlCardCBS: TPanel
                Left = 732
                Top = 0
                Width = 175
                Height = 64
                BevelOuter = bvNone
                Padding.Left = 1
                Padding.Top = 1
                Padding.Right = 1
                Padding.Bottom = 1
                ParentBackground = False
                ShowCaption = False
                TabOrder = 4
                object PnlCardCBSFundo: TPanel
                  Left = 1
                  Top = 1
                  Width = 173
                  Height = 62
                  Align = alClient
                  BevelOuter = bvNone
                  Padding.Left = 12
                  Padding.Top = 10
                  Padding.Right = 12
                  Padding.Bottom = 10
                  ParentBackground = False
                  ShowCaption = False
                  TabOrder = 0
                  object LabelValorCBS: TLabel
                    Left = 12
                    Top = 30
                    Width = 149
                    Height = 22
                    Align = alBottom
                    AutoSize = False
                    Caption = 'R$ 0,00'
                    Layout = tlCenter
                  end
                  object PnlCardCBSRotulo: TPanel
                    Left = 12
                    Top = 10
                    Width = 149
                    Height = 16
                    Align = alTop
                    BevelOuter = bvNone
                    ParentBackground = False
                    ShowCaption = False
                    TabOrder = 0
                    object SkSvgCardCBS: TSkSvg
                      Left = 0
                      Top = 0
                      Width = 16
                      Height = 16
                      Align = alLeft
                    end
                    object LabelTituloCBS: TLabel
                      AlignWithMargins = True
                      Left = 24
                      Top = 0
                      Width = 125
                      Height = 16
                      Margins.Left = 8
                      Margins.Top = 0
                      Margins.Right = 0
                      Margins.Bottom = 0
                      Align = alClient
                      AutoSize = False
                      Caption = 'CBS'
                      EllipsisPosition = epEndEllipsis
                      Layout = tlCenter
                    end
                  end
                end
              end
            end
            object PageControl1: TPageControl
              Left = 16
              Top = 96
              Width = 904
              Height = 483
              ActivePage = TabSheet1
              Align = alClient
              TabOrder = 1
              object TabSheet1: TTabSheet
                Caption = 'TabSheet1'
                TabVisible = False
                object PnlResumo: TPanel
                  Left = 0
                  Top = 0
                  Width = 896
                  Height = 473
                  Align = alClient
                  BevelOuter = bvNone
                  ParentBackground = False
                  ShowCaption = False
                  TabOrder = 0
                  object PnlAvisoPasta: TPanel
                    AlignWithMargins = True
                    Left = 0
                    Top = 0
                    Width = 896
                    Height = 76
                    Margins.Left = 0
                    Margins.Top = 0
                    Margins.Right = 0
                    Margins.Bottom = 8
                    Align = alTop
                    BevelOuter = bvNone
                    ParentBackground = False
                    ShowCaption = False
                    TabOrder = 0
                    Visible = False
                    object SkSvgAvisoPasta: TSkSvg
                      AlignWithMargins = True
                      Left = 16
                      Top = 12
                      Width = 20
                      Height = 20
                      Margins.Left = 12
                      Margins.Top = 12
                      Margins.Right = 0
                      Margins.Bottom = 44
                      Align = alLeft
                      ExplicitHeight = 52
                    end
                    object LabelAvisoPasta: TLabel
                      AlignWithMargins = True
                      Left = 48
                      Top = 12
                      Width = 832
                      Height = 52
                      Margins.Left = 12
                      Margins.Top = 12
                      Margins.Right = 16
                      Margins.Bottom = 12
                      Align = alClient
                      AutoSize = False
                      ShowAccelChar = False
                      ExplicitWidth = 552
                    end
                    object PnlAvisoPastaBarra: TPanel
                      Left = 0
                      Top = 0
                      Width = 4
                      Height = 76
                      Align = alLeft
                      BevelOuter = bvNone
                      ParentBackground = False
                      ShowCaption = False
                      TabOrder = 0
                    end
                  end
                  object PnlFaixaResumo: TPanel
                    AlignWithMargins = True
                    Left = 0
                    Top = 84
                    Width = 896
                    Height = 68
                    Margins.Left = 0
                    Margins.Top = 0
                    Margins.Right = 0
                    Margins.Bottom = 16
                    Align = alTop
                    BevelOuter = bvNone
                    ParentBackground = False
                    ShowCaption = False
                    TabOrder = 1
                    Visible = False
                    object PnlFaixaResumoBarra: TPanel
                      Left = 0
                      Top = 0
                      Width = 4
                      Height = 68
                      Align = alLeft
                      BevelOuter = bvNone
                      ParentBackground = False
                      ShowCaption = False
                      TabOrder = 0
                    end
                    object SkSvgFaixaResumo: TSkSvg
                      AlignWithMargins = True
                      Left = 20
                      Top = 12
                      Width = 20
                      Height = 20
                      Margins.Left = 16
                      Margins.Top = 12
                      Margins.Right = 0
                      Margins.Bottom = 36
                      Align = alLeft
                    end
                    object PbxFaixaResumo: TPaintBox
                      AlignWithMargins = True
                      Left = 52
                      Top = 12
                      Width = 828
                      Height = 44
                      Margins.Left = 12
                      Margins.Top = 12
                      Margins.Right = 16
                      Margins.Bottom = 12
                      Align = alClient
                    end
                  end
                  object PnlResumoVazio: TPanel
                    Left = 0
                    Top = 84
                    Width = 896
                    Height = 389
                    Align = alClient
                    BevelOuter = bvNone
                    Padding.Left = 1
                    Padding.Top = 1
                    Padding.Right = 1
                    Padding.Bottom = 1
                    ParentBackground = False
                    ShowCaption = False
                    TabOrder = 2
                    object PnlResumoVazioFundo: TPanel
                      Left = 1
                      Top = 1
                      Width = 894
                      Height = 387
                      Align = alClient
                      BevelOuter = bvNone
                      ParentBackground = False
                      ShowCaption = False
                      TabOrder = 0
                      object SkSvgResumoVazio: TSkSvg
                        Left = 423
                        Top = 96
                        Width = 48
                        Height = 48
                      end
                      object LabelResumoVazioTitulo: TLabel
                        Left = 16
                        Top = 152
                        Width = 862
                        Height = 21
                        Alignment = taCenter
                        AutoSize = False
                        ShowAccelChar = False
                        WordWrap = True
                      end
                      object LabelResumoVazioTexto: TLabel
                        Left = 237
                        Top = 181
                        Width = 420
                        Height = 34
                        Alignment = taCenter
                        AutoSize = False
                        ShowAccelChar = False
                        WordWrap = True
                      end
                      object LabelResumoVazioAtalhos: TLabel
                        Left = 16
                        Top = 279
                        Width = 862
                        Height = 15
                        Alignment = taCenter
                        AutoSize = False
                        ShowAccelChar = False
                        WordWrap = True
                      end
                      object PnlResumoVazioBotao: TPanel
                        Left = 371
                        Top = 227
                        Width = 152
                        Height = 40
                        BevelOuter = bvNone
                        ParentBackground = False
                        ShowCaption = False
                        TabOrder = 0
                      end
                    end
                  end
                  object PnlProgresso: TPanel
                    Left = 0
                    Top = 84
                    Width = 896
                    Height = 389
                    Align = alClient
                    BevelOuter = bvNone
                    Padding.Left = 1
                    Padding.Top = 1
                    Padding.Right = 1
                    Padding.Bottom = 1
                    ParentBackground = False
                    ShowCaption = False
                    TabOrder = 3
                    Visible = False
                    object PnlProgressoFundo: TPanel
                      Left = 1
                      Top = 1
                      Width = 894
                      Height = 387
                      Align = alClient
                      BevelOuter = bvNone
                      ParentBackground = False
                      ShowCaption = False
                      TabOrder = 0
                      object LabelProgressoTitulo: TLabel
                        Left = 48
                        Top = 120
                        Width = 798
                        Height = 21
                        AutoSize = False
                        ShowAccelChar = False
                      end
                      object LabelProgressoContagem: TLabel
                        Left = 48
                        Top = 173
                        Width = 120
                        Height = 32
                        AutoSize = False
                        ShowAccelChar = False
                        Layout = tlCenter
                      end
                      object LabelProgressoArquivo: TLabel
                        Left = 184
                        Top = 173
                        Width = 662
                        Height = 32
                        Alignment = taRightJustify
                        AutoSize = False
                        ShowAccelChar = False
                        Layout = tlCenter
                      end
                      object LabelProgressoDica: TLabel
                        Left = 160
                        Top = 225
                        Width = 686
                        Height = 32
                        AutoSize = False
                        EllipsisPosition = epEndEllipsis
                        ShowAccelChar = False
                        Layout = tlCenter
                      end
                      object PnlProgressoTrilho: TPanel
                        Left = 48
                        Top = 153
                        Width = 798
                        Height = 8
                        BevelOuter = bvNone
                        ParentBackground = False
                        ShowCaption = False
                        TabOrder = 0
                        object PnlProgressoBarra: TPanel
                          Left = 0
                          Top = 0
                          Width = 0
                          Height = 8
                          Align = alLeft
                          BevelOuter = bvNone
                          ParentBackground = False
                          ShowCaption = False
                          TabOrder = 0
                        end
                      end
                      object PnlCancelar: TPanel
                        Left = 44
                        Top = 221
                        Width = 112
                        Height = 40
                        BevelOuter = bvNone
                        ParentBackground = False
                        ShowCaption = False
                        TabOrder = 1
                      end
                    end
                  end
                  object PnlConcluido: TPanel
                    Left = 0
                    Top = 84
                    Width = 896
                    Height = 389
                    Align = alClient
                    BevelOuter = bvNone
                    ParentBackground = False
                    ShowCaption = False
                    TabOrder = 4
                    Visible = False
                    object PnlContadores: TPanel
                      AlignWithMargins = True
                      Left = 0
                      Top = 0
                      Width = 896
                      Height = 58
                      Margins.Left = 0
                      Margins.Top = 0
                      Margins.Right = 0
                      Margins.Bottom = 16
                      Align = alTop
                      BevelOuter = bvNone
                      ParentBackground = False
                      ShowCaption = False
                      TabOrder = 0
                      object PnlContadorAutorizadas: TPanel
                        Left = 0
                        Top = 0
                        Width = 218
                        Height = 58
                        BevelOuter = bvNone
                        Padding.Left = 1
                        Padding.Right = 1
                        Padding.Bottom = 1
                        ParentBackground = False
                        ShowCaption = False
                        TabOrder = 0
                        object PnlContadorAutorizadasTopo: TPanel
                          Left = 1
                          Top = 0
                          Width = 216
                          Height = 4
                          Align = alTop
                          BevelOuter = bvNone
                          ParentBackground = False
                          ShowCaption = False
                          TabOrder = 0
                        end
                        object PnlContadorAutorizadasFundo: TPanel
                          Left = 1
                          Top = 4
                          Width = 216
                          Height = 53
                          Align = alClient
                          BevelOuter = bvNone
                          ParentBackground = False
                          ShowCaption = False
                          TabOrder = 1
                          object SkSvgContadorAutorizadas: TSkSvg
                            Left = 12
                            Top = 14
                            Width = 24
                            Height = 24
                          end
                          object LabelNumeroAutorizadas: TLabel
                            Left = 48
                            Top = 5
                            Width = 156
                            Height = 28
                            AutoSize = False
                            ShowAccelChar = False
                          end
                          object LabelRotuloAutorizadas: TLabel
                            Left = 48
                            Top = 33
                            Width = 156
                            Height = 15
                            AutoSize = False
                            ShowAccelChar = False
                          end
                        end
                      end
                      object PnlContadorIgnoradas: TPanel
                        Left = 226
                        Top = 0
                        Width = 218
                        Height = 58
                        BevelOuter = bvNone
                        Padding.Left = 1
                        Padding.Right = 1
                        Padding.Bottom = 1
                        ParentBackground = False
                        ShowCaption = False
                        TabOrder = 1
                        object PnlContadorIgnoradasTopo: TPanel
                          Left = 1
                          Top = 0
                          Width = 216
                          Height = 4
                          Align = alTop
                          BevelOuter = bvNone
                          ParentBackground = False
                          ShowCaption = False
                          TabOrder = 0
                        end
                        object PnlContadorIgnoradasFundo: TPanel
                          Left = 1
                          Top = 4
                          Width = 216
                          Height = 53
                          Align = alClient
                          BevelOuter = bvNone
                          ParentBackground = False
                          ShowCaption = False
                          TabOrder = 1
                          object SkSvgContadorIgnoradas: TSkSvg
                            Left = 12
                            Top = 14
                            Width = 24
                            Height = 24
                          end
                          object LabelNumeroIgnoradas: TLabel
                            Left = 48
                            Top = 5
                            Width = 156
                            Height = 28
                            AutoSize = False
                            ShowAccelChar = False
                          end
                          object LabelRotuloIgnoradas: TLabel
                            Left = 48
                            Top = 33
                            Width = 156
                            Height = 15
                            AutoSize = False
                            ShowAccelChar = False
                          end
                        end
                      end
                      object PnlContadorComErro: TPanel
                        Left = 452
                        Top = 0
                        Width = 218
                        Height = 58
                        BevelOuter = bvNone
                        Padding.Left = 1
                        Padding.Right = 1
                        Padding.Bottom = 1
                        ParentBackground = False
                        ShowCaption = False
                        TabOrder = 2
                        object PnlContadorComErroTopo: TPanel
                          Left = 1
                          Top = 0
                          Width = 216
                          Height = 4
                          Align = alTop
                          BevelOuter = bvNone
                          ParentBackground = False
                          ShowCaption = False
                          TabOrder = 0
                        end
                        object PnlContadorComErroFundo: TPanel
                          Left = 1
                          Top = 4
                          Width = 216
                          Height = 53
                          Align = alClient
                          BevelOuter = bvNone
                          ParentBackground = False
                          ShowCaption = False
                          TabOrder = 1
                          object SkSvgContadorComErro: TSkSvg
                            Left = 12
                            Top = 14
                            Width = 24
                            Height = 24
                          end
                          object LabelNumeroComErro: TLabel
                            Left = 48
                            Top = 5
                            Width = 156
                            Height = 28
                            AutoSize = False
                            ShowAccelChar = False
                          end
                          object LabelRotuloComErro: TLabel
                            Left = 48
                            Top = 33
                            Width = 156
                            Height = 15
                            AutoSize = False
                            ShowAccelChar = False
                          end
                        end
                      end
                      object PnlContadorTempo: TPanel
                        Left = 678
                        Top = 0
                        Width = 218
                        Height = 58
                        BevelOuter = bvNone
                        Padding.Left = 1
                        Padding.Right = 1
                        Padding.Bottom = 1
                        ParentBackground = False
                        ShowCaption = False
                        TabOrder = 3
                        object PnlContadorTempoTopo: TPanel
                          Left = 1
                          Top = 0
                          Width = 216
                          Height = 4
                          Align = alTop
                          BevelOuter = bvNone
                          ParentBackground = False
                          ShowCaption = False
                          TabOrder = 0
                        end
                        object PnlContadorTempoFundo: TPanel
                          Left = 1
                          Top = 4
                          Width = 216
                          Height = 53
                          Align = alClient
                          BevelOuter = bvNone
                          ParentBackground = False
                          ShowCaption = False
                          TabOrder = 1
                          object SkSvgContadorTempo: TSkSvg
                            Left = 12
                            Top = 14
                            Width = 24
                            Height = 24
                          end
                          object LabelNumeroTempo: TLabel
                            Left = 48
                            Top = 5
                            Width = 156
                            Height = 28
                            AutoSize = False
                            ShowAccelChar = False
                          end
                          object LabelRotuloTempo: TLabel
                            Left = 48
                            Top = 33
                            Width = 156
                            Height = 15
                            AutoSize = False
                            ShowAccelChar = False
                          end
                        end
                      end
                    end
                    object PnlAvisoResumo: TPanel
                      AlignWithMargins = True
                      Left = 0
                      Top = 74
                      Width = 896
                      Height = 36
                      Margins.Left = 0
                      Margins.Top = 0
                      Margins.Right = 0
                      Margins.Bottom = 16
                      Align = alTop
                      BevelOuter = bvNone
                      ParentBackground = False
                      ShowCaption = False
                      TabOrder = 1
                      Visible = False
                      object PnlAvisoResumoBarra: TPanel
                        Left = 0
                        Top = 0
                        Width = 4
                        Height = 36
                        Align = alLeft
                        BevelOuter = bvNone
                        ParentBackground = False
                        ShowCaption = False
                        TabOrder = 0
                      end
                      object SkSvgAvisoResumo: TSkSvg
                        AlignWithMargins = True
                        Left = 20
                        Top = 8
                        Width = 20
                        Height = 20
                        Margins.Left = 16
                        Margins.Top = 8
                        Margins.Right = 0
                        Margins.Bottom = 8
                        Align = alLeft
                      end
                      object PbxAvisoResumo: TPaintBox
                        AlignWithMargins = True
                        Left = 52
                        Top = 8
                        Width = 828
                        Height = 20
                        Margins.Left = 12
                        Margins.Top = 8
                        Margins.Right = 16
                        Margins.Bottom = 8
                        Align = alClient
                      end
                    end
                    object PnlLog: TPanel
                      Left = 0
                      Top = 126
                      Width = 896
                      Height = 263
                      Align = alClient
                      BevelOuter = bvNone
                      Padding.Left = 1
                      Padding.Top = 1
                      Padding.Right = 1
                      Padding.Bottom = 1
                      ParentBackground = False
                      ShowCaption = False
                      TabOrder = 2
                      object PnlLogFundo: TPanel
                        Left = 1
                        Top = 1
                        Width = 894
                        Height = 261
                        Align = alClient
                        BevelOuter = bvNone
                        Padding.Bottom = 4
                        ParentBackground = False
                        ShowCaption = False
                        TabOrder = 0
                        object PnlLogTitulo: TPanel
                          Left = 0
                          Top = 0
                          Width = 894
                          Height = 32
                          Align = alTop
                          BevelOuter = bvNone
                          ParentBackground = False
                          ShowCaption = False
                          TabOrder = 0
                          object LabelLogTitulo: TLabel
                            AlignWithMargins = True
                            Left = 12
                            Top = 0
                            Width = 4
                            Height = 32
                            Margins.Left = 12
                            Margins.Top = 0
                            Margins.Right = 0
                            Margins.Bottom = 0
                            Align = alLeft
                            ShowAccelChar = False
                            Layout = tlCenter
                          end
                          object LabelLogData: TLabel
                            AlignWithMargins = True
                            Left = 878
                            Top = 0
                            Width = 4
                            Height = 32
                            Margins.Left = 0
                            Margins.Top = 0
                            Margins.Right = 12
                            Margins.Bottom = 0
                            Align = alRight
                            ShowAccelChar = False
                            Layout = tlCenter
                          end
                        end
                        object PnlLogDivisoria: TPanel
                          Left = 0
                          Top = 32
                          Width = 894
                          Height = 1
                          Align = alTop
                          BevelOuter = bvNone
                          ParentBackground = False
                          ShowCaption = False
                          TabOrder = 1
                        end
                        object ListBoxLog: TListBox
                          AlignWithMargins = True
                          Left = 0
                          Top = 37
                          Width = 894
                          Height = 220
                          Margins.Left = 0
                          Margins.Top = 4
                          Margins.Right = 0
                          Margins.Bottom = 0
                          Style = lbOwnerDrawFixed
                          Align = alClient
                          BorderStyle = bsNone
                          ItemHeight = 24
                          TabOrder = 2
                        end
                      end
                    end
                  end
                end
              end
              object TabSheet2: TTabSheet
                Caption = 'TabSheet2'
                ImageIndex = 1
                TabVisible = False
                ExplicitLeft = 0
                ExplicitTop = 0
                ExplicitWidth = 0
                ExplicitHeight = 0
                object PnlNotas: TPanel
                  Left = 0
                  Top = 0
                  Width = 896
                  Height = 473
                  Align = alClient
                  BevelOuter = bvNone
                  ParentBackground = False
                  ShowCaption = False
                  TabOrder = 0
                  object PnlNotasTitulo: TPanel
                    AlignWithMargins = True
                    Left = 0
                    Top = 0
                    Width = 896
                    Height = 40
                    Margins.Left = 0
                    Margins.Top = 0
                    Margins.Right = 0
                    Margins.Bottom = 12
                    Align = alTop
                    BevelOuter = bvNone
                    ParentBackground = False
                    ShowCaption = False
                    TabOrder = 0
                    object LabelNotasTitulo: TLabel
                      Left = 0
                      Top = 0
                      Width = 39
                      Height = 40
                      Align = alLeft
                      Caption = 'Notas'
                      ShowAccelChar = False
                      Layout = tlCenter
                    end
                    object LabelNotasContador: TLabel
                      AlignWithMargins = True
                      Left = 47
                      Top = 0
                      Width = 4
                      Height = 40
                      Margins.Left = 8
                      Margins.Top = 0
                      Margins.Right = 0
                      Margins.Bottom = 0
                      Align = alLeft
                      ShowAccelChar = False
                      Layout = tlCenter
                    end
                    object PnlCopiarChave: TPanel
                      Left = 200
                      Top = 0
                      Width = 144
                      Height = 40
                      Align = alRight
                      BevelOuter = bvNone
                      ParentBackground = False
                      ShowCaption = False
                      TabOrder = 0
                    end
                    object PnlGerarDanfe: TPanel
                      Left = 344
                      Top = 0
                      Width = 144
                      Height = 40
                      Align = alRight
                      BevelOuter = bvNone
                      ParentBackground = False
                      ShowCaption = False
                      TabOrder = 1
                    end
                    object PnlExportarCSV: TPanel
                      Left = 488
                      Top = 0
                      Width = 156
                      Height = 40
                      Align = alRight
                      BevelOuter = bvNone
                      ParentBackground = False
                      ShowCaption = False
                      TabOrder = 2
                    end
                    object PnlCampoBusca: TPanel
                      AlignWithMargins = True
                      Left = 648
                      Top = 4
                      Width = 248
                      Height = 32
                      Margins.Left = 4
                      Margins.Top = 4
                      Margins.Right = 0
                      Margins.Bottom = 4
                      Align = alRight
                      BevelOuter = bvNone
                      Padding.Left = 1
                      Padding.Top = 1
                      Padding.Right = 1
                      Padding.Bottom = 1
                      ParentBackground = False
                      ShowCaption = False
                      TabOrder = 3
                      object PnlCampoBuscaFundo: TPanel
                        Left = 1
                        Top = 1
                        Width = 246
                        Height = 30
                        Align = alClient
                        BevelOuter = bvNone
                        ParentBackground = False
                        ShowCaption = False
                        TabOrder = 0
                        object SkSvgBusca: TSkSvg
                          AlignWithMargins = True
                          Left = 8
                          Top = 7
                          Width = 16
                          Height = 16
                          Margins.Left = 8
                          Margins.Top = 7
                          Margins.Right = 0
                          Margins.Bottom = 7
                          Align = alLeft
                        end
                        object EditBusca: TEdit
                          AlignWithMargins = True
                          Left = 32
                          Top = 6
                          Width = 206
                          Height = 18
                          Margins.Left = 8
                          Margins.Top = 6
                          Margins.Right = 8
                          Margins.Bottom = 6
                          Align = alClient
                          BevelInner = bvNone
                          BevelOuter = bvNone
                          BorderStyle = bsNone
                          TabOrder = 0
                          TextHint = 'Buscar por n'#250'mero ou chave'
                        end
                      end
                    end
                  end
                  object Panel5: TPanel
                    Left = 0
                    Top = 52
                    Width = 896
                    Height = 421
                    Align = alClient
                    BevelOuter = bvNone
                    Padding.Left = 1
                    Padding.Top = 1
                    Padding.Right = 1
                    Padding.Bottom = 1
                    ParentBackground = False
                    ShowCaption = False
                    TabOrder = 1
                    object DBGrid1: TDBGrid
                      Left = 1
                      Top = 1
                      Width = 894
                      Height = 419
                      Align = alClient
                      BorderStyle = bsNone
                      DataSource = DataSource1
                      DefaultDrawing = False
                      DrawingStyle = gdsClassic
                      Font.Charset = DEFAULT_CHARSET
                      Font.Height = -13
                      Font.Name = 'Segoe UI'
                      Font.Style = []
                      Options = [dgTitles, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick]
                      ParentFont = False
                      PopupMenu = PopupMenu
                      ReadOnly = True
                      TabOrder = 0
                      TitleFont.Charset = DEFAULT_CHARSET
                      TitleFont.Height = -13
                      TitleFont.Name = 'Segoe UI Semibold'
                      TitleFont.Style = []
                      Columns = <
                        item
                          Alignment = taRightJustify
                          Expanded = False
                          FieldName = 'numero'
                          Title.Alignment = taRightJustify
                          Title.Caption = 'N'#186
                          Width = 72
                          Visible = True
                        end
                        item
                          Alignment = taCenter
                          Expanded = False
                          FieldName = 'modelo'
                          Title.Alignment = taCenter
                          Title.Caption = 'Modelo'
                          Width = 64
                          Visible = True
                        end
                        item
                          Expanded = False
                          FieldName = 'data'
                          Title.Caption = 'Data'
                          Width = 88
                          Visible = True
                        end
                        item
                          Expanded = False
                          FieldName = 'chave'
                          Title.Caption = 'Chave'
                          Width = 330
                          Visible = True
                        end
                        item
                          Alignment = taRightJustify
                          Expanded = False
                          FieldName = 'vtotal'
                          Title.Alignment = taRightJustify
                          Title.Caption = 'Valor'
                          Width = 120
                          Visible = True
                        end
                        item
                          Alignment = taRightJustify
                          Expanded = False
                          FieldName = 'bcicms'
                          Title.Alignment = taRightJustify
                          Title.Caption = 'Base ICMS'
                          Width = 120
                          Visible = True
                        end
                        item
                          Alignment = taRightJustify
                          Expanded = False
                          FieldName = 'vlicms'
                          Title.Alignment = taRightJustify
                          Title.Caption = 'ICMS'
                          Width = 104
                          Visible = True
                        end
                        item
                          Alignment = taRightJustify
                          Expanded = False
                          FieldName = 'vibs'
                          Title.Alignment = taRightJustify
                          Title.Caption = 'IBS'
                          Width = 88
                          Visible = True
                        end
                        item
                          Alignment = taRightJustify
                          Expanded = False
                          FieldName = 'vcbs'
                          Title.Alignment = taRightJustify
                          Title.Caption = 'CBS'
                          Width = 96
                          Visible = True
                        end>
                    end
                    object PnlNotasVazio: TPanel
                      Left = 1
                      Top = 33
                      Width = 894
                      Height = 387
                      BevelOuter = bvNone
                      ParentBackground = False
                      ShowCaption = False
                      TabOrder = 1
                      Visible = False
                      object SkSvgNotasVazio: TSkSvg
                        Left = 423
                        Top = 104
                        Width = 48
                        Height = 48
                      end
                      object LabelNotasVazioTitulo: TLabel
                        Left = 16
                        Top = 160
                        Width = 862
                        Height = 21
                        Alignment = taCenter
                        AutoSize = False
                        ShowAccelChar = False
                        WordWrap = True
                      end
                      object LabelNotasVazioTexto: TLabel
                        Left = 237
                        Top = 189
                        Width = 420
                        Height = 17
                        Alignment = taCenter
                        AutoSize = False
                        ShowAccelChar = False
                        WordWrap = True
                      end
                      object PnlNotasVazioBotao: TPanel
                        Left = 371
                        Top = 210
                        Width = 152
                        Height = 40
                        BevelOuter = bvNone
                        ParentBackground = False
                        ShowCaption = False
                        TabOrder = 0
                      end
                    end
                    object PnlChaveCopiada: TPanel
                      Left = 383
                      Top = 371
                      Width = 128
                      Height = 32
                      BevelOuter = bvNone
                      ParentBackground = False
                      ShowCaption = False
                      TabOrder = 2
                      Visible = False
                      object SkSvgChaveCopiada: TSkSvg
                        Left = 16
                        Top = 8
                        Width = 16
                        Height = 16
                      end
                      object LabelChaveCopiada: TLabel
                        Left = 40
                        Top = 8
                        Width = 72
                        Height = 15
                        ShowAccelChar = False
                      end
                    end
                  end
                end
              end
              object Loading: TTabSheet
                Caption = 'Loading'
                ImageIndex = 2
                TabVisible = False
                ExplicitLeft = 0
                ExplicitTop = 0
                ExplicitWidth = 0
                ExplicitHeight = 0
                object PnlCarregando: TPanel
                  Left = 0
                  Top = 0
                  Width = 904
                  Height = 483
                  Align = alClient
                  BevelOuter = bvNone
                  Padding.Left = 1
                  Padding.Top = 1
                  Padding.Right = 1
                  Padding.Bottom = 1
                  ParentBackground = False
                  ShowCaption = False
                  TabOrder = 0
                  object PnlCarregandoFundo: TPanel
                    Left = 1
                    Top = 1
                    Width = 902
                    Height = 481
                    Align = alClient
                    BevelOuter = bvNone
                    ParentBackground = False
                    ShowCaption = False
                    TabOrder = 0
                    object LabelCarregandoTitulo: TLabel
                      Left = 0
                      Top = 256
                      Width = 902
                      Height = 21
                      Alignment = taCenter
                      AutoSize = False
                      ShowAccelChar = False
                    end
                    object LabelCarregandoLegenda: TLabel
                      Left = 0
                      Top = 289
                      Width = 902
                      Height = 17
                      Alignment = taCenter
                      AutoSize = False
                      ShowAccelChar = False
                    end
                    object PnlAnimacao: TPanel
                      Left = 371
                      Top = 110
                      Width = 160
                      Height = 134
                      BevelOuter = bvNone
                      ParentBackground = False
                      ShowCaption = False
                      TabOrder = 0
                    end
                  end
                end
              end
              object Enviar: TTabSheet
                Caption = 'Enviar'
                ImageIndex = 3
                TabVisible = False
                ExplicitLeft = 0
                ExplicitTop = 0
                ExplicitWidth = 0
                ExplicitHeight = 0
                object Panel10: TPanel
                  Left = 0
                  Top = 0
                  Width = 616
                  Height = 419
                  Align = alClient
                  BevelOuter = bvNone
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clGray
                  Font.Height = -13
                  Font.Name = 'Segoe UI'
                  Font.Style = []
                  ParentFont = False
                  ShowCaption = False
                  TabOrder = 0
                  object Label11: TLabel
                    AlignWithMargins = True
                    Left = 10
                    Top = 3
                    Width = 57
                    Height = 25
                    Margins.Left = 10
                    Align = alTop
                    Caption = 'Enviar '
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clGray
                    Font.Height = -19
                    Font.Name = 'Segoe UI'
                    Font.Style = []
                    ParentFont = False
                  end
                  object Label12: TLabel
                    AlignWithMargins = True
                    Left = 10
                    Top = 34
                    Width = 149
                    Height = 17
                    Margins.Left = 10
                    Align = alTop
                    Caption = 'Enviar arquivos por email'
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clGray
                    Font.Height = -13
                    Font.Name = 'Segoe UI'
                    Font.Style = []
                    ParentFont = False
                  end
                  object Shape15: TShape
                    Left = 16
                    Top = 97
                    Width = 409
                    Height = 40
                    Pen.Color = clGray
                  end
                  object Shape17: TShape
                    Left = 16
                    Top = 184
                    Width = 532
                    Height = 101
                    Pen.Color = clGray
                  end
                  object Label15: TLabel
                    Left = 16
                    Top = 74
                    Width = 31
                    Height = 17
                    Caption = 'Email'
                  end
                  object Label17: TLabel
                    Left = 16
                    Top = 161
                    Width = 65
                    Height = 17
                    Caption = 'Mensagem'
                  end
                  object EditEmailEnviar: TEdit
                    Left = 24
                    Top = 105
                    Width = 385
                    Height = 25
                    BorderStyle = bsNone
                    TabOrder = 0
                  end
                  object MemoMensagem: TMemo
                    Left = 23
                    Top = 196
                    Width = 517
                    Height = 77
                    BorderStyle = bsNone
                    TabOrder = 1
                  end
                  object Panel11: TPanel
                    Left = 434
                    Top = 93
                    Width = 118
                    Height = 48
                    BevelOuter = bvNone
                    ShowCaption = False
                    TabOrder = 2
                  end
                end
              end
              object Config: TTabSheet
                Caption = 'Config'
                ImageIndex = 4
                TabVisible = False
                ExplicitLeft = 0
                ExplicitTop = 0
                ExplicitWidth = 0
                ExplicitHeight = 0
                object PanelCorpoConfig: TPanel
                  Left = 0
                  Top = 0
                  Width = 616
                  Height = 419
                  Align = alClient
                  BevelOuter = bvNone
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clGray
                  Font.Height = -13
                  Font.Name = 'Segoe UI'
                  Font.Style = []
                  ParentFont = False
                  ShowCaption = False
                  TabOrder = 0
                  object Label1: TLabel
                    AlignWithMargins = True
                    Left = 10
                    Top = 3
                    Width = 122
                    Height = 25
                    Margins.Left = 10
                    Align = alTop
                    Caption = 'Configura'#231#245'es'
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clGray
                    Font.Height = -19
                    Font.Name = 'Segoe UI'
                    Font.Style = []
                    ParentFont = False
                  end
                  object Label2: TLabel
                    AlignWithMargins = True
                    Left = 10
                    Top = 34
                    Width = 164
                    Height = 17
                    Margins.Left = 10
                    Align = alTop
                    Caption = 'Dados para envio por email'
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clGray
                    Font.Height = -13
                    Font.Name = 'Segoe UI'
                    Font.Style = []
                    ParentFont = False
                  end
                  object Shape2: TShape
                    Left = 24
                    Top = 89
                    Width = 297
                    Height = 40
                    Pen.Color = clGray
                  end
                  object Shape3: TShape
                    Left = 344
                    Top = 89
                    Width = 145
                    Height = 40
                    Pen.Color = clGray
                  end
                  object Shape10: TShape
                    Left = 24
                    Top = 177
                    Width = 297
                    Height = 40
                    Pen.Color = clGray
                  end
                  object Shape11: TShape
                    Left = 344
                    Top = 177
                    Width = 217
                    Height = 40
                    Pen.Color = clGray
                  end
                  object Shape12: TShape
                    Left = 24
                    Top = 260
                    Width = 537
                    Height = 101
                    Pen.Color = clGray
                  end
                  object Label4: TLabel
                    Left = 24
                    Top = 66
                    Width = 33
                    Height = 17
                    Caption = 'SMTP'
                  end
                  object Label7: TLabel
                    Left = 344
                    Top = 66
                    Width = 31
                    Height = 17
                    Caption = 'Porta'
                  end
                  object Label8: TLabel
                    Left = 24
                    Top = 154
                    Width = 31
                    Height = 17
                    Caption = 'Email'
                  end
                  object Label9: TLabel
                    Left = 344
                    Top = 154
                    Width = 35
                    Height = 17
                    Caption = 'Senha'
                  end
                  object Label10: TLabel
                    Left = 24
                    Top = 237
                    Width = 65
                    Height = 17
                    Caption = 'Mensagem'
                  end
                  object SkSvg5: TSkSvg
                    Left = 530
                    Top = 187
                    Width = 25
                    Height = 20
                    Cursor = crHandPoint
                    OnClick = SkSvg5Click
                    Svg.OverrideColor = claSlategray
                    Svg.Source = 
                      '<?xml version="1.0" ?><svg fill="none" height="28" viewBox="0 0 ' +
                      '28 28" width="28" xmlns="http://www.w3.org/2000/svg"><path clip-' +
                      'rule="evenodd" d="M17.7469 15.4149C17.9855 14.8742 18.1188 14.27' +
                      '24 18.1188 14.0016C18.1188 11.6544 16.2952 9.7513 14.046 9.7513C' +
                      '11.7969 9.7513 9.97332 11.6544 9.97332 14.0016C9.97332 16.3487 1' +
                      '2.0097 17.8886 14.046 17.8886C15.3486 17.8886 16.508 17.2515 17.' +
                      '2517 16.2595C17.4466 16.0001 17.6137 15.7168 17.7469 15.4149ZM14' +
                      '.046 15.7635C14.5551 15.7635 15.0205 15.5684 15.3784 15.2457C15.' +
                      '81 14.8566 16 14.2807 16 14.0016C16 12.828 15.1716 11.8764 14.04' +
                      '6 11.8764C12.9205 11.8764 12 12.8264 12 14C12 14.8104 12.9205 15' +
                      '.7635 14.046 15.7635Z" fill="black" fill-rule="evenodd"/><path c' +
                      'lip-rule="evenodd" d="M1.09212 14.2724C1.07621 14.2527 1.10803 1' +
                      '4.2931 1.09212 14.2724C0.96764 14.1021 0.970773 13.8996 1.09268 ' +
                      '13.7273C1.10161 13.7147 1.11071 13.7016 1.11993 13.6882C4.781 8.' +
                      '34319 9.32105 5.5 14.0142 5.5C18.7025 5.5 23.2385 8.33554 26.895' +
                      '6 13.6698C26.965 13.771 27 13.875 27 13.9995C27 14.1301 26.9593 ' +
                      '14.2399 26.8863 14.3461C23.2302 19.6702 18.6982 22.5 14.0142 22.' +
                      '5C9.30912 22.5 4.75717 19.6433 1.09212 14.2724ZM3.93909 13.3525C' +
                      '3.6381 13.7267 3.6381 14.2722 3.93908 14.6465C7.07417 18.5443 10' +
                      '.6042 20.3749 14.0142 20.3749C17.4243 20.3749 20.9543 18.5443 24' +
                      '.0894 14.6465C24.3904 14.2722 24.3904 13.7267 24.0894 13.3525C20' +
                      '.9543 9.45475 17.4243 7.62513 14.0142 7.62513C10.6042 7.62513 7.' +
                      '07417 9.45475 3.93909 13.3525Z" fill="black" fill-rule="evenodd"' +
                      '/></svg>'
                  end
                  object CheckBoxSSL: TCheckBox
                    Left = 512
                    Top = 89
                    Width = 97
                    Height = 17
                    Caption = 'SSL'
                    Color = clGray
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clGray
                    Font.Height = -16
                    Font.Name = 'Segoe UI'
                    Font.Style = []
                    ParentColor = False
                    ParentFont = False
                    TabOrder = 5
                  end
                  object CheckBoxTSL: TCheckBox
                    Left = 512
                    Top = 112
                    Width = 97
                    Height = 17
                    Caption = 'TSL'
                    Color = clGray
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clGray
                    Font.Height = -16
                    Font.Name = 'Segoe UI'
                    Font.Style = []
                    ParentColor = False
                    ParentFont = False
                    TabOrder = 6
                  end
                  object EditSMTP: TEdit
                    Left = 32
                    Top = 97
                    Width = 281
                    Height = 25
                    BorderStyle = bsNone
                    TabOrder = 0
                    Text = 'smtp.gmail.com'
                  end
                  object EditPorta: TEdit
                    Left = 352
                    Top = 97
                    Width = 129
                    Height = 25
                    BorderStyle = bsNone
                    NumbersOnly = True
                    TabOrder = 1
                  end
                  object EditEmail: TEdit
                    Left = 32
                    Top = 185
                    Width = 281
                    Height = 25
                    BorderStyle = bsNone
                    TabOrder = 2
                  end
                  object EditPass: TEdit
                    Left = 352
                    Top = 185
                    Width = 169
                    Height = 25
                    BorderStyle = bsNone
                    PasswordChar = '*'
                    TabOrder = 3
                  end
                  object MemoMsg: TMemo
                    Left = 31
                    Top = 272
                    Width = 521
                    Height = 77
                    BorderStyle = bsNone
                    TabOrder = 4
                  end
                  object Panel9: TPanel
                    Left = 423
                    Top = 372
                    Width = 142
                    Height = 44
                    BevelOuter = bvNone
                    ShowCaption = False
                    TabOrder = 7
                  end
                end
              end
              object Relatorios: TTabSheet
                Caption = 'Relatorios'
                ImageIndex = 5
                TabVisible = False
                ExplicitLeft = 0
                ExplicitTop = 0
                ExplicitWidth = 0
                ExplicitHeight = 0
                object PnlRelatorios: TPanel
                  Left = 0
                  Top = 0
                  Width = 904
                  Height = 483
                  Align = alClient
                  BevelOuter = bvNone
                  ParentBackground = False
                  ShowCaption = False
                  TabOrder = 0
                  object LabelRelatoriosRodape: TLabel
                    AlignWithMargins = True
                    Left = 0
                    Top = 234
                    Width = 4
                    Height = 17
                    Margins.Left = 0
                    Margins.Top = 16
                    Margins.Right = 0
                    Margins.Bottom = 0
                    Align = alTop
                    ShowAccelChar = False
                    WordWrap = True
                  end
                  object PnlRelatoriosTitulo: TPanel
                    AlignWithMargins = True
                    Left = 0
                    Top = 0
                    Width = 904
                    Height = 32
                    Margins.Left = 0
                    Margins.Top = 0
                    Margins.Right = 0
                    Margins.Bottom = 16
                    Align = alTop
                    BevelOuter = bvNone
                    ParentBackground = False
                    ShowCaption = False
                    TabOrder = 0
                    object LabelRelatoriosTitulo: TLabel
                      Left = 0
                      Top = 0
                      Width = 59
                      Height = 17
                      Align = alLeft
                      Caption = 'Relat'#243'rios'
                      ShowAccelChar = False
                      Layout = tlCenter
                    end
                    object PnlRelatoriosFiltro: TPanel
                      AlignWithMargins = True
                      Left = 734
                      Top = 5
                      Width = 170
                      Height = 22
                      Margins.Left = 0
                      Margins.Top = 5
                      Margins.Right = 0
                      Margins.Bottom = 5
                      Align = alRight
                      BevelOuter = bvNone
                      Padding.Left = 1
                      Padding.Top = 1
                      Padding.Right = 1
                      Padding.Bottom = 1
                      ParentBackground = False
                      ShowCaption = False
                      TabOrder = 0
                      object PnlRelatoriosFiltroFundo: TPanel
                        Left = 1
                        Top = 1
                        Width = 168
                        Height = 20
                        Align = alClient
                        BevelOuter = bvNone
                        Padding.Left = 8
                        Padding.Top = 2
                        Padding.Right = 8
                        Padding.Bottom = 2
                        ParentBackground = False
                        ShowCaption = False
                        TabOrder = 0
                        object LabelRelatoriosFiltro: TLabel
                          AlignWithMargins = True
                          Left = 28
                          Top = 2
                          Width = 4
                          Height = 17
                          Margins.Left = 6
                          Margins.Top = 0
                          Margins.Right = 0
                          Margins.Bottom = 0
                          Align = alClient
                          ShowAccelChar = False
                          Layout = tlCenter
                        end
                        object SkSvgRelatoriosFiltro: TSkSvg
                          AlignWithMargins = True
                          Left = 8
                          Top = 3
                          Width = 14
                          Height = 14
                          Margins.Left = 0
                          Margins.Top = 1
                          Margins.Right = 0
                          Margins.Bottom = 1
                          Align = alLeft
                        end
                      end
                    end
                  end
                  object PnlOpcoes: TPanel
                    Left = 0
                    Top = 48
                    Width = 904
                    Height = 170
                    Align = alTop
                    BevelOuter = bvNone
                    ParentBackground = False
                    ShowCaption = False
                    TabOrder = 1
                    object PnlOpcaoNotas: TPanel
                      Left = 0
                      Top = 0
                      Width = 444
                      Height = 170
                      BevelOuter = bvNone
                      Padding.Left = 1
                      Padding.Top = 1
                      Padding.Right = 1
                      Padding.Bottom = 1
                      ParentBackground = False
                      ShowCaption = False
                      TabOrder = 0
                      object PnlOpcaoNotasFundo: TPanel
                        Left = 1
                        Top = 1
                        Width = 442
                        Height = 168
                        Align = alClient
                        BevelOuter = bvNone
                        Padding.Left = 12
                        Padding.Top = 16
                        Padding.Right = 16
                        Padding.Bottom = 12
                        ParentBackground = False
                        ShowCaption = False
                        TabOrder = 0
                        object LabelOpcaoNotasDescricao: TLabel
                          AlignWithMargins = True
                          Left = 16
                          Top = 53
                          Width = 410
                          Height = 40
                          Margins.Left = 4
                          Margins.Top = 0
                          Margins.Right = 0
                          Margins.Bottom = 4
                          Align = alTop
                          AutoSize = False
                          ShowAccelChar = False
                          WordWrap = True
                        end
                        object PnlOpcaoNotasTitulo: TPanel
                          AlignWithMargins = True
                          Left = 16
                          Top = 16
                          Width = 410
                          Height = 29
                          Margins.Left = 4
                          Margins.Top = 0
                          Margins.Right = 0
                          Margins.Bottom = 8
                          Align = alTop
                          BevelOuter = bvNone
                          ParentBackground = False
                          ShowCaption = False
                          TabOrder = 0
                          object LabelOpcaoNotasTitulo: TLabel
                            AlignWithMargins = True
                            Left = 28
                            Top = 0
                            Width = 4
                            Height = 17
                            Margins.Left = 8
                            Margins.Top = 0
                            Margins.Right = 0
                            Margins.Bottom = 0
                            Align = alClient
                            ShowAccelChar = False
                            Layout = tlCenter
                          end
                          object SkSvgOpcaoNotas: TSkSvg
                            AlignWithMargins = True
                            Left = 0
                            Top = 4
                            Width = 20
                            Height = 20
                            Margins.Left = 0
                            Margins.Top = 4
                            Margins.Right = 0
                            Margins.Bottom = 5
                            Align = alLeft
                          end
                        end
                        object PnlOpcaoNotasRodape: TPanel
                          Left = 12
                          Top = 114
                          Width = 414
                          Height = 40
                          Align = alTop
                          BevelOuter = bvNone
                          ParentBackground = False
                          ShowCaption = False
                          TabOrder = 1
                          object LabelDicaNotas: TLabel
                            AlignWithMargins = True
                            Left = 191
                            Top = 0
                            Width = 4
                            Height = 17
                            Margins.Left = 4
                            Margins.Top = 0
                            Margins.Right = 0
                            Margins.Bottom = 0
                            Align = alClient
                            ShowAccelChar = False
                            Layout = tlCenter
                            WordWrap = True
                          end
                          object SkSvgDicaNotas: TSkSvg
                            AlignWithMargins = True
                            Left = 167
                            Top = 13
                            Width = 14
                            Height = 14
                            Margins.Left = 8
                            Margins.Top = 13
                            Margins.Right = 0
                            Margins.Bottom = 13
                            Align = alLeft
                          end
                          object PnlGerarNotas: TPanel
                            AlignWithMargins = True
                            Left = 0
                            Top = 0
                            Width = 159
                            Height = 40
                            Margins.Left = 0
                            Margins.Top = 0
                            Margins.Right = 0
                            Margins.Bottom = 0
                            Align = alLeft
                            BevelOuter = bvNone
                            ParentBackground = False
                            ShowCaption = False
                            TabOrder = 0
                          end
                        end
                      end
                    end
                    object PnlOpcaoIBSCBS: TPanel
                      Left = 452
                      Top = 0
                      Width = 444
                      Height = 170
                      BevelOuter = bvNone
                      Padding.Left = 1
                      Padding.Top = 1
                      Padding.Right = 1
                      Padding.Bottom = 1
                      ParentBackground = False
                      ShowCaption = False
                      TabOrder = 1
                      object PnlOpcaoIBSCBSFundo: TPanel
                        Left = 1
                        Top = 1
                        Width = 442
                        Height = 168
                        Align = alClient
                        BevelOuter = bvNone
                        Padding.Left = 12
                        Padding.Top = 16
                        Padding.Right = 16
                        Padding.Bottom = 12
                        ParentBackground = False
                        ShowCaption = False
                        TabOrder = 0
                        object LabelOpcaoIBSCBSDescricao: TLabel
                          AlignWithMargins = True
                          Left = 16
                          Top = 53
                          Width = 410
                          Height = 40
                          Margins.Left = 4
                          Margins.Top = 0
                          Margins.Right = 0
                          Margins.Bottom = 4
                          Align = alTop
                          AutoSize = False
                          ShowAccelChar = False
                          WordWrap = True
                        end
                        object PnlOpcaoIBSCBSTitulo: TPanel
                          AlignWithMargins = True
                          Left = 16
                          Top = 16
                          Width = 410
                          Height = 29
                          Margins.Left = 4
                          Margins.Top = 0
                          Margins.Right = 0
                          Margins.Bottom = 8
                          Align = alTop
                          BevelOuter = bvNone
                          ParentBackground = False
                          ShowCaption = False
                          TabOrder = 0
                          object LabelOpcaoIBSCBSTitulo: TLabel
                            AlignWithMargins = True
                            Left = 28
                            Top = 0
                            Width = 4
                            Height = 17
                            Margins.Left = 8
                            Margins.Top = 0
                            Margins.Right = 0
                            Margins.Bottom = 0
                            Align = alClient
                            ShowAccelChar = False
                            Layout = tlCenter
                          end
                          object SkSvgOpcaoIBSCBS: TSkSvg
                            AlignWithMargins = True
                            Left = 0
                            Top = 4
                            Width = 20
                            Height = 20
                            Margins.Left = 0
                            Margins.Top = 4
                            Margins.Right = 0
                            Margins.Bottom = 5
                            Align = alLeft
                          end
                        end
                        object PnlOpcaoIBSCBSRodape: TPanel
                          Left = 12
                          Top = 114
                          Width = 414
                          Height = 40
                          Align = alTop
                          BevelOuter = bvNone
                          ParentBackground = False
                          ShowCaption = False
                          TabOrder = 1
                          object LabelDicaIBSCBS: TLabel
                            AlignWithMargins = True
                            Left = 191
                            Top = 0
                            Width = 4
                            Height = 17
                            Margins.Left = 4
                            Margins.Top = 0
                            Margins.Right = 0
                            Margins.Bottom = 0
                            Align = alClient
                            ShowAccelChar = False
                            Layout = tlCenter
                            WordWrap = True
                          end
                          object SkSvgDicaIBSCBS: TSkSvg
                            AlignWithMargins = True
                            Left = 167
                            Top = 13
                            Width = 14
                            Height = 14
                            Margins.Left = 8
                            Margins.Top = 13
                            Margins.Right = 0
                            Margins.Bottom = 13
                            Align = alLeft
                          end
                          object PnlGerarIBSCBS: TPanel
                            AlignWithMargins = True
                            Left = 0
                            Top = 0
                            Width = 159
                            Height = 40
                            Margins.Left = 0
                            Margins.Top = 0
                            Margins.Right = 0
                            Margins.Bottom = 0
                            Align = alLeft
                            BevelOuter = bvNone
                            ParentBackground = False
                            ShowCaption = False
                            TabOrder = 0
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
          object PanelMenus: TPanel
            Left = 0
            Top = 0
            Width = 200
            Height = 595
            Align = alLeft
            BevelOuter = bvNone
            ParentBackground = False
            ShowCaption = False
            TabOrder = 0
            object PnlMenuBorda: TPanel
              Left = 199
              Top = 0
              Width = 1
              Height = 595
              Align = alRight
              BevelOuter = bvNone
              ParentBackground = False
              ShowCaption = False
              TabOrder = 1
            end
            object PnlMenuItens: TPanel
              Left = 0
              Top = 0
              Width = 199
              Height = 595
              Align = alClient
              BevelOuter = bvNone
              ParentBackground = False
              ShowCaption = False
              TabOrder = 0
            end
          end
        end
      end
    end
  end
  object FileOpenDialog1: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = [fdoPickFolders]
    Title = 'Selecione a pasta com os XMLs'
    Left = 950
    Top = 424
  end
  object DataSource1: TDataSource
    DataSet = FDMemTable1
    Left = 952
    Top = 377
  end
  object FDMemTable1: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'numero'
        DataType = ftInteger
      end
      item
        Name = 'chave'
        DataType = ftWideString
        Size = 50
      end
      item
        Name = 'data'
        DataType = ftWideString
        Size = 20
      end
      item
        Name = 'vlicms'
        DataType = ftFloat
      end
      item
        Name = 'bcicms'
        DataType = ftFloat
      end
      item
        Name = 'vtotal'
        DataType = ftFloat
      end
      item
        Name = 'xml'
        DataType = ftString
        Size = 200
      end
      item
        Name = 'modelo'
        DataType = ftInteger
      end
      item
        Name = 'tem_ibscbs'
        DataType = ftBoolean
      end
      item
        Name = 'vbcibscbs'
        DataType = ftFloat
      end
      item
        Name = 'vibsuf'
        DataType = ftFloat
      end
      item
        Name = 'vibsmun'
        DataType = ftFloat
      end
      item
        Name = 'vibs'
        DataType = ftFloat
      end
      item
        Name = 'vcbs'
        DataType = ftFloat
      end
      item
        Name = 'data_ordem'
        DataType = ftInteger
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode, evUnidirectional]
    FetchOptions.Mode = fmAll
    FormatOptions.AssignedValues = [fvMaxBcdPrecision, fvMaxBcdScale]
    FormatOptions.MaxBcdPrecision = 2147483647
    FormatOptions.MaxBcdScale = 2147483647
    ResourceOptions.AssignedValues = [rvPersistent, rvSilentMode]
    ResourceOptions.Persistent = True
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable, uvAutoCommitUpdates]
    UpdateOptions.LockWait = True
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 1040
    Top = 377
    object FDMemTable1numero: TIntegerField
      FieldName = 'numero'
    end
    object FDMemTable1chave: TWideStringField
      FieldName = 'chave'
      Size = 50
    end
    object FDMemTable1data: TWideStringField
      FieldName = 'data'
    end
    object FDMemTable1vlicms: TFloatField
      FieldName = 'vlicms'
    end
    object FDMemTable1bcicms: TFloatField
      FieldName = 'bcicms'
    end
    object FDMemTable1vtotal: TFloatField
      FieldName = 'vtotal'
    end
    object FDMemTable1xml: TStringField
      FieldName = 'xml'
      Size = 200
    end
    object FDMemTable1modelo: TIntegerField
      FieldName = 'modelo'
    end
    object FDMemTable1tem_ibscbs: TBooleanField
      FieldName = 'tem_ibscbs'
    end
    object FDMemTable1vbcibscbs: TFloatField
      FieldName = 'vbcibscbs'
      DisplayFormat = '#,##0.00'
    end
    object FDMemTable1vibsuf: TFloatField
      FieldName = 'vibsuf'
      DisplayFormat = '#,##0.00'
    end
    object FDMemTable1vibsmun: TFloatField
      FieldName = 'vibsmun'
      DisplayFormat = '#,##0.00'
    end
    object FDMemTable1vibs: TFloatField
      FieldName = 'vibs'
      DisplayFormat = '#,##0.00'
    end
    object FDMemTable1vcbs: TFloatField
      FieldName = 'vcbs'
      DisplayFormat = '#,##0.00'
    end
    object FDMemTable1data_ordem: TIntegerField
      FieldName = 'data_ordem'
    end
  end
  object PopupMenu: TPopupMenu
    Left = 992
    Top = 373
    object mnuCopiarChave: TMenuItem
      Caption = 'Copiar chave'
      OnClick = mnuCopiarChaveClick
    end
    object GerarDANFe1: TMenuItem
      Caption = 'Gerar DANFE'
      OnClick = GerarDANFe1Click
    end
  end
  object TimerChaveCopiada: TTimer
    Enabled = False
    Interval = 2000
    Left = 1040
    Top = 516
  end
  object ACBrNFe: TACBrNFe
    MAIL = ACBrMail1
    Configuracoes.Geral.SSLLib = libNone
    Configuracoes.Geral.SSLCryptLib = cryNone
    Configuracoes.Geral.SSLHttpLib = httpNone
    Configuracoes.Geral.SSLXmlSignLib = xsNone
    Configuracoes.Geral.FormatoAlerta = 'TAG:%TAGNIVEL% ID:%ID%/%TAG%(%DESCRICAO%) - %MSG%.'
    Configuracoes.Geral.VersaoQRCode = veqr000
    Configuracoes.Geral.ForcarGerarTagRejeicao938 = fgtSempre
    Configuracoes.Arquivos.OrdenacaoPath = <>
    Configuracoes.WebServices.UF = 'SP'
    Configuracoes.WebServices.AguardarConsultaRet = 0
    Configuracoes.WebServices.QuebradeLinha = '|'
    Configuracoes.RespTec.IdCSRT = 0
    DANFE = ACBrNFeDANFEFR
    Left = 993
    Top = 468
  end
  object ACBrNFeDANFeFPDF1: TACBrNFeDANFeFPDF
    Sistema = 'Desenvolvido por Caique Garcia'
    Site = 'github.com/Caique-Garcia'
    MargemInferior = 8.000000000000000000
    MargemSuperior = 8.000000000000000000
    MargemEsquerda = 6.000000000000000000
    MargemDireita = 5.099999999999999000
    ExpandeLogoMarcaConfig.Altura = 0
    ExpandeLogoMarcaConfig.Esquerda = 0
    ExpandeLogoMarcaConfig.Topo = 0
    ExpandeLogoMarcaConfig.Largura = 0
    ExpandeLogoMarcaConfig.Dimensionar = False
    ExpandeLogoMarcaConfig.Esticar = True
    CasasDecimais.Formato = tdetInteger
    CasasDecimais.qCom = 2
    CasasDecimais.vUnCom = 2
    CasasDecimais.MaskqCom = ',0.00'
    CasasDecimais.MaskvUnCom = ',0.00'
    CasasDecimais.Aliquota = 2
    CasasDecimais.MaskAliquota = ',0.00'
    TipoDANFE = tiNFCe
    Left = 1039
    Top = 422
  end
  object ACBrMail1: TACBrMail
    Host = '127.0.0.1'
    Port = '25'
    SetSSL = False
    SetTLS = False
    Attempts = 3
    DefaultCharset = UTF_8
    IDECharset = CP1252
    Left = 951
    Top = 470
  end
  object ACBrNFeDANFEFR: TACBrNFeDANFEFR
    Sistema = 'Desenvolvido por Caique Garcia'
    Site = 'github.com/Caique-Garcia'
    MargemInferior = 0.800000000000000000
    MargemSuperior = 0.800000000000000000
    MargemEsquerda = 0.600000000000000000
    MargemDireita = 0.510000000000000000
    ExpandeLogoMarcaConfig.Altura = 0
    ExpandeLogoMarcaConfig.Esquerda = 0
    ExpandeLogoMarcaConfig.Topo = 0
    ExpandeLogoMarcaConfig.Largura = 0
    ExpandeLogoMarcaConfig.Dimensionar = False
    ExpandeLogoMarcaConfig.Esticar = True
    CasasDecimais.Formato = tdetInteger
    CasasDecimais.qCom = 3
    CasasDecimais.vUnCom = 3
    CasasDecimais.MaskqCom = ',0.000'
    CasasDecimais.MaskvUnCom = ',0.000'
    CasasDecimais.Aliquota = 2
    CasasDecimais.MaskAliquota = ',0.00'
    ACBrNFe = ACBrNFe
    TipoDANFE = tiNFCe
    EspessuraBorda = 1
    BorderIcon = [biSystemMenu, biMinimize, biMaximize]
    ThreadSafe = False
    Left = 1000
    Top = 419
  end
end
