VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "C_GridToExcel"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'////////////////////////////////////////////////////////////////////////
'VSFlexGridの内容をExcel出力するクラス
'   C_GridToExcel
'       2006/11/30 DATACOM うっちー
'
'公開プロパティ(I:書込専用　O:読込専用　X:読み書き可)
'IsExcelEnabled             O   Excelが使用可能かどうか(True:使用可能　False:使用不可)
'ExcelVersion               O   Excelのバージョン
'ExcelVisible               X   Excelの表示/非表示(True:表示　False:非表示)
'WindowZoom                 X   アクティブウィンドウ(シート)のズーム
'Row                        X   現在処理中の行(Excel側)
'BaseCol                    X   OutputGrid/OutputRowの基準列(Excel側)
'ReflectNumberFormat        X   表示形式(ColFormat)を反映するかどうか
'ReflectAlignment           X   文字配置(CellAlignment/ColAlignment)を反映するかどうか
'ReflectMerge               X   セル結合(GetMergedRange)を反映するかどうか
'ReflectFont                X   フォント(FontName/Size/Italic/Bold/Underline/Strikethru)を反映するかどうか
'ReflectBorder              X   簡易的に罫線を設定するかどうか
'ReflectColor               X   色情報(背景色/前景色)を反映するかどうか
'FreezePanesAsGrid          X   グリッドの固定セルに応じてExcel側にウィンドウ枠の固定設定をするかどうか(非表示考慮)
'TitleRowColAsGrid          X   グリッドの固定セルに応じてExcel側に印刷行/列のタイトル設定をするかどうか(非表示考慮)
'OutputTarget               X   出力対象(TextDisplay/ValueMatrix)
'ErrRowOver                 O   出力行数超過エラー(True:超過した)
'ErrColOver                 O   出力列数超過エラー(〃)
'ErrPaletteOver             O   色情報数超過エラー(〃)
'StandardHeight/Width       X   標準の行高/列幅
'Orientation                X   印刷の向き
'PageZoom                   X   拡大/縮小印刷
'FitToPagesWide/Tall        X   横/縦をページ数に合わせて印刷
'PaperSize                  X   用紙サイズ
'Top/Bottom/Left/RightMargin    X   上/下/左/右余白
'Header/FooterMargin        X   ヘッダー/フッター余白
'CenterHorizontally/Vertically  X   水平/垂直ページ中央印刷
'Left/Center/RightHeader    X   左側/中央部/右側ヘッダー
'Left/Center/RightFooter    X   左側/中央部/右側フッター
'PrintTitleRows/Columns     X   印刷行/列のタイトル
'PrintGridLines             X   枠線印刷
'
'発生イベント
'BeforeOutput               グリッド内容出力前に発生(アクティブシートの切替等に使用できます)
'AfterOutput                グリッド内容出力後に発生
'BeforeOutputRow            グリッドに1行出力する直前に発生(進捗状況調査や出力キャンセルに使用できます)
'AfterOutputRow             グリッドに1行出力した直後に発生
'
'公開メソッド
'OpenWorkbook               既存のワークブックを開く
'OpenNewWorkbook            新しいワークブックを開く
'OutputGrid                 カレント行以降にグリッド内容を出力する
'OutputRow                  カレント行にテキストを出力する
'FreezePanes                ウィンドウ枠の固定設定をする
'AutoFitRows/Columns        自動行高/列幅調整
'CloseWorkbook              処理中のワークブックを閉じる
'SaveWorkbook               処理中のワークブックを保存する
'SaveAsWorkbook             処理中のワークブックを名前を付けて保存する
'SetGridLinesFixed          簡易罫線設定時の固定セルの罫線情報をセットする
'SetGridLinesFrozen         簡易罫線設定時の静止セルの罫線情報をセットする
'SetGridLines               簡易罫線設定時の固定セル以外の罫線情報をセットする
'
'※Reflect○○系プロパティ(ReflectBorder以外)をTrueにすると基本的に1セルずつ処理されるため処理速度が遅くなります(特にReflectFont、既定値はすべてFalse)。
'※OutputGridでは行列数超過以外は基本的にエラーチェックをしていないので適切なエラートラップをしてください。
'////////////////////////////////////////////////////////////////////////

'////////////////////////////////////////////////////////////////////////
'   Win32API関数宣言
'////////////////////////////////////////////////////////////////////////
Private Declare Function GetSysColor Lib "user32" _
    (ByVal nIndex As Long) As Long

'////////////////////////////////////////////////////////////////////////
'   定数宣言
'////////////////////////////////////////////////////////////////////////
Private Const cPtPerCm As Double = 28.3464566929134     '1センチ≒28.3464566929134ポイント(余白計算に使用)
Private Const cMaxRows As Long = 65536                  'Excel最大行数
Private Const cMaxCols As Long = 256                    'Excel最大列数
Private Const cMaxPalettes As Integer = 56              'Excelカラーパレット最大数

'////////////////////////////////////////////////////////////////////////
'   列挙型宣言
'////////////////////////////////////////////////////////////////////////
'====   各種書式反映済みフラグ
Private Enum eReflections
    RefNone = 0
    RefNumberFormat = 1
    RefAlignment = 2
    RefMerge = 4
    RefFont = 8
    RefBackColor = 16
    RefForeColor = 32
End Enum

'====   ウィンドウ枠の固定自動設定対象
Public Enum eFreezePanesAsGrid
    FreezePanesNone
    FreezePanesAsFixed
    FreezePanesAsFrozen
End Enum

'====   印刷行/列のタイトル自動設定対象
Public Enum eTitleRowColAsGrid
    TitleRowColNone
    TitleRowColAsFixed
    TitleRowColAsFrozen
End Enum

'====   用紙の向き
Public Enum eOrientation
    ORPortrait = 1
    ORLandscape
End Enum

'====   用紙サイズ
Public Enum ePaperSize
    PaperLetter = 1
    PaperLetterSmall
    PaperTabloid
    PaperLedger
    PaperLegal
    PaperStatement
    PaperExecutive
    PaperA3
    PaperA4
    PaperA4Small
    PaperA5
    PaperB4
    PaperB5
    PaperFolio
    PaperQuarto
    Paper10x14
    Paper11x17
    PaperNote
    PaperEnvelope9
    PaperEnvelope10
    PaperEnvelope11
    PaperEnvelope12
    PaperEnvelope14
    PaperCsheet
    PaperDsheet
    PaperEsheet
    PaperEnvelopeDL
    PaperEnvelopeC5
    PaperEnvelopeC3
    PaperEnvelopeC4
    PaperEnvelopeC6
    PaperEnvelopeC65
    PaperEnvelopeB4
    PaperEnvelopeB5
    PaperEnvelopeB6
    PaperEnvelopeItaly
    PaperEnvelopeMonarch
    PaperEnvelopePersonal
    PaperFanfoldUS
    PaperFanfoldStdGerman
    PaperFanfoldLegalGerman = 41
    PaperUser = 256
End Enum

'====   横配置の種類
Private Enum eXlHAlign
    xlHAlignCenter = -4108              '中央揃え
    xlHAlignCenterAcrossSelection = 7   '選択範囲内で中央
    xlHAlignDistributed = -4117         '均等割り付け
    xlHAlignFill = 5                    '繰り返し
    xlHAlignGeneral = 1                 '標準
    xlHAlignJustify = -4130             '両端揃え
    xlHAlignLeft = -4131                '左詰め(インデント)
    xlHAlignRight = -4152               '右詰め
End Enum

'====   縦配置の種類
Private Enum eXlVAlign
    xlVAlignBottom = -4107              '下詰め
    xlVAlignCenter = -4108              '中央揃え
    xlVAlignDistributed = -4117         '均等割り付け
    xlVAlignJustify = -4130             '両端揃え
    xlVAlignTop = -4160                 '上揃え
End Enum

'====   下線の種類
Private Enum eXlUnderlineStyle
    xlUnderlineStyleNone = -4142            'なし
    xlUnderlineStyleSingle = 2              '下線
    xlUnderlineStyleDouble = -4119          '二重下線
    xlUnderlineStyleSingleAccounting = 4    '下線(会計)
    xlUnderlineStyleDoubleAccounting = 5    '二重下線(会計)
End Enum

'====   罫線インデックス
Public Enum eXlBordersIndex
    xlDiagonalDown = 5          '右下がり対角線
    xlDiagonalUp = 6            '右上がり対角線
    xlEdgeLeft = 7              '外枠左
    xlEdgeTop = 8               '外枠上
    xlEdgeBottom = 9            '外枠下
    xlEdgeRight = 10            '外枠右
    xlInsideVertical = 11       '内側縦線
    xlInsideHorizontal = 12     '内側横線
End Enum

'====   罫線の種類
Public Enum eXlLineStyle
    xlContinuous = 1            '実線(既定値)
    xlDash = -4115              '破線
    xlDashDot = 4               '１点鎖線
    xlDashDotDot = 5            '２点鎖線
    xlDot = -4118               '点線
    xlDouble = -4119            '二重線
    xlLineStyleNone = -4142     '線なし
    xlSlantDashDot = 13         '斜点線
End Enum

'====   罫線の太さ
Public Enum eXlBorderWeight
    xlHairline = 1              '極細線
    xlMedium = -4138            '中線
    xlThick = 4                 '太線
    xlThin = 2                  '細線(既定値)
End Enum

'====   出力対象
Public Enum eOutputTarget
    OTTextDisplay
    OTTextMatrix
End Enum

'////////////////////////////////////////////////////////////////////////
'   構造体宣言
'////////////////////////////////////////////////////////////////////////
'====   セル範囲
Private Type tRange
    Row1 As Long
    Col1 As Long
    Row2 As Long
    Col2 As Long
    Rows As Long
    Cols As Long
End Type

'====   ２分探索木ノード(色情報格納用)
Private Type tBinaryTreeNode
    LIndex As Long
    RIndex As Long
    Key As Long
End Type

'====   文字配置
Private Type tAlignment
    HAlign As eXlHAlign
    VAlign As eXlVAlign
End Type

'====   フォント情報
Private Type tFont
    FName As String
    Size As Single
    Italic As Boolean
    Bold As Boolean
    Underline As eXlUnderlineStyle
    Strikethrough As Boolean
End Type

'====   結合セル情報
Private Type tMergeRange
    Rows As Long
    Cols As Long
End Type

'====   罫線情報
Private Type tBorder
    LineStyle As eXlLineStyle
    Weight As eXlBorderWeight
    Color As Long
End Type

'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
'
'   イベント
'
'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
Public Event BeforeOutput(ByVal ExcelBook As Object, ByRef ExcelSheet As Object)
Public Event AfterOutput(ByVal ExcelBook As Object, ByRef ExcelSheet As Object)
Public Event BeforeOutputRow(ByVal ExcelBook As Object, ByRef ExcelSheet As Object, ByVal GridRow As Long, ByRef CancelRow As Boolean, ByRef CancelAll As Boolean)
Public Event AfterOutputRow(ByVal ExcelBook As Object, ByRef ExcelSheet As Object, ByVal GridRow As Long)

'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
'
'   メンバ変数
'
'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
'====   Excel情報
Private m_ExApp As Object
Private m_ExBook As Object
Private m_ExSheet As Object
Private m_ExRow As Long                     '現在処理中の行
Private m_ExCol As Long                     '現在処理中の列
Private m_ExBaseRow As Long                 'OutputGridの基準行(Excel側)
Private m_ExBaseCol As Long                 'OutputGrid/OutputRowの基準列(Excel側)
Private m_Processing As Boolean             'OutputGrid処理中フラグ

