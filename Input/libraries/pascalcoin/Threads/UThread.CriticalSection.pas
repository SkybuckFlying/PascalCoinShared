unit UThread.CriticalSection;

interface

uses
  SyncObjs, UBaseTypes, Classes, System.Generics.Collections;

type
  TPCCriticalSection = Class(TCriticalSection)
  private
    FCounterLock : TCriticalSection;
    FWaitingForCounter : Integer;
    mLocks : uint64;
    mUnlocks : uint64;
    mTryEnterSuccesses : uint64;
    mTryEnterFails : uint64;
    FCurrentThread : Cardinal;
    FStartedTickCount : TTickCount;
    FName : String;
  public
    Constructor Create(const AName : String);
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    Destructor Destroy; override;
    {$IFDEF HIGHLOG}
    procedure Acquire; override;
    procedure Release; override;
    function TryEnter: Boolean; { HS - had 'override' in development }
    {$ELSE}
    procedure Acquire; override;
    procedure Release; override;
    function TryEnter: Boolean;
    {$ENDIF}

    Property CurrentThread : Cardinal read FCurrentThread;
    Property WaitingForCounter : Integer read FWaitingForCounter;
    Property StartedTickCount : TTickCount read FStartedTickCount;  // Renamed from StartedTimestamp to StartedTickCount to avoid confusion
    Property Name : String read FName;

    Class Procedure CriticalSectionsListInfo(list: TStrings);
  end;

implementation

uses
  UThread.CriticalSectionList, SysUtils;

{ TPCCriticalSection }

constructor TPCCriticalSection.Create(const AName : String);
begin
  inherited Create;
  FCounterLock := TCriticalSection.Create;
  FWaitingForCounter := 0;
  FCurrentThread := 0;
  FStartedTickCount := 0;
  FName := AName;
  {$IFDEF HIGHLOG}TLog.NewLog(ltDebug,ClassName,'Created critical section '+IntToHex(PtrInt(Self),16)+' '+AName );{$ENDIF}
 end;

 procedure TPCCriticalSection.AfterConstruction;
 begin
  if _critical_sections <> nil then
  begin
    _critical_sections.Add( Self );
  end;
 end;

 procedure TPCCriticalSection.BeforeDestruction;
 begin
   if _critical_sections <> nil then
   begin
     _critical_sections.Remove( Self );
   end;
 end;

destructor TPCCriticalSection.Destroy;
begin
  FCounterLock.Free;
  inherited Destroy;
end;



class procedure TPCCriticalSection.CriticalSectionsListInfo(list: TStrings);
Var l : TList<TPCCriticalSection>;
  i : Integer;
begin
  l := _critical_sections.LockList;
  try
    list.BeginUpdate;
    list.Clear;
    for i := 0 to l.Count - 1 do begin
      list.Add
      (
        Format
        (
          '%.2d/%.2d <%s> mLocks: %ud   mUnlocks: %ud   mTryEntersSuccesses: %ud   mTryEntersFails: %ud   WaitForCounter: %d',
          [
            i+1,
            l.Count,
            TPCCriticalSection(l[i]).FName,
            TPCCriticalSection(l[i]).mLocks,
            TPCCriticalSection(l[i]).mUnLocks,
            TPCCriticalSection(l[i]).mTryEnterSuccesses,
            TPCCriticalSection(l[i]).mTryEnterFails,
            TPCCriticalSection(l[i]).FWaitingForCounter
          ]
        )
      );
    end;
    list.EndUpdate;
  finally
    _critical_sections.UnlockList;
  end;
end;

{$IFDEF HIGHLOG}
procedure TPCCriticalSection.Acquire;
Var continue, logged : Boolean;
  startTC, LLastTC : TTickCount;
  LWaitMillis : Int64;
begin
  startTC := TPlatform.GetTickCount;
  LLastTC := startTC;
  FCounterLock.Acquire;
  try
    FWaitingForCounter := FWaitingForCounter + 1;
  finally
    FCounterLock.Release;
  end;
  logged := false;
  LWaitMillis := 10000;
  Repeat
    continue := inherited TryEnter;
    if (Not continue) then begin
      If (TPlatform.GetElapsedMilliseconds(LLastTC)>LWaitMillis) then begin
        LLastTC := TPlatform.GetTickCount;
        inc(LWaitMillis,LWaitMillis);
        logged := true;
        TLog.NewLog(ltdebug,ClassName,'ALERT Critical section '+IntToHex(PtrInt(Self),16)+' '+Name+
          ' locked by '+IntToHex(FCurrentThread,16)+' waiting '+
          IntToStr(FWaitingForCounter)+' elapsed milis: '+IntToStr(TPlatform.GetElapsedMilliseconds(startTC)));
      end else sleep(10);
      sleep(10);
    end;
  Until continue;
  Inc(mLocks);
  if (logged) then begin
    TLog.NewLog(ltdebug,Classname,'ENTER Critical section '+IntToHex(PtrInt(Self),16)+' '+Name+' elapsed milis: '+IntToStr(TPlatform.GetElapsedMilliseconds(startTC)) );
  end;
  FCounterLock.Acquire;
  try
    FWaitingForCounter := FWaitingForCounter - 1;
  finally
    FCounterLock.Release;
  end;
  FCurrentThread := TThread.CurrentThread.ThreadID;
  FStartedTickCount := TPlatform.GetTickCount;
end;

procedure TPCCriticalSection.Release;
begin
  FCurrentThread := 0;
  FStartedTickCount := 0;
  Inc(mUnLocks);
  inherited Release;
end;

function TPCCriticalSection.TryEnter: Boolean;
begin
  FCounterLock.Acquire;
  try
    FWaitingForCounter := FWaitingForCounter + 1;
  finally
    FCounterLock.Release;
  end;
  If inherited TryEnter then begin
    FCurrentThread := TThread.CurrentThread.ThreadID;
    FStartedTickCount := TPlatform.GetTickCount;
    Inc(mLocks);
    Result := true;
  end else
    Result := false;
  FCounterLock.Acquire;
  try
    FWaitingForCounter := FWaitingForCounter - 1;
  finally
    FCounterLock.Release;
  end;
end;

{$ELSE}

procedure TPCCriticalSection.Acquire;
begin
  inherited Acquire;
  Inc(mLocks);
end;

procedure TPCCriticalSection.Release;
begin
  Inc(mUnLocks);
  inherited Release;
end;

function TPCCriticalSection.TryEnter: Boolean;
begin
  result := inherited TryEnter;
  if result then
  begin
    Inc(mTryEnterSuccesses);
  end else
  begin
    Inc(mTryEnterFails);
  end;
end;

{$ENDIF}

 end.
