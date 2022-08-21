unit uCommon;

interface

uses
  System.SysUtils, System.Classes, Data.Win.ADODB;

type
  TCommon = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
    class function GetDoubleFromIntAndFrac(aInt, aFrac: integer): double;
    class function GetLastInsertID(): integer;
    class function GetRestOfFloat(ASomeFloat: real): integer; static;
  end;

implementation

uses
  FireDAC.Comp.Client
  , uDb
  , uMain;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}
class function TCommon.GetDoubleFromIntAndFrac(aInt, aFrac: integer): double;
begin
  Result := StrToFloat((aInt.ToString)) + StrToFloat((aFrac / 100).ToString); // ����� + ������� �����
end;

class function TCommon.GetLastInsertID: integer;
var
  q: TADOQuery;
begin
  q := TADOQuery.Create(nil);
  try
    with q do
    begin
       Connection := Db.ADOConnection;
      sql.Text := 'select LAST_INSERT_ID() as lastId';
      Active := false;
    Active := true;
      result := FieldByName('lastId').AsInteger;
      Close();
    end;
  finally
    q.Free();
  end;
end;

class function TCommon.GetRestOfFloat(ASomeFloat: real): integer;
var
  s: string;
begin
  ASomeFloat := frac(ASomeFloat);
  str(ASomeFloat: 0: 2, s);
  Result := strtoint(copy(s, pos('.', s) + 1, 6));
end;

end.

