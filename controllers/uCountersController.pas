unit uCountersController;

interface

uses
  uCounter, //
  uFLatCounter, //
  Data.Win.ADODB,
  uCountersUpdateHistory, uFlat //
; //

type
  TCountersController = class
  private
  protected
  public
    class function GetCounter(aId: integer): TCounter;
    class function InsertCounter(var aC: TCounter): integer;
    class procedure Update(aC: TCounter; aId: integer);
    class procedure Delete(aId: integer);
    //
    class procedure InsertCounterData(aCounterId: integer; aValue: double);
    class function IsNewValueOk(aCounterId: integer; aNewValue: double): boolean; static;
    class procedure AssociateFlatToCounter(var aCounter: TFLatCounter; var aChosenFlat: TFLatCounter);
    class procedure LogAssociatonFlatToCounter(var aModel: TCountersUpdateHistory);
    class function GetAssociationToFlat(var aCounterId: integer): TFlatCounter;
    class function GetAssociationToCounter(var aModel: TFlat): TFlatCounter; static;
    class function IsCounterAssociatedToFlat(aCounterId: integer): boolean; static;
    class function IsFlatHasCounter(aFlatId: integer): boolean; static;
    class function ExchangeCountersInFlats(aCounterId, aAnotherCounterId: integer): boolean; static;
    class procedure UpdateCounterInFlat(aCounterId: integer; aFlatId: integer);
    class procedure BrakeAssociation(aModel: TFlatCounter);
  end;

implementation

uses
  FireDAC.Comp.Client,
  uDB,
   System.SysUtils, uCommon, LDSLogger
   , uMain
   ;

{ TCountersController }

class procedure TCountersController.AssociateFlatToCounter(var aCounter: TFLatCounter; var aChosenFlat: TFLatCounter);
var
  q: TADOQuery;
  l: TLDSLogger;
  h: TCountersUpdateHistory;
  h2: TCountersUpdateHistory;
begin
  h := TCountersUpdateHistory.Create(nil);
  h2 := TCountersUpdateHistory.Create(nil);
  try
  // 1) В выбранной квартире есть свой ассоциированный счетчик,
  //  Текущий счетчик ассоциирован с квартирой
  // поменять их местами
    if (aChosenFlat.IsAssociated) and (aCounter.IsAssociated) then
    begin
    // ask in dialog
      ExchangeCountersInFlats(aCounter.Counter.Id, aChosenFlat.Counter.Id);
    // write history

      h.CounterOld := aCounter.Counter;
      h.CounterNew := aChosenFlat.Counter;
      h.Flat.Id := aCounter.Flat.Id;
      TCountersController.LogAssociatonFlatToCounter(h);
    //
      h2.CounterOld := aChosenFlat.Counter;
      h2.Flat.Id := aChosenFlat.Flat.Id;
      h2.CounterNew := aCounter.Counter;
      TCountersController.LogAssociatonFlatToCounter(h2);

    end
  // 2) Текущий счетчик не ассоциирован с квартирой,
  // В выбранной квартире уже есть счетчик, тогда предложить
  // перезаписать
    else if (aChosenFlat.IsAssociated) and (not aCounter.IsAssociated) then
    begin
    // ask in dialog
      UpdateCounterInFlat(aCounter.Counter.Id, aChosenFlat.Flat.Id);
  // write history
      h.CounterOld := aChosenFlat.Counter;
      h.Flat.Id := aChosenFlat.Flat.Id;
      h.CounterNew := aCounter.Counter;
      TCountersController.LogAssociatonFlatToCounter(h);
    end
   //3) Текущий счетчик не ассоциирован с квартирой,
   //В выбранной квартире нет счетчика, тогда просто записываем
    else if (not aChosenFlat.IsAssociated) and (not aCounter.IsAssociated) then
    begin
      UpdateCounterInFlat(aCounter.Counter.Id, aChosenFlat.Flat.Id);
      h.CounterOld.Free();
      h.CounterOld := nil;
      h.Flat.Id := aChosenFlat.Flat.Id;
      h.CounterNew := aCounter.Counter;
      TCountersController.LogAssociatonFlatToCounter(h);
    end;
  finally
    h.Free();
    h2.Free();
  end;
