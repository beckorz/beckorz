VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "C_Finder"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'////////////////////////////////////////////////////////////////////////
'PictureBoxをSPY++のウィンドウファインダーツールのように動作させるクラス
'　対象PictureBox側にあらかじめMouseIconプロパティでドラッグ時の画像を指定しておくか、
'　ImageList等からMouseIconプロパティをセットします。
'   C_Finder
'       2007/04/20 DATACOM うっちー
'
'公開プロパティ
'InvertWidth                X   強調枠幅を取得または設定します。(デフォルト：2)
'TargetPictureBox           X   対象PictureBoxを取得または設定します。
'MouseIcon                  X   ドラッグ中のマウスアイコンを取得または設定します。(デフォルト：TargetPictureBoxのMouseIcon)
'DragPicture                X   ドラッグ中のPictureBox画像を取得または設定します。(デフォルト：TargetPictureBoxのPicture)
'BasePicture                X   通常のPictureBox画像を取得または設定します。(デフォルト：TargetPictureBoxのPicture)
'
'イベント
'OnWindow                   ドラッグ操作でカーソルの下にウィンドウが見つかるたびに発生します。
'////////////////////////////////////////////////////////////////////////

'////////////////////////////////////////////////////////////////////////
'   Win32API関数宣言
'////////////////////////////////////////////////////////////////////////
Private Declare Function SetCapture Lib "user32" _
    (ByVal hWnd As Long) As Long
Private Declare Function GetCapture Lib "user32" _
    () As Long
Private Declare Function ClientToScreen Lib "user32" _
    (ByVal hWnd As Long, _
    lpPoint As POINTAPI) As Long
Private Declare Function ScreenToClient Lib "user32" _
    (ByVal hWnd As Long, _
    lpPoint As POINTAPI) As Long
Private Declare Function WindowFromPoint Lib "user32" _
    (ByVal xPoint As Long, _
    ByVal yPoint As Long) As Long
Private Declare Function ChildWindowFromPoint Lib "user32" _
    (ByVal hWnd As Long, _
    ByVal xPoint As Long, _
    ByVal yPoint As Long) As Long
Private Declare Function GetClassName Lib "user32" Alias "GetClassNameA" _
    (ByVal hWnd As Long, _
    ByVal lpClassName As String, _
    ByVal nMaxCount As Long) As Long
Private Declare Function IsWindowVisible Lib "user32" _
    (ByVal hWnd As Long) As Long
Private Declare Function IsWindowEnabled Lib "user32" _
    (ByVal hWnd As Long) As Long
Private Declare Function GetWindowText Lib "user32" Alias "GetWindowTextA" _
    (ByVal hWnd As Long, _
    ByVal lpString As String, _
    ByVal cch As Long) As Long
Private Declare Function GetWindowLong Lib "user32" Alias "GetWindowLongA" _
    (ByVal hWnd As Long, _
    ByVal nIndex As Long) As Long
Private Declare Function IsWindow Lib "user32" _
    (ByVal hWnd As Long) As Long
Private Declare Function ReleaseCapture Lib "user32" _
    () As Long
Private Declare Function GetWindowDC Lib "user32" _
    (ByVal hWnd As Long) As Long
Private Declare Function GetWindowRect Lib "user32" _
    (ByVal hWnd As Long, _
    lpRect As RECT) As Long
Private Declare Function OffsetRect Lib "user32" _
    (lpRect As RECT, _
    ByVal x As Long, _
    ByVal y As Long) As Long
Private Declare Function IsRectEmpty Lib "user32" _
    (lpRect As RECT) As Long
Private Declare Function PatBlt Lib "gdi32" _
    (ByVal hDC As Long, _
    ByVal x As Long, _
    ByVal y As Long, _
    ByVal nWidth As Long, _
    ByVal nHeight As Long, _
    ByVal dwRop As Long) As Long
Private Declare Function ReleaseDC Lib "user32" _
    (ByVal hWnd As Long, _
    ByVal hDC As Long) As Long

