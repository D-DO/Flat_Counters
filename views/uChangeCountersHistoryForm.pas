unit uChangeCountersHistoryForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Data.Win.ADODB, Data.DB, Vcl.Grids, Vcl.DBGrids;

type
  TChangeCountersHistoryForm = class(TForm)

   // qHistory: TFDQuery;
    DSHistory: TDataSource;
    DBGrid: TDBGrid;
    qHistory2: TADOQuery;
    ADOConnection1: TADOConnection;
  private
    FFlatID: integer;
    procedure SetFlatID(const Value: integer);
    { Private declarations }
  public
    { Public declarations }
    property FlatID: integer read FFlatID write SetFlatID;
    procedure Init;
  end;

implementation

{$R *.dfm}

//uses
 // uDb;


{ TChangeCountersHistoryForm }

procedure TChangeCountersHistoryForm.Init;
begin
 { FDConnectionTemp.Connected := false;
  with qHistory do
  begin
    Connection := db.FDConnection;
    params.ParamValues['flats_id'] := FFlatID;
    Disconnect();
    Open();
  end;    }


  with qHistory2 do
  begin

    parameters.ParamValues['flats_id'] := FFlatID;
    Active := false;
    Active := true;
  end;
end;

procedure TChangeCountersHistoryForm.SetFlatID(const Value: integer);
begin
  FFlatID := Value;
end;

end.