'====   グリッド出力時に反映させる情報
Private m_ReflectNumberFormat As Boolean    '表示形式を反映する
Private m_ReflectAlignment As Boolean       '文字配置を反映する
Private m_ReflectMerge As Boolean           'セル結合を反映する
Private m_ReflectFont As Boolean            'フォントを反映する
Private m_ReflectBorder As Boolean          '簡易的に罫線を設定する
Private m_ReflectColor As Boolean           '色情報を反映する
Private m_Reflections() As eReflections     '各種書式反映済み管理配列
Private m_FreezePanesAsGrid As eFreezePanesAsGrid   'グリッドの固定セルに応じてExcel側にウィンドウ枠の固定設定をするかどうか(非表示考慮)
Private m_TitleRowColAsGrid As eTitleRowColAsGrid   'グリッドの固定セルに応じてExcel側に印刷行/列のタイトル設定をするかどうか(非表示考慮)

Private m_OurputTarget As eOutputTarget     '出力対象(TextDisplay/ValueMatrix)
Private m_GridLinesFixed(12) As tBorder     '固定セルの罫線情報
Private m_GridLinesFrozen(12) As tBorder    '静止セルの罫線情報
Private m_GridLines(12) As tBorder          '固定セル以外の罫線情報

'====   拡張エラー情報
Private m_ErrRowOver As Boolean             '出力行数超過エラー
Private m_ErrColOver As Boolean             '出力列数超過エラー
Private m_ErrPaletteOver As Boolean         '色情報数超過エラー

'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
'
'   プロパティ
'
'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
Public Property Get IsExcelEnabled() As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Get IsExcelEnabled
'Explanation:Excelが使用可能かチェック
'Return     :Boolean型(True:使用可能　False:使用不可)
'////////////////////////////////////////////////////////////////////////
Dim wExcelApp                   As Object

    '********************************************************************
    '   インスタンス作成チェック
    '********************************************************************
    On Error Resume Next
    Set wExcelApp = CreateObject("Excel.Application")
    IsExcelEnabled = (Err.Number <> 429)
    Set wExcelApp = Nothing
    On Error GoTo 0
    
End Property

Public Property Get ExcelVersion() As String
'////////////////////////////////////////////////////////////////////////
'Name       :Get ExcelVersion
'Explanation:Excelのバージョン
'Return     :String型(わかる範囲では以下の通り)
'           :7.0    Excel95
'           :8.0    Excel97
'           :8.0d   Excel97 SR-1
'           :8.0e   Excel97 SR-2
'           :9.0    Excel2000
'           :10.0   Excel2002
'           :11.0   Excel2003
'           :12.0   Excel2007
'////////////////////////////////////////////////////////////////////////
Dim wExcelApp                   As Object

    '********************************************************************
    '   インスタンス作成＆チェック
    '********************************************************************
    On Error Resume Next
    Set wExcelApp = CreateObject("Excel.Application")
    ExcelVersion = wExcelApp.Version
    Set wExcelApp = Nothing
    On Error GoTo 0
    
End Property

'====   Excelの表示・非表示
Public Property Let ExcelVisible(ByVal iVisible As Boolean)
    If Not (m_ExApp Is Nothing) Then
        m_ExApp.Visible = iVisible
    End If
End Property
Public Property Get ExcelVisible() As Boolean
    If Not (m_ExApp Is Nothing) Then
        ExcelVisible = m_ExApp.Visible
    End If
End Property

'====   アクティブウィンドウ(シート)のズーム
Public Property Let WindowZoom(ByVal iZoom As Integer)
    If Not (m_ExApp Is Nothing) Then
        If 10 <= iZoom And iZoom <= 400 Then
            m_ExApp.ActiveWindow.Zoom = iZoom
        End If
    End If
End Property
Public Property Get WindowZoom() As Integer
    If Not (m_ExApp Is Nothing) Then
        WindowZoom = m_ExApp.ActiveWindow.Zoom
    End If
End Property

'====   現在処理中の行
Public Property Let Row(ByVal iRow As Long)
    If m_Processing Then Exit Property  '処理中は読込専用
    If 0 < iRow And iRow <= cMaxRows Then m_ExRow = iRow
End Property
Public Property Get Row() As Long
    Row = m_ExRow
End Property

'====   OutputGrid/OutputRowの基準列(Excel側)
Public Property Let BaseCol(ByVal iBaseCol As Long)
    If m_Processing Then Exit Property  '処理中は読込専用
    If 0 < iBaseCol And iBaseCol <= cMaxCols Then m_ExBaseCol = iBaseCol
End Property
Public Property Get BaseCol() As Long
    BaseCol = m_ExBaseCol
End Property

'====   表示形式を反映するかどうか
Public Property Let ReflectNumberFormat(ByVal iReflectNumberFormat As Boolean)
    If m_Processing Then Exit Property  '処理中は読込専用
    m_ReflectNumberFormat = iReflectNumberFormat
End Property
Public Property Get ReflectNumberFormat() As Boolean
    ReflectNumberFormat = m_ReflectNumberFormat
End Property

'====   文字配置を反映するかどうか
Public Property Let ReflectAlignment(ByVal iReflectAlignment As Boolean)
    If m_Processing Then Exit Property  '処理中は読込専用
    m_ReflectAlignment = iReflectAlignment
End Property
Public Property Get ReflectAlignment() As Boolean
    ReflectAlignment = m_ReflectAlignment
End Property

'====   セル結合を反映するかどうか
Public Property Let ReflectMerge(ByVal iReflectMerge As Boolean)
    If m_Processing Then Exit Property  '処理中は読込専用
    m_ReflectMerge = iReflectMerge
End Property
Public Property Get ReflectMerge() As Boolean
    ReflectMerge = m_ReflectMerge
End Property

'====   フォントを反映するかどうか
Public Property Let ReflectFont(ByVal iReflectFont As Boolean)
    If m_Processing Then Exit Property  '処理中は読込専用
    m_ReflectFont = iReflectFont
End Property
Public Property Get ReflectFont() As Boolean
    ReflectFont = m_ReflectFont
End Property

'====   簡易的に罫線を設定するかどうか
Public Property Let ReflectBorder(ByVal iReflectBorder As Boolean)
    If m_Processing Then Exit Property  '処理中は読込専用
    m_ReflectBorder = iReflectBorder
End Property
Public Property Get ReflectBorder() As Boolean
    ReflectBorder = m_ReflectBorder
End Property

'====   色情報を反映するかどうか
Public Property Let ReflectColor(ByVal iReflectColor As Boolean)
    If m_Processing Then Exit Property  '処理中は読込専用
    m_ReflectColor = iReflectColor
End Property
Public Property Get ReflectColor() As Boolean
    ReflectColor = m_ReflectColor
End Property

'====   グリッドの固定セルに応じてExcel側にウィンドウ枠の固定設定をするかどうか(非表示考慮)
Public Property Let FreezePanesAsGrid(ByVal iFreezePanesAsGrid As eFreezePanesAsGrid)
    m_FreezePanesAsGrid = iFreezePanesAsGrid
End Property
Public Property Get FreezePanesAsGrid() As eFreezePanesAsGrid
    FreezePanesAsGrid = m_FreezePanesAsGrid
End Property

'====   グリッドの固定セルに応じてExcel側に印刷行/列のタイトル設定をするかどうか(非表示考慮)
Public Property Let TitleRowColAsGrid(ByVal iTitleRowColAsGrid As eTitleRowColAsGrid)
    m_TitleRowColAsGrid = iTitleRowColAsGrid
End Property
Public Property Get TitleRowColAsGrid() As eTitleRowColAsGrid
    TitleRowColAsGrid = m_TitleRowColAsGrid
End Property

'====   出力対象(TextDisplay/ValueMatrix)
Public Property Let OutputTarget(ByVal iOutputTarget As eOutputTarget)
    m_OurputTarget = iOutputTarget
End Property
Public Property Get OutputTarget() As eOutputTarget
    OutputTarget = m_OurputTarget
End Property

'====   出力行数超過エラー
Public Property Get ErrRowOver() As Boolean
    ErrRowOver = m_ErrRowOver
End Property

'====   出力列数超過エラー
Public Property Get ErrColOver() As Boolean
    ErrColOver = m_ErrColOver
End Property

'====   色情報数超過エラー
Public Property Get ErrPaletteOver() As Boolean
    ErrPaletteOver = m_ErrPaletteOver
End Property

'====   標準の行高
Public Property Let StandardHeight(ByVal iStandardHeight As Double)
    If Not (m_ExSheet Is Nothing) Then
        m_ExSheet.StandardHeight = iStandardHeight
    End If
End Property
Public Property Get StandardHeight() As Double
    If Not (m_ExSheet Is Nothing) Then
        StandardHeight = m_ExSheet.StandardHeight
    End If
End Property

'====   標準の列幅
Public Property Let StandardWidth(ByVal iStandardWidth As Double)
    If Not (m_ExSheet Is Nothing) Then
        m_ExSheet.StandardWidth = iStandardWidth
    End If
End Property
Public Property Get StandardWidth() As Double
    If Not (m_ExSheet Is Nothing) Then
        StandardWidth = m_ExSheet.StandardWidth
    End If
End Property

'====   印刷の向き
Public Property Let Orientation(ByVal iOrientation As eOrientation)
    If Not (m_ExSheet Is Nothing) Then
        m_ExSheet.PageSetup.Orientation = iOrientation
    End If
End Property
Public Property Get Orientation() As eOrientation
    If Not (m_ExSheet Is Nothing) Then
        Orientation = m_ExSheet.PageSetup.Orientation
    End If
End Property

'====   拡大/縮小印刷
Public Property Let PageZoom(ByVal iZoom As Variant)
    If Not (m_ExSheet Is Nothing) Then
        If 10 <= iZoom And iZoom <= 400 Then
            m_ExSheet.PageSetup.Zoom = iZoom
        End If
    End If
End Property
Public Property Get PageZoom() As Variant
    If Not (m_ExSheet Is Nothing) Then
        PageZoom = m_ExSheet.PageSetup.Zoom
    End If
End Property

'====   横をページ数に合わせて印刷
Public Property Let FitToPagesWide(ByVal iFitToPagesWide As Variant)
    If Not (m_ExSheet Is Nothing) Then
        m_ExSheet.PageSetup.Zoom = False
        m_ExSheet.PageSetup.FitToPagesWide = iFitToPagesWide
    End If
End Property
Public Property Get FitToPagesWide() As Variant
    If Not (m_ExSheet Is Nothing) Then
        FitToPagesWide = m_ExSheet.PageSetup.FitToPagesWide
    End If
End Property

'====   縦をページ数に合わせて印刷
Public Property Let FitToPagesTall(ByVal iFitToPagesTall As Variant)
    If Not (m_ExSheet Is Nothing) Then
        m_ExSheet.PageSetup.Zoom = False
        m_ExSheet.PageSetup.FitToPagesTall = iFitToPagesTall
    End If
End Property
Public Property Get FitToPagesTall() As Variant
    If Not (m_ExSheet Is Nothing) Then
        FitToPagesTall = m_ExSheet.PageSetup.FitToPagesTall
    End If
End Property