'////////////////////////////////////////////////////////////////////////
'   定数宣言
'////////////////////////////////////////////////////////////////////////
Private Const GWL_STYLE = (-16)
Private Const GWL_EXSTYLE = (-20)

Private Const DSTINVERT As Long = &H550009

'////////////////////////////////////////////////////////////////////////
'   構造体宣言
'////////////////////////////////////////////////////////////////////////
Private Type POINTAPI
    x As Long
    y As Long
End Type
Private Type RECT
    Left As Long
    Top As Long
    Right As Long
    Bottom As Long
End Type

'////////////////////////////////////////////////////////////////////////
'   メンバ変数宣言
'////////////////////////////////////////////////////////////////////////
Private m_InvertWidth As Long                   '強調枠幅
Private WithEvents m_PictureBox As PictureBox   '対象PictureBox
Attribute m_PictureBox.VB_VarHelpID = -1
Private m_MouseIcon As IPictureDisp             'ドラッグ中のマウスアイコン
Private m_DragPicture As IPictureDisp           'ドラッグ中のPictureBox画像
Private m_BasePicture As IPictureDisp           '通常のPictureBox画像
Private m_TargetHwnd As Long
Private m_PrevHwnd As Long
Private m_IsDragStart As Boolean

'////////////////////////////////////////////////////////////////////////
'   イベント宣言
'////////////////////////////////////////////////////////////////////////
Public Event OnWindow(ByVal hWnd As Long, ByVal ClassName As String, ByVal Caption As String, ByVal Visible As Boolean, ByVal Enabled As Boolean, ByVal Style As Long, ByVal ExStyle As Long)

'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
'
'   プロパティ
'
'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
Public Property Get InvertWidth() As Long
    InvertWidth = m_InvertWidth
End Property
Public Property Let InvertWidth(ByVal Value As Long)
    m_InvertWidth = Value
End Property

Public Property Get TargetPictureBox() As PictureBox
    TargetPictureBox = m_PictureBox
End Property
Public Property Set TargetPictureBox(ByVal obj As PictureBox)
    Set m_PictureBox = obj
    If Not obj Is Nothing Then
        Set m_MouseIcon = obj.MouseIcon
        Set m_DragPicture = obj.Picture
        Set m_BasePicture = obj.Picture
    End If
End Property

Public Property Get MouseIcon() As IPictureDisp
    MouseIcon = m_MouseIcon
End Property
Public Property Set MouseIcon(ByVal obj As IPictureDisp)
    Set m_MouseIcon = obj
End Property

Public Property Get DragPicture() As IPictureDisp
    DragPicture = m_DragPicture
End Property
Public Property Set DragPicture(ByVal obj As IPictureDisp)
    Set m_DragPicture = obj
End Property

Public Property Get BasePicture() As IPictureDisp
    BasePicture = m_BasePicture
End Property
Public Property Set BasePicture(ByVal obj As IPictureDisp)
    Set m_BasePicture = obj
End Property

'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
'
'   イベントプロシージャ
'
'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
Private Sub Class_Initialize()
'////////////////////////////////////////////////////////////////////////
'Name       :Class_Initialize
'Explanation:コンストラクタ
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   初期化
    '********************************************************************
    m_InvertWidth = 2
    
End Sub

Private Sub Class_Terminate()
'////////////////////////////////////////////////////////////////////////
'Name       :Class_Terminate
'Explanation:デストラクタ
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   終了処理
    '********************************************************************
    Set m_PictureBox = Nothing
    
End Sub

Private Sub m_PictureBox_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
'////////////////////////////////////////////////////////////////////////
'Name       :m_PictureBox_MouseDown
'Explanation:MouseDownイベントプロシージャ
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   初期化
    '********************************************************************
    If m_IsDragStart Then Exit Sub
    m_TargetHwnd = 0
    m_PrevHwnd = 0

    '********************************************************************
    '   マウスキャプチャ開始
    '********************************************************************
    Call SetCapture(m_PictureBox.hWnd)
    
    '********************************************************************
    '   カーソル等変更
    '********************************************************************
    With m_PictureBox
        Set .MouseIcon = m_MouseIcon
        .MousePointer = vbCustom
        Set .Picture = m_DragPicture
    End With
    
