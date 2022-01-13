unit UFRMCriticalSections;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFRMCriticalSections = class(TForm)
    Panel1: TPanel;
    LabelInMilliseconds: TLabel;
    LabeledEditRefreshInterval: TLabeledEdit;
    TimerRefresh: TTimer;
    MemoCriticalSections: TMemo;
    procedure TimerRefreshTimer(Sender: TObject);
    procedure LabeledEditRefreshIntervalExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure UpdateInformation;
  end;

var
  FRMCriticalSections: TFRMCriticalSections;

implementation

{$R *.dfm}

uses
  UThread.CriticalSection;

procedure TFRMCriticalSections.LabeledEditRefreshIntervalExit(Sender: TObject);
var
  vRefreshInterval : integer;
begin
  if TryStrToInt( LabeledEditRefreshInterval.Text, vRefreshInterval ) then
  begin
    if (vRefreshInterval < 1) then
    begin
      ShowMessage('It is not allowed to set refresh interval lower than 1 milliseconds');
      exit;
    end;
    if (vRefreshInterval > 2000000000) then
    begin
      ShowMessage('It is not allowed to set refresh interval higher than 2000000000 milliseconds');
      exit;
    end;

     TimerRefresh.Interval := vRefreshInterval;
  end else
  begin
    ShowMessage('Refresh interval set incorrectly');
  end;
end;

procedure TFRMCriticalSections.TimerRefreshTimer(Sender: TObject);
begin
  UpdateInformation;
end;

procedure TFRMCriticalSections.UpdateInformation;
begin
  TPCCriticalSection.CriticalSectionsListInfo( MemoCriticalSections.Lines );
end;

end.
