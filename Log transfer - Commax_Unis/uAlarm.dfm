object frmAlarm: TfrmAlarm
  Left = 0
  Top = 0
  Caption = 'frmAlarm'
  ClientHeight = 256
  ClientWidth = 363
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 363
    Height = 256
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 48
    ExplicitTop = 48
    ExplicitWidth = 185
    ExplicitHeight = 41
    DesignSize = (
      363
      256)
    object Panel2: TPanel
      Left = 8
      Top = 8
      Width = 348
      Height = 239
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 0
      ExplicitWidth = 322
      ExplicitHeight = 241
      DesignSize = (
        348
        239)
      object lbDate_time: TLabel
        Left = 0
        Top = 37
        Width = 335
        Height = 13
        Alignment = taCenter
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'Date Time.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edGateInOut: TEdit
        Left = 0
        Top = 5
        Width = 335
        Height = 22
        Alignment = taCenter
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        Text = 'GATE IN/OUT'
      end
    end
  end
end
