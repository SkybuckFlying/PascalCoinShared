unit UNetProtection;

{ Copyright (c) 2018 by Albert Molina

  Distributed under the MIT software license, see the accompanying file LICENSE
  or visit http://www.opensource.org/licenses/mit-license.php.

  This unit is a part of the PascalCoin Project, an infinitely scalable
  cryptocurrency. Find us here:
  Web: https://www.pascalcoin.org
  Source: https://github.com/PascalCoin/PascalCoin

  If you like it, consider a donation using Bitcoin:
  14qBrMavy2pW9umzuhd7eMDVpwQ62xRtPK

  THIS LICENSE HEADER MUST NOT BE REMOVED.
}

{
  This unit will include objects usefull for control statistical
  information about nodes IP's to decide if a IP is a scammer or is abusive.

  Information will be stored in a "TIpInfos" object class, thread protected,
  that will store statistical info for each IP and will return
  info based on Limits for decision

  Can be used both for a Node (p2p) and also for a JSON-RPC server
}

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{$I ../../Input/config.inc}

interface

Uses
  SysUtils, Classes,
  UThread,
  UThread.ThreadList,
  ULog, UTime, UBaseTypes,
  {$IFNDEF FPC}System.Generics.Collections{$ELSE}Generics.Collections{$ENDIF};


Type
  TIpInfo = Record
    ip : String;
  End;

  TLimitLifetime = Record
    MaxBackSeconds : Integer;
    MaxCalls : Integer;
    MaxSize : Integer;
    class function Create(AMaxBackSeconds,AMaxCalls,AMaxSize : Integer) : TLimitLifetime; static;
  End;
  TLimitsLifetimeArray = TArray<TLimitLifetime>;

  TIpInfos = Class
  private
    FThreadList : TPCThreadList<Pointer>;
    FMaxStatsLifetime: Integer;
    FMaxStatsCount: Integer;
    FDeletedStatsCount: Int64;
    FLastCleanedTC : TTickCount;
    function Find(lockedList : TList<Pointer>; const ip : String; var Index: Integer): Boolean;
    procedure SetMaxStatsLifetime(const Value: Integer);
    procedure CleanLastStatsByUpdatedTimestamp(minTimestamp : Integer);
    procedure SetMaxStatsCount(const Value: Integer);
  public
    Constructor Create;
    Destructor Destroy; override;
    procedure Lock(const AIp : String; MarkAsUpdated : Boolean); overload;
    function Lock(index : Integer) : TIpInfo; overload;
    procedure UpdateIpInfo(const AIp, netTransferType, opType : String; dataSize : Integer);
    function ReachesLimits(const AIp, netTransferType, opType : String; dataSize : Integer; const limits : TLimitsLifetimeArray) : Boolean;
    function Update_And_ReachesLimits(const AIp, netTransferType, opType : String; dataSize : Integer; DoUpdate: Boolean; const limits : TLimitsLifetimeArray) : Boolean;
    procedure LogDisconnect(const AIp, AReason : String; IsMyself : Boolean);
    procedure Unlock;
    procedure Clear;
    function Count : Integer;
    property MaxStatsLifetime : Integer read FMaxStatsLifetime write SetMaxStatsLifetime;
    property MaxStatsCount : Integer read FMaxStatsCount write SetMaxStatsCount;
    function CleanLastStats : Integer;
  End;

implementation

{ TIpInfos }

Type PIpInfo = ^TIpInfo;

function TIpInfos.CleanLastStats : Integer;
var LLastCleanedCount : Integer;
  LCurrTimestamp : Integer;
begin
  LCurrTimestamp := UnivDateTimeToUnix( DateTime2UnivDateTime(now) );
  LLastCleanedCount := FDeletedStatsCount;
  CleanLastStatsByUpdatedTimestamp(LCurrTimestamp - FMaxStatsLifetime);
  Result := FDeletedStatsCount-LLastCleanedCount;
  if (LLastCleanedCount<>FDeletedStatsCount) then begin
    TLog.NewLog(ltInfo,ClassName,Format('Cleaned %d old stats',[(FDeletedStatsCount-LLastCleanedCount)]));
  end;
end;

procedure TIpInfos.CleanLastStatsByUpdatedTimestamp(minTimestamp: Integer);
var
  iIp, i,j,k : Integer;
  list : TList<Pointer>;
  p : PIpInfo;
begin
  list := FThreadList.LockList;
  Try
    FLastCleanedTC := TPlatform.GetTickCount;
  Finally
    FThreadList.UnlockList;
  End;
end;

procedure TIpInfos.Clear;
var p : PIpInfo;
  i : Integer;
  list : TList<Pointer>;
begin
  list := FThreadList.LockList;
  Try
    for i := 0 to list.Count-1 do begin
      p := PIpInfo(list[i]);
      Dispose(p);
    end;
    FDeletedStatsCount := 0;
    list.Clear;
    FLastCleanedTC := TPlatform.GetTickCount;
  Finally
    FThreadList.UnlockList;
  End;
end;

function TIpInfos.Count: Integer;
begin
  Result := FThreadList.LockList.Count;
  Unlock;
end;

