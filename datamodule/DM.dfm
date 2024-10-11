object DMConfig: TDMConfig
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 273
  Width = 302
  object Conxao: TFDConnection
    Params.Strings = (
      'DriverID=SQLite'
      'Database=config')
    AfterConnect = ConxaoAfterConnect
    BeforeConnect = ConxaoBeforeConnect
    Left = 136
    Top = 88
  end
  object Query: TFDQuery
    Connection = Conxao
    Left = 136
    Top = 144
  end
end