end;
//

class procedure TCountersController.BrakeAssociation(aModel: TFlatCounter);
var
  q: TADOQuery;
  l: TLDSLogger;
begin
  q := TADOQuery.Create(nil);
  l := TLDSLogger.Create(logFileName);
  try
    try
      with q do
      begin
         Connection := Db.ADOConnection;
        sql.Text := 'UPDATE `flat_db`.`flats` SET `counters_id`=NULL WHERE `id`=:id;';
        parameters.ParamValues['id'] := aModel.Flat.Id;
        ExecSQL();
      end;
    except
      on E: Exception do
        l.LogStr('error=' + E.Message, tlpError);
    end;
  finally
    q.Free();
    l.Free();
  end;
end;

class procedure TCountersController.Delete(aId: integer);
var
  q: TADOQuery;
  l: TLDSLogger;
begin
  q := TADOQuery.Create(nil);
  l := TLDSLogger.Create(logFileName);
  try
    try
      with q do
      begin
         Connection := Db.ADOConnection;
        sql.Text := 'DELETE FROM `flat_db`.`counters` WHERE `id`=:id;';
        parameters.ParamValues['id'] := aId;
        ExecSQL();
      end;
    except
      on E: Exception do
        l.LogStr('error=' + E.Message, tlpError);
    end;
  finally
    q.Free();
    l.Free();
  end;
end;

class function TCountersController.ExchangeCountersInFlats(aCounterId, aAnotherCounterId: integer): boolean;
var
  fc: TFLatCounter;
  fcAnother: TFLatCounter;
//  c: TCounter;
//  cAnother: TCounter;
  l: TLDSLogger;
begin
  l := TLDSLogger.Create(logFileName);
//  c := TCountersController.GetCounter(aCounterId);
//  cAnother := TCountersController.GetCounter(aAnotherCounterId);
  fc := TCountersController.GetAssociationToFlat(aCounterId);
  fcAnother := TCountersController.GetAssociationToFlat(aAnotherCounterId);
  try
    try
      if ((fc.IsAssociated) and (fcAnother.IsAssociated)) then
      begin
        UpdateCounterInFlat(fc.Counter.Id, fcAnother.Flat.Id);
        UpdateCounterInFlat(fcAnother.Counter.Id, fc.Flat.Id);
      end;
    except
      on E: Exception do
        l.LogStr('error=' + E.Message, tlpError);
    end;
  finally
    fc.Free;
    fcAnother.Free;
    l.Free
  end;
end;

class function TCountersController.GetAssociationToFlat(var aCounterId: integer): TFlatCounter;
var
  q: TADOQuery;
  l: TLDSLogger;
begin
  q := TADOQuery.Create(nil);
  result := TFlatCounter.Create(nil);
  l := TLDSLogger.Create(logFileName);
  try
    try
      with q do
      begin
         Connection := Db.ADOConnection;
        sql.Text := 'SELECT ' + //
          'f.id, ' + //
          'f.flatNumber, ' + //
          'f.houseNumbers_id, ' + //
          '(select name from housenumbers where id=f.houseNumbers_id) as houseNumbersName, ' + //
          'f.counters_id, ' + //
          '(select streets_id from housenumbers where id=f.houseNumbers_id) as streetId, ' + //
          '(select name from streets where id=(select streets_id from housenumbers where id=f.houseNumbers_id)) as streetName ' + //
          'FROM flat_db.flats f ' + //
          'where f.counters_id=:counters_id';
        parameters.ParamValues['counters_id'] := aCounterId;
       Active := false;
    Active := true;
        result.Counter.Id := FieldByName('counters_id').AsInteger;
        result.Counter := GetCounter(aCounterId);
        if (not IsEmpty) then
        begin
          result.Flat.Id := FieldByName('id').AsInteger;
          result.Street.Id := FieldByName('streetId').AsInteger;
          result.HouseNumber.Id := FieldByName('houseNumbers_id').AsInteger;
          result.IsAssociated := true;
        end
        else
        begin
          result.IsAssociated := false;
        //result.Free();
        //result := nil;
        end;
        Close();
      end;
    except
      on E: Exception do
        l.LogStr('error=' + E.Message, tlpError);
    end;
  finally
    q.Free();
    l.Free();
  end;
