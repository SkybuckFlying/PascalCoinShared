unit UFRMWalletInstance;

interface

uses
  UFRMWallet,
  UFRMTestWallet;

{$IFDEF TESTNET}
var
  FRMWallet: TFRMTestWallet;
{$ELSE}
var
  FRMWallet: TFRMWallet;
{$ENDIF}

implementation

end.