End Sub

Private Sub m_PictureBox_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
'////////////////////////////////////////////////////////////////////////
'Name       :m_PictureBox_MouseMove
'Explanation:MouseMoveイベントプロシージャ
'////////////////////////////////////////////////////////////////////////
Dim wPoint                      As POINTAPI
Dim wHwnd                       As Long
Dim wClassName                  As String * 1024
Dim wCaption                    As String * 1024
Dim wVisible                    As Boolean
Dim wEnabled                    As Boolean
Dim wStyle                      As Long
Dim wExStyle                    As Long

    '********************************************************************
    '   キャプチャ済みチェック
    '********************************************************************
    If GetCapture() <> m_PictureBox.hWnd Then Exit Sub

    '********************************************************************
    '   対象ウィンドウハンドル取得
    '********************************************************************
    wPoint.x = x / Screen.TwipsPerPixelX
    wPoint.y = y / Screen.TwipsPerPixelY
    Call ClientToScreen(m_PictureBox.hWnd, wPoint)
    m_TargetHwnd = WindowFromPoint(wPoint.x, wPoint.y)
    If m_TargetHwnd <> 0 Then
        Call ScreenToClient(m_TargetHwnd, wPoint)
        wHwnd = ChildWindowFromPoint(m_TargetHwnd, wPoint.x, wPoint.y)
        If wHwnd <> 0 Then m_TargetHwnd = wHwnd
        '対象PictureBox自体なら親ウィンドウハンドルに差し替え
        If m_TargetHwnd = m_PictureBox.hWnd Then
            m_TargetHwnd = m_PictureBox.Parent.hWnd
        End If
    End If
    
    '********************************************************************
    '   強調枠描画＆対象ウィンドウ情報取得
    '********************************************************************
    If m_TargetHwnd <> m_PrevHwnd And m_TargetHwnd <> 0 Then
        '================================================================
        '   強調枠描画
        '================================================================
        Call DrawEmphasisLine(m_PrevHwnd)       '前回のウィンドウ枠を戻す
        Call DrawEmphasisLine(m_TargetHwnd)     '現在のウィンドウ枠を強調
        m_PrevHwnd = m_TargetHwnd
        m_IsDragStart = True
        '================================================================
        '   対象ウィンドウ情報取得
        '================================================================
        Call GetClassName(m_TargetHwnd, wClassName, 1024)
        wClassName = GetStrBeforeNULL(wClassName)
        Call GetWindowText(m_TargetHwnd, wCaption, 1024)
        wCaption = GetStrBeforeNULL(wCaption)
        wVisible = IsWindowVisible(m_TargetHwnd)
        wEnabled = IsWindowEnabled(m_TargetHwnd)
        wStyle = GetWindowLong(m_TargetHwnd, GWL_STYLE)
        wExStyle = GetWindowLong(m_TargetHwnd, GWL_EXSTYLE)
        RaiseEvent OnWindow(m_TargetHwnd, wClassName, wCaption, wVisible, wEnabled, wStyle, wExStyle)
    End If
    
End Sub

