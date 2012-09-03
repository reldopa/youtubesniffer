Attribute VB_Name = "modFunc"
Option Explicit
Public Declare Function SafeArrayGetDim Lib "oleaut32.dll" (ByRef saArray() As Any) As Long

Public Sub LoadInfo(ByVal wbSource As WebBrowser, ByVal txtDest As TextBox)
    'Clean Up
    If Len(txtDest.Text) > 0 Then txtDest.Text = ""
    'Load Title
    txtDest.Text = "[Title:] " & wbSource.LocationName & vbCrLf

End Sub

