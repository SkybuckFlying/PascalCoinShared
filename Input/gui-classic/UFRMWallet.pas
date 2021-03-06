unit UFRMWallet;

interface

{$I ..\..\Input\config.inc}

uses
  pngimage, Windows, AppEvnts, ShlObj,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, UWallet, StdCtrls, ULog, Grids, UAppParams, UBlockChain,
  UNode, UGridUtils, UAccounts, Menus, ImgList, UNetProtocol,
  UCrypto, Buttons, UFRMAccountSelect, UConst,
  UAccountKeyStorage, UBaseTypes, UPCDataTypes, UOrderedList,
  UTxMultiOperation, USettings, UEPasa,
  UFRMWalletUserMessages,
  UFrameAccountExplorer,
  UFramePendingOperations,
  UFrameMessages,
  UFrameNodeStats,
  UFrameLogs,
  UFrameOperationsExplorer,
  UFrameBlockExplorer,
  UFrameInfo,
  System.Generics.Collections;

type
  { TFRMWallet }
  TFRMWallet = class(TForm)
    pnlTop: TPanel;
    StatusBar: TStatusBar;
    TimerUpdateStatus: TTimer;
    MainMenu: TMainMenu;
    miProject: TMenuItem;
    miOptions: TMenuItem;
    miPrivatekeys: TMenuItem;
    miN1: TMenuItem;
    miAbout: TMenuItem;
    miAboutPascalCoin: TMenuItem;
    miNewOperation: TMenuItem;
    N1: TMenuItem;
    MiClose: TMenuItem;
    MiDecodePayload: TMenuItem;
    IPnodes1: TMenuItem;
    MiOperations: TMenuItem;
    MiAddaccounttoSelected: TMenuItem;
    MiRemoveaccountfromselected: TMenuItem;
    N2: TMenuItem;
    MiMultiaccountoperation: TMenuItem;
    N3: TMenuItem;
    MiFindnextaccountwithhighbalance: TMenuItem;
    MiFindpreviousaccountwithhighbalance: TMenuItem;
    MiFindaccount: TMenuItem;
    MiFindOperationbyOpHash: TMenuItem;
    MiAccountInformation: TMenuItem;
    MiOperationsExplorer: TMenuItem;
    PanelMain: TPanel;
    PageControl: TPageControl;
    tsMyAccounts: TTabSheet;
    FrameAccountExplorer: TFrameAccountExplorer;
    tsPendingOperations: TTabSheet;
    FramePendingOperations: TFramePendingOperations;
    tsBlockChain: TTabSheet;
    FrameBlockChainExplorer: TFrameBlockChainExplorer;
    tsOperations: TTabSheet;
    FrameOperationsExplorer: TFrameOperationsExplorer;
    tsLogs: TTabSheet;
    FrameLogs: TFrameLogs;
    tsNodeStats: TTabSheet;
    FrameNodeStats: TFrameNodeStats;
    tsMessages: TTabSheet;
    FrameMessages: TFrameMessages;
    SplitterTop: TSplitter;
    FrameInfo: TFrameInfo;
    PanelNodeStatus: TPanel;
    lblNodeCaption: TLabel;
    lblNodeStatus: TLabel;
    Views: TMenuItem;
    MenuItemThreads: TMenuItem;
    MenuItemCriticalSections: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MiOperationsExplorerClick(Sender: TObject);
    procedure TimerUpdateStatusTimer(Sender: TObject);
    procedure miOptionsClick(Sender: TObject);
    procedure miAboutPascalCoinClick(Sender: TObject);
    procedure miNewOperationClick(Sender: TObject);
    procedure miPrivatekeysClick(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure MiCloseClick(Sender: TObject);
    procedure MiDecodePayloadClick(Sender: TObject);
    procedure lblReceivedMessagesClick(Sender: TObject);
    procedure IPnodes1Click(Sender: TObject);
    procedure MiAddaccounttoSelectedClick(Sender: TObject);
    procedure MiRemoveaccountfromselectedClick(Sender: TObject);
    procedure MiMultiaccountoperationClick(Sender: TObject);
    procedure MiFindnextaccountwithhighbalanceClick(Sender: TObject);
    procedure MiFindpreviousaccountwithhighbalanceClick(Sender: TObject);
    procedure MiFindaccountClick(Sender: TObject);
    procedure MiFindOperationbyOpHashClick(Sender: TObject);
    procedure MiAccountInformationClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MenuItemThreadsClick(Sender: TObject);
    procedure MenuItemCriticalSectionsClick(Sender: TObject);
  private
    FLastNodesCacheUpdatedTS : TDateTime;
    FBackgroundPanel : TPanel;
    FBackgroundLabel : TLabel;
    Procedure FinishedLoadingApp;
//    Procedure FillAccountInformation(Const Strings : TStrings; Const AccountNumber : Cardinal);
    Procedure InitMacOSMenu;
  protected
    { Private declarations }
    FNode : TNode;
    FIsActivated : Boolean;
    FWalletKeys : TWalletKeysExt;
    FLog : TLog;
    FNodeNotifyEvents : TNodeNotifyEvents;
    FAccountsGrid : TAccountsGrid;
    FSelectedAccountsGrid : TAccountsGrid;
    FOperationsAccountGrid : TOperationsGrid;
    FPendingOperationsGrid : TOperationsGrid;
    FOperationsExplorerGrid : TOperationsGrid;
    FBlockChainGrid : TBlockChainGrid;
    FMinerPrivateKeyType : TMinerPrivateKeyType;
    FUpdating : Boolean;
    FMustProcessWalletChanged : Boolean;
    FThreadActivate : TObject;

    Procedure OnNewAccount(Sender : TObject);
    Procedure OnReceivedHelloMessage(Sender : TObject);
    Procedure OnNetStatisticsChanged(Sender : TObject);
    procedure OnWalletChanged(Sender : TObject);
    Procedure OnNodeKeysActivity(Sender : TObject);
    Procedure OnMiningServerNewBlockFound(Sender : TObject);
    Procedure UpdateConnectionStatus;
    Procedure UpdateConfigChanged(Sender:TObject);
    procedure Activate; override;
    Function ForceMining : Boolean; virtual;
    Function GetAccountKeyForMiner : TAccountKey;
    Procedure DoUpdateAccounts;
    procedure CM_WalletChanged(var Msg: TMessage); message CM_PC_WalletKeysChanged;
//    procedure CM_NetConnectionUpdated(var Msg: TMessage); message CM_PC_NetConnectionUpdated; // moved to UFrameNodeStats, Skybuck: not sure yet if Frames can received messages
  public
    Procedure CheckIsReady;

    procedure UpdateNodeStatus;

    Procedure UpdateOperations;
    Property BackgroundLabel : TLabel read FBackgroundLabel;
    { Public declarations }
    Property Node : TNode read FNode;
    Property WalletKeys : TWalletKeysExt read FWalletKeys;
    Property NodeNotifyEvents : TNodeNotifyEvents read FNodeNotifyEvents;
    Property Updating : boolean read FUpdating write FUpdating;
    property OperationsExplorerGrid : TOperationsGrid read FOperationsExplorerGrid;
    Property BlockChainGrid : TBlockChainGrid read FBlockChainGrid;
//    Property SelectedAccountsGrid : TAccountsGrid read FSelectedAccountsGrid;
  end;

implementation

{$R *.dfm}

Uses UFolderHelper,
{$IFDEF Use_OpenSSL}
  UOpenSSL,
{$ENDIF}
  UTime, UFileStorage,
  UThread, UOpTransaction, UFRMWalletConfig,
  UFRMOperationsExplorer,
  {$IFDEF TESTNET}
  UFRMRandomOperations,
  UFRMDiagnosticTool,
  {$ENDIF}
  UPCTNetDataExtraMessages,
  UAbstractBTree, UEPasaDecoder,
  UFRMAbout, UFRMOperation, UFRMWalletKeys, UFRMPayloadDecoder, UFRMNodesIp, UFRMMemoText,
  UCommon, UPCOrderedLists,
  UFRMWalletInformation,
  UFRMWalletInstance,
  UFRMThreads,
  UFRMCriticalSections;

Type
  { TThreadActivate }
  TThreadActivate = Class(TPCThread)
  private
    FLastTC : TTickCount;
    FLastMsg : String;
    procedure OnProgressNotify(sender : TObject; const mesage : String; curPos, totalCount : Int64);
    procedure ThreadSafeNotify;
  protected
    procedure BCExecute; override;
  End;

{ TThreadActivate }
procedure TThreadActivate.OnProgressNotify(sender: TObject; const mesage: String; curPos, totalCount: Int64);
var pct : String;
begin
  If TPlatform.GetElapsedMilliseconds(FLastTC)>500 then begin
    FLastTC := TPlatform.GetTickCount;
    if (totalCount>0) then pct := Format('%.2f',[curPos*100/totalCount])+'%'
    else pct := '';
    FLastMsg:='Please wait until finished: '+mesage+' '+pct;
    Synchronize(ThreadSafeNotify);
  end;
end;

procedure TThreadActivate.ThreadSafeNotify;
begin
  If (FLastMsg<>'') then begin
    if Assigned(FRMWallet.FBackgroundLabel) then begin
      FRMWallet.FBackgroundLabel.Caption:=FLastMsg;
    end;
  end else FRMWallet.UpdateNodeStatus;
end;

procedure TThreadActivate.BCExecute;
Var currentProcess : String;
  LTC : TTickCount;
  LRaw : TRawBytes;
begin
  FLastTC := 0;
  FLastMsg := '';
  //
  {$IFDEF PRODUCTION}
  OnProgressNotify(Self,'Reading Hardcoded RandomHash file',0,0);
  LRaw := TCrypto.HexaToRaw(CT_Hardcoded_RandomHash_Table_HASH);
  TPascalCoinProtocol.AllowUseHardcodedRandomHashTable(
    ExtractFileDir(Application.ExeName)+PathDelim+CT_Hardcoded_RandomHash_Table_Filename,
    LRaw );
  {$ENDIF}
  FLastTC := 0;
  OnProgressNotify(Self,'Initializing databases',0,0);
  // Read Operations saved from disk
  TNode.Node.InitSafeboxAndOperations($FFFFFFFF,OnProgressNotify); // New Build 2.1.4 to load pending operations buffer
  TNode.Node.AutoDiscoverNodes(CT_Discover_IPs);
  TNode.Node.NetServer.Active := true;
  FLastTC := 0;
  FLastMsg := '';
  LTC := TPlatform.GetTickCount;
  if (TNode.Node.Bank.BlocksCount<=1) then begin
    while (Not Terminated) And (Not TNode.Node.IsReady(currentProcess) Or (TNode.Node.Bank.BlocksCount<=1)) do begin
      Synchronize(ThreadSafeNotify);
      Sleep(200);
      {$IFDEF TESTNET}
      if (TPlatform.GetElapsedMilliseconds(LTC)>5000) then Break;
      {$ENDIF}
    end;
  end;
  if Not Terminated then begin
    Synchronize( FRMWallet.DoUpdateAccounts );
    Synchronize( FRMWallet.FinishedLoadingApp );
  end;
  FRMWallet.FThreadActivate := Nil;
end;
{ TFRMWallet }

procedure TFRMWallet.UpdateNodeStatus;
Var status : String;
begin
  If Not Assigned(Node) then begin
    lblNodeStatus.Font.Color := clRed;
    lblNodeStatus.Caption := 'Initializing...';
  end else begin
    If Node.IsReady(status) then begin
      if TNetData.NetData.NetStatistics.ActiveConnections>0 then begin
        lblNodeStatus.Font.Color := clGreen;
        if TNetData.NetData.IsDiscoveringServers then begin
          lblNodeStatus.Caption := 'Discovering servers';
        end else if TNetData.NetData.IsGettingNewBlockChainFromClient(status) then begin
          lblNodeStatus.Caption := 'Obtaining new blockchain '+status;
        end else begin
          lblNodeStatus.Caption := 'Running';
        end;
      end else begin
        lblNodeStatus.Font.Color := clRed;
        lblNodeStatus.Caption := 'Alone in the world...';
      end;
    end else begin
      lblNodeStatus.Font.Color := clRed;
      lblNodeStatus.Caption := status;
    end;
  end;
  If Assigned(BackgroundLabel) then begin
    BackgroundLabel.Font.Color:= lblNodeStatus.Font.Color;
    BackgroundLabel.Caption:='Please wait until finished: '+lblNodeStatus.Caption;
  end;
end;

procedure TFRMWallet.lblReceivedMessagesClick(Sender: TObject);
begin
  PageControl.ActivePage := tsMessages;
end;

procedure TFRMWallet.Activate;
Var ips : AnsiString;
  nsarr : TNodeServerAddressArray;
  i : Integer;
begin
  inherited;
  if FIsActivated then exit;
  FIsActivated := true;
  try
    TCrypto.InitCrypto;
    // Read Wallet
    Try
      FWalletKeys.WalletFileName := TNode.GetPascalCoinDataFolder+PathDelim+'WalletKeys.dat';
    Except
      On E:Exception do begin
        E.Message := 'Cannot open your wallet... Perhaps another instance of Pascal Coin is active!'+#10+#10+E.Message;
        Raise;
      end;
    End;
    ips := TSettings.TryConnectOnlyWithThisFixedServers;
    TNode.DecodeIpStringToNodeServerAddressArray(ips,nsarr);
    TNetData.NetData.DiscoverFixedServersOnly(nsarr);
    setlength(nsarr,0);
    // Creating Node:
    FNode := TNode.Node;
    FNode.NetServer.Port := TSettings.InternetServerPort;
    FNode.PeerCache := TSettings.PeerCache+';'+CT_Discover_IPs;
    FNode.MaxPayToKeyPurchasePrice := TSettings.MaxPayToKeyPurchasePrice;
    WalletKeys.SafeBox := FNode.Bank.SafeBox;
    // Check Database
    FNode.Bank.StorageClass := TFileStorage;
    FNode.Bank.Storage.Initialize;
    // Init Grid
    FrameAccountExplorer.SelectedAccountsGrid.Node := FNode;
    FWalletKeys.OnChanged.Add( OnWalletChanged );
    FrameAccountExplorer.AccountsGrid.Node := FNode;
    FOperationsAccountGrid.Node := FNode;
    FBlockChainGrid.HashRateAverageBlocksCount := TSettings.HashRateAvgBlocksCount;
    i := Integer(TSettings.ShowHashRateAs);
    if (i<Integer(Low(TShowHashRateAs))) Or (i>Integer(High(TShowHashRateAs))) then i := Integer({$IFDEF TESTNET}hr_Mega{$ELSE}hr_Tera{$ENDIF});
    FBlockChainGrid.HashRateAs := TShowHashRateAs(i);
    // Reading database
    FThreadActivate := TThreadActivate.Create(true);
    TThreadActivate(FThreadActivate).FreeOnTerminate := true;
    TThreadActivate(FThreadActivate).Suspended := False;
    UpdateConfigChanged(Self);
    UpdateNodeStatus;
    TPCTNetDataExtraMessages.InitNetDataExtraMessages(FNode,TNetData.NetData,FWalletKeys);
  Except
    On E:Exception do begin
      E.Message := 'An error occurred during initialization. Application cannot continue:'+#10+#10+E.Message+#10+#10+'Application will close...';
      Application.MessageBox(PChar(E.Message),PChar(Application.Title),MB_ICONERROR+MB_OK);
      Halt;
    end;
  end;
  FrameAccountExplorer.UpdatePrivateKeys;
  FrameAccountExplorer.UpdateAccounts(false);
  if TSettings.FirstTime then begin
    TSettings.FirstTime := false;
    miAboutPascalCoinClick(Nil);
  end;
  PageControlChange(Nil);
end;

Procedure TFRMWallet.InitMacOSMenu;
{$IFDEF FPC}
var
  mi : TMenuItem;
  app : TMenuItem;
{$ENDIF}
begin
  {$IFDEF FPC}
  {$IFNDEF DARWIN}
  Exit;
  {$ENDIF}
  app := TMenuItem.Create(MainMenu);
  app := TMenuItem.Create(MainMenu);
  app.Caption:=#$EF#$A3#$BF;
  miAboutPascalCoin.Parent.Remove(miAboutPascalCoin);
  app.Add(miAboutPascalCoin);
  {$IFDEF TESTNET}
  // Things for testing purposes only
  miAbout.caption := 'Testing';
  {$ELSE}
  miAbout.Visible:=false;
  {$ENDIF}
  // Move "Options" to "Prefernces"
  mi := TMenuItem.Create(MainMenu);
  mi.Caption:='-';
  app.Add(mi);
  miOptions.Parent.Remove(miOptions);
  miOptions.Caption:='Preferences...';
  miOptions.ShortCut:=Menus.ShortCut(VK_OEM_COMMA, [ssMeta]);
  app.Add(miOptions);
  MiFindaccount.ShortCut:=Menus.ShortCut(VK_F, [ssMeta]);
  MiOperationsExplorer.ShortCut:=Menus.ShortCut(VK_E, [ssMeta]);
  MiFindpreviousaccountwithhighbalance.ShortCut:=Menus.Shortcut(VK_F3, [ssMeta]);
  miOptions.ShortCut:=Menus.ShortCut(VK_OEM_COMMA, [ssMeta]); // match preferences
  miPrivatekeys.ShortCut:=Menus.Shortcut(VK_P, [ssMeta]);
  N1.Visible:=false;
  MiClose.Visible:=false;
  MainMenu.Items.Insert(0, app);
  {$endif}
end;

function TFRMWallet.ForceMining: Boolean;
begin
  Result := false;
end;

procedure TFRMWallet.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FThreadActivate) then begin
    TThreadActivate(FThreadActivate).Terminate;
    FThreadActivate := Nil;
  end;
