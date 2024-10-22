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
    Left = 152
    Top = 48
  end
  object Query: TFDQuery
    Connection = Conexao
    Left = 120
    Top = 144
  end
  object QryNotas: TFDQuery
    Connection = Conexao
    SQL.Strings = (
      'SELECT NUMERO, CHAVE, VALOR, DATA, BCICMS, VLICMS FROM NF')
    Left = 224
    Top = 72
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
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    VendorLib = 'D:\PROJETOS\Novo-ProXML_Delphi\bin\SQLite3.dll'
    Left = 184
    Top = 168
  end
end
