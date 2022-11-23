unit uAlarm4;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmAlarm4 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    lbDate_time: TLabel;
    lbRoom: TLabel;
    lbSuccess: TLabel;
    lbRemark: TLabel;
    lbGate: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAlarm4: TfrmAlarm4;

implementation

{$R *.dfm}

end.
