object frmWindowController: TfrmWindowController
  Left = 218
  Top = 159
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #12454#12451#12531#12489#12454#32113#21512#25805#20316
  ClientHeight = 257
  ClientWidth = 609
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
  object SpTBXStatusBar1: TSpTBXStatusBar
    Left = 4
    Top = 234
    Width = 517
    Height = 28
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
    Left = 528
    Top = 233
    Width = 76
    Height = 21
    Caption = #38281#12376#12427
    TabOrder = 1
    OnClick = btnCloseClick
    LinkFont.Charset = SHIFTJIS_CHARSET
    LinkFont.Color = clBlue
    LinkFont.Height = -12
    LinkFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
    LinkFont.Style = [fsUnderline]
    Caption_UTF7 = '+lYkwWDCL'
  end
  object SpTBXTabControl1: TSpTBXTabControl
    Left = 4
    Top = 3
    Width = 604
    Height = 229
    ActiveTabIndex = 3
    Images = imlTool
    HiddenItems = <>
    object SpTBXTabItem6: TSpTBXTabItem
      Caption = #12454#12451#12531#12489#12454#29366#24907#22793#26356
      ImageIndex = 0
      Caption_UTF7 = '+MKYwozDzMMkwpnK2YUtZCWb0'
    end
    object SpTBXTabItem7: TSpTBXTabItem
      Caption = #12454#12451#12531#12489#12454#21322#36879#26126#24230
      ImageIndex = 1
      Caption_UTF7 = '+MKYwozDzMMkwplNKkA9mDl6m'
    end
    object SpTBXTabItem8: TSpTBXTabItem
      Caption = #12473#12479#12452#12523
      ImageIndex = 2
      Caption_UTF7 = '+MLkwvzCkMOs'
    end
    object SpTBXTabItem9: TSpTBXTabItem
      Caption = #25313#24373#12473#12479#12452#12523
      Checked = True
      ImageIndex = 3
      Caption_UTF7 = '+YuFfNTC5ML8wpDDr'
    end
    object SpTBXTabItem10: TSpTBXTabItem
      Caption = #12454#12451#12531#12489#12454#29366#24907
      ImageIndex = 4
      Caption_UTF7 = '+MKYwozDzMMkwpnK2YUs'
    end
    object SpTBXTabSheet5: TSpTBXTabSheet
      Left = 0
      Top = 28
      Width = 604
      Height = 201
      Caption = #12454#12451#12531#12489#12454#29366#24907
      ImageIndex = 4
      TabItem = 'SpTBXTabItem10'
    end
    object SpTBXTabSheet2: TSpTBXTabSheet
      Left = 0
      Top = 28
      Width = 604
      Height = 201
      Caption = #12454#12451#12531#12489#12454#21322#36879#26126#24230
      ImageIndex = 1
      TabItem = 'SpTBXTabItem7'
      object SpTBXLabel7: TSpTBXLabel
        Left = 16
        Top = 8
        Width = 267
        Height = 13
        Caption = #12454#12451#12531#12489#12454#12398#21322#36879#26126#24230#12434#22793#26356#12375#12414#12377' (Windows 2000'#20197#38477')'
        LinkFont.Charset = SHIFTJIS_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -12
        LinkFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
        LinkFont.Style = [fsUnderline]
        Caption_UTF7 = 
          '+MKYwozDzMMkwpjBuU0qQD2YOXqYwklkJZvQwVzB+MFk (Windows 2000+TuWWT' +
          'Q)'
      end
      object SpTBXCheckBox1: TSpTBXCheckBox
        Left = 24
        Top = 26
        Width = 85
        Height = 15
        Caption = #21322#36879#26126#21270#12377#12427
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = chkStylesClick
        Caption_UTF7 = '+U0qQD2YOUxYwWTCL'
      end
      object SpTBXTrackBar1: TSpTBXTrackBar
        Left = 24
        Top = 48
        Width = 135
        Height = 33
        Enabled = False
        Max = 255
        Min = 10
        Orientation = trHorizontal
        Frequency = 1
        Position = 255
        SelEnd = 0
        SelStart = 0
        TabOrder = 2
        TickStyle = tsAuto
        OnChange = trbPositionChange
      end
      object SpTBXCheckBox2: TSpTBXCheckBox
        Left = 24
        Top = 98
        Width = 65
        Height = 15
        Caption = #12459#12521#12540#12461#12540
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = chkStylesClick
        Caption_UTF7 = '+MKsw6TD8MK0w/A'
      end
      object SpTBXLabel8: TSpTBXLabel
        Left = 24
        Top = 120
        Width = 11
        Height = 13
        Caption = 'R:'
        LinkFont.Charset = SHIFTJIS_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -12
        LinkFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
        LinkFont.Style = [fsUnderline]
      end
      object SpTBXLabel9: TSpTBXLabel
        Left = 72
        Top = 120
        Width = 11
        Height = 13
        Caption = 'G:'
        LinkFont.Charset = SHIFTJIS_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -12
        LinkFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
        LinkFont.Style = [fsUnderline]
      end
      object SpTBXLabel10: TSpTBXLabel
        Left = 120
        Top = 120
        Width = 10
        Height = 13
        Caption = 'B:'
        LinkFont.Charset = SHIFTJIS_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -12
        LinkFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
        LinkFont.Style = [fsUnderline]
      end
      object SpTBXEdit1: TSpTBXEdit
        Left = 40
        Top = 120
        Width = 25
        Height = 21
        Enabled = False
        TabOrder = 7
        Text = 'FF'
      end
      object SpTBXEdit2: TSpTBXEdit
        Left = 88
        Top = 120
        Width = 25
        Height = 21
        Enabled = False
        TabOrder = 8
        Text = 'FF'
      end
      object SpTBXEdit3: TSpTBXEdit
        Left = 136
        Top = 120
        Width = 25
        Height = 21
        Enabled = False
        TabOrder = 9
        Text = 'FF'
      end
      object SpTBXButton4: TSpTBXButton
        Left = 40
        Top = 152
        Width = 124
        Height = 20
        Caption = #33394#24773#22577#12434#35501#12415#36796#12416
        Enabled = False
        TabOrder = 10
        LinkFont.Charset = SHIFTJIS_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -12
        LinkFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
        LinkFont.Style = [fsUnderline]
        Caption_UTF7 = '+gnJgxVgxMJKKrTB/j7wwgA'
      end
      object btnApplyTransparent: TSpTBXButton
        Left = 196
        Top = 109
        Width = 76
        Height = 21
        Caption = #36969#29992
        Enabled = False
        TabOrder = 11
        LinkFont.Charset = SHIFTJIS_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -12
        LinkFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
        LinkFont.Style = [fsUnderline]
        Caption_UTF7 = '+kGl1KA'
      end
      object SpTBXButton6: TSpTBXButton
        Left = 196
        Top = 133
        Width = 76
        Height = 21
        Caption = #12522#12475#12483#12488
        Enabled = False
        TabOrder = 12
        LinkFont.Charset = SHIFTJIS_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -12
        LinkFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
        LinkFont.Style = [fsUnderline]
        Caption_UTF7 = '+MOowuzDDMMg'
      end
    end
    object SpTBXTabSheet1: TSpTBXTabSheet
      Left = 0
      Top = 28
      Width = 604
      Height = 201
      Caption = #12454#12451#12531#12489#12454#29366#24907#22793#26356
      ImageIndex = 0
      TabItem = 'SpTBXTabItem6'
      object SpTBXGroupBox1: TSpTBXGroupBox
        Left = 7
        Top = 1
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
            Enabled = False
            TabOrder = 14
            LinkFont.Charset = SHIFTJIS_CHARSET
            LinkFont.Color = clBlue
            LinkFont.Height = -12
            LinkFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
            LinkFont.Style = [fsUnderline]
            Caption_UTF7 = '+MOowuzDDMMg'
          end
        end
        object SpTBXToolbar1: TSpTBXToolbar
          Left = 48
          Top = 16
          Width = 172
          Height = 24
          Caption = 'SpTBXToolbar1'
          TabOrder = 1
          object SpTBXItem6: TSpTBXItem
            Caption = #26368#23567#21270
            Caption_UTF7 = '+ZwBcD1MW'
          end
          object SpTBXItem7: TSpTBXItem
            Caption = #26368#22823#21270
            Caption_UTF7 = '+ZwBZJ1MW'
          end
          object SpTBXItem8: TSpTBXItem
            Caption = #38281#12376#12427
            Caption_UTF7 = '+lYkwWDCL'
          end
          object SpTBXItem9: TSpTBXItem
            Caption = #27161#28310
            Caption_UTF7 = '+ahlulg'
          end
        end
        object SpTBXToolbar2: TSpTBXToolbar
          Left = 48
          Top = 48
          Width = 136
          Height = 24
          Caption = 'SpTBXToolbar1'
          TabOrder = 2
          object SpTBXItem1: TSpTBXItem
            Caption = #28961#21177
            Caption_UTF7 = '+cSFSuQ'
          end
          object SpTBXItem2: TSpTBXItem
            Caption = #28961#21177
            Caption_UTF7 = '+cSFSuQ'
          end
          object SpTBXItem3: TSpTBXItem
            Caption = #28961#21177
            Caption_UTF7 = '+cSFSuQ'
          end
          object SpTBXItem4: TSpTBXItem
            Caption = #27161#28310
            Caption_UTF7 = '+ahlulg'
          end
        end
      end
    end
    object SpTBXTabSheet3: TSpTBXTabSheet
      Left = 0
      Top = 28
      Width = 604
      Height = 201
      Caption = #12473#12479#12452#12523
      ImageIndex = 2
      TabItem = 'SpTBXTabItem8'
      object edtStyle: TSpTBXEdit
        Left = 16
        Top = 24
        Width = 76
        Height = 21
        TabOrder = 0
        Text = 'edtStyle'
      end
      object SpTBXLabel5: TSpTBXLabel
        Left = 16
        Top = 8
        Width = 83
        Height = 13
        Caption = #12454#12451#12531#12489#12454#12473#12479#12452#12523':'
        LinkFont.Charset = SHIFTJIS_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -12
        LinkFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
        LinkFont.Style = [fsUnderline]
        Caption_UTF7 = '+MKYwozDzMMkwpjC5ML8wpDDr:'
      end
      object btnApplyStyle: TSpTBXButton
        Left = 16
        Top = 55
        Width = 76
        Height = 21
        Caption = #36969#29992'(&A)'
        TabOrder = 2
        OnClick = btnApplyStyleClick
        LinkFont.Charset = SHIFTJIS_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -12
        LinkFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
        LinkFont.Style = [fsUnderline]
        Caption_UTF7 = '+kGl1KA(&A)'
      end
      object SpTBXButton3: TSpTBXButton
        Left = 16
        Top = 80
        Width = 76
        Height = 20
        Caption = #12522#12475#12483#12488
        Enabled = False
        TabOrder = 3
        LinkFont.Charset = SHIFTJIS_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -12
        LinkFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
        LinkFont.Style = [fsUnderline]
        Caption_UTF7 = '+MOowuzDDMMg'
      end
      object btnGetStyle: TSpTBXButton
        Left = 16
        Top = 120
        Width = 76
        Height = 20
        Caption = #21462#24471
        TabOrder = 4
        OnClick = btnGetStyleClick
        LinkFont.Charset = SHIFTJIS_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -12
        LinkFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
        LinkFont.Style = [fsUnderline]
        Caption_UTF7 = '+U9Zflw'
      end
      object SpTBXButton5: TSpTBXButton
        Left = 16
        Top = 144
        Width = 76
        Height = 20
        Caption = #12377#12409#12390#22806#12377
        Enabled = False
        TabOrder = 5
        LinkFont.Charset = SHIFTJIS_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -12
        LinkFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
        LinkFont.Style = [fsUnderline]
        Caption_UTF7 = '+MFkweTBmWRYwWQ'
      end
      object chkStyles0: TSpTBXCheckBox
        Left = 120
        Top = 26
        Width = 81
        Height = 15
        Caption = 'WS_BORDER'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
        OnClick = chkStylesClick
      end
      object chkStyles1: TSpTBXCheckBox
        Left = 120
        Top = 42
        Width = 85
        Height = 15
        Caption = 'WS_CAPTION'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        OnClick = chkStylesClick
      end
      object chkStyles2: TSpTBXCheckBox
        Left = 120
        Top = 58
        Width = 70
        Height = 15
        Caption = 'WS_CHILD'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
        OnClick = chkStylesClick
      end
      object chkStyles3: TSpTBXCheckBox
        Left = 120
        Top = 74
        Width = 112
        Height = 15
        Caption = 'WS_CLIPCHILDREN'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
        OnClick = chkStylesClick
      end
      object chkStyles4: TSpTBXCheckBox
        Left = 120
        Top = 90
        Width = 101
        Height = 15
        Caption = 'WS_CLIPSIBLING'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 10
        OnClick = chkStylesClick
      end
      object chkStyles5: TSpTBXCheckBox
        Left = 120
        Top = 106
        Width = 88
        Height = 15
        Caption = 'WS_DISABLED'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 11
        OnClick = chkStylesClick
      end
      object chkStyles6: TSpTBXCheckBox
        Left = 120
        Top = 122
        Width = 93
        Height = 15
        Caption = 'WS_DLGFRAME'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 12
        OnClick = chkStylesClick
      end
      object chkStyles7: TSpTBXCheckBox
        Left = 120
        Top = 138
        Width = 75
        Height = 15
        Caption = 'WS_GROUP'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 13
        OnClick = chkStylesClick
      end
      object chkStyles8: TSpTBXCheckBox
        Left = 120
        Top = 154
        Width = 85
        Height = 15
        Caption = 'WS_HSCROLL'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 14
        OnClick = chkStylesClick
      end
      object chkStyles9: TSpTBXCheckBox
        Left = 248
        Top = 26
        Width = 89
        Height = 15
        Caption = 'WS_MAXIMIZE'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 15
        OnClick = chkStylesClick
      end
      object chkStyles10: TSpTBXCheckBox
        Left = 248
        Top = 42
        Width = 109
        Height = 15
        Caption = 'WS_MAXIMIZEBOX'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 16
        OnClick = chkStylesClick
      end
      object chkStyles11: TSpTBXCheckBox
        Left = 248
        Top = 58
        Width = 87
        Height = 15
        Caption = 'WS_MINIMIZE'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 17
        OnClick = chkStylesClick
      end
      object chkStyles12: TSpTBXCheckBox
        Left = 248
        Top = 74
        Width = 107
        Height = 15
        Caption = 'WS_MINIMIZEBOX'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 18
        OnClick = chkStylesClick
      end
      object chkStyles13: TSpTBXCheckBox
        Left = 248
        Top = 90
        Width = 104
        Height = 15
        Caption = 'WS_OVERLAPPED'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 19
        OnClick = chkStylesClick
      end
      object chkStyles14: TSpTBXCheckBox
        Left = 248
        Top = 106
        Width = 150
        Height = 15
        Caption = 'WS_OVERLAPPEDWINDOW'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 20
        OnClick = chkStylesClick
      end
      object chkStyles15: TSpTBXCheckBox
        Left = 248
        Top = 122
        Width = 73
        Height = 15
        Caption = 'WS_POPUP'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 21
        OnClick = chkStylesClick
      end
      object chkStyles16: TSpTBXCheckBox
        Left = 248
        Top = 138
        Width = 119
        Height = 15
        Caption = 'WS_POPUPWINDOW'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 22
        OnClick = chkStylesClick
      end
      object chkStyles17: TSpTBXCheckBox
        Left = 248
        Top = 154
        Width = 86
        Height = 15
        Caption = 'WS_SYSMENU'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 23
        OnClick = chkStylesClick
      end
      object chkStyles18: TSpTBXCheckBox
        Left = 416
        Top = 26
        Width = 85
        Height = 15
        Caption = 'WS_TABSTOP'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 24
        OnClick = chkStylesClick
      end
      object chkStyles19: TSpTBXCheckBox
        Left = 416
        Top = 42
        Width = 104
        Height = 15
        Caption = 'WS_THICKFRAME'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 25
        OnClick = chkStylesClick
      end
      object chkStyles20: TSpTBXCheckBox
        Left = 416
        Top = 58
        Width = 77
        Height = 15
        Caption = 'WS_VISIBLE'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 26
        OnClick = chkStylesClick
      end
      object chkStyles21: TSpTBXCheckBox
        Left = 416
        Top = 74
        Width = 84
        Height = 15
        Caption = 'WS_VSCROLL'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 27
        OnClick = chkStylesClick
      end
    end
    object SpTBXTabSheet4: TSpTBXTabSheet
      Left = 0
      Top = 28
      Width = 604
      Height = 201
      Caption = #25313#24373#12473#12479#12452#12523
      ImageIndex = 3
      TabItem = 'SpTBXTabItem9'
      object edtExStyle: TSpTBXEdit
        Left = 16
        Top = 24
        Width = 76
        Height = 21
        TabOrder = 0
        Text = 'edtExStyle'
      end
      object SpTBXLabel6: TSpTBXLabel
        Left = 16
        Top = 8
        Width = 107
        Height = 13
        Caption = #12454#12451#12531#12489#12454#25313#24373#12473#12479#12452#12523':'
        LinkFont.Charset = SHIFTJIS_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -12
        LinkFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
        LinkFont.Style = [fsUnderline]
        Caption_UTF7 = '+MKYwozDzMMkwpmLhXzUwuTC/MKQw6w:'
      end
      object chkExStyles0: TSpTBXCheckBox
        Left = 120
        Top = 26
        Width = 130
        Height = 15
        Caption = 'WS_EX_WINDOWEDGE'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = chkExStylesClick
      end
      object btnApplyExStyle: TSpTBXButton
        Left = 16
        Top = 55
        Width = 76
        Height = 21
        Caption = #36969#29992'(&A)'
        TabOrder = 3
        OnClick = btnApplyExStyleClick
        LinkFont.Charset = SHIFTJIS_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -12
        LinkFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
        LinkFont.Style = [fsUnderline]
        Caption_UTF7 = '+kGl1KA(&A)'
      end
      object btnGetExStyle: TSpTBXButton
        Left = 16
        Top = 120
        Width = 76
        Height = 20
        Caption = #21462#24471
        TabOrder = 4
        OnClick = btnGetExStyleClick
        LinkFont.Charset = SHIFTJIS_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -12
        LinkFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
        LinkFont.Style = [fsUnderline]
        Caption_UTF7 = '+U9Zflw'
      end
      object chkExStyles1: TSpTBXCheckBox
        Left = 120
        Top = 42
        Width = 119
        Height = 15
        Caption = 'WS_EX_CLIENTEDGE'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        OnClick = chkExStylesClick
      end
      object chkExStyles2: TSpTBXCheckBox
        Left = 120
        Top = 58
        Width = 120
        Height = 15
        Caption = 'WS_EX_STATICEDGE'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
        OnClick = chkExStylesClick
      end
      object chkExStyles3: TSpTBXCheckBox
        Left = 120
        Top = 74
        Width = 146
        Height = 15
        Caption = 'WS_EX_DLGMODALFRAME'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        OnClick = chkExStylesClick
      end
      object chkExStyles4: TSpTBXCheckBox
        Left = 120
        Top = 90
        Width = 168
        Height = 15
        Caption = 'WS_EX_OVERLAPPEDWINDOW'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
        OnClick = chkExStylesClick
      end
      object chkExStyles5: TSpTBXCheckBox
        Left = 304
        Top = 26
        Width = 130
        Height = 15
        Caption = 'WS_EX_TRANSPARENT'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
        OnClick = chkExStylesClick
      end
      object chkExStyles6: TSpTBXCheckBox
        Left = 304
        Top = 42
        Width = 131
        Height = 15
        Caption = 'WS_EX_TOOLWINDOW'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 10
        OnClick = chkExStylesClick
      end
      object chkExStyles7: TSpTBXCheckBox
        Left = 304
        Top = 58
        Width = 121
        Height = 15
        Caption = 'WS_EX_RTLREADING'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 11
        OnClick = chkExStylesClick
      end
      object chkExStyles8: TSpTBXCheckBox
        Left = 304
        Top = 74
        Width = 128
        Height = 15
        Caption = 'WS_EX_CONTEXTHELP'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 12
        OnClick = chkExStylesClick
      end
      object chkExStyles9: TSpTBXCheckBox
        Left = 304
        Top = 90
        Width = 139
        Height = 15
        Caption = 'WS_EX_LEFTSCROLLBAR'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 13
        OnClick = chkExStylesClick
      end
      object SpTBXButton7: TSpTBXButton
        Left = 16
        Top = 80
        Width = 76
        Height = 20
        Caption = #12522#12475#12483#12488
        Enabled = False
        TabOrder = 14
        LinkFont.Charset = SHIFTJIS_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -12
        LinkFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
        LinkFont.Style = [fsUnderline]
        Caption_UTF7 = '+MOowuzDDMMg'
      end
      object SpTBXButton8: TSpTBXButton
        Left = 16
        Top = 144
        Width = 76
        Height = 20
        Caption = #12377#12409#12390#22806#12377
        Enabled = False
        TabOrder = 15
        LinkFont.Charset = SHIFTJIS_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -12
        LinkFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
        LinkFont.Style = [fsUnderline]
        Caption_UTF7 = '+MFkweTBmWRYwWQ'
      end
    end
  end
  object imlTool: TImageList
    BkColor = 13160660
    Width = 20
    Left = 265
    Top = 230
    Bitmap = {
      494C010108000900040014001000D4D0C800FF10FFFFFFFFFFFFFFFF424D3600
      000000000000360000002800000050000000300000000100200000000000003C
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CED6D600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600C6BD
      BD00CEADAD00CEB5B500CEC6C600CED6D600CED6D600CED6D600CED6D600CED6
      D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6
      D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6
      D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6
      D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6
      D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6
      D600CED6D600CED6D600CED6D600CED6D600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C6C6
      C600CED6D600CED6D600CED6D600CED6D600CED6D600C6C6C600C6B5AD00DEB5
      9C00F7E7D600EFE7CE00CEC6BD00C6B5AD00CEB5B500CEC6C600CEC6C600CED6
      D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D6008484
      84008484840084848400848484006B6B94008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400CED6D600CED6
      D600CED6D600CED6D600CED6D600A5947B00C69C6300CEA56B00D6AD7300DEB5
      7300E7BD7B00E7BD8400EFC68400F7CE8C00F7CE8C00F7CE9400F7D69400F7D6
      9400EFDEC600CED6D600CED6D600CED6D600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C6C6
      C600CED6D600CED6D600CED6D600CED6D600C6C6C600CEBDB500EFC68C00EFBD
      8C00F7EFDE00F7E7D600EFE7CE00B58C8C00AD7B7B00B5848400CEB5AD00C6AD
      9C00C6ADAD00CEC6C600CED6D600CED6D600CED6D600CED6D600C6A58C00BD8C
      7B00BD947B00394A7B000831DE000031F7006B6B9400BD947B00BD947B00BD94
      7B00BD947B00BD947B00BD947B00BD947B00BD947B0084848400CED6D600CED6
      D600CED6D600CED6D600CED6D600C69C6300EF940800F79C0800FFA50800FFAD
      0800FFAD1000FFAD1000FFB51800FFAD1000FFAD0800FFAD0800FFA50800F79C
      0800F7CE9400CED6D600CED6D600CED6D600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF00737373008C8C8C00FFFFFF00FFFFFF00FFFFFF0042424200ADAD
      AD0042424200BDBDBD008C8C8C008C8C8C00FFFFFF00FFFFFF00FFFFFF00C6C6
      C600CED6D600CED6D600CED6D600C6C6C600CEBDB500F7CE9C00F7C69400EFC6
      8C00F7EFE700F7EFDE00F7E7CE00B58C8C009C6B6B00A56B6B00DEBDA500E7CE
      A500E7CEA500C6BDBD00CED6D600CED6D600CED6D600CED6D600C69C7B005A63
      6B002152AD000039FF000031FF000031FF001031A500D6C6B500D6CEB500D6CE
      BD00D6CEBD00D6C6B500D6C6B500DECEBD00BD947B0084848400CED6D600CED6
      D600CED6D600CED6D600CED6D600C6A56B00EF940800EF940800D6B58400FFAD
      1800FFAD0800FFAD1000FFAD1000FFAD0800FFAD0800FFA50800F79C0800EF94
      0800F7CE9400CED6D600CED6D600CED6D600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF00CECECE0031313100FFFFFF00FFFFFF00EFEFEF0010101000FFFF
      FF0042424200BDBDBD008C8C8C008C8C8C00FFFFFF00FFFFFF00FFFFFF00C6C6
      C600CED6D600CED6D600CED6D600CEB5AD00F7DEA500F7D6A500F7CE9C00F7C6
      9400FFF7EF00F7EFE700F7EFDE00B58C8C009C6363009C636300D6BDA500EFD6
      AD00E7CEA500C6BDBD00CED6D600CED6D600CED6D600CED6D600527B9400398C
      EF00297BF700185AF7000839F7000031FF000031FF006B6B9400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00EFFFFF00BD947B0084848400CED6D600CED6
      D600CED6D600CED6D600CED6D600CEAD7300E7940800EF940800EFBD7300FFE7
      BD00FFAD0800FFAD0800FFAD0800FFAD0800FFA50800FFA50800F79C0800EF94
      0800EFCE9400CED6D600CED6D600CED6D600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF002121210031313100424242002121210063636300FFFF
      FF0042424200BDBDBD008C8C8C008C8C8C00FFFFFF00FFFFFF00FFFFFF00C6C6
      C600CED6D600CED6D600CED6D600CEB5AD00F7E7AD00F7DEA500F7D6A500F7CE
      9C00FFF7F700FFF7EF00F7EFDE00B58C8C009C6363009C636300D6BDAD00EFD6
      B500EFD6AD00C6BDBD00CED6D600CED6D600CED6D600CED6D6006394B50052B5
      FF00398CEF00426BAD00737384000839E7000031FF000831CE00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00E7FFFF00BD947B0084848400CED6D600CED6
      D600CED6D600CED6D600CED6D600D6B57B00E7940800EF940800EF940800EFC6
      8C00F7C67B00FFA50800FFA50800FFA50800FFA50800F79C0800EF940800E794
      0800EFCE9400CED6D600CED6D600CED6D600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00737373008C8C8C00FFFFFF0042424200ADADAD00FFFF
      FF0042424200BDBDBD008C8C8C008C8C8C00FFFFFF00FFFFFF00FFFFFF00C6C6
      C600CED6D600CED6D600CED6D600CEB5AD00FFE7B500E7CEA50094A5BD009C9C
      AD00FFFFFF00FFF7F700F7F7EF00DEC6AD00B58C8C00AD7B7B00DEC6AD00EFDE
      BD00EFD6B500C6BDBD00CED6D600CED6D600CED6D600CED6D600BD947B004A8C
      A50084848C00FFFFFF00FFFFFF00525A8C000039FF000031FF00394A9C00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00E7FFFF00BD947B0084848400CED6D600CED6
      D600CED6D600CED6D600CED6D600D6B58400DE8C0800E7940800E7940800EF94
      0800D6BD8C00CE9C4A00B58C4200C6944A00E7941800E7940800E7940800DE8C
      0800DEBD8C00CED6D600CED6D600CED6D600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00CECECE0031313100EFEFEF0010101000FFFFFF00FFFF
      FF0042424200BDBDBD008C8C8C008C8C8C00FFFFFF00FFFFFF00FFFFFF00C6C6
      C600CED6D600CED6D600CED6D600CEB5AD00D6CEAD0052ADF700399CFF003194
      F70094BDEF00FFFFFF00FFF7F700F7F7EF00F7EFDE00F7E7D600F7E7CE00EFDE
      C600EFDEBD00C6BDBD00CED6D600CED6D600CED6D600CED6D600BD947B00E7FF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00184AC6000039FF000031F7006B6B
      9400FFFFFF00FFFFFF00FFFFFF00E7FFFF00BD947B0084848400CED6D600CED6
      D600CED6D600CED6D600CED6D600D6B58400DE8C0800DE8C0800E7940800E794
      0800B5843100AD9C8400A58C6B00A58C6B00B5A57B00E79C3100E7940800DE8C
      0800DEBD8400CED6D600CED6D600CED6D600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00212121007373730063636300FFFFFF00FFFF
      FF0042424200BDBDBD008C8C8C008C8C8C00FFFFFF00FFFFFF00FFFFFF00C6C6
      C600CED6D600CED6D600CED6D600B5C6CE0063CEFF005ABDFF004AB5FF0039A5
      FF003194F700B5D6F700FFFFFF00FFF7EF00F7F7EF00F7EFDE00F7E7D600F7E7
      CE00D6B5B500CEBDBD00CED6D600CED6D600CED6D600CED6D600BD947B00E7FF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008C8C9C00185AF7000039FF001839
      AD00FFFFFF00FFFFFF00FFFFFF00E7FFFF00BD947B0084848400CED6D600CED6
      D600CED6D600CED6D600CED6D600D6BD9400E7941800DE8C0800DE8C0800DE8C
      08009C8C6B00A58C6B00A58C6B00A5947B00B5A58400D6B58400DE8C0800DE8C
      0800D6B58400CED6D600CED6D600CED6D600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF008C8C8C0000000000BDBDBD00FFFFFF00FFFF
      FF0042424200BDBDBD008C8C8C008C8C8C00FFFFFF00FFFFFF00FFFFFF00C6C6
      C600CED6D600CED6D6005AB5FF005AB5FF005AC6FF0063CEFF005AC6FF004AB5
      FF0039A5FF003194FF00B5D6FF00FFFFFF00FFF7EF00F7F7E700F7EFDE00C6BD
      C600AD9CB500C6C6C600CED6D600CED6D600CED6D600CED6D600BD947B00E7FF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF004263A500185AF7000039
      FF006B6B9400FFFFFF00FFFFFF00E7FFFF00BD947B0084848400CED6D600CED6
      D600CED6D600CED6D600CED6D600DEC69C00EFB55A00E7A54200DE942100DE8C
      0800A5947B00A5947B00A5947B00B5AD9400C6BDA500D6BD9C00DE8C0800DE8C
      0800CEB58400CED6D600CED6D600CED6D600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00EFEFEF00BDBDBD00FFFFFF00FFFFFF00FFFF
      FF0073737300CECECE009C9C9C009C9C9C00FFFFFF00FFFFFF00FFFFFF00C6C6
      C600CED6D600CED6D600C6C6C6007BBDF7004AB5FF005ABDFF0063CEFF005AC6
      FF004AB5FF0042A5FF003194FF00B5D6FF00FFFFFF00FFF7EF00B5BDD600848C
      B500C6C6C600CED6D600CED6D600CED6D600CED6D600CED6D600BD947B00E7FF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF002973DE00185A
      EF0042427300FFFFFF00FFFFFF00E7FFFF00BD947B0084848400CED6D600CED6
      D600CED6D600CED6D600CED6D600E7CEA500EFB56300EFB56300EFB56300EFB5
      5A00C6B58C00ADA59C00BDB5A500D6C6BD00DED6C600E7BD8400DE8C0800DE8C
      0800CEAD7B00CED6D600CED6D600CED6D600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C6C6
      C600CED6D600CED6D600CED6D600C6C6C60094C6EF005AB5FF005ABDFF0063CE
      FF0063C6FF0052B5FF0042A5FF00319CFF00B5D6FF00B5CEEF005A7BBD00C6C6
      CE00CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600BD947B00EFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF004A8C
      A500FFFFFF00FFFFFF00FFFFFF00EFFFFF00BD947B0084848400CED6D600CED6
      D600CED6D600CED6D600CED6D600E7CEAD00EFBD7300EFBD7300EFBD6B00EFBD
      6B00EFBD7300E7D6C600EFEFE700F7F7EF00F7E7CE00E7AD4A00E79C3100DE9C
      2900C6A57B00CED6D600CED6D600CED6D600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C6C6
      C600CED6D600CED6D600CED6D600CED6D600CED6D6009CC6E70052ADFF0052BD
      FF0063CEFF0063C6FF0052BDFF0042ADFF00319CFF00398CEF00C6CECE00CED6
      D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600BD947B00DEEF
      E700DEE7DE00DEE7DE00DEE7DE00E7E7DE00E7E7DE00E7EFDE00E7EFE700E7E7
      DE00DEE7DE00DEDEDE00DEDEDE00E7EFDE00BD947B0084848400CED6D600CED6
      D600CED6D600CED6D600CED6D600EFD6B500F7C68400F7C68400E7BD8400F7C6
      7B00EFBD7300EFBD6B00EFC68400EFC67B00E7AD5200E7AD4A00E7A53900E79C
      3100BDA57300CED6D600CED6D600CED6D600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C6C6
      C600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D6009CC6E70052AD
      FF0052BDFF0063C6FF0063CEFF0052ADFF002973DE00316BEF00CED6D600CED6
      D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600B55A0000AD52
      0000AD520000AD520000AD520000AD520000AD520000AD520000AD520000AD52
      0000AD520000B55A0800B55A00009C5A2900AD6B290084848400CED6D600CED6
      D600CED6D600CED6D600CED6D600EFD6B500F7CE8C00F7CE8C00EFC68C00EFC6
      8400F7C68400EFC67300EFBD6B00EFB56300EFB55A00E7AD5200E7A54200E7A5
      3900B59C6B00CED6D600CED6D600CED6D600CED6D60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600A5C6
      E7008CC6EF00B5CEDE00C6CECE00C6C6CE0000009C00315AE700CED6D600CED6
      D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600DE842900E78C
      2100E7841000E7841000E7841000E7841000E7841000E7841000E7841000E784
      0800E77B0800EF8C1800EF8C1800CE844200CE844200CED6D600CED6D600CED6
      D600CED6D600CED6D600CED6D600EFDEC600EFD6B500EFD6B500EFD6B500EFD6
      B500E7CEAD00DEC6A500D6BD9C00D6BD9400CEB58C00C6AD8400C6A57B00B59C
      73009C948400CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6
      D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6
      D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6
      D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6
      D600CED6D600CED6D600CED6D600C6C6CE008484B500ADADC600CED6D600CED6
      D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6
      D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6
      D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6
      D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6
      D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6
      D600CED6D600CED6D600CED6D600CED6D600CED6D600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600CED6D600C6C6C6009C9CC6006B6BE7006B6BE700C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6009C9C
      C6006B6BE7006B6BE700C6C6C600C6C6C600CED6D600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600CED6D600C6C6C600CED6D6006B6BEF006B6BEF00C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600CED6
      D6006B6BEF006B6BEF00C6C6C600C6C6C600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C6C6
      C600CED6D60000000000FFFFFF003131FF000000FF006B6BE700FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00EFEFFF003131
      FF000000FF009C9CFF00FFFFFF00C6C6C600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C6C6
      C600CED6D60000000000FFFFFF003131FF000000FF006B6BEF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00EFEFFF003131
      FF000000FF009494FF00FFFFFF00C6C6C600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00C6C6
      C600CED6D60000000000FFFFFF00EFEFFF003131FF000000FF009C9CFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF005A5AFF000000
      FF005A5AFF0000000000FFFFFF00C6C6C600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00C6C6
      C600CED6D60000000000FFFFFF00EFEFFF003131FF000000FF009494FF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF005252FF000000
      FF006B6BEF0000000000FFFFFF00C6C6C600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF0000000000000000000000000000000000FFFFFF00000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00C6C6
      C600CED6D60000000000FFFFFF00FFFFFF00CECEFF000000E7000000FF000000
      310000000000FFFFFF0000000000000000000000000000009C000000FF005A5A
      FF00FFFFFF0000000000FFFFFF00C6C6C600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00C6C6
      C600CED6D60000000000FFFFFF00FFFFFF00CECEFF001010FF000000FF00CECE
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF006B6BEF000000FF005252
      FF00FFFFFF0000000000FFFFFF00C6C6C600CED6D60000000000FFFFFF00FFFF
      FF0000000000C6C6C600FFFFFF00FFFFFF0000000000FFFFFF0000000000FFFF
      FF00FFFFFF008484840000000000FFFFFF00FFFFFF0000000000FFFFFF00C6C6
      C600CED6D60000000000FFFFFF00FFFFFF00000000009C9CC6000000FF001010
      FF0000003100FFFFFF0000000000FFFFFF009C9CFF000000FF000000E700EFEF
      FF00FFFFFF0000000000FFFFFF00C6C6C600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0042424200FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0042424200FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00C6C6
      C600CED6D60000000000FFFFFF00FFFFFF00FFFFFF00CECEFF000000FF001010
      FF00CECEFF00FFFFFF00FFFFFF00FFFFFF00080884000000FF003131FF00EFEF
      FF00FFFFFF0000000000FFFFFF00C6C6C600CED6D60000000000FFFFFF00FFFF
      FF0000000000C6C6C600FFFFFF00FFFFFF0000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF0000000000FFFFFF00C6C6
      C600CED6D60000000000FFFFFF00FFFFFF0000000000C6C6C6009C9CFF000000
      FF000000E700EFEFFF0000000000CECEFF000000FF001010FF0000003100FFFF
      FF00FFFFFF0000000000FFFFFF00C6C6C600CED6D60000000000FFFFFF00DEDE
      DE0073737300EFEFEF008C8C8C00FFFFFF00CED6D6005A5A5A008C8C8C00FFFF
      FF008C8C8C00FFFFFF008C8C8C00ADADAD00FFFFFF0000000000FFFFFF00C6C6
      C600CED6D60000000000FFFFFF00EFEFFF0084848C00FFFFFF004242B5000000
      FF003131FF004242520084848C00CECEFF000000FF001010FF0084848C00CED6
      D600FFFFFF0000000000FFFFFF00C6C6C600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF0000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF0000000000FFFFFF00C6C6
      C600CED6D60000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      9C000000FF005A5AFF00000031001010FF001010FF00CECEFF0000000000FFFF
      FF00FFFFFF0000000000FFFFFF00C6C6C600CED6D60000000000FFFFFF00FFFF
      FF009C9C9C0052525200525252007373730063636300D6D6D6008C8C8C006363
      630063636300525252008C8C8C00EFEFEF00FFFFFF0000000000FFFFFF00C6C6
      C600CED6D60000000000FFFFFF00FFFFFF0084848C0042425200424252004242
      B5000000FF005252FF0084848C000000FF000000FF004242520084848C00EFEF
      FF00FFFFFF0000000000FFFFFF00C6C6C600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF0000000000FFFFFF00C6C6
      C600CED6D60000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000009C000000FF000000E7000000FF009C9CFF00FFFFFF0000000000FFFF
      FF00FFFFFF0000000000FFFFFF00C6C6C600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF009C9C9C000000000052525200DEDEDE00FFFFFF00EFEFEF007373
      73002929290073737300EFEFEF00FFFFFF00FFFFFF0000000000FFFFFF00C6C6
      C600CED6D60000000000FFFFFF00FFFFFF00FFFFFF0084848C00000000004242
      52005252FF000000FF001010FF000000FF000808840084848C00EFEFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00C6C6C600CED6D60000000000FFFFFF00FFFF
      FF0000000000C6C6C600FFFFFF00C6C6C60000000000FFFFFF00000000000000
      0000FFFFFF008484840000000000FFFFFF00FFFFFF0000000000FFFFFF00C6C6
      C600CED6D60000000000FFFFFF00FFFFFF0000000000C6C6C600FFFFFF00C6C6
      C600000031000000FF000000FF0000009C00FFFFFF009C9CC60000000000FFFF
      FF00FFFFFF0000000000FFFFFF00C6C6C600CED6D60000000000FFFFFF00DEDE
      DE00292929009C9C9C008C8C8C00DEDEDE00424242005A5A5A0029292900D6D6
      D6008C8C8C00CED6D60029292900ADADAD00FFFFFF0000000000FFFFFF00C6C6
      C600CED6D60000000000FFFFFF00EFEFFF004242520084848C0084848C00EFEF
      FF00424252000000FF000000FF003131FF0084848C00CED6D60042425200CED6
      D600FFFFFF0000000000FFFFFF00C6C6C600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF0000000000C6C6
      C6000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00C6C6
      C600CED6D60000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      00005A5AFF000000FF000000E7000000FF000000310000000000FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00C6C6C600CED6D60000000000FFFFFF00FFFF
      FF00DEDEDE00FFFFFF0073737300FFFFFF00FFFFFF00D6D6D600EFEFEF00FFFF
      FF0073737300FFFFFF00EFEFEF00EFEFEF00FFFFFF0000000000FFFFFF00C6C6
      C600CED6D60000000000FFFFFF00FFFFFF00EFEFFF00FFFFFF0084848C00FFFF
      FF005252FF000000FF001010FF000000FF004242B500FFFFFF00EFEFFF00EFEF
      FF00FFFFFF0000000000FFFFFF00C6C6C600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00C6C6
      C600CED6D60000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF005A5A
      FF000000FF005A5AFF00000031001010FF000000FF00CECEFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00C6C6C600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0073737300FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0073737300FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00C6C6
      C600CED6D60000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0084848C006B6B
      EF000000FF005252FF00CECEFF001010FF000000FF00CECEFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00C6C6C600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00C6C6
      C600CED6D60000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF009C9CFF000000
      FF003131FF00EFEFFF0000000000CECEFF000000FF001010FF00CECEFF00FFFF
      FF00FFFFFF0000000000FFFFFF00C6C6C600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00C6C6
      C600CED6D60000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF009494FF000000
      FF003131FF00EFEFFF00FFFFFF00CECEFF000000FF001010FF00CECEFF00FFFF
      FF00FFFFFF0000000000FFFFFF00C6C6C600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00C6C6
      C600CED6D60000000000FFFFFF00FFFFFF00FFFFFF009C9CFF000000FF001010
      FF00EFEFFF00FFFFFF00FFFFFF00FFFFFF009C9CFF000000FF003131FF00EFEF
      FF00FFFFFF0000000000FFFFFF00C6C6C600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00C6C6
      C600CED6D60000000000FFFFFF00FFFFFF00FFFFFF009494FF000000FF001010
      FF00EFEFFF00FFFFFF00FFFFFF00FFFFFF009494FF000000FF003131FF00EFEF
      FF00FFFFFF0000000000FFFFFF00C6C6C600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C6C6
      C600CED6D60000000000FFFFFF00FFFFFF00CECEFF001010FF001010FF00CECE
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF009C9CFF000000FF003131
      FF00EFEFFF00FFFFFF00FFFFFF00C6C6C600CED6D60000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C6C6
      C600CED6D60000000000FFFFFF00FFFFFF00CECEFF001010FF001010FF00CECE
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF009494FF000000FF003131
      FF00EFEFFF00FFFFFF00FFFFFF00C6C6C600CED6D60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C600CED6D6000000000000000000000000000000E7000000FF00000031000000
      000000000000000000000000000000000000000000000000000000009C000000
      FF0000009C000000000000000000C6C6C600CED6D60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C600CED6D6000000000000000000000000000000FF000000FF00080884000000
      0000000000000000000000000000000000000000000000000000080884000000
      FF00080884000000000000000000C6C6C600CED6D600CED6D600CED6D600CED6
      D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6
      D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6
      D600CED6D600CED6D600CED6D6009C9CC6006B6BE7006B6BE700CED6D600CED6
      D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D6006B6B
      E7006B6BE7009C9CC600CED6D600CED6D600CED6D600CED6D600CED6D600CED6
      D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6
      D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6
      D600CED6D600CED6D600CED6D6009494FF006B6BEF006B6BEF00CED6D600CED6
      D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D600CED6D6006B6B
      EF006B6BEF00CED6D600CED6D600CED6D600424D3E000000000000003E000000
      2800000050000000300000000100010000000000400200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000080000FE1FFFFFFFFFFFF000080000F80
      1FE0003E0007000080000F0003C0003E0007000080000E0003C0003E00070000
      80000E0003C0003E0007000080000E0003C0003E0007000080000E0003C0003E
      0007000080000E0003C0003E0007000080000E0003C0003E0007000080000C00
      03C0003E0007000080000C0007C0003E0007000080000E000FC0003E00070000
      80000F801FC0003E0007000080000FC03FC0003E0007000080000FE03FC0007E
      00070000FFFFFFFE3FFFFFFFFFFF0000800008000080000A0010000080000800
      0080000800000000800008000080000800000000800008000080000800000000
      8000080000800008000000008000080000808008001000008000080000800008
      0000000080000800008000080000000080000800008004080050000080000800
      0080000800000000800008000080000800000000800008000080000800000000
      8000080000800008000000008000080000800008000000008000080000800008
      00000000FFFFFE3FE3FFFFFE3FE7000000000000000000000000000000000000
      000000000000}
  end
end
