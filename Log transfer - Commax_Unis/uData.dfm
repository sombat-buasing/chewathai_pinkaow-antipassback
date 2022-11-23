object dmData: TdmData
  OldCreateOrder = False
  Height = 555
  Width = 733
  object cmxFind: TUniQuery
    Left = 72
    Top = 144
  end
  object dsFind: TUniDataSource
    DataSet = cmxFind
    Left = 72
    Top = 216
  end
  object MySQLUniProvider1: TMySQLUniProvider
    Left = 208
    Top = 48
  end
  object bacFind: TUniQuery
    Left = 352
    Top = 152
  end
  object bacConnection: TUniConnection
    ProviderName = 'MySQL'
    Port = 3306
    Database = 'bac_center'
    SpecificOptions.Strings = (
      'MySQL.Charset=utf8')
    Username = 'root'
    Server = 'ums.dyndns.info'
    LoginPrompt = False
    OnConnectionLost = bacConnectionConnectionLost
    Left = 352
    Top = 56
    EncryptedPassword = '9DFF9EFF8BFF92FF9EFF91FFCDFFCFFF'
  end
  object zmxConnection: TUniConnection
    ProviderName = 'MySQL'
    Database = 'db_center'
    SpecificOptions.Strings = (
      'MySQL.Charset=utf8')
    Username = 'bac'
    Server = '203.156.178.109'
    LoginPrompt = False
    OnConnectionLost = zmxConnectionConnectionLost
    Left = 72
    Top = 48
    EncryptedPassword = '9DFF9EFF9CFFD2FF8FFF9EFF8CFF8CFF88FF90FF8DFF9BFF'
  end
  object aptConnection: TUniConnection
    ProviderName = 'SQL Server'
    Database = 'UCDB'
    SpecificOptions.Strings = (
      'MySQL.Charset=utf8')
    Username = 'unisuser'
    LoginPrompt = False
    OnConnectionLost = aptConnectionConnectionLost
    Left = 496
    Top = 64
    EncryptedPassword = '8AFF91FF96FF8CFF9EFF92FF97FF90FF'
  end
  object SQLServerUniProvider1: TSQLServerUniProvider
    Left = 216
    Top = 128
  end
  object unisConnection: TUniConnection
    ProviderName = 'SQL Server'
    Database = 'bac_center'
    SpecificOptions.Strings = (
      'MySQL.Charset=utf8')
    Username = 'root'
    Server = 'Sql'
    LoginPrompt = False
    OnConnectionLost = unisConnectionConnectionLost
    Left = 448
    Top = 144
    EncryptedPassword = '9DFF9EFF8BFF92FF9EFF91FFCDFFCFFF'
  end
end
