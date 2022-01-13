unit UThread.Pipeline;

interface

uses
  Classes, SyncObjs, SysUtils,
  UThread,
  {$IFNDEF FPC}System.Generics.Collections{$ELSE}Generics.Collections{$ENDIF};

type
  { TPipelineQueue }
  TPipelineQueue<T> = class(TComponent)
  private type

    { TStageQueue }

    TStageQueue = class
    private
      FDirty : Boolean;
      FLock : TMultiReadExclusiveWriteSynchronizer;
      FItems : TList<T>;
      function GetDirty : Boolean;
      procedure SetDirty (AValue : Boolean);
      function GetItems : TArray<T>;
    public
      constructor Create; overload;
      destructor Destroy; override;
      property Dirty : Boolean read GetDirty write SetDirty;
      property Lock : TMultiReadExclusiveWriteSynchronizer read FLock;
      property Items : TArray<T> read GetItems;
    end;

    { TErrorResult }

    TErrorResult = record
     Item : T;
     ErrorMessage : String;
    end;

    { TPipelineWorkerThread}

    TPipelineWorkerThread = class(TPCThread)
    private
      FPipeline : TPipelineQueue<T>;
      FStage : Integer;
    protected
      procedure BCExecute; override;
    public
      constructor Create(const APipelineQueue : TPipelineQueue<T>; AStage : Integer); overload;
    end;

  private
    FQueues : TList<TStageQueue>;
    FMaxWorkerThreads : Integer;
    FActiveWorkerThreads : Integer;
    {$IFDEF UNITTESTS}
    FHistoricalMaxActiveWorkerThreads : Integer;
    {$ENDIF}
    procedure Initialize(AStageCount : Integer; AMaxWorkerThreadCount : Integer);
    procedure Enqueue(AStage : Integer; const AItem : T); overload;
    procedure EnqueueRange(AStage : Integer; const AItems : array of T); overload;
    procedure NotifyPipelineAppended(AStage : Integer);
    function GetStageCount : Integer; inline;
    function GetHasCompleted : Boolean;
  protected
    function ProcessStage(AStageNum : Integer; const AItems : TArray<T>; out AErrors : TArray<TErrorResult>) : TArray<T>; virtual; abstract;
    procedure HandleErrorItems(const AErrorItems : array of TErrorResult); virtual; abstract;
    procedure HandleFinishedItems(const AItems : array of T); virtual; abstract;
  public
    property StageCount : Integer read GetStageCount;
    property HasCompleted : Boolean read GetHasCompleted;
    {$IFDEF UNITTESTS}
    property HistoricalMaxActiveWorkerThreads : Integer read FHistoricalMaxActiveWorkerThreads;
    {$ENDIF}
    constructor Create(AOwner : TComponent; AStageCount, AMaxWorkerThreads : Integer); overload;
    destructor Destroy; override;
    procedure Enqueue(const AItem : T); overload;
    procedure EnqueueRange(const AItems : array of T); overload;
  end;

implementation

{ TPipelineQueue }

constructor TPipelineQueue<T>.Create(AOwner : TComponent; AStageCount, AMaxWorkerThreads : Integer);
begin
  inherited Create(AOwner);
  Initialize(AStageCount, AMaxWorkerThreads);
end;

destructor TPipelineQueue<T>.Destroy;
var i : Integer;
begin
  for i := 0 to FQueues.Count - 1 do
    FQueues[i].Destroy;
  FreeAndNil(FQueues);
  inherited Destroy;
end;

procedure TPipelineQueue<T>.Initialize(AStageCount : Integer; AMaxWorkerThreadCount : Integer);
var i : integer;
begin
  if AStageCount <= 0 then raise EArgumentException.Create('AStageCount must be greater than 0');
  if AMaxWorkerThreadCount <= 0 then raise EArgumentException.Create('AMaxWorkerThreadCount must be greater than 0');
  FMaxWorkerThreads := AMaxWorkerThreadCount;
  FActiveWorkerThreads := 0;
  FQueues := TList<TStageQueue>.Create;
  for i := 0 to AStageCount - 1 do begin
    FQueues.Add(  TStageQueue.Create );
  end;
end;

procedure TPipelineQueue<T>.Enqueue(AStage : Integer; const AItem : T);
begin
  EnqueueRange(AStage, [AItem]);
end;

procedure TPipelineQueue<T>.EnqueueRange(AStage : Integer; const AItems : array of T);
begin
  FQueues[AStage].Lock.BeginWrite;
  try
    FQueues[AStage].FDirty := True;
    FQueues[AStage].FItems.AddRange(AItems);
  finally
    FQueues[AStage].Lock.EndWrite;
  end;
  NotifyPipelineAppended(AStage);
