unit uAlarm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TfrmAlarm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    edGateInOut: TEdit;
    lbDate_time: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAlarm: TfrmAlarm;

implementation

{$R *.dfm}

end.
