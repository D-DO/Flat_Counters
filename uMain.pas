unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls,
  // my
  //uDb, //
  uFlatsFrame, //
  uCountersFrame, //
 // LDSLogger,
  //uCommon,
  //
  Vcl.ExtCtrls, //
  Vcl.AppEvnts,
  //Data.DB,
  Data.Win.ADODB, Vcl.Grids, Vcl.DBGrids, Data.DB; //

type
  TMainForm = class(TForm)
    PageControl1: TPageControl;
    tsFlats: TTabSheet;
    tsCounters: TTabSheet;
    StatusBar: TStatusBar;
    Timer: TTimer;
    ApplicationEvents: TApplicationEvents;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
  private
    { Private declarations }
    //FLDSLogger: TLDSLogger;
    FlatsFrame: TFlatsFrame;
    CountersFrame: TCountersFrame;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { Public declarations }
  end;

var
  MainForm: TMainForm;

const
  logFileName = 'log.txt';

implementation

{$R *.dfm}

procedure TMainForm.ApplicationEventsException(Sender: TObject; E: Exception);
begin
 // FLDSLogger.LogStr('error=' + E.Message, tlpError);
end;

constructor TMainForm.Create(AOwner: TComponent);
begin
  inherited;
  ReportMemoryLeaksOnShutdown := true;
end;

destructor TMainForm.Destroy;
begin
 // FLDSLogger.Free();
  inherited;
end;

procedure TMainForm.FormCreate(Sender: TObject);
//var
 // db: TDb;
begin
  //flatsFrame
 // db := Tdb.Create(Self);
  FlatsFrame := TFlatsFrame.Create(Self);
  FlatsFrame.Parent := tsFlats;
  FlatsFrame.Align := alClient;
  FlatsFrame.Init;
  FlatsFrame.Show();
  //countersFrame
  CountersFrame := TCountersFrame.Create(Self);
  CountersFrame.Parent := tsCounters;
  CountersFrame.Align := alClient;
  CountersFrame.Init;
  CountersFrame.Show();
  //
//  FLDSLogger := TLDSLogger.Create(logFileName);
end;

procedure TMainForm.TimerTimer(Sender: TObject);
begin
  StatusBar.Panels[0].Text := DateTimeToStr(Now());
end;

end.

