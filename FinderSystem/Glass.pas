// Aero Glass Effekt fur Delphi-Forms 
// 
// Mit der Methode GlassForm kann fur eine Form der 
// Aero Glass Effekt unter Vista aktiviert werden. 
// Der erste Parameter ist die Form-Klasse, der zweite 
// optionale Parameter ist der BlurColorKey. Mit dem 
// BlurColorKey wird eine Farbe festgelegt, auf dem 
// der Effekt wirken soll, d.h. benutzt eine Komponente,
// auf der Form, fur visuelle Darstellungen (Linien, Punkte, 
// Bilder, ...), diese Farbe, so wird an dieser Stelle der 
// Effekt wirksam. Der Standardwert fur BlurColorKey ist 
// clFuchsia. 
// 
// Hinweis: Fur die Aktivierung wird zusatzlich TXPManifest 
//          bzw. eine RES-Datei die die Manifest-Daten 
//          enthalt benotigt. 
// 
// 
// Delphi-Unit von Daniel Mitte (2006) 
// 
// 
// Beispiel: 
// 
// uses glass; 
// 
// [...] 
// 
// procedure TForm1.FormActivate(Sender: TObject); 
// begin 
//   GlassForm(Form1); 
//   // oder mit anderem BlurColorKey 
//   // GlassForm(Form1, clBlue) 
// end; 

unit Glass;

interface 

uses 
  Windows, 
  Forms, 
  Graphics; 
  
  procedure GlassForm(frm: TForm; cBlurColorKey: TColor = clFuchsia);

implementation

procedure GlassForm(frm: TForm; cBlurColorKey: TColor = clFuchsia);
const
  WS_EX_LAYERED = $80000;
  LWA_COLORKEY = 1;
type
  _MARGINS = packed record
    cxLeftWidth: Integer;
    cxRightWidth: Integer;
    cyTopHeight: Integer;
    cyBottomHeight: Integer;
  end;

  PMargins = ^_MARGINS;
  TMargins = _MARGINS;

  DwmIsCompositionEnabledFunc = function(pfEnabled: PBoolean): HRESULT; stdcall;
  DwmExtendFrameIntoClientAreaFunc = function(destWnd: HWND; const pMarInset: PMargins): HRESULT; stdcall;
  SetLayeredWindowAttributesFunc = function(destWnd: HWND; cKey: TColor; bAlpha: Byte; dwFlags: DWord): BOOL; stdcall;

var
  hDWMDLL: Cardinal;
  osVinfo: TOSVERSIONINFO;
  fDwmIsCompositionEnabled: DwmIsCompositionEnabledFunc;
  fDwmExtendFrameIntoClientArea: DwmExtendFrameIntoClientAreaFunc;
  fSetLayeredWindowAttributesFunc: SetLayeredWindowAttributesFunc;
  bCmpEnable: Boolean;
  mgn: TMargins;

begin
  ZeroMemory(@osVinfo, SizeOf(osVinfo));
  OsVinfo.dwOSVersionInfoSize := SizeOf(TOSVERSIONINFO);

  if ((GetVersionEx(osVInfo) = True) and (osVinfo.dwPlatformId = VER_PLATFORM_WIN32_NT) and (osVinfo.dwMajorVersion >= 6)) then begin
    hDWMDLL := LoadLibrary('dwmapi.dll');

    if hDWMDLL <> 0 then begin
      @fDwmIsCompositionEnabled := GetProcAddress(hDWMDLL, 'DwmIsCompositionEnabled');
      @fDwmExtendFrameIntoClientArea := GetProcAddress(hDWMDLL, 'DwmExtendFrameIntoClientArea');
      @fSetLayeredWindowAttributesFunc := GetProcAddress(GetModulehandle(user32), 'SetLayeredWindowAttributes');

      if ((@fDwmIsCompositionEnabled <> nil) and (@fDwmExtendFrameIntoClientArea <> nil) and (@fSetLayeredWindowAttributesFunc <> nil)) then begin
        fDwmIsCompositionEnabled(@bCmpEnable);

        if bCmpEnable = True then begin
          frm.Color := cBlurColorKey;

          SetWindowLong(frm.Handle, GWL_EXSTYLE, GetWindowLong(frm.Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
          fSetLayeredWindowAttributesFunc(frm.Handle, cBlurColorKey, 0, LWA_COLORKEY);

          ZeroMemory(@mgn, SizeOf(mgn));
          mgn.cxLeftWidth := -1;
          mgn.cxRightWidth := -1;
          mgn.cyTopHeight := -1;
          mgn.cyBottomHeight := -1;

          fDwmExtendFrameIntoClientArea(frm.Handle, @mgn);
        end;
      end;

      FreeLibrary(hDWMDLL);
    end;
  end;
end;

end.