unit uCountersFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB,
  Vcl.StdCtrls, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.Buttons,
  Data.Win.ADODB;

type
  TCountersFrame = class(TFrame)
    DBGrid: TDBGrid;
    tbit: TPanel;
    bAdd: TBitBtn;
    bEdit: TBitBtn;
    bDelete: TBitBtn;
    DSCounters: TDataSource;
    pCountersToCheck: TPanel;
    lStreets: TLabel;
    lHouseNumbers: TLabel;
    bFilter: TButton;
    bFlushFilter: TButton;
    DSStreets: TDataSource;
    DSHouseNumbers: TDataSource;
    bAddNewData: TBitBtn;
    ADOConnection1: TADOConnection;
    qCountersFilter2: TADOQuery;
    qCounters2: TADOQuery;
    qStreets2: TADOQuery;
    qHouseNumbers2: TADOQuery;
    qFlatNumbers2: TADOQuery;
    cbStreets2: TDBLookupComboBox;
    cbHouseNumbers2: TDBLookupComboBox;
    procedure bAddClick(Sender: TObject);
    procedure bEditClick(Sender: TObject);
    procedure bDeleteClick(Sender: TObject);
    procedure bFilterClick(Sender: TObject);
    procedure bFlushFilterClick(Sender: TObject);
    procedure bAddNewDataClick(Sender: TObject);
    procedure cbStreets2CloseUp(Sender: TObject);
    procedure cbHouseNumbers2CloseUp(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Init();
  end;

implementation

{$R *.dfm}

uses
  uAddEditCounterForm, //
  uDB, //
  uCounter, //
  uCountersController, //
  uAddNewCounterData, //
  uCommon, //
  uFlatCounter, //
  uCountersUpdateHistory, uFlat; //

procedure TCountersFrame.bAddClick(Sender: TObject);
var
  c: TCounter;
  f: TAddEditCounterForm;
  fc: TFLatCounter;
  fcChosen: TFLatCounter;
  counterId: Integer;
  flatChosen: TFlat;
begin
  flatChosen := TFlat.Create(Self);
  f := TAddEditCounterForm.Create(Self);
  c := TCounter.Create(Self);
  try
    f.Init();
    with f do
    begin
      // update view
     // eSerialNumber.Text := fc.Counter.SerialNumber;
      dtpLast.DateTime := Now(); // fc.Counter.LastCheckDate;
      dtpNext.DateTime := Now(); //fc.Counter.NextCheckDate;
      if f.ShowModal = mrOk then
      begin
      // updating model
        c.SerialNumber := eSerialNumber.Text;
        c.LastCheckDate := dtpLast.DateTime;
        c.NextCheckDate := dtpNext.DateTime;
        counterId := TCountersController.InsertCounter(c);
        c.Id := counterId;
        //
        if f.cbIsAssociateToFlat.Checked then
        begin
          fc := TCountersController.GetAssociationToFlat(counterId);
          flatChosen.Id := f.qFlatNumbers.FieldByName('id').AsInteger;
          fcChosen := TCountersController.GetAssociationToCounter(flatChosen);
          TCountersController.AssociateFlatToCounter(fc, fcChosen);
        // associating flat and counter
        end;
      end;
      qCounters2.Active := false;//Disconnect();
      qCounters2.Active := true;//Open();


      DSCounters.DataSet := qCounters2;
    end;
  finally
    c.Free();
    flatChosen.Free();
    fc.Free();
    fcChosen.Free();
    f.Free();
    fc.Free();
  end;
end;

procedure TCountersFrame.bAddNewDataClick(Sender: TObject);
var
  f: TAddNewCounterData;
  newValue: double;
begin
  f := TAddNewCounterData.Create(Self);
  try
    f.CounterID := qCounters2.FieldByName('id').AsInteger;
    f.Init();
    if f.ShowModal = mrOk then
    begin
      newValue := TCommon.GetDoubleFromIntAndFrac(f.seInt.Value, f.seFrac.Value);
       // insert new record
      if (not TCountersController.IsNewValueOk(f.CounterID, newValue)) then
      begin
        Application.MessageBox('����� �������� ������ ���� ������ �����������', //
          '��������� �������', MB_OK + MB_ICONSTOP);
        exit;
      end;
      TCountersController.InsertCounterData(f.CounterID, newValue);
      qCounters2.Active := false;//Disconnect();
      qCounters2.Active := true;//Open();


    end;
  finally
    f.Free();
  end;
end;

procedure TCountersFrame.bDeleteClick(Sender: TObject);
var
  buttonSelected: Integer;
begin
  case Application.MessageBox('������� ������� � ��� ��� ������?', '��������� �������', MB_YESNO + MB_ICONQUESTION) of
    IDYES:
      begin
        TCountersController.Delete(qCounters2.FieldByName('id').AsInteger);
        qCounters2.Active := false;//Disconnect();
        qCounters2.  Active := true;//Open();


        DSCounters.DataSet := qCounters2;
      end;
    IDNO:
      begin
        Exit();
      end;
  end;
end;

procedure TCountersFrame.bEditClick(Sender: TObject);
var
  c: TCounter;
  f: TAddEditCounterForm;
  fc: TFLatCounter;
  fcChosen: TFLatCounter;
  anotherCounterId: integer;
  counterId: Integer;
  flatChosen: TFlat;
begin
  flatChosen := TFlat.Create(Self);
  f := TAddEditCounterForm.Create(Self);
  try
    f.Init();
    // ��������� ���������� �������� � ���������
    counterId := qCounters2.FieldByName('id').AsInteger;
    fc := TCountersController.GetAssociationToFlat(counterId);
    if (not fc.IsAssociated) then
      fc.Counter := TCountersController.GetCounter(counterId); // if no association
    if fc.IsAssociated then
    begin
      // ��������� ������
      f.cbIsAssociateToFlat.Checked := true;
      f.cbStreets.KeyValue := fc.Street.Id;
      // ����
      f.LoadHouseNumbersInList(fc.Street.Id);
      f.cbHouseNumbers.KeyValue := fc.HouseNumber.Id;
      // ��������
      f.LoadFlatsInList(fc.HouseNumber.Id);
      f.cbFlatNumbers.KeyValue := fc.Flat.Id;
    end;
    with f do
    begin
      // update view
      eSerialNumber.Text := fc.Counter.SerialNumber;
      dtpLast.DateTime := fc.Counter.LastCheckDate;
      dtpNext.DateTime := fc.Counter.NextCheckDate;
      if f.ShowModal = mrOk then
      begin
      // updating model from view
        fc.Counter.SerialNumber := eSerialNumber.Text;
        fc.Counter.LastCheckDate := dtpLast.DateTime;
        fc.Counter.NextCheckDate := dtpNext.DateTime;
        TCountersController.Update(fc.Counter, qCounters2.FieldByName('id').AsInteger);
        // associating flat and counter
        if f.cbIsAssociateToFlat.Checked then
        begin
          flatChosen.Id := f.qFlatNumbers.FieldByName('id').AsInteger;
          fcChosen := TCountersController.GetAssociationToCounter(flatChosen);
          TCountersController.AssociateFlatToCounter(fc, fcChosen);
        end
        else if (not f.cbIsAssociateToFlat.Checked) and (fc.IsAssociated) then
        begin
          // brake association
          TCountersController.BrakeAssociation(fc);
        end;
      end;
      qCounters2.Active := false;//Disconnect();
      qCounters2.Active := true;//Open();


      DSCounters.DataSet := qCounters2;
    end;
  finally
    flatChosen.Free();
    f.Free();
    fc.Free();
    fcChosen.Free();
  end;
end;

procedure TCountersFrame.bFilterClick(Sender: TObject);
begin
  with qCountersFilter2 do
  begin
    Connection := Db.ADOConnection;
    parameters.ParamValues['streetId'] := qStreets2.FieldByName('id').AsInteger;
    parameters.ParamValues['houseNumberId'] := qHouseNumbers2.FieldByName('id').AsInteger;
   Active := false;
    Active := true;
    DSCounters.DataSet := qCountersFilter2;
  end;
end;

procedure TCountersFrame.bFlushFilterClick(Sender: TObject);
begin
  with qCounters2 do
  begin
    Connection := Db.ADOConnection;
   Active := false;
    Active := true;
    DSCounters.DataSet := qCounters2;
  end;
end;

procedure TCountersFrame.cbHouseNumbers2CloseUp(Sender: TObject);
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

procedure TCountersFrame.cbStreets2CloseUp(Sender: TObject);
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

procedure TCountersFrame.Init;
begin
  ADOConnection1.Connected := false;
  with qCounters2 do
  begin
   Connection := Db.ADOConnection;
    //CachedUpdates := true;
    Active := false;
    Active := true;
  end;
  with qStreets2 do
  begin
    Connection := Db.ADOConnection;
   // CachedUpdates := true;
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
end;

end.

