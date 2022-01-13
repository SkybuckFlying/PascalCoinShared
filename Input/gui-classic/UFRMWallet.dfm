object FRMWallet: TFRMWallet
  Left = 389
  Top = 201
  Caption = 'Pascal full node Wallet (Classic GUI)'
  ClientHeight = 580
  ClientWidth = 865
  Color = clBtnFace
  Constraints.MinHeight = 600
  Constraints.MinWidth = 865
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = True
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object SplitterTop: TSplitter
    Left = 0
    Top = 110
    Width = 865
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ResizeStyle = rsUpdate
    ExplicitTop = 108
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 865
    Height = 110
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    inline FrameInfo: TFrameInfo
      Left = 0
      Top = 0
      Width = 865
      Height = 110
      Align = alClient
      TabOrder = 0
      ExplicitWidth = 865
      ExplicitHeight = 110
      inherited PanelTop: TPanel
        Width = 865
        Height = 110
        ExplicitWidth = 865
        ExplicitHeight = 110
        inherited Splitter3: TSplitter
          Height = 108
          ExplicitHeight = 108
        end
        inherited Splitter1: TSplitter
          Height = 108
          ExplicitHeight = 108
        end
        inherited Splitter2: TSplitter
          Height = 108
          ExplicitHeight = 108
        end
        inherited Panel2: TPanel
          Height = 108
          ExplicitHeight = 108
        end
        inherited Panel3: TPanel
          Height = 108
          ExplicitHeight = 108
        end
        inherited Panel4: TPanel
          Width = 148
          Height = 108
          ExplicitWidth = 148
          ExplicitHeight = 108
        end
        inherited Panel1: TPanel
          Height = 108
          ExplicitHeight = 108
          inherited Image1: TImage
            Width = 71
            Height = 104
            ExplicitWidth = 71
            ExplicitHeight = 104
          end
        end
      end
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 557
    Width = 865
    Height = 23
    Panels = <
      item
        Alignment = taCenter
        Text = 'Server Active'
        Width = 130
      end
      item
        Text = 'Connection status'
        Width = 430
      end
      item
        Text = 'Blocks'
        Width = 50
      end>
  end
  object PanelMain: TPanel
    Left = 0
    Top = 142
    Width = 865
    Height = 415
    Align = alClient
    Caption = ' '
    TabOrder = 2
    object PageControl: TPageControl
      Left = 1
      Top = 1
      Width = 863
      Height = 413
      ActivePage = tsMyAccounts
      Align = alClient
      TabOrder = 0
      OnChange = PageControlChange
      object tsMyAccounts: TTabSheet
        Caption = 'Account Explorer'
        inline FrameAccountExplorer: TFrameAccountExplorer
          Left = 0
          Top = 0
          Width = 855
          Height = 385
          Align = alClient
          TabOrder = 0
          ExplicitWidth = 855
          ExplicitHeight = 385
          inherited Splitter1: TSplitter
            Height = 319
            ExplicitHeight = 359
          end
          inherited pnlMyAccountsTop: TPanel
            Width = 855
            ExplicitWidth = 855
          end
          inherited pnlAccounts: TPanel
            Height = 319
            ExplicitHeight = 319
            inherited dgAccounts: TDrawGrid
              Height = 285
              ExplicitHeight = 285
            end
            inherited pnlAccountsInfo: TPanel
              Top = 285
              ExplicitTop = 285
            end
          end
          inherited pcAccountsOptions: TPageControl
            Width = 450
            Height = 319
            ExplicitWidth = 450
            ExplicitHeight = 319
            inherited tsMultiSelectAccounts: TTabSheet
              ExplicitWidth = 442
              ExplicitHeight = 291
              inherited dgSelectedAccounts: TDrawGrid
                Height = 234
                ExplicitHeight = 234
              end
              inherited pnlSelectedAccountsTop: TPanel
                Width = 442
                ExplicitWidth = 442
              end
              inherited pnlSelectedAccountsBottom: TPanel
                Top = 265
                Width = 442
                ExplicitTop = 265
                ExplicitWidth = 442
              end
              inherited pnlSelectedAccountsLeft: TPanel
                Height = 234
                ExplicitHeight = 234
              end
            end
          end
        end
      end
      object tsPendingOperations: TTabSheet
        Caption = 'Pending Operations'
        ImageIndex = 5
        inline FramePendingOperations: TFramePendingOperations
          Left = 0
          Top = 0
          Width = 855
          Height = 385
          Align = alClient
          TabOrder = 0
          ExplicitWidth = 855
          ExplicitHeight = 385
          inherited dgPendingOperations: TDrawGrid
            Width = 855
            Height = 299
            ExplicitLeft = 0
            ExplicitTop = 86
            ExplicitWidth = 855
            ExplicitHeight = 299
          end
          inherited pnlPendingOperations: TPanel
            Width = 855
            ExplicitLeft = 0
            ExplicitWidth = 855
            inherited Label10: TLabel
              Width = 835
              ExplicitWidth = 835
            end
          end
        end
      end
      object tsBlockChain: TTabSheet
        Caption = 'Block Explorer'
        ImageIndex = 1
        inline FrameBlockChainExplorer: TFrameBlockChainExplorer
          Left = 0
          Top = 0
          Width = 855
          Height = 385
          Align = alClient
          TabOrder = 0
          ExplicitWidth = 855
          ExplicitHeight = 385
          inherited Panel2: TPanel
            Width = 855
            ExplicitWidth = 855
          end
          inherited dgBlockChainExplorer: TDrawGrid
            Width = 855
            Height = 344
            ExplicitWidth = 855
            ExplicitHeight = 344
          end
        end
      end
      object tsOperations: TTabSheet
        Caption = 'Operations Explorer'
        ImageIndex = 1
        inline FrameOperationsExplorer: TFrameOperationsExplorer
          Left = 0
          Top = 0
          Width = 855
          Height = 385
          Align = alClient
          TabOrder = 0
          ExplicitWidth = 855
          ExplicitHeight = 385
          inherited Panel1: TPanel
            Width = 855
            ExplicitWidth = 855
          end
          inherited dgOperationsExplorer: TDrawGrid
            Width = 855
            Height = 344
            ExplicitWidth = 855
            ExplicitHeight = 344
          end
        end
      end
      object tsLogs: TTabSheet
        Caption = 'Logs'
        ImageIndex = 2
        inline FrameLogs: TFrameLogs
          Left = 0
          Top = 0
          Width = 855
          Height = 385
          Align = alClient
          TabOrder = 0
          ExplicitWidth = 855
          ExplicitHeight = 385
          inherited memoLogs: TMemo
            Width = 855
            Height = 352
            ExplicitWidth = 855
            ExplicitHeight = 352
          end
          inherited pnlTopLogs: TPanel
            Width = 855
            ExplicitWidth = 855
            inherited ButtonCopyLogToClipboard: TButton
              Left = 714
              ExplicitLeft = 714
            end
          end
        end
      end
      object tsNodeStats: TTabSheet
        Caption = 'Node Stats'
        ImageIndex = 3
        inline FrameNodeStats: TFrameNodeStats
          Left = 0
          Top = 0
          Width = 855
          Height = 385
          Align = alClient
          TabOrder = 0
          ExplicitWidth = 855
          ExplicitHeight = 385
          inherited Splitter1: TSplitter
            Width = 855
            ExplicitWidth = 857
          end
          inherited Splitter2: TSplitter
            Top = 228
            Width = 855
            ExplicitTop = 264
            ExplicitWidth = 857
          end
          inherited PanelTop: TPanel
            Width = 855
            ExplicitWidth = 855
            inherited Panel4: TPanel
              Width = 855
              ExplicitWidth = 855
            end
            inherited memoNetConnections: TMemo
              Width = 855
              ExplicitWidth = 855
            end
          end
          inherited PanelMiddle: TPanel
            Width = 855
            Height = 72
            ExplicitWidth = 855
            ExplicitHeight = 72
            inherited Panel1: TPanel
              Width = 855
              ExplicitWidth = 855
            end
            inherited memoNetBlackLists: TMemo
              Width = 855
              Height = 52
              ExplicitWidth = 855
              ExplicitHeight = 52
            end
          end
          inherited PanelBottom: TPanel
            Top = 231
            Width = 855
            ExplicitTop = 231
            ExplicitWidth = 855
            inherited Panel2: TPanel
              Width = 855
              ExplicitWidth = 855
            end
            inherited memoNetServers: TMemo
              Width = 855
              ExplicitWidth = 855
            end
          end
        end
      end
      object tsMessages: TTabSheet
        Caption = 'Messages'
        ImageIndex = 6
        inline FrameMessages: TFrameMessages
          Left = 0
          Top = 0
          Width = 855
          Height = 385
          Align = alClient
          TabOrder = 0
          ExplicitWidth = 855
          ExplicitHeight = 385
          inherited Splitter1: TSplitter
            Top = 132
            Width = 855
            ExplicitTop = 205
            ExplicitWidth = 857
          end
          inherited PanelBottom: TPanel
            Top = 135
            Width = 855
            ExplicitTop = 135
            ExplicitWidth = 855
            inherited Panel1: TPanel
              Width = 855
              ExplicitWidth = 855
            end
            inherited memoMessages: TMemo
              Width = 855
              ExplicitWidth = 855
            end
          end
          inherited PanelTop: TPanel
            Width = 855
            Height = 132
            ExplicitWidth = 855
            ExplicitHeight = 132
            inherited Splitter2: TSplitter
              Height = 132
              ExplicitHeight = 203
            end
            inherited PanelLeft: TPanel
              Height = 132
              ExplicitHeight = 132
              inherited lbNetConnections: TListBox
                Height = 112
                ExplicitHeight = 112
              end
            end
            inherited PanelRight: TPanel
              Width = 564
              Height = 132
              ExplicitWidth = 564
              ExplicitHeight = 132
              inherited memoMessageToSend: TMemo
                Width = 564
                Height = 46
                ExplicitWidth = 564
                ExplicitHeight = 46
              end
              inherited Panel6: TPanel
                Width = 564
                ExplicitWidth = 564
              end
              inherited Panel7: TPanel
                Top = 66
                Width = 564
                ExplicitTop = 66
                ExplicitWidth = 564
                DesignSize = (
                  564
                  66)
                inherited bbSendAMessage: TButton
                  Width = 541
                  ExplicitWidth = 541
                end
              end
            end
          end
        end
      end
    end
  end
  object PanelNodeStatus: TPanel
    Left = 0
    Top = 113
    Width = 865
    Height = 29
    Align = alTop
    BevelKind = bkTile
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 3
    object lblNodeCaption: TLabel
      Left = 55
      Top = 5
      Width = 63
      Height = 13
      Alignment = taRightJustify
      Caption = 'Node Status:'
      Color = clBtnFace
      ParentColor = False
    end
    object lblNodeStatus: TLabel
      Left = 124
      Top = 5
      Width = 15
      Height = 13
      Caption = '???'
      Color = clBtnFace
      ParentColor = False
    end
  end
  object TimerUpdateStatus: TTimer
    OnTimer = TimerUpdateStatusTimer
    Left = 801
    Top = 13
  end
  object MainMenu: TMainMenu
    Left = 341
    Top = 24
    object miProject: TMenuItem
      Caption = 'Project'
      object miPrivatekeys: TMenuItem
        Caption = 'Private Keys'
        ShortCut = 16464
        OnClick = miPrivatekeysClick
      end
      object miN1: TMenuItem
        Caption = '-'
      end
      object miOptions: TMenuItem
        Caption = 'Options'
        ShortCut = 16463
        OnClick = miOptionsClick
      end
      object IPnodes1: TMenuItem
        Caption = 'Available Node List'
        OnClick = IPnodes1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object MiClose: TMenuItem
        Caption = 'Close'
        OnClick = MiCloseClick
      end
    end
    object MiOperations: TMenuItem
      Caption = 'Operations'
      object miNewOperation: TMenuItem
        Caption = 'New single Operation'
        ShortCut = 120
        OnClick = miNewOperationClick
      end
      object MiFindOperationbyOpHash: TMenuItem
        Caption = 'Find Operation by OpHash'
        ShortCut = 116
        OnClick = MiFindOperationbyOpHashClick
      end
      object MiDecodePayload: TMenuItem
        Caption = 'Decode Payload'
        ShortCut = 113
        OnClick = MiDecodePayloadClick
      end
      object MiFindaccount: TMenuItem
        Caption = 'Find account'
        ShortCut = 16454
        OnClick = MiFindaccountClick
      end
      object MiAccountInformation: TMenuItem
        Caption = 'Account Information'
        ShortCut = 112
        OnClick = MiAccountInformationClick
      end
      object MiOperationsExplorer: TMenuItem
        Caption = 'Operations Explorer'
        ShortCut = 16453
        OnClick = MiOperationsExplorerClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object MiAddaccounttoSelected: TMenuItem
        Caption = 'Add account to selected'
        ShortCut = 117
        OnClick = MiAddaccounttoSelectedClick
      end
      object MiRemoveaccountfromselected: TMenuItem
        Caption = 'Remove account from selected'
        ShortCut = 118
        OnClick = MiRemoveaccountfromselectedClick
      end
      object MiMultiaccountoperation: TMenuItem
        Caption = 'Multi account operation'
        OnClick = MiMultiaccountoperationClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object MiFindpreviousaccountwithhighbalance: TMenuItem
        Caption = 'Find previous account with high balance'
        ShortCut = 16498
        OnClick = MiFindpreviousaccountwithhighbalanceClick
      end
      object MiFindnextaccountwithhighbalance: TMenuItem
        Caption = 'Find next account with high balance'
        ShortCut = 114
        OnClick = MiFindnextaccountwithhighbalanceClick
      end
    end
    object Views: TMenuItem
      Caption = 'Views'
      object MenuItemThreads: TMenuItem
        Caption = 'Threads'
        OnClick = MenuItemThreadsClick
      end
      object MenuItemCriticalSections: TMenuItem
        Caption = 'Critical Sections'
        OnClick = MenuItemCriticalSectionsClick
      end
    end
    object miAbout: TMenuItem
      Caption = 'About'
      object miAboutPascalCoin: TMenuItem
        Caption = 'About Pascal Coin...'
        OnClick = miAboutPascalCoinClick
      end
    end
  end
end
