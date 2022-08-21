unit uAddNewCounterData;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin,
  Vcl.ExtCtrls, Vcl.Buttons, Data.DB,
  Vcl.Grids, Data.Win.ADODB, Vcl.DBGrids;

type
  TAddNewCounterData = class(TForm)
    seInt: TSpinEdit;
    seFrac: TSpinEdit;
    lInt: TLabel;
    Label1: TLabel;
    pBottom: TPanel;
    bOk: TBitBtn;
    bCancel: TBitBtn;
    DBGrid1: TDBGrid;
    Label2: TLabel;
    DSCounterData: TDataSource;
    ADOConnection1: TADOConnection;
    qCounterData2: TADOQuery;
    procedure bOkClick(Sender: TObject);
    procedure bCancelClick(Sender: TObject);
  private
    FCounterID: integer;
    procedure SetCounterID(const Value: integer);
    { Private declarations }

  public
    { Public declarations }
    procedure Init();
    property CounterID: integer read FCounterID write SetCounterID;
  end;

implementation

uses
//  uDb,
 uCommon;

{$R *.dfm}

procedure TAddNewCounterData.bCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TAddNewCounterData.bOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TAddNewCounterData.Init;
begin

  with qCounterData2 do
  begin

    parameters.ParamValues['counters_id'] := FCounterID;
    Active := false;
    Active := true;
  end;
  seInt.Value := trunc(qCounterData2.FieldByName('value').AsFloat);
  seFrac.Value := TCommon.GetRestOfFloat(qCounterData2.FieldByName('value').AsFloat);
end;

procedure TAddNewCounterData.SetCounterID(const Value: integer);
begin
  FCounterID := Value;
end;

end.

