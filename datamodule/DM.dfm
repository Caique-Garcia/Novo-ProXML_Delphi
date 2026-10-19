object DMConfig: TDMConfig
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 273
  Width = 383
  object Conexao: TFDConnection
    Params.Strings = (
      'DriverID=SQLite'
      'Database=D:\PROJETOS\Novo-ProXML_Delphi\bin\db\notas.db')
    LoginPrompt = False
    AfterConnect = ConexaoAfterConnect
    BeforeConnect = ConexaoBeforeConnect
    Left = 136
    Top = 88
  end
  object Query: TFDQuery
    Connection = Conexao
    Left = 136
    Top = 144
  end
  object QryNotas: TFDQuery
    BeforeOpen = QryNotasBeforeOpen
    Connection = Conexao
    SQL.Strings = (
      'SELECT NUMERO, CHAVE, VALOR, DATA, BCICMS, VLICMS, MODELO FROM NF'
      'WHERE (:MODELO = 0 OR MODELO = :MODELO)')
    Left = 232
    Top = 120
    ParamData = <
      item
        Name = 'MODELO'
        DataType = ftInteger
        ParamType = ptInput
        Value = 0
      end>
    object QryNotasCHAVE: TWideStringField
      FieldName = 'CHAVE'
      Origin = 'CHAVE'
      Size = 50
    end
    object QryNotasVALOR: TWideStringField
      FieldName = 'VALOR'
      Origin = 'VALOR'
    end
    object QryNotasDATA: TWideStringField
      FieldName = 'DATA'
      Origin = 'DATA'
      Size = 36
    end
    object QryNotasBCICMS: TWideStringField
      FieldName = 'BCICMS'
      Origin = 'BCICMS'
      Size = 30
    end
    object QryNotasVLICMS: TWideStringField
      FieldName = 'VLICMS'
      Origin = 'VLICMS'
      Size = 30
    end
    object QryNotasNUMERO: TWideStringField
      FieldName = 'NUMERO'
      Origin = 'NUMERO'
    end
    object QryNotasMODELO: TIntegerField
      FieldName = 'MODELO'
      Origin = 'MODELO'
    end
  end
  object QryNotasIBSCBS: TFDQuery
    BeforeOpen = QryNotasBeforeOpen
    Connection = Conexao
    SQL.Strings = (
      'SELECT NUMERO, CHAVE, DATA, MODELO, VBCIBSCBS, VIBSUF, VIBSMUN, VIBS, VCBS FROM NF'
      'WHERE TEM_IBSCBS = 1'
      'AND (:MODELO = 0 OR MODELO = :MODELO)')
    Left = 232
    Top = 176
    ParamData = <
      item
        Name = 'MODELO'
        DataType = ftInteger
        ParamType = ptInput
        Value = 0
      end>
    object QryNotasIBSCBSNUMERO: TWideStringField
      FieldName = 'NUMERO'
      Origin = 'NUMERO'
    end
    object QryNotasIBSCBSCHAVE: TWideStringField
      FieldName = 'CHAVE'
      Origin = 'CHAVE'
      Size = 50
    end
    object QryNotasIBSCBSDATA: TWideStringField
      FieldName = 'DATA'
      Origin = 'DATA'
      Size = 36
    end
    object QryNotasIBSCBSMODELO: TIntegerField
      FieldName = 'MODELO'
      Origin = 'MODELO'
    end
    object QryNotasIBSCBSVBCIBSCBS: TWideStringField
      FieldName = 'VBCIBSCBS'
      Origin = 'VBCIBSCBS'
      Size = 30
    end
    object QryNotasIBSCBSVIBSUF: TWideStringField
      FieldName = 'VIBSUF'
      Origin = 'VIBSUF'
      Size = 30
    end
    object QryNotasIBSCBSVIBSMUN: TWideStringField
      FieldName = 'VIBSMUN'
      Origin = 'VIBSMUN'
      Size = 30
    end
    object QryNotasIBSCBSVIBS: TWideStringField
      FieldName = 'VIBS'
      Origin = 'VIBS'
      Size = 30
    end
    object QryNotasIBSCBSVCBS: TWideStringField
      FieldName = 'VCBS'
      Origin = 'VCBS'
      Size = 30
    end
  end
end
