Attribute VB_Name = "modINIReader"
'**************************************************************************
'**模 块 名：INI 文件操作 - 操作ini.bas
'**说    明：
'**创 建 人：icecept(魔灵)
'**日    期：2008-12-15 00:11:06
'**修 改 人：icecept(魔灵)
'**日    期：2009-1-9 01:20:23
'**描    述：icecept(魔灵)制作
'**版    本：V1.0.0    http://icecept.blog.sohu.com
'*************************************************************************

Option Explicit

'读出自定义INI文件
Private Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
'写入自定义INI文件
Public Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpString As Any, ByVal lpFileName As String) As Long
'读出自定义INI文件中的单个区段间的所有键名和值
Public Declare Function GetPrivateProfileSection Lib "kernel32" Alias "GetPrivateProfileSectionA" (ByVal lpAppName As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
'读出自定义INI所有区段名
Public Declare Function GetPrivateProfileSectionNames Lib "kernel32.dll" Alias "GetPrivateProfileSectionNamesA" (ByVal lpszReturnBuffer As String, ByVal nSize As Long, ByVal lpFileName As String) As Long

'*************************************************************************
'**函 数 名：GetIni
'**功能描述：从自定义ini文件中读信息 SectionName:区段名 KeyWord:具体键名 DefString:读取失败后返回默认 FileName:ini文件所在路径
'**补    充：读出的都是String类型的,如果你想读数字型的,可用VB的val()函数将其转化
'*************************************************************************

Public Function GetIni(ByVal SectionName As String, ByVal KeyWord As String, ByVal DefString As String, ByVal FileName As String) As String
    Dim ResultString As String * 255
    If GetPrivateProfileString(ByVal SectionName, ByVal KeyWord, vbNullString, ByVal ResultString, ByVal Len(ResultString), ByVal FileName) > 0 Then '关键词的值不为空
        GetIni = Left(ResultString, InStr(ResultString, Chr(0)) - 1)
    Else                                                                        '将缺省值写入INI文件
        WritePrivateProfileString SectionName, KeyWord, DefString, FileName
        GetIni = DefString
    End If
End Function

'*************************************************************************
'**函 数 名：GetKeyWord
'**功能描述：从自定义ini文件中得到键名和值
'**          SectionName:区段名  DefString:默认值  FileName:ini文件所在路径
'**补    充：�
'*************************************************************************
Public Function GetKeyWord(ByVal SectionName As String, ByVal DefString As String, ByVal FileName As String) As String
    Dim szBuf As String * 255
    If GetPrivateProfileSection(ByVal SectionName, ByVal szBuf, Len(szBuf), ByVal FileName) > 0 Then
        '同时获取键名和值
        GetKeyWord = Left(szBuf, InStr(szBuf, Chr(0)) - 1)
    Else
        WritePrivateProfileString SectionName, DefString, vbNullString, FileName
        GetKeyWord = DefString
    End If
End Function

'*************************************************************************
'**函 数 名：GetKey
'**功能描述：从自定义ini文件中得到键名
'**          SectionName:区段名  DefString:默认值  FileName:ini文件所在路径
'**补    充：�
'*************************************************************************
Public Function GetKey(ByVal SectionName As String, ByVal DefString As String, ByVal FileName As String) As String
    Dim szBuf As String * 255, ResultString As String
    ResultString = GetKeyWord(ByVal SectionName, ByVal szBuf, ByVal FileName)
    If InStr(ResultString, "=") <> 0 Then
        GetKey = Left(ResultString, InStr(ResultString, "=") - 1)
    Else
        GetKey = DefString
    End If
End Function

Public Function WriteKey(ByVal 区段名 As String, ByVal 键名 As String, ByVal 值 As String, ByVal 文件名 As String) As String
    WritePrivateProfileString 区段名, 键名, 值, 文件名
End Function

Public Function DelKey(ByVal 区段名 As String, ByVal 键名 As String, ByVal 文件名 As String) As String
    WritePrivateProfileString "区段名", "键名", vbNullString, 文件名
End Function
    'WritePrivateProfileString "a", "b", vbNullString, App.Path & "\test.ini"

'生成的test.ini 文件格式:
'
'[a]              a: 区段名
'b=c　    　　　　b：键名  c：值
'[d]              d: 区段名
'e=f              e：键名  f：值
'--------------------------------------------------------------------------------------
'操作ini文件的函数列表:
'只能操作win.ini的函数
'WriteProfileString 在win.ini初始化文件指定小节内设置一个字串
'WriteProfileSection 为win.ini初始化文件中一个指定的小节设置所有项名和值
'GetProfileInt 取得win.ini初始化文件中指定条目的一个整数值
'GetProfileSection               获取指定小节（在win.ini文件中）所有项名和值的一个列表
'GetProfileString 为win.ini初始化文件中指定的条目取得字串
'======================================================================================
'即能操作win.ini的函数，又能操作自定义ini文件的函数
'WritePrivateProfileString 在初始化文件指定小节内设置一个字串
'WritePrivateProfileSection      为一个初始化文件（.ini）中指定的小节设置所有项名和值
'GetPrivateProfileInt 为初始化文件中指定的条目获取一个整数值
'GetPrivateProfileSection 获取指定小节所有项名和值的一个列表
'GetPrivateProfileString 为初始化文件中指定的条目取得字串
'GetPrivateProfileSectionNames 读出INI文件中所有区段名

'Write
'      区段名，键名，值，文件名
    'WritePrivateProfileString "a", "b", "c", App.Path & "\test.ini"
    'WritePrivateProfileString "d", "e", "f", App.Path & "\test.ini"
 '修改键值
    'Dim AA As String
    'AA = InputBox("请输入新的a区段键名b下的值", Me.Caption)
    'If AA <> vbNullString Then
        'WritePrivateProfileString "a", "b", AA, App.Path & "\test.ini"
        'MsgBox "修改成功"
    'End If
    
    '删除a区段下的一个键名,删除键名后，键名下的值也会同时删除
    '                        区段名 键名
    'WritePrivateProfileString "a", "b", vbNullString, App.Path & "\test.ini"
'删除整个区段,,删除区段后，区段下的键名和值也会同时删除
    '        区段名
    'WritePrivateProfileString "a", vbNullString, vbNullString, App.Path & "\test.ini"
    'WritePrivateProfileString "d", vbNullString, vbNullString, App.Path & "\test.ini"

'读取数据       区段名     键名      默认值             文件名
    'MsgBox GetIni("rBnwares", "Year", vbNullString, "c:\windows\win.ini")

'获取键名
    'Dim szBuf As String * 255
    '                区段名，     键名，    文件名
    'MsgBox GetKeyWord("rBnwares", szBuf, "c:\windows\win.ini")
 '获取键名
    'Dim szBuf As String * 255
    '                区段名，   键名，    文件名
    'MsgBox GetKey("rBnwares", szBuf, "c:\windows\win.ini")