Private Sub m_PictureBox_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
'////////////////////////////////////////////////////////////////////////
'Name       :m_PictureBox_MouseUp
'Explanation:MouseUpイベントプロシージャ
'////////////////////////////////////////////////////////////////////////
Dim wPoint                      As POINTAPI
Dim wHwnd                       As Long
Dim wClassName                  As String * 1024
Dim wCaption                    As String * 1024
Dim wVisible                    As Boolean
Dim wEnabled                    As Boolean
Dim wStyle                      As Long
Dim wExStyle                    As Long

    '********************************************************************
    '   マウスキャプチャ終了
    '********************************************************************
    Call ReleaseCapture
    
    '********************************************************************
    '   カーソル等を戻す
    '********************************************************************
    With m_PictureBox
        .MousePointer = vbDefault
        Set .Picture = m_BasePicture
    End With

    '********************************************************************
    '   対象ウィンドウハンドル取得
    '********************************************************************
    wPoint.x = x / Screen.TwipsPerPixelX
    wPoint.y = y / Screen.TwipsPerPixelY
    Call ClientToScreen(m_PictureBox.hWnd, wPoint)
    m_TargetHwnd = WindowFromPoint(wPoint.x, wPoint.y)
    If m_TargetHwnd <> 0 Then
        Call ScreenToClient(m_TargetHwnd, wPoint)
        wHwnd = ChildWindowFromPoint(m_TargetHwnd, wPoint.x, wPoint.y)
        If wHwnd <> 0 Then m_TargetHwnd = wHwnd
        '対象PictureBox自体なら親ウィンドウハンドルに差し替え
        If m_TargetHwnd = m_PictureBox.hWnd Then
            m_TargetHwnd = m_PictureBox.Parent.hWnd
        End If
    End If
    
    '********************************************************************
    '   強調枠解除＆対象ウィンドウ情報取得
    '********************************************************************
    If m_IsDragStart Then
        Call DrawEmphasisLine(m_PrevHwnd)
        m_IsDragStart = False
    End If
    
    If m_TargetHwnd <> 0 Then
        Call GetClassName(m_TargetHwnd, wClassName, 1024)
        wClassName = GetStrBeforeNULL(wClassName)
        Call GetWindowText(m_TargetHwnd, wCaption, 1024)
        wCaption = GetStrBeforeNULL(wCaption)
        wVisible = IsWindowVisible(m_TargetHwnd)
        wEnabled = IsWindowEnabled(m_TargetHwnd)
        wStyle = GetWindowLong(m_TargetHwnd, GWL_STYLE)
        wExStyle = GetWindowLong(m_TargetHwnd, GWL_EXSTYLE)
        RaiseEvent OnWindow(m_TargetHwnd, wClassName, wCaption, wVisible, wEnabled, wStyle, wExStyle)
    End If
    
End Sub

Private Sub DrawEmphasisLine(ByVal hWnd As Long)
'////////////////////////////////////////////////////////////////////////
'Name       :DrawEmphasisLine
'Explanation:ウィンドウ枠の強調(反転)表示
'Arguments  :hWnd               I   対象ウィンドウハンドル
'////////////////////////////////////////////////////////////////////////
Dim hDC                         As Long
Dim wRect                       As RECT

    '********************************************************************
    '   対象ウィンドウチェック
    '********************************************************************
    If hWnd = 0 Then Exit Sub
    If IsWindow(hWnd) = 0 Then Exit Sub
    
    '********************************************************************
    '   強調枠描画
    '********************************************************************
    hDC = GetWindowDC(hWnd)
    Call GetWindowRect(hWnd, wRect)
    With wRect
        Call OffsetRect(wRect, -.Left, -.Top)
        If IsRectEmpty(wRect) = 0 Then
            Call PatBlt(hDC, .Left, .Top, .Right - .Left, m_InvertWidth, DSTINVERT)
            Call PatBlt(hDC, .Left, .Bottom - m_InvertWidth, m_InvertWidth, -(.Bottom - .Top - 2 * m_InvertWidth), DSTINVERT)
            Call PatBlt(hDC, .Right - m_InvertWidth, .Top + m_InvertWidth, m_InvertWidth, .Bottom - .Top - 2 * m_InvertWidth, DSTINVERT)
            Call PatBlt(hDC, .Right, .Bottom - m_InvertWidth, -(.Right - .Left), m_InvertWidth, DSTINVERT)
        End If
    End With
    Call ReleaseDC(hWnd, hDC)
    
End Sub

Private Function GetStrBeforeNULL(ByRef iString As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :GetStrBeforeNULL
'Explanation:NULL終端文字列のNULL手前までを返す
'Arguments  :iString            O   対象文字列
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wIndex                      As Long

    '********************************************************************
    '   結果を返す
    '********************************************************************
    wIndex = InStr(iString, vbNullChar)
    If wIndex <= 0 Then
        GetStrBeforeNULL = iString
    Else
        GetStrBeforeNULL = Left$(iString, wIndex - 1)
    End If
    
End Function

