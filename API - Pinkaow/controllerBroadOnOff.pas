unit controllerBroadOnOff;

interface

uses
  MVCFramework, MVCFramework.Commons, MVCFramework.Serializer.Commons,
      IdTCPClient, System.NetEncoding,
    System.JSON, Rest.JSON,  Web.HTTPApp;

Type
  TBoard = class
    FIPAddress : string;
    FPort : integer;
    FStatus : string;
  property IPAddress : string read FIPAddress write FIPAddress ;
  property Port : Integer read FPort write FPort;
  property Status : String read FStatus write FStatus;
end;

type
  [MVCPath('/api')]
  TControllerBroadOnOff = class(TMVCController)
  public
    [MVCPath]
    [MVCHTTPMethod([httpGET])]
    procedure Index;

    [MVCPath('/reversedstrings/($Value)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetReversedString(const Value: String);
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;

  public
    //Sample CRUD Actions for a "Customer" entity
    [MVCPath('/board_on_off')]
    [MVCHTTPMethod([httpPost])]
    procedure GetBoardOnOff;


end;

implementation

uses
  System.SysUtils, MVCFramework.Logger, System.StrUtils, System.Threading;

procedure TControllerBroadOnOff.Index;
begin
  //use Context property to access to the HTTP request and response 
  Render('Board On Off');
end;

procedure TControllerBroadOnOff.GetReversedString(const Value: String);
begin
  Render(System.StrUtils.ReverseString(Value.Trim));
end;

procedure TControllerBroadOnOff.OnAfterAction(Context: TWebContext; const AActionName: string); 
begin
  { Executed after each action }
  inherited;
end;

procedure TControllerBroadOnOff.OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean);
begin
  { Executed before each action
    if handled is true (or an exception is raised) the actual
    action will not be called }
  inherited;
end;

//Sample CRUD Actions for a "Customer" entity
procedure TControllerBroadOnOff.GetBoardOnOff;
var
  board : TBoard;
  IdTCP : TIdTCPClient;
  nPass_relay, nError_relay : integer;
begin

  nPass_relay := 0;
  nError_relay := 1;

  board := TJSON.JsonToObject<TBoard>(Context.Request.Body);

  IdTCP := TIdTCPClient.Create(nil);
  IdTCP.Host := board.IPAddress;
  IdTCP.Port := board.Port ;
  IdTCP.ReadTimeout := 10;
  try
    IdTCP.Connect;
    try
      if IdTCP.Connected = True then
      begin
        IdTCP.Socket.WriteLn('*LOGIN=' + TNetEncoding.Base64.Encode('1342'));

        if board.Status = 'Pass' then
        begin
          IdTCP.Socket.WriteLn( '*GPIO'  + FormatFloat('00',nPass_relay) + '=' + FormatFloat('0',0)  );
          sleep(1000);
          IdTCP.Socket.WriteLn( '*GPIO'  + FormatFloat('00',nPass_relay) + '=' + FormatFloat('0',1)  );
          IdTCP.Socket.WriteLn( '*GPIO'  + FormatFloat('00',nError_relay) + '=' + FormatFloat('0',1)  );
          sleep(500);
        end;

        if board.Status = 'Error' then
        begin
          IdTCP.Socket.WriteLn( '*GPIO'  + FormatFloat('00',nError_relay) + '=' + FormatFloat('0',0)  );
          sleep(1000);



//          TTask.Run(
//          procedure
//          begin
//            WriteLn( nError_Relay.ToString ) ;
//            sleep(5000);
//            IdTCP.Socket.WriteLn( '*GPIO'  + FormatFloat('00',nError_relay) + '=' + FormatFloat('0',1)  );
//            sleep(100);
//          end); // TTask.Run
        end;

      end;
    Except

    end;
  finally
    IdTCP.Free;
  end;

  Render ( Board ) ;

end;



end.
