#include <SQLite.au3>
#include <SQLite.dll.au3>
#include<Array.au3>
Local $aResult, $iRows, $iColumns, $iRval
_SQLite_Startup()
If @error Then
   MsgBox(16, "SQLite Error", "SQLite.dll Can't be Loaded!")
   Exit -1
EndIf
ConsoleWrite("_SQLite_LibVersion=" & _SQLite_LibVersion() & @CRLF)
_SQLite_Open()
; Open a :memory: database
If @error Then
   MsgBox(16, "SQLite Error", "Can't Load Database!")
   Exit -1
EndIf
_SQLite_Open(@ScriptDir & '\user.db')
;Example Table
;	USER_ID   | PASSWORD
;   -----------------------
;    Alice    |  land
;    Bob      |  star
;    Cindy    |  world
If Not _SQLite_Exec(-1, "CREATE TABLE XTDUOUIPVS (USER_ID, PASSWORD);") = $SQLITE_OK Then _
   MsgBox(16, "SQLite Error", _SQLite_ErrMsg())
If Not _SQLite_Exec(-1, "INSERT INTO XTDUOUIPVS VALUES ('Alice','land');") = $SQLITE_OK Then _
   MsgBox(16, "SQLite Error", _SQLite_ErrMsg())
If Not _SQLite_Exec(-1, "INSERT INTO XTDUOUIPVS VALUES ('Bob','star');") = $SQLITE_OK Then _
   MsgBox(16, "SQLite Error", _SQLite_ErrMsg())
If Not _SQLite_Exec(-1, "INSERT INTO XTDUOUIPVS VALUES ('Cindy','world');") = $SQLITE_OK Then _
   MsgBox(16, "SQLite Error", _SQLite_ErrMsg())
   ; Query
$iRval = _SQLite_GetTable2d(-1, "SELECT * FROM XTDUOUIPVS;", $aResult, $iRows, $iColumns)
If $iRval = $SQLITE_OK Then
   _ArrayDisplay($aResult)
Else
   MsgBox(16, "SQLite Error: " & $iRval, _SQLite_ErrMsg())
EndIf
_SQLite_Close()
_SQLite_Shutdown()