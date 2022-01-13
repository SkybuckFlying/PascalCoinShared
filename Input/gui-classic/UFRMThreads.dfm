object FRMThreads: TFRMThreads
  Left = 0
  Top = 0
  Caption = 'PascalCoin Threads'
  ClientHeight = 486
  ClientWidth = 654
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 654
    Height = 41
    Align = alTop
    Caption = ' '
    TabOrder = 0
    object LabelInMilliseconds: TLabel
      Left = 159
      Top = 14
      Width = 66
      Height = 13
      Caption = 'in milliseconds'
    end
    object LabeledEditRefreshInterval: TLabeledEdit
      Left = 96
      Top = 11
      Width = 57
      Height = 21
      EditLabel.Width = 81
      EditLabel.Height = 13
      EditLabel.Caption = 'Refresh interval:'
      LabelPosition = lpLeft
      TabOrder = 0
      Text = '10'
      OnExit = LabeledEditRefreshIntervalExit
    end
  end
  object MemoThreadInfo: TMemo
    Left = 0
    Top = 41
    Width = 654
    Height = 445
    Align = alClient
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object TimerRefresh: TTimer
    Interval = 1
    OnTimer = TimerRefreshTimer
    Left = 264
    Top = 8
  end
end
