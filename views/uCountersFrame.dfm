object CountersFrame: TCountersFrame
  Left = 0
  Top = 0
  Width = 842
  Height = 415
  TabOrder = 0
  object DBGrid: TDBGrid
    Left = 0
    Top = 97
    Width = 842
    Height = 318
    Align = alClient
    DataSource = DSCounters
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
        FieldName = 'serialNumber'
        Title.Caption = #1057#1077#1088#1080#1081#1085#1099#1081' '#1085#1086#1084#1077#1088
        Width = 92
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'creationDateTime'
        Title.Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103
        Width = 94
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'lastCheckDate'
        Title.Caption = #1044#1072#1090#1072' '#1087#1086#1074#1077#1088#1082#1080
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'nextCheckDate'
        Title.Caption = #1057#1083#1077#1076'. '#1076#1072#1090#1072' '#1087#1086#1074#1077#1088#1082#1080
        Width = 120
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'streetName'
        Title.Caption = #1059#1083#1080#1094#1072
        Width = 80
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
        FieldName = 'value'
        Title.Caption = #1047#1085#1072#1095#1077#1085#1080#1077
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'measureDateTime'
        Title.Caption = #1044#1072#1090#1072' '#1080#1079#1084#1077#1088#1077#1085#1080#1103
        Width = 102
        Visible = True
      end>
  end
  object tbit: TPanel
    Left = 0
    Top = 0
    Width = 842
    Height = 33
    Align = alTop
    TabOrder = 1
    object bAdd: TBitBtn
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 75
      Height = 25
      Align = alLeft
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      TabOrder = 0
      OnClick = bAddClick
    end
    object bEdit: TBitBtn
      AlignWithMargins = True
      Left = 85
      Top = 4
      Width = 92
      Height = 25
      Align = alLeft
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
      TabOrder = 1
      OnClick = bEditClick
    end
    object bDelete: TBitBtn
      AlignWithMargins = True
      Left = 183
      Top = 4
      Width = 92
      Height = 25
      Align = alLeft
      Caption = #1059#1076#1072#1083#1080#1090#1100
      TabOrder = 2
      OnClick = bDeleteClick
    end
    object bAddNewData: TBitBtn
      AlignWithMargins = True
      Left = 281
      Top = 4
      Width = 163
      Height = 25
      Align = alLeft
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1086#1074#1099#1077' '#1087#1086#1082#1072#1079#1072#1085#1080#1103
      TabOrder = 3
      OnClick = bAddNewDataClick
    end
  end
  object pCountersToCheck: TPanel
    Left = 0
    Top = 33
    Width = 842
    Height = 64
    Align = alTop
    TabOrder = 2
    object lStreets: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 33
      Height = 13
      Caption = #1059#1083#1080#1094#1099
    end
    object lHouseNumbers: TLabel
      AlignWithMargins = True
      Left = 281
      Top = 6
      Width = 74
      Height = 24
      AutoSize = False
      Caption = #1053#1086#1084#1077#1088#1072' '#1076#1086#1084#1086#1074
    end
    object bFilter: TButton
      AlignWithMargins = True
      Left = 386
      Top = 24
      Width = 180
      Height = 24
      Caption = #1060#1080#1083#1100#1090#1088' '#1089#1095#1077#1090#1095#1080#1082#1086#1074' '#1085#1072' '#1087#1086#1074#1077#1088#1082#1091
      TabOrder = 0
      OnClick = bFilterClick
    end
    object bFlushFilter: TButton
      AlignWithMargins = True
      Left = 572
      Top = 24
      Width = 113
      Height = 24
      Caption = #1057#1073#1088#1086#1089#1080#1090#1100' '#1092#1080#1083#1100#1090#1088
      TabOrder = 1
      OnClick = bFlushFilterClick
    end
    object cbStreets2: TDBLookupComboBox
      Left = 4
      Top = 24
      Width = 145
      Height = 21
      KeyField = 'id'
      ListField = 'name'
      ListSource = DSStreets
      TabOrder = 2
      OnCloseUp = cbStreets2CloseUp
    end
    object cbHouseNumbers2: TDBLookupComboBox
      Left = 257
      Top = 32
      Width = 99
      Height = 21
      KeyField = 'id'
      ListField = 'name'
      ListSource = DSHouseNumbers
      TabOrder = 3
      OnCloseUp = cbHouseNumbers2CloseUp
    end
  end
  object DSCounters: TDataSource
    DataSet = qCounters2
    Left = 80
    Top = 280
  end
  object DSStreets: TDataSource
    DataSet = qStreets2
    Left = 160
    Top = 280
  end
  object DSHouseNumbers: TDataSource
    DataSet = qHouseNumbers2
    Left = 304
    Top = 296
  end
  object ADOConnection1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=MSDASQL.1;Password=12345;Persist Security Info=True;Use' +
      'r ID=root;Extended Properties="DSN=D;UID=root;PWD=12345;DATABASE' +
      '=flat_db;PORT=3306"'
    LoginPrompt = False
    Left = 484
    Top = 112
  end
  object qCountersFilter2: TADOQuery
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'streetId'
        DataType = ftInteger
        Size = -1
        Value = Null
      end
      item
        Name = 'houseNumberId'
        DataType = ftInteger
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'SELECT'
      'c.id, '
      'c.serialNumber,'
      'c.creationDateTime,'
      'c.lastCheckDate,'
      'c.nextCheckDate,'
      '#street'
      '(select name from streets where id=('
      'select streets_id from housenumbers where '
      
        'id=(select houseNumbers_id from flats where counters_id=c.id))) ' +
        'as streetName,'
      '#houseNumber'
      '(select name from housenumbers where '
      
        'id=(select houseNumbers_id from flats where counters_id=c.id)) a' +
        's houseNumberName,'
      '#flatNumber'
      
        '(select flatNumber from flats where counters_id=c.id) as flatNum' +
        'ber,'
      '# value'
      '(SELECT value FROM flat_db.counterdata where counters_id=c.id'
      
        'and id=( select Max(Id) from counterdata where counters_id=(Sele' +
        'ct counters_id from flats '
      'where id=(select flatNumber from flats where counters_id=c.id)'
      '))) as value,'
      '# measureDateTime'
      
        '(SELECT measureDateTime FROM flat_db.counterdata where counters_' +
        'id=c.id'
      
        'and id=( select Max(Id) from counterdata where counters_id=(Sele' +
        'ct counters_id from flats '
      'where id=(select flatNumber from flats where counters_id=c.id)'
      '))) as measureDateTime'
      'FROM '
      'counters c'
      'where '
      'date(c.NextCheckDate)<=date(Now())'
      'and'
      '(select id from streets where id=('
      'select streets_id from housenumbers where '
      
        'id=(select houseNumbers_id from flats where counters_id=c.id)))=' +
        ':streetId'
      'and'
      '(select id from housenumbers where '
      
        'id=(select houseNumbers_id from flats where counters_id=c.id)) =' +
        ':houseNumberId'
      'order by id desc')
    Left = 28
    Top = 225
  end
  object qCounters2: TADOQuery
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT'
      'c.id,'
      'c.serialNumber,'
      'c.creationDateTime,'
      'c.lastCheckDate,'
      'c.nextCheckDate,'
      '#street'
      '(select name from streets where id=('
      'select streets_id from housenumbers where '
      
        'id=(select houseNumbers_id from flats where counters_id=c.id))) ' +
        'as streetName,'
      '#houseNumber'
      '(select name from housenumbers where '
      
        'id=(select houseNumbers_id from flats where counters_id=c.id)) a' +
        's houseNumberName,'
      '#flatNumber'
      
        '(select flatNumber from flats where counters_id=c.id) as flatNum' +
        'ber,'
      '# value'
      
        '(SELECT value FROM flat_db.counterdata where counters_id=c.id or' +
        'der by id desc limit 1) as value,'
      '/*'
      '(SELECT value FROM flat_db.counterdata where counters_id=c.id'
      
        'and id=( select Max(Id) from counterdata where counters_id=(Sele' +
        'ct counters_id from flats '
      'where id=(select flatNumber from flats where counters_id=c.id)'
      ''
      '))) as value,'
      '*/'
      '# measureDateTime'
      
        '(SELECT measureDateTime FROM flat_db.counterdata where counters_' +
        'id=c.id order by id desc limit 1) as measureDateTime'
      '/*'
      
        '(SELECT measureDateTime FROM flat_db.counterdata where counters_' +
        'id=c.id'
      
        'and id=( select Max(Id) from counterdata where counters_id=(Sele' +
        'ct counters_id from flats '
      'where id=(select flatNumber from flats where counters_id=c.id)'
      '))) as measureDateTime'
      '*/'
      'FROM '
      'counters c'
      'order by id desc')
    Left = 108
    Top = 161
  end
  object qStreets2: TADOQuery
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select*from streets')
    Left = 196
    Top = 137
  end
  object qHouseNumbers2: TADOQuery
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'streets_id'
        DataType = ftInteger
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'SELECT * FROM flat_db.housenumbers where streets_id=:streets_id;')
    Left = 284
    Top = 169
  end
  object qFlatNumbers2: TADOQuery
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'houseNumbers_id'
        DataType = ftInteger
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      
        'SELECT * FROM flat_db.flats where houseNumbers_id=:houseNumbers_' +
        'id;')
    Left = 380
    Top = 185
  end
end