'====   用紙サイズ
Public Property Let PaperSize(ByVal iPaperSize As ePaperSize)
    If Not (m_ExSheet Is Nothing) Then
        m_ExSheet.PageSetup.PaperSize = iPaperSize
    End If
End Property
Public Property Get PaperSize() As ePaperSize
    If Not (m_ExSheet Is Nothing) Then
        PaperSize = m_ExSheet.PageSetup.PaperSize
    End If
End Property

'====   上余白
Public Property Let TopMargin(ByVal iTopMargin As Double)
    If Not (m_ExSheet Is Nothing) Then
        m_ExSheet.PageSetup.TopMargin = m_ExApp.CentimetersToPoints(iTopMargin)
    End If
End Property
Public Property Get TopMargin() As Double
    If Not (m_ExSheet Is Nothing) Then
        TopMargin = m_ExSheet.PageSetup.TopMargin / cPtPerCm
    End If
End Property

'====   下余白
Public Property Let BottomMargin(ByVal iBottomMargin As Double)
    If Not (m_ExSheet Is Nothing) Then
        m_ExSheet.PageSetup.BottomMargin = m_ExApp.CentimetersBottomoints(iBottomMargin)
    End If
End Property
Public Property Get BottomMargin() As Double
    If Not (m_ExSheet Is Nothing) Then
        BottomMargin = m_ExSheet.PageSetup.BottomMargin / cPtPerCm
    End If
End Property

'====   左余白
Public Property Let LeftMargin(ByVal iLeftMargin As Double)
    If Not (m_ExSheet Is Nothing) Then
        m_ExSheet.PageSetup.LeftMargin = m_ExApp.CentimetersLeftoints(iLeftMargin)
    End If
End Property
Public Property Get LeftMargin() As Double
    If Not (m_ExSheet Is Nothing) Then
        LeftMargin = m_ExSheet.PageSetup.LeftMargin / cPtPerCm
    End If
End Property

'====   右余白
Public Property Let RightMargin(ByVal iRightMargin As Double)
    If Not (m_ExSheet Is Nothing) Then
        m_ExSheet.PageSetup.RightMargin = m_ExApp.CentimetersRightoints(iRightMargin)
    End If
End Property
Public Property Get RightMargin() As Double
    If Not (m_ExSheet Is Nothing) Then
        RightMargin = m_ExSheet.PageSetup.RightMargin / cPtPerCm
    End If
End Property

'====   ヘッダー余白
Public Property Let HeaderMargin(ByVal iHeaderMargin As Double)
    If Not (m_ExSheet Is Nothing) Then
        m_ExSheet.PageSetup.HeaderMargin = m_ExApp.CentimetersToPoints(iHeaderMargin)
    End If
End Property
Public Property Get HeaderMargin() As Double
    If Not (m_ExSheet Is Nothing) Then
        HeaderMargin = m_ExSheet.PageSetup.HeaderMargin / cPtPerCm
    End If
End Property

'====   フッター余白
Public Property Let FooterMargin(ByVal iFooterMargin As Double)
    If Not (m_ExSheet Is Nothing) Then
        m_ExSheet.PageSetup.FooterMargin = m_ExApp.CentimetersToPoints(iFooterMargin)
    End If
End Property
Public Property Get FooterMargin() As Double
    If Not (m_ExSheet Is Nothing) Then
        FooterMargin = m_ExSheet.PageSetup.FooterMargin / cPtPerCm
    End If
End Property

'====   水平ページ中央印刷
Public Property Let CenterHorizontally(ByVal iCenterHorizontally As Boolean)
    If Not (m_ExSheet Is Nothing) Then
        m_ExSheet.PageSetup.CenterHorizontally = iCenterHorizontally
    End If
End Property
Public Property Get CenterHorizontally() As Boolean
    If Not (m_ExSheet Is Nothing) Then
        CenterHorizontally = m_ExSheet.PageSetup.CenterHorizontally
    End If
End Property

'====   垂直ページ中央印刷
Public Property Let CenterVertically(ByVal iCenterVertically As Boolean)
    If Not (m_ExSheet Is Nothing) Then
        m_ExSheet.PageSetup.CenterVertically = iCenterVertically
    End If
End Property
Public Property Get CenterVertically() As Boolean
    If Not (m_ExSheet Is Nothing) Then
        CenterVertically = m_ExSheet.PageSetup.CenterVertically
    End If
End Property

'====   左側ヘッダー
Public Property Let LeftHeader(ByVal iLeftHeader As String)
    If Not (m_ExSheet Is Nothing) Then
        m_ExSheet.PageSetup.LeftHeader = iLeftHeader
    End If
End Property
Public Property Get LeftHeader() As String
    If Not (m_ExSheet Is Nothing) Then
        LeftHeader = m_ExSheet.PageSetup.LeftHeader
    End If
End Property

'====   中央部ヘッダー
Public Property Let CenterHeader(ByVal iCenterHeader As String)
    If Not (m_ExSheet Is Nothing) Then
        m_ExSheet.PageSetup.CenterHeader = iCenterHeader
    End If
End Property
Public Property Get CenterHeader() As String
    If Not (m_ExSheet Is Nothing) Then
        CenterHeader = m_ExSheet.PageSetup.CenterHeader
    End If
End Property

'====   右側ヘッダー
Public Property Let RightHeader(ByVal iRightHeader As String)
    If Not (m_ExSheet Is Nothing) Then
        m_ExSheet.PageSetup.RightHeader = iRightHeader
    End If
End Property
Public Property Get RightHeader() As String
    If Not (m_ExSheet Is Nothing) Then
        RightHeader = m_ExSheet.PageSetup.RightHeader
    End If
End Property

'====   左側フッター
Public Property Let LeftFooter(ByVal iLeftFooter As String)
    If Not (m_ExSheet Is Nothing) Then
        m_ExSheet.PageSetup.LeftFooter = iLeftFooter
    End If
End Property
Public Property Get LeftFooter() As String
    If Not (m_ExSheet Is Nothing) Then
        LeftFooter = m_ExSheet.PageSetup.LeftFooter
    End If
End Property

'====   中央部フッター
Public Property Let CenterFooter(ByVal iCenterFooter As String)
    If Not (m_ExSheet Is Nothing) Then
        m_ExSheet.PageSetup.CenterFooter = iCenterFooter
    End If
End Property
Public Property Get CenterFooter() As String
    If Not (m_ExSheet Is Nothing) Then
        CenterFooter = m_ExSheet.PageSetup.CenterFooter
    End If
End Property

'====   右側フッター
Public Property Let RightFooter(ByVal iRightFooter As String)
    If Not (m_ExSheet Is Nothing) Then
        m_ExSheet.PageSetup.RightFooter = iRightFooter
    End If
End Property
Public Property Get RightFooter() As String
    If Not (m_ExSheet Is Nothing) Then
        RightFooter = m_ExSheet.PageSetup.RightFooter
    End If
End Property

'====   印刷行のタイトル
Public Property Let PrintTitleRows(ByVal iPrintTitleRows As String)
    If Not (m_ExSheet Is Nothing) Then
        m_ExSheet.PageSetup.PrintTitleRows = iPrintTitleRows
    End If
End Property
Public Property Get PrintTitleRows() As String
    If Not (m_ExSheet Is Nothing) Then
        PrintTitleRows = m_ExSheet.PageSetup.PrintTitleRows
    End If
End Property

'====   印刷列のタイトル
Public Property Let PrintTitleColumns(ByVal iPrintTitleColumns As String)
    If Not (m_ExSheet Is Nothing) Then
        m_ExSheet.PageSetup.PrintTitleColumns = iPrintTitleColumns
    End If
End Property
Public Property Get PrintTitleColumns() As String
    If Not (m_ExSheet Is Nothing) Then
        PrintTitleColumns = m_ExSheet.PageSetup.PrintTitleColumns
    End If
End Property

'====   枠線印刷
Public Property Let PrintGridLines(ByVal iPrintGridLines As Boolean)
    If Not (m_ExSheet Is Nothing) Then
        m_ExSheet.PageSetup.PrintGridLines = iPrintGridLines
    End If
End Property
Public Property Get PrintGridLines() As Boolean
    If Not (m_ExSheet Is Nothing) Then
        PrintGridLines = m_ExSheet.PageSetup.PrintGridLines
    End If
End Property

'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
'
'   メソッド
'
'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
Private Sub Class_Initialize()
'////////////////////////////////////////////////////////////////////////
'Name       :Class_Initialize
'Explanation:クラスInitializeイベントプロシージャ
'////////////////////////////////////////////////////////////////////////
Dim wBordersIndex               As eXlBordersIndex

    '********************************************************************
    '   メンバ変数初期化
    '********************************************************************
    Set m_ExApp = Nothing
    Set m_ExBook = Nothing
    Set m_ExSheet = Nothing
    m_ExRow = 1
    m_ExBaseCol = 1
    
    m_ReflectNumberFormat = False
    m_ReflectAlignment = False
    m_ReflectMerge = False
    m_ReflectFont = False
    m_ReflectBorder = False
    m_ReflectColor = False
    m_FreezePanesAsGrid = FreezePanesNone
    m_TitleRowColAsGrid = TitleRowColNone
    m_OurputTarget = OTTextDisplay
    
    For wBordersIndex = xlDiagonalDown To xlInsideHorizontal
        Select Case wBordersIndex
        Case xlDiagonalDown, xlDiagonalUp
            m_GridLinesFixed(wBordersIndex).LineStyle = xlLineStyleNone
            m_GridLinesFixed(wBordersIndex).Weight = xlThin
            m_GridLinesFrozen(wBordersIndex).LineStyle = xlLineStyleNone
            m_GridLinesFrozen(wBordersIndex).Weight = xlThin
            m_GridLines(wBordersIndex).LineStyle = xlLineStyleNone
            m_GridLines(wBordersIndex).Weight = xlThin
        Case xlInsideVertical, xlInsideHorizontal
            m_GridLinesFixed(wBordersIndex).LineStyle = xlContinuous
            m_GridLinesFixed(wBordersIndex).Weight = xlHairline
            m_GridLinesFrozen(wBordersIndex).LineStyle = xlContinuous
            m_GridLinesFrozen(wBordersIndex).Weight = xlHairline
            m_GridLines(wBordersIndex).LineStyle = xlContinuous
            m_GridLines(wBordersIndex).Weight = xlHairline
        Case Else
            m_GridLinesFixed(wBordersIndex).LineStyle = xlContinuous
            m_GridLinesFixed(wBordersIndex).Weight = xlThin
            m_GridLinesFrozen(wBordersIndex).LineStyle = xlContinuous
            m_GridLinesFrozen(wBordersIndex).Weight = xlThin
            m_GridLines(wBordersIndex).LineStyle = xlContinuous
            m_GridLines(wBordersIndex).Weight = xlThin
        End Select
    Next

End Sub

Public Function OpenWorkbook(ByVal iFileName As String, _
                             Optional ByVal iSheet As Variant) As Long
