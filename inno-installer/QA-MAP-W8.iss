; -- Example2.iss --
; Same as Example1.iss, but creates its icon in the Programs folder of the
; Start Menu instead of in a subfolder, and also creates a desktop icon.

; SEE THE DOCUMENTATION FOR DETAILS ON CREATING .ISS SCRIPT FILES!

[Setup]
AppName=QA-MAP
AppVersion=MAP 2.0 
DefaultDirName=C:\QAMAP
; Since no icons will be created in "{group}", we don't need the wizard
; to ask for a Start Menu folder name:
DisableProgramGroupPage=yes
UninstallDisplayIcon={app}\eclipse-juno\eclipse\eclipse.exe
OutputDir=r:\Automation\MAP-Distribution\MAP-QA-JUNO-INSTALLER-W8

[Files]
; both eclipse and perl will be pulled from this folder
Source: "C:\QAMAP\*.*"; DestDir: "{app}"; Flags: recursesubdirs

; the qa-map eclipse workspace
;Source: "d:\map-qa-install\*.*"; DestDir: "{app}"; Flags: recursesubdirs

[Icons]
Name: "{commondesktop}\MAP-Eclipse"; Filename: "{app}\eclipse-juno\eclipse\eclipse.exe"
