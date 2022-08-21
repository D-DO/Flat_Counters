object FlatsFrame: TFlatsFrame
  Left = 0
  Top = 0
  Width = 1021
  Height = 317
  TabOrder = 0
  object pTop: TPanel
    Left = 0
    Top = 25
    Width = 1021
    Height = 64
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 784
      Top = 24
      Width = 31
      Height = 13
      Caption = 'Label1'
    end
    object bFilter: TButton
      AlignWithMargins = True
      Left = 324
      Top = 6
      Width = 75
      Height = 45
      Caption = #1060#1080#1083#1100#1090#1088
      TabOrder = 0
      OnClick = bFilterClick
    end
    object bFlushFilter: TButton
      AlignWithMargins = True
      Left = 405
      Top = 5
      Width = 106
      Height = 47
      Caption = #1057#1073#1088#1086#1089#1080#1090#1100' '#1092#1080#1083#1100#1090#1088
      TabOrder = 1
      OnClick = bFlushFilterClick
    end
    object bHistory: TButton
      AlignWithMargins = True
      Left = 517
      Top = 6
      Width = 170
      Height = 45
      Caption = #1048#1089#1090#1086#1088#1080#1103' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1089#1095#1077#1090#1095#1080#1082#1086#1074
      TabOrder = 2
      OnClick = bHistoryClick
    end
    object cbStreets2: TDBLookupComboBox
      Left = 4
      Top = 28
      Width = 145
      Height = 21
      KeyField = 'id'
      ListField = 'name'
      ListSource = DSStreets
      TabOrder = 3
      OnCloseUp = cbStreets2CloseUp
    end
    object cbHouseNumbers2: TDBLookupComboBox
      Left = 155
      Top = 28
      Width = 145
      Height = 21
      KeyField = 'id'
      ListField = 'name'
      ListSource = DSHouseNumbers
      TabOrder = 4
    end
  end
  object DBGrid: TDBGrid
    Left = 0
    Top = 89
    Width = 1021
    Height = 228
    Align = alClient
    DataSource = DSFlats
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'streetName'
        Title.Caption = #1059#1083#1080#1094#1072
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'houseNumberName'
        Title.Caption = #1044#1086#1084
        Width = 80
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'flatNumber'
        Title.Caption = #1050#1074#1072#1088#1090#1080#1088#1072
        Width = 80
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'serialNumber'
        Title.Caption = #1057#1077#1088#1080#1081#1085#1099#1081' '#1085#1086#1084#1077#1088' '#1089#1095#1077#1090#1095#1080#1082#1072
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'lastCounterDataValue'
        Title.Caption = #1047#1085#1072#1095#1077#1085#1080#1077' '#1089#1095#1077#1090#1095#1080#1082#1072
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'measureDateTime'
        Title.Caption = #1044#1072#1090#1072' '#1080#1079#1084#1077#1088#1077#1085#1080#1103
        Visible = True
      end>
  end
  object pPanelTop: TPanel
    Left = 0
    Top = 0
    Width = 1021
    Height = 25
    Align = alTop
    Caption = 'pPanelTop'
    ShowCaption = False
    TabOrder = 2
    object lStreets: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 160
      Height = 17
      Align = alLeft
      AutoSize = False
      Caption = #1059#1083#1080#1094#1099
      ExplicitLeft = 44
      ExplicitTop = 2
    end
    object lHouseNumbers: TLabel
      AlignWithMargins = True
      Left = 170
      Top = 4
      Width = 135
      Height = 17
      Align = alLeft
      AutoSize = False
      Caption = #1053#1086#1084#1077#1088#1072' '#1076#1086#1084#1086#1074
      ExplicitLeft = 578
      ExplicitTop = 8
    end
  end
  object DSFlats: TDataSource
    DataSet = qFlats2
    Left = 80
    Top = 224
  end
  object DSStreets: TDataSource
    DataSet = qStreets2
    Left = 184
    Top = 208
  end
  object DSHouseNumbers: TDataSource
    DataSet = qHouseNumbers2
    Left = 352
    Top = 240
  end
  object DS: TDataSource
    DataSet = qFlatsFilter2
    Left = 504
    Top = 240
  end
  object qFlats2: TADOQuery
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select'
      's.name as streetName,'
      'hn.name as houseNumberName,'
      'f.id as flatId,'
      'f.flatNumber,'
      '(select value from counterdata '
      
        'where id = (SELECT id FROM flat_db.counterdata where counters_id' +
        '=f.counters_id order by id desc limit 1)) as lastCounterDataValu' +
        'e,'
      '(select measureDateTime from counterdata '
      
        'where id = (SELECT id FROM flat_db.counterdata where counters_id' +
        '=f.counters_id order by id desc limit 1)) as measureDateTime,'
      
        '(select serialNumber from counters where id=f.counters_id) as se' +
        'rialNumber'
      'from flats f,housenumbers hn, streets s'
      'where '
      'hn.streets_id=s.id'
      'and f.houseNumbers_id=hn.id')
    Left = 100
    Top = 161
  end
  object qHouseNumbers2: TADOQuery
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'streets_id'
        DataType = ftSmallint
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'SELECT * FROM flat_db.housenumbers where streets_id=:streets_id;')
    Left = 380
    Top = 177
  end
  object qStreets2: TADOQuery
    Active = True
    CacheSize = 100
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from streets')
    Left = 236
    Top = 129
  end
  object qFlatsFilter2: TADOQuery
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'street_id'
        DataType = ftSmallint
        Size = -1
        Value = Null
      end
      item
        Name = 'houseNumber_id'
        DataType = ftSmallint
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'select'
      's.name as streetName,'
      'hn.name as houseNumberName,'
      'f.id as flatId,'
      'f.flatNumber,'
      '(select value from counterdata '
      
        'where id = (SELECT id FROM flat_db.counterdata where counters_id' +
        '=f.counters_id order by id desc limit 1)) as lastCounterDataValu' +
        'e,'
      '(select measureDateTime from counterdata '
      
        'where id = (SELECT id FROM flat_db.counterdata where counters_id' +
        '=f.counters_id order by id desc limit 1)) as measureDateTime,'
      
        '(select serialNumber from counters where id=f.counters_id) as se' +
        'rialNumber'
      'from flats f,housenumbers hn, streets s'
      'where '
      'hn.streets_id=s.id'
      'and f.houseNumbers_id=hn.id'
      'and s.id=:street_id'
      'and hn.id=:houseNumber_id')
    Left = 516
    Top = 161
  end
  object ADOConnection1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=MSDASQL.1;Password=12345;Persist Security Info=True;Use' +
      'r ID=root;Extended Properties="DSN=D;UID=root;PWD=12345;DATABASE' +
      '=flat_db;PORT=3306"'
    LoginPrompt = False
    Left = 100
    Top = 104
  end
end