'////////////////////////////////////////////////////////////////////////
'Name       :OpenWorkbook
'Explanation:既存のワークブックを開く
'Arguments  :iFileName          I   ブックのファイル名
'           :iSheet             I   出力対象シート
'Return     :Long型(0:正常　0以外:エラーコード)
'////////////////////////////////////////////////////////////////////////
    
    '********************************************************************
    '   ワークブックを開く
    '********************************************************************
    On Error GoTo ERR_PROCESS
    Set m_ExApp = CreateObject("Excel.Application")
    Set m_ExBook = m_ExApp.Workbooks.Open(iFileName)
    Set m_ExSheet = m_ExBook.Worksheets(1)
    If Not IsMissing(iSheet) Then
        Set m_ExSheet = m_ExBook.Worksheets(iSheet)
    End If
    On Error GoTo 0

Exit Function

ERR_PROCESS:
    '********************************************************************
    '   Error
    '********************************************************************
    OpenWorkbook = Err.Number
    
End Function

Public Function OpenNewWorkbook(Optional ByVal iSheet As Variant) As Long
'////////////////////////////////////////////////////////////////////////
'Name       :OpenNewWorkbook
'Explanation:新しいワークブックを開く
'Arguments  :iSheet             I   出力対象シート
'Return     :Long型(0:正常　0以外:エラーコード)
'////////////////////////////////////////////////////////////////////////
    
    '********************************************************************
    '   ワークブックを開く
    '********************************************************************
    On Error GoTo ERR_PROCESS
    Set m_ExApp = CreateObject("Excel.Application")
    Set m_ExBook = m_ExApp.Workbooks.Add
    Set m_ExSheet = m_ExBook.Worksheets(1)
    If Not IsMissing(iSheet) Then
        Set m_ExSheet = m_ExBook.Worksheets(iSheet)
    End If
    On Error GoTo 0

Exit Function

ERR_PROCESS:
    '********************************************************************
    '   Error
    '********************************************************************
    OpenNewWorkbook = Err.Number

End Function

Public Sub OutputGrid(ByRef iGrid As VSFlexGrid, _
                      Optional ByVal iRowRange1 As Long = -1, _
                      Optional ByVal iColRange1 As Long = -1, _
                      Optional ByVal iRowRange2 As Long = -1, _
                      Optional ByVal iColRange2 As Long = -1)
'////////////////////////////////////////////////////////////////////////
'Name       :OutputGrid
'Explanation:カレント行以降にグリッド内容を出力する
'Arguments  :iGrid              I   対象グリッド
'           :iRowRange1         I   出力範囲開始行
'           :iColRange1         I   出力範囲開始列
'           :iRowRange2         I   出力範囲終了行
'           :iColRange2         I   出力範囲終了列
'////////////////////////////////////////////////////////////////////////
Dim wRows                       As Long     '出力行数(非表示分考慮)
Dim wCols                       As Long     '出力列数(非表示分考慮)
Dim wFixedRows                  As Long     '出力固定行数(非表示分考慮)
Dim wFixedCols                  As Long     '出力固定列数(非表示分考慮)
Dim wFrozenRows                 As Long     '出力静止行数(非表示分考慮)
Dim wFrozenCols                 As Long     '出力静止列数(非表示分考慮)
Dim wRange                      As tRange
Dim wRow                        As Long     'グリッド処理行
Dim wCol                        As Long     'グリッド処理列
Dim wPalettes()                 As tBinaryTreeNode  'パレット設定配列
Dim wLpi                        As Long
Dim wCellIndex                  As Long     'Excel処理行列インデックス
Dim wRowData()                  As Variant  '1行分のセルデータ
Dim wCancelRow                  As Boolean  '1行出力キャンセルフラグ
Dim wCancelAll                  As Boolean  '出力キャンセルフラグ
Dim wMergeRange                 As tMergeRange

    '********************************************************************
    '   前処理
    '********************************************************************
    If m_ExSheet Is Nothing Then Exit Sub
    RaiseEvent BeforeOutput(m_ExBook, m_ExSheet)
    
    '********************************************************************
    '   出力行列数の事前チェック
    '********************************************************************
    If iRowRange1 < 0 Then iRowRange1 = 0
    If iColRange1 < 0 Then iColRange1 = 0
    If iRowRange2 < 0 Then iRowRange2 = iGrid.Rows - 1
    If iColRange2 < 0 Then iColRange2 = iGrid.Cols - 1
    For wRow = iRowRange1 To iRowRange2
        If Not iGrid.RowHidden(wRow) Then
            wRows = wRows + 1
            If wRow < iGrid.FixedRows Then
                wFixedRows = wFixedRows + 1
            ElseIf wRow < iGrid.FixedRows + iGrid.FrozenRows Then
                wFrozenRows = wFrozenRows + 1
            End If
        End If
    Next
    m_ErrRowOver = (cMaxRows < (m_ExRow + (wRows - 1)))
    For wCol = iColRange1 To iColRange2
        If Not iGrid.ColHidden(wCol) Then
            wCols = wCols + 1
            If wCol < iGrid.FixedCols Then
                wFixedCols = wFixedCols + 1
            ElseIf wCol < iGrid.FixedCols + iGrid.FrozenCols Then
                wFrozenCols = wFrozenCols + 1
            End If
        End If
    Next
    m_ErrColOver = (cMaxCols < (m_ExBaseCol + (wCols - 1)))
    If wRows = 0 Or wCols = 0 Then Exit Sub
    m_Processing = True
    ReDim m_Reflections(wRows * wCols - 1)
    
    '********************************************************************
    '   簡易的に罫線を設定
    '********************************************************************
    If m_ReflectBorder Then
        '================================================================
        '   固定セル以外を設定
        '================================================================
        Call SetExcelBorders(m_GridLines, m_ExRow, m_ExBaseCol, wRows, wCols)
        '================================================================
        '   静止セルを設定
        '================================================================
        '====   静止行
        Call SetExcelBorders(m_GridLinesFrozen, m_ExRow, m_ExBaseCol, wFixedRows + wFrozenRows, wCols)
        '====   静止列
        Call SetExcelBorders(m_GridLinesFrozen, m_ExRow, m_ExBaseCol, wRows, wFixedCols + wFrozenCols)
        '====   静止行と静止列の交差部分
        Call SetExcelBorders(m_GridLinesFrozen, m_ExRow, m_ExBaseCol, wFixedRows + wFrozenRows, wFixedCols + wFrozenCols)
        '================================================================
        '   固定セルを設定
        '================================================================
        '====   固定行
        Call SetExcelBorders(m_GridLinesFixed, m_ExRow, m_ExBaseCol, wFixedRows, wCols)
        '====   固定列
        Call SetExcelBorders(m_GridLinesFixed, m_ExRow, m_ExBaseCol, wRows, wFixedCols)
        '===    固定行と固定列の交差部分
        Call SetExcelBorders(m_GridLinesFixed, m_ExRow, m_ExBaseCol, wFixedRows, wFixedCols)
    End If
    
    '********************************************************************
    '   ウィンドウ枠の固定設定
    '********************************************************************
    Select Case m_FreezePanesAsGrid
    Case eFreezePanesAsGrid.FreezePanesAsFixed
        Call FreezePanes(m_ExRow + wFixedRows, m_ExBaseCol + wFixedCols)
    Case eFreezePanesAsGrid.FreezePanesAsFrozen
        Call FreezePanes(m_ExRow + wFixedRows + wFrozenRows, m_ExBaseCol + wFixedCols + wFrozenCols)
    End Select
    
    '********************************************************************
    '   印刷行/列のタイトル設定(Addressで$○:$○形式に変換して設定)
    '********************************************************************
    Select Case m_TitleRowColAsGrid
    Case eTitleRowColAsGrid.TitleRowColAsFixed
        If 0 < wFixedRows Then
            wRange = GetValidRange(m_ExRow, 1, wFixedRows, 1)
            m_ExSheet.PageSetup.PrintTitleRows = _
                m_ExSheet.Range(m_ExSheet.Rows(wRange.Row1), m_ExSheet.Rows(wRange.Row2)).Address
        End If
        If 0 < wFixedCols Then
            wRange = GetValidRange(1, m_ExBaseCol, 1, wFixedCols)
            m_ExSheet.PageSetup.PrintTitleColumns = _
                m_ExSheet.Range(m_ExSheet.Columns(wRange.Col1), m_ExSheet.Columns(wRange.Col2)).Address
        End If
    Case eTitleRowColAsGrid.TitleRowColAsFrozen
        If 0 < wFixedRows + wFrozenRows Then
            wRange = GetValidRange(m_ExRow, 1, wFixedRows + wFrozenRows, 1)
            m_ExSheet.PageSetup.PrintTitleRows = _
                m_ExSheet.Range(m_ExSheet.Rows(wRange.Row1), m_ExSheet.Rows(wRange.Row2)).Address
        End If
        If 0 < wFixedCols + wFrozenCols Then
            wRange = GetValidRange(1, m_ExBaseCol, 1, wFixedCols + wFrozenCols)
            m_ExSheet.PageSetup.PrintTitleColumns = _
                m_ExSheet.Range(m_ExSheet.Columns(wRange.Col1), m_ExSheet.Columns(wRange.Col2)).Address
        End If
    End Select
    
    '********************************************************************
    '   色情報事前チェック
    '********************************************************************
    m_ErrPaletteOver = False
    If m_ReflectColor Then
        m_ErrPaletteOver = GetGridColors(wPalettes, iGrid, iRowRange1, iColRange1, iRowRange2, iColRange2)
        For wLpi = 1 To UBound(wPalettes)
            m_ExBook.Colors(wLpi) = wPalettes(wLpi).Key
        Next
    End If
    
    '********************************************************************
    '   グリッド内容出力
    '********************************************************************
    m_ExBaseRow = m_ExRow
    For wRow = iRowRange1 To iRowRange2
        If iGrid.RowHidden(wRow) Then GoTo ROW_CONTINUE
        '================================================================
        '   初期化
        '================================================================
        ReDim wRowData(wCols - 1)
        m_ExCol = m_ExBaseCol
        '================================================================
        '   セル毎の情報取得
        '================================================================
        For wCol = iColRange1 To iColRange2
            If iGrid.ColHidden(wCol) Then GoTo COL_CONTINUE
            wCellIndex = GetCellIndex(m_ExRow - m_ExBaseRow, m_ExCol - m_ExBaseCol, wCols)
            '------------------------------------------------------------
            '   セル結合を反映
            '------------------------------------------------------------
            If m_ReflectMerge Then
                '====   結合済みセルなら飛ばす
                If m_ExSheet.Cells(m_ExRow, m_ExCol).MergeCells Then
                    m_ExCol = m_ExCol + 1
                    If cMaxCols < m_ExCol Then Exit For
                    GoTo COL_CONTINUE
                End If
                '====   セル結合を反映
                If GetGridMergedRange(iGrid, wRow, wCol, wMergeRange) Then
                    wRange = GetValidRange(m_ExRow, m_ExCol, wMergeRange.Rows, wMergeRange.Cols)
                    m_ExSheet.Cells(m_ExRow, m_ExCol).Resize(wRange.Rows, wRange.Cols).Merge
                End If
            End If
            '------------------------------------------------------------
            '   表示形式を反映
            '------------------------------------------------------------
            If m_ReflectNumberFormat Then
                If (m_Reflections(wCellIndex) And RefNumberFormat) = RefNone Then
                    Call SetNumberFormat(iGrid, wRow, wCol, iRowRange2, iColRange2, wCols)
                End If
            End If
            '------------------------------------------------------------
            '   文字配置を反映
            '------------------------------------------------------------
            If m_ReflectAlignment Then
                If (m_Reflections(wCellIndex) And RefAlignment) = RefNone Then
                    Call SetAlignment(iGrid, wRow, wCol, iRowRange2, iColRange2, wCols)
                End If
            End If
            '------------------------------------------------------------
            '   フォントを反映
            '------------------------------------------------------------
            If m_ReflectFont Then
                If (m_Reflections(wCellIndex) And RefFont) = RefNone Then
                    Call SetFont(iGrid, wRow, wCol, iRowRange2, iColRange2, wCols)
                End If
            End If
            '------------------------------------------------------------
            '   色情報を反映
            '------------------------------------------------------------
            If m_ReflectColor Then
                If (m_Reflections(wCellIndex) And RefBackColor) = RefNone Then
                    Call SetBackColor(iGrid, wRow, wCol, iRowRange2, iColRange2, wCols)
                End If
                If (m_Reflections(wCellIndex) And RefForeColor) = RefNone Then
                    Call SetForeColor(iGrid, wRow, wCol, iRowRange2, iColRange2, wCols)
                End If
            End If
            '------------------------------------------------------------
            '   出力テキスト取得
            '------------------------------------------------------------
            Select Case m_OurputTarget
            Case OTTextDisplay
                wRowData(m_ExCol - m_ExBaseCol) = iGrid.Cell(flexcpTextDisplay, wRow, wCol)
            Case OTTextMatrix
                wRowData(m_ExCol - m_ExBaseCol) = iGrid.TextMatrix(wRow, wCol)
            End Select
            m_ExCol = m_ExCol + 1
            If cMaxCols < m_ExCol Then Exit For
