object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'LOG Transfer ( Commax vs Unis )'
  ClientHeight = 506
  ClientWidth = 966
  Color = 16776176
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    966
    506)
  PixelsPerInch = 96
  TextHeight = 13
  object ProgressBar1: TProgressBar
    Left = 151
    Top = 12
    Width = 525
    Height = 13
    Max = 20
    TabOrder = 0
  end
  object edDateTime: TEdit
    Left = 682
    Top = 8
    Width = 137
    Height = 21
    Alignment = taCenter
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
    Text = '08/02/2563 14:29:30'
  end
  object Edit1: TEdit
    Left = 8
    Top = 8
    Width = 137
    Height = 21
    Alignment = taCenter
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
    Text = 'COMMAX & UNIS'
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 34
    Width = 811
    Height = 466
    Anchors = [akLeft, akTop, akBottom]
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgTitleClick, dgTitleHotTrack]
    ParentColor = True
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object GroupBox1: TGroupBox
    Left = 825
    Top = 8
    Width = 138
    Height = 539
    TabOrder = 4
    object Label1: TLabel
      Left = 15
      Top = 462
      Width = 38
      Height = 13
      Caption = 'Status :'
    end
    object Label2: TLabel
      Left = 15
      Top = 438
      Width = 21
      Height = 13
      Caption = 'rmk:'
    end
    object btnStart: TBitBtn
      Left = 5
      Top = 5
      Width = 127
      Height = 25
      Caption = 'Start'
      TabOrder = 0
      OnClick = btnStartClick
    end
    object btnStop: TBitBtn
      Left = 5
      Top = 31
      Width = 127
      Height = 25
      Caption = 'Stop'
      TabOrder = 1
      OnClick = btnStopClick
    end
    object btnCommaxLogs: TBitBtn
      Left = 8
      Top = 300
      Width = 127
      Height = 25
      Caption = 'Commax Logs'
      TabOrder = 2
      OnClick = btnCommaxLogsClick
    end
    object btnDisp_log: TBitBtn
      Left = 8
      Top = 353
      Width = 127
      Height = 25
      Caption = 'Display logs'
      TabOrder = 3
      OnClick = btnDisp_logClick
    end
    object btnAlpeta_logs: TBitBtn
      Left = 8
      Top = 379
      Width = 127
      Height = 25
      Caption = 'Alpeta logs'
      TabOrder = 4
      Visible = False
      OnClick = btnAlpeta_logsClick
    end
    object btnUnis_logs: TBitBtn
      Left = 8
      Top = 326
      Width = 127
      Height = 25
      Caption = 'Unis logs'
      TabOrder = 5
      OnClick = btnUnis_logsClick
    end
    object btnGete_in: TBitBtn
      Left = 6
      Top = 483
      Width = 127
      Height = 25
      Caption = 'Gage In   '
      TabOrder = 6
      OnClick = btnGete_inClick
    end
    object btnGate_out: TBitBtn
      Left = 6
      Top = 508
      Width = 127
      Height = 25
      Caption = 'Gage Out'
      TabOrder = 7
      OnClick = btnGate_outClick
    end
    object cbGate_status: TComboBox
      Left = 59
      Top = 459
      Width = 74
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ItemIndex = 0
      ParentFont = False
      TabOrder = 8
      Text = 'Pass'
      Items.Strings = (
        'Pass'
        'Error')
    end
    object btnSetup: TBitBtn
      Left = 8
      Top = 406
      Width = 127
      Height = 25
      Caption = 'Setup'
      TabOrder = 9
      OnClick = btnSetupClick
    end
    object cbRemark: TComboBox
      Left = 42
      Top = 435
      Width = 91
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 10
      Text = 'Not member'
      Items.Strings = (
        'Not member'
        'Limit 1, 2, 3, InHouse = 2')
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 40
    Top = 72
  end
  object cmxFind: TUniQuery
    Left = 88
    Top = 72
  end
  object bacFind: TUniQuery
    Left = 152
    Top = 72
  end
  object bacDisplay: TUniQuery
    Left = 272
    Top = 80
  end
  object dsBacDisplay: TUniDataSource
    DataSet = bacDisplay
    Left = 376
    Top = 80
  end
  object unisFind: TUniQuery
    Left = 544
    Top = 80
  end
  object qryFind: TUniQuery
    Left = 272
    Top = 144
  end
  object qryTemp: TUniQuery
    Left = 368
    Top = 152
  end
  object Timer3: TTimer
    Enabled = False
    OnTimer = Timer3Timer
    Left = 120
    Top = 224
  end
end
