unit UThread.ThreadList;

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
  Classes, SyncObjs, SysUtils, UBaseTypes,
  UThread,
  UThread.CriticalSection;

{$I ..\..\Input\config.inc}

type
  TPCThreadList<T> = class
  private
    FList: TList<T>;
    FLock: TPCCriticalSection;
  public
    constructor Create(const AName : String);
    destructor Destroy; override;
    function Add(Item: T) : Integer;
    function Count : Integer;
    procedure Clear;
    procedure Remove(Item: T); inline;
    function LockList: TList<T>;
    function TryLockList(MaxWaitMilliseconds : Cardinal; var lockedList : TList<T>) : Boolean;
    procedure UnlockList; inline;
  end;

Var _threads : TPCThreadList<TPCThread>;

implementation

{ TPCThreadList }

function TPCThreadList<T>.Add(Item: T) : Integer;
begin
  LockList;
  Try
    Result := FList.Add(Item);
  Finally
    UnlockList;
  End;
end;

procedure TPCThreadList<T>.Clear;
begin
  LockList;
  Try
    FList.Clear;
  Finally
    UnlockList;
  End;
end;

constructor TPCThreadList<T>.Create(const AName : String);
begin
  inherited Create;

  FLock := TPCCriticalSection.Create(AName);
  FList := TList<T>.Create;
end;

function TPCThreadList<T>.Count : Integer;
begin
  Result := FList.Count;
end;

destructor TPCThreadList<T>.Destroy;
begin
  LockList;
  try
    FreeAndNil(FList);
  finally
    UnlockList;
    FreeAndNil(FLock);
  end;
  inherited Destroy;
end;

function TPCThreadList<T>.LockList: TList<T>;
begin
  TPCThread.ProtectEnterCriticalSection(Self,FLock);
  Result := FList;
end;

procedure TPCThreadList<T>.Remove(Item: T);
begin
  LockList;
  try
    FList.Remove(Item);
  finally
    UnlockList;
  end;
end;

function TPCThreadList<T>.TryLockList(MaxWaitMilliseconds: Cardinal; var lockedList: TList<T>): Boolean;
begin
  lockedList := FList;
  Result := TPCThread.TryProtectEnterCriticalSection(Self,MaxWaitMilliseconds,FLock);
end;

procedure TPCThreadList<T>.UnlockList;
begin
  FLock.Release;
end;


initialization
  _threads := nil;
  _threads := TPCThreadList<TPCThread>.Create('GLOBAL_THREADS');

finalization
  FreeAndNil(_threads);


end.