COL_CONTINUE:
        Next
        '================================================================
        '   1行分まとめて出力
        '================================================================
        wCancelRow = False
        RaiseEvent BeforeOutputRow(m_ExBook, m_ExSheet, wRow, wCancelRow, wCancelAll)
        If wCancelAll Then Exit For
        If Not wCancelRow Then
            wRange = GetValidRange(m_ExRow, m_ExBaseCol, 1, wCols)
            m_ExSheet.Cells(m_ExRow, m_ExBaseCol).Resize(wRange.Rows, wRange.Cols).Value = wRowData
            RaiseEvent AfterOutputRow(m_ExBook, m_ExSheet, wRow)
        End If
        m_ExRow = m_ExRow + 1
        If cMaxRows < m_ExRow Then Exit For
ROW_CONTINUE:
    Next
    
    '********************************************************************
    '   後処理
    '********************************************************************
    m_Processing = False
    Erase m_Reflections
    RaiseEvent AfterOutput(m_ExBook, m_ExSheet)
    
End Sub

Public Function OutputRow(ParamArray Cols() As Variant) As Long
'////////////////////////////////////////////////////////////////////////
'Name       :OutputRow
'Explanation:カレント行にテキストを出力する
'Arguments  :Cols               I   列毎の文字列
'Return     :Long型(0:正常　0以外:エラーコード)
'////////////////////////////////////////////////////////////////////////
Dim wRange                      As tRange

    '********************************************************************
    '   テキスト出力
    '********************************************************************
    If m_ExSheet Is Nothing Then Exit Function
    If Not IsMissing(Cols) Then
        m_ExApp.DisplayAlerts = False
        wRange = GetValidRange(m_ExRow, m_ExBaseCol, 1, UBound(Cols) + 1)
        On Error GoTo ERR_PROCESS
        m_ExSheet.Cells(m_ExRow, m_ExBaseCol).Resize(wRange.Rows, wRange.Cols) = Cols
        On Error GoTo 0
        m_ExApp.DisplayAlerts = True
    End If
    m_ExRow = m_ExRow + 1
    If cMaxRows < m_ExRow Then m_ExRow = cMaxRows
    
Exit Function

ERR_PROCESS:
    '********************************************************************
    '   Error
    '********************************************************************
    m_ExApp.DisplayAlerts = True
    OutputRow = Err.Number
    
End Function

Public Sub FreezePanes(ByVal iRow As Long, ByVal iCol As Long)
'////////////////////////////////////////////////////////////////////////
'Name       :FreezePanes
'Explanation:ウィンドウ枠の固定設定をする
'Arguments  :iRow               I   対象行(Excel側)
'           :iCol               I   対象列(Excel側)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   ウィンドウ枠の固定
    '********************************************************************
    If m_ExApp Is Nothing Then Exit Sub
    If iRow < 1 Then iRow = 1
    If cMaxRows < iRow Then iRow = cMaxRows
    If iCol < 1 Then iCol = 1
    If cMaxCols < iCol Then iCol = cMaxCols
    m_ExApp.ActiveWindow.FreezePanes = False    'いったん解除
    m_ExApp.Cells(iRow, iCol).Select
    m_ExApp.ActiveWindow.FreezePanes = True     '設定
    
End Sub

Public Sub AutoFitRows()
'////////////////////////////////////////////////////////////////////////
'Name       :AutoFitRows
'Explanation:自動行高調整
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   行高の自動調整
    '********************************************************************
    If m_ExSheet Is Nothing Then Exit Sub
    m_ExSheet.Rows.AutoFit
    
End Sub

Public Sub AutoFitColumns()
'////////////////////////////////////////////////////////////////////////
'Name       :AutoFitColumns
'Explanation:自動列幅調整
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   列幅の自動調整
    '********************************************************************
    If m_ExSheet Is Nothing Then Exit Sub
    m_ExSheet.Columns.AutoFit
    
End Sub

Public Function CloseWorkbook(Optional ByVal iSaveChanges As Boolean = False, _
                              Optional ByVal iFileName As String = "") As Long
'////////////////////////////////////////////////////////////////////////
'Name       :CloseWorkbook
'Explanation:処理中のワークブックを閉じる
'Arguments  :iSaveChanges       I   True:変更を保存する　False:しない
'           :iFileName          I   ブックのファイル名
'Return     :Long型(0:正常　0以外:エラーコード)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   ワークブックを閉じる
    '********************************************************************
    If m_ExBook Is Nothing Then Exit Function
    m_ExApp.DisplayAlerts = False   '同名ファイルがあっても上書き保存する
    On Error GoTo ERR_PROCESS
    Call m_ExBook.Close(iSaveChanges, iFileName)
    On Error GoTo 0
    m_ExApp.DisplayAlerts = True
    Set m_ExSheet = Nothing
    Set m_ExBook = Nothing
    
Exit Function

ERR_PROCESS:
    '********************************************************************
    '   Error
    '********************************************************************
    m_ExApp.DisplayAlerts = True
    CloseWorkbook = Err.Number
    
End Function

Public Function SaveWorkbook() As Long
'////////////////////////////////////////////////////////////////////////
'Name       :SaveWorkbook
'Explanation:処理中のワークブックを保存する
'Return     :Long型(0:正常　0以外:エラーコード)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   ワークブックを保存
    '********************************************************************
    If m_ExBook Is Nothing Then Exit Function
    m_ExApp.DisplayAlerts = False   '同名ファイルがあっても上書き保存する
    On Error GoTo ERR_PROCESS
    Call m_ExBook.Save
    On Error GoTo 0
    m_ExApp.DisplayAlerts = True
    
Exit Function

ERR_PROCESS:
    '********************************************************************
    '   Error
    '********************************************************************
    m_ExApp.DisplayAlerts = True
    SaveWorkbook = Err.Number
    
End Function

Public Function SaveAsWorkbook(ByVal iFileName As String) As Long
'////////////////////////////////////////////////////////////////////////
'Name       :SaveAsWorkbook
'Explanation:処理中のワークブックを名前を付けて保存する
'Arguments  :iFileName          I   ブックのファイル名
'Return     :Long型(0:正常　0以外:エラーコード)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   ワークブックを名前を付けて保存
    '********************************************************************
    If m_ExBook Is Nothing Then Exit Function
    m_ExApp.DisplayAlerts = False   '同名ファイルがあっても上書き保存する
    On Error GoTo ERR_PROCESS
    Call m_ExBook.SaveAs(iFileName)
    On Error GoTo 0
    m_ExApp.DisplayAlerts = True
    
Exit Function

ERR_PROCESS:
    '********************************************************************
    '   Error
    '********************************************************************
    m_ExApp.DisplayAlerts = True
    SaveAsWorkbook = Err.Number
    
End Function

Private Function GetCellIndex(ByVal iRow As Long, ByVal iCol As Long, ByVal iCols As Long) As Long
'////////////////////////////////////////////////////////////////////////
'Name       :GetCellIndex
'Explanation:行列番号(0スタート)を元に1次元配列上でのインデックスを返す
'Arguments  :iRow               I   対象行
'           :iCol               I   対象列
'           :iCols              I   列数
'Return     :Long型
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   変換
    '********************************************************************
    GetCellIndex = iRow * iCols + iCol
    
End Function

Private Function GetValidRange(ByVal iRow As Long, ByVal iCol As Long, ByVal iRows As Long, ByVal iCols As Long) As tRange
'////////////////////////////////////////////////////////////////////////
'Name       :GetValidRange
'Explanation:Excelの行列制限を超えないセル範囲を返す
'Arguments  :iRow               I   基準行
'           :iCol               I   基準列
'           :iRows              I   行数(>0)
'           :iCols              I   列数(>0)
'Return     :tRange型
'////////////////////////////////////////////////////////////////////////
Dim wRange                      As tRange

    '********************************************************************
    '   行列範囲チェック
    '********************************************************************
    With wRange
        .Row1 = iRow
        If cMaxRows < .Row1 Then .Row1 = cMaxRows
        
        .Col1 = iCol
        If cMaxCols < .Col1 Then .Col1 = cMaxCols
        
        .Row2 = .Row1
        If 0 < iRows Then .Row2 = .Row1 + iRows - 1
        If cMaxRows < .Row2 Then .Row2 = cMaxRows
        
        .Col2 = .Col1
        If 0 < iCols Then .Col2 = .Col1 + iCols - 1
        If cMaxCols < .Col2 Then .Col2 = cMaxCols
        
        .Rows = .Row2 - .Row1 + 1
        .Cols = .Col2 - .Col1 + 1
    End With
    GetValidRange = wRange

End Function

Private Sub SetExcelBorders(ByRef iBorders() As tBorder, ByVal iRow As Long, ByVal iCol As Long, ByVal iRows As Long, ByVal iCols As Long)
'////////////////////////////////////////////////////////////////////////
'Name       :SetExcelBorders
'Explanation:Excelに罫線を設定する
'Arguments  :iBorders           I   設定罫線情報
'           :iRow               I   設定範囲開始行
'           :iCol               I   設定範囲開始列
'           :iRows              I   設定行数
'           :iCols              I   設定列数
'////////////////////////////////////////////////////////////////////////
Dim wRange                      As tRange
Dim wBordersIndex               As eXlBordersIndex

    If m_ExSheet Is Nothing Then Exit Sub
    '********************************************************************
    '   範囲取得
    '********************************************************************
    If iRows = 0 Or iCols = 0 Then Exit Sub
    wRange = GetValidRange(iRow, iCol, iRows, iCols)
    
    '********************************************************************
    '   罫線設定
    '********************************************************************
    With m_ExSheet.Cells(wRange.Row1, wRange.Col1).Resize(wRange.Rows, wRange.Cols)
        For wBordersIndex = xlDiagonalDown To xlInsideHorizontal
            Select Case wBordersIndex
            Case xlInsideVertical
                If 1 < wRange.Cols Then
                    .Borders(wBordersIndex).Weight = iBorders(wBordersIndex).Weight
                    .Borders(wBordersIndex).LineStyle = iBorders(wBordersIndex).LineStyle
                End If
            Case xlInsideHorizontal
                If 1 < wRange.Rows Then
                    .Borders(wBordersIndex).Weight = iBorders(wBordersIndex).Weight
                    .Borders(wBordersIndex).LineStyle = iBorders(wBordersIndex).LineStyle
                End If
            Case Else
                .Borders(wBordersIndex).Weight = iBorders(wBordersIndex).Weight
                .Borders(wBordersIndex).LineStyle = iBorders(wBordersIndex).LineStyle
            End Select
        Next
    End With
    
