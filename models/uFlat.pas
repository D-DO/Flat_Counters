unit uFlat;

interface

uses
  uHouseNumber, System.Classes;

type
  TFlat = class(TComponent)
  private
    FFlatNumber: integer;
    FId: integer;
    FHouseNumber: THouseNumber;
    procedure SetFlatNumber(const Value: integer);
    procedure SetHouseNumber(const Value: THouseNumber);
    procedure SetId(const Value: integer);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Id: integer read FId write SetId;
    property FlatNumber: integer read FFlatNumber write SetFlatNumber;
    property HouseNumber: THouseNumber read FHouseNumber write SetHouseNumber;
  end;

implementation

{ TFlat }

constructor TFlat.Create(AOwner: TComponent);
begin
  inherited;
  FHouseNumber := THouseNumber.Create(nil);
end;

destructor TFlat.Destroy;
begin
  FHouseNumber.Free();
  inherited;
end;

procedure TFlat.SetFlatNumber(const Value: integer);
begin
  FFlatNumber := Value;
end;

procedure TFlat.SetHouseNumber(const Value: THouseNumber);
begin
  FHouseNumber := Value;
end;

procedure TFlat.SetId(const Value: integer);
begin
  FId := Value;
end;

end.

