object dmRest: TdmRest
  OldCreateOrder = False
  Height = 440
  Width = 767
  object RESTClient: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    BaseURL = 'https://bac.dyndns-server.com:9004/v1/login'
    Params = <>
    RaiseExceptionOn500 = False
    Left = 88
    Top = 112
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
    Left = 184
    Top = 112
  end
  object RESTResponse: TRESTResponse
    Left = 280
    Top = 120
  end
end
