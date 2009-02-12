object frmWindowController: TfrmWindowController
  Left = 681
  Top = 156
  Width = 457
  Height = 278
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #12454#12451#12531#12489#12454#32113#21512#25805#20316
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXGroupBox1: TSpTBXGroupBox
    Left = 104
    Top = 8
    Width = 337
    Height = 199
    Caption = #12454#12451#12531#12489#12454#29366#24907#22793#26356
    TabOrder = 0
    Caption_UTF7 = '+MKYwozDzMMkwpnK2YUtZCWb0'
    object SpTBXGroupBox2: TSpTBXGroupBox
      Left = 10
      Top = 80
      Width = 319
      Height = 115
      Caption = #12454#12451#12531#12489#12454#31227#21205
      TabOrder = 0
      Caption_UTF7 = '+MKYwozDzMMkwpnn7UtU'
      object SpTBXLabel1: TSpTBXLabel
        Left = 8
        Top = 20
        Width = 37
        Height = 13
        Caption = 'X'#24231#27161' :'
        LinkFont.Charset = SHIFTJIS_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -12
        LinkFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
        LinkFont.Style = [fsUnderline]
        Caption_UTF7 = 'X+XqdqGQ :'
      end
      object SpTBXLabel2: TSpTBXLabel
        Left = 8
        Top = 44
        Width = 37
        Height = 13
        Caption = 'Y'#24231#27161' :'
        LinkFont.Charset = SHIFTJIS_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -12
        LinkFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
        LinkFont.Style = [fsUnderline]
        Caption_UTF7 = 'Y+XqdqGQ :'
      end
      object SpTBXLabel3: TSpTBXLabel
        Left = 24
        Top = 68
        Width = 19
        Height = 13
        Caption = #24133' :'
        LinkFont.Charset = SHIFTJIS_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -12
        LinkFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
        LinkFont.Style = [fsUnderline]
        Caption_UTF7 = '+XkU :'
      end
      object SpTBXLabel4: TSpTBXLabel
        Left = 16
        Top = 92
        Width = 27
        Height = 13
        Caption = #39640#12373' :'
        LinkFont.Charset = SHIFTJIS_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -12
        LinkFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
        LinkFont.Style = [fsUnderline]
        Caption_UTF7 = '+mtgwVQ :'
      end
      object edtPosX: TSpTBXEdit
        Left = 48
        Top = 16
        Width = 40
        Height = 21
        TabOrder = 4
        Text = '0'
        Alignment = taRightJustify
      end
      object edtPosY: TSpTBXEdit
        Left = 48
        Top = 40
        Width = 40
        Height = 21
        TabOrder = 5
        Text = '0'
        Alignment = taRightJustify
      end
      object edtPosWidth: TSpTBXEdit
        Left = 48
        Top = 64
        Width = 40
        Height = 21
        TabOrder = 6
        Text = '0'
        Alignment = taRightJustify
      end
      object edtPosHeight: TSpTBXEdit
        Left = 48
        Top = 88
        Width = 40
        Height = 21
        TabOrder = 7
        Text = '0'
        Alignment = taRightJustify
      end
      object trbPosX: TSpTBXTrackBar
        Left = 96
        Top = 16
        Width = 88
        Height = 24
        Max = 1024
        Min = -1024
        Orientation = trHorizontal
        Frequency = 1
        Position = 0
        SelEnd = 0
        SelStart = 0
        TabOrder = 8
        TickStyle = tsAuto
        OnChange = trbPositionChange
      end
      object trbPosY: TSpTBXTrackBar
        Left = 96
        Top = 40
        Width = 88
        Height = 25
        Max = 768
        Min = -768
        Orientation = trHorizontal
        Frequency = 1
        Position = 0
        SelEnd = 0
        SelStart = 0
        TabOrder = 9
        TickStyle = tsAuto
        OnChange = trbPositionChange
      end
      object trbPosWidth: TSpTBXTrackBar
        Left = 96
        Top = 64
        Width = 88
        Height = 24
        Max = 1024
        Orientation = trHorizontal
        Frequency = 1
        Position = 0
        SelEnd = 0
        SelStart = 0
        TabOrder = 10
        TickStyle = tsAuto
        OnChange = trbPositionChange
      end
      object trbPosHeight: TSpTBXTrackBar
        Left = 96
        Top = 88
        Width = 88
        Height = 24
        Max = 768
        Orientation = trHorizontal
        Frequency = 1
        Position = 0
        SelEnd = 0
        SelStart = 0
        TabOrder = 11
        TickStyle = tsAuto
        OnChange = trbPositionChange
      end
      object btnAppy: TSpTBXButton
        Left = 228
        Top = 37
        Width = 76
        Height = 21
        Caption = #36969#29992
        TabOrder = 12
        OnClick = btnAppyClick
        LinkFont.Charset = SHIFTJIS_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -12
        LinkFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
        LinkFont.Style = [fsUnderline]
        Caption_UTF7 = '+kGl1KA'
      end
      object btnGetWindowInfo: TSpTBXButton
        Left = 228
        Top = 61
        Width = 76
        Height = 21
        Caption = #21462#24471
        TabOrder = 13
        OnClick = btnGetWindowInfoClick
        LinkFont.Charset = SHIFTJIS_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -12
        LinkFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
        LinkFont.Style = [fsUnderline]
        Caption_UTF7 = '+U9Zflw'
      end
      object SpTBXButton2: TSpTBXButton
        Left = 228
        Top = 85
        Width = 76
        Height = 21
        Caption = #12522#12475#12483#12488
        TabOrder = 14
        LinkFont.Charset = SHIFTJIS_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -12
        LinkFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
        LinkFont.Style = [fsUnderline]
        Caption_UTF7 = '+MOowuzDDMMg'
      end
    end
  end
  object SpTBXStatusBar1: TSpTBXStatusBar
    Left = 4
    Top = 214
    Width = 358
    Height = 22
    Align = alNone
    SizeGrip = False
    ThemeType = thtWindows
    object SpTBXLabelItem1: TSpTBXLabelItem
      Caption = 'hint'
      CustomWidth = 280
    end
    object SpTBXSeparatorItem1: TSpTBXSeparatorItem
    end
    object SpTBXLabelItem2: TSpTBXLabelItem
      Caption = '0x00000000'
      CustomWidth = 100
    end
  end
  object btnClose: TSpTBXButton
    Left = 368
    Top = 215
    Width = 76
    Height = 21
    Caption = #38281#12376#12427
    TabOrder = 2
    OnClick = btnCloseClick
    LinkFont.Charset = SHIFTJIS_CHARSET
    LinkFont.Color = clBlue
    LinkFont.Height = -12
    LinkFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
    LinkFont.Style = [fsUnderline]
    Caption_UTF7 = '+lYkwWDCL'
  end
end