constructor TIpInfos.Create;
begin
  FThreadList := TPCThreadList<Pointer>.Create(Self.ClassName);
  FMaxStatsLifetime := 60*60*24; // Last values by 24 hours by default
  FMaxStatsCount := 1000; // Max 1000 last stats by default
  FDeletedStatsCount := 0;
  FLastCleanedTC := TPlatform.GetTickCount;
end;

destructor TIpInfos.Destroy;
begin
  Clear;
  FreeAndNil(FThreadList);
  inherited;
end;

function TIpInfos.Find(lockedList : TList<Pointer>; const ip: String; var Index: Integer): Boolean;
var L, H, I, C: Integer;
  PN : PIpInfo;
begin
  Result := False;
  L := 0;
  H := lockedList.Count - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    PN := lockedList.Items[I];
    C := CompareStr( PN^.ip, ip );
    if C < 0 then L := I + 1 else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := True;
        L := I;
      end;
    end;
  end;
  Index := L;
end;

function TIpInfos.Lock(index: Integer): TIpInfo;
var list : TList<Pointer>;
begin
  list := FThreadList.LockList;
  if (list.Count>index) then begin
    Result := PIpInfo(list[index])^;
  end else begin
    Result.ip := '';
  end;
end;

procedure TIpInfos.LogDisconnect(const AIp, AReason : String; IsMyself : Boolean);
var
  msg : String;
  i : Integer;
  currts : Integer;
  lastUpdatedTs : Integer;
begin
  // Disconnect will store at /disconnect in objects
  currts := UnivDateTimeToUnix( DateTime2UnivDateTime(now) );
  Lock(AIp,True);
  Unlock;
end;

procedure TIpInfos.Lock(const AIp: String; MarkAsUpdated: Boolean);
var list : TList<Pointer>;
  i : Integer;
  p : PIpInfo;
begin
  list := FThreadList.LockList;
  if Not Find(list,AIp,i) then begin
    new(p);
    p^.ip := AIp;
    list.Insert(i,p);
  end else p := list[i];
end;

function TIpInfos.ReachesLimits(const AIp, netTransferType, opType: String; dataSize : Integer; const limits : TLimitsLifetimeArray): Boolean;
begin
  Result := Update_And_ReachesLimits(AIp,netTransferType,opType,dataSize,False,limits);
end;

procedure TIpInfos.SetMaxStatsCount(const Value: Integer);
var currts : Integer;
begin
  if FMaxStatsCount=Value then Exit;
  if Value<=0 then FMaxStatsCount := 1
  else FMaxStatsCount := Value;
  currts := UnivDateTimeToUnix( DateTime2UnivDateTime(now) );
  CleanLastStatsByUpdatedTimestamp(currts - FMaxStatsLifetime);
end;

procedure TIpInfos.SetMaxStatsLifetime(const Value: Integer);
var currts : Integer;
begin
  if FMaxStatsLifetime=Value then Exit;
  if Value<=0 then
    FMaxStatsLifetime := 1
  else FMaxStatsLifetime := Value;
  currts := UnivDateTimeToUnix( DateTime2UnivDateTime(now) );
  CleanLastStatsByUpdatedTimestamp(currts - FMaxStatsLifetime);
end;

procedure TIpInfos.Unlock;
begin
  FThreadList.UnlockList;
end;

procedure TIpInfos.UpdateIpInfo(const AIp, netTransferType, opType: String; dataSize: Integer);
begin
  Update_And_ReachesLimits(AIp,netTransferType,opType,dataSize,True,Nil);
end;

function TIpInfos.Update_And_ReachesLimits(const AIp, netTransferType, opType: String; dataSize: Integer; DoUpdate: Boolean; const limits: TLimitsLifetimeArray): Boolean;
var
  currts : Integer;
  i, j, lastUpdatedTs : Integer;
  countLimitsValues : TLimitsLifetimeArray;
begin
  Result := False;
  setLength(countLimitsValues,Length(limits));
  for j :=Low(countLimitsValues) to High(countLimitsValues) do begin
    countLimitsValues[j].MaxBackSeconds := limits[j].MaxBackSeconds;
    countLimitsValues[j].MaxCalls := 0;
    countLimitsValues[j].MaxSize := 0;
  end;

  currts := UnivDateTimeToUnix( DateTime2UnivDateTime(now) );
  Lock(AIp,DoUpdate);
  Try
    if (DoUpdate) then
    begin
    end;
    if TPlatform.GetElapsedMilliseconds( FLastCleanedTC ) > (FMaxStatsLifetime * 1000) then begin ///  Clean stats auto
      CleanLastStats;
    end;
  Finally
    Unlock;
    {$IFDEF TESTNET}
    // For testing purposes, TESTNET will log when reaches limits but will not return a True value
    Result := False;
    {$ENDIF}
  End;
  setLength(countLimitsValues,0);
end;

{ TLimitLifetime }

class function TLimitLifetime.Create(AMaxBackSeconds, AMaxCalls, AMaxSize: Integer): TLimitLifetime;
begin
  Result.MaxBackSeconds := AMaxBackSeconds;
  Result.MaxCalls := AMaxCalls;
  Result.MaxSize := AMaxSize;
end;

end.

