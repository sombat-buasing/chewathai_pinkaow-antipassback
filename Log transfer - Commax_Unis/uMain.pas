unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Buttons,
  IdSSLOpenSSL, System.JSON,
  Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, MemDS, DBAccess, Uni, IniFiles,
  uniGUIBaseClasses, uniGUIClasses, uniMemo, IPPeerClient, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, REST.JSON, REST.Types,
  StrUtils, System.Threading;

type
  TfrmMain = class(TForm)
    ProgressBar1: TProgressBar;
    edDateTime: TEdit;
    Edit1: TEdit;
    DBGrid1: TDBGrid;
    Timer1: TTimer;
    cmxFind: TUniQuery;
    bacFind: TUniQuery;
    bacDisplay: TUniQuery;
    dsBacDisplay: TUniDataSource;
    GroupBox1: TGroupBox;
    btnStart: TBitBtn;
    btnStop: TBitBtn;
    btnCommaxLogs: TBitBtn;
    btnDisp_log: TBitBtn;
    btnAlpeta_logs: TBitBtn;
    btnUnis_logs: TBitBtn;
    unisFind: TUniQuery;
    btnGete_in: TBitBtn;
    btnGate_out: TBitBtn;
    qryFind: TUniQuery;
    qryTemp: TUniQuery;
    cbGate_status: TComboBox;
    Label1: TLabel;
    btnSetup: TBitBtn;
    cbRemark: TComboBox;
    Label2: TLabel;
    Timer3: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnCommaxLogsClick(Sender: TObject);
    procedure btnDisp_logClick(Sender: TObject);
    procedure btnAlpeta_logsClick(Sender: TObject);
    procedure btnUnis_logsClick(Sender: TObject);
    procedure btnGete_inClick(Sender: TObject);
    procedure btnGate_outClick(Sender: TObject);
    procedure btnSetupClick(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
//    fJSONArray : TJSONArray;
//    function Alpeta_login( userid, userPassword, userType : string ) : boolean ;
//    function GetLogsCount(cFirst, cLast : string): integer;
//    procedure SaveLogs2TEnter(cFirst, cLast : string;
//                                       nCount : integer);
  public
    { Public declarations }
    procedure CommaxLogs( var bData : boolean ) ;
    procedure UnisLogs  ( Var bData : boolean );
    procedure Disp_logs;
    procedure BoardOpen( cInOut, cStatus : string );
    procedure BoardOpen_Task( cInOut, cStatus : string );
    function Antipassback_inout(cDate, cTime, cCardtype, cIPAddress, cBuilding, cRoom : string) : string ;
    procedure FormData( cGate, cRoom, cDate, cTime, cStatus, cRemark : string );
    procedure ShowPopup( maxShow : integer );
    procedure DeleteForm( frmName : string ) ;

  end;

var
  frmMain: TfrmMain;
  nProgress : integer = 0 ;
  cmxDateTime : string = '';
  unsDateTime : string = '';
  aptDateTime : string = '';
  iniFilename : string = '';
  iniBuilding : string = '';
  iniConfig : TIniFile;
  alpeta_URL  : string = 'http://10.0.0.5:9004/v1';
  haveData, autoStart : boolean;

  unisTerminal, msgLimit, msgInhouse : string;

  baseURL_API : string;
  gateIn_ip, gateout_ip : string;
  gateIn_port, gateOut_port : integer;

  maxForm, nMaxShow : integer;

  arrGate         : array[1..4] of string;
  arrDateTime     : array[1..4] of string;
  arrRoom_name    : array[1..4] of string;
  arrStatus, arrRemark    : array[1..4] of string;
  arrTime         : array[1..4] of TTime ;
  maxMin : integer = 60;

const
  frmWidth : integer = 200;
  frmHeight : integer = 140;


implementation

{$R *.dfm}

uses uData, uFunction, uRestfull,
  MVCFramework.RESTClient,
  MVCFramework.RESTClient.Intf, uSetup, uAlarm, uAlarm1, uForm1;


function TfrmMain.Antipassback_inout(cDate, cTime, cCardtype, cIPAddress, cBuilding, cRoom: string): string;
var
  cInOut, cResult, cType, cStatus, cHomeno : string;
  isAdmin : boolean;
  nLimit, nInHouse, nUpd, nResult : integer;
  lRes: IMVCRESTResponse;
  FRestClient: IMVCRESTClient;
  oBody, oResult, oResponse, oDetail : TJSONObject;

begin
  cResult := '';
  qryFind.Sql.Clear;
  qryFind.Sql.Add('Select * from zmx_ipaddress ' +
    'Where cm_ipaddress = ' + QuotedStr(cIPAddress) ) ;
  qryFind.Active := True;
  if qryFind.IsEmpty = True then
  begin
    cResult := 'Not found ip-address.';
    result := cResult ;
    exit;
  end;

  cInOut := '';
  if qryFind.FieldByName('cm_type').AsString = 'carpark-in'  then cInOut := 'IN';
  if qryFind.FieldByName('cm_type').AsString = 'carpark-out' then cInOut := 'OUT';
  if cInOut = '' then
  begin
    cResult := 'invalid type. (' + qryFind.FieldByName('cm_type').AsString + ')';
    exit;
  end;

////////
///

  cType := LeftStr(qryFind.FieldByName('cm_type').AsString,7);
  cHomeno := cBuilding + '/' + cRoom ;

  isAdmin := False;
  if (cRoom = '999') then isAdmin := True;

//  if (StrToIntDef(cRoom,0) >= 906) or (StrToIntDef(cRoom,0) <= 924) then  isAdmin := True;

  if (cType = 'carpark')  then
  begin

    if isAdmin = True then   // Admin
    begin   //
      cStatus  := 'Success' ;
      cResult  := 'By Admin ' + cRoom ;
    end
    else
    begin
      oBody := TJsonObject.Create;
      oBody.AddPair(TJSONPair.Create('Room',cHomeno)) ;

      FRestClient := TMVCRESTClient.new.BaseURL( baseURL_API );
      lRes := FRestClient.Post('/carpark', oBody.ToString, 'application/json');

      oResponse := TJSONObject.ParseJSONValue(lRes.Content) as TJSONObject;

      oResult := oResponse.GetValue('Result') as TJSONObject;
      nResult := oResult.GetValue('ResultCode').Value.ToInteger ;

      oDetail := oResponse.GetValue('Detail') as TJSONObject;

      if nResult = 1 then
      begin
        cStatus := 'Fail' ;
        cResult := '( Not Member )'
      end;

      if nResult = 0 then
      begin
        nLimit   := oDetail.GetValue<Integer>('Car Limit'); //  qryTemp.FieldByName('cm_car_limit').AsInteger;
        nInHouse := oDetail.GetValue<Integer>('Car Count'); // qryTemp.FieldByName('cm_car_count').AsInteger;

        //////  OUT
        if cInOut = 'OUT' then
        begin
          cStatus := 'Success' ;
          cResult := '(' + msgLimit   + ' = ' + IntTostr(nLimit) + ', ' +
                           msgInHouse + ' = ' + IntToStr(nInHouse) + ' )' ;
        end;

        //////  IN
        if cInOut = 'IN' then
        begin
          if nInHouse < nLimit then
          begin
            cStatus := 'Success' ;
          cResult := '(' + msgLimit   + ' = ' + IntTostr(nLimit) + ', ' +
                           msgInHouse + ' = ' + IntToStr(nInHouse) + ' )' ;
          end
          else
          begin
            cStatus := 'Fail';
            cResult := '(' + msgLimit   + ' = ' + IntTostr(nLimit) + ', ' +
                             msgInHouse + ' = ' + IntToStr(nInHouse) + ' )' ;
          end;
        end;
      end;
    end;

    if cStatus = 'Success' then BoardOpen_Task(cInOut, 'Pass');
    if cStatus = 'Fail'    then BoardOpen_Task(cInOut, 'Error');

///////
///
///   Update zmx_carpark_log
///

    oBody := TJsonObject.Create;
    try
      oBody.AddPair(TJSONPair.Create('cp_date',cDate)) ;
      oBody.AddPair(TJSONPair.Create('cp_time',cTime)) ;
      oBody.AddPair(TJSONPair.Create('cp_home_no',cBuilding + '/' + cRoom)) ;
      oBody.AddPair(TJSONPair.Create('cp_card_type',cCardType)) ;
      oBody.AddPair(TJSONPair.Create('cp_ipaddress',cIPAddress)) ;
      oBody.AddPair(TJSONPair.Create('cp_status',cStatus)) ;
      oBody.AddPair(TJSONPair.Create('cp_in_out',cInOut)) ;
      oBody.AddPair(TJSONPair.Create('cp_remark',cStatus + '-' + Lowercase(cInOut) + ' ' + cResult)) ;

      FRestClient := TMVCRESTClient.new.BaseURL( baseURL_API );
      lRes := FRestClient.Post('/update_carpark_log', oBody.ToString, 'application/json');

      oResponse := TJSONObject.ParseJSONValue(lRes.Content) as TJSONObject;
    finally
      oBody.Free;
    end;

    if (isAdmin = False) then
    begin
      if (cInout = 'IN') and (cStatus = 'Success') then
      begin

        oBody := TJsonObject.Create;
        try
          oBody.AddPair(TJSONPair.Create('cp_home_no',cBuilding + '/' + cRoom)) ;
          oBody.AddPair(TJSONPair.Create('cm_car_count',TJSONNumber.Create( nInHouse + 1))) ;

          FRestClient := TMVCRESTClient.new.BaseURL( baseURL_API );
          lRes := FRestClient.Post('/update_carpark_member', oBody.ToString, 'application/json');

          oResponse := TJSONObject.ParseJSONValue(lRes.Content) as TJSONObject;
        finally
          oBody.Free;
        end;

        cResult := '( ' + msgLimit   + ' = ' + IntTostr(nLimit) + ', ' +
                          msgInHouse + ' = ' + IntToStr(nInHouse + 1) + ' )' ;
      end;
      if cInout = 'OUT' then
      begin
        if nInHouse > 0 then nUpd := nInhouse -  1
                        else nUpd := 0;

        oBody := TJsonObject.Create;
        try
          oBody.AddPair(TJSONPair.Create('cp_home_no',cBuilding + '/' + cRoom)) ;
          oBody.AddPair(TJSONPair.Create('cm_car_count',TJSONNumber.Create( nUpd ))) ;

          FRestClient := TMVCRESTClient.new.BaseURL( baseURL_API );
          lRes := FRestClient.Post('/update_carpark_member', oBody.ToString, 'application/json');

          oResponse := TJSONObject.ParseJSONValue(lRes.Content) as TJSONObject;
        finally
          oBody.Free;
        end;

        cResult := '( ' + msgLimit   + ' = ' + IntTostr(nLimit) + ', ' +
                          msgInHouse + ' = ' + IntToStr(nUpd  ) + ' )' ;

      end;
    end;

    FormData( cInOut, cHomeno, cDate, cTime, cStatus, cResult ) ;


  end;

  result := cResult ;
end;

procedure TfrmMain.btnAlpeta_logsClick(Sender: TObject);
var
  nCount : integer;
  cFirst, cLast : string ;
begin

end;


procedure TfrmMain.btnCommaxLogsClick(Sender: TObject);
begin
  haveData := False;
  CommaxLogs( haveData ) ;
  if haveData = True then disp_logs;
end;


procedure TfrmMain.CommaxLogs( var bData : boolean ) ;
var
  cmType, cmDate, cmTime , cmIPAddress, cmBuilding, cmRoom : string;
  cmHome_no, cmMember_name : string ;
  wDate : TDateTime;
  cAntipassback_result : string;
begin
  cmxFind.Sql.Clear;
  cmxFind.Sql.Add('Select type, ip, d_name, h_ho, wdate ' +
    'From view_entrance_log_bac ' );
  if cmxDateTime <> Emptystr then
  begin
    cmxFind.SQL.Add('Where wdate > ' + QuotedStr(cmxDateTime) + ' ' );
  end;

  cmxFind.SQL.Add('Order by wdate asc ' );
  cmxFind.Active  := True;

  while not cmxFind.Eof do
  begin
    cmType      := cmxFind.FieldByName('type').AsString;
    cmIPAddress := cmxFind.FieldByName('ip').AsString;
    cmBuilding  := cmxFind.FieldByName('d_name').AsString;
    cmRoom      := FormatFloat('000',StrToIntDef( Trim(cmxFind.FieldByName('h_ho').AsString),0 ));

    wDate := cmxFind.FieldByName('wdate').AsDateTime;
    cmDate      := FormatDateTime('YYYYMMDD',wDate);
    cmTime      := FormatDateTime('HHMMSS'  ,wDate);
    cmxDateTime := FormatDateTime('YYYY-MM-DD',wDate) + ' ' + FormatDateTime('HH:MM:SS',wDate) ;

    cmHome_no := cmBuilding + '/' + cmRoom ;
    cmMember_name := '' ;

    if not ( (cmBuilding = Emptystr) or (Copy(cmRoom,1,3) = '999') or
             (cmRoom = '000')  ) then
    begin
      bacFind.SQL.Clear;
      bacFind.SQL.Add('Select * From zmx_member ' +
        'Where cm_home_no = :home_no ' );
      bacFind.ParamByName('home_no' ).AsString := cmHome_no;
      bacFind.Active := True;
      if bacFind.IsEmpty = True then
      begin
        bacFind.SQL.Clear;
        bacFind.SQL.Add('Insert into zmx_member ' +
          '( cm_home_no, cm_member_name  ) Values ( :home_no, :mname  ) ');
        bacFind.ParamByName('home_no').AsString := cmHome_no;
        bacFind.ParamByName('mname'  ).AsString := cmMember_name;
        bacFind.Execsql;
      end;
    end;


//    if not ((cmBuilding = Emptystr) or (cmRoom = '000')) then
    if (cmRoom <>  Emptystr) then
    begin
      bacFind.SQL.Clear;
      bacFind.SQL.Add('Select * From zmx_transaction ' +
        'Where cm_type = :type and cm_ipaddress = :ipaddress and cm_building = :building ' +
         ' and cm_room = :room and cm_date      = :date      and cm_time     = :time ' +
         ' and cm_brand = :brand ' );
      bacFind.ParamByName('type'      ).AsString := cmType;
      bacFind.ParamByName('ipaddress' ).AsString := cmIPAddress;
      bacFind.ParamByName('building'  ).AsString := cmBuilding;
      bacFind.ParamByName('room'      ).AsString := cmRoom;
      bacFind.ParamByName('date'      ).AsString := cmDate;
      bacFind.ParamByName('time'      ).AsString := cmTime;
      bacFind.ParamByName('brand'     ).AsString := 'Commax';
      bacFind.Active := True;

      if bacFind.IsEmpty = True then
      begin

        cAntipassback_result := Antipassback_inout(cmDate, cmTime, 'Commax', cmIPAddress, cmBuilding, cmRoom) ;

        bacFind.SQL.Clear;
        bacFind.SQL.Add('Insert into zmx_transaction ' +
          '( cm_type, cm_ipaddress, cm_building, cm_room, cm_date, cm_time, cm_brand, cm_remark ) ' +
          'Values ' +
          '(:type, :ipaddress, :building, :room, :date, :time, :brand, :remk ) ' );
        bacFind.ParamByName('type'      ).AsString := cmType;
        bacFind.ParamByName('ipaddress' ).AsString := cmIPAddress;
        bacFind.ParamByName('building'  ).AsString := cmBuilding;
        bacFind.ParamByName('room'      ).AsString := cmRoom;
        bacFind.ParamByName('date'      ).AsString := cmDate;
        bacFind.ParamByName('time'      ).AsString := cmTime;
        bacFind.ParamByName('remk'      ).AsString := cAntipassback_result;
        bacFind.ParamByName('brand'     ).AsString := 'Commax';
        bacFind.ExecSQL ;
        haveData := True;
      end;

      cmHome_no := cmBuilding + '/' + cmRoom ;
      cmMember_name := '' ;

      if not ( (cmBuilding = Emptystr) or (Copy(cmRoom,1,3) = '999') or
               (cmRoom = '000')  ) then
      begin
        bacFind.SQL.Clear;
        bacFind.SQL.Add('Select * From zmx_member ' +
          'Where cm_home_no = :home_no ' );
        bacFind.ParamByName('home_no' ).AsString := cmHome_no;
        bacFind.Active := True;
        if bacFind.IsEmpty = True then
        begin
          bacFind.SQL.Clear;
          bacFind.SQL.Add('Insert into zmx_member ' +
            '( cm_home_no, cm_member_name  ) Values ( :home_no, :mname  ) ');
          bacFind.ParamByName('home_no').AsString := cmHome_no;
          bacFind.ParamByName('mname'  ).AsString := cmMember_name;
          bacFind.Execsql;
        end;
      end;

    end;

    cmxFind.Next;
  end;
end;

procedure TfrmMain.btnDisp_logClick(Sender: TObject);
begin
  disp_logs;
end;

procedure TfrmMain.btnGate_outClick(Sender: TObject);
begin
  BoardOpen_Task('OUT',cbGate_status.Text);
end;

procedure TfrmMain.btnGete_inClick(Sender: TObject);
var
  cDate, cTime, cStatus, cRemark : String;
begin
  BoardOpen_Task('IN',cbGate_status.Text);

  cDate := FormatDateTime('YYYYMMDD', now) ;
  cTime := FormatDateTime('HHMMSS', now);

  if cbGate_status.Text = 'Pass' then cStatus := 'Success';
  if cbGate_status.Text = 'Error' then cStatus := 'Fail';

  cRemark := cbRemark.Text;

  FormData('IN','ROOM No', cDate, cTime, cStatus, cRemark ) ;

end;


procedure TfrmMain.BoardOpen_Task( cInOut, cStatus : string );
var
 aTask: ITask;

var
  lRest : TdmRest;
  oObj : TJSONObject;
  gateIPAddress : string;
  gatePort : integer;

begin
  if cInout = 'IN'  then
  begin
    gateIPAddress := gateIn_ip;
    gatePort := gateIn_port;
  end;

  if cInOut = 'OUT' then
  begin
    gateIPAddress := gateout_ip;
    gatePort := gateOut_port;
  end;

  oObj := TJSONObject.Create;
  oObj.AddPair(TJSONPair.Create('ipaddress', gateIPAddress));
  oObj.AddPair(TJSONPair.Create('port',TJSONNumber.Create(gatePort)));
  oObj.AddPair(TJSONPair.Create('status',cStatus));

  lRest := TdmRest.Create(self);
  try
  with lRest do
  begin
    RESTClient.BaseURL := baseURL_API;
    RESTRequest.Resource := 'board_on_off';
    RESTRequest.Method   := rmPOST;
    RESTRequest.Response := RESTResponse;

    RESTRequest.Params.Clear;
    with RESTRequest.Params.AddItem do
    begin
      ContentType := ctAPPLICATION_JSON ;
      Options := [poDoNotEncode]  ;
      name  := 'body';
      value := oObj.ToString;
      Kind  := pkREQUESTBODY;
    end;

    RESTRequest.Execute;

  end;
  finally
    lRest.Free;
  end;
end;



procedure TfrmMain.FormData( cGate, cRoom, cDate, cTime, cStatus, cRemark : string );
var
  Form : TForm;
  i : integer;
  cForm, cDateTime : string;
begin

  cDateTime := Copy(cDate,7,2) + '-' + Copy(cDate,5,2) + '-' + Copy(cDate,1,4) + ' ' +
               Copy(cTime,1,2) + ':' + Copy(cTime,3,2) + ':' + Copy(cTime,5,2) ;

  if nMaxshow < maxForm then begin
    nMaxShow := nMaxShow + 1;
  end else begin
    i := 1;
    while i < maxForm do
    begin
      arrGate     [i] := arrGate     [i + 1];
      arrDateTime [i] := arrDateTime [i + 1];
      arrRoom_name[i] := arrRoom_name[i + 1];
      arrStatus   [i] := arrStatus   [i + 1];
      arrRemark   [i] := arrRemark   [i + 1];
      arrTime     [i] := arrTime     [i + 1];
      i := i + 1;
    end;
  end;

  arrGate     [nMaxShow] := cGate;
  arrDateTime [nMaxShow] := cDateTime;
  arrRoom_name[nMaxShow] := cRoom;
  arrStatus   [nMaxShow] := cStatus;
  arrRemark   [nMaxShow] := cRemark;
  arrTime     [nMaxShow] := now;

  ShowPopup( nMaxShow ) ;

  Timer3.Enabled := True;

end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  if autoStart = True  then btnStartClick(self);
end;

procedure TfrmMain.BoardOpen( cInOut, cStatus : string );
var
  lRest : TdmRest;
  oObj : TJSONObject;
  gateIPAddress : string;
  gatePort : integer;
begin

  if cInout = 'IN'  then
  begin
    gateIPAddress := gateIn_ip;
    gatePort := gateIn_port;
  end;

  if cInOut = 'OUT' then
  begin
    gateIPAddress := gateout_ip;
    gatePort := gateOut_port;
  end;

  oObj := TJSONObject.Create;
  oObj.AddPair(TJSONPair.Create('ipaddress', gateIPAddress));
  oObj.AddPair(TJSONPair.Create('port',TJSONNumber.Create(gatePort)));
  oObj.AddPair(TJSONPair.Create('status',cStatus));

  lRest := TdmRest.Create(self);
  try
  with lRest do
  begin
    RESTClient.BaseURL := baseURL_API;
    RESTRequest.Resource := 'board_on_off';
    RESTRequest.Method   := rmPOST;
    RESTRequest.Response := RESTResponse;

    RESTRequest.Params.Clear;
    with RESTRequest.Params.AddItem do
    begin
      ContentType := ctAPPLICATION_JSON ;
      Options := [poDoNotEncode]  ;
      name  := 'body';
      value := oObj.ToString;
      Kind  := pkREQUESTBODY;
    end;

    RESTRequest.Execute;

  end;
  finally
    lRest.Free;
  end;
end;

procedure TfrmMain.Disp_logs ;
var
  n : integer;
begin
  haveData := False;
  bacDisplay.Sql.Clear;
  bacDisplay.Sql.Add('Select cm_type, cm_ipaddress, cm_building, cm_room, ' +
      'Concat(Substring(cm_date,7,2),' + QuotedStr('/') +
             ',Substring(cm_date,5,2),' + QuotedStr('/') +
             ',Substring(cm_date,1,4)) as cmDate, ' +
      'Concat(Substring(cm_time,1,2),' + QuotedStr(':') +
             ',Substring(cm_time,3,2),' + QuotedStr(':') +
             ',Substring(cm_time,5,2)) as cmTime, ' +
      'Concat(cm_building,' + QuotedStr('/') + ',cm_room) as cmRoom, ' +
      'cm_brand, cm_remark ' +
    'From zmx_transaction ' +
    'Where cm_date >= ' + QuotedStr(FormatDateTime('YYYYMMDD',date)) +
     ' and cm_time <= ' + QuotedStr(FormatDateTime('HHMMSS',time)) + ' ' +
     'Order by cm_date desc, cm_time desc ' );
  bacDisplay.SQL.Add('Limit 30' );
  bacDisplay.Active  := True;

  dsBacDisplay.DataSet := bacDisplay;
  DBGrid1.DataSource := dsBacDisplay;

end;

procedure TfrmMain.btnSetupClick(Sender: TObject);
begin
  try
    Application.CreateForm(TfrmSetup, frmSetup);
    frmSetup.ShowModal;
  finally
    FreeAndNil(frmSetup);
  end;
end;

procedure TfrmMain.btnStartClick(Sender: TObject);
begin
  self.Width := 844;
  self.Height := 337;
  Disp_logs;
  timer1.Enabled := True;
end;

procedure TfrmMain.btnStopClick(Sender: TObject);
begin
  Self.Width := 982;
  Timer1.Enabled := False;
  ProgressBar1.Visible := False;
end;

procedure TfrmMain.btnUnis_logsClick(Sender: TObject);
begin
  haveData := False;
  UnisLogs( haveData ) ;
  if haveData = True then Disp_logs;
end;

procedure TfrmMain.UnisLogs;
var
  cmType, cmIPAddress, cmBuilding, cmRoom, cmDate, cmTime, cmHome_no, cmMember_name : string;
  cAntipassback_result : string;
begin

  if unsDateTime = Emptystr then
     unsDatetime := FormatDateTime('YYYYMMDD',date) + FormatDateTime('HHMMSS',now) ;


  unisFind.Sql.Clear;
  unisFind.Sql.Add('Select e.c_date, e.c_time, e.l_tid, e.l_uid, e.c_name, e.c_unique, '+
        't.c_ipaddr ' +
    'From tEnter e ' +
    'Left join tTerminal t on t.l_id = e.l_tid ' +
    'Where concat(c_date,c_time) > ' + QuotedStr( unsDatetime) +
     ' and l_tid in ' + unisTerminal );
  unisFind.Sql.Add('Order by concat(c_date, c_time) asc ' );
  unisFind.Active := True ;

//
//  memo1.lines.add( unisFind.Sql.Text ) ;

  while not unisFind.Eof do
  begin
    cmType      := 'card';
    cmIPAddress := unisFind.FieldByName('c_ipaddr').AsString;
    cmBuilding  := iniBuilding;
    cmRoom      := FormatFloat('000',StrToIntDef( RightStr(unisFind.FieldByName('c_unique').AsString,3),0 ));

    cmDate      := unisFind.FieldByName('c_date').AsString ;
    cmTime      := unisFind.FieldByName('c_time').AsString ;
    unsDateTime := cmDate + cmTime ;

    if (cmRoom <> Emptystr) then
    begin
      bacFind.SQL.Clear;
      bacFind.SQL.Add('Select * From zmx_transaction ' +
        'Where cm_type = :type and cm_ipaddress = :ipaddress and cm_building = :building ' +
         ' and cm_room = :room and cm_date      = :date      and cm_time     = :time ' +
         ' and cm_brand = :brand ' );
      bacFind.ParamByName('type'      ).AsString := cmType;
      bacFind.ParamByName('ipaddress' ).AsString := cmIPAddress;
      bacFind.ParamByName('building'  ).AsString := cmBuilding;
      bacFind.ParamByName('room'      ).AsString := cmRoom;
      bacFind.ParamByName('date'      ).AsString := cmDate;
      bacFind.ParamByName('time'      ).AsString := cmTime;
      bacFind.ParamByName('brand'     ).AsString := 'Unis';
      bacFind.Active := True;

      if bacFind.IsEmpty = True then
      begin

        cAntipassback_result := Antipassback_inout(cmDate, cmTime, 'Commax', cmIPAddress, cmBuilding, cmRoom) ;

        bacFind.SQL.Clear;
        bacFind.SQL.Add('Insert into zmx_transaction ' +
          '( cm_type, cm_ipaddress, cm_building, cm_room, cm_date, cm_time, cm_brand, cm_remark ) ' +
          'Values ' +
          '(:type, :ipaddress, :building, :room, :date, :time, :brand, :remk ) ' );
        bacFind.ParamByName('type'      ).AsString := cmType;
        bacFind.ParamByName('ipaddress' ).AsString := cmIPAddress;
        bacFind.ParamByName('building'  ).AsString := cmBuilding;
        bacFind.ParamByName('room'      ).AsString := cmRoom;
        bacFind.ParamByName('date'      ).AsString := cmDate;
        bacFind.ParamByName('time'      ).AsString := cmTime;
        bacFind.ParamByName('remk'     ).AsString := cAntipassback_result;
        bacFind.ParamByName('brand'     ).AsString := 'Unis';
        bacFind.ExecSQL ;
        haveData := True;
      end;

      cmHome_no := cmBuilding + '/' + cmRoom ;
      cmMember_name := cmHome_no ;

      if not ( (cmBuilding = Emptystr) or (Copy(cmRoom,1,3) = '999') or
               (cmRoom = '000')  ) then
      begin
        bacFind.SQL.Clear;
        bacFind.SQL.Add('Select * From zmx_member ' +
          'Where cm_home_no = :home_no ' );
        bacFind.ParamByName('home_no' ).AsString := cmHome_no;
        bacFind.Active := True;
        if bacFind.IsEmpty = True then
        begin
          bacFind.SQL.Clear;
          bacFind.SQL.Add('Insert into zmx_member ' +
            '( cm_home_no, cm_member_name  ) Values ( :home_no, :mname  ) ');
          bacFind.ParamByName('home_no').AsString := cmHome_no;
          bacFind.ParamByName('mname'  ).AsString := cmMember_name;
          bacFind.Execsql;
        end;
      end;
    end;

    unisFind.Next;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  iniDir : String ;
  nMenu, n : integer ;
  curDateTime : string;
begin

  iniDir := IncludeTrailingBackslash( ExtractFilePath(Application.ExeName) );
  iniFilename  := iniDir + 'config.ini';

//  self.Caption := 'Chewathai Anti-passback ' ;

  iniConfig := TIniFile.Create( iniFilename ) ;

  if not FileExists( iniFilename ) then
  begin
    iniConfig.WriteString('Commax','Server'  ,'192.168.100.10');
    iniConfig.WriteString('Commax','Database','db_center') ;
    iniConfig.WriteString('Commax','Username','root');
    iniConfig.WriteString('Commax','Password','linuxonchip');

    iniConfig.WriteString('BAC','Server'  ,'192.168.100.10');
    iniConfig.WriteString('BAC','Database','bac_center') ;
    iniConfig.WriteString('BAC','Username','root');
    iniConfig.WriteString('BAC','Password','linuxonchip');

    iniConfig.WriteString('Alpeta','Server'  ,'192.168.100.4');
    iniConfig.WriteString('Alpeta','Database','UCDB') ;
    iniConfig.WriteString('Alpeta','Username','unisuser');
    iniConfig.WriteString('Alpeta','Password','unisamho');

    iniConfig.WriteString('Unis','Server'  ,'192.168.100.4');
    iniConfig.WriteString('Unis','Database','unis') ;
    iniConfig.WriteString('Unis','Username','unisuser');
    iniConfig.WriteString('Unis','Password','unisamho');
    iniConfig.WriteString('Unis','Terminal','(1, 1001, 1002)');

    iniConfig.WriteString ('Gate-In','IP-Address'  ,'192.168.100.32');
    iniConfig.WriteInteger('Gate-In','Port',10001) ;

    iniConfig.WriteString ('Gate-Out','IP-Address'  ,'192.168.100.33');
    iniConfig.WriteInteger('Gate-Out','Port',10002) ;

    iniConfig.WriteString ('Config','Building'  ,'126');
  end;

  with dmData do
  begin

    zmxConnection.ProviderName := 'MySql' ;
    zmxConnection.Server   := iniConfig.ReadString('Commax','Server'  ,'203.156.178.109');
    zmxConnection.Database := iniConfig.ReadString('Commax','Database','db_center') ;
    zmxConnection.Username := iniConfig.ReadString('Commax','Username','root');
    zmxConnection.Password := iniConfig.ReadString('Commax','Password','linuxonchip');
    zmxConnection.Options.LocalFailover := True;
    zmxConnection.Connected := True;

    bacConnection.ProviderName := 'MySql' ;
    bacConnection.Server   := iniConfig.ReadString('BAC','Server'     ,'192.168.100.10');
    bacConnection.Database := iniConfig.ReadString('BAC','Database'   ,'bac_center') ;
    bacConnection.Username := iniConfig.ReadString('BAC','Username'   ,'root');
    bacConnection.Password := iniConfig.ReadString('BAC','Password'   ,'linuxonchip');
    bacConnection.Options.LocalFailover := True;
    bacConnection.Connected := True;

    aptConnection.Server   := iniConfig.ReadString('Alpeta','Server'  ,'203.156.178.109');
    aptConnection.Database := iniConfig.ReadString('Alpeta','Database','UCDB') ;
    aptConnection.Username := iniConfig.ReadString('Alpeta','Username','unisuser');
    aptConnection.Password := iniConfig.ReadString('Alpeta','Password','unisamho');
    aptConnection.Options.LocalFailover := True;
    aptConnection.Connected := True;

    unisTerminal := iniConfig.ReadString('Unis','Terminal','(1, 1001, 1002)');

    unisConnection.Server   := iniConfig.ReadString('Unis','Server'  ,'203.156.178.109');
    unisConnection.Database := iniConfig.ReadString('Unis','Database','unis') ;
    unisConnection.Username := iniConfig.ReadString('Unis','Username','unisuser');
    unisConnection.Password := iniConfig.ReadString('Unis','Password','unisamho');
    unisConnection.Options.LocalFailover := True;
    unisConnection.Connected := True;


  end;

  baseURL_API    := iniConfig.ReadString ('API','url'  ,'');

  gateIn_ip    := iniConfig.ReadString ('Gate-In','IP-Address'  ,'192.168.100.32');
  gateIn_port  := iniConfig.ReadInteger('Gate-In','Port'  ,10001);

  gateOut_ip   := iniConfig.ReadString ('Gate-Out','IP-Address'  ,'192.168.100.33');
  gateOut_port := iniConfig.ReadInteger('Gate-Out','Port'  ,10002);

  iniBuilding  := iniConfig.ReadString ('Config','Building','111');
  msgLimit     := iniConfig.ReadString ('Config','Text Limit','Limit');
  msgInhouse   := iniConfig.ReadString ('Config','Text In-House','In House');

  autoStart   := iniConfig.ReadBool('Config','Auto Start',True);

  iniConfig.Free;

  cmxFind   .Connection := dmData.zmxConnection;
  bacFind   .Connection := dmData.bacConnection;
  qryFind   .Connection := dmData.bacConnection;
  qryTemp   .Connection := dmData.bacConnection;
  bacDisplay.Connection := dmData.bacConnection;
  unisFind  .Connection := dmData.unisConnection;

  cmxDateTime := FormatDateTime('YYYY-MM-DD',now) + ' ' + FormatDateTime('HH:MM:SS',now) ;
  unsDateTime := FormatDateTime('YYYYMMDD'  ,now) + FormatDateTime('HHMMSS',now);
  aptDateTime := FormatDateTime('YYYYMMDD'  ,now) + FormatDateTime('HHMMSS',now);


  dsBacDisplay.DataSet := bacDisplay;

  edDateTime.Text := FormatDateTime('DD/MM/YYYY',Date) + ' ' +
                     FormatDateTime('HH:MM:SS'  ,Time);
  ProgressBar1.Visible := False;


  n := 0 ;
  DBGrid1.Columns.Clear;
  ShowDBGrid(n, 'cmdate'      , 90,taCenter     ,'Date',        DBGrid1);
  ShowDBGrid(n, 'cmtime'      , 90,taCenter     ,'Time',        DBGrid1);
//  ShowDBGrid(n, 'cm_building' , 80,taCenter     ,'Building',    DBGrid1);
  ShowDBGrid(n, 'cmRoom'     , 90,taCenter     ,'Room',        DBGrid1);
  ShowDBGrid(n, 'cm_type'     , 70,taCenter     ,'Type',        DBGrid1);
  ShowDBGrid(n, 'cm_brand'    , 90,taCenter     ,'Brand',       DBGrid1);
  ShowDBGrid(n, 'cm_ipaddress',100,taCenter     ,'IP-Address',  DBGrid1);
  ShowDBGrid(n, 'cm_remark',300,taLeftJustify     ,'Remark',  DBGrid1);

//  btnStartClick(self);

  maxForm := 4; nMaxShow := 0 ;

end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;

  edDateTime.Text := FormatDateTime('DD/MM/YYYY',Date) + ' ' +
                     FormatDateTime('HH:MM:SS'  ,Time);

  ProgressBar1.Visible := True;
  ProgressBar1.Position := nProgress ;

  if nProgress >= ProgressBar1.Max then nProgress := 0
                                   else nProgress := nProgress + 1;

  haveData := False;
  CommaxLogs( haveData );
  UnisLogs( haveData ) ;

  if haveData then Disp_logs;

  Application.ProcessMessages;

  Timer1.Enabled := True;
end;

function GetSeconds(timeValue : TDateTime): Integer;
var
  Hour, Min, Sec, MSec: Word;
begin
  DecodeTime(timeValue, Hour, Min, Sec, MSec);
  Result := Hour * 3600 + Min * 60 + Sec;
end;


procedure TfrmMain.Timer3Timer(Sender: TObject);
var
  i, f, nSec : integer;
  cForm : string;
  lFlag : boolean;
begin
  timer3.Enabled := False;
  f := nMaxShow ;
  i := 1;
  lFlag := True;
  while (f >= 1) and (lFlag = True) do
  begin
    cForm := 'frmAlarm' + IntToStr(i) ;

    nSec := GetSeconds ( now - arrTime[f] ) ;
    if nSec >= maxMin then
    begin
      DeleteForm(cForm);
      ShowPopup( nMaxShow ) ;
      lFlag := False ;
    end;

    f := f - 1;
    i := i + 1;
  end;


  Timer3.Enabled := True;
end;


procedure TfrmMain.DeleteForm( frmName : string ) ;
var
  n, i : integer;
begin
  n := StrToint(rightstr(frmName,1));

  i := (nMaxShow - n) + 1;
  while i < nMaxShow do
  begin
    arrGate[i] := arrGate[i + 1];
    arrDateTime[i] := arrDateTime  [i + 1];
    arrRoom_name[i] := arrRoom_name    [i + 1];
    arrStatus[i] := arrStatus  [i + 1];
    arrRemark[i] := arrRemark[i + 1];
    arrTime[i] := arrTime[i +1];
    i := i + 1;
  end;

  (Application.FindComponent( 'frmAlarm' + IntToStr(nMaxShow)) as TForm).Close;

  nMaxShow := nMaxShow - 1;

  ShowPopup(nMaxShow);
end;


procedure TfrmMain.ShowPopup( maxShow : integer );
var
  i, f : integer;
  cForm : string;
  Form : TForm;
  nFontColor : TColor;
begin
  f := maxShow ;
  i := 1;
  while f >= 1 do
  begin
    cForm := 'frmAlarm' + IntToStr(i) ;

    Form := (Application.FindComponent( cForm ) as TForm) ;

    if arrStatus[f] = 'Success' then
    begin
      nFontColor := clWhite;
      (Form.FindComponent('Panel2') as TPanel).Color := clGreen ;
    end
    else if (arrStatus[f] = 'Fail') and (pos('Not Member', arrRemark[f]) > 0) then
    begin
      nFontColor := clWhite;
      (Form.FindComponent('Panel2') as TPanel).Color := clRed
    end
    else
    begin
      nFontColor := clBlack;
      (Form.FindComponent('Panel2') as TPanel).Color := clYellow ;
    end;


    (Form.FindComponent('lbGate'     ) as TLabel).Font.Color := nFontColor;
    (Form.FindComponent('lbDate_time') as TLabel).Font.Color := nFontColor;
    (Form.FindComponent('lbRoom'     ) as TLabel).Font.Color := nFontColor;
    (Form.FindComponent('lbSuccess'  ) as TLabel).Font.Color := nFontColor;
    (Form.FindComponent('lbRemark'   ) as TLabel).Font.Color := nFontColor;

    (Form.FindComponent('lbGate'     ) as TLabel).Caption  := 'GATE-' + arrGate[f] ;
    (Form.FindComponent('lbDate_time') as TLabel).Caption  := arrDateTime[f] ;
    (Form.FindComponent('lbRoom'     ) as TLabel).Caption  := arrRoom_name[f] ;
    (Form.FindComponent('lbSuccess'  ) as TLabel).Caption  := arrStatus[f] ;
    (Form.FindComponent('lbRemark'   ) as TLabel).Caption  := arrRemark[f] ;


    Form.Width := frmWidth;
    Form.Height := frmHeight;
    Form.Left  := (i-1) * frmWidth;
    Form.Show;
//    Form.ShowModal;

    i := i + 1;
    f := f - 1;

  end;



end;


end.
