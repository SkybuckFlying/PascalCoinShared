object FRMPascalCoinWalletConfig: TFRMPascalCoinWalletConfig
  Left = 462
  Top = 234
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Options'
  ClientHeight = 329
  ClientWidth = 475
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 270
    Width = 475
    Height = 59
    Align = alBottom
    Caption = ' '
    TabOrder = 0
    object bbOk: TBitBtn
      Left = 16
      Top = 14
      Width = 75
      Height = 30
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
      OnClick = bbOkClick
    end
    object bbCancel: TBitBtn
      Left = 107
      Top = 14
      Width = 75
      Height = 30
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object PageControlWalletConfig: TPageControl
    Left = 0
    Top = 0
    Width = 475
    Height = 270
    ActivePage = TabSheetMiner
    Align = alClient
    TabOrder = 1
    object TabSheetPassword: TTabSheet
      Caption = 'Password'
      object bbUpdatePassword: TBitBtn
        Left = 15
        Top = 14
        Width = 337
        Height = 38
        Caption = 'Wallet Password'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        Glyph.Data = {
          76060000424D7606000000000000360400002800000018000000180000000100
          0800000000004002000000000000000000000001000000010000000000000101
          0100020202000303030004040400050505000606060007070700080808000909
          09000A0A0A000B0B0B000C0C0C000D0D0D000E0E0E000F0F0F00101010001111
          1100121212001313130014141400151515001616160017171700181818001919
          19001A1A1A001B1B1B001C1C1C001D1D1D001E1E1E001F1F1F00202020002121
          2100222222002323230024242400252525002626260027272700282828002929
          29002A2A2A002B2B2B002C2C2C002D2D2D002E2E2E002F2F2F00303030003131
          3100323232003333330034343400353535003636360037373700383838003939
          39003A3A3A003B3B3B003C3C3C003D3D3D003E3E3E003F3F3F00404040004141
          4100424242004343430044444400454545004646460047474700484848004949
          49004A4A4A004B4B4B004C4C4C004D4D4D004E4E4E004F4F4F00505050005151
          5100525252005353530054545400555555005656560057575700585858005959
          59005A5A5A005B5B5B005C5C5C005D5D5D005E5E5E00685968007C4F7C009441
          9400B72CB700DD15DD00F506F500FD01FD00FE00FE00FE00FE00FE00FE00FE00
          FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00
          FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00
          FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00
          FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00
          FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00
          FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00
          FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00
          FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00
          FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00
          FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00
          FE00FE00FE00FE00FE00FE00FE00F008F900D517F000BD24E800A830E1007B4B
          D0005065C1003774B7002B7DB100237FAC001F82AD001C83AD001785AE001687
          AF001489B100128AB300108CB6000F8EB9000D91BB000C94BF000A97C3000A99
          C5000A9AC7000B9BC8000B9CCA000C9ECC000C9FCD000DA0CE000DA1CE000EA2
          CF0011A3CF0015A4CF0018A5CF001CA7D10021A9D1002AAAD00035AACD0035AD
          D00035AFD30035B1D60037B5D8003AB8DB003EB9DC0040BBDD0045BEDE004CC1
          E00055C6E3005BC8E40061CAE40066CBE3006BCCE30072D3E60078D8EB0080D8
          EE0083D9F10085DCF40088DBF5008BDBF6008EDAF70091DAF70095DCF70097E0
          F7009EE3F800A4E7F900A9E9F900AEE9F900B5EBF900B2EBF800919191919191
          919191919191919191919191919191919191919191919191D5E7E8E7E3DED591
          919191919191919191919191919191D6DDF7F8F8F7F6F4EEE6D5919191919191
          919191919191D7DADEF8F8F6F7F6EDF1F8F1E69191919191919191919191DADE
          DFFAFAF8F7F7E9EDF7F7F8EB91919191919191919191DDE5E3FCFCFAFAEEE0E9
          F3F7F7F7DC919191919191919191DEE7E4FEFEFCFCEDC5E0EFF7F6F6DC919191
          919191919191DEEAE7FEFEFEFDFBC4C4F5F7F6F6DC919191919191919191E3EC
          E9FEFEFEFEFEE0C3F9F7F6F6DC919191919191919191E3E9E3F8F8F1F1F8FBFB
          FCFAF7F6DC919191919191919191DCEAEAE0E1E9E5E3DEE4EBF2FAF9DC919191
          919191919191DBF3EEC5C5EFF3EBE5DDD9D6E6F5DC91919191919191919191D5
          E8EDF1FAF6F0EAE4DAD1D2DBDC919191919191919191919191DBE8F0F3F3F3E4
          D0CFE4D8DC919191919191919191919191919191D5DEE4DED2CFD4D491919191
          91919191919191919191919191919191D2CE9191919191919191919191919191
          91C8C89191919191D2CE919191919191919191919191919191D9D09191919191
          D2CE919191919191919191919191919191E6E39191919191D2CE919191919191
          919191919191919191E0F3CE91919191D2CE9191919191919191919191919191
          9191EFF6E1C9C8CDD9CC91919191919191919191919191919191C9EDF9F3F3EB
          DC91919191919191919191919191919191919191CBE0E1CF9191919191919191
          9191919191919191919191919191919191919191919191919191}
        ParentFont = False
        TabOrder = 0
        OnClick = bbUpdatePasswordClick
      end
    end
    object TabSheetMiner: TTabSheet
      Caption = 'Miner'
      ImageIndex = 1
      object Label3: TLabel
        Left = 15
        Top = 19
        Width = 60
        Height = 13
        Caption = 'Miner Name:'
        Color = clBtnFace
        ParentColor = False
      end
      object Label4: TLabel
        Left = 103
        Top = 43
        Width = 259
        Height = 13
        Caption = 'This name will be included in each new block you mine!'
        Color = clBtnFace
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Pitch = fpVariable
        Font.Style = []
        Font.Quality = fqDraft
        ParentColor = False
        ParentFont = False
      end
      object lblDefaultInternetServerPort: TLabel
        Left = 281
        Top = 72
        Width = 70
        Height = 13
        Caption = '(Default XXXX)'
        Color = clBtnFace
        ParentColor = False
      end
      object Label2: TLabel
        Left = 15
        Top = 72
        Width = 98
        Height = 13
        Caption = 'Internet Server Port'
        Color = clBtnFace
        ParentColor = False
      end
      object ebMinerName: TEdit
        Left = 103
        Top = 16
        Width = 298
        Height = 21
        TabOrder = 0
        Text = 'ebMinerName'
      end
      object ebInternetServerPort: TEdit
        Left = 203
        Top = 69
        Width = 56
        Height = 21
        Alignment = taRightJustify
        TabOrder = 1
        Text = '4004'
      end
      object udInternetServerPort: TUpDown
        Left = 259
        Top = 69
        Width = 16
        Height = 21
        Associate = ebInternetServerPort
        Min = 1
        Max = 25000
        Position = 4004
        TabOrder = 2
        Thousands = False
      end
      object gbMinerPrivateKey: TGroupBox
        Left = 15
        Top = 104
        Width = 386
        Height = 121
        Caption = ' Miner Server Private Key: '
        TabOrder = 3
        object rbGenerateANewPrivateKeyEachBlock: TRadioButton
          Left = 18
          Top = 22
          Width = 351
          Height = 19
          Caption = 'Generate a new private key for each generated block'
          TabOrder = 0
        end
        object rbUseARandomKey: TRadioButton
          Left = 18
          Top = 42
          Width = 351
          Height = 19
          Caption = 'Use a random existing key'
          TabOrder = 1
        end
        object rbMineAllwaysWithThisKey: TRadioButton
          Left = 18
          Top = 63
          Width = 351
          Height = 19
          Caption = 'Always mine with this key:'
          TabOrder = 2
        end
        object cbPrivateKeyToMine: TComboBox
          Left = 35
          Top = 88
          Width = 334
          Height = 21
          Style = csDropDownList
          TabOrder = 3
        end
      end
    end
    object TabSheetBlockchain: TTabSheet
      Caption = 'Blockchain'
      ImageIndex = 3
      object ebMinFutureBlocksToDownloadNewSafebox: TEdit
        Left = 352
        Top = 16
        Width = 53
        Height = 21
        Alignment = taRightJustify
        TabOrder = 0
        Text = '0'
      end
      object cbDownloadNewCheckpoint: TCheckBox
        Left = 15
        Top = 16
        Width = 330
        Height = 19
        Caption = 'Download new Checkpoint if blockchain older than...'
        TabOrder = 1
        OnClick = cbDownloadNewCheckpointClick
      end
    end
    object TabSheetOperations: TTabSheet
      Caption = 'Operations'
      ImageIndex = 4
      object Label1: TLabel
        Left = 15
        Top = 19
        Width = 120
        Height = 13
        Caption = 'Default fee for operation'
        Color = clBtnFace
        ParentColor = False
      end
      object ebDefaultFee: TEdit
        Left = 178
        Top = 16
        Width = 56
        Height = 21
        Alignment = taRightJustify
        TabOrder = 0
        Text = '0'
      end
    end
    object TabSheetLogs: TTabSheet
      Caption = 'Logs'
      ImageIndex = 5
      object cbSaveLogFiles: TCheckBox
        Left = 15
        Top = 19
        Width = 78
        Height = 19
        Caption = 'Save log file'
        TabOrder = 0
        OnClick = cbSaveLogFilesClick
      end
      object cbShowLogs: TCheckBox
        Left = 15
        Top = 57
        Width = 68
        Height = 19
        Caption = 'Show logs'
        TabOrder = 1
      end
      object cbShowModalMessages: TCheckBox
        Left = 15
        Top = 82
        Width = 127
        Height = 19
        Caption = 'Show modal messages'
        TabOrder = 2
      end
      object cbSaveDebugLogs: TCheckBox
        Left = 31
        Top = 37
        Width = 118
        Height = 19
        Caption = 'Save debug logs too'
        TabOrder = 3
      end
    end
    object TabSheetStorage: TTabSheet
      Caption = 'Storage'
      ImageIndex = 7
      object bbOpenDataFolder: TBitBtn
        Left = 15
        Top = 16
        Width = 131
        Height = 30
        Caption = 'Open Data Folder'
        Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000064000000640000000000000000000000078DBE4D078D
          BEFF078DBEFF078DBEFF078DBEFF078DBEFF078DBEFF078DBEFF078DBEFF078D
          BEFF078DBEFF078DBEFF078DBEFF078DBEFFFFFFFF00FFFFFF00078DBEFF25A1
          D1FF70C6E7FF6BCFF9FF66CDF9FF65CDF9FF65CDF9FF65CDF9FF65CDF8FF65CD
          F9FF65CDF8FF66CEF9FF39ADD8FF078DBEFF078DBE4DFFFFFF00078DBEFF4CBC
          E7FF5EB8DAFF94DFFBFF6FD4FAFF6FD4F9FF6ED4FAFF6FD4F9FF6FD4FAFF6FD4
          FAFF6FD4FAFF6ED4F9FF3EB1D9FF84D7EBFF078DBEFFFFFFFF00078DBEFF72D6
          FAFF1593C2FFB6ECFDFF7DDDFBFF79DCFBFF79DCFBFF79DCFBFF79DCFBFF7ADC
          FBFF79DCFAFF79DCFAFF44B5D9FFAEF1F9FF078DBEFFFFFFFF00078DBEFF79DD
          FBFF1899C7FF94DDF3FFA2EBFCFF84E4FBFF83E4FCFF83E4FCFF84E4FCFF83E4
          FCFF83E4FBFF84E5FCFF48B9DAFFB3F4F9FF078DBEFF078DBE4D078DBEFF82E3
          FCFF43B7DCFF4BB9DBFFBFF4FDFF8EEBFCFF8DEBFCFF8DEBFDFF8DEBFDFF8DEB
          FCFF8DEBFDFF8DEBFCFF4CBBDAFFB6F7F9FF6DCAE0FF078DBEFF078DBEFF8AEA
          FCFF77DCF3FF1496C3FFFFFFFFFFC9F8FEFFC9F8FEFFC9F8FEFFC9F8FFFFC9F7
          FFFFC9F8FEFFC9F8FFFF9CD6E7FFDFFAFBFFDBF7FAFF078DBEFF078DBEFF93F0
          FEFF93F0FDFF1697C5FF078DBEFF078DBEFF078DBEFF078DBEFF078DBEFF078D
          BEFF078DBEFF078DBEFF078DBEFF078DBEFF078DBEFF078DBEFF078DBEFF9BF5
          FEFF9AF6FEFF9AF6FEFF9BF5FDFF9BF6FEFF9AF6FEFF9BF5FEFF9AF6FDFF9BF5
          FEFF9AF6FEFF9AF6FEFF0989BAFFFFFFFF00FFFFFF00FFFFFF00078DBEFFFEFE
          FEFFA0FBFFFFA0FBFEFFA0FBFEFFA1FAFEFFA1FBFEFFA0FAFEFFA1FBFEFFA1FB
          FFFFA0FBFFFFA1FBFFFF0989BAFFFFFFFF00FFFFFF00FFFFFF00078DBE4D078D
          BEFFFEFEFEFFA5FEFFFFA5FEFFFFA5FEFFFF078DBEFF078DBEFF078DBEFF078D
          BEFF078DBEFF078DBEFFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00078D
          BE4D078DBEFF078DBEFF078DBEFF078DBEFF078DBE4DFFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00}
        TabOrder = 0
        OnClick = bbOpenDataFolderClick
      end
    end
  end
end
