unit UFRMNewPrivateKeyType;

interface

uses
  Windows,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, UWallet, UCrypto,
  System.Generics.Collections;

type
  TFRMNewPrivateKeyType = class(TForm)
    Label1: TLabel;
    ebName: TEdit;
    rgKeyType: TRadioGroup;
    bbOk: TBitBtn;
    bbCancel: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure bbOkClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FWalletKeys: TWalletKeys;
    FGeneratedPrivateKey: TECPrivateKey;
    procedure SetWalletKeys(const Value: TWalletKeys);
    { Private declarations }
  public
    { Public declarations }
    Property WalletKeys : TWalletKeys read FWalletKeys write SetWalletKeys;
    Property GeneratedPrivateKey : TECPrivateKey read FGeneratedPrivateKey write FGeneratedPrivateKey;
  end;


implementation

uses
  UAccounts, UConst;

{$R *.dfm}

procedure TFRMNewPrivateKeyType.bbOkClick(Sender: TObject);
begin
  if Not Assigned(WalletKeys) then exit;
  if rgKeyType.ItemIndex<0 then raise Exception.Create('Select a key type');

  if Assigned(FGeneratedPrivateKey) then FGeneratedPrivateKey.Free;

  FGeneratedPrivateKey := TECPrivateKey.Create;
  FGeneratedPrivateKey.GenerateRandomPrivateKey( PtrInt(rgKeyType.Items.Objects[rgKeyType.ItemIndex]) );
  WalletKeys.AddPrivateKey(ebName.Text,FGeneratedPrivateKey);
  ModalResult := MrOk;
end;

procedure TFRMNewPrivateKeyType.FormCreate(Sender: TObject);
Var l : TList<Word>;
  i : Integer;
begin
  FGeneratedPrivateKey := Nil;
  FWalletKeys := Nil;
  ebName.Text := DateTimeToStr(now);
  rgKeyType.Items.Clear;
  l := TList<Word>.Create;
  Try
    TAccountComp.ValidsEC_OpenSSL_NID(l);
    for i := 0 to l.Count - 1 do begin
      rgKeyType.Items.AddObject(TAccountComp.GetECInfoTxt(l[i]),TObject(l[i]));
    end;
  Finally
    l.free;
  End;
end;

procedure TFRMNewPrivateKeyType.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FGeneratedPrivateKey);
end;

procedure TFRMNewPrivateKeyType.SetWalletKeys(const Value: TWalletKeys);
begin
  FWalletKeys := Value;
end;

end.