end;

procedure TFRMWallet.FormCreate(Sender: TObject);
Var i : Integer;
begin
  {$IFDEF TESTNET}
  System.ReportMemoryLeaksOnShutdown := True; // Delphi memory leaks testing
  {$ENDIF}
  FLastNodesCacheUpdatedTS := Now;
  FBackgroundPanel := Nil;
  FBackgroundLabel := Nil;
  FThreadActivate := Nil;
  FMustProcessWalletChanged := false;
  FNode := Nil;
  FrameInfo.lblReceivedMessages.Visible := false;
  FUpdating := false;
  TimerUpdateStatus.Enabled := false;
  FIsActivated := false;
  FWalletKeys := TWalletKeysExt.Create(Self);
  for i := 0 to StatusBar.Panels.Count - 1 do begin
    StatusBar.Panels[i].Text := '';
  end;
  FLog := TLog.Create(Self);
  FLog.OnNewLog := FrameLogs.OnNewLog;
  FLog.SaveTypes := [];
  If Not ForceDirectories(TNode.GetPascalCoinDataFolder) then raise Exception.Create('Cannot create dir: '+TNode.GetPascalCoinDataFolder);
  TSettings.Load;
  TSettings.OnChanged.Add(UpdateConfigChanged);
  FNodeNotifyEvents := TNodeNotifyEvents.Create(Self);
  FNodeNotifyEvents.OnBlocksChanged := OnNewAccount;
  FNodeNotifyEvents.OnNodeMessageEvent := FrameMessages.OnNodeMessageEvent;
  FNodeNotifyEvents.OnKeyActivity := OnNodeKeysActivity;
  FAccountsGrid := TAccountsGrid.Create(Self);
  FAccountsGrid.DrawGrid := FrameAccountExplorer.dgAccounts;
  FAccountsGrid.AllowMultiSelect := True;
  FAccountsGrid.OnAccountsGridUpdatedData := FrameAccountExplorer.OnAccountsGridUpdatedData;
  FAccountsGrid.AccountsGridDatasource := acds_Node;
  FrameAccountExplorer.AccountsGrid := FAccountsGrid;
  FSelectedAccountsGrid := TAccountsGrid.Create(Self);
  FSelectedAccountsGrid.AccountsGridDatasource := acds_InternalList;
  FSelectedAccountsGrid.DrawGrid := FrameAccountExplorer.dgSelectedAccounts;
  FSelectedAccountsGrid.OnUpdated := FrameAccountExplorer.OnSelectedAccountsGridUpdated;
  FrameAccountExplorer.SelectedAccountsGrid := FSelectedAccountsGrid;
  FOperationsAccountGrid := TOperationsGrid.Create(Self);
  FOperationsAccountGrid.DrawGrid := FrameAccountExplorer.dgAccountOperations;
  FOperationsAccountGrid.MustShowAlwaysAnAccount := true;
  FOperationsAccountGrid.WalletKeys := FWalletKeys;
  FPendingOperationsGrid := TOperationsGrid.Create(Self);
  FPendingOperationsGrid.DrawGrid := FramePendingOperations.dgPendingOperations;
  FPendingOperationsGrid.AccountNumber := -1; // all
  FPendingOperationsGrid.PendingOperations := true;
  FPendingOperationsGrid.WalletKeys := FWalletKeys;
  FOperationsExplorerGrid := TOperationsGrid.Create(Self);
  FOperationsExplorerGrid.DrawGrid := FrameOperationsExplorer.dgOperationsExplorer;
  FOperationsExplorerGrid.AccountNumber := -1;
  FOperationsExplorerGrid.PendingOperations := False;
  FOperationsExplorerGrid.WalletKeys := FWalletKeys;
  FBlockChainGrid := TBlockChainGrid.Create(Self);
  FBlockChainGrid.DrawGrid := FrameBlockChainExplorer.dgBlockChainExplorer;
  FBlockChainGrid.ShowTimeAverageColumns:={$IFDEF SHOW_AVERAGE_TIME_STATS}True;{$ELSE}False;{$ENDIF}
  // FWalletKeys.OnChanged.Add( OnWalletChanged );
  //
  FrameAccountExplorer.UpdatePrivateKeys;
  FrameInfo.UpdateBlockChainState;
  UpdateConnectionStatus;
  PageControl.ActivePage := tsOperations;
  FrameAccountExplorer.cbExploreMyAccountsClick(nil);
  FrameInfo.lblBuild.Caption := 'Build: '+CT_ClientAppVersion;
  {$IFDEF TESTNET}
  FrameInfo.lblBuild.Font.Color := clRed;
  {$ENDIF}
  PageControl.Enabled := False;
  PageControl.Visible := False;
  FBackgroundPanel := TPanel.Create(Self);
  FBackgroundPanel.Parent:=Self;
  FBackgroundPanel.Align:=alClient;
  FBackgroundPanel.Font.Size:=15;
  FBackgroundPanel.BevelWidth := 10;
  FBackgroundLabel := TLabel.Create(Self);
  FBackgroundLabel.Parent := FBackgroundPanel;
  FBackgroundLabel.Align := alClient;
  FBackgroundLabel.Layout := tlCenter;
  FBackgroundLabel.Font.Size := 18;
  FBackgroundLabel.Alignment := taCenter;
  FBackgroundLabel.WordWrap := True;
   // set some frame properties
  with FrameAccountExplorer do
  begin
    pcAccountsOptions.ActivePage := tsAccountOperations;
    cbExploreMyAccounts.Checked:=True; // By default
  end;
  {$ifdef DARWIN}
  // this is macOS specific menu layout
  InitMacOSMenu;
  {$endif}
  PageControl.ActivePageIndex := 0;
  {$IFDEF DEBUG}
  System.ReportMemoryLeaksOnShutdown := True; // Delphi memory leaks testing
  {$ENDIF}