end;

procedure TPipelineQueue<T>.Enqueue(const AItem : T);
begin
  Enqueue(0, AItem);
end;

procedure TPipelineQueue<T>.EnqueueRange(const AItems : array of T);
begin
  EnqueueRange(0, AItems);
end;

procedure TPipelineQueue<T>.NotifyPipelineAppended(AStage : Integer);
begin
  if (FActiveWorkerThreads = 0) OR (FActiveWorkerThreads < FMaxWorkerThreads) then begin
    // Start a new worker thread to process
    TPipelineWorkerThread.Create(Self, AStage);
    {$IFDEF UNITTESTS}
    if (FActiveWorkerThreads > FHistoricalMaxActiveWorkerThreads) then
      FHistoricalMaxActiveWorkerThreads := FActiveWorkerThreads;
    {$ENDIF}
  end;
end;

function TPipelineQueue<T>.GetStageCount : Integer;
begin
  Result := FQueues.Count;
end;

function TPipelineQueue<T>.GetHasCompleted : Boolean;
var i : Integer;
begin
  if FActiveWorkerThreads > 0 then Exit(False);
  for i := 0 to FQueues.Count - 1 do
    if FQueues[i].Dirty then Exit(False);
  Result := true;
end;

{ TPipelineQueue<T>.TStageQueue }

constructor TPipelineQueue<T>.TStageQueue.Create;
begin
  inherited;
  FDirty := False;
  FLock := TMultiReadExclusiveWriteSynchronizer.Create;
  FItems := TList<T>.Create;
end;

destructor TPipelineQueue<T>.TStageQueue.Destroy;
begin
  inherited;
  FreeAndNil(FLock);
  FreeAndNil(FItems);
end;

function TPipelineQueue<T>.TStageQueue.GetDirty : Boolean;
begin
  FLock.BeginRead;
  try
    Result := FDirty;
  finally
    FLock.EndRead;
  end;
end;

procedure TPipelineQueue<T>.TStageQueue.SetDirty ( AValue : Boolean );
begin
  FLock.BeginWrite;
  try
    FDirty := AValue;
  finally
    FLock.EndWrite;
  end;
end;

function TPipelineQueue<T>.TStageQueue.GetItems : TArray<T>;
begin
  begin
    FLock.BeginRead;
    try
      Result := FItems.ToArray;
    finally
      FLock.EndRead;
    end;
  end;
end;

{ TPipelineQueue<T>.TPipelineWorkerThread }

constructor TPipelineQueue<T>.TPipelineWorkerThread.Create(const APipelineQueue : TPipelineQueue<T>; AStage : Integer);
begin
 inherited Create(True);
 Self.FreeOnTerminate := true;
 FPipeline := APipelineQueue;
 FStage := AStage;
 Inc(FPipeline.FActiveWorkerThreads);
 Self.Start;
end;

procedure TPipelineQueue<T>.TPipelineWorkerThread.BCExecute;
var
  i, j : Integer;
  LHasMore : Boolean;
  LIn : TArray<T>;
  LOut : TArray<T>;
  LErrorOut : TArray<TErrorResult>;
begin
  try
    repeat
      // protect against excessive worker threads
      if FPipeline.FActiveWorkerThreads > FPipeline.FMaxWorkerThreads then exit;

      // double-check ensure still dirty
      if not FPipeline.FQueues[FStage].FDirty then exit;

      // Extract items from pipeline stage
      FPipeline.FQueues[FStage].Lock.BeginWrite;
      try
        LIn := FPipeline.FQueues[FStage].FItems.ToArray;
        FPipeline.FQueues[FStage].FItems.Clear;
        FPipeline.FQueues[FStage].FDirty := False;
      finally
        FPipeline.FQueues[FStage].Lock.EndWrite;
      end;

      // process items
      LOut := FPipeline.ProcessStage(FStage, LIn, LErrorOut);

      // process errors
      if Length(LErrorOut) > 0 then
        FPipeline.HandleErrorItems(LErrorOut);

      // send output to next queue (or finish)
      if FStage < FPipeline.StageCount - 1 then
        FPipeline.EnqueueRange(FStage + 1, LOut)
      else
        FPipeline.HandleFinishedItems(LOut);

      // keep working until all stages are completed
      LHasMore := False;
      for i := 0 to FPipeline.FQueues.Count - 1 do begin
        if FPipeline.FQueues[i].Dirty then begin
          FStage := i;
          LHasMore := True;
          break;
        end;
      end;
    until not LHasMore;
  finally
    Dec(FPipeline.FActiveWorkerThreads);
  end;
end;

end.
