unit uSetup;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  IniFiles;

type
  TfrmSetup = class(TForm)
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    edUnis_server: TEdit;
    edUnis_database: TEdit;
    edUnis_user: TEdit;
    edUnis_pass: TEdit;
    Label4: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    btnUnis_connect: TBitBtn;
    btnUnis_save: TBitBtn;
    edUnis_terminal: TEdit;
    Label5: TLabel;
    GroupBox3: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    edCommax_server: TEdit;
    edCommax_database: TEdit;
    edCommax_user: TEdit;
    edCommax_pass: TEdit;
    btnCommax_connect: TBitBtn;
    btnCommax_save: TBitBtn;
    GroupBox4: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    edBac_server: TEdit;
    edBac_database: TEdit;
    edBac_user: TEdit;
    edBac_pass: TEdit;
    btnBac_connect: TBitBtn;
    btnBac_save: TBitBtn;
    Label14: TLabel;
    edGatein_ip: TEdit;
    Label15: TLabel;
    edGatein_port: TEdit;
    Label16: TLabel;
    edGateout_ip: TEdit;
    Label17: TLabel;
    edGateout_port: TEdit;
    btnConfig_save: TBitBtn;
    edBuilding_def: TEdit;
    Label18: TLabel;
    cbAuto_start: TCheckBox;
    Label19: TLabel;
    edText_limit: TEdit;
    edText_inhouse: TEdit;
    Label20: TLabel;
    Label21: TLabel;
    edApi_url: TEdit;
    procedure FormShow(Sender: TObject);
    procedure btnUnis_saveClick(Sender: TObject);
    procedure btnUnis_connectClick(Sender: TObject);
    procedure btnCommax_connectClick(Sender: TObject);
    procedure btnCommax_saveClick(Sender: TObject);
    procedure btnBac_connectClick(Sender: TObject);
    procedure btnBac_saveClick(Sender: TObject);
    procedure btnConfig_saveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSetup: TfrmSetup;

implementation

{$R *.dfm}

uses uData, uFunction, uMain;

procedure TfrmSetup.btnBac_connectClick(Sender: TObject);
var
  lDm : TdmData;
  lConnect : boolean;
begin
  lConnect := False;
  lDm := TdmData.Create(self);
  try
    with lDm do
    begin
      bacConnection.Server    := edBac_server.Text   ;
      bacConnection.Database  := edBac_database.Text ;
      bacConnection.Username  := edBac_user.Text;
      bacConnection.Password  := edBac_pass.Text ;
      bacConnection.Connected := True ;
    end;
    lConnect := True;
  except
    lConnect := False;
  end;

  if lConnect = True then
  begin
    MessageDlg('Connect OK.',TMsgDlgType.mtInformation,[mbOK],0);
  end
  else
  begin
    MessageDlg('Not connect.',TMsgDlgType.mtWarning,[mbCancel],0);
  end;

end;

