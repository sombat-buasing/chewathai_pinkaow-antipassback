program antipassback_pinkaow;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  uData in 'uData.pas' {dmData: TDataModule},
  uFunction in 'uFunction.pas',
  uRestfull in 'uRestfull.pas' {dmRest: TDataModule},
  uSetup in 'uSetup.pas' {frmSetup},
  uAlarm1 in 'uAlarm1.pas' {frmAlarm1},
  uAlarm3 in 'uAlarm3.pas' {frmAlarm3},
  uAlarm4 in 'uAlarm4.pas' {frmAlarm4},
  uAlarm2 in 'uAlarm2.pas' {frmAlarm2};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmData, dmData);
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdmRest, dmRest);
  Application.CreateForm(TfrmSetup, frmSetup);
  Application.CreateForm(TfrmAlarm1, frmAlarm1);
  Application.CreateForm(TfrmAlarm3, frmAlarm3);
  Application.CreateForm(TfrmAlarm4, frmAlarm4);
  Application.CreateForm(TfrmAlarm2, frmAlarm2);
  Application.Run;
end.
