object FormPrincipal: TFormPrincipal
  Left = 0
  Top = 0
  Caption = 'ProXML'
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
        object PnlSobreAtivo: TPanel
          Left = 0
          Top = 26
          Width = 70
          Height = 2
          BevelOuter = bvNone
          ParentBackground = False
          ShowCaption = False
          TabOrder = 0
          Visible = False
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
                    object SkSvgAvisoPasta: TSkSvg
                      AlignWithMargins = True
                      Left = 20
                      Top = 12
                      Width = 20
                      Height = 20
                      Margins.Left = 16
                      Margins.Top = 12
                      Margins.Right = 0
                      Margins.Bottom = 44
                      Align = alLeft
                    end
                    object PbxAvisoPasta: TPaintBox
                      AlignWithMargins = True
                      Left = 52
                      Top = 12
                      Width = 828
                      Height = 52
                      Margins.Left = 12
                      Margins.Top = 12
                      Margins.Right = 16
                      Margins.Bottom = 12
                      Align = alClient
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
                  object PnlEnviarFundo: TPanel
                    Left = 1
                    Top = 1
                    Width = 902
                    Height = 481
                    Align = alClient
                    BevelOuter = bvNone
                    ParentBackground = False
                    ShowCaption = False
                    TabOrder = 0
                    object Label11: TLabel
                      Left = 24
                      Top = 16
                      Width = 117
                      Height = 32
                      AutoSize = False
                      Caption = 'Enviar por e-mail'
                      ShowAccelChar = False
                      Layout = tlCenter
                    end
                    object Label15: TLabel
                      Left = 24
                      Top = 132
                      Width = 26
                      Height = 15
                      Caption = 'Para'
                      ShowAccelChar = False
                    end
                    object SkSvgErroPara: TSkSvg
                      Left = 24
                      Top = 188
                      Width = 14
                      Height = 14
                      Visible = False
                    end
                    object LabelErroPara: TLabel
                      Left = 42
                      Top = 187
                      Width = 300
                      Height = 15
                      AutoSize = False
                      ShowAccelChar = False
                      Visible = False
                      WordWrap = True
                    end
                    object Label17: TLabel
                      Left = 24
                      Top = 199
                      Width = 57
                      Height = 15
                      Caption = 'Mensagem'
                      ShowAccelChar = False
                    end
                    object LabelRemetente: TLabel
                      Left = 24
                      Top = 306
                      Width = 200
                      Height = 15
                      ShowAccelChar = False
                    end
                    object LabelEnviando: TLabel
                      Left = 152
                      Top = 342
                      Width = 400
                      Height = 32
                      AutoSize = False
                      ShowAccelChar = False
                      Visible = False
                      Layout = tlCenter
                    end
                    object PnlFaixaEnviar: TPanel
                      Left = 24
                      Top = 60
                      Width = 854
                      Height = 44
                      BevelOuter = bvNone
                      ParentBackground = False
                      ShowCaption = False
                      TabOrder = 0
                      Visible = False
                      object PnlFaixaEnviarBarra: TPanel
                        Left = 0
                        Top = 0
                        Width = 4
                        Height = 44
                        Align = alLeft
                        BevelOuter = bvNone
                        ParentBackground = False
                        ShowCaption = False
                        TabOrder = 0
                      end
                      object SkSvgFaixaEnviar: TSkSvg
                        AlignWithMargins = True
                        Left = 20
                        Top = 12
                        Width = 20
                        Height = 20
                        Margins.Left = 16
                        Margins.Top = 12
                        Margins.Right = 0
                        Margins.Bottom = 12
                        Align = alLeft
                      end
                      object PbxFaixaEnviar: TPaintBox
                        AlignWithMargins = True
                        Left = 52
                        Top = 12
                        Width = 786
                        Height = 20
                        Margins.Left = 12
                        Margins.Top = 12
                        Margins.Right = 16
                        Margins.Bottom = 12
                        Align = alClient
                      end
                    end
                    object PnlAnexo: TPanel
                      Left = 24
                      Top = 60
                      Width = 854
                      Height = 60
                      BevelOuter = bvNone
                      Padding.Left = 1
                      Padding.Top = 1
                      Padding.Right = 1
                      Padding.Bottom = 1
                      ParentBackground = False
                      ShowCaption = False
                      TabOrder = 1
                      object PnlAnexoFundo: TPanel
                        Left = 1
                        Top = 1
                        Width = 852
                        Height = 58
                        Align = alClient
                        BevelOuter = bvNone
                        ParentBackground = False
                        ShowCaption = False
                        TabOrder = 0
                        object SkSvgAnexo: TSkSvg
                          Left = 16
                          Top = 19
                          Width = 20
                          Height = 20
                        end
                        object LabelAnexoTitulo: TLabel
                          Left = 48
                          Top = 12
                          Width = 300
                          Height = 17
                          AutoSize = False
                          ShowAccelChar = False
                        end
                        object LabelAnexoDetalhe: TLabel
                          Left = 48
                          Top = 31
                          Width = 500
                          Height = 15
                          AutoSize = False
                          ShowAccelChar = False
                          WordWrap = True
                        end
                      end
                    end
                    object PnlCampoPara: TPanel
                      Left = 24
                      Top = 151
                      Width = 854
                      Height = 32
                      BevelOuter = bvNone
                      Padding.Left = 1
                      Padding.Top = 1
                      Padding.Right = 1
                      Padding.Bottom = 1
                      ParentBackground = False
                      ShowCaption = False
                      TabOrder = 2
                      object PnlCampoParaFundo: TPanel
                        Left = 1
                        Top = 1
                        Width = 852
                        Height = 30
                        Align = alClient
                        BevelOuter = bvNone
                        ParentBackground = False
                        ShowCaption = False
                        TabOrder = 0
                        object SkSvgPara: TSkSvg
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
                        object EditEmailEnviar: TEdit
                          AlignWithMargins = True
                          Left = 32
                          Top = 6
                          Width = 812
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
                          TextHint = 'nome@empresa.com.br'
                        end
                      end
                    end
                    object PnlCampoMensagem: TPanel
                      Left = 24
                      Top = 218
                      Width = 854
                      Height = 72
                      BevelOuter = bvNone
                      Padding.Left = 1
                      Padding.Top = 1
                      Padding.Right = 1
                      Padding.Bottom = 1
                      ParentBackground = False
                      ShowCaption = False
                      TabOrder = 3
                      object PnlCampoMensagemFundo: TPanel
                        Left = 1
                        Top = 1
                        Width = 852
                        Height = 70
                        Align = alClient
                        BevelOuter = bvNone
                        ParentBackground = False
                        ShowCaption = False
                        TabOrder = 0
                        object MemoMensagem: TMemo
                          AlignWithMargins = True
                          Left = 8
                          Top = 8
                          Width = 836
                          Height = 54
                          Margins.Left = 8
                          Margins.Top = 8
                          Margins.Right = 8
                          Margins.Bottom = 8
                          Align = alClient
                          BevelInner = bvNone
                          BevelOuter = bvNone
                          BorderStyle = bsNone
                          TabOrder = 0
                        end
                      end
                    end
                    object PnlAlterarConfig: TPanel
                      Left = 224
                      Top = 302
                      Width = 140
                      Height = 23
                      BevelOuter = bvNone
                      ParentBackground = False
                      ShowCaption = False
                      TabOrder = 4
                    end
                    object Panel11: TPanel
                      Left = 20
                      Top = 338
                      Width = 128
                      Height = 40
                      BevelOuter = bvNone
                      ParentBackground = False
                      ShowCaption = False
                      TabOrder = 5
                    end
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
                  object PnlConfigFundo: TPanel
                    Left = 1
                    Top = 1
                    Width = 902
                    Height = 481
                    Align = alClient
                    BevelOuter = bvNone
                    ParentBackground = False
                    ShowCaption = False
                    TabOrder = 0
                    object Label1: TLabel
                      Left = 24
                      Top = 16
                      Width = 108
                      Height = 32
                      AutoSize = False
                      Caption = 'Configura'#231#245'es'
                      ShowAccelChar = False
                      Layout = tlCenter
                    end
                    object Label2: TLabel
                      Left = 140
                      Top = 16
                      Width = 125
                      Height = 32
                      AutoSize = False
                      Caption = 'E-mail de envio (SMTP)'
                      ShowAccelChar = False
                      Layout = tlCenter
                    end
                    object Label4: TLabel
                      Left = 24
                      Top = 60
                      Width = 76
                      Height = 15
                      Caption = 'Servidor SMTP'
                      ShowAccelChar = False
                    end
                    object SkSvgErroSMTP: TSkSvg
                      Left = 24
                      Top = 116
                      Width = 14
                      Height = 14
                      Visible = False
                    end
                    object LabelErroSMTP: TLabel
                      Left = 42
                      Top = 115
                      Width = 300
                      Height = 15
                      AutoSize = False
                      ShowAccelChar = False
                      Visible = False
                      WordWrap = True
                    end
                    object Label7: TLabel
                      Left = 542
                      Top = 60
                      Width = 28
                      Height = 15
                      Caption = 'Porta'
                      ShowAccelChar = False
                    end
                    object SkSvgErroPorta: TSkSvg
                      Left = 542
                      Top = 116
                      Width = 14
                      Height = 14
                      Visible = False
                    end
                    object LabelErroPorta: TLabel
                      Left = 560
                      Top = 115
                      Width = 102
                      Height = 15
                      AutoSize = False
                      ShowAccelChar = False
                      Visible = False
                      WordWrap = True
                    end
                    object LabelSeguranca: TLabel
                      Left = 678
                      Top = 60
                      Width = 52
                      Height = 15
                      Caption = 'Seguran'#231'a'
                      ShowAccelChar = False
                    end
                    object LabelAjudaSeguranca: TLabel
                      Left = 678
                      Top = 115
                      Width = 200
                      Height = 15
                      AutoSize = False
                      Caption = 'Porta 587 usa TLS; porta 465 usa SSL.'
                      ShowAccelChar = False
                      WordWrap = True
                    end
                    object Label8: TLabel
                      Left = 24
                      Top = 142
                      Width = 90
                      Height = 15
                      Caption = 'E-mail (usu'#225'rio)'
                      ShowAccelChar = False
                    end
                    object SkSvgErroEmail: TSkSvg
                      Left = 24
                      Top = 198
                      Width = 14
                      Height = 14
                      Visible = False
                    end
                    object LabelErroEmail: TLabel
                      Left = 42
                      Top = 197
                      Width = 300
                      Height = 15
                      AutoSize = False
                      ShowAccelChar = False
                      Visible = False
                      WordWrap = True
                    end
                    object Label9: TLabel
                      Left = 459
                      Top = 142
                      Width = 32
                      Height = 15
                      Caption = 'Senha'
                      ShowAccelChar = False
                    end
                    object LabelAjudaSenha: TLabel
                      Left = 459
                      Top = 197
                      Width = 419
                      Height = 15
                      AutoSize = False
                      Caption = 'No Gmail, use uma senha de app.'
                      ShowAccelChar = False
                      WordWrap = True
                    end
                    object Label10: TLabel
                      Left = 24
                      Top = 224
                      Width = 143
                      Height = 15
                      Caption = 'Mensagem padr'#227'o do e-mail'
                      ShowAccelChar = False
                    end
                    object LabelTestando: TLabel
                      Left = 176
                      Top = 323
                      Width = 300
                      Height = 32
                      AutoSize = False
                      ShowAccelChar = False
                      Visible = False
                      Layout = tlCenter
                    end
                    object SkSvgConfigSalva: TSkSvg
                      Left = 620
                      Top = 332
                      Width = 14
                      Height = 14
                      Visible = False
                    end
                    object LabelConfigSalva: TLabel
                      Left = 638
                      Top = 323
                      Width = 108
                      Height = 32
                      AutoSize = False
                      Caption = 'Configura'#231#245'es salvas'
                      ShowAccelChar = False
                      Visible = False
                      Layout = tlCenter
                    end
                    object PnlFaixaConfig: TPanel
                      Left = 24
                      Top = 60
                      Width = 854
                      Height = 44
                      BevelOuter = bvNone
                      ParentBackground = False
                      ShowCaption = False
                      TabOrder = 0
                      Visible = False
                      object PnlFaixaConfigBarra: TPanel
                        Left = 0
                        Top = 0
                        Width = 4
                        Height = 44
                        Align = alLeft
                        BevelOuter = bvNone
                        ParentBackground = False
                        ShowCaption = False
                        TabOrder = 0
                      end
                      object SkSvgFaixaConfig: TSkSvg
                        AlignWithMargins = True
                        Left = 20
                        Top = 12
                        Width = 20
                        Height = 20
                        Margins.Left = 16
                        Margins.Top = 12
                        Margins.Right = 0
                        Margins.Bottom = 12
                        Align = alLeft
                      end
                      object PbxFaixaConfig: TPaintBox
                        AlignWithMargins = True
                        Left = 52
                        Top = 12
                        Width = 786
                        Height = 20
                        Margins.Left = 12
                        Margins.Top = 12
                        Margins.Right = 16
                        Margins.Bottom = 12
                        Align = alClient
                      end
                    end
                    object PnlCampoSMTP: TPanel
                      Left = 24
                      Top = 79
                      Width = 502
                      Height = 32
                      BevelOuter = bvNone
                      Padding.Left = 1
                      Padding.Top = 1
                      Padding.Right = 1
                      Padding.Bottom = 1
                      ParentBackground = False
                      ShowCaption = False
                      TabOrder = 1
                      object PnlCampoSMTPFundo: TPanel
                        Left = 1
                        Top = 1
                        Width = 500
                        Height = 30
                        Align = alClient
                        BevelOuter = bvNone
                        ParentBackground = False
                        ShowCaption = False
                        TabOrder = 0
                        object EditSMTP: TEdit
                          AlignWithMargins = True
                          Left = 8
                          Top = 6
                          Width = 484
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
                          TextHint = 'Ex.: smtp.gmail.com'
                        end
                      end
                    end
                    object PnlCampoPorta: TPanel
                      Left = 542
                      Top = 79
                      Width = 120
                      Height = 32
                      BevelOuter = bvNone
                      Padding.Left = 1
                      Padding.Top = 1
                      Padding.Right = 1
                      Padding.Bottom = 1
                      ParentBackground = False
                      ShowCaption = False
                      TabOrder = 2
                      object PnlCampoPortaFundo: TPanel
                        Left = 1
                        Top = 1
                        Width = 118
                        Height = 30
                        Align = alClient
                        BevelOuter = bvNone
                        ParentBackground = False
                        ShowCaption = False
                        TabOrder = 0
                        object EditPorta: TEdit
                          AlignWithMargins = True
                          Left = 8
                          Top = 6
                          Width = 102
                          Height = 18
                          Margins.Left = 8
                          Margins.Top = 6
                          Margins.Right = 8
                          Margins.Bottom = 6
                          Align = alClient
                          BevelInner = bvNone
                          BevelOuter = bvNone
                          BorderStyle = bsNone
                          NumbersOnly = True
                          TabOrder = 0
                          TextHint = '587'
                        end
                      end
                    end
                    object CheckBoxSSL: TCheckBox
                      Left = 678
                      Top = 86
                      Width = 48
                      Height = 17
                      Caption = 'SSL'
                      TabOrder = 3
                    end
                    object CheckBoxTSL: TCheckBox
                      Left = 750
                      Top = 86
                      Width = 48
                      Height = 17
                      Caption = 'TLS'
                      TabOrder = 4
                    end
                    object PnlCampoEmail: TPanel
                      Left = 24
                      Top = 161
                      Width = 419
                      Height = 32
                      BevelOuter = bvNone
                      Padding.Left = 1
                      Padding.Top = 1
                      Padding.Right = 1
                      Padding.Bottom = 1
                      ParentBackground = False
                      ShowCaption = False
                      TabOrder = 5
                      object PnlCampoEmailFundo: TPanel
                        Left = 1
                        Top = 1
                        Width = 417
                        Height = 30
                        Align = alClient
                        BevelOuter = bvNone
                        ParentBackground = False
                        ShowCaption = False
                        TabOrder = 0
                        object SkSvgEmail: TSkSvg
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
                        object EditEmail: TEdit
                          AlignWithMargins = True
                          Left = 32
                          Top = 6
                          Width = 377
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
                        end
                      end
                    end
                    object PnlCampoSenha: TPanel
                      Left = 459
                      Top = 161
                      Width = 419
                      Height = 32
                      BevelOuter = bvNone
                      Padding.Left = 1
                      Padding.Top = 1
                      Padding.Right = 1
                      Padding.Bottom = 1
                      ParentBackground = False
                      ShowCaption = False
                      TabOrder = 6
                      object PnlCampoSenhaFundo: TPanel
                        Left = 1
                        Top = 1
                        Width = 417
                        Height = 30
                        Align = alClient
                        BevelOuter = bvNone
                        ParentBackground = False
                        ShowCaption = False
                        TabOrder = 0
                        object SkSvg5: TSkSvg
                          AlignWithMargins = True
                          Left = 393
                          Top = 7
                          Width = 16
                          Height = 16
                          Cursor = crHandPoint
                          Margins.Left = 0
                          Margins.Top = 7
                          Margins.Right = 8
                          Margins.Bottom = 7
                          Align = alRight
                          OnClick = SkSvg5Click
                        end
                        object EditPass: TEdit
                          AlignWithMargins = True
                          Left = 8
                          Top = 6
                          Width = 377
                          Height = 18
                          Margins.Left = 8
                          Margins.Top = 6
                          Margins.Right = 8
                          Margins.Bottom = 6
                          Align = alClient
                          BevelInner = bvNone
                          BevelOuter = bvNone
                          BorderStyle = bsNone
                          PasswordChar = '*'
                          TabOrder = 0
                        end
                      end
                    end
                    object PnlCampoMsg: TPanel
                      Left = 24
                      Top = 243
                      Width = 854
                      Height = 56
                      BevelOuter = bvNone
                      Padding.Left = 1
                      Padding.Top = 1
                      Padding.Right = 1
                      Padding.Bottom = 1
                      ParentBackground = False
                      ShowCaption = False
                      TabOrder = 7
                      object PnlCampoMsgFundo: TPanel
                        Left = 1
                        Top = 1
                        Width = 852
                        Height = 54
                        Align = alClient
                        BevelOuter = bvNone
                        ParentBackground = False
                        ShowCaption = False
                        TabOrder = 0
                        object MemoMsg: TMemo
                          AlignWithMargins = True
                          Left = 8
                          Top = 8
                          Width = 836
                          Height = 38
                          Margins.Left = 8
                          Margins.Top = 8
                          Margins.Right = 8
                          Margins.Bottom = 8
                          Align = alClient
                          BevelInner = bvNone
                          BevelOuter = bvNone
                          BorderStyle = bsNone
                          TabOrder = 0
                        end
                      end
                    end
                    object PnlTestarConexao: TPanel
                      Left = 20
                      Top = 319
                      Width = 152
                      Height = 40
                      BevelOuter = bvNone
                      ParentBackground = False
                      ShowCaption = False
                      TabOrder = 8
                    end
                    object Panel9: TPanel
                      Left = 750
                      Top = 319
                      Width = 128
                      Height = 40
                      BevelOuter = bvNone
                      ParentBackground = False
                      ShowCaption = False
                      TabOrder = 9
                    end
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
              object TelaSobre: TTabSheet
                Caption = 'Sobre'
                ImageIndex = 6
                TabVisible = False
                ExplicitLeft = 0
                ExplicitTop = 0
                ExplicitWidth = 0
                ExplicitHeight = 0
                object PnlTelaSobre: TPanel
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
                  object PnlTelaSobreFundo: TPanel
                    Left = 1
                    Top = 1
                    Width = 902
                    Height = 481
                    Align = alClient
                    BevelOuter = bvNone
                    ParentBackground = False
                    ShowCaption = False
                    TabOrder = 0
                    object LabelSobreVersao: TLabel
                      Left = 0
                      Top = 168
                      Width = 902
                      Height = 25
                      Alignment = taCenter
                      AutoSize = False
                      ShowAccelChar = False
                    end
                    object LabelSobreDescricao: TLabel
                      Left = 0
                      Top = 201
                      Width = 902
                      Height = 17
                      Alignment = taCenter
                      AutoSize = False
                      Caption = 'Totalizador de XMLs de NF-e (55) e NFC-e (65) com IBS/CBS, DANFE e relat'#243'rios.'
                      ShowAccelChar = False
                      WordWrap = True
                    end
                    object LabelSobreAutor: TLabel
                      Left = 0
                      Top = 234
                      Width = 902
                      Height = 17
                      Alignment = taCenter
                      AutoSize = False
                      Caption = 'Desenvolvido por Caique Garcia'
                      ShowAccelChar = False
                    end
                    object LabelSobreCreditos: TLabel
                      Left = 0
                      Top = 302
                      Width = 902
                      Height = 15
                      Alignment = taCenter
                      AutoSize = False
                      Caption = #205'cones: Lucide (licen'#231'a ISC) '#183' Componentes: ACBr, Skia4Delphi'
                      ShowAccelChar = False
                      WordWrap = True
                    end
                    object SkSvgSobreLogo: TSkSvg
                      Left = 343
                      Top = 108
                      Width = 216
                      Height = 44
                      Svg.Source = 
                        '<svg xmlns="http://www.w3.org/2000/svg" width="157" height="32" ' +
                        'viewBox="0 0 157 32">'#13#10'  <title>ProXML (para fundo claro)</title>'#13#10' ' +
                        ' <!-- Logo ProXML vetorial (redesenhado a partir de src/img/Logo' +
                        '/Logo1.png). Sem fontes, filtros nem scripts. -->'#13#10'  <g><circle cx' +
                        '="13" cy="3" r="1.25" fill="#B4BACA"/><circle cx="18.5" cy="3" r' +
                        '="1.25" fill="#B4BACA"/><circle cx="8.25" cy="7.75" r="1.55" fil' +
                        'l="#8E97AE"/><circle cx="13" cy="7.75" r="1.8" fill="#55688F"/><' +
                        'circle cx="18.5" cy="7.75" r="1.8" fill="#55688F"/><circle cx="2' +
                        '3.25" cy="7.75" r="1.55" fill="#8E97AE"/><circle cx="3.5" cy="12' +
                        '.75" r="1.25" fill="#B4BACA"/><circle cx="8.25" cy="12.75" r="1.' +
                        '8" fill="#55688F"/><circle cx="13" cy="12.75" r="2.1" fill="#2F4' +
                        'A66"/><circle cx="18.5" cy="12.75" r="2.1" fill="#2F4A66"/><circ' +
                        'le cx="23.25" cy="12.75" r="1.8" fill="#55688F"/><circle cx="28"' +
                        ' cy="12.75" r="1.25" fill="#B4BACA"/><circle cx="3.5" cy="18.25"' +
                        ' r="1.25" fill="#B4BACA"/><circle cx="8.25" cy="18.25" r="1.8" f' +
                        'ill="#55688F"/><circle cx="13" cy="18.25" r="2.1" fill="#2F4A66"' +
                        '/><circle cx="18.5" cy="18.25" r="2.1" fill="#2F4A66"/><circle c' +
                        'x="23.25" cy="18.25" r="1.8" fill="#55688F"/><circle cx="28" cy=' +
                        '"18.25" r="1.25" fill="#B4BACA"/><circle cx="8.25" cy="23.25" r=' +
                        '"1.55" fill="#8E97AE"/><circle cx="13" cy="23.25" r="1.8" fill="' +
                        '#55688F"/><circle cx="18.5" cy="23.25" r="1.8" fill="#55688F"/><' +
                        'circle cx="23.25" cy="23.25" r="1.55" fill="#8E97AE"/><circle cx' +
                        '="13" cy="28" r="1.25" fill="#B4BACA"/><circle cx="18.5" cy="28"' +
                        ' r="1.25" fill="#B4BACA"/></g>'#13#10'  <path d="M35 25V8.2A2.2 2.2 0 0 ' +
                        '1 37.2 6H46A4 4 0 0 1 50 10V14A4 4 0 0 1 46 18H35M55 25V11.8M55 ' +
                        '15.6C55.4 13.3 57.4 12.3 60 12.3H62.4M91 5.6L106.2 25M106.4 5.6L' +
                        '91 25M112 25V11.2A5.75 5.75 0 0 1 123.5 11.2V25M123.5 11.2A5.75 ' +
                        '5.75 0 0 1 135 11.2V25M140 5.6V22A3 3 0 0 0 143 25H153.2" fill="' +
                        'none" stroke="#171A21" stroke-width="2.5" stroke-linecap="round"' +
                        ' stroke-linejoin="round"/>'#13#10'  <ellipse cx="72" cy="18.6" rx="6.7" ' +
                        'ry="6.4" fill="none" stroke="#171A21" stroke-width="2.5"/>'#13#10'</svg>'
                    end
                    object PnlSobreLink: TPanel
                      Left = 299
                      Top = 255
                      Width = 304
                      Height = 25
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
  object TimerConfigSalva: TTimer
    Enabled = False
    Interval = 3000
    Left = 1088
    Top = 516
  end
  object TimerTesteConexao: TTimer
    Enabled = False
    Interval = 15000
    Left = 1088
    Top = 468
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
