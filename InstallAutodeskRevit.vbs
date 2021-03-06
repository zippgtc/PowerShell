 '*******************************************************************************  
 '     Program: Install.vbs  
 '      Author: Mick Pletcher  
 '        Date: 08 November 2010  
 '    Modified:  
 '  
 '     Program: Autodesk Revit  
 '     Version: 2012  
 ' Description: This will install Autodesk Revit Structural  
 '                 1) Define the relative installation path  
 '                 2) Create the Log Folder  
 '                 3) Install Current Version of Revit  
 '                 4) Install Workstation Monitor  
 '                 5) Cleanup Global Variables  
 '*******************************************************************************  
 Option Explicit

 REM Define Constants
 CONST TempFolder    = "c:\temp\"  
 CONST LogFolderName = "RevitStruct2012"  

 REM Define Global Variables  
 DIM LogFolder    : Set LogFolder    = Nothing  
 DIM RelativePath : Set RelativePath = Nothing  
 DIM ReturnCode   : ReturnCode       = "0"  

 REM Initialize Global Variables  
 LogFolder = TempFolder & LogFolderName & "\"  

 REM Define the relative installation path  
 DefineRelativePath()  
 REM Create the Log Folder  
 CreateLogFolder()  
 REM Install Current Version  
 InstallCurrentVersion()  
 REM Install Workshare Monitor  
 InstallWorkshareMonitor()  
 REM Cleanup Global Variables  
 GlobalVariableCleanup()  

 '*******************************************************************************  
 '*******************************************************************************  

 Sub DefineRelativePath()  

      REM Get File Name with full relative path  
      RelativePath = WScript.ScriptFullName  
      REM Remove file name, leaving relative path only  
      RelativePath = Left(RelativePath, InStrRev(RelativePath, "\"))  

 End Sub  

 '*******************************************************************************  

 Sub CreateLogFolder()  

      REM Define Local Objects  
      DIM FSO : Set FSO = CreateObject("Scripting.FileSystemObject")  

      If NOT FSO.FolderExists(TempFolder) then  
           FSO.CreateFolder(TempFolder)  
      End If  
      If NOT FSO.FolderExists(LogFolder) then  
           FSO.CreateFolder(LogFolder)  
      End If 
 
      REM Cleanup Local Variables  
      Set FSO = Nothing  

 End Sub  

 '*******************************************************************************  

 Sub InstallCurrentVersion()  

      REM Define Local Constants  
      CONST Timeout  = 3000  
      CONST Timepoll = 500  
      CONST FileName = "setup.exe"  

      REM Define Local Objects  
      DIM oShell : Set oShell = CreateObject("Wscript.Shell")  
      DIM SVC    : Set SVC    = GetObject("winmgmts:root\cimv2")  

      REM Define Local Variables  
      DIM sQuery     : sQuery         = "select * from win32_process where name=" & Chr(39) & FileName & Chr(39)  
      DIM cproc      : Set cproc      = Nothing  
      DIM iniproc    : Set iniproc    = Nothing  
      DIM Install    : Set Install    = Nothing  
      DIM Parameters : Set Parameters = Nothing  

      REM Initialize Local Variables  
      Parameters = Chr(32) & "/qb /I" & Chr(32) & RelativePath &_  
                      "AdminImage\RST_64bit.ini"  
      Install    = RelativePath & "AdminImage\" & FileName & Parameters  

      REM Install Autodesk  
      oShell.Run Install, 1, True  
      REM Wait until Second Setup.exe closes  
      Wscript.Sleep 5000  
      Set cproc = svc.execquery(sQuery)  
      iniproc = cproc.count  
      Do While iniproc = 1  
           wscript.sleep 5000  
           set svc=getobject("winmgmts:root\cimv2")  
           sQuery = "select * from win32_process where name=" & Chr(39) & FileName & Chr(39)  
           set cproc=svc.execquery(sQuery)  
           iniproc=cproc.count  
      Loop  

      REM Cleanup Local Variables  
      Set cproc      = Nothing  
      Set iniproc    = Nothing  
      Set Install    = Nothing  
      Set oShell     = Nothing  
      Set Parameters = Nothing  
      Set sQuery     = Nothing  
      set svc        = Nothing  

 End Sub  

 '*******************************************************************************  

 Sub InstallWorkshareMonitor()  

      REM Define Local Objects  
      DIM oShell : SET oShell = CreateObject("Wscript.Shell")  

      REM Define Local Variables  
      DIM MSI        : MSI        = Chr(32) & "workshare_monitor\worksharingmonitorforautodeskrevit2012_20110316_1624.msi"  
      DIM Log        : Log        = "WorkshareMonitor.log"  
      DIM Logs       : Logs       = Chr(32) & "/lvx" & Chr(32) & LogFolder & Log  
      DIM Parameters : Parameters = Chr(32) & "/qn /norestart"  
      DIM Install    : Install    = "msiexec.exe /i" & MSI & Logs & Parameters  

      oShell.Run Install, 1, True  

      REM Cleanup Local Variables  
      Set Install    = Nothing  
      Set Log        = Nothing  
      Set Logs       = Nothing  
      Set MSI        = Nothing  
      Set oShell     = Nothing  
      Set Parameters = Nothing  

 End Sub  

 '*******************************************************************************  

 Sub GlobalVariableCleanup()  

      Set LogFolder    = Nothing  
      Set RelativePath = Nothing  
      Set ReturnCode   = Nothing  

 End Sub  