End Sub

Private Function GetGridColors(ByRef oPalletes() As tBinaryTreeNode, ByRef iGrid As VSFlexGrid, _
                               Optional ByVal iRowRange1 As Long = -1, _
                               Optional ByVal iColRange1 As Long = -1, _
                               Optional ByVal iRowRange2 As Long = -1, _
                               Optional ByVal iColRange2 As Long = -1) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :GetGridColors
'Explanation:グリッドに設定されている色情報取得
'Arguments  :oPalletes          O   色情報配列
'           :iGrid              I   対象グリッド
'           :iRowRange1         I   出力範囲開始行
'           :iColRange1         I   出力範囲開始列
'           :iRowRange2         I   出力範囲終了行
'           :iColRange2         I   出力範囲終了列
'Return     :Boolean型(False:正常　True:色情報数超過)
'////////////////////////////////////////////////////////////////////////
Dim wRow                        As Long
Dim wCol                        As Long
Dim wColor                      As Long
Dim wPaletteOver                As Boolean

    '********************************************************************
    '   前処理
    '********************************************************************
    If iRowRange1 < 0 Then iRowRange1 = 0
    If iColRange1 < 0 Then iColRange1 = 0
    If iRowRange2 < 0 Then iRowRange2 = iGrid.Rows - 1
    If iColRange2 < 0 Then iColRange2 = iGrid.Cols - 1
    Call BinaryTreeInit(oPalletes, -1)
    
    '********************************************************************
    '   よく使われる黒と白は固定的に追加
    '********************************************************************
    Call BinaryTreeAddKey(oPalletes, vbBlack)
    Call BinaryTreeAddKey(oPalletes, vbWhite)
    
    '********************************************************************
    '   色情報取得
    '********************************************************************
    For wRow = iRowRange1 To iRowRange2
        If iGrid.RowHidden(wRow) Then GoTo ROW_CONTINUE
        For wCol = iColRange1 To iColRange2
            If iGrid.ColHidden(wCol) Then GoTo COL_CONTINUE
            '====   背景色追加
            wColor = GetGridCellBackColor(iGrid, wRow, wCol)
            If wColor <> vbBlack And wColor <> vbWhite Then
                Call BinaryTreeAddKey(oPalletes, wColor)
            End If
            '====   前景色追加
            wColor = GetGridCellForeColor(iGrid, wRow, wCol)
            If wColor <> vbBlack And wColor <> vbWhite Then
                Call BinaryTreeAddKey(oPalletes, wColor)
            End If
            '====   色情報数超過チェック
            If cMaxPalettes < UBound(oPalletes) Then
                wPaletteOver = True
                ReDim Preserve oPalletes(cMaxPalettes)
                Exit For
            End If
COL_CONTINUE:
        Next
        If wPaletteOver Then Exit For
ROW_CONTINUE:
    Next
    GetGridColors = wPaletteOver

End Function

Private Function GetGridCellBackColor(ByRef iGrid As VSFlexGrid, ByVal iRow As Long, ByVal iCol As Long) As Long
'////////////////////////////////////////////////////////////////////////
'Name       :GetGridCellBackColor
'Explanation:グリッドのセルに設定されている背景色を取得
'Arguments  :iGrid              I   対象グリッド
'           :iRow               I   対象行
'           :iCol               I   対象列
'Return     :Long型
'////////////////////////////////////////////////////////////////////////
Dim wColor                      As Long

    '********************************************************************
    '   固定セル等を考慮して実際の背景色を取得
    '********************************************************************
    With iGrid
        wColor = .Cell(flexcpBackColor, iRow, iCol)
        If wColor = 0 Then
            wColor = .BackColor
            If (iRow < .FixedRows Or iCol < .FixedCols) Then
                wColor = .BackColorFixed            '固定セル
            ElseIf .BackColorFrozen <> 0 And (iRow < .FixedRows + .FrozenRows Or iCol < .FixedCols + .FrozenCols) Then
                wColor = .BackColorFrozen           '静止セル
            ElseIf .BackColorAlternate <> .BackColor And ((iRow - .FixedRows) Mod 2 <> 0) Then
                wColor = .BackColorAlternate        '1行おきの背景色
            End If
        End If
    End With
    GetGridCellBackColor = ConvertSystemColor(wColor)

End Function

Private Function GetGridCellForeColor(ByRef iGrid As VSFlexGrid, ByVal iRow As Long, ByVal iCol As Long) As Long
'////////////////////////////////////////////////////////////////////////
'Name       :GetGridCellForeColor
'Explanation:グリッドのセルに設定されている前景色を取得
'Arguments  :iGrid              I   対象グリッド
'           :iRow               I   対象行
'           :iCol               I   対象列
'Return     :Long型
'////////////////////////////////////////////////////////////////////////
Dim wColor                      As Long

    '********************************************************************
    '   固定セル等を考慮して実際の前景色を取得
    '********************************************************************
    With iGrid
        wColor = .Cell(flexcpForeColor, iRow, iCol)
        If wColor = 0 Then
            wColor = .ForeColor
            If (iRow < .FixedRows Or iCol < .FixedCols) Then
                wColor = .ForeColorFixed            '固定セル
            ElseIf .ForeColorFrozen <> 0 And (iRow < .FixedRows + .FrozenRows Or iCol < .FixedCols + .FrozenCols) Then
                wColor = .ForeColorFrozen           '静止セル
            End If
        End If
    End With
    GetGridCellForeColor = ConvertSystemColor(wColor)
    
End Function

Private Function ConvertSystemColor(ByVal iColor As Long) As Long
'////////////////////////////////////////////////////////////////////////
'Name       :ConvertSystemColor
'Explanation:VBのシステムカラーコードからRGB値を返す
'Arguments  :iColor             I   対象カラーコード
'Return     :Long型
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   変換
    '********************************************************************
    If iColor < 0 And &H80000000 <= iColor Then
        iColor = iColor Xor &H80000000
        iColor = GetSysColor(iColor)
    End If
    ConvertSystemColor = iColor
    
End Function

Private Sub SetNumberFormat(ByRef iGrid As VSFlexGrid, ByVal iRow As Long, ByVal iCol As Long, ByVal iRowRange As Long, ByVal iColRange As Long, ByVal iCols As Long)
'////////////////////////////////////////////////////////////////////////
'Name       :SetNumberForat
'Explanation:グリッドを走査して同じ表示形式のまとまりを一括反映
'Arguments  :iGrid              I   対象グリッド
'           :iRow               I   走査開始行
'           :iCol               I   走査開始列
'           :iRowRange          I   走査終了行
'           :iColRange          I   走査終了列
'           :iCols              I   Excel出力列数
'////////////////////////////////////////////////////////////////////////
Dim wNumberFormat               As String
Dim wCellIndex                  As Long
Dim wRow                        As Long
Dim wExRow                      As Long
Dim wRows                       As Long
Dim wCol                        As Long
Dim wExCol                      As Long
Dim wCols                       As Long
Dim wRange                      As tRange

    '********************************************************************
    '   同じ表示形式を走査
    '********************************************************************
    wExRow = m_ExRow
    wExCol = m_ExCol
    With iGrid
        wNumberFormat = iGrid.ColFormat(iCol)
        '================================================================
        '   行を下に走査(全行同じはずなので反映済み管理配列のみ操作)
        '================================================================
        For wRow = iRow To iRowRange
            If .RowHidden(wRow) Then GoTo ROW_CONTINUE
            wRows = wRows + 1
            wCellIndex = GetCellIndex(wExRow - m_ExBaseRow, m_ExCol - m_ExBaseCol, iCols)
            m_Reflections(wCellIndex) = m_Reflections(wCellIndex) Or RefNumberFormat
            wExRow = wExRow + 1
            If cMaxRows < wExRow Then Exit For
ROW_CONTINUE:
        Next
        '================================================================
        '   列を右に走査
        '================================================================
        For wCol = iCol To iColRange
            If .ColHidden(wCol) Then GoTo COL_CONTINUE
            If wNumberFormat <> .ColFormat(wCol) Then Exit For
            wCols = wCols + 1
            wCellIndex = GetCellIndex(m_ExRow - m_ExBaseRow, wExCol - m_ExBaseCol, iCols)
            m_Reflections(wCellIndex) = m_Reflections(wCellIndex) Or RefNumberFormat
            wExCol = wExCol + 1
            If cMaxCols < wExCol Then Exit For
COL_CONTINUE:
        Next
    End With
    
    '********************************************************************
    '   Excelに反映
    '********************************************************************
    If wNumberFormat = "" Then wNumberFormat = "@"  'デフォルトは文字列形式
    wRange = GetValidRange(m_ExRow, m_ExCol, wRows, wCols)
    With m_ExSheet.Cells(m_ExRow, m_ExCol)
        '====   行のまとまり
        .Resize(wRange.Rows, 1).NumberFormat = wNumberFormat
        '====   列のまとまり
        .Resize(1, wRange.Cols).NumberFormat = wNumberFormat
    End With
    
End Sub

Private Sub SetAlignment(ByRef iGrid As VSFlexGrid, ByVal iRow As Long, ByVal iCol As Long, ByVal iRowRange As Long, ByVal iColRange As Long, ByVal iCols As Long)
'////////////////////////////////////////////////////////////////////////
'Name       :SetAlignment
'Explanation:グリッドを走査して同じ文字配置のまとまりを一括反映
'Arguments  :iGrid              I   対象グリッド
'           :iRow               I   走査開始行
'           :iCol               I   走査開始列
'           :iRowRange          I   走査終了行
'           :iColRange          I   走査終了列
'           :iCols              I   Excel出力列数
'////////////////////////////////////////////////////////////////////////
Dim wAlignment                  As AlignmentSettings
Dim wCellIndex                  As Long
Dim wRow                        As Long
Dim wExRow                      As Long
Dim wRows                       As Long
Dim wCol                        As Long
Dim wExCol                      As Long
Dim wCols                       As Long
Dim wRange                      As tRange
Dim wExAlign                    As tAlignment

    '********************************************************************
    '   同じ文字配置を走査
    '********************************************************************
    wExRow = m_ExRow
    wExCol = m_ExCol
    With iGrid
        wAlignment = GetGridCellAlignment(iGrid, iRow, iCol)
        '================================================================
        '   行を下に走査
        '================================================================
        For wRow = iRow To iRowRange
            If .RowHidden(wRow) Then GoTo ROW_CONTINUE
            If wAlignment <> GetGridCellAlignment(iGrid, wRow, iCol) Then Exit For
            wRows = wRows + 1
            wCellIndex = GetCellIndex(wExRow - m_ExBaseRow, m_ExCol - m_ExBaseCol, iCols)
            m_Reflections(wCellIndex) = m_Reflections(wCellIndex) Or RefAlignment
            wExRow = wExRow + 1
            If cMaxRows < wExRow Then Exit For
