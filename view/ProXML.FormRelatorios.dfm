object FormRelatorios: TFormRelatorios
  Left = 0
  Top = 0
  ClientHeight = 600
  ClientWidth = 923
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object QuickNotas: TQuickRep
    Left = 62
    Top = 21
    Width = 794
    Height = 1123
    BeforePrint = QuickNotasBeforePrint
    ShowingPreview = False
    DataSet = DMConfig.QryNotas
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Functions.Strings = (
      'PAGENUMBER'
      'COLUMNNUMBER'
      'REPORTTITLE')
    Functions.DATA = (
      '0'
      '0'
      #39#39)
    Options = [LastPageFooter]
    Page.Columns = 1
    Page.Orientation = poPortrait
    Page.PaperSize = A4
    Page.Continuous = False
    Page.Values = (
      100.000000000000000000
      2970.000000000000000000
      100.000000000000000000
      2100.000000000000000000
      100.000000000000000000
      100.000000000000000000
      0.000000000000000000)
    PrinterSettings.Copies = 1
    PrinterSettings.OutputBin = Auto
    PrinterSettings.Duplex = False
    PrinterSettings.FirstPage = 0
    PrinterSettings.LastPage = 0
    PrinterSettings.UseStandardprinter = False
    PrinterSettings.UseCustomBinCode = False
    PrinterSettings.CustomBinCode = 0
    PrinterSettings.ExtendedDuplex = 0
    PrinterSettings.UseCustomPaperCode = False
    PrinterSettings.CustomPaperCode = 0
    PrinterSettings.PrintMetaFile = False
    PrinterSettings.MemoryLimit = 1000000
    PrinterSettings.PrintQuality = 0
    PrinterSettings.Collate = 0
    PrinterSettings.ColorOption = 0
    PrintIfEmpty = True
    SnapToGrid = True
    Units = MM
    Zoom = 100
    PrevFormStyle = fsNormal
    PreviewInitialState = wsMaximized
    PreviewWidth = 500
    PreviewHeight = 500
    PrevInitialZoom = qrZoomToWidth
    PreviewDefaultSaveType = stPDF
    PreviewLeft = 0
    PreviewTop = 0
    object QRBandTitulo: TQRBand
      Left = 38
      Top = 38
      Width = 718
      Height = 92
      AlignToBottom = False
      TransparentBand = False
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        243.416666666666657193
        1899.708333333333257542)
      PreCaluculateBandHeight = False
      KeepOnOnePage = False
      BandType = rbTitle
      object QRLabelTitulo: TQRLabel
        Left = 0
        Top = 0
        Width = 600
        Height = 26
        Size.Values = (
          68.791666666666671404
          0.000000000000000000
          0.000000000000000000
          1587.500000000000000000)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        Caption = 'Relat'#243'rio de Notas'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        VerticalAlignment = tlTop
        FontSize = 16
      end
      object QRLabelRotuloPeriodo: TQRLabel
        Left = 0
        Top = 26
        Width = 52
        Height = 17
        Size.Values = (
          44.979166666666664298
          0.000000000000000000
          68.791666666666671404
          137.583333333333342807)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        Caption = 'Per'#237'odo:'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        VerticalAlignment = tlTop
        FontSize = 9
      end
      object QRLabelPeriodo: TQRLabel
        Left = 52
        Top = 26
        Width = 140
        Height = 17
        Size.Values = (
          44.979166666666664298
          137.583333333333342807
          68.791666666666671404
          370.416666666666685614)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        Caption = ' 01/10/2026 a 31/10/2026 '#183' '
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        VerticalAlignment = tlTop
        FontSize = 9
      end
      object QRLabelRotuloModelo: TQRLabel
        Left = 192
        Top = 26
        Width = 48
        Height = 17
        Size.Values = (
          44.979166666666664298
          508.000000000000000000
          68.791666666666671404
          127.000000000000000000)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        Caption = 'Modelo:'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        VerticalAlignment = tlTop
        FontSize = 9
      end
      object QRLabelModeloFiltro: TQRLabel
        Left = 240
        Top = 26
        Width = 170
        Height = 17
        Size.Values = (
          44.979166666666664298
          635.000000000000000000
          68.791666666666671404
          449.791666666666685614)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        Caption = ' Todos (NF-e 55 e NFC-e 65) '#183' '
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        VerticalAlignment = tlTop
        FontSize = 9
      end
      object QRLabelQuantidade: TQRLabel
        Left = 410
        Top = 26
        Width = 30
        Height = 17
        Size.Values = (
          44.979166666666664298
          1084.791666666666742458
          68.791666666666671404
          79.375000000000000000)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        Caption = '0'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        VerticalAlignment = tlTop
        FontSize = 9
      end
      object QRLabelNotas: TQRLabel
        Left = 440
        Top = 26
        Width = 160
        Height = 17
        Size.Values = (
          44.979166666666664298
          1164.166666666666742458
          68.791666666666671404
          423.333333333333314386)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        Caption = ' notas'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        VerticalAlignment = tlTop
        FontSize = 9
      end
      object QRLabelRotuloPasta: TQRLabel
        Left = 0
        Top = 43
        Width = 36
        Height = 17
        Size.Values = (
          44.979166666666664298
          0.000000000000000000
          113.770833333333328596
          95.250000000000000000)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        Caption = 'Pasta:'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        VerticalAlignment = tlTop
        FontSize = 9
      end
      object QRLabelPasta: TQRLabel
        Left = 36
        Top = 43
        Width = 568
        Height = 17
        Size.Values = (
          44.979166666666664298
          95.250000000000000000
          113.770833333333328596
          1502.833333333333257542)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        Caption = ' C:\'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        VerticalAlignment = tlTop
        FontSize = 9
      end
      object QRImageLogo: TQRImage
        Left = 620
        Top = 3
        Width = 98
        Height = 20
        Size.Values = (
          52.916666666666664298
          1640.416666666666742458
          7.937500000000000000
          259.291666666666685614)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Stretch = True
      end
      object QRLabelMarca: TQRLabel
        Left = 560
        Top = 0
        Width = 158
        Height = 26
        Enabled = False
        Size.Values = (
          68.791666666666671404
          1481.666666666666742458
          0.000000000000000000
          418.041666666666685614)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        Caption = 'ProXML'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        VerticalAlignment = tlTop
        FontSize = 12
      end
      object QRShapeTitulo: TQRShape
        Left = 0
        Top = 82
        Width = 718
        Height = 2
        Size.Values = (
          5.291666666666666963
          0.000000000000000000
          216.958333333333342807
          1899.708333333333257542)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Brush.Color = clBlack
        Pen.Style = psClear
        Shape = qrsRectangle
        VertAdjust = 0
      end
    end
    object QRBandContinuacao: TQRBand
      Left = 38
      Top = 130
      Width = 718
      Height = 24
      AlignToBottom = False
      TransparentBand = False
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        63.500000000000000000
        1899.708333333333257542)
      PreCaluculateBandHeight = False
      KeepOnOnePage = False
      BandType = rbPageHeader
      object QRLabelContinuacao: TQRLabel
        Left = 0
        Top = 4
        Width = 500
        Height = 16
        Size.Values = (
          42.333333333333335702
          0.000000000000000000
          10.583333333333333925
          1322.916666666666742458)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        Caption = 'Relat'#243'rio de Notas '#183' Modelo: Todos '#183' continua'#231#227'o'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        VerticalAlignment = tlTop
        FontSize = 9
      end
      object QRLabelPeriodoContinuacao: TQRLabel
        Left = 500
        Top = 4
        Width = 218
        Height = 16
        Size.Values = (
          42.333333333333335702
          1322.916666666666742458
          10.583333333333333925
          576.791666666666628771)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        Caption = '01/10/2026 a 31/10/2026'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        VerticalAlignment = tlTop
        FontSize = 9
      end
      object QRShapeContinuacao: TQRShape
        Left = 0
        Top = 23
        Width = 718
        Height = 1
        Size.Values = (
          2.645833333333333481
          0.000000000000000000
          60.854166666666664298
          1899.708333333333257542)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Brush.Color = clBlack
        Pen.Style = psClear
        Shape = qrsRectangle
        VertAdjust = 0
      end
    end
    object QRBandColunas: TQRBand
      Left = 38
      Top = 154
      Width = 718
      Height = 24
      AlignToBottom = False
      Color = clBtnFace
      TransparentBand = False
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        63.500000000000000000
        1899.708333333333257542)
      PreCaluculateBandHeight = False
      KeepOnOnePage = False
      BandType = rbColumnHeader
      object QRLabelNumero: TQRLabel
        Left = 6
        Top = 4
        Width = 52
        Height = 16
        Size.Values = (
          42.333333333333335702
          15.875000000000000000
          10.583333333333333925
          137.583333333333342807)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        Caption = 'N'#186
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        VerticalAlignment = tlTop
        FontSize = 9
      end
      object QRLabelModelo: TQRLabel
        Left = 66
        Top = 4
        Width = 32
        Height = 16
        Size.Values = (
          42.333333333333335702
          174.625000000000000000
          10.583333333333333925
          84.666666666666671404)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        Caption = 'Mod.'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        VerticalAlignment = tlTop
        FontSize = 9
      end
      object QRLabelData: TQRLabel
        Left = 102
        Top = 4
        Width = 64
        Height = 16
        Size.Values = (
          42.333333333333335702
          269.875000000000000000
          10.583333333333333925
          169.333333333333342807)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        Caption = 'Data'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        VerticalAlignment = tlTop
        FontSize = 9
      end
      object QRLabelChave: TQRLabel
        Left = 174
        Top = 4
        Width = 270
        Height = 16
        Size.Values = (
          42.333333333333335702
          460.375000000000000000
          10.583333333333333925
          714.375000000000000000)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        Caption = 'Chave'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        VerticalAlignment = tlTop
        FontSize = 9
      end
      object QRLabelValor: TQRLabel
        Left = 456
        Top = 4
        Width = 80
        Height = 16
        Size.Values = (
          42.333333333333335702
          1206.500000000000000000
          10.583333333333333925
          211.666666666666657193)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        Caption = 'Valor (R$)'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        VerticalAlignment = tlTop
        FontSize = 9
      end
      object QRLabelBaseICMS: TQRLabel
        Left = 548
        Top = 4
        Width = 84
        Height = 16
        Size.Values = (
          42.333333333333335702
          1449.916666666666742458
          10.583333333333333925
          222.250000000000000000)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        Caption = 'Base ICMS (R$)'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        VerticalAlignment = tlTop
        FontSize = 9
      end
      object QRLabelICMS: TQRLabel
        Left = 644
        Top = 4
        Width = 68
        Height = 16
        Size.Values = (
          42.333333333333335702
          1703.916666666666742458
          10.583333333333333925
          179.916666666666657193)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        Caption = 'ICMS (R$)'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        VerticalAlignment = tlTop
        FontSize = 9
      end
      object QRShapeColunas: TQRShape
        Left = 0
        Top = 23
        Width = 718
        Height = 1
        Size.Values = (
          2.645833333333333481
          0.000000000000000000
          60.854166666666664298
          1899.708333333333257542)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Brush.Color = clBlack
        Pen.Style = psClear
        Shape = qrsRectangle
        VertAdjust = 0
      end
    end
    object QRBandDetalhe: TQRBand
      Left = 38
      Top = 178
      Width = 718
      Height = 20
      BeforePrint = QRBandDetalheBeforePrint
      AlignToBottom = False
      TransparentBand = False
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        52.916666666666664298
        1899.708333333333257542)
      PreCaluculateBandHeight = False
      KeepOnOnePage = False
      BandType = rbDetail
      object QRDBTextNumero: TQRDBText
        Left = 6
        Top = 2
        Width = 52
        Height = 16
        Size.Values = (
          42.333333333333335702
          15.875000000000000000
          5.291666666666666963
          137.583333333333342807)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        Color = clWhite
        DataSet = DMConfig.QryNotas
        DataField = 'NUMERO'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        FullJustify = False
        MaxBreakChars = 0
        VerticalAlignment = tlTop
        FontSize = 9
      end
      object QRDBTextModelo: TQRDBText
        Left = 66
        Top = 2
        Width = 32
        Height = 16
        Size.Values = (
          42.333333333333335702
          174.625000000000000000
          5.291666666666666963
          84.666666666666671404)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        Color = clWhite
        DataSet = DMConfig.QryNotas
        DataField = 'MODELO'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        FullJustify = False
        MaxBreakChars = 0
        VerticalAlignment = tlTop
        FontSize = 9
      end
      object QRDBTextData: TQRDBText
        Left = 102
        Top = 2
        Width = 64
        Height = 16
        Size.Values = (
          42.333333333333335702
          269.875000000000000000
          5.291666666666666963
          169.333333333333342807)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        Color = clWhite
        DataSet = DMConfig.QryNotas
        DataField = 'DATA'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        FullJustify = False
        MaxBreakChars = 0
        VerticalAlignment = tlTop
        FontSize = 9
      end
      object QRDBTextChave: TQRDBText
        Left = 174
        Top = 2
        Width = 270
        Height = 16
        Size.Values = (
          42.333333333333335702
          460.375000000000000000
          5.291666666666666963
          714.375000000000000000)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        Color = clWhite
        DataSet = DMConfig.QryNotas
        DataField = 'CHAVE'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        FullJustify = False
        MaxBreakChars = 0
        VerticalAlignment = tlTop
        FontSize = 9
      end
      object QRDBTextValor: TQRDBText
        Left = 456
        Top = 2
        Width = 80
        Height = 16
        Size.Values = (
          42.333333333333335702
          1206.500000000000000000
          5.291666666666666963
          211.666666666666657193)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        Color = clWhite
        DataSet = DMConfig.QryNotas
        DataField = 'VALOR'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Transparent = True
        OnPrint = ValorPrint
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        FullJustify = False
        MaxBreakChars = 0
        VerticalAlignment = tlTop
        FontSize = 9
      end
      object QRDBTextBaseICMS: TQRDBText
        Left = 548
        Top = 2
        Width = 84
        Height = 16
        Size.Values = (
          42.333333333333335702
          1449.916666666666742458
          5.291666666666666963
          222.250000000000000000)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        Color = clWhite
        DataSet = DMConfig.QryNotas
        DataField = 'BCICMS'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Transparent = True
        OnPrint = ValorPrint
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        FullJustify = False
        MaxBreakChars = 0
        VerticalAlignment = tlTop
        FontSize = 9
      end
      object QRDBTextICMS: TQRDBText
        Left = 644
        Top = 2
        Width = 68
        Height = 16
        Size.Values = (
          42.333333333333335702
          1703.916666666666742458
          5.291666666666666963
          179.916666666666657193)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        Color = clWhite
        DataSet = DMConfig.QryNotas
        DataField = 'VLICMS'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Transparent = True
        OnPrint = ValorPrint
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        FullJustify = False
        MaxBreakChars = 0
        VerticalAlignment = tlTop
        FontSize = 9
      end
    end
    object QRBandTotais: TQRBand
      Left = 38
      Top = 198
      Width = 718
      Height = 44
      AlignToBottom = False
      TransparentBand = False
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        116.416666666666671404
        1899.708333333333257542)
      PreCaluculateBandHeight = False
      KeepOnOnePage = False
      BandType = rbSummary
      object QRShapeTotais: TQRShape
        Left = 0
        Top = 0
        Width = 718
        Height = 2
        Size.Values = (
          5.291666666666666963
          0.000000000000000000
          0.000000000000000000
          1899.708333333333257542)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Brush.Color = clBlack
        Pen.Style = psClear
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabelTotal: TQRLabel
        Left = 6
        Top = 6
        Width = 438
        Height = 16
        Size.Values = (
          42.333333333333335702
          15.875000000000000000
          15.875000000000000000
          1158.875000000000000000)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        Caption = 'Total '#183' 0 notas'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        VerticalAlignment = tlTop
        FontSize = 9
      end
      object QRLabelTotalValor: TQRLabel
        Left = 456
        Top = 6
        Width = 80
        Height = 16
        Size.Values = (
          42.333333333333335702
          1206.500000000000000000
          15.875000000000000000
          211.666666666666657193)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        Caption = '0,00'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        VerticalAlignment = tlTop
        FontSize = 9
      end
      object QRLabelTotalBaseICMS: TQRLabel
        Left = 548
        Top = 6
        Width = 84
        Height = 16
        Size.Values = (
          42.333333333333335702
          1449.916666666666742458
          15.875000000000000000
          222.250000000000000000)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        Caption = '0,00'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        VerticalAlignment = tlTop
        FontSize = 9
      end
      object QRLabelTotalICMS: TQRLabel
        Left = 644
        Top = 6
        Width = 68
        Height = 16
        Size.Values = (
          42.333333333333335702
          1703.916666666666742458
          15.875000000000000000
          179.916666666666657193)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        Caption = '0,00'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        VerticalAlignment = tlTop
        FontSize = 9
      end
      object QRLabelLegenda: TQRLabel
        Left = 6
        Top = 28
        Width = 706
        Height = 14
        Size.Values = (
          37.041666666666664298
          15.875000000000000000
          74.083333333333328596
          1867.958333333333257542)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        Caption = ''
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        VerticalAlignment = tlTop
        FontSize = 8
      end
    end
    object QRBandRodape: TQRBand
      Left = 38
      Top = 242
      Width = 718
      Height = 28
      BeforePrint = QRBandRodapeBeforePrint
      AlignToBottom = False
      TransparentBand = False
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        74.083333333333328596
        1899.708333333333257542)
      PreCaluculateBandHeight = False
      KeepOnOnePage = False
      BandType = rbPageFooter
      object QRShapeRodape: TQRShape
        Left = 0
        Top = 6
        Width = 718
        Height = 1
        Size.Values = (
          2.645833333333333481
          0.000000000000000000
          15.875000000000000000
          1899.708333333333257542)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Brush.Color = clBlack
        Pen.Style = psClear
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabelRodape: TQRLabel
        Left = 0
        Top = 12
        Width = 718
        Height = 14
        Size.Values = (
          37.041666666666664298
          0.000000000000000000
          31.750000000000000000
          1899.708333333333257542)
        XLColumn = 0
        XLNumFormat = nfGeneral
        ActiveInPreview = False
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        Caption = 'Gerado pelo ProXML'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        VerticalAlignment = tlTop
        FontSize = 8
      end
    end
  end
end
