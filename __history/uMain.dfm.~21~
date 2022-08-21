object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1050#1074#1072#1088#1090#1080#1088#1099' '#1080' '#1089#1095#1077#1090#1095#1080#1082#1080
  ClientHeight = 579
  ClientWidth = 902
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 902
    Height = 560
    ActivePage = tsFlats
    Align = alClient
    TabOrder = 0
    object tsFlats: TTabSheet
      Caption = #1050#1074#1072#1088#1090#1080#1088#1099
      object DBGrid1: TDBGrid
        Left = 555
        Top = 421
        Width = 320
        Height = 120
        DataSource = DataSource1
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
    end
    object tsCounters: TTabSheet
      Caption = #1057#1095#1077#1090#1095#1080#1082#1080
      ImageIndex = 1
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 560
    Width = 902
    Height = 19
    Panels = <
      item
        Width = 200
      end>
  end
  object Timer: TTimer
    OnTimer = TimerTimer
    Left = 536
    Top = 88
  end
  object ApplicationEvents: TApplicationEvents
    OnException = ApplicationEventsException
    Left = 600
    Top = 192
  end
  object DataSource1: TDataSource
    DataSet = ADOQuery1
    Left = 316
    Top = 192
  end
  object ADOConnection1: TADOConnection
    ConnectionString = 
      'Provider=MSDASQL.1;Password=12345;Persist Security Info=True;Use' +
      'r ID=root;Extended Properties="DSN=D;UID=root;PWD=12345;DATABASE' +
      '=flat_db;PORT=3306"'
    LoginPrompt = False
    Provider = 'MSDASQL.1'
    Left = 460
    Top = 256
  end
  object ADOQuery1: TADOQuery
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from Streets')
    Left = 548
    Top = 312
  end
end