procedure TfrmSetup.btnBac_saveClick(Sender: TObject);
begin
  iniConfig.WriteString('BAC','Server'  , edBac_server.Text);
  iniConfig.WriteString('BAC','Database', edBac_database.Text) ;
  iniConfig.WriteString('BAC','Username', edBac_user.Text);
  iniConfig.WriteString('BAC','Password', edBac_pass.Text);

  with dmData do
  begin
    bacConnection.Server := edBac_server.Text;
    bacConnection.Database := edBac_database.Text;
    bacConnection.Username := edBac_user.Text;
    bacConnection.Password := edBac_pass.Text;
  end;


  MessageDlg('Save Bac-Config.' + #13 + 'Complete.!!!',TMsgDlgType.mtInformation, [mbOK],0) ;

end;

procedure TfrmSetup.btnCommax_connectClick(Sender: TObject);
var
  lDm : TdmData;
  lConnect : boolean;
begin
  lConnect := False;
  lDm := TdmData.Create(self);
  try
    with lDm do
    begin
      zmxConnection.Server    := edCommax_server.Text   ;
      zmxConnection.Database  := edCommax_database.Text ;
      zmxConnection.Username  := edCommax_user.Text;
      zmxConnection.Password  := edCommax_pass.Text ;
      zmxConnection.Connected := True ;
    end;
    lConnect := True;
  except
    lConnect := False;
  end;

  if lConnect = True then
  begin
    MessageDlg('Connect OK.',TMsgDlgType.mtInformation,[mbOK],0);
  end
  else
  begin
    MessageDlg('Not connect.',TMsgDlgType.mtWarning,[mbCancel],0);
  end;

end;

procedure TfrmSetup.btnCommax_saveClick(Sender: TObject);
begin
  iniConfig.WriteString('Commax','Server'  , edCommax_server.Text);
  iniConfig.WriteString('Commax','Database', edCommax_database.Text) ;
  iniConfig.WriteString('Commax','Username', edCommax_user.Text);
  iniConfig.WriteString('Commax','Password', edCommax_pass.Text);

  MessageDlg('Save Commax-Config.' + #13 + 'Complete.!!!',TMsgDlgType.mtInformation, [mbOK],0) ;

  with dmData do
  begin
    zmxConnection.Server := edCommax_server.Text;
    zmxConnection.Database := edCommax_database.Text;
    zmxConnection.Username := edCommax_user.Text;
    zmxConnection.Password := edCommax_pass.Text;
  end;


end;

procedure TfrmSetup.btnConfig_saveClick(Sender: TObject);
begin
  iniConfig.WriteString ('Gate-In','IP-Address'  , edGatein_ip.Text);
  iniConfig.WriteInteger('Gate-In','Port', StrToInt(edGatein_port.text)) ;

  iniConfig.WriteString ('Gate-Out','IP-Address'  , edGateout_ip.Text);
  iniConfig.WriteInteger('Gate-Out','Port', StrToInt(edGateout_port.text)) ;

  iniConfig.WriteString ('API','url'    , edApi_url.Text);

  iniConfig.WriteString ('Config','Text Limit'    , edText_limit.Text);
  iniConfig.WriteString ('Config','Text In-House' , edText_inhouse.Text);
  iniConfig.WriteString ('Config','Building'      , edBuilding_def.Text);
  iniConfig.WriteBool   ('Config','Auto Start'    , cbAuto_start.Checked);

  MessageDlg('Save Other-Config.' + #13 + 'Complete.!!!',TMsgDlgType.mtInformation, [mbOK],0) ;

  iniBuilding  := edBuilding_def.Text;
  msgLimit     := edText_limit.Text;
  msgInhouse   := edText_inhouse.Text;

  gateIn_ip    := edGatein_ip.Text;
  gateIn_port  := StrToInt(edGateIn_port.Text);

  gateOut_ip   := edGateOut_ip.Text;
  gateOut_port := StrToInt(edGateOut_port.Text);

  baseURL_API  := edApi_url.Text;
end;

procedure TfrmSetup.btnUnis_saveClick(Sender: TObject);
begin
  iniConfig.WriteString('Unis','Server'  , edUnis_server.Text);
  iniConfig.WriteString('Unis','Database', edUnis_database.Text) ;
  iniConfig.WriteString('Unis','Username', edUnis_user.Text);
  iniConfig.WriteString('Unis','Password', edUnis_pass.Text);
  iniConfig.WriteString('Unis','Terminal', edUnis_terminal.Text);

  with dmData do
  begin
    unisConnection.Server := edUnis_server.Text;
    unisConnection.Database := edUnis_database.Text;
    unisConnection.Username := edUnis_user.Text;
    unisConnection.Password := edUnis_pass.Text;
  end;

  unisTerminal := edUnis_terminal.text;


  MessageDlg('Save UNIS-Config.' + #13 + 'Complete.!!!',TMsgDlgType.mtInformation, [mbOK],0) ;
end;

procedure TfrmSetup.btnUnis_connectClick(Sender: TObject);
var
  lDm : TdmData;
  lConnect : boolean;
begin
  lConnect := False;
  lDm := TdmData.Create(self);
  try
    with lDm do
    begin
      unisConnection.Server    := edUnis_server.Text   ;
      unisConnection.Database  := edUnis_database.Text ;
      unisConnection.Username  := edUnis_user.Text;
      unisConnection.Password  := edUnis_pass.Text ;
      unisConnection.Connected := True ;
    end;
    lConnect := True;
  except
    lConnect := False;
  end;

  if lConnect = True then
  begin
    MessageDlg('Connect OK.',TMsgDlgType.mtInformation,[mbOK],0);
  end
  else
  begin
    MessageDlg('Not connect.',TMsgDlgType.mtWarning,[mbCancel],0);
  end;
end;

procedure TfrmSetup.FormShow(Sender: TObject);
begin
  iniConfig := TIniFile.Create( iniFilename ) ;

  edUnis_server.Text   := iniConfig.ReadString('Unis','Server'  ,'');
  edUnis_database.Text := iniConfig.ReadString('Unis','Database','') ;
  edUnis_user.Text     := iniConfig.ReadString('Unis','Username','');
  edUnis_pass.Text     := iniConfig.ReadString('Unis','Password','');
  edUnis_terminal.Text := iniConfig.ReadString('Unis','Terminal','(1001, 1002)');

  edCommax_server.Text   := iniConfig.ReadString('Commax','Server'  ,'');
  edCommax_database.Text := iniConfig.ReadString('Commax','Database','') ;
  edCommax_user.Text     := iniConfig.ReadString('Commax','Username','');
  edCommax_pass.Text     := iniConfig.ReadString('Commax','Password','');

  edBac_server.Text   := iniConfig.ReadString('Bac','Server'  ,'');
  edBac_database.Text := iniConfig.ReadString('Bac','Database','') ;
  edBac_user.Text     := iniConfig.ReadString('Bac','Username','');
  edBac_pass.Text     := iniConfig.ReadString('Bac','Password','');

  edGatein_ip  .Text := iniConfig.ReadString ('Gate-In','IP-Address','');
  edGatein_port.Text := iniConfig.ReadInteger('Gate-In','Port',0).ToString;

  edGateout_ip  .Text := iniConfig.ReadString ('Gate-Out','IP-Address','');
  edGateout_port.Text := iniConfig.ReadInteger('Gate-Out','Port',0).ToString;

  edBuilding_def  .Text := iniConfig.ReadString ('Config','Building','');

  cbAuto_start.Checked := iniConfig.ReadBool('Config','Auto start',True);

  edApi_url  .Text := iniConfig.ReadString ('API','url','');

  if not FileExists( iniFilename ) then
  begin

    iniConfig.WriteString('BAC','Server'  ,'192.168.100.10');
    iniConfig.WriteString('BAC','Database','bac_center') ;
    iniConfig.WriteString('BAC','Username','root');
    iniConfig.WriteString('BAC','Password','linuxonchip');

    iniConfig.WriteString('Alpeta','Server'  ,'192.168.100.4');
    iniConfig.WriteString('Alpeta','Database','UCDB') ;
    iniConfig.WriteString('Alpeta','Username','unisuser');
    iniConfig.WriteString('Alpeta','Password','unisamho');


    iniConfig.WriteString ('Gate-In','IP-Address'  ,'192.168.100.32');
    iniConfig.WriteInteger('Gate-In','Port',10001) ;

    iniConfig.WriteString ('Gate-Out','IP-Address'  ,'192.168.100.33');
    iniConfig.WriteInteger('Gate-Out','Port',10002) ;

    iniConfig.WriteString ('Config','Building'  ,'126');
  end;

end;

end.
