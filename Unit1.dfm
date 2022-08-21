object Db2: TDb2
  Left = 0
  Top = 0
  ClientHeight = 260
  ClientWidth = 369
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ADOConnection: TADOConnection
    ConnectionString = 
      'Provider=MSDASQL.1;Password=12345;Persist Security Info=True;Use' +
      'r ID=root;Extended Properties="DSN=D;UID=root;PWD=12345;DATABASE' +
      '=flat_db;PORT=3306"'
    LoginPrompt = False
    Provider = 'MSDASQL.1'
    Left = 201
    Top = 128
  end
end