end;

class function TCountersController.GetAssociationToCounter(var aModel: TFlat): TFlatCounter;
var
  q: TADOQuery;
  l: TLDSLogger;
begin
  q := TADOQuery.Create(nil);
  result := TFlatCounter.Create(nil);
  l := TLDSLogger.Create(logFileName);
  try
    try
      with q do
      begin
        Connection := Db.ADOConnection;
        sql.Text := 'SELECT ' + //
          'f.id, ' + //
          'f.flatNumber, ' + //
          'f.houseNumbers_id, ' + //
          '(select name from housenumbers where id=f.houseNumbers_id) as houseNumbersName, ' + //
          'f.counters_id, ' + //
          '(select streets_id from housenumbers where id=f.houseNumbers_id) as streetId, ' + //
          '(select name from streets where id=(select streets_id from housenumbers where id=f.houseNumbers_id)) as streetName ' + //
          'FROM flat_db.flats f ' + //
          'where f.id=:flat_id';
        parameters.ParamValues['flat_id'] := aModel.Id;
      Active := false;
    Active := true;
        if (not IsEmpty) then
        begin
          result.Counter.Id := FieldByName('counters_id').AsInteger;
          result.Flat.Id := FieldByName('id').AsInteger;
          result.Street.Id := FieldByName('streetId').AsInteger;
          result.HouseNumber.Id := FieldByName('houseNumbers_id').AsInteger;
          //result.IsAssociated := true;
        end;
        result.IsAssociated := not FieldByName('counters_id').IsNull;
        Close();
      end;
    except
      on E: Exception do
        l.LogStr('error=' + E.Message, tlpError);
    end;
  finally
    q.Free();
    l.Free();
  end;
end;

class function TCountersController.GetCounter(aId: integer): TCounter;
var
  q: TADOQuery;
  l: TLDSLogger;
begin
  q := TADOQuery.Create(nil);
  Result := TCounter.Create(nil);
  l := TLDSLogger.Create(logFileName);
  try
    try
      with q do
      begin
         Connection := Db.ADOConnection;
        sql.Text := 'SELECT ' + //
          'c.id, ' + //
          'c.serialNumber, ' + //
          'c.lastCheckDate, ' + //
          'c.nextCheckDate, ' + //
          '(select measureDateTime from counterdata cd where ' + //
          'counters_id=1 order by id desc limit 1) as measureDateTime, ' + //
          '(select value from counterdata cd where ' + //
          'counters_id=1 order by id desc limit 1) as value ' + //
          'FROM flat_db.counters c ' + //
          'where c.id=:id; '; //;

        parameters.ParamValues['id'] := aId;
        Active := false;
    Active := true;
        Result.Id := FieldByName('id').AsInteger;
        Result.SerialNumber := FieldByName('serialNumber').AsString;
        Result.LastCheckDate := FieldByName('lastCheckDate').AsDateTime;
        Result.NextCheckDate := FieldByName('nextCheckDate').AsDateTime;
        if not (FieldByName('value').IsNull) then
          Result.CounterDataLastRecord.Value := FieldByName('value').AsFloat;
        if not (FieldByName('measureDateTime').IsNull) then
          Result.CounterDataLastRecord.MeasureDateTime := FieldByName('measureDateTime').AsDateTime;
        Close();
      end;
    except
      on E: Exception do
        l.LogStr('error=' + E.Message, tlpError);
    end;
  finally
    q.Free();
    l.Free;
  end;
end;

class function TCountersController.InsertCounter(var aC: TCounter): integer;
var
  q: TADOQuery;
  l: TLDSLogger;
