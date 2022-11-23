unit controllerQrcode;

interface

uses
  MVCFramework, MVCFramework.Commons, MVCFramework.Serializer.Commons,
  MVCFramework.RESTClient, IniFiles,
  MVCFramework.RESTClient.Intf,
  System.JSON, Rest.JSON,
  dataModule,
  rest.Types;

type
  [MVCPath('/api')]
  TControllerQrcode = class(TMVCController) 
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
    [MVCPath('/qrcode')]
    [MVCHTTPMethod([httpGET])]
    procedure GetQrcode;


    [MVCPath('/MessageTerminal/($t_id)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetMessageTerminal( t_id: string );

    [MVCPath('/customers/($id)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetCustomer(id: Integer);

    [MVCPath('/qrcode')]
    [MVCHTTPMethod([httpPOST])]
    procedure CreateQRCode;

    [MVCPath('/customers/($id)')]
    [MVCHTTPMethod([httpPUT])]
    procedure UpdateCustomer(id: Integer);

    [MVCPath('/customers/($id)')]
    [MVCHTTPMethod([httpDELETE])]
    procedure DeleteCustomer(id: Integer);

  private
    FRESTClient: IMVCRESTClient;
    function AlpetaInsert( lRest : TdmRest;
                           lObj : TJSONObject ) : String;
    function bodyNewQRCode( nId : integer;
                            lObj : TJSONObject;
                            nGroupId : Integer ) : TJSONObject ;
    procedure OrderResponse( var bObj : TJsonObject;
                             nResult, nNewId : integer;
                             cDesc : String;
                             lObj : TJSONObject ) ;
    procedure SaveOrderLog( lRest : TdmRest;
                            cBranch, cTitle, cDesc, cDetail, cResponse : string ) ;

    function SendToTerminal( cBranch : string; nNewId : integer ; lRest : TdmRest ) : integer;

  end;

implementation

uses
  System.SysUtils, MVCFramework.Logger, System.StrUtils,
  uAlpeta_login;

var
  alpetaApi_UserId   : String = '99999998';
  alpetaApi_Url       : String = 'https://192.168.100.6:9004/v1';
  alpetaApi_Password  : String = 'batman20';
  alpetaApi_UserType : Integer = 0;

  alpetaDB_Server : String = '192.168.100.6' ;
  alpetaDB_user : String = 'unisuser';
  alpetaDB_password : String = 'unisamho';
  alpetaDB_database : String = 'ucdb';

  trueDB_Server : String = '192.168.100.6' ;
  trueDB_user : String = 'unisuser';
  trueDB_password : String = 'unisamho';
  trueDB_database : String = 'true_carpark';

procedure TControllerQrcode.Index;
begin
  //use Context property to access to the HTTP request and response
  Render('Hello True');

end;

procedure TControllerQrcode.GetReversedString(const Value: String);
begin
  Render(System.StrUtils.ReverseString(Value.Trim));
end;

procedure TControllerQrcode.OnAfterAction(Context: TWebContext; const AActionName: string); 
begin
  { Executed after each action }
  inherited;
end;

procedure TControllerQrcode.OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean);
begin
  { Executed before each action
    if handled is true (or an exception is raised) the actual
    action will not be called }
  inherited;
end;

//Sample CRUD Actions for a "Customer" entity
procedure TControllerQrcode.GetQrcode;
begin
end;

procedure TControllerQrcode.GetCustomer(id: Integer);
begin
  //todo: render the customer by id
end;

procedure TControllerQrcode.GetMessageTerminal( t_id: string);
var
  msg, dte : string;
  lRest : TDmRest ;
  oObj : TJSONObject;
begin

  lRest := TdmRest.create(nil);

  try
    msg := ''; dte := '';
    with lRest do
    begin
      trueQuery.Sql.Clear;
      trueQuery.Sql.Add('Select * From true_message_terminal ' +
        'Where terminal_code = ' + QuotedStr( t_id ) ) ;
      trueQuery.Active := True;
      if trueQuery.IsEmpty = True then
      begin
        msg := 'no message.....';
        dte := '';
      end
      else
      begin
        msg := trueQuery.FieldByName('terminal_message').AsString;
        dte := trueQuery.FieldByName('terminal_datetime').AsString;
      end;

    end;
  finally
    lRest.Free;
  end;

  oObj := TJSONOBject.Create;
  oOBj.AddPair('message', msg) ;
  oOBj.AddPair('datetime', dte) ;


  render ( oObj );
end;


procedure TControllerQrcode.CreateQRCode; //////////////////
var
  lRest : TdmRest;
  nResult : integer;
  Alpeta_login : TAlpeta_login;
  lRes: IMVCRESTResponse;
  jsonObj, oResult, jObj, lObj, bObj : TJSONObject;

  cOrder, cLpr, cEmpid, cCarSlot, cResult : string;

  iniFilename : string;
  iniConfig : TIniFile;
  jValue : TJSONValue ;
begin

  iniFilename := './config.ini';
  iniConfig := TIniFile.create( iniFilename ) ;
  alpetaDB_Server   := iniConfig.ReadString('Alpeta DB', 'server'     ,'192.168.100.6');
  alpetaDB_database := iniConfig.ReadString('Alpeta DB', 'database'   ,'ucdb');
  alpetaDB_user     := iniConfig.ReadString('Alpeta DB', 'user'       ,'unisuser');
  alpetaDB_password := iniConfig.ReadString('Alpeta DB', 'password'   ,'unisamho');
  iniConfig.Free;

  lRest := TdmRest.create(nil);

  try

    Alpeta_login := TAlpeta_login.Create;

    Alpeta_login.UserId   := alpetaApi_UserId;
    Alpeta_login.Password := alpetaApi_Password;
    Alpeta_login.UserType := alpetaApi_UserType;

    with lRest do
    begin
      FRESTClient := TMVCRESTClient.new.BaseURL( alpetaApi_Url );
      lRes := FRESTClient.Post('/login',Alpeta_login,False);
    end;

    jsonObj := TJSONObject.ParseJSONValue(lRes.Content) as TJSONObject;

    oResult := jsonObj.GetValue('Result') as TJSONObject;
    nResult := oResult.GetValue('ResultCode').Value.ToInteger ;

    if (nResult = 0) then
    begin

//      lObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Context.Request.Body),0) as TJSONObject;
      lObj := TJSONObject.ParseJSONValue(Context.Request.Body) as TJSONObject;
      cOrder   := lObj.GetValue('Job Order'  ).Value;
      cEmpid   := lObj.GetValue('Employee ID').Value;


      with lRest do
      begin

        FDQuery.Sql.Clear;
        FDQuery.SQL.Text := 'Select * From users where unique_id = ' + QuotedStr(cOrder) ;
        FDQuery.Active := True;
        if FDQuery.IsEmpty = False then
        begin
          OrderResponse( bObj, 2, -1, 'Order Duplicate.', lObj);
          Render( bObj.ToString );
          exit;
        end
        else
        begin
          cResult := AlpetaInsert( lRest, lObj ) ;
          render ( cResult ) ;
        end;
      end;  // with lRest
    end
    else
    begin
      render(jsonObj) ;
    end;

  finally
    lRest.Free;
  end;
end;

function TControllerQrcode.AlpetaInsert( lRest : TdmRest; lObj : TJSONObject ) : String;
var
  nNewId, nResult, nGroupId : integer;
  cBranch, cOrder, cLpr, cEmpid, cCarSlot : string;
  jsonObj, oResult, oUserInfo, bodyObj, bObj, rObj : TJSONObject;
  lRes: IMVCRESTResponse;
  xObj : TJSONObject;
begin

  cBranch  := lObj.GetValue('Branch'     ).Value;
  cOrder   := lObj.GetValue('Job Order'  ).Value;
  cLpr     := lObj.GetValue('License'    ).Value;
  cEmpid   := lObj.GetValue('Employee ID').Value;
  cCarSlot := lObj.GetValue('Car Slot'   ).Value;


  with lRest do
  begin
//
//    FDQuery.Sql.Clear;
//    FDQuery.Sql.Add('Select * From users where unique_id = ' + QuotedStr(cEmpid) ) ;
//    FDQuery.Active := True;
//    if FDQuery.IsEmpty then
//    begin
//      result := 'ไม่พบรหัส พนักงาน นี้ ในแฟ้ม' ;
//    end
//    else
    begin

      lRes := FRESTClient.Get('/users/initUserInfo');
      jsonObj := TJSONObject.ParseJSONValue(lRes.Content) as TJSONObject;

      oResult   := jsonObj.GetValue('Result') as TJSONObject;
      oUserInfo := jsonObj.GetValue('dmUserInfo') as TJSONObject;
      nResult := oResult.GetValue('ResultCode').Value.ToInteger ;

      if nResult <> 0 then
      begin
        result := ( oResult.ToString ) ;
      end
      else
      begin
        nNewId := oUserInfo.GetValue('ID').Value.ToInteger ;

        FDQuery.Sql.Clear;
        FDQuery.SQL.Text := 'Select * From groups where name = ' + QuotedStr(cBranch) ;
        FDQuery.Active := True;
        if FDQuery.IsEmpty = True then
        begin
          result :=  'ไม่มี Group นี้. ' ;
          exit;
        end
        else
        begin
          nGroupId := FDQuery.FieldByName('group_id').AsInteger;
        end;


        bodyObj := TJSONObject.Create;
        bodyObj := bodyNewQRCode( nNewId, lObj, nGroupId ) ;

        lRes := FRESTClient.Post('/users?UserID=' + IntToStr(nNewId), bodyObj.ToString, 'application/json');

        jsonObj := TJSONObject.ParseJSONValue(lRes.Content) as TJSONObject;
        oResult   := jsonObj.GetValue('Result') as TJSONObject;
        nResult   := oResult.GetValue('ResultCode').Value.ToInteger ;

        if nResult = 0 then
        begin
          // Insert Complete

          SaveOrderlog( lRest, cBranch, 'Job order', 'Alpeta Created', lObj.ToString, 'Complete'  ) ;

          ////////////////////////
          ///
          //  Send to Terminal
          ///

          SendToTerminal( cBranch, nNewId, lRest ) ;

          OrderResponse( bObj, 0, nNewId, 'Created complete.', lObj);
          result := ( bObj.ToString ) ;
        end
        else
        begin
          // Not Complete
          OrderResponse( bObj, 116548, -1, 'Created not complete.', lObj);
          result := ( bObj.ToString ) ;
        end;

      end;

    end;
  end;

end;


function TControllerQrcode.SendToTerminal( cBranch : string; nNewId : integer ; lRest : TdmRest ) : integer;
var
  bObj, rObj : TJSONObject;
  lRes: IMVCRESTResponse;
  cReq : string;
  nTerminal : integer;
begin
  bObj := TJSONObject.Create;
  rObj := TJSONObject.Create;
  rObj.AddPair(TJSONPair.Create('Total' , TJSONNumber.Create(1)));
  rObj.AddPair(TJSONPair.Create('Offset', TJSONNumber.Create(1)));
  bObj.AddPair( TJSONPair.Create('DownloadInfo',rObj)) ;
  with lRest do
  begin
    trueQuery.Sql.Clear;
    trueQuery.Sql.Add('Select * From true_terminal_carpark ' +
      'where branch = ' + QuotedStr(cBranch) ) ;
    trueQuery.Open ;
    while not trueQuery.Eof do
    begin
      cReq := '/terminals/' + trueQuery.FieldByName('terminal_id').AsString +
              '/users/'     + IntToStr(nNewId) ;

      lRes := FRESTClient.Post( cReq ,bObj.ToString, 'application/json');
      trueQuery.Next ;
    end;
  end;

  writeln( bObj.ToString ) ;
  result := 0 ;


end;

procedure TControllerQrcode.SaveOrderLog(lRest : TdmRest;
                                         cBranch, cTitle, cDesc, cDetail, cResponse : string ) ;
begin
  with lRest do
  begin
    trueQuery.Sql.Clear;
    trueQuery.Sql.Add('Insert into true_logs ' +
      '( log_branch, log_title, log_desc, log_detail, log_created, log_response ) ' +
      'Values ' +
      '(:log_branch,:log_title,:log_desc,:log_detail,:log_created,:log_response ) ');
    trueQuery.ParamByName('log_branch' ).AsString := cBranch;
    trueQuery.ParamByName('log_desc'   ).AsString := cDesc;
    trueQuery.ParamByName('log_title'  ).AsString := cTitle;
    trueQuery.ParamByName('log_detail' ).AsString := cDetail;
    trueQuery.ParamByName('log_created').AsDateTime := now;
    trueQuery.ParamByName('log_response' ).AsString := cResponse;
    trueQuery.ExecSQL;
  end;
end;

procedure TControllerQrCode.OrderResponse( var bObj : TJsonObject;
                                           nResult, nNewId : Integer;
                                           cDesc : String;
                                           lObj : TJSONObject ) ;
var
  rObj : TJSONObject ;
begin

  bObj := TJSONObject.Create;

  rObj := TJSONObject.Create;
  rObj.AddPair(TJSONPair.Create('ResultCode' , TJSONNumber.Create(nResult)));
  rObj.AddPair(TJSONPair.Create('Description',cDesc)) ;

  bObj.AddPair( TJSONPair.Create('Result',rObj)) ;

  if nResult = 0 then
  begin
    rObj := TJSONObject.Create;
    rObj.AddPair(TJSONPair.Create('Id'   ,   TJSONNumber.Create(nNewid)));
    rObj.AddPair(TJSONPair.Create('Branch',  lObj.GetValue('Branch'   ).Value));
    rObj.AddPair(TJSONPair.Create('Order' ,  lObj.GetValue('Job Order').Value));
    rObj.AddPair(TJSONPair.Create('License', lObj.GetValue('License' ).Value));
    rObj.AddPair(TJSONPair.Create('Car-Slot',lObj.GetValue('Car Slot' ).Value));

    bObj.AddPair( TJSONPair.Create('Data',rObj)) ;
  end;

end;



procedure TControllerQrcode.UpdateCustomer(id: Integer);
begin
  //todo: update customer by id
end;

procedure TControllerQrcode.DeleteCustomer(id: Integer);
begin
  //todo: delete customer by id
end;

function TControllerQrcode.bodyNewQRCode( nId  : integer;
                                          lObj : TJSONOBject;
                                          nGroupId : Integer) : TJSONObject ;
var
  bodyJSON, oUserInfo, jso : TJSONObject;
  aAuthInfo, aDuressFinger, aUserFPInfo, aUserFaceInfo, aUserCardinfo, aUserFaceWTInfo, aUserIrisInfo : TJSONArray;

  cId : String;
  createDate, registerDate, expireDate, cPicture : string;
  cBranch, cOrder, cLpr, cEmpid, cCarSlot : string;
begin

  cId := IntToStr(nId);

  cBranch  := lObj.GetValue('Branch'     ).Value;
  cOrder   := lObj.GetValue('Job Order'  ).Value;
  cLpr     := lObj.GetValue('License'    ).Value;
  cEmpid   := lObj.GetValue('Employee ID').Value;
  cCarSlot := lObj.GetValue('Car Slot'   ).Value;



  createDate   := FormatDateTime('YYYY-MM-DD HH:MM:SS', now);
  registerDate := createDate;
  expireDate   := createDate;

  bodyJSON := TJSONObject.Create;

  oUserinfo := TJSONObject.Create;
  oUserinfo.AddPair(TJSONPair.Create('ID'       , cId    ));
  oUserinfo.AddPair(TJSONPair.Create('UniqueID' , cOrder));
  oUserinfo.AddPair(TJSONPair.Create('Name'     , cLpr  ));

  aAuthInfo := TJSONArray.Create;
  aAuthInfo.Add(30);  //30-Student id  , 3-password
  aAuthInfo.Add(0);
  aAuthInfo.Add(0);
  aAuthInfo.Add(0);
  aAuthInfo.Add(0);
  aAuthInfo.Add(0);
  aAuthInfo.Add(0);
  aAuthInfo.Add(0);
  oUserInfo.AddPair(TJSONPair.Create('AuthInfo'    ,aAuthInfo)) ;

  oUserInfo.AddPair(TJSONPair.Create('Privilege'    , TJSONNumber.Create(2)   )) ;
  oUserInfo.AddPair(TJSONPair.Create('CreateDate'   , createDate )) ;
  oUserInfo.AddPair(TJSONPair.Create('UsePeriodFlag', TJSONNumber.Create(0)  ));
  oUserInfo.AddPair(TJSONPair.Create('RegistDate'   , registerDate  )) ;
  oUserInfo.AddPair(TJSONPair.Create('ExpireDate'   , expireDate  )) ;
  oUserInfo.AddPair(TJSONPair.Create('Password'     , '1234'  )) ;
  oUserInfo.AddPair(TJSONPair.Create('GroupCode'    , TJSONNumber.Create(nGroupId)  ));

  oUserInfo.AddPair(TJSONPair.Create('AccessGroupCode',TJSONNumber.Create(0)  ));
  oUserInfo.AddPair(TJSONPair.Create('UserType'       ,TJSONNumber.Create(0)  ));
  oUserInfo.AddPair(TJSONPair.Create('TimezoneCode'   ,TJSONNumber.Create(0)  ));
  oUserInfo.AddPair(TJSONPair.Create('BlackList'      ,TJSONNumber.Create(0)  ));
  oUserInfo.AddPair(TJSONPair.Create('FPIdentify'     ,TJSONNumber.Create(0)  ));
  oUserInfo.AddPair(TJSONPair.Create('FaceIdentify'   ,TJSONNumber.Create(0)  ));

  aDuressFinger := TJSONArray.Create;
  aDuressFinger.Add(1);
  aDuressFinger.Add(2);
  aDuressFinger.Add(3);
  oUserInfo.AddPair(TJSONPair.Create('DuressFinger'  ,aDuressFinger)) ;

  oUserInfo.AddPair(TJSONPair.Create('Partition'   ,TJSONNumber.Create(0)  ));
  oUserInfo.AddPair(TJSONPair.Create('APBExcept'   ,TJSONNumber.Create(0)  ));
  oUserInfo.AddPair(TJSONPair.Create('APBZone'     ,TJSONNumber.Create(0)  ));
  oUserInfo.AddPair(TJSONPair.Create('WorkCode'    , '****'  )) ;
  oUserInfo.AddPair(TJSONPair.Create('MealCode'    , '****'  )) ;
  oUserInfo.AddPair(TJSONPair.Create('MoneyCode'   , '****'  )) ;
  oUserInfo.AddPair(TJSONPair.Create('MessageCode' ,TJSONNumber.Create(0)  ));
  oUserInfo.AddPair(TJSONPair.Create('VerifyLevel' ,TJSONNumber.Create(5)  ));
  oUserInfo.AddPair(TJSONPair.Create('PositionCode',TJSONNumber.Create(1000)  ));
  oUserInfo.AddPair(TJSONPair.Create('Department'    , cCarSlot  )) ;
  oUserInfo.AddPair(TJSONPair.Create('LoginPW'    , '1234'  )) ;
  oUserInfo.AddPair(TJSONPair.Create('LoginAllowed',TJSONNumber.Create(1)  ));
  oUserInfo.AddPair(TJSONPair.Create('Picture'    , ''  )) ;
  oUserInfo.AddPair(TJSONPair.Create('EmployeeNum'    , ''  )) ;
  oUserInfo.AddPair(TJSONPair.Create('Email'    , ''  )) ;
  oUserInfo.AddPair(TJSONPair.Create('Phone'    , ''  )) ;


  bodyJSON.AddPair( TJSONPair.Create('UserInfo',oUserInfo)) ;

// UserFPInfo

  aUserFPInfo := TJSONArray.Create;
  bodyJSON.AddPair( TJSONPair.Create('UserFPInfo',aUserFPInfo)) ;

    jso := TJsonObject.Create();
    jso.AddPair(TJSONPair.Create('FingerID'     , TJSONNumber.Create(nId)));
    jso.AddPair(TJSONPair.Create('MinConvType'  , TJSONNumber.Create(3)));
    jso.AddPair(TJSONPair.Create('TemplateIndex', TJSONNumber.Create(1)));
    jso.AddPair(TJSONPair.Create('TemplateData' , ''));
    aUserFPInfo.AddElement(jso);

    jso := TJsonObject.Create();
    jso.AddPair(TJSONPair.Create('FingerID'     , TJSONNumber.Create(nId)));
    jso.AddPair(TJSONPair.Create('MinConvType'  , TJSONNumber.Create(3)));
    jso.AddPair(TJSONPair.Create('TemplateIndex', TJSONNumber.Create(2)));
    jso.AddPair(TJSONPair.Create('TemplateData' , ''));
    aUserFPInfo.AddElement(jso);

// UserFaceinfo
  aUserFaceinfo := TJSONArray.Create;
  bodyJSON.AddPair( TJSONPair.Create('UserFaceInfo',aUserFaceinfo)) ;

    jso := TJsonObject.Create();
    jso.AddPair(TJSONPair.Create('UserID'       , TJSONNumber.Create(nId)));
    jso.AddPair(TJSONPair.Create('Index'        , TJSONNumber.Create(1)));
    jso.AddPair(TJSONPair.Create('Type'         , TJSONNumber.Create(0)));
    jso.AddPair(TJSONPair.Create('SubIndex'     , TJSONNumber.Create(1)));
    jso.AddPair(TJSONPair.Create('TemplateSize' , TJSONNumber.Create(0)));
    jso.AddPair(TJSONPair.Create('TemplateData' , ''));
    aUserFaceinfo.AddElement(jso);

    jso := TJsonObject.Create();
    jso.AddPair(TJSONPair.Create('UserID'       , TJSONNumber.Create(nId)));
    jso.AddPair(TJSONPair.Create('Index'        , TJSONNumber.Create(1)));
    jso.AddPair(TJSONPair.Create('Type'         , TJSONNumber.Create(0)));
    jso.AddPair(TJSONPair.Create('SubIndex'     , TJSONNumber.Create(2)));
    jso.AddPair(TJSONPair.Create('TemplateSize' , TJSONNumber.Create(0)));
    jso.AddPair(TJSONPair.Create('TemplateData' , ''));
    aUserFaceinfo.AddElement(jso);

    jso := TJsonObject.Create();
    jso.AddPair(TJSONPair.Create('UserID'       , TJSONNumber.Create(nId)));
    jso.AddPair(TJSONPair.Create('Index'        , TJSONNumber.Create(1)));
    jso.AddPair(TJSONPair.Create('Type'         , TJSONNumber.Create(0)));
    jso.AddPair(TJSONPair.Create('SubIndex'     , TJSONNumber.Create(3)));
    jso.AddPair(TJSONPair.Create('TemplateSize' , TJSONNumber.Create(0)));
    jso.AddPair(TJSONPair.Create('TemplateData' , ''));
    aUserFaceinfo.AddElement(jso);


    jso := TJsonObject.Create();
    jso.AddPair(TJSONPair.Create('UserID'       , TJSONNumber.Create(nId)));
    jso.AddPair(TJSONPair.Create('Index'        , TJSONNumber.Create(1)));
    jso.AddPair(TJSONPair.Create('Type'         , TJSONNumber.Create(0)));
    jso.AddPair(TJSONPair.Create('SubIndex'     , TJSONNumber.Create(4)));
    jso.AddPair(TJSONPair.Create('TemplateSize' , TJSONNumber.Create(0)));
    jso.AddPair(TJSONPair.Create('TemplateData' , ''));
    aUserFaceinfo.AddElement(jso);

    jso := TJsonObject.Create();
    jso.AddPair(TJSONPair.Create('UserID'       , TJSONNumber.Create(nId)));
    jso.AddPair(TJSONPair.Create('Index'        , TJSONNumber.Create(1)));
    jso.AddPair(TJSONPair.Create('Type'         , TJSONNumber.Create(0)));
    jso.AddPair(TJSONPair.Create('SubIndex'     , TJSONNumber.Create(5)));
    jso.AddPair(TJSONPair.Create('TemplateSize' , TJSONNumber.Create(0)));
    jso.AddPair(TJSONPair.Create('TemplateData' , ''));
    aUserFaceinfo.AddElement(jso);

// UserCardInfo
  aUserCardInfo := TJSONArray.Create;
  bodyJSON.AddPair( TJSONPair.Create('UserCardInfo',aUserCardInfo)) ;

    jso := TJsonObject.Create();
    jso.AddPair(TJSONPair.Create('CardNum' , ''));
    aUserCardInfo.AddElement(jso);

// UserFaceWTInfo

  cPicture := '' ; //Base64_Encoding( 'C:\27102021\Ums\ums018_.jpg' );


  aUserFaceWTInfo:= TJSONArray.Create;
  bodyJSON.AddPair( TJSONPair.Create('UserFaceWTInfo',aUserFaceWTInfo)) ;

    jso := TJsonObject.Create();
    jso.AddPair(TJSONPair.Create('UserID'       , TJSONNumber.Create(nId)));
    jso.AddPair(TJSONPair.Create('TemplateType' , TJSONNumber.Create(0)));
    jso.AddPair(TJSONPair.Create('TemplateSize' , TJSONNumber.Create(Length(cPicture))));
    jso.AddPair(TJSONPair.Create('TemplateData' , cPicture));
    aUserFaceWTInfo.AddElement(jso);


// UserIrisInfo
  aUserIrisInfo := TJSONArray.Create;
  bodyJSON.AddPair( TJSONPair.Create('UserIrisInfo',aUserIrisInfo)) ;

    jso := TJsonObject.Create();
    jso.AddPair(TJSONPair.Create('UserID'       , TJSONNumber.Create(nId)));
    jso.AddPair(TJSONPair.Create('EyeType'      , TJSONNumber.Create(1)));
    jso.AddPair(TJSONPair.Create('TemplateSize' , TJSONNumber.Create(1)));
    jso.AddPair(TJSONPair.Create('TemplateData' , ''));
    aUserIrisInfo.AddElement(jso);
  result := bodyJSON ;
end;




end.
