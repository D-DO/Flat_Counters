unit uFlatsFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.StdCtrls,
  Vcl.AppEvnts, Data.Win.ADODB;

type
  TFlatsFrame = class(TFrame)
    pTop: TPanel;
    DBGrid: TDBGrid;
   // FDConnectionTemp: TFDConnection;
    DSFlats: TDataSource;
   // qFlats: TFDQuery;
  // cbStreets: TDBLookupComboBox;
   // cbHouseNumbers: TDBLookupComboBox;
    bFilter: TButton;
    bFlushFilter: TButton;
   // qStreets: TFDQuery;
    DSStreets: TDataSource;
   // qHouseNumbers: TFDQuery;
    DSHouseNumbers: TDataSource;
    pPanelTop: TPanel;
    lStreets: TLabel;
    lHouseNumbers: TLabel;
   // qFlatsFilter: TFDQuery;
    DS: TDataSource;
    bHistory: TButton;
    qFlats2: TADOQuery;
    qHouseNumbers2: TADOQuery;
    qStreets2: TADOQuery;
    qFlatsFilter2: TADOQuery;
    ADOConnection1: TADOConnection;
    cbStreets2: TDBLookupComboBox;
    cbHouseNumbers2: TDBLookupComboBox;
    Label1: TLabel;

    procedure bFilterClick(Sender: TObject);
    procedure bFlushFilterClick(Sender: TObject);
    procedure bHistoryClick(Sender: TObject);

    procedure cbStreets2CloseUp(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Init();
  end;

implementation

uses
  uDb, //
  uChangeCountersHistoryForm;

{$R *.dfm}

{ TFlatsFrame }

procedure TFlatsFrame.bFilterClick(Sender: TObject);
begin

   with qFlatsFilter2 do
  begin
    //Connection := DB.FDConnection;
    //CachedUpdates := true;
    parameters.ParamValues['street_id'] := qStreets2.FieldByName('id').AsInteger;
    parameters.ParamValues['houseNumber_id'] := qHouseNumbers2.FieldByName('id').AsInteger;
    Active := false;
    Active := true;
  end;
  DSFlats.DataSet := qFlatsFilter2;
end;

procedure TFlatsFrame.bFlushFilterClick(Sender: TObject);
begin
 { qFlats.Disconnect();
  qFlats.Open();
  DSFlats.DataSet := qFlats;   }

  qFlats2.Active := false;
  qFlats2.Active := true;
  DSFlats.DataSet := qFlats2;
end;

procedure TFlatsFrame.bHistoryClick(Sender: TObject);
var
  f: TChangeCountersHistoryForm;
begin
  f := TChangeCountersHistoryForm.Create(Self);
  f.FlatID := DSFlats.DataSet.FieldByName('flatId').AsInteger;
  Label1.Caption :=  DSFlats.DataSet.FieldByName('flatId').AsString;
  f.Init();
  f.Show();
end;

procedure TFlatsFrame.cbStreets2CloseUp(Sender: TObject);
begin
      with qHouseNumbers2 do
  begin
    Connection := Db.ADOConnection;
    //CachedUpdates := true;
    parameters.ParamValues['streets_id'] := qStreets2.FieldByName('id').AsInteger;
     Active := false;
    Active := true;
    cbHouseNumbers2.KeyValue := qHouseNumbers2.FieldByName('id').AsInteger;
  end;
end;





procedure TFlatsFrame.Init;
begin
    ADOConnection1.Connected := false;

  with qFlats2 do
  begin
  Connection := Db.ADOConnection;
    Active := false;
    Active := true;
  end;
  with qStreets2 do
  begin
  Connection := Db.ADOConnection;
    Active := false;
    Active := true;
    cbStreets2.KeyValue := qStreets2.FieldByName('id').AsInteger;
  end;
  with qHouseNumbers2 do
  begin
    Connection := Db.ADOConnection;
   // CachedUpdates := true;
    parameters.ParamValues['streets_id'] := qStreets2.FieldByName('id').AsInteger;
    Active := false;
    Active := true;
   cbHouseNumbers2.KeyValue := qHouseNumbers2.FieldByName('id').AsInteger;
  end;
  {FDConnectionTemp.Connected := false;
  with qFlats do
  begin
    Connection := Db.FDConnection;
    Disconnect();
    Open();
  end;
  with qStreets do
  begin
    Connection := Db.FDConnection;
    CachedUpdates := true;
    Disconnect();
    Open();
    cbStreets.KeyValue := qStreets.FieldByName('id').AsInteger;
  end;
  with qHouseNumbers do
  begin
    Connection := Db.FDConnection;
    CachedUpdates := true;
    params.ParamValues['streets_id'] := qStreets.FieldByName('id').AsInteger;
    Disconnect();
    Open();
    cbHouseNumbers.KeyValue := qHouseNumbers.FieldByName('id').AsInteger;
  end; }
end;

end.

