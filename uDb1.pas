unit uDb1;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, FireDAC.Comp.Client, Umain,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL;

type
  TDb1 = class(TDataModule)
    ADOConnection: TADOConnection;
    procedure DataModuleCreate1(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Connect1: boolean;
  end;

var
  DB1: TDB1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function TDB.Connect1: boolean;
//var
//  oParams: TStrings;
//  ErrorInfo: string;
begin
       ADOConnection.ConnectionString :='Provider=MSDASQL.1;Password=12345;Persist Security Info=True;User ID=root;Extended Properties="DSN=D;UID=root;PWD=12345;DATABASE=flat_db;PORT=3306"';

         ADOConnection.LoginPrompt := false;
       ADOConnection.Connected := TRUE;
end;

procedure TDb.DataModuleCreate1(Sender: TObject);
begin
  Connect();
end;

end.

