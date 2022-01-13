unit UThread.CriticalSectionList;

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
  TPCCriticalSectionList<T> = class
  private
    FName : string;
    FList: TList<T>;
    FLock: TPCCriticalSection;
  public
    constructor Create(const AName : String);
    procedure AfterConstruction; override;
    destructor Destroy; override;
    function Add(Item: T) : Integer;
    function Count : Integer;
    procedure Clear;
    procedure Remove(Item: T); inline;
    function LockList: TList<T>;
    function TryLockList(MaxWaitMilliseconds : Cardinal; var lockedList : TList<T>) : Boolean;
    procedure UnlockList; inline;
  end;

Var _critical_sections : TPCCriticalSectionList<TPCCriticalSection>;

implementation

{ TPCCriticalSectionList }

function TPCCriticalSectionList<T>.Add(Item: T) : Integer;
begin
  LockList;
  Try
    Result := FList.Add(Item);
  Finally
    UnlockList;
  End;
end;

procedure TPCCriticalSectionList<T>.Clear;
begin
  LockList;
  Try
    FList.Clear;
  Finally
    UnlockList;
  End;
end;

constructor TPCCriticalSectionList<T>.Create(const AName : String);
begin
  inherited Create;
  FName := AName;
  FList := TList<T>.Create;
end;

procedure TPCCriticalSectionList<T>.AfterConstruction;
begin
//  _critical_sections := Self; // Compiler/Generics limitation: Not possible ?
  FLock := TPCCriticalSection.Create(FName);
end;

function TPCCriticalSectionList<T>.Count : Integer;
begin
  Result := FList.Count;
end;

destructor TPCCriticalSectionList<T>.Destroy;
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

function TPCCriticalSectionList<T>.LockList: TList<T>;
begin
  {$IFDEF HIGHLOG}
  if Not FLock.TryEnter then begin
    FLock.Acquire;
  end;
  {$ELSE}
  FLock.Acquire;
  {$ENDIF}
  Result := FList;
end;

procedure TPCCriticalSectionList<T>.Remove(Item: T);
begin
  LockList;
  try
    FList.Remove(Item);
  finally
    UnlockList;
  end;
end;

function TPCCriticalSectionList<T>.TryLockList(MaxWaitMilliseconds: Cardinal; var lockedList: TList<T>): Boolean;
begin
  lockedList := FList;
  Result := TPCThread.TryProtectEnterCriticalSection(Self,MaxWaitMilliseconds,FLock);
end;

procedure TPCCriticalSectionList<T>.UnlockList;
begin
  FLock.Release;
end;

initialization
  _critical_sections := nil;
  _critical_sections := TPCCriticalSectionList<TPCCriticalSection>.Create('GLOBAL_CRITICAl_SECTIONS');

  // work around for problem:
  if _critical_sections.FList.Count = 0 then
  begin
    _critical_sections.Add( _critical_sections.FLock );
  end;

finalization
  FreeAndNil(_critical_sections);

end.

