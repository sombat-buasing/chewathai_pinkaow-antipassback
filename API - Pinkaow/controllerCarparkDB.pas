unit controllerCarparkDB;

interface

uses
  MVCFramework, MVCFramework.Commons, MVCFramework.Serializer.Commons,
  system.json, rest.Json, MidasLib;

type
  [MVCPath('/api')]
  TControllerCarparkDB = class(TMVCController) 
  public

    [MVCPath('/Carpark')]
    [MVCHTTPMethod([httpPOST])]
    procedure GetCarpark;

    [MVCPath('/Update_Carpark_log')]
    [MVCHTTPMethod([httpPOST])]
    procedure Update_Carpark_log;

    [MVCPath('/Update_Carpark_Member')]
    [MVCHTTPMethod([httpPOST])]
    procedure Update_Carpark_Member;

  end;

implementation

uses
  System.SysUtils, MVCFramework.Logger, System.StrUtils, dataModule;

{ TControllerCarparkDB }

procedure TControllerCarparkDB.GetCarpark;
var
  lData : TdmRest;
  jValue : TJSONValue;
  oObj, oResult, rObj : TJsonObject;
  cRoom : string;
begin

  jValue := TJSONObject.ParseJSONValue( Context.Request.Body);
  cRoom := jValue.GetValue<string>('Room');

  lData := TDmRest.Create(nil);

  with ldata do
  begin

    oObj := TJsonObject.Create;

    carQuery.Sql.Clear;
    carQuery.Sql.Add('Select * From zmx_member ' +
      'Where cm_home_no = ' + QuotedStr(cRoom)) ;
    carQuery.Active := True;
    if (carQuery.IsEmpty = False) then
    begin
      oObj.AddPair(TJSONPair.Create('Room', carQuery.FieldByName('cm_home_no').AsString));
      oObj.AddPair(TJSONPair.Create('Owner', carQuery.FieldByName('cm_member_name').AsString));
      oObj.AddPair(TJSONPair.Create('Car Limit', TJsonNumber.create( carQuery.FieldByName('cm_car_limit').AsInteger)));
      oObj.AddPair(TJSONPair.Create('Car Count', TJsonNumber.create( carQuery.FieldByName('cm_car_count').AsInteger)));
    end;
  end;

  rObj := TJsonObject.Create;
  if oObj.Count > 0 then
  begin
    rObj.AddPair('ResultCode', TJsonNumber.Create( 0 ));
    rObj.AddPair('Remark', 'Complete.');
  end
  else
  begin
    rObj.AddPair('ResultCode', TJsonNumber.Create( 1 ));
    rObj.AddPair('Remark', 'Not Member');
  end;

  oResult := TJsonObject.Create;
  oResult.AddPair(TJSONPair.Create('Result', rObj)) ;
  oResult.AddPair(TJSONPair.Create('Detail', oObj)) ;


  Render( oResult  ) ;
end;

procedure TControllerCarparkDB.Update_Carpark_Log;
var
  lData : TdmRest;
  jValue : TJSONValue;
  oObj, oResult, rObj : TJsonObject;
  cRoom : string;
begin

  jValue := TJSONObject.ParseJSONValue( Context.Request.Body);

  lData := TDmRest.Create(nil);

  with ldata do
  begin

    carQuery.SQL.Clear;
    carQuery.SQL.Add('Insert into zmx_carpark_log ' +
      '( cp_date, cp_time, cp_home_no, cp_card_type, cp_ipaddress, cp_status, cp_in_out, cp_remark ) ' +
      ' Values ' +
      '(:cp_date,:cp_time,:cp_home_no,:cp_card_type,:cp_ipaddress,:cp_status,:cp_in_out,:cp_remark ) ' );
    carQuery.ParamByName('cp_date'  ).AsString := jValue.GetValue<String>('cp_date') ;
    carQuery.ParamByName('cp_time'  ).AsString := jValue.GetValue<String>('cp_time')  ;
    carQuery.ParamByName('cp_home_no'  ).AsString := jValue.GetValue<String>('cp_home_no');
    carQuery.ParamByName('cp_card_type').AsString := jValue.GetValue<String>('cp_card_type')  ;
    carQuery.ParamByName('cp_ipaddress').AsString := jValue.GetValue<String>('cp_ipaddress')  ;
    carQuery.ParamByName('cp_status'   ).AsString := jValue.GetValue<String>('cp_status')  ;
    carQuery.ParamByName('cp_in_out'   ).AsString := jValue.GetValue<String>('cp_in_out')  ;
    carQuery.ParamByName('cp_remark'   ).AsString := jValue.GetValue<String>('cp_remark')  ;
    carQuery.ExecSQL;
  end;

  rObj := TJsonObject.Create;
  rObj.AddPair('ResultCode', TJsonNumber.Create( 0 ));
  rObj.AddPair('Remark', 'Insert complete.');

  oResult := TJsonObject.Create;
  oResult.AddPair(TJSONPair.Create('Result', rObj)) ;
  oResult.AddPair(TJSONPair.Create('Detail', oObj)) ;


  Render( oResult  ) ;
end;

procedure TControllerCarparkDB.Update_Carpark_Member;
var
  lData : TdmRest;
  jValue : TJSONValue;
  oObj, oResult, rObj : TJsonObject;
  cRoom : string;
begin

  jValue := TJSONObject.ParseJSONValue( Context.Request.Body);

  oObj := TJSONObject.ParseJSONValue(jValue.ToString) as TJSONObject;


  lData := TDmRest.Create(nil);
  with lData do
  begin
    carQuery.Sql.Clear;
    carQuery.Sql.Add('Update zmx_member ' +
      'Set cm_car_count = :cm_car_count ' +
      'where cm_home_no = :cm_home_no ');
    carQuery.ParamByName('cm_home_no'  ).AsString  := jValue.GetValue<String> ('cp_home_no');
    carQuery.ParamByName('cm_car_count').AsInteger := jValue.GetValue<Integer>('cm_car_count');
    carQuery.ExecSQL;
  end;

  rObj := TJsonObject.Create;
  rObj.AddPair('ResultCode', TJsonNumber.Create( 0 ));
  rObj.AddPair('Remark', 'Update complete.');

  oResult := TJsonObject.Create;
  oResult.AddPair(TJSONPair.Create('Result', rObj)) ;
  oResult.AddPair(TJSONPair.Create('Detail', oObj)) ;


  Render( oResult  ) ;
end;


end.
