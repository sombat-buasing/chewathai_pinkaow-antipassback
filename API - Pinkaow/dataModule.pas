unit dataModule;

interface

uses
  System.SysUtils, System.Classes, REST.Types, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.ConsoleUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Phys.MSSQLDef, FireDAC.Phys.ODBCBase,
  FireDAC.Phys.MSSQL, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  IniFiles, Datasnap.DBClient, FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL,
  MidasLib;

type
  TdmRest = class(TDataModule)
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    FDConnection: TFDConnection;
    FDQuery: TFDQuery;
    carConnection: TFDConnection;
    carQuery: TFDQuery;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmRest: TdmRest;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure TdmRest.DataModuleCreate(Sender: TObject);
var
  iniFilename : string;
  iniConfig : TIniFile;
begin
  iniFilename := './config.ini';
  iniConfig := TIniFile.create( iniFilename ) ;

//  FDConnection.Close;
//  FDConnection.Params.Clear;
//  FDConnection.Params.Add('DriverID=MSSQL');
//  FDConnection.Params.Add('Server='   + iniConfig.ReadString('Alpeta DB', 'server'   ,'192.168.100.4'));
//  FDConnection.Params.Add('Database=' + iniConfig.ReadString('Alpeta DB', 'database' ,'ucdb'));
//  FDConnection.Params.Add('User_Name='+ iniConfig.ReadString('Alpeta DB', 'user'     ,'unisuser'));
//  FDConnection.Params.Add('Password=' + iniConfig.ReadString('Alpeta DB', 'password' ,'unisamho'));
//  FDConnection.Connected := True;

  carConnection.Close;
  carConnection.Params.Clear;
  carConnection.Params.Add('DriverID=MySQL');
  carConnection.Params.Add('Server='   + iniConfig.ReadString('Chewathai_car', 'server'   ,'192.168.100.10'));
  carConnection.Params.Add('Database=' + iniConfig.ReadString('Chewathai_car', 'database' ,'bac_center'));
  carConnection.Params.Add('User_Name='+ iniConfig.ReadString('Chewathai_car', 'user'     ,'root'));
  carConnection.Params.Add('Password=' + iniConfig.ReadString('Chewathai_car', 'password' ,'linuxonchip'));
  carConnection.Connected := True;

  iniConfig.Free;
end;

end.
