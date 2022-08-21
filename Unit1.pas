unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.Win.ADODB, Data.DB;

type
   TDb2 = class(TDataModule)
    ADOConnection: TADOConnection;
    procedure DataModuleCreate1(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Connect1: boolean;
  end;

var
  DB1: TDB2;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function TDB2.Connect1: boolean;
//var
//  oParams: TStrings;
//  ErrorInfo: string;
begin
       ADOConnection.ConnectionString :='Provider=MSDASQL.1;Password=12345;Persist Security Info=True;User ID=root;Extended Properties="DSN=D;UID=root;PWD=12345;DATABASE=flat_db;PORT=3306"';

         ADOConnection.LoginPrompt := false;
       ADOConnection.Connected := TRUE;
end;

procedure TDb2.DataModuleCreate1(Sender: TObject);
begin
  Connect1();
end;

end.

