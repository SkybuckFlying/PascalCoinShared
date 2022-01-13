program PascalCoinWallet;

{$I ..\..\Input\config.inc}

uses
  Forms,
  SysUtils,
  UFRMAbout in '..\..\Input\gui-classic\UFRMAbout.pas' {FRMAbout},
  UFRMAccountSelect in '..\..\Input\gui-classic\UFRMAccountSelect.pas' {FRMAccountSelect},
  UFRMMemoText in '..\..\Input\gui-classic\UFRMMemoText.pas' {FRMMemoText},
  UFRMNewPrivateKeyType in '..\..\Input\gui-classic\UFRMNewPrivateKeyType.pas' {FRMNewPrivateKeyType},
  UFRMNodesIp in '..\..\Input\gui-classic\UFRMNodesIp.pas' {FRMNodesIp},
  UFRMOperation in '..\..\Input\gui-classic\UFRMOperation.pas' {FRMOperation},
  UFRMOperationsExplorer in '..\..\Input\gui-classic\UFRMOperationsExplorer.pas' {FRMOperationsExplorer},
  UFRMWalletConfig in '..\..\Input\gui-classic\UFRMWalletConfig.pas' {FRMPascalCoinWalletConfig},
  UFRMPayloadDecoder in '..\..\Input\gui-classic\UFRMPayloadDecoder.pas' {FRMPayloadDecoder},
  UFRMRandomOperations in '..\..\Input\gui-classic\UFRMRandomOperations.pas' {FRMRandomOperations},
  UFRMWallet in '..\..\Input\gui-classic\UFRMWallet.pas' {FRMWallet},
  UFRMWalletKeys in '..\..\Input\gui-classic\UFRMWalletKeys.pas' {FRMWalletKeys},
  UGridUtils in '..\..\Input\gui-classic\UGridUtils.pas',
  UGUIUtils in '..\..\Input\gui-classic\UGUIUtils.pas',
  UFRMHashLock in '..\..\Input\gui-classic\UFRMHashLock.pas' {FRMHashLock},
  UFRMDiagnosticTool in '..\..\Input\gui-classic\UFRMDiagnosticTool.pas' {FRMDiagnosticTool},
  UFRMTestWallet in '..\..\Input\gui-classic\UFRMTestWallet.pas' {FRMTestWallet},
  UFRMWalletUserMessages in '..\..\Input\gui-classic\UFRMWalletUserMessages.pas',
  UFRMWalletInformation in '..\..\Input\gui-classic\UFRMWalletInformation.pas',
  UFRMWalletInstance in '..\..\Input\gui-classic\UFRMWalletInstance.pas',
  UCommon in '..\..\Input\libraries\sphere10\UCommon.pas',
  UMemory in '..\..\Input\libraries\sphere10\UMemory.pas',
  UFolderHelper in '..\..\Input\libraries\pascalcoin\UFolderHelper.pas',
  UAppParams in '..\..\Input\libraries\pascalcoin\UAppParams.pas',
  UEPasaDecoder in '..\..\Input\libraries\pascalcoin\UEPasaDecoder.pas',
  UAccountKeyStorage in '..\..\Input\libraries\PascalCoin\UAccountKeyStorage.pas',
  UAccounts in '..\..\Input\libraries\PascalCoin\UAccounts.pas',
  UAES in '..\..\Input\libraries\PascalCoin\UAES.pas',
  UBaseTypes in '..\..\Input\libraries\PascalCoin\UBaseTypes.pas',
  UBlockChain in '..\..\Input\libraries\PascalCoin\UBlockChain.pas',
  UChunk in '..\..\Input\libraries\PascalCoin\UChunk.pas',
  UConst in '..\..\Input\libraries\PascalCoin\UConst.pas',
  UCrypto in '..\..\Input\libraries\PascalCoin\UCrypto.pas',
  UECIES in '..\..\Input\libraries\PascalCoin\UECIES.pas',
  UEncoding in '..\..\Input\libraries\PascalCoin\UEncoding.pas',
  UEPasa in '..\..\Input\libraries\PascalCoin\UEPasa.pas',
  UFileStorage in '..\..\Input\libraries\PascalCoin\UFileStorage.pas',
  ULog in '..\..\Input\libraries\PascalCoin\ULog.pas',
  UMurMur3Fast in '..\..\Input\libraries\PascalCoin\UMurMur3Fast.pas',
  UNetProtection in '..\..\Input\libraries\PascalCoin\UNetProtection.pas',
  UNetProtocol in '..\..\Input\libraries\PascalCoin\UNetProtocol.pas',
  UNode in '..\..\Input\libraries\PascalCoin\UNode.pas',
  UOpenSSL in '..\..\Input\libraries\PascalCoin\UOpenSSL.pas',
  UOpTransaction in '..\..\Input\libraries\PascalCoin\UOpTransaction.pas',
  UPCAbstractMem in '..\..\Input\libraries\PascalCoin\UPCAbstractMem.pas',
  UPCAccountsOrdenations in '..\..\Input\libraries\PascalCoin\UPCAccountsOrdenations.pas',
  UPCCryptoLib4Pascal in '..\..\Input\libraries\PascalCoin\UPCCryptoLib4Pascal.pas',
  UPCEncryption in '..\..\Input\libraries\PascalCoin\UPCEncryption.pas',
  UPCHardcodedRandomHashTable in '..\..\Input\libraries\PascalCoin\UPCHardcodedRandomHashTable.pas',
  UPCOperationsBlockValidator in '..\..\Input\libraries\PascalCoin\UPCOperationsBlockValidator.pas',
  UPCOperationsSignatureValidator in '..\..\Input\libraries\PascalCoin\UPCOperationsSignatureValidator.pas',
  UPCOrderedLists in '..\..\Input\libraries\PascalCoin\UPCOrderedLists.pas',
  UPCSafeBoxRootHash in '..\..\Input\libraries\PascalCoin\UPCSafeBoxRootHash.pas',
  UPCTemporalAbstractMem in '..\..\Input\libraries\PascalCoin\UPCTemporalAbstractMem.pas',
  UPCTemporalFileStream in '..\..\Input\libraries\PascalCoin\UPCTemporalFileStream.pas',
  UPCTNetDataExtraMessages in '..\..\Input\libraries\PascalCoin\UPCTNetDataExtraMessages.pas',
  UPCDataTypes in '..\..\Input\libraries\PascalCoin\UPCDataTypes.pas',
  URandomHash in '..\..\Input\libraries\PascalCoin\URandomHash.pas',
  URandomHash2 in '..\..\Input\libraries\PascalCoin\URandomHash2.pas',
  USettings in '..\..\Input\libraries\PascalCoin\USettings.pas',
  USha256 in '..\..\Input\libraries\PascalCoin\USha256.pas',
  UTCPIP in '..\..\Input\libraries\PascalCoin\UTCPIP.pas',
  UTime in '..\..\Input\libraries\PascalCoin\UTime.pas',
  UTxMultiOperation in '..\..\Input\libraries\PascalCoin\UTxMultiOperation.pas',
  UWallet in '..\..\Input\libraries\PascalCoin\UWallet.pas',
  UPCOpenSSLSignature in '..\..\Input\libraries\PascalCoin\UPCOpenSSLSignature.pas',
  UAbstractAVLTree in '..\..\Input\libraries\abstractmem\UAbstractAVLTree.pas',
  UAbstractBTree in '..\..\Input\libraries\abstractmem\UAbstractBTree.pas',
  UAbstractMem in '..\..\Input\libraries\abstractmem\UAbstractMem.pas',
  UAbstractMemBTree in '..\..\Input\libraries\abstractmem\UAbstractMemBTree.pas',
  UAbstractMemTList in '..\..\Input\libraries\abstractmem\UAbstractMemTList.pas',
  UAVLCache in '..\..\Input\libraries\abstractmem\UAVLCache.pas',
  UCacheMem in '..\..\Input\libraries\abstractmem\UCacheMem.pas',
  UFileMem in '..\..\Input\libraries\abstractmem\UFileMem.pas',
  UOrderedList in '..\..\Input\libraries\abstractmem\UOrderedList.pas',
  UPCAbstractMemAccountKeys in '..\..\Input\libraries\PascalCoin\UPCAbstractMemAccountKeys.pas',
  UPCAbstractMemAccounts in '..\..\Input\libraries\PascalCoin\UPCAbstractMemAccounts.pas',
  UFrameAccountExplorer in '..\..\Input\gui-classic\Frames\UFrameAccountExplorer.pas' {FrameAccountExplorer: TFrame},
  UFrameBlockExplorer in '..\..\Input\gui-classic\Frames\UFrameBlockExplorer.pas' {FrameBlockChainExplorer: TFrame},
  UFrameInfo in '..\..\Input\gui-classic\Frames\UFrameInfo.pas' {FrameInfo: TFrame},
  UFrameLogs in '..\..\Input\gui-classic\Frames\UFrameLogs.pas' {FrameLogs: TFrame},
  UFrameMessages in '..\..\Input\gui-classic\Frames\UFrameMessages.pas' {FrameMessages: TFrame},
  UFrameNodeStats in '..\..\Input\gui-classic\Frames\UFrameNodeStats.pas' {FrameNodeStats: TFrame},
  UFrameOperationsExplorer in '..\..\Input\gui-classic\Frames\UFrameOperationsExplorer.pas' {FrameOperationsExplorer: TFrame},
  UFramePendingOperations in '..\..\Input\gui-classic\Frames\UFramePendingOperations.pas' {FramePendingOperations: TFrame},
  UFRMThreads in '..\..\Input\gui-classic\UFRMThreads.pas' {FRMThreads},
  UFRMCriticalSections in '..\..\Input\gui-classic\UFRMCriticalSections.pas' {FRMCriticalSections},
  UThread in '..\..\Input\libraries\PascalCoin\Threads\UThread.pas',
  UThread.CriticalSection in '..\..\Input\libraries\PascalCoin\Threads\UThread.CriticalSection.pas',
  UThread.Pipeline in '..\..\Input\libraries\PascalCoin\Threads\UThread.Pipeline.pas',
  UThread.CriticalSectionList in '..\..\Input\libraries\PascalCoin\Threads\UThread.CriticalSectionList.pas',
  UThread.ThreadList in '..\..\Input\libraries\PascalCoin\Threads\UThread.ThreadList.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Pascal Coin Wallet, Miner & Explorer';
  {$IFDEF TESTNET}
  Application.CreateForm(TFRMTestWallet, FRMWallet);
  {$ELSE}
  Application.CreateForm(TFRMWallet, FRMWallet);
  Application.CreateForm(TFRMThreads, FRMThreads);
  Application.CreateForm(TFRMCriticalSections, FRMCriticalSections);
  {$ENDIF}
  Application.CreateForm(TFRMThreads, FRMThreads);
  Application.Run;
end.




