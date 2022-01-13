unit UFRMAbout;

interface

{$I ../config.inc}

uses
  pngimage, Windows,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons;

type
  { TFRMAbout }
  TFRMAbout = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Memo1: TMemo;
    bbClose: TBitBtn;
    lblBuild: TLabel;
    lblProtocolVersion: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
  private
    function GetBuildString : string;
    function GetProtocolVersionString : string;

    { Private declarations }
    Procedure OpenURL(Url : String);
  public
    { Public declarations }
  end;

implementation

uses
  ShellApi,
  UFolderHelper, UConst,
{$IFDEF Use_OpenSSL}
  UOpenSSL,
{$ENDIF}
  UNode;

{$R *.dfm}

function TFRMAbout.GetBuildString : string;
begin
  result :=
    'Build: ' + CT_ClientAppVersion
    + ' OpenSSL: '  +
    {$IFDEF Use_OpenSSL}
    IntToHex(OpenSSLVersion,8)
    {$ELSE}
      'NONE'
    {$ENDIF}  +
    ' Compiler: Delphi'
    {$IFDEF CPU32BITS}+' 32b'{$ELSE}+' 64b'{$ENDIF};
end;

function TFRMAbout.GetProtocolVersionString : string;
begin
  result :=
    Format
    (
      'BlockChain Protocol: %d (%d)  -  Net Protocol: %d (%d)',
      [
        TNode.Node.Bank.SafeBox.CurrentProtocol,
        CT_BlockChain_Protocol_Available,
        CT_NetProtocol_Version,
        CT_NetProtocol_Available
      ]
    );
end;

procedure TFRMAbout.FormCreate(Sender: TObject);
begin
  lblBuild.Caption := GetBuildString;
  lblProtocolVersion.Caption := GetProtocolVersionString;
end;

procedure TFRMAbout.Label4Click(Sender: TObject);
begin
  OpenURL(TLabel(Sender).Caption);
end;

procedure TFRMAbout.Label5Click(Sender: TObject);
begin
  OpenURL(TLabel(Sender).Caption);
end;


procedure TFRMAbout.OpenURL(Url: String);
begin
  shellexecute(0, 'open', pchar(URL), nil, nil, SW_SHOW)
end;

end.
