unit UThread;

{ Copyright (c) 2016 by Albert Molina

  Acknowledgements:
    Herman Schoenfeld <herman@sphere10.com> author of TPipelineQueue (2019)

  Distributed under the MIT software license, see the accompanying file LICENSE
  or visit http://www.opensource.org/licenses/mit-license.php.

  This unit is a part of the PascalCoin Project, an infinitely scalable
  cryptocurrency. Find us here:
  Web: https://www.pascalcoin.org
  Source: https://github.com/PascalCoin/PascalCoin

  If you like it, consider a donation using Bitcoin:
  16K3HCZRhFUtM8GdWRcfKeaa6KsuyxZaYk

  THIS LICENSE HEADER MUST NOT BE REMOVED.
}

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  {$IFDEF WINDOWS}
  Windows,
  {$ENDIF}
{$ELSE}
  {$IFDEF LINUX}cthreads,{$ENDIF}
{$ENDIF}
  {$IFNDEF FPC}System.Generics.Collections{$ELSE}Generics.Collections{$ENDIF},
  Classes, SyncObjs, SysUtils, UBaseTypes, UThread.CriticalSection;

{$I ..\..\Input\config.inc}

Type
  TPCThread = Class;
  TPCThreadClass = Class of TPCThread;
  TPCThread = Class(TThread)
  private
    FDebugStep: String;
    FStartTickCount : TTickCount;
  protected
    procedure DoTerminate; override;
    procedure Execute; override;
    procedure BCExecute; virtual; abstract;
  public
    Class function ThreadClassFound(tclass : TPCThreadClass; Exclude : TObject) : Integer;
    Class function ThreadCount : Integer;
    Class function GetThread(index : Integer) : TPCThread;
    Class function GetThreadByClass(tclass : TPCThreadClass; Exclude : TObject) : TPCThread;
    Class Procedure ProtectEnterCriticalSection(Sender : TObject; var Lock : TPCCriticalSection);
    Class Function TryProtectEnterCriticalSection(Sender : TObject; MaxWaitMilliseconds : Cardinal; var Lock : TPCCriticalSection) : Boolean;
    Class Procedure ThreadsListInfo(list: TStrings);
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
    Property DebugStep : String read FDebugStep write FDebugStep;
    Property StartTickCount : TTickCount read FStartTickCount;
    property Terminated;
  End;

implementation

uses
  ULog, UConst,
  UThread.ThreadList,
  UThread.CriticalSectionList;


{ TPCThread }

constructor TPCThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  {$IFDEF HIGHLOG}TLog.NewLog(ltdebug,Classname,'Created Thread '+IntToHex(PtrInt(Self),16));{$ENDIF}
end;

destructor TPCThread.Destroy;
begin

  inherited Destroy;
end;

procedure TPCThread.DoTerminate;
begin
  inherited DoTerminate;
end;

procedure TPCThread.Execute;
Var l : TList<TPCThread>;
  {$IFDEF HIGHLOG}i : Integer;{$ENDIF}
begin
  FStartTickCount := TPlatform.GetTickCount;
  FDebugStep := '';
  {$IFDEF HIGHLOG}i := {$ENDIF}_threads.Add(Self);
  try
    {$IFDEF HIGHLOG}TLog.NewLog(ltdebug,Classname,'Starting Thread '+IntToHex(PtrInt(Self),16)+' in pos '+inttostr(i+1));{$ENDIF}
    Try
      Try
        BCExecute;
        FDebugStep := 'Finalized BCExecute';
      Finally
        Terminate;
      End;
    Except
      On E:Exception do begin
        TLog.NewLog(lterror,Classname,'Exception inside a Thread at step: '+FDebugStep+' ('+E.ClassName+'): '+E.Message);
        Raise;
      end;
    End;
  finally
    if Assigned(_threads) then begin
      l := _threads.LockList;
      Try
        {$IFDEF HIGHLOG}i := {$ENDIF}l.Remove(Self);
        {$IFDEF HIGHLOG}TLog.NewLog(ltdebug,Classname,'Finalizing Thread in pos '+inttostr(i+1)+'/'+inttostr(l.Count+1)+' working time: '+FormatFloat('0.000',TPlatform.GetElapsedMilliseconds(FStartTickCount) / 1000)+' sec');{$ENDIF}
      Finally
        _threads.UnlockList;
      End;
    end;
  end;
end;

