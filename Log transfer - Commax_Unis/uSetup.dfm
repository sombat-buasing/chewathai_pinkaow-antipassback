object frmSetup: TfrmSetup
  Left = 0
  Top = 0
  Caption = 'Setup'
  ClientHeight = 458
  ClientWidth = 1085
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1085
    Height = 458
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 654
    ExplicitHeight = 450
    object GroupBox1: TGroupBox
      Left = 8
      Top = 8
      Width = 353
      Height = 161
      Caption = ' Unis '
      TabOrder = 0
      object Label4: TLabel
        Left = 50
        Top = 104
        Width = 53
        Height = 13
        Caption = 'Password :'
      end
      object Label3: TLabel
        Left = 74
        Top = 78
        Width = 29
        Height = 13
        Caption = 'User :'
      end
      object Label2: TLabel
        Left = 50
        Top = 53
        Width = 53
        Height = 13
        Caption = 'Database :'
      end
      object Label1: TLabel
        Left = 64
        Top = 28
        Width = 39
        Height = 13
        Caption = 'Server :'
      end
      object Label5: TLabel
        Left = 56
        Top = 130
        Width = 47
        Height = 13
        Caption = 'Terminal :'
      end
      object edUnis_server: TEdit
        Left = 109
        Top = 25
        Width = 212
        Height = 21
        Hint = '192.168.100.4'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TextHint = '192.168.100.4'
      end
      object edUnis_database: TEdit
        Left = 109
        Top = 50
        Width = 212
        Height = 21
        Hint = 'unis'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        TextHint = 'unis'
      end
      object edUnis_user: TEdit
        Left = 109
        Top = 75
        Width = 116
        Height = 21
        Hint = 'unisuser'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        TextHint = 'unisuser'
      end
      object edUnis_pass: TEdit
        Left = 109
        Top = 101
        Width = 116
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        PasswordChar = '*'
        TabOrder = 3
      end
      object btnUnis_connect: TBitBtn
        Left = 231
        Top = 73
        Width = 90
        Height = 25
        Caption = 'Connect'
        TabOrder = 4
        OnClick = btnUnis_connectClick
      end
      object btnUnis_save: TBitBtn
        Left = 231
        Top = 99
        Width = 90
        Height = 25
        Caption = 'Save'
        TabOrder = 5
        OnClick = btnUnis_saveClick
      end
      object edUnis_terminal: TEdit
        Left = 109
        Top = 127
        Width = 212
        Height = 21
        Hint = '( 1001, 1002 )'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
        TextHint = '( 1001, 1002 )'
      end
    end
    object GroupBox2: TGroupBox
      Left = 8
      Top = 175
      Width = 710
      Height = 258
      Caption = ' Config '
      TabOrder = 1
      object Label14: TLabel
        Left = 46
        Top = 47
        Width = 57
        Height = 13
        Caption = 'Gate-In IP :'
      end
      object Label15: TLabel
        Left = 314
        Top = 47
        Width = 27
        Height = 13
        Caption = 'Port :'
      end
      object Label16: TLabel
        Left = 38
        Top = 74
        Width = 65
        Height = 13
        Caption = 'Gate-Out IP :'
      end
      object Label17: TLabel
        Left = 314
        Top = 74
        Width = 27
        Height = 13
        Caption = 'Port :'
      end
      object Label18: TLabel
        Left = 23
        Top = 21
        Width = 80
        Height = 13
        Caption = 'Building default :'
      end
      object Label19: TLabel
        Left = 50
        Top = 101
        Width = 53
        Height = 13
        Caption = 'Limit Text :'
      end
      object Label20: TLabel
        Left = 29
        Top = 128
        Width = 74
        Height = 13
        Caption = 'In house Text :'
      end
      object Label21: TLabel
        Left = 63
        Top = 155
        Width = 40
        Height = 13
        Caption = 'API Url :'
      end
      object edGatein_ip: TEdit
        Left = 109
        Top = 44
        Width = 181
        Height = 21
        Hint = '192.168.100.4'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TextHint = '192.168.100.4'
      end
      object edGatein_port: TEdit
        Left = 347
        Top = 44
        Width = 64
        Height = 21
        Hint = '192.168.100.4'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        TextHint = '192.168.100.4'
      end
      object edGateout_ip: TEdit
        Left = 109
        Top = 71
        Width = 181
        Height = 21
        Hint = '192.168.100.4'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        TextHint = '192.168.100.4'
      end
      object edGateout_port: TEdit
        Left = 347
        Top = 71
        Width = 64
        Height = 21
        Hint = '192.168.100.4'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        TextHint = '192.168.100.4'
      end
      object btnConfig_save: TBitBtn
        Left = 109
        Top = 211
        Width = 332
        Height = 25
        Caption = 'Save'
        TabOrder = 4
        OnClick = btnConfig_saveClick
      end
      object edBuilding_def: TEdit
        Left = 109
        Top = 18
        Width = 76
        Height = 21
        Hint = '192.168.100.4'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        TextHint = '192.168.100.4'
      end
      object cbAuto_start: TCheckBox
        Left = 231
        Top = 21
        Width = 186
        Height = 17
        Caption = 'Auto start when open application.'
        TabOrder = 6
      end
      object edText_limit: TEdit
        Left = 109
        Top = 98
        Width = 181
        Height = 21
        Hint = '192.168.100.4'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        TextHint = '192.168.100.4'
      end
      object edText_inhouse: TEdit
        Left = 109
        Top = 125
        Width = 181
        Height = 21
        Hint = '192.168.100.4'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
        TextHint = '192.168.100.4'
      end
      object edApi_url: TEdit
        Left = 109
        Top = 152
        Width = 332
        Height = 21
        Hint = '192.168.100.4'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
        TextHint = '192.168.100.4'
      end
    end
    object GroupBox3: TGroupBox
      Left = 365
      Top = 8
      Width = 353
      Height = 161
      Caption = ' Commax '
      TabOrder = 2
      object Label6: TLabel
        Left = 50
        Top = 104
        Width = 53
        Height = 13
        Caption = 'Password :'
      end
      object Label7: TLabel
        Left = 74
        Top = 78
        Width = 29
        Height = 13
        Caption = 'User :'
      end
      object Label8: TLabel
        Left = 50
        Top = 53
        Width = 53
        Height = 13
        Caption = 'Database :'
      end
      object Label9: TLabel
        Left = 64
        Top = 28
        Width = 39
        Height = 13
        Caption = 'Server :'
      end
      object edCommax_server: TEdit
        Left = 109
        Top = 25
        Width = 212
        Height = 21
        Hint = '192.168.100.10'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TextHint = '192.168.100.10'
      end
      object edCommax_database: TEdit
        Left = 109
        Top = 50
        Width = 212
        Height = 21
        Hint = 'unis'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        TextHint = 'db_center'
      end
      object edCommax_user: TEdit
        Left = 109
        Top = 75
        Width = 116
        Height = 21
        Hint = 'unisuser'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        TextHint = 'bac'
      end
      object edCommax_pass: TEdit
        Left = 109
        Top = 101
        Width = 116
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        PasswordChar = '*'
        TabOrder = 3
      end
      object btnCommax_connect: TBitBtn
        Left = 231
        Top = 73
        Width = 90
        Height = 25
        Caption = 'Connect'
        TabOrder = 4
        OnClick = btnCommax_connectClick
      end
      object btnCommax_save: TBitBtn
        Left = 231
        Top = 99
        Width = 90
        Height = 25
        Caption = 'Save'
        TabOrder = 5
        OnClick = btnCommax_saveClick
      end
    end
    object GroupBox4: TGroupBox
      Left = 724
      Top = 8
      Width = 353
      Height = 161
      Caption = 'BAC'
      TabOrder = 3
      object Label10: TLabel
        Left = 50
        Top = 104
        Width = 53
        Height = 13
        Caption = 'Password :'
      end
      object Label11: TLabel
        Left = 74
        Top = 78
        Width = 29
        Height = 13
        Caption = 'User :'
      end
      object Label12: TLabel
        Left = 50
        Top = 53
        Width = 53
        Height = 13
        Caption = 'Database :'
      end
      object Label13: TLabel
        Left = 64
        Top = 28
        Width = 39
        Height = 13
        Caption = 'Server :'
      end
      object edBac_server: TEdit
        Left = 109
        Top = 25
        Width = 212
        Height = 21
        Hint = '192.168.100.10'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TextHint = '192.168.100.10'
      end
      object edBac_database: TEdit
        Left = 109
        Top = 50
        Width = 212
        Height = 21
        Hint = 'unis'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        TextHint = 'db_center'
      end
      object edBac_user: TEdit
        Left = 109
        Top = 75
        Width = 116
        Height = 21
        Hint = 'unisuser'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        TextHint = 'bac'
      end
      object edBac_pass: TEdit
        Left = 109
        Top = 101
        Width = 116
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        PasswordChar = '*'
        TabOrder = 3
      end
      object btnBac_connect: TBitBtn
        Left = 231
        Top = 73
        Width = 90
        Height = 25
        Caption = 'Connect'
        TabOrder = 4
        OnClick = btnBac_connectClick
      end
      object btnBac_save: TBitBtn
        Left = 231
        Top = 99
        Width = 90
        Height = 25
        Caption = 'Save'
        TabOrder = 5
        OnClick = btnBac_saveClick
      end
    end
  end
end