end;

procedure TFRMWallet.FormDestroy(Sender: TObject);
Var i : Integer;
  step : String;
begin
  TLog.NewLog(ltinfo,Classname,'Destroying form - START');
  Try
    if Assigned(FThreadActivate) then begin
      TThreadActivate(FThreadActivate).Terminate;
      FThreadActivate := Nil;
    end;
  step := 'Saving params';
  TSettings.Save;
  //
  step := 'Assigning nil events';
  FLog.OnNewLog :=Nil;
  FNodeNotifyEvents.Node := Nil;
  FOperationsAccountGrid.Node := Nil;
  FOperationsExplorerGrid.Node := Nil;
  FPendingOperationsGrid.Node := Nil;
  FrameAccountExplorer.AccountsGrid.Node := Nil;
  FrameAccountExplorer.SelectedAccountsGrid.Node := Nil;
  TNetData.NetData.OnReceivedHelloMessage := Nil;
  TNetData.NetData.OnStatisticsChanged := Nil;
  TNetData.NetData.OnNetConnectionsUpdated := Nil;
  TNetData.NetData.OnNodeServersUpdated := Nil;
  TNetData.NetData.OnBlackListUpdated := Nil;
  //
  step := 'Destroying NodeNotifyEvents';
  FreeAndNil(FNodeNotifyEvents);
  //
  step := 'Assigning Nil to TNetData';
  TNetData.NetData.OnReceivedHelloMessage := Nil;
  TNetData.NetData.OnStatisticsChanged := Nil;
  step := 'Destroying grids operators';
  FreeAndNil(FOperationsAccountGrid);
  FreeAndNil(FOperationsExplorerGrid);
  FreeAndNil(FBlockChainGrid);
  step := 'Desactivating Node';
  TNode.Node.NetServer.Active := false;
  FNode := Nil;
  TNetData.NetData.Free;
  step := 'Processing messages 1';
  Application.ProcessMessages;
  step := 'Destroying Node';
  TNode.Node.Free;
  step := 'Destroying Wallet';
  FreeAndNil(FWalletKeys);
  step := 'Processing messages 2';
  Application.ProcessMessages;
  step := 'Destroying stringslist';
  Except
    On E:Exception do begin
      TLog.NewLog(lterror,Classname,'Error destroying Form step: '+step+' Errors ('+E.ClassName+'): ' +E.Message);
    end;
  End;
  TLog.NewLog(ltinfo,Classname,'Destroying form - END');
  FreeAndNil(FLog);
  Sleep(100);