ROW_CONTINUE:
        Next
        '================================================================
        '   列を右に走査
        '================================================================
        For wCol = iCol To iColRange
            If .ColHidden(wCol) Then GoTo COL_CONTINUE
            If wAlignment <> GetGridCellAlignment(iGrid, iRow, wCol) Then Exit For
            wCols = wCols + 1
            wCellIndex = GetCellIndex(m_ExRow - m_ExBaseRow, wExCol - m_ExBaseCol, iCols)
            m_Reflections(wCellIndex) = m_Reflections(wCellIndex) Or RefAlignment
            wExCol = wExCol + 1
            If cMaxCols < wExCol Then Exit For
COL_CONTINUE:
        Next
    End With
    
    '********************************************************************
    '   Excelに反映
    '********************************************************************
    wExAlign = ConvertAlignment(wAlignment)     'Excel文字配置定数変換
    wRange = GetValidRange(m_ExRow, m_ExCol, wRows, wCols)
    '====   行のまとまり
    With m_ExSheet.Cells(m_ExRow, m_ExCol).Resize(wRange.Rows, 1)
        .HorizontalAlignment = wExAlign.HAlign
        .VerticalAlignment = wExAlign.VAlign
    End With
    '====   列のまとまり
    With m_ExSheet.Cells(m_ExRow, m_ExCol).Resize(1, wRange.Cols)
        .HorizontalAlignment = wExAlign.HAlign
        .VerticalAlignment = wExAlign.VAlign
    End With
    
End Sub

Private Sub SetFont(ByRef iGrid As VSFlexGrid, ByVal iRow As Long, ByVal iCol As Long, ByVal iRowRange As Long, ByVal iColRange As Long, ByVal iCols As Long)
'////////////////////////////////////////////////////////////////////////
'Name       :SetFont
'Explanation:グリッドを走査して同じフォントのまとまりを一括反映
'Arguments  :iGrid              I   対象グリッド
'           :iRow               I   走査開始行
'           :iCol               I   走査開始列
'           :iRowRange          I   走査終了行
'           :iColRange          I   走査終了列
'           :iCols              I   Excel出力列数
'////////////////////////////////////////////////////////////////////////
Dim wFont                       As tFont
Dim wScanFont                   As tFont
Dim wCellIndex                  As Long
Dim wRow                        As Long
Dim wExRow                      As Long
Dim wRows                       As Long
Dim wCol                        As Long
Dim wExCol                      As Long
Dim wCols                       As Long
Dim wRange                      As tRange

    '********************************************************************
    '   同じフォントを走査
    '********************************************************************
    wExRow = m_ExRow
    wExCol = m_ExCol
    With iGrid
        wFont = GetGridCellFont(iGrid, iRow, iCol)
        '================================================================
        '   行を下に走査
        '================================================================
        For wRow = iRow To iRowRange
            If .RowHidden(wRow) Then GoTo ROW_CONTINUE
            wScanFont = GetGridCellFont(iGrid, wRow, iCol)
            If wFont.FName <> wScanFont.FName _
               Or wFont.Size <> wScanFont.Size _
               Or wFont.Italic <> wScanFont.Italic _
               Or wFont.Bold <> wScanFont.Bold _
               Or wFont.Underline <> wScanFont.Underline _
               Or wFont.Strikethrough <> wScanFont.Strikethrough Then Exit For
            wRows = wRows + 1
            wCellIndex = GetCellIndex(wExRow - m_ExBaseRow, m_ExCol - m_ExBaseCol, iCols)
            m_Reflections(wCellIndex) = m_Reflections(wCellIndex) Or RefFont
            wExRow = wExRow + 1
            If cMaxRows < wExRow Then Exit For
ROW_CONTINUE:
        Next
        '================================================================
        '   列を右に走査
        '================================================================
        For wCol = iCol To iColRange
            If .ColHidden(wCol) Then GoTo COL_CONTINUE
            wScanFont = GetGridCellFont(iGrid, iRow, wCol)
            If wFont.FName <> wScanFont.FName _
               Or wFont.Size <> wScanFont.Size _
               Or wFont.Italic <> wScanFont.Italic _
               Or wFont.Bold <> wScanFont.Bold _
               Or wFont.Underline <> wScanFont.Underline _
               Or wFont.Strikethrough <> wScanFont.Strikethrough Then Exit For
            wCols = wCols + 1
            wCellIndex = GetCellIndex(m_ExRow - m_ExBaseRow, wExCol - m_ExBaseCol, iCols)
            m_Reflections(wCellIndex) = m_Reflections(wCellIndex) Or RefFont
            wExCol = wExCol + 1
            If cMaxCols < wExCol Then Exit For
COL_CONTINUE:
        Next
    End With
    
    '********************************************************************
    '   Excelに反映
    '********************************************************************
    wRange = GetValidRange(m_ExRow, m_ExCol, wRows, wCols)
    '====   行のまとまり
    With m_ExSheet.Cells(m_ExRow, m_ExCol).Resize(wRange.Rows, 1).Font
        .Name = wFont.FName
        .Size = wFont.Size
        .Italic = wFont.Italic
        .Bold = wFont.Bold
        .Underline = wFont.Underline
        .Strikethrough = wFont.Strikethrough
    End With
    '====   列のまとまり
    With m_ExSheet.Cells(m_ExRow, m_ExCol).Resize(1, wRange.Cols).Font
        .Name = wFont.FName
        .Size = wFont.Size
        .Italic = wFont.Italic
        .Bold = wFont.Bold
        .Underline = wFont.Underline
        .Strikethrough = wFont.Strikethrough
    End With
    
End Sub

Private Sub SetBackColor(ByRef iGrid As VSFlexGrid, ByVal iRow As Long, ByVal iCol As Long, ByVal iRowRange As Long, ByVal iColRange As Long, ByVal iCols As Long)
'////////////////////////////////////////////////////////////////////////
'Name       :SetBackColor
'Explanation:グリッドを走査して同じ背景色のまとまりを一括反映
'Arguments  :iGrid              I   対象グリッド
'           :iRow               I   走査開始行
'           :iCol               I   走査開始列
'           :iRowRange          I   走査終了行
'           :iColRange          I   走査終了列
'           :iCols              I   Excel出力列数
'////////////////////////////////////////////////////////////////////////
Dim wBackColor                  As Long
Dim wCellIndex                  As Long
Dim wRow                        As Long
Dim wExRow                      As Long
Dim wRows                       As Long
Dim wCol                        As Long
Dim wExCol                      As Long
Dim wCols                       As Long
Dim wRange                      As tRange

    '********************************************************************
    '   同じ背景色を走査
    '********************************************************************
    wExRow = m_ExRow
    wExCol = m_ExCol
    With iGrid
        wBackColor = GetGridCellBackColor(iGrid, iRow, iCol)
        '================================================================
        '   行を下に走査
        '================================================================
        For wRow = iRow To iRowRange
            If .RowHidden(wRow) Then GoTo ROW_CONTINUE
            If wBackColor <> GetGridCellBackColor(iGrid, wRow, iCol) Then Exit For
            wRows = wRows + 1
            wCellIndex = GetCellIndex(wExRow - m_ExBaseRow, m_ExCol - m_ExBaseCol, iCols)
            m_Reflections(wCellIndex) = m_Reflections(wCellIndex) Or RefBackColor
            wExRow = wExRow + 1
            If cMaxRows < wExRow Then Exit For
ROW_CONTINUE:
        Next
        '================================================================
        '   列を右に走査
        '================================================================
        For wCol = iCol To iColRange
            If .ColHidden(wCol) Then GoTo COL_CONTINUE
            If wBackColor <> GetGridCellBackColor(iGrid, iRow, wCol) Then Exit For
            wCols = wCols + 1
            wCellIndex = GetCellIndex(m_ExRow - m_ExBaseRow, wExCol - m_ExBaseCol, iCols)
            m_Reflections(wCellIndex) = m_Reflections(wCellIndex) Or RefBackColor
            wExCol = wExCol + 1
            If cMaxCols < wExCol Then Exit For
COL_CONTINUE:
        Next
    End With
    
    '********************************************************************
    '   Excelに反映
    '********************************************************************
    wRange = GetValidRange(m_ExRow, m_ExCol, wRows, wCols)
    With m_ExSheet.Cells(m_ExRow, m_ExCol)
        '====   行のまとまり
        .Resize(wRange.Rows, 1).Interior.Color = wBackColor
        '====   列のまとまり
        .Resize(1, wRange.Cols).Interior.Color = wBackColor
    End With
    
End Sub

Private Sub SetForeColor(ByRef iGrid As VSFlexGrid, ByVal iRow As Long, ByVal iCol As Long, ByVal iRowRange As Long, ByVal iColRange As Long, ByVal iCols As Long)
'////////////////////////////////////////////////////////////////////////
'Name       :SetForeColor
'Explanation:グリッドを走査して同じ前景色のまとまりを一括反映
'Arguments  :iGrid              I   対象グリッド
'           :iRow               I   走査開始行
'           :iCol               I   走査開始列
'           :iRowRange          I   走査終了行
'           :iColRange          I   走査終了列
'           :iCols              I   Excel出力列数
'////////////////////////////////////////////////////////////////////////
Dim wForeColor                  As Long
Dim wCellIndex                  As Long
Dim wRow                        As Long
Dim wExRow                      As Long
Dim wRows                       As Long
Dim wCol                        As Long
Dim wExCol                      As Long
Dim wCols                       As Long
Dim wRange                      As tRange

    '********************************************************************
    '   同じ前景色を走査
    '********************************************************************
    wExRow = m_ExRow
    wExCol = m_ExCol
    With iGrid
        wForeColor = GetGridCellForeColor(iGrid, iRow, iCol)
        '================================================================
        '   行を下に走査
        '================================================================
        For wRow = iRow To iRowRange
            If .RowHidden(wRow) Then GoTo ROW_CONTINUE
            If wForeColor <> GetGridCellForeColor(iGrid, wRow, iCol) Then Exit For
            wRows = wRows + 1
            wCellIndex = GetCellIndex(wExRow - m_ExBaseRow, m_ExCol - m_ExBaseCol, iCols)
            m_Reflections(wCellIndex) = m_Reflections(wCellIndex) Or RefForeColor
            wExRow = wExRow + 1
            If cMaxRows < wExRow Then Exit For
ROW_CONTINUE:
        Next
        '================================================================
        '   列を右に走査
        '================================================================
        For wCol = iCol To iColRange
            If .ColHidden(wCol) Then GoTo COL_CONTINUE
            If wForeColor <> GetGridCellForeColor(iGrid, iRow, wCol) Then Exit For
            wCols = wCols + 1
            wCellIndex = GetCellIndex(m_ExRow - m_ExBaseRow, wExCol - m_ExBaseCol, iCols)
            m_Reflections(wCellIndex) = m_Reflections(wCellIndex) Or RefForeColor
            wExCol = wExCol + 1
            If cMaxCols < wExCol Then Exit For
COL_CONTINUE:
        Next
    End With
    
    '********************************************************************
    '   Excelに反映
    '********************************************************************
    wRange = GetValidRange(m_ExRow, m_ExCol, wRows, wCols)
    With m_ExSheet.Cells(m_ExRow, m_ExCol)
        '====   行のまとまり
        .Resize(wRange.Rows, 1).Font.Color = wForeColor
        '====   列のまとまり
        .Resize(1, wRange.Cols).Font.Color = wForeColor
    End With
    
