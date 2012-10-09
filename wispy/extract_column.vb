Sub createFile()

Dim numOfCol As Integer
Dim colNum As Integer
Dim myTempSheet As String
Dim dataSheet As String
Dim colValue As Variant
Dim ColIndex() As Integer
Dim cvsName As String

    ThisWorkbook.Save
    
    myTempSheet = "myTempSeet"
    dataSheet = "Sheet1"
    cvsName = "tempCSV"
    
    Sheets(dataSheet).Select

    numOfCol = Cells(1, Columns.Count).End(xlToLeft).Column
    
    ReDim ColIndex(numOfCol)
    For colNum = 1 To numOfCol
        
        colValue = InputBox("What column should be in position " & colNum & " in the CVS file", "Col Position")
        If colValue = "" Then
            Exit For
        Else
            ColIndex(colNum) = colValue
        End If
       
    Next
    
    On Error Resume Next
    
    Sheets(myTempSheet).Delete
    
    On Error GoTo 0
    
    
    Sheets.Add
    ActiveSheet.Name = myTempSheet

    For colNum = 1 To numOfCol
    
        If ColIndex(colNum) > 0 Then
        
            Sheets(dataSheet).Select
            Columns(ColIndex(colNum)).Select
            Selection.Copy
            
            Sheets(myTempSheet).Select
            Columns(colNum).Select
            ActiveSheet.PasteSpecial xlValue
            
        Else
         Exit For
        
        End If

    Next
    
    Sheets(myTempSheet).Select
    numOfCol = Cells(1, Columns.Count).End(xlToLeft).Column
    
    For colNum = 1 To numOfCol
        
        If Cells(1, colNum) <> "" Then
            Cells(1, colNum) = "(" & Cells(1, colNum) & ")        "
        End If
    Next
    
    ActiveWorkbook.SaveAs _
        Filename:=cvsName & ".csv", _
        FileFormat:=xlCSV, _
        CreateBackup:=True
End Sub