begin
  q := TADOQuery.Create(nil);
  l := TLDSLogger.Create(logFileName);
  try
    try
      with q do
      begin
         Connection := Db.ADOConnection;
        sql.Text := 'INSERT INTO `flat_db`.`counters` ' + //
          '(`serialNumber`, `lastCheckDate`, `nextCheckDate`) ' + //
          'VALUES (:serialNumber, :lastCheckDate, :nextCheckDate);';
        parameters.ParamValues['serialNumber'] := aC.SerialNumber;
        parameters.ParamValues['lastCheckDate'] := FormatDateTime('yyyy-mm-dd hh:mm:ss', aC.LastCheckDate);
        parameters.ParamValues['nextCheckDate'] := FormatDateTime('yyyy-mm-dd hh:mm:ss', aC.NextCheckDate);
        ExecSQL();
        result := TCommon.GetLastInsertID();
      end;
    except
      on E: Exception do
        l.LogStr('error=' + E.Message, tlpError);
    end;
  finally
    q.Free();
    l.Free;
  end;
end;

class procedure TCountersController.InsertCounterData(aCounterId: integer; aValue: double);
var
  q: TADOQuery;
  l: TLDSLogger;
begin
  q := TADOQuery.Create(nil);
  l := TLDSLogger.Create(logFileName);
  try
    try
      with q do
      begin
          Connection := Db.ADOConnection;
        sql.Text := 'INSERT INTO `flat_db`.`counterdata` (`counters_id`, `value`) VALUES (:counters_id, :value);';
        parameters.ParamValues['counters_id'] := aCounterId;
        parameters.ParamValues['value'] := aValue;
        ExecSQL();
      end;
    except
      on E: Exception do
        l.LogStr('error=' + E.Message, tlpError);
    end;
  finally
    q.Free();
    l.Free();
  end;
end;

//
class function TCountersController.IsCounterAssociatedToFlat(aCounterId: integer): boolean;
var
  q: TADOQuery;
  l: TLDSLogger;
begin
  q := TADOQuery.Create(nil);
  l := TLDSLogger.Create(logFileName);
  try
    try
      with q do
      begin
          Connection := Db.ADOConnection;
        sql.Text := 'SELECT * FROM flat_db.flats where counters_id=:counters_id';
        parameters.ParamValues['counters_id'] := aCounterId;
        Active := false;
    Active := true;
        result := not IsEmpty;
        Close();
      end;
    except
      on E: Exception do
        l.LogStr('error=' + E.Message, tlpError);
    end;
  finally
    q.Free();
    l.Free();
  end;
end;

class function TCountersController.IsFlatHasCounter(aFlatId: integer): boolean;
var
  q: TADOQuery;
  l: TLDSLogger;
begin
  q := TADOQuery.Create(nil);
  l := TLDSLogger.Create(logFileName);
  try
    try
      with q do
      begin
          Connection := Db.ADOConnection;
        sql.Text := 'SELECT * FROM flat_db.flats where id=:id';
        parameters.ParamValues['id'] := aFlatId;
        Active := false;
    Active := true;
        result := not FieldByName('counters_id').IsNull;
        Close();
      end;
    except
      on E: Exception do
        l.LogStr('error=' + E.Message, tlpError);
    end;
  finally
    q.Free();
    l.Free();
  end;
end;

class function TCountersController.IsNewValueOk(aCounterId: integer; aNewValue: double): boolean;

  function getLastValue(): double;
  var
    q: TADOQuery;
    l: TLDSLogger;
  begin
    q := TADOQuery.Create(nil);
    l := TLDSLogger.Create(logFileName);
    try
      try
        with q do
        begin
            Connection := Db.ADOConnection;
          sql.Text := 'SELECT * FROM flat_db.counterdata where counters_id=:counters_id order by id desc limit 1;';
          parameters.ParamValues['counters_id'] := aCounterId;
         Active := false;
    Active := true;
          if (IsEmpty) or (FieldByName('value').IsNull) then
            result := -1
          else
            result := FieldByName('value').AsFloat;
          Close();
        end;
      except
        on E: Exception do
          l.LogStr('error=' + E.Message, tlpError);
      end;
    finally
      q.Free();
      l.Free();
    end;
  end;

