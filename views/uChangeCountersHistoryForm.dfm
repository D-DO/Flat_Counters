object ChangeCountersHistoryForm: TChangeCountersHistoryForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1048#1089#1090#1086#1088#1080#1103' '#1079#1072#1084#1077#1085#1099' '#1089#1095#1077#1090#1095#1080#1082#1086#1074
  ClientHeight = 346
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid: TDBGrid
    Left = 0
    Top = 0
    Width = 635
    Height = 346
    Align = alClient
    DataSource = DSHistory
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'datetime'
        Title.Caption = #1044#1072#1090#1072' '#1080' '#1074#1088#1077#1084#1103
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'oldCounterValue'
        Title.Caption = #1047#1085#1072#1095#1077#1085#1080#1077' '#1089#1090#1072#1088#1086#1075#1086' '#1089#1095#1077#1090#1095#1080#1082#1072
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'oldSerialNumber'
        Title.Caption = #1057#1077#1088#1080#1081#1085#1099#1081' '#1085#1086#1084#1077#1088' '#1089#1090#1072#1088#1086#1075#1086' '#1089#1095#1077#1090#1095#1080#1082#1072
        Width = 180
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'serialNumber'
        Title.Caption = #1058#1077#1082#1091#1097#1080#1081' '#1089#1077#1088#1080#1081#1085#1099#1081' '#1085#1086#1084#1077#1088
        Width = 140
        Visible = True
      end>
  end
  object DSHistory: TDataSource
    DataSet = qHistory2
    Left = 120
    Top = 216
  end
  object qHistory2: TADOQuery
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'flats_id'
        Attributes = [paNullable]
        DataType = ftInteger
        NumericScale = 236
        Precision = 255
        Size = 255
        Value = Null
      end>
    SQL.Strings = (
      'SELECT '
      'h.datetime,'
      'c.serialNumber,'
      
        '(select serialNumber from counters where id=h.countersOld_id) as' +
        ' oldSerialNumber,'
      
        '(select counterOldValue from counters where id=h.countersOld_id)' +
        ' as oldCounterValue'
      'FROM flat_db.countersupdatehistory h,counters c'
      'where flats_id=:flats_id'
      'and h.counters_id=c.id')
    Left = 180
    Top = 153
  end
  object ADOConnection1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=MSDASQL.1;Password=12345;Persist Security Info=True;Use' +
      'r ID=root;Extended Properties="DSN=D;UID=root;PWD=12345;DATABASE' +
      '=flat_db;PORT=3306;"'
    LoginPrompt = False
    Left = 164
    Top = 80
  end
end
