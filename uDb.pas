unit uDb;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TDb = class(TDataModule)
    ADOConnection: TADOConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Connect: boolean;
  end;

var
  DB: TDB;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function TDB.Connect: boolean;
//var
//  oParams: TStrings;
//  ErrorInfo: string;
begin
       ADOConnection.ConnectionString :='Provider=MSDASQL.1;Password=12345;Persist Security Info=True;User ID=root;Extended Properties="DSN=D;UID=root;PWD=12345;DATABASE=flat_db;PORT=3306"';

         ADOConnection.LoginPrompt := false;
       ADOConnection.Connected := TRUE;
end;

procedure TDb.DataModuleCreate(Sender: TObject);
begin
  Connect();
end;

end.