end;

procedure TFRMWallet.CheckIsReady;
Var isready : String;
begin
  if Not Assigned(FNode) then Abort;
  if Not FNode.IsReady(isready) then begin
    Raise Exception.Create('You cannot do this operation now:'+#10+#10+isready);
  end;
end;

procedure TFRMWallet.CM_WalletChanged(var Msg: TMessage);
begin
  FrameAccountExplorer.UpdatePrivateKeys;
  FMustProcessWalletChanged := false;
end;

procedure TFRMWallet.DoUpdateAccounts;
begin
  FrameAccountExplorer.UpdateAccounts(true);
end;

procedure TFRMWallet.FinishedLoadingApp;
var LLockedMempool : TPCOperationsComp;
  LFoundAccounts, i, LOnSafebox,LOnMempool : Integer;
  Lpubkeys : TList<TAccountKey>;
begin
  FNodeNotifyEvents.Node := FNode;
  // Init
  TNetData.NetData.OnReceivedHelloMessage := OnReceivedHelloMessage;
  TNetData.NetData.OnStatisticsChanged := OnNetStatisticsChanged;
  TNetData.NetData.OnNetConnectionsUpdated := FrameNodeStats.OnNetConnectionsUpdated;
  TNetData.NetData.OnNodeServersUpdated := FrameNodeStats.OnNetNodeServersUpdated;
  TNetData.NetData.OnBlackListUpdated := FrameNodeStats.OnNetBlackListUpdated;
  //
  TimerUpdateStatus.Interval := 1000;
  TimerUpdateStatus.Enabled := true;
  LLockedMempool := FNode.LockMempoolWrite;
  try
    LLockedMempool.AccountKey := GetAccountKeyForMiner;
  finally
    FNode.UnlockMempoolWrite;
  end;
  FreeAndNil(FBackgroundLabel);
  FreeAndNil(FBackgroundPanel);
  PageControl.Visible:=True;
  PageControl.Enabled:=True;
  FrameAccountExplorer.UpdatePrivateKeys;
  //
  LFoundAccounts := 0;
  FNode.Bank.SafeBox.StartThreadSafe;
  try
    Lpubkeys := TList<TAccountKey>.Create;
    Try
      for i := 0 to FWalletKeys.Count-1 do begin
        if (FWalletKeys.Key[i].HasPrivateKey) then begin
          Lpubkeys.Add(FWalletKeys.Key[i].AccountKey);
        end;
      end;
      if (Lpubkeys.Count>0) then begin
        LFoundAccounts := FNode.GetAccountsAvailableByPublicKey(Lpubkeys,LOnSafebox,LOnMempool);
      end else LFoundAccounts := 0;
    Finally
      Lpubkeys.Free;
    End;
  finally
    FNode.Bank.SafeBox.EndThreadSave;
  end;
  if LFoundAccounts<1 then begin
    // Will only ask if no accounts
    // TFRMAskForAccount.AskForAccount(Self,FNode,TNetData.NetData,FWalletKeys,GetAccountKeyForMiner);
  end;
end;

procedure TFRMWallet.MiOperationsExplorerClick(Sender: TObject);
begin
  With TFRMOperationsExplorer.Create(Self) do
  try
    SourceNode := FNode;
    SourceWalletKeys := FWalletKeys;
    ShowModal;
  finally
    Free;
  end;
end;

function TFRMWallet.GetAccountKeyForMiner: TAccountKey;
Var PK : TECPrivateKey;
  i : Integer;
  PublicK : TECDSA_Public;
begin
  Result := CT_TECDSA_Public_Nul;
  if Not Assigned(FWalletKeys) then exit;
  case FMinerPrivateKeyType of
    mpk_NewEachTime: PublicK := CT_TECDSA_Public_Nul;
    mpk_Selected: begin
      PublicK := TAccountComp.RawString2Accountkey(TSettings.MinerSelectedPublicKey);
    end;
  else
    // Random
    PublicK := CT_TECDSA_Public_Nul;
    if FWalletKeys.Count>0 then begin
      i := Random(FWalletKeys.Count);
      if (Length(FWalletKeys.Key[i].CryptedKey)=0) then begin
        // Not valid, search for first valid:
        i:=0;
        while (i<FWalletKeys.Count) And (Length(FWalletKeys.Key[i].CryptedKey)=0) do inc(i);
        if i<FWalletKeys.Count then PublicK := FWalletKeys.Key[i].AccountKey;
      end else PublicK := FWalletKeys.Key[i].AccountKey;
    end;
  end;
  i := FWalletKeys.IndexOfAccountKey(PublicK);
  if i>=0 then begin
    if (Length(FWalletKeys.Key[i].CryptedKey)=0) then i:=-1;
  end;
  if i<0 then begin
    PK := TECPrivateKey.Create;
    try
      PK.GenerateRandomPrivateKey(CT_Default_EC_OpenSSL_NID);
      FWalletKeys.AddPrivateKey('New for miner '+DateTimeToStr(Now), PK);
      PublicK := PK.PublicKey;
      // Set to AppParams if not mpk_NewEachTime
      if (FMinerPrivateKeyType<>mpk_NewEachTime) then begin
        TSettings.MinerSelectedPublicKey := TAccountComp.AccountKey2RawString(PublicK);
        FMinerPrivateKeyType:=mpk_Selected;
        TSettings.MinerPrivateKeyType := mpk_Selected;
      end;
    finally
      PK.Free;
    end;
  end;
  Result := PublicK;
end;

procedure TFRMWallet.IPnodes1Click(Sender: TObject);
Var FRM : TFRMNodesIp;
begin
  FRM := TFRMNodesIp.Create(Self);
  Try
    FRM.AppParams := TSettings.AppParams;
    FRM.ShowModal;
  Finally
    FRM.Free;
  End;
end;

procedure TFRMWallet.miAboutPascalCoinClick(Sender: TObject);
begin
  With TFRMAbout.Create(Self) do
  try
    showmodal;
  finally
    free;
  end;
end;

procedure TFRMWallet.MiAccountInformationClick(Sender: TObject);
Var F : TFRMMemoText;
  accn : Int64;
  s,title : String;
  account : TAccount;
  strings : TStrings;
  i : Integer;
  opr : TOperationResume;
begin
  accn := -1;
  title := '';
  strings := TStringList.Create;
  try
    opr := CT_TOperationResume_NUL;
    if PageControl.ActivePage=tsOperations then begin
      i := FOperationsExplorerGrid.DrawGrid.Row;
      if (i>0) and (i<=FOperationsExplorerGrid.OperationsResume.Count) then begin
        opr := FOperationsExplorerGrid.OperationsResume.Items[i-1];
      end;
    end else if PageControl.ActivePage=tsPendingOperations then begin
      i := FPendingOperationsGrid.DrawGrid.Row;
      if (i>0) and (i<=FPendingOperationsGrid.OperationsResume.Count) then begin
        opr := FPendingOperationsGrid.OperationsResume.Items[i-1];
      end;
    end else if PageControl.ActivePage=tsMyAccounts then begin
      accn := FrameAccountExplorer.AccountsGrid.AccountNumber(FrameAccountExplorer.dgAccounts.Row);
      if accn<0 then raise Exception.Create('Select an account');
      TFRMWalletInformation.FillAccountInformation(strings,accn);
      title := 'Account '+TAccountComp.AccountNumberToAccountTxtNumber(accn)+' info';
      i := FOperationsAccountGrid.DrawGrid.Row;
      if (i>0) and (i<=FOperationsAccountGrid.OperationsResume.Count) then begin
        opr := FOperationsAccountGrid.OperationsResume.Items[i-1];
      end;
    end;
    If (opr.valid) then begin
      if accn>=0 then strings.Add('')
      else title := 'Operation info';
      strings.Add('Operation info:');
      TFRMWalletInformation.FillOperationInformation(strings,opr);
    end else if accn<0 then Raise Exception.Create('No info available');
    F := TFRMMemoText.Create(Self);
    Try
      F.Caption := title;
      strings.add(Format('Agg Hashrate: %s',[FNode.Bank.SafeBox.AggregatedHashrate.ToDecimal]));
      strings.add(Format('Agg Hashrate: %s',[FNode.Bank.SafeBox.AggregatedHashrate.HexaValue]));
      F.Memo.Lines.Assign(strings);
      F.ShowModal;
    Finally
      F.Free;
    End;
  finally
    strings.free;
  end;
end;

procedure TFRMWallet.MiAddaccounttoSelectedClick(Sender: TObject);
begin
  PageControl.ActivePage := tsMyAccounts;
  PageControlChange(Nil);
  FrameAccountExplorer.pcAccountsOptions.ActivePage := FrameAccountExplorer.tsMultiSelectAccounts;
  FrameAccountExplorer.sbSelectedAccountsAddClick(Sender);
end;

procedure TFRMWallet.MiCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFRMWallet.MiDecodePayloadClick(Sender: TObject);
begin
  if PageControl.ActivePage=tsOperations then begin
    FOperationsExplorerGrid.ShowModalDecoder(FWalletKeys, TSettings.AppParams);
  end else if PageControl.ActivePage=tsPendingOperations then begin
    FPendingOperationsGrid.ShowModalDecoder(FWalletKeys,TSettings.AppParams);
  end else if PageControl.ActivePage=tsMyAccounts then begin
    FOperationsAccountGrid.ShowModalDecoder(FWalletKeys,TSettings.AppParams);
  end;
end;

procedure TFRMWallet.MiFindaccountClick(Sender: TObject);
begin
  PageControl.ActivePage := tsMyAccounts;
  PageControlChange(Nil);
  FrameAccountExplorer.ebFindAccountNumber.SetFocus;
end;

procedure TFRMWallet.MiFindnextaccountwithhighbalanceClick(Sender: TObject);
Var an  : Cardinal;
  an64 : Int64;
  start : TAccount;
begin
  PageControl.ActivePage := tsMyAccounts;
  PageControlChange(Nil);
  an64 := FrameAccountExplorer.AccountsGrid.AccountNumber(FrameAccountExplorer.dgAccounts.Row);
  if an64<0 then an := 0
  else an := an64;
  If an>=FNode.Bank.SafeBox.AccountsCount then exit;
  start := FNode.Bank.SafeBox.Account(an);
  while (an<FNode.Bank.SafeBox.AccountsCount)  do begin
    if FNode.Bank.SafeBox.Account(an).balance>start.balance then break
    else inc(an);
  end;
  if (an<FNode.Bank.SafeBox.AccountsCount) then FrameAccountExplorer.AccountsGrid.MoveRowToAccount(an)
  else raise Exception.Create('Not found any account higher than '+TAccountComp.AccountNumberToAccountTxtNumber(start.account)+' with balance higher than '+
    TAccountComp.FormatMoney(start.balance));
end;

procedure TFRMWallet.MiFindOperationbyOpHashClick(Sender: TObject);
Var FRM : TFRMPayloadDecoder;
  oph : String;
begin
  oph := '';
  if Not InputQuery('Search operation by OpHash','Insert Operation Hash value (OpHash)',oph) then exit;
  //
  FRM := TFRMPayloadDecoder.Create(Self);
  try
    FRM.Init(CT_TOperationResume_NUL,WalletKeys,TSettings.AppParams);
    FRM.DoFind(oph);
    FRM.ShowModal;
  finally
    FRM.Free;
  end;
end;

procedure TFRMWallet.MiFindpreviousaccountwithhighbalanceClick(Sender: TObject);
Var an  : Cardinal;
  an64 : Int64;
  start : TAccount;
begin
  PageControl.ActivePage := tsMyAccounts;
  PageControlChange(Nil);
  an64 := FrameAccountExplorer.AccountsGrid.AccountNumber(FrameAccountExplorer.dgAccounts.Row);
  if an64<0 then an := FNode.Bank.SafeBox.AccountsCount-1
  else an := an64;
  If an>=FNode.Bank.SafeBox.AccountsCount then exit;
  start := FNode.Bank.SafeBox.Account(an);
  while (an>0)  do begin
    if FNode.Bank.SafeBox.Account(an).balance>start.balance then break
    else dec(an);
  end;
  if (FNode.Bank.SafeBox.Account(an).balance>start.balance) then FrameAccountExplorer.AccountsGrid.MoveRowToAccount(an)
  else raise Exception.Create('Not found any account lower than '+TAccountComp.AccountNumberToAccountTxtNumber(start.account)+' with balance higher than '+
    TAccountComp.FormatMoney(start.balance));
end;

procedure TFRMWallet.MiMultiaccountoperationClick(Sender: TObject);
begin
  PageControl.ActivePage := tsMyAccounts;
  FrameAccountExplorer.pcAccountsOptions.ActivePage := FrameAccountExplorer.tsMultiSelectAccounts;
  FrameAccountExplorer.bbSelectedAccountsOperationClick(Sender);
end;

procedure TFRMWallet.miNewOperationClick(Sender: TObject);
var l : TOrderedCardinalList;
begin
  CheckIsReady;
  With TFRMOperation.Create(Self) do
  Try
    l := TOrderedCardinalList.Create;
    try
      If FrameAccountExplorer.AccountsGrid.SelectedAccounts(l)<1 then raise Exception.Create('No row selected');
      SenderAccounts.CopyFrom(l);
    finally
      l.Free;
    end;
    DefaultFee := TSettings.DefaultFee;
    WalletKeys := FWalletKeys;
    ShowModal;
  Finally
    Free;
  End;
end;

procedure TFRMWallet.miOptionsClick(Sender: TObject);
begin
  With TFRMPascalCoinWalletConfig.Create(Self) do
  try
    AppParams := TSettings.AppParams;
    WalletKeys := Self.FWalletKeys;
    if ShowModal=MrOk then begin
      TSettings.Save;
      UpdateConfigChanged(Self);
    end;
  finally
    free;
  end;
end;

procedure TFRMWallet.miPrivatekeysClick(Sender: TObject);
Var FRM : TFRMWalletKeys;
begin
  FRM := TFRMWalletKeys.Create(Self);
  Try
    FRM.WalletKeys := FWalletKeys;
    FRM.ShowModal;
    FrameAccountExplorer.UpdatePrivateKeys;
  Finally
    FRM.Free;
  End;
end;

procedure TFRMWallet.MiRemoveaccountfromselectedClick(Sender: TObject);
begin
  PageControl.ActivePage := tsMyAccounts;
  PageControlChange(Nil);
  FrameAccountExplorer.pcAccountsOptions.ActivePage := FrameAccountExplorer.tsMultiSelectAccounts;
  FrameAccountExplorer.sbSelectedAccountsDelClick(Sender);
end;

procedure TFRMWallet.OnMiningServerNewBlockFound(Sender: TObject);
begin
end;

procedure TFRMWallet.OnNetStatisticsChanged(Sender: TObject);
Var NS : TNetStatistics;
begin
  //CheckMining;
  if Assigned(FNode) then begin
    If FNode.NetServer.Active then begin
      StatusBar.Panels[0].Text := 'Active (Port '+Inttostr(FNode.NetServer.Port)+')';
    end else StatusBar.Panels[0].Text := 'Server stopped';
    NS := TNetData.NetData.NetStatistics;
    StatusBar.Panels[1].Text := Format('Connections:%d Clients:%d Servers:%d - Rcvd:%d Kb Send:%d Kb',
      [NS.ActiveConnections,NS.ClientsConnections,NS.ServersConnections,NS.BytesReceived DIV 1024,NS.BytesSend DIV 1024]);
  end else begin
    StatusBar.Panels[0].Text := '';
    StatusBar.Panels[1].Text := '';
  end;
end;

procedure TFRMWallet.OnNewAccount(Sender: TObject);
begin
  Try
    FrameAccountExplorer.UpdateAccounts(false);
    FrameInfo.UpdateBlockChainState;
  Except
    On E:Exception do begin
      E.Message := 'Exception at OnNewAccount '+E.ClassName+': '+E.Message;
      TLog.NewLog(lterror,ClassName,E.Message);
      Raise;
    end;
  end;
end;

procedure TFRMWallet.OnNodeKeysActivity(Sender: TObject);
begin
  DoUpdateAccounts;
end;

procedure TFRMWallet.OnReceivedHelloMessage(Sender: TObject);
Var nsarr : TNodeServerAddressArray;
  i : Integer;
  s : AnsiString;
begin
  If (FLastNodesCacheUpdatedTS + EncodeTime(0,5,0,0) > Now) then exit; // Prevent continuous saving
  FLastNodesCacheUpdatedTS := Now;
  // Update node servers Peer Cache
  nsarr := TNetData.NetData.NodeServersAddresses.GetValidNodeServers(true,0);
  s := '';
  for i := low(nsarr) to High(nsarr) do begin
    if (s<>'') then s := s+';';
    s := s + nsarr[i].ip+':'+IntToStr( nsarr[i].port );
  end;
  TSettings.PeerCache := s;
  TNode.Node.PeerCache := s;
end;

procedure TFRMWallet.OnWalletChanged(Sender: TObject);
begin
  if FMustProcessWalletChanged then exit;
  FMustProcessWalletChanged := true;
  PostMessage(Self.Handle,CM_PC_WalletKeysChanged,0,0);
end;

procedure TFRMWallet.PageControlChange(Sender: TObject);
begin
  MiDecodePayload.Enabled := false;
  if PageControl.ActivePage=tsMyAccounts then begin
    FrameAccountExplorer.AccountsGrid.Node := FNode;
    MiDecodePayload.Enabled := true;
    FrameAccountExplorer.SelectedAccountsGrid.Node := FNode;
  end else begin
    FrameAccountExplorer.AccountsGrid.Node := Nil;
    FrameAccountExplorer.SelectedAccountsGrid.Node := Nil;
  end;
  if PageControl.ActivePage=tsPendingOperations then begin
    FPendingOperationsGrid.Node := FNode;
    MiDecodePayload.Enabled := true;
  end else begin
    FPendingOperationsGrid.Node := Nil;
  end;
  if PageControl.ActivePage=tsBlockChain then
  begin
    FBlockChainGrid.Node := FNode;
  end else begin
    FBlockChainGrid.Node := Nil;
  end;
  if PageControl.ActivePage=tsOperations then begin
    FOperationsExplorerGrid.Node := FNode;
    MiDecodePayload.Enabled := true;
  end else begin
    FOperationsExplorerGrid.Node := Nil;
  end;
  if PageControl.ActivePage=tsMessages then begin
    FrameMessages.UpdateAvailableConnections;
    FrameMessages.MessagesUnreadCount := 0;
    FrameInfo.lblReceivedMessages.Visible := false;
  end;
end;

procedure TFRMWallet.MenuItemThreadsClick(Sender: TObject);
begin
  FRMThreads.Show;
end;

procedure TFRMWallet.MenuItemCriticalSectionsClick(Sender: TObject);
begin
  FRMCriticalSections.Show;
end;

procedure TFRMWallet.TimerUpdateStatusTimer(Sender: TObject);
begin
  Try
    UpdateConnectionStatus;
    FrameInfo.UpdateBlockChainState;
    UpdateNodeStatus;
  Except
    On E:Exception do begin
      E.Message := 'Exception at TimerUpdate '+E.ClassName+': '+E.Message;
      TLog.NewLog(lterror,ClassName,E.Message);
    end;
  End;
end;

procedure TFRMWallet.UpdateConfigChanged(Sender:TObject);
Var wa : Boolean;
  i : Integer;
  LLockedMempool : TPCOperationsComp;
begin
  tsLogs.TabVisible := TSettings.ShowLogs;
  if (Not tsLogs.TabVisible) then begin
    FLog.OnNewLog := Nil;
    if PageControl.ActivePage = tsLogs then PageControl.ActivePage := tsMyAccounts;
  end else FLog.OnNewLog := FrameLogs.OnNewLog;
  if TSettings.SaveLogFiles then begin
    if TSettings.SaveDebugLogs then FLog.SaveTypes := CT_TLogTypes_ALL
    else FLog.SaveTypes := CT_TLogTypes_DEFAULT;
    FLog.FileName := TNode.GetPascalCoinDataFolder+PathDelim+'PascalCointWallet.log';
  end else begin
    FLog.SaveTypes := [];
    FLog.FileName := '';
  end;
  if Assigned(FNode) then begin
    wa := FNode.NetServer.Active;
    FNode.NetServer.Port := TSettings.InternetServerPort;
    FNode.NetServer.Active := wa;
    LLockedMempool := FNode.LockMempoolWrite;
    try
      LLockedMempool.BlockPayload := TEncoding.ANSI.GetBytes(TSettings.MinerName);
    finally
      FNode.UnlockMempoolWrite;
    end;
    FNode.NodeLogFilename := TNode.GetPascalCoinDataFolder+PathDelim+'blocks.log';
  end;
  i := Integer(TSettings.MinerPrivateKeyType);
  if (i>=Integer(Low(TMinerPrivateKeyType))) And (i<=Integer(High(TMinerPrivateKeyType))) then FMinerPrivateKeyType := TMinerPrivateKeyType(i)
  else FMinerPrivateKeyType := mpk_Random;
  FrameBlockChainExplorer.ebHashRateBackBlocks.Text := IntToStr(FBlockChainGrid.HashRateAverageBlocksCount);
  FrameBlockChainExplorer.ChangeHashRateUnits( FBlockChainGrid.HashRateAs );
  if TNetData.NetDataExists then begin
    if TSettings.AppParams.ParamByName[CT_PARAM_AllowDownloadNewCheckpointIfOlderThan].GetAsBoolean(TNetData.NetData.MinFutureBlocksToDownloadNewSafebox>200) then begin
      TNetData.NetData.MinFutureBlocksToDownloadNewSafebox:=TSettings.AppParams.ParamByName[CT_PARAM_MinFutureBlocksToDownloadNewSafebox].GetAsInteger(TNetData.NetData.MinFutureBlocksToDownloadNewSafebox);
    end else TNetData.NetData.MinFutureBlocksToDownloadNewSafebox:=0;
  end;
end;

procedure TFRMWallet.UpdateConnectionStatus;
var errors : String;
begin
  UpdateNodeStatus;
  OnNetStatisticsChanged(Nil);
  if Assigned(FNode) then begin
    if FNode.IsBlockChainValid(errors) then begin
      StatusBar.Panels[2].Text := Format('Last account time:%s',
       [FormatDateTime('dd/mm/yyyy hh:nn:ss',UnivDateTime2LocalDateTime(UnixToUnivDateTime( FNode.Bank.LastOperationBlock.timestamp )))]);
    end else begin
      StatusBar.Panels[2].Text := 'NO BLOCKCHAIN: '+errors;
    end;
  end else begin
    StatusBar.Panels[2].Text := '';
  end;
end;

procedure TFRMWallet.UpdateOperations;
Var accn : Int64;
begin
  accn := FrameAccountExplorer.AccountsGrid.AccountNumber(FrameAccountExplorer.dgAccounts.Row);
  FOperationsAccountGrid.AccountNumber := accn;
end;

initialization
  FRMWallet := Nil;
end.