var
  lastValue: Double;
begin
// get last value
  lastValue := getLastValue();
  if lastValue = -1 then
    result := true; // means no values in db
  result := (aNewValue > lastValue);
end;

class procedure TCountersController.LogAssociatonFlatToCounter(var aModel: TCountersUpdateHistory);
var
  q: TADOQuery;
  l: TLDSLogger;
begin
  q := TADOQuery.Create(nil);
  l := TLDSLogger.Create(logFileName);
  try
    try
      with q do
      begin
          Connection := Db.ADOConnection;
        if (aModel.CounterOld = nil) then // 1st add of counter to flat
        begin
          sql.Text := 'INSERT INTO `flat_db`.`countersupdatehistory` ' + //
            '(`flats_id`, `counters_id`) ' + //
            'VALUES (:flats_id, :counters_id);'; //
          parameters.ParamValues['flats_id'] := aModel.Flat.Id;
          parameters.ParamValues['counters_id'] := aModel.CounterNew.Id;
        end
        else
        begin
          sql.Text := 'INSERT INTO `flat_db`.`countersupdatehistory` ' + //
            '(`counterOldValue`, `flats_id`, `counters_id`, `countersOld_id`) ' + //
            'VALUES (:counterOldValue, :flats_id, :counters_id, :countersOld_id);'; //
          parameters.ParamValues['countersOld_id'] := aModel.CounterOld.Id;
          parameters.ParamValues['counterOldValue'] := aModel.CounterOld.CounterDataLastRecord.Value;
          parameters.ParamValues['flats_id'] := aModel.Flat.Id;
          parameters.ParamValues['counters_id'] := aModel.CounterNew.Id;
        end;
        ExecSQL();
      end;
    except
      on E: Exception do
        l.LogStr('error=' + E.Message, tlpError);
    end;
  finally
    q.Free();
    l.Free();
  end;
end;

class procedure TCountersController.Update(aC: TCounter; aId: integer);
var
  q: TADOQuery;
  l: TLDSLogger;
begin
  q := TADOQuery.Create(nil);
  l := TLDSLogger.Create(logFileName);
  try
    try
      with q do
      begin
         Connection := Db.ADOConnection;
        sql.Text := 'UPDATE `flat_db`.`counters` SET `serialNumber`=:serialNumber, ' + //
          '`lastCheckDate`=:lastCheckDate, `nextCheckDate`=:nextCheckDate WHERE `id`=:id;';
        parameters.ParamValues['serialNumber'] := aC.SerialNumber;
        parameters.ParamValues['lastCheckDate'] := FormatDateTime('yyyy-mm-dd hh:mm:ss', aC.LastCheckDate);
        parameters.ParamValues['nextCheckDate'] := FormatDateTime('yyyy-mm-dd hh:mm:ss', aC.NextCheckDate);
        parameters.ParamValues['id'] := aId;
        ExecSQL();
      end;
    except
      on E: Exception do
        l.LogStr('error=' + E.Message, tlpError);
    end;
  finally
    q.Free();
    l.Free();
  end;
end;

class procedure TCountersController.UpdateCounterInFlat(aCounterId, aFlatId: integer);
var
  q: TADOQuery;
  l: TLDSLogger;
begin
  q := TADOQuery.Create(nil);
  l := TLDSLogger.Create(logFileName);
  try
    try
      with q do
      begin
          Connection := Db.ADOConnection;
        sql.Text := 'UPDATE `flat_db`.`flats` SET `counters_id`=:counters_id WHERE `id`=:id;';
        parameters.ParamValues['counters_id'] := aCounterId;
        parameters.ParamValues['id'] := aFlatId;
        ExecSQL;
      end;
    except
      on E: Exception do
        l.LogStr('error=' + E.Message, tlpError);
    end;
  finally
    l.Free();
    q.Free();
  end;
end;

end.