End Sub

Private Function GetGridCellAlignment(ByRef iGrid As VSFlexGrid, ByVal iRow As Long, ByVal iCol As Long) As AlignmentSettings
'////////////////////////////////////////////////////////////////////////
'Name       :GetGridCellAlignment
'Explanation:グリッドのセルに設定されている文字配置情報を取得
'Arguments  :iGrid              I   対象グリッド
'           :iRow               I   対象行
'           :iCol               I   対象列
'Return     :AlignmentSettings型
'////////////////////////////////////////////////////////////////////////
Dim wAlignment                  As AlignmentSettings

    '********************************************************************
    '   文字配置情報取得
    '********************************************************************
    With iGrid
        wAlignment = flexAlignGeneral
        If .Cell(flexcpAlignment, iRow, iCol) <> flexAlignGeneral Then
            wAlignment = .Cell(flexcpAlignment, iRow, iCol)
        ElseIf .ColAlignment(iCol) <> flexAlignGeneral Then
            wAlignment = .ColAlignment(iCol)
        End If
    End With
    GetGridCellAlignment = wAlignment

End Function

Private Function ConvertAlignment(ByVal iGridAlignment As AlignmentSettings) As tAlignment
'////////////////////////////////////////////////////////////////////////
'Name       :ConvertAlignment
'Explanation:グリッドの文字配置定数からExcelの文字配置定数に変換する
'Arguments  :iGridAlignment     I   グリッド文字配置定数
'Return     :tAlignment型
'////////////////////////////////////////////////////////////////////////
Dim wAlignment                  As tAlignment

    '********************************************************************
    '   変換
    '********************************************************************
    With wAlignment
        Select Case iGridAlignment
        Case flexAlignLeftTop
            .HAlign = xlHAlignLeft
            .VAlign = xlVAlignTop
        Case flexAlignLeftCenter
            .HAlign = xlHAlignLeft
            .VAlign = xlVAlignCenter
        Case flexAlignLeftBottom
            .HAlign = xlHAlignLeft
            .VAlign = xlVAlignBottom
        Case flexAlignCenterTop
            .HAlign = xlHAlignCenter
            .VAlign = xlVAlignTop
        Case flexAlignCenterCenter
            .HAlign = xlHAlignCenter
            .VAlign = xlVAlignCenter
        Case flexAlignCenterBottom
            .HAlign = xlHAlignCenter
            .VAlign = xlVAlignBottom
        Case flexAlignRightTop
            .HAlign = xlHAlignRight
            .VAlign = xlVAlignTop
        Case flexAlignRightCenter
            .HAlign = xlHAlignRight
            .VAlign = xlVAlignCenter
        Case flexAlignRightBottom
            .HAlign = xlHAlignRight
            .VAlign = xlVAlignBottom
        Case flexAlignGeneral
            .HAlign = xlHAlignGeneral
            .VAlign = xlVAlignCenter
        End Select
    End With
    ConvertAlignment = wAlignment
    
End Function

Private Function GetGridCellFont(ByRef iGrid As VSFlexGrid, ByVal iRow As Long, ByVal iCol As Long) As tFont
'////////////////////////////////////////////////////////////////////////
'Name       :GetGridCellFont
'Explanation:グリッドのセルに設定されているフォント情報を取得
'Arguments  :iGrid              I   対象グリッド
'           :iRow               I   対象行
'           :iCol               I   対象列
'Return     :tFont型
'////////////////////////////////////////////////////////////////////////
Dim wFont                       As tFont

    '********************************************************************
    '   フォント情報取得
    '********************************************************************
    With wFont
        .FName = iGrid.Cell(flexcpFontName, iRow, iCol)
        .Size = iGrid.Cell(flexcpFontSize, iRow, iCol)
        .Italic = iGrid.Cell(flexcpFontItalic, iRow, iCol)
        .Bold = iGrid.Cell(flexcpFontBold, iRow, iCol)
        .Underline = xlUnderlineStyleNone
        If iGrid.Cell(flexcpFontUnderline, iRow, iCol) Then .Underline = xlUnderlineStyleSingle
        .Strikethrough = iGrid.Cell(flexcpFontStrikethru, iRow, iCol)
    End With
    GetGridCellFont = wFont
    
End Function

Private Function GetGridMergedRange(ByRef iGrid As VSFlexGrid, ByVal iRow As Long, ByVal iCol As Long, ByRef oMergeRange As tMergeRange) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :GetGridMergedRange
'Explanation:グリッドのセル結合情報を取得
'Arguments  :iGrid              I   対象グリッド
'           :iRow               I   対象行
'           :iCol               I   対象列
'           :oMergeRange        O   結合セル情報
'Return     :Boolean型(False:結合されていない　True:結合されている)
'////////////////////////////////////////////////////////////////////////
Dim wMergeRange                 As tMergeRange
Dim wRow                        As Long
Dim wCol                        As Long
Dim wMergeRow1                  As Long
Dim wMergeCol1                  As Long
Dim wMergeRow2                  As Long
Dim wMergeCol2                  As Long

    oMergeRange = wMergeRange
    '********************************************************************
    '   結合情報取得
    '********************************************************************
    Call iGrid.GetMergedRange(iRow, iCol, wMergeRow1, wMergeCol1, wMergeRow2, wMergeCol2)
    If wMergeRow1 = wMergeRow2 And wMergeCol1 = wMergeCol2 Then Exit Function
    With iGrid
        '================================================================
        '   非表示行を除く結合行数取得
        '================================================================
        For wRow = wMergeRow1 To wMergeRow2
            If Not .RowHidden(wRow) Then
                oMergeRange.Rows = oMergeRange.Rows + 1
            End If
        Next
        '================================================================
        '   非表示列を除く結合列数取得
        '================================================================
        For wCol = wMergeCol1 To wMergeCol2
            If Not .ColHidden(wCol) Then
                oMergeRange.Cols = oMergeRange.Cols + 1
            End If
        Next
    End With
    GetGridMergedRange = (0 < oMergeRange.Rows Or 0 < oMergeRange.Cols)
    
End Function

Public Sub SetGridLinesFixed(ByVal iBordersIndex As eXlBordersIndex, _
                             Optional ByVal iLineStyle As eXlLineStyle = xlContinuous, _
                             Optional ByVal iWeight As eXlBorderWeight = xlThin)
'////////////////////////////////////////////////////////////////////////
'Name       :SetGridLinesFixed
'Explanation:簡易罫線設定時の固定セルの罫線情報をセットする
'Arguments  :iBordersIndex      I   対象罫線インデックス
'           :iLineStyle         I   罫線の種類
'           :iWeight            I   罫線の太さ
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   罫線情報セット
    '********************************************************************
    If iBordersIndex < LBound(m_GridLinesFixed) Or UBound(m_GridLinesFixed) < iBordersIndex Then Exit Sub
    With m_GridLinesFixed(iBordersIndex)
        .LineStyle = iLineStyle
        .Weight = iWeight
    End With
    
End Sub

Public Sub SetGridLinesFrozen(ByVal iBordersIndex As eXlBordersIndex, _
                              Optional ByVal iLineStyle As eXlLineStyle = xlContinuous, _
                              Optional ByVal iWeight As eXlBorderWeight = xlThin)
'////////////////////////////////////////////////////////////////////////
'Name       :SetGridLinesFrozen
'Explanation:簡易罫線設定時の静止セルの罫線情報をセットする
'Arguments  :iBordersIndex      I   対象罫線インデックス
'           :iLineStyle         I   罫線の種類
'           :iWeight            I   罫線の太さ
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   罫線情報セット
    '********************************************************************
    If iBordersIndex < LBound(m_GridLinesFrozen) Or UBound(m_GridLinesFrozen) < iBordersIndex Then Exit Sub
    With m_GridLinesFrozen(iBordersIndex)
        .LineStyle = iLineStyle
        .Weight = iWeight
    End With
    
End Sub

Public Sub SetGridLines(ByVal iBordersIndex As eXlBordersIndex, _
                        Optional ByVal iLineStyle As eXlLineStyle = xlContinuous, _
                        Optional ByVal iWeight As eXlBorderWeight = xlThin)
'////////////////////////////////////////////////////////////////////////
'Name       :SetGridLines
'Explanation:簡易罫線設定時の固定セル以外の罫線情報をセットする
'Arguments  :iBordersIndex      I   対象罫線インデックス
'           :iLineStyle         I   罫線の種類
'           :iWeight            I   罫線の太さ
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   罫線情報セット
    '********************************************************************
    If iBordersIndex < LBound(m_GridLines) Or UBound(m_GridLines) < iBordersIndex Then Exit Sub
    With m_GridLines(iBordersIndex)
        .LineStyle = iLineStyle
        .Weight = iWeight
    End With
    
End Sub

Private Sub BinaryTreeInit(ByRef oBinaryTree() As tBinaryTreeNode, ByVal iRootKey As Long)
'////////////////////////////////////////////////////////////////////////
'Name       :BinaryTreeInit
'Explanation:２分探索木の初期化
'Arguments  :oBinaryTree        O   ２分探索木ノード配列
'           :iRootKey           I   ルートへの設定値
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   初期化
    '********************************************************************
    Erase oBinaryTree
    ReDim oBinaryTree(0)
    With oBinaryTree(0)
        .LIndex = -1
        .RIndex = -1
        .Key = iRootKey
    End With
    
End Sub

Private Sub BinaryTreeAddKey(ByRef oBinaryTree() As tBinaryTreeNode, ByVal iAddKey As Long)
'////////////////////////////////////////////////////////////////////////
'Name       :BinaryTreeAddKey
'Explanation:２分探索木にキーを追加
'Arguments  :oBinaryTree        O   ２分探索木ノード配列
'           :iAddKey            I   追加キー
'////////////////////////////////////////////////////////////////////////
Dim wIndex                      As Long
Dim wAddLeft                    As Boolean
Dim wLastIndex                  As Long

    '********************************************************************
    '   検索
    '********************************************************************
    Do While 0 <= wIndex
        Select Case oBinaryTree(wIndex).Key
        Case Is > iAddKey
            '====   追加キーの方が小さい
            If oBinaryTree(wIndex).LIndex < 0 Then
                wAddLeft = True
                Exit Do
            End If
            wIndex = oBinaryTree(wIndex).LIndex
        Case Is < iAddKey
            '====   追加キーの方が大きい
            If oBinaryTree(wIndex).RIndex < 0 Then
                wAddLeft = False
                Exit Do
            End If
            wIndex = oBinaryTree(wIndex).RIndex
        Case iAddKey
            '====   既にノード上に存在する
            Exit Sub
        End Select
    Loop
    
    '********************************************************************
    '   末端ノードの更新＆キー追加
    '********************************************************************
    wLastIndex = UBound(oBinaryTree)
    With oBinaryTree(wIndex)
        If wAddLeft Then
            .LIndex = wLastIndex + 1
        Else
            .RIndex = wLastIndex + 1
        End If
    End With
    ReDim Preserve oBinaryTree(wLastIndex + 1)
    With oBinaryTree(wLastIndex + 1)
        .LIndex = -1
        .RIndex = -1
        .Key = iAddKey
    End With

End Sub

