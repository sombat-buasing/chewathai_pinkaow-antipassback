object dmRest: TdmRest
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 350
  Width = 653
  object RESTClient: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    BaseURL = 'https://bac.dyndns-server.com:9004/v1/login'
    Params = <>
    RaiseExceptionOn500 = False
    Left = 32
    Top = 22
  end
  object RESTRequest: TRESTRequest
    Client = RESTClient
    Method = rmPOST
    Params = <
      item
        Kind = pkREQUESTBODY
        Name = 'body'
        Options = [poDoNotEncode]
        ContentType = ctAPPLICATION_JSON
      end>
    Resource = 'login'
    Response = RESTResponse
    SynchronizedEvents = False
    Left = 128
    Top = 22
  end
  object RESTResponse: TRESTResponse
    Left = 224
    Top = 22
  end
  object FDConnection: TFDConnection
    Params.Strings = (
      'Database=ucdb'
      'User_Name=unisuser'
      'Password=unisamho'
      'Server=1'
      'DriverID=MSSQL')
    LoginPrompt = False
    Left = 40
    Top = 112
  end
  object FDQuery: TFDQuery
    Connection = FDConnection
    Left = 128
    Top = 112
  end
  object carConnection: TFDConnection
    Params.Strings = (
      'Database=ucdb'
      'User_Name=unisuser'
      'Password=unisamho'
      'Server=1'
      'DriverID=MSSQL')
    LoginPrompt = False
    Left = 40
    Top = 192
  end
  object carQuery: TFDQuery
    Connection = carConnection
    Left = 120
    Top = 192
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 216
    Top = 192
  end
  object FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink
    Left = 216
    Top = 112
  end
end