class function TPCThread.GetThread(index: Integer): TPCThread;
Var l : TList<TPCThread>;
begin
  Result := Nil;
  l := _threads.LockList;
  try
    if (index<0) or (index>=l.Count) then exit;
    Result := TPCThread(l[index]);
  finally
    _threads.UnlockList;
  end;
end;

class function TPCThread.GetThreadByClass(tclass: TPCThreadClass; Exclude: TObject): TPCThread;
Var l : TList<TPCThread>;
  i : Integer;
begin
  Result := Nil;
  if Not Assigned(_threads) then exit;
  l := _threads.LockList;
  try
    for i := 0 to l.Count - 1 do begin
      if (TPCThread(l[i]) is tclass) And ((l[i])<>Exclude) then begin
        Result := TPCThread(l[i]);
        exit;
      end;
    end;
  finally
    _threads.UnlockList;
  end;
end;

class procedure TPCThread.ProtectEnterCriticalSection(Sender : TObject; var Lock: TPCCriticalSection);
begin
  {$IFDEF HIGHLOG}
  if Not Lock.TryEnter then begin
    Lock.Acquire;
  end;
  {$ELSE}
 // ShowMessage( Lock.ClassName );
  Lock.Acquire;
  {$ENDIF}
end;

class function TPCThread.ThreadClassFound(tclass: TPCThreadClass; Exclude : TObject): Integer;
Var l : TList<TPCThread>;
begin
  Result := -1;
  if Not Assigned(_threads) then exit;
  l := _threads.LockList;
  try
    for Result := 0 to l.Count - 1 do begin
      if (TPCThread(l[Result]) is tclass) And ((l[Result])<>Exclude) then exit;
    end;
    Result := -1;
  finally
    _threads.UnlockList;
  end;
end;

class function TPCThread.ThreadCount: Integer;
Var l : TList<TPCThread>;
begin
  l := _threads.LockList;
  try
    Result := l.Count;
  finally
    _threads.UnlockList;
  end;
end;

class procedure TPCThread.ThreadsListInfo(list: TStrings);
Var l : TList<TPCThread>;
  i : Integer;
begin
  l := _threads.LockList;
  try
    list.BeginUpdate;
    list.Clear;
    for i := 0 to l.Count - 1 do begin
      list.Add(Format('%.2d/%.2d <%s> Time:%s sec - Step: %s',[i+1,l.Count,TPCThread(l[i]).ClassName,FormatFloat('0.000',(TPlatform.GetElapsedMilliseconds(TPCThread(l[i]).FStartTickCount) / 1000)),TPCThread(l[i]).DebugStep] ));
    end;
    list.EndUpdate;
  finally
    _threads.UnlockList;
  end;
end;

class function TPCThread.TryProtectEnterCriticalSection(Sender: TObject;
  MaxWaitMilliseconds: Cardinal; var Lock: TPCCriticalSection): Boolean;
Var tc : TTickCount;
  {$IFDEF HIGHLOG}
  tc2,tc3,lockStartedTimestamp : TTickCount;
  lockCurrThread : TThreadID;
  lockWatingForCounter : Cardinal;
  s : String;
  {$ENDIF}
begin
  tc := TPlatform.GetTickCount;
  if MaxWaitMilliseconds>60000 then MaxWaitMilliseconds := 60000;
  {$IFDEF HIGHLOG}
  lockWatingForCounter := Lock.WaitingForCounter;
  lockStartedTimestamp := Lock.StartedTickCount;
  lockCurrThread := Lock.CurrentThread;
  {$ENDIF}
  Repeat
    Result := Lock.TryEnter;
    if Not Result then sleep(10);
  Until (Result) Or (TPlatform.GetElapsedMilliseconds(tc)>MaxWaitMilliseconds);
  {$IFDEF HIGHLOG}
  if Not Result then begin
    tc2 := TPlatform.GetTickCount;
    if lockStartedTimestamp=0 then lockStartedTimestamp := Lock.StartedTickCount;
    if lockStartedTimestamp=0 then tc3 := 0
    else tc3 := tc2-lockStartedTimestamp;
    s := Format('Cannot Protect a critical section %s %s class %s after %d milis locked by %s waiting %d-%d elapsed milis: %d',
      [IntToHex(PtrInt(Lock),16),Lock.Name,
      Sender.ClassName,tc2-tc,
      IntToHex(lockCurrThread,16)+'-'+IntToHex(Lock.CurrentThread,16),
      lockWatingForCounter,Lock.WaitingForCounter,
      tc3
      ]);
    TLog.NewLog(ltdebug,Classname,s);
  end;
  {$ENDIF}
end;

end.
