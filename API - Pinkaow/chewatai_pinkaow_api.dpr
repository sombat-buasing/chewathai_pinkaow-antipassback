program chewatai_pinkaow_api;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  MVCFramework,
  MVCFramework.Logger,
  MVCFramework.Commons,
  MVCFramework.Signal,
  Web.ReqMulti,
  Web.WebReq,
  Web.WebBroker,
  IdContext,
  IniFiles,
  IdHTTPWebBrokerBridge,
  webModule in 'webModule.pas' {wmModule: TWebModule},
  dataModule in 'dataModule.pas' {dmRest: TDataModule},
  uAlpeta_login in 'model\uAlpeta_login.pas',
  controllerBroadOnOff in 'controllerBroadOnOff.pas',
  controllerCarparkDB in 'controllerCarparkDB.pas';

var
  alpetaUrl, alpetaUser, alpetaPassword : string;

{$R *.res}


procedure RunServer(APort: Integer);
var
  LServer: TIdHTTPWebBrokerBridge;
//  iniFilename : string;
//  iniConfig : TIniFile;
begin
  Writeln('** Chewatai Pinkaow - API **' ) ; //+ DMVCFRAMEWORK_VERSION);

  LServer := TIdHTTPWebBrokerBridge.Create(nil);
  try

    LServer.OnParseAuthentication := TMVCParseAuthentication.OnParseAuthentication;
    LServer.DefaultPort := APort;
    LServer.KeepAlive := True;

    { more info about MaxConnections
      http://ww2.indyproject.org/docsite/html/frames.html?frmname=topic&frmfile=index.html }
    LServer.MaxConnections := 0;

    { more info about ListenQueue
      http://ww2.indyproject.org/docsite/html/frames.html?frmname=topic&frmfile=index.html }
    LServer.ListenQueue := 200;

    LServer.Active := True;
    WriteLn('Listening on port ', APort);
    Write('CTRL+C to shutdown the server');
    WaitForTerminationSignal;
    EnterInShutdownState;
    LServer.Active := False;
  finally
    LServer.Free;
  end;
end;

begin
  ReportMemoryLeaksOnShutdown := True;
  IsMultiThread := True;
  try
    if WebRequestHandler <> nil then
      WebRequestHandler.WebModuleClass := WebModuleClass;
    WebRequestHandlerProc.MaxConnections := 1024;
    RunServer(9090);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
