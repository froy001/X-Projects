'========================================================
' X-Projects v0.5.0 - Copyright (C) 2011 M.Nomura
'========================================================
' �ύX����
'  v0.1.0 �����o�[�W����
'  v0.2.0 ���t�v�Z���Ȃ��S����ǉ�
'  v0.2.1 �񓚗��ǉ��A���O�𐮗�
'  v0.2.2 �ݒ�V�[�g�ɐi����񗓂�ǉ�
'  v0.3.0 CCPM�Ή��A�S���ҏ󋵂Ɨ\��H��������ǉ�
'  v0.3.1 CCPM����Ȃ��i���Ǘ����o�b�N�|�[�g
'  v0.3.2 �\��H�������Ɏ��сE�c��E�\��H���v��ǉ�
'  v0.3.3 �i�����ڃO���t�̏o�͂�ǉ�
'  v0.3.4 �`�P�b�g�폜�E�ǉ����l�������\��H�������̍X�V
'  v0.3.5 �i���񍐓��m�F��ǉ�
'  v0.4.0 �o�b�t�@�Ǘ��@�\�̒ǉ�
'  v0.5.0 REST API�ɂ��f�[�^�o�^�E�X�V
'========================================================

'�ݒ�V�[�g��
Const cCfgShtName = "�ݒ�"
Const cYkrShtName = "�\��H������"

Dim nDayKosu       '�P���ƌv�Z����H��
Dim nDefKosu       '�����͎��̗\��H��
Dim sHolidayOfWeek '�x���̗j��
Dim sReCalcDate    '�Čv�Z����J�n���t

'REST API ����p
Dim oCli As WebClient
Dim oReq As WebRequest
Dim sBaseUrl As String
Dim sApiKey As String
Dim sProjectId As String


'CSV�쐬�{�^��������
Private Sub btnMakeCsv_Click()

    Dim file_source As Object
    Dim file_target As Object

    csv_file_name = ActiveWorkbook.Path + "\" + ActiveSheet.Name + ".csv"

    code_source = "Shift_JIS"
    code_target = "UTF-8"

    char_source = ","
    char_target = ";"

    Application.DisplayAlerts = False
   
' ���V�[�g�𕡐�
    ActiveSheet.Copy

' CSV�`���ŕۑ�
    ActiveWorkbook.SaveAs Filename:=csv_file_name, FileFormat:=xlCSV, _
        CreateBackup:=False

' ���V�[�g�����
    ActiveWindow.Close Savechanges:=False
   

' **********************************
'      CSV�t�@�C����UTF-8�ɕϊ�
' **********************************
    
' ADODB.Stream���Q��
    Set file_source = CreateObject("ADODB.Stream")

' CSV�t�@�C���̓ǂݍ���
    With file_source
        .Charset = code_source
        .Open
        .LoadFromFile csv_file_name
        char_temp = .ReadText
    End With

' �u������
'    char_temp = Replace(char_temp, char_source, char_target)

' CSV�t�@�C���̏����o��
    Set file_target = CreateObject("ADODB.Stream")
    With file_target
        .Charset = code_target
        .Open
        .WriteText char_temp
    End With
    
' �����R�[�h�̕ϊ�
    file_source.copyto file_target
    file_target.savetofile csv_file_name, 2

End Sub

'���t�Čv�Z�{�^��������
Private Sub btnCalcDate_Click()

    '�S���҂��ƁA���A���Ń\�[�g����
    '�ŏ��̊J�n������x�����l������
    '�\��H�����犄��o����������
    '�J�n���A�����������v�Z����
    
    '�i���񍐓��m�F�E�Z�b�g
    sRDate = Format(Now, "yyyy/mm/dd")
    If Sheets(cCfgShtName).Range("�i���񍐓��m�F").Value = "�m�F����" Then
        sRet = InputBox("�w�肵���i���񍐓��œ��t�Čv�Z���������s���܂����H", "�i���񍐓��m�F", sRDate)
        If sRet = "" Then
            Exit Sub
        End If
        sRDate = sRet
    End If
    Sheets(cCfgShtName).Range("�i���񍐓�").Value = sRDate
    Sheets(cCfgShtName).Range("�i���񍐓�2").Value = sRDate
    
    '�ݒ� �ǂݍ���
    nDayKosu = Sheets(cCfgShtName).Range("�H���P��")
    nDefKosu = Sheets(cCfgShtName).Range("�H��������")
    sHolidayOfWeek = ""
    If Sheets(cCfgShtName).Range("�x���j��").Rows(1) <> "" Then
        sHolidayOfWeek = sHolidayOfWeek & "2"
    End If
    If Sheets(cCfgShtName).Range("�x���j��").Rows(2) <> "" Then
        sHolidayOfWeek = sHolidayOfWeek & "3"
    End If
    If Sheets(cCfgShtName).Range("�x���j��").Rows(3) <> "" Then
        sHolidayOfWeek = sHolidayOfWeek & "4"
    End If
    If Sheets(cCfgShtName).Range("�x���j��").Rows(4) <> "" Then
        sHolidayOfWeek = sHolidayOfWeek & "5"
    End If
    If Sheets(cCfgShtName).Range("�x���j��").Rows(5) <> "" Then
        sHolidayOfWeek = sHolidayOfWeek & "6"
    End If
    If Sheets(cCfgShtName).Range("�x���j��").Rows(6) <> "" Then
        sHolidayOfWeek = sHolidayOfWeek & "7"
    End If
    If Sheets(cCfgShtName).Range("�x���j��").Rows(7) <> "" Then
        sHolidayOfWeek = sHolidayOfWeek & "1"
    End If
    sReCalcDate = Sheets(cCfgShtName).Range("�Čv�Z�J�n���t")
    
    'MsgBox WorkDateAdd("2011/10/10", 0)
    'Exit Sub
    
    'Application.ScreenUpdating = False
    
    '�S���ҁA���A���Ń\�[�g
    Range("�f�[�^").Sort _
        Key1:=Range("�S����"), Order1:=xlAscending, _
        Key2:=Range("��"), Order2:=xlAscending, _
        Key3:=Range("No"), Order3:=xlAscending, _
        Header:=xlGuess, OrderCustom:=1, MatchCase:=False, Orientation:=xlTopToBottom, SortMethod:=xlPinYin, _
        DataOption1:=xlSortNormal, DataOption2:=xlSortTextAsNumbers, DataOption3:=xlSortNormal
    
    '�ŏI�s�A�e�J�����ʒu�擾
    nLastRow = Cells.SpecialCells(xlCellTypeLastCell).Row
    nTantoCol = Range("�S����").Column
    nSDateCol = Range("�J�n��").Column
    nEDateCol = Range("����").Column
    nTKosuCol = Range("�����H��").Column
    nYKosuCol = Range("�\��H��").Column
    
    nTKosuColGT = 0
    nYKosuColGT = 0
    nJKosuColGT = 0
    sDateGT = ""
    
    '�S���҃��X�g�擾
    Set oTantos = CreateObject("Scripting.Dictionary")
    
    arTantos = Range(Cells(2, nTantoCol), Cells(nLastRow, nTantoCol))
    
    For Each sTanto In arTantos
        If Not oTantos.Exists(sTanto) And Trim(sTanto) <> "" Then
            oTantos.Add sTanto, Null
        End If
    Next
    
    '�f�t�H���g�̊J�n���t�F���ݓ��{�P
    sDefDate = Format(Now + 1, "yyyy/mm/dd")
    
    '�S���ҏ󋵂̃N���A
    nTjOff = 0
    With Sheets(cCfgShtName)
        With .Range(.Range("�S���ҏ󋵐��^�s").Offset(1, 0), .Range("�S���ҏ󋵐��^�s").Offset(50, 0))
            .Clear
        End With
    End With
    
    '�S���҂��ƂɃ��[�v
    Dim oFind
    For Each sTanto In oTantos
        'Debug.Print sTanto
        sDate = ""
        nKosu = 0
        
        nTKosuColST = 0
        nYKosuColST = 0
        nJKosuColST = 0
        
        '�ΏۊO����
        Set oFind = Sheets(cCfgShtName).Range("���t�v�Z�ΏۊO").Find(sTanto, , xlFormulas, xlWhole)
        
        '�`�P�b�g�s���ƂɃ��[�v
        For i = 2 To nLastRow
            
            '�������̒S���҂��ǂ���
            If Cells(i, nTantoCol) = sTanto Then
                
                '���t�Čv�Z����S���҂��ǂ���
                If oFind Is Nothing Then
                    
                    '�S���̊J�n���ǂ���
                    If sDate = "" Then
                        '�Čv�Z���ǂ���
                        If sReCalcDate = "" Then
                            '�J�n�������ݒ�
                            If Cells(i, nSDateCol) = "" Then
                                sDefDate = InputBox("�J�n�������ݒ�F" & sTanto, "���t�v�Z", sDefDate)
                                If sDefDate = "" Then
                                    GoTo LOOP_EXIT
                                End If
                                sDate = sDefDate
                            Else
                                sDate = Cells(i, nSDateCol)
                            End If
                            
                            '�J�n�����c�Ɠ��ɂ���
                            sDate = WorkDateAdd(sDate, 0)
                            
                             Cells(i, nSDateCol) = sDate
                        Else
                            '�J�n�������ݒ�͖���
                            If Cells(i, nSDateCol) <> "" Then
                                '�Čv�Z�J�n���ȏ�Ȃ�
                                If CDate(sReCalcDate) <= CDate(Cells(i, nSDateCol)) Then
                                    sDate = Cells(i, nSDateCol)
                                End If
                            End If
                        End If
                    Else
                        Cells(i, nSDateCol) = sDate
                    End If
                    
                    '�v�Z�J�n�����ǂ���
                    If sDate <> "" Then
                        
                        '�\��H�������ݒ�
                        If Cells(i, nYKosuCol) = "" Then
                            Cells(i, nYKosuCol) = nDefKosu
                        End If
                        
                        '�����H�������ݒ�
                        If Cells(i, nTKosuCol) = "" Then
                            Cells(i, nTKosuCol) = Cells(i, nYKosuCol)
                        End If
                        
                        '�����Ɨ]��H��
                        nTKosu = Cells(i, nTKosuCol)
                        nYKosu = Cells(i, nYKosuCol)
                        nAKosu = nKosu + nYKosu
                        nDay = Int((nAKosu - 1) / nDayKosu)
                        nKosu = nAKosu Mod nDayKosu
                        
                        '�J�n��
                        sSDate = sDate
                        
                        '�����̐ݒ�
                        sDate = WorkDateAdd(sDate, nDay)
                        Cells(i, nEDateCol) = sDate
                        sEDate = sDate
                        
                        '���̊J�n�����v�Z
                        If nYKosu <> 0 And nKosu = 0 Then
                            sDate = WorkDateAdd(sDate, 1)
                        End If
                    End If
                
                Else '���t�Čv�Z���Ȃ��S���҂̏ꍇ
                    
                    '�\��H��
                    nYKosu = Cells(i, nYKosuCol)
                    
                    '�����H��
                    nTKosu = Cells(i, nTKosuCol)
                    
                    '�J�n��
                    sSDate = Cells(i, nSDateCol)
                    
                    '����
                    sEDate = Cells(i, nEDateCol)
                    
                End If
                        
                '�S���Ҍv�A�����v�̌v�Z
                nTKosuColST = nTKosuColST + nTKosu
                nYKosuColST = nYKosuColST + nYKosu
                nTKosuColGT = nTKosuColGT + nTKosu
                nYKosuColGT = nYKosuColGT + nYKosu
                
                '���эH���v
                If sEDate < sRDate Then
                    nJKosuColST = nJKosuColST + nYKosu
                    nJKosuColGT = nJKosuColGT + nYKosu
                ElseIf sSDate <= sRDate Then
                    nTmpKosu = (DateDiff("d", CDate(sSDate), CDate(sRDate)) + 1) * nDayKosu
                    nJKosuColST = nJKosuColST + nTmpKosu
                    nJKosuColGT = nJKosuColGT + nTmpKosu
                End If
                
            End If
            
        Next
      
        '�S���ҏ󋵂̏o��
        'Debug.Print sTanto & ", " & sEDate & ", " & nTKosuColST & ", " & nYKosuColST
        With Sheets(cCfgShtName).Range("�S���ҏ󋵐��^�s")
            '���^�s�R�s�[
            If nTjOff > 0 Then
                .Copy .Offset(nTjOff, 0)
            End If
            '�s���Z�b�g
            With .Offset(nTjOff, 0)
                .Value = Array(sTanto, sEDate, nTKosuColST, nJKosuColST, nYKosuColST - nJKosuColST, nYKosuColST, "", "", "")
                .Cells(1, 7).FormulaR1C1 = "=RC[-1]/�H���P��"
                .Cells(1, 8).FormulaR1C1 = "=RC[-1]/20"
                .Cells(1, 9).FormulaR1C1 = "=(RC[-3]/RC[-6]-1)*100"
            End With
            nTjOff = nTjOff + 1
        End With
        
        If sDateGT < sEDate Then sDateGT = sEDate
        
    Next

LOOP_EXIT:
    
    Range("�f�[�^").Sort _
        Key1:=Range("No"), Order1:=xlAscending, _
        Header:=xlGuess, OrderCustom:=1, MatchCase:=False, Orientation:=xlTopToBottom, SortMethod:=xlPinYin, _
        DataOption1:=xlSortNormal, DataOption2:=xlSortTextAsNumbers, DataOption3:=xlSortNormal
 
    '�v���W�F�N�g�󋵂̏o��
    'Debug.Print "���v" & ", " & sDateGT & ", " & nTKosuColGT & ", " & nYKosuColGT
    With Sheets(cCfgShtName).Range("�S���ҏ󋵐��^�s")
        '���^�s�R�s�[
        .Copy .Offset(nTjOff, 0)
        With .Offset(nTjOff, 0)
            '�W�v�s�r��
            .Borders(xlEdgeTop).LineStyle = xlDouble
            '�s���Z�b�g
            .Cells(1, 1).Value = ""
            .Cells(1, 2).Value = sDateGT
            .Cells(1, 3).FormulaR1C1 = "=SUM(R[-" & nTjOff & "]C:R[-1]C)"
            .Cells(1, 4).FormulaR1C1 = "=SUM(R[-" & nTjOff & "]C:R[-1]C)"
            .Cells(1, 5).FormulaR1C1 = "=SUM(R[-" & nTjOff & "]C:R[-1]C)"
            .Cells(1, 6).FormulaR1C1 = "=SUM(R[-" & nTjOff & "]C:R[-1]C)"
            .Cells(1, 7).FormulaR1C1 = "=RC[-1]/�H���P��"
            .Cells(1, 8).FormulaR1C1 = "=RC[-1]/20"
            .Cells(1, 9).FormulaR1C1 = "=(RC[-3]/RC[-6]-1)*100"
        End With
        nTjOff = nTjOff + 1
    End With
   
    '�\��H�������̍쐬
    If Sheets(cCfgShtName).Range("�\��H������").Value = "�쐬����" Then
        With Sheets(cYkrShtName)
            '�V�K��ʒu�̎Z�o�A���^�R�s�[�A���t�Z�b�g
            nYkrCol = .Range("�\��H�����𐗌^��").Column
            Do Until .Cells(1, nYkrCol).Value = ""
                nYkrCol = nYkrCol + 1
            Loop
            .Range("�\��H�����𐗌^��").Copy .Columns(nYkrCol)
            .Cells(1, nYkrCol).Value = sRDate
            
            '�\��H���v�A�c��H���v�A���эH���v�̃Z�b�g
            .Cells(2, nYkrCol).Value = nJKosuColGT
            .Cells(3, nYkrCol).Value = nYKosuColGT - nJKosuColGT
            .Cells(4, nYkrCol).Value = nYKosuColGT
            
            'TODO: �`�P�b�g�폜����������ꍇ�͇��ł̃}�b�`���O�K�v
            'Range("No").Resize(Range("No").Rows.Count - 3, 1).Copy .Range("No")
            'Range("�薼").Resize(Range("�薼").Rows.Count - 3, 1).Copy .Range("�薼")
            'Range("�S����").Resize(Range("�S����").Rows.Count - 3, 1).Copy .Range("�S����")
            'Range("�\��H��").Resize(Range("�\��H��").Rows.Count - 3, 1).Copy .Range(.Cells(5, nYkrCol), .Cells(.Rows.Count - 1, nYkrCol))
            
            '�o�b�t�@����̐����Z�b�g
            .Cells(5, nYkrCol).FormulaR1C1 = "=IF(�o�b�t�@�H��=0,0,ROUND((R[-1]C-R4C4)/�o�b�t�@�H��*100,0))"
            
            '�ŏI�s�ʒu�̎Z�o
            nYkrRow = 6
            Do Until .Cells(nYkrRow, 1).Value = ""
                nYkrRow = nYkrRow + 1
            Loop
            
            '�\��H���Z�b�g�A��v���釂�������ꍇ�͍ŏI�s�ȍ~�ɒǉ�
            For i = 2 To nLastRow
                nNo = Range("No").Cells(i - 1, 1)
                Set oFind = .Range("No").Find(nNo, , xlFormulas, xlWhole)
                If Not oFind Is Nothing Then
                    .Cells(oFind.Row, nYkrCol) = Range("�\��H��").Cells(i - 1, 1)
                Else
                    .Cells(nYkrRow, .Range("No").Column) = Range("No").Cells(i - 1, 1)
                    .Cells(nYkrRow, .Range("�薼").Column) = Range("�薼").Cells(i - 1, 1)
                    .Cells(nYkrRow, .Range("�S����").Column) = Range("�S����").Cells(i - 1, 1)
                    .Cells(nYkrRow, nYkrCol) = Range("�\��H��").Cells(i - 1, 1)
                    nYkrRow = nYkrRow + 1
                End If
            Next
            
            '�\��H�������̃`�P�b�g�s�������Ń\�[�g
            .Range(.Cells(6, 1), .Cells(nYkrRow, nYkrCol)).Sort _
                Key1:=.Range("No"), Order1:=xlAscending, _
                Header:=xlNo, OrderCustom:=1, MatchCase:=False, Orientation:=xlTopToBottom, SortMethod:=xlPinYin, _
                DataOption1:=xlSortNormal, DataOption2:=xlSortTextAsNumbers, DataOption3:=xlSortNormal
            
            '�I�[�g�t�B���^�̍Đݒ�
            With .Range(.Columns(1), .Columns(nYkrCol))
                .AutoFilter
                .AutoFilter
            End With
        End With
    End If
    
    '�i�����ڃO���t�̏o��
    With Sheets(cYkrShtName)
        nYkrSCol = .Range("�\��H�����𐗌^��").Column
        nYkrECol = nYkrSCol
        Do Until .Cells(1, nYkrECol).Value = ""
            nYkrECol = nYkrECol + 1
        Loop
        nYkrECol = nYkrECol - 1
    End With
    With Sheets(cYkrShtName)
        Set oSrcDat = .Range(.Cells(1, nYkrSCol), .Cells(4, nYkrECol))
    End With
    With Sheets(cCfgShtName)
        For Each oChtObj In .ChartObjects
             oChtObj.Delete
        Next
        Set oChtObj = .ChartObjects.Add(313, 220, 510, 300) 'Left, Top, Width, Height
    End With
    With oChtObj.Chart
        .ChartType = xlLineMarkers
        .SetSourceData Source:=oSrcDat, PlotBy:=xlRows
        With .SeriesCollection(1)
            .Name = "���эH���v"
            .Border.Weight = xlMedium
            .Border.ColorIndex = 11
            .MarkerForegroundColorIndex = 11
            .MarkerBackgroundColorIndex = 11
        End With
        With .SeriesCollection(2)
            .Name = "�c��H���v"
            .Border.Weight = xlMedium
            .Border.ColorIndex = 7
            .MarkerForegroundColorIndex = 7
            .MarkerBackgroundColorIndex = 7
        End With
        With .SeriesCollection(3)
            .Name = "�\��H���v"
            .Border.Weight = xlMedium
            .Border.ColorIndex = 43
            .MarkerForegroundColorIndex = 43
            .MarkerBackgroundColorIndex = 43
        End With
        .Legend.Position = xlTop
        With .Axes(xlValue)
            .Border.ColorIndex = 16
            .MajorGridlines.Border.ColorIndex = 16
        End With
        With .Axes(xlCategory)
            .CategoryType = xlCategoryScale
            .HasMajorGridlines = True
            .AxisBetweenCategories = False
            .Border.ColorIndex = 16
            .MajorGridlines.Border.ColorIndex = 16
        End With
        .PlotArea.Interior.ColorIndex = 2
    End With
    
    '�o�b�t�@�Ǘ��O���t�̍쐬
    Dim nYkrCnt, nBufKosu, nWarBufPerS, nWarBufPerE, nWarBufDif, nDanBufPerS, nDanBufPerE, nDanBufDif
    Dim arSafBufPer(), arWarBufPer(), arDanBufPer()
    
    '�ݒ�V�[�g����ݒ�l���擾
    With Sheets(cCfgShtName)
        nBufKosu = .Range("�o�b�t�@�H��").Value
        nWarBufPerS = .Range("���Ӄo�b�t�@����J�n��").Value
        nWarBufPerE = .Range("���Ӄo�b�t�@����I����").Value
        nDanBufPerS = .Range("�댯�o�b�t�@����J�n��").Value
        nDanBufPerE = .Range("�댯�o�b�t�@����I����").Value
    End With
    
    '�o�b�t�@�H�����ݒ肳��Ă���ꍇ�̂�
    If nBufKosu > 0 Then
        '�f�[�^���A���S�E���ӁE�댯�́��z��m��
        nYkrCnt = nYkrECol - 3
        ReDim Preserve arSafBufPer(nYkrCnt - 1)
        ReDim Preserve arWarBufPer(nYkrCnt - 1)
        ReDim Preserve arDanBufPer(nYkrCnt - 1)
        '���ӁE�댯�̑�����
        nWarBufDif = nWarBufPerE - nWarBufPerS
        nDanBufDif = nDanBufPerE - nDanBufPerS
        '�\��H���������Ƃɐi�������Z�o�A�e���z��ɃZ�b�g
        With Sheets(cYkrShtName)
            For i = 0 To nYkrCnt - 1
                nShinchokuRitsu = .Cells(2, nYkrSCol + i).Value / .Cells(4, nYkrSCol + i).Value '�i���� �� ���эH�� �� �\��H��
                arSafBufPer(i) = nWarBufPerS + Round(nWarBufDif * nShinchokuRitsu, 0)
                arWarBufPer(i) = nDanBufPerS - nWarBufPerS - Round(nWarBufDif * nShinchokuRitsu, 0) + Round(nDanBufDif * nShinchokuRitsu, 0)
                arDanBufPer(i) = 100 - nDanBufPerS - Round(nDanBufDif * nShinchokuRitsu, 0)
            Next
        End With
        
'        Debug.Print "nWarBufDif: " & nWarBufDif
'        Debug.Print "nDanBufDif: " & nDanBufDif
'        Debug.Print "arSafBufPer: " & Join(arSafBufPer, ", ")
'        Debug.Print "arWarBufPer: " & Join(arWarBufPer, ", ")
'        Debug.Print "arDanBufPer: " & Join(arDanBufPer, ", ")
        
        '�o�b�t�@�Ǘ��O���t�̏o��
        With Sheets(cYkrShtName)
            Set oXValDat = .Range(.Cells(1, nYkrSCol), .Cells(1, nYkrECol))
            Set oBValDat = .Range(.Cells(5, nYkrSCol), .Cells(5, nYkrECol))
        End With
        With Sheets(cCfgShtName)
            Set oChtObj = .ChartObjects.Add(313, 530, 510, 300) 'Left, Top, Width, Height
        End With
        With oChtObj.Chart
            .SeriesCollection.NewSeries
            With .SeriesCollection(1)
                .ChartType = xlAreaStacked
                .XValues = oXValDat
                .Name = "���S"
                .Values = arSafBufPer
                .Interior.ColorIndex = 35 '10
                .Border.LineStyle = xlNone
            End With
            .SeriesCollection.NewSeries
            With .SeriesCollection(2)
                .Name = "����"
                .Values = arWarBufPer
                .Interior.ColorIndex = 36 '6
                .Border.LineStyle = xlNone
            End With
            .SeriesCollection.NewSeries
            With .SeriesCollection(3)
                .Name = "�댯"
                .Values = arDanBufPer
                .Interior.ColorIndex = 38 '3
                .Border.LineStyle = xlNone
            End With
            .SeriesCollection.NewSeries
            With .SeriesCollection(4)
                .ChartType = xlLineMarkers
                '.AxisGroup = xlSecondary
                .Name = "�o�b�t�@���"
                .Values = oBValDat
                With .Border
                    .ColorIndex = 46
                    .Weight = xlMedium
                End With
                .MarkerBackgroundColorIndex = 46
                .MarkerForegroundColorIndex = xlNone
                .MarkerStyle = xlSquare
            End With
            .Legend.Position = xlTop
            With .Axes(xlValue)
                .MaximumScale = 100
                .Border.ColorIndex = 16
                .MajorGridlines.Border.ColorIndex = 16
            End With
            With .Axes(xlCategory)
                .CategoryType = xlCategoryScale
                .HasMajorGridlines = True
                .AxisBetweenCategories = False
                .Border.ColorIndex = 16
                .MajorGridlines.Border.ColorIndex = 16
            End With
        End With
    End If

End Sub

'�c�Ɠ��œ������Z
Private Function WorkDateAdd(sDate, nDay)
    'WorkDateAdd = Format(CDate(sDate) + nDay, "yyyy/mm/dd")
    'Exit Function
    
    '�w�肵�������c�Ɠ����ǂ������`�F�b�N
    nAdd = -1
    nDate = CDate(sDate) - 1
    Do
        nDate = nDate + 1
        bWorkDay = True
        
        '�x���̗j������
        If InStr(sHolidayOfWeek, Weekday(nDate)) > 0 Then
            bWorkDay = False
        End If
        
        '�j������
        Dim oFind
        Set oFind = Sheets(cCfgShtName).Range("�j���ݒ�").Find(nDate, , xlFormulas, xlWhole)
        If Not oFind Is Nothing Then
            bWorkDay = False
        End If
        
        '�x���j���̖�������
        If Not bWorkDay Then
            Set oFind = Sheets(cCfgShtName).Range("�����x���j��").Find(nDate, , xlFormulas, xlWhole)
            If Not oFind Is Nothing Then
                bWorkDay = True
            End If
        End If
        
        '�c�Ɠ��Ȃ�J�E���g
        If bWorkDay Then
            nAdd = nAdd + 1
        End If
    Loop While nAdd < nDay
    WorkDateAdd = Format(nDate, "yyyy/mm/dd")
End Function


'==================== REST API ���쏈���Q ====================

'REST�N���C�A���g�ݒ�
Private Sub RestClientSetup()
    sBaseUrl = Sheets(cCfgShtName).Range("�x�[�XURL")
    sApiKey = Sheets(cCfgShtName).Range("API�L�[")
    sProjectId = Sheets(cCfgShtName).Range("�v���W�F�N�gID")
    Set oCli = New WebClient
    oCli.BaseUrl = sBaseUrl
    Set oReq = New WebRequest
    With oReq
        .AddHeader "X-Redmine-API-Key", sApiKey
        .Format = WebFormat.Json
    End With
End Sub

'����ID�}�b�v�擾
Private Function GetNameIdMap(argResource As String) As Dictionary
    Dim arTemp
    arTemp = Split(argResource, "/")
    sMapName = arTemp(UBound(arTemp))
    If sMapName = "users" Then
        sName = "login"
    Else
        sName = "name"
    End If
    With oReq
        .Resource = argResource & ".json"
        .Method = WebMethod.HttpGet
        .AddQuerystringParam "limit", "200"
    End With
    Set oRes = oCli.Execute(oReq)
    Set dicRet = New Dictionary
    For Each oItem In oRes.Data(sMapName)
        'Debug.Print oItem(sName) & ", " & oItem("id")
        dicRet.Add oItem(sName), oItem("id")
    Next
    Set GetNameIdMap = dicRet
End Function


'Web�Ǎ��{�^��������
Private Sub btnWebLoad_Click()
    If MsgBox("���������s���܂����H", vbOKCancel + vbQuestion, "Web�Ǎ�") = vbCancel Then
        Exit Sub
    End If
    
    '�����Z�b�g�A�b�v
    RestClientSetup
    
    '�`�P�b�g�ꗗ�f�[�^���擾
    With oReq
        .Resource = "issues.json"
        .Method = WebMethod.HttpGet
        .AddQuerystringParam "project_id", sProjectId
        .AddQuerystringParam "sort", "id"
    End With
    Set oRes = oCli.Execute(oReq)
    
    '�e�J�����ʒu�擾
    nProjectCol = Range("�v���W�F�N�g").Column
    nTrackerCol = Range("�g���b�J�[").Column
    nStatusCol = Range("�X�e�[�^�X").Column
    nPriorityCol = Range("�D��x").Column
    nSubjectCol = Range("�薼").Column
    nAuthorCol = Range("�쐬��").Column
    nAssignCol = Range("�S����").Column
    nUpdatedCol = Range("�X�V��").Column
    nCategoryCol = Range("�J�e�S��").Column
    nVersionCol = Range("�Ώۃo�[�W����").Column
    nStartDateCol = Range("�J�n��").Column
    nDueDateCol = Range("����").Column
    nYKosuCol = Range("�\��H��").Column
    nEstHoursCol = Range("��Ǝ���").Column
    nDoneRatioCol = Range("�i���p�[�Z���g").Column
    nCreatedCol = Range("�쐬��").Column
    nAnswerCol = Range("��").Column
    nTKosuCol = Range("�����H��").Column
    nPrivateCol = Range("�v���C�x�[�g").Column
    nDescCol = Range("����").Column

    '�擾�����`�P�b�g�ꗗ�f�[�^�����ɏ���
    For Each oItem In oRes.Data("issues")
        '�`�P�b�gId�����݂���Ύ擾�f�[�^�𔽉f
        Set oFind = Range("Id").Find(oItem("id"), , xlFormulas, xlWhole)
        If Not oFind Is Nothing Then
            Cells(oFind.Row, nProjectCol) = oItem("project")("name")
            Cells(oFind.Row, nTrackerCol) = oItem("tracker")("name")
            Cells(oFind.Row, nStatusCol) = oItem("status")("name")
            Cells(oFind.Row, nPriorityCol) = oItem("priority")("name")
            Cells(oFind.Row, nSubjectCol) = oItem("subject")
            Cells(oFind.Row, nAuthorCol) = oItem("author")("name")
            Cells(oFind.Row, nAssignCol) = oItem("assigned_to")("name")
            Cells(oFind.Row, nUpdatedCol) = Replace(Replace(oItem("updated_on"), "T", " "), "Z", "")
            If oItem.Exists("category") Then
                Cells(oFind.Row, nCategoryCol) = oItem("category")("name")
            End If
            If oItem.Exists("fixed_version") Then
                Cells(oFind.Row, nVersionCol) = oItem("fixed_version")("name")
            End If
            Cells(oFind.Row, nStartDateCol) = oItem("start_date")
            Cells(oFind.Row, nDueDateCol) = oItem("due_date")
            Cells(oFind.Row, nYKosuCol) = oItem("estimated_hours")
            'Cells(oFind.Row, nEstHoursCol) = oItem("estimated_hours")
            'Cells(oFind.Row, nDoneRatioCol) = oItem("done_ratio")
            Cells(oFind.Row, nCreatedCol) = Replace(Replace(oItem("created_on"), "T", " "), "Z", "")
            If oItem.Exists("custom_fields") Then
                '�J�X�^���t�B�[���h�̔��f
                For Each oCustomFields In oItem("custom_fields")
                    Select Case oCustomFields("name")
                    Case "�����H��"
                        Cells(oFind.Row, nTKosuCol) = oCustomFields("value")
                    Case "��"
                        Cells(oFind.Row, nAnswerCol) = oCustomFields("value")
                    End Select
                Next
            End If
            If oItem.Exists("is_private") Then
                Cells(oFind.Row, nPrivateCol) = oItem("is_private")
            End If
            If oItem.Exists("description") Then
                'Cells(oFind.Row, nDescCol) = oItem("description")
            End If
        End If
    Next
End Sub

'Web�o�^�{�^��������
Private Sub btnWebSave_Click()
    If MsgBox("���������s���܂����H", vbOKCancel + vbQuestion, "Web�o�^") = vbCancel Then
        Exit Sub
    End If
    
    'REST�N���C�A���g�ݒ�
    RestClientSetup
    
    '����ID�}�b�v�擾
    Set dicTrackers = GetNameIdMap("trackers")
    Set dicStatuses = GetNameIdMap("issue_statuses")
    Set dicPriorities = GetNameIdMap("enumerations/issue_priorities")
    Set dicCategories = GetNameIdMap("projects/" & sProjectId & "/issue_categories")
    Set dicVersions = GetNameIdMap("projects/" & sProjectId & "/versions")
    Set dicCustomFields = GetNameIdMap("custom_fields")
    Set dicUsers = GetNameIdMap("users")
    
    '�ŏI�s�A�e�J�����ʒu�擾
    nLastRow = Cells.SpecialCells(xlCellTypeLastCell).Row
    nNoCol = Range("No").Column
    nIdCol = Range("Id").Column
    nProjectCol = Range("�v���W�F�N�g").Column
    nTrackerCol = Range("�g���b�J�[").Column
    nStatusCol = Range("�X�e�[�^�X").Column
    nPriorityCol = Range("�D��x").Column
    nSubjectCol = Range("�薼").Column
    nAuthorCol = Range("�쐬��").Column
    nAssignCol = Range("�S����").Column
    nUpdatedCol = Range("�X�V��").Column
    nCategoryCol = Range("�J�e�S��").Column
    nVersionCol = Range("�Ώۃo�[�W����").Column
    nStartDateCol = Range("�J�n��").Column
    nDueDateCol = Range("����").Column
    nYKosuCol = Range("�\��H��").Column
    nEstHoursCol = Range("��Ǝ���").Column
    nDoneRatioCol = Range("�i���p�[�Z���g").Column
    nCreatedCol = Range("�쐬��").Column
    nAnswerCol = Range("��").Column
    nTKosuCol = Range("�����H��").Column
    nPrivateCol = Range("�v���C�x�[�g").Column
    nDescCol = Range("����").Column
    
    Dim Body As New Dictionary
    Dim Issue As New Dictionary
    Dim CustomFields As Collection
    Dim CustomField1 As New Dictionary
    Dim CustomField2 As New Dictionary
    
    Body.Add "issue", Issue
    
    '�`�P�b�g�s���ƂɃ��[�v
    For i = 2 To nLastRow
        '�����͍s�̓X�L�b�v
        If Cells(i, nNoCol) <> "" Then
            '�`�P�b�gID�������͂̏ꍇ�͓o�^�A����ȊO�̏ꍇ�͍X�V
            If Cells(i, nIdCol) = "" Then
                Debug.Print Cells(i, nNoCol) & ", New"
                
                With Issue
                    .RemoveAll
                    .Add "project_id", sProjectId
                    .Add "tracker_id", dicTrackers(CStr(Cells(i, nTrackerCol)))
                    .Add "status_id", dicStatuses(CStr(Cells(i, nStatusCol)))
                    .Add "priority_id", dicPriorities(CStr(Cells(i, nPriorityCol)))
                    .Add "subject", Cells(i, nSubjectCol)
                    If Cells(i, nAuthorCol) <> "" Then
                        .Add "author_id", dicUsers(CStr(Cells(i, nAuthorCol)))
                    End If
                    If Cells(i, nAssignCol) <> "" Then
                        .Add "assigned_to_id", dicUsers(CStr(Cells(i, nAssignCol)))
                    End If
                    '.Add "updated_on", Cells(i, nUpdatedCol)
                    If Cells(i, nCategoryCol) <> "" Then
                        .Add "category_id", dicCategories(CStr(Cells(i, nCategoryCol)))
                    End If
                    If Cells(i, nVersionCol) <> "" Then
                        .Add "fixed_version_id", dicVersions(CStr(Cells(i, nVersionCol)))
                    End If
                    .Add "start_date", Replace(Cells(i, nStartDateCol), "/", "-")
                    .Add "due_date", Replace(Cells(i, nDueDateCol), "/", "-")
                    .Add "estimated_hours", Cells(i, nYKosuCol)
                    '.Add "estimated_hours", Cells(i, nEstHoursCol)
                    '.Add "done_ratio", Cells(i, nDoneRatioCol)
                    '.Add "created_on", Cells(i, nCreatedCol)
                    If Cells(i, nAnswerCol) <> "" Or Cells(i, nTKosuCol) <> "" Then
                        Set CustomFields = New Collection
                        
                        If Cells(i, nAnswerCol) <> "" Then
                            CustomField1.RemoveAll
                            CustomField1.Add "name", "��"
                            CustomField1.Add "id", dicCustomFields("��")
                            CustomField1.Add "value", CStr(Cells(i, nAnswerCol))
                            CustomFields.Add CustomField1
                        End If
                        
                        If Cells(i, nTKosuCol) <> "" Then
                            CustomField2.RemoveAll
                            CustomField2.Add "name", "�����H��"
                            CustomField2.Add "id", dicCustomFields("�����H��")
                            CustomField2.Add "value", CStr(Cells(i, nTKosuCol))
                            CustomFields.Add CustomField2
                        End If
                        
                        .Add "custom_fields", CustomFields
                    End If
                    .Add "is_private", Cells(i, nPrivateCol)
                    .Add "description", Cells(i, nDescCol)
                End With
            
                With oReq
                    .Resource = "issues.json"
                    .Method = WebMethod.HttpPost
                    Set .Body = Body
                End With
                
                Set oRes = oCli.Execute(oReq)
                
                Cells(i, nIdCol) = oRes.Data("issue")("id")
            Else
                Debug.Print Cells(i, nNoCol) & ", " & Cells(i, nIdCol)
                
                With Issue
                    .RemoveAll
                    .Add "project_id", sProjectId
                    .Add "tracker_id", dicTrackers(CStr(Cells(i, nTrackerCol)))
                    .Add "status_id", dicStatuses(CStr(Cells(i, nStatusCol)))
                    .Add "priority_id", dicPriorities(CStr(Cells(i, nPriorityCol)))
                    .Add "subject", Cells(i, nSubjectCol)
                    If Cells(i, nAuthorCol) <> "" Then
                        .Add "author_id", dicUsers(CStr(Cells(i, nAuthorCol)))
                    End If
                    If Cells(i, nAssignCol) <> "" Then
                        .Add "assigned_to_id", dicUsers(CStr(Cells(i, nAssignCol)))
                    End If
                    '.Add "updated_on", Cells(i, nUpdatedCol)
                    If Cells(i, nCategoryCol) <> "" Then
                        .Add "category_id", dicCategories(CStr(Cells(i, nCategoryCol)))
                    End If
                    If Cells(i, nVersionCol) <> "" Then
                        .Add "fixed_version_id", dicVersions(CStr(Cells(i, nVersionCol)))
                    End If
                    .Add "start_date", Replace(Cells(i, nStartDateCol), "/", "-")
                    .Add "due_date", Replace(Cells(i, nDueDateCol), "/", "-")
                    .Add "estimated_hours", Cells(i, nYKosuCol)
                    '.Add "estimated_hours", Cells(i, nEstHoursCol)
                    '.Add "done_ratio", Cells(i, nDoneRatioCol)
                    '.Add "created_on", Cells(i, nCreatedCol)
                    If Cells(i, nAnswerCol) <> "" Or Cells(i, nTKosuCol) <> "" Then
                        Set CustomFields = New Collection
                        
                        If Cells(i, nAnswerCol) <> "" Then
                            CustomField1.RemoveAll
                            CustomField1.Add "name", "��"
                            CustomField1.Add "id", dicCustomFields("��")
                            CustomField1.Add "value", CStr(Cells(i, nAnswerCol))
                            CustomFields.Add CustomField1
                        End If
                        
                        If Cells(i, nTKosuCol) <> "" Then
                            CustomField2.RemoveAll
                            CustomField2.Add "name", "�����H��"
                            CustomField2.Add "id", dicCustomFields("�����H��")
                            CustomField2.Add "value", CStr(Cells(i, nTKosuCol))
                            CustomFields.Add CustomField2
                        End If
                        
                        .Add "custom_fields", CustomFields
                    End If
                    .Add "is_private", Cells(i, nPrivateCol)
                    .Add "description", Cells(i, nDescCol)
                End With
            
                With oReq
                    .Resource = "issues/" & Cells(i, nIdCol) & ".json"
                    .Method = WebMethod.HttpPut
                    Set .Body = Body
                End With
                
                Set oRes = oCli.Execute(oReq)
            End If
        End If
    Next

End Sub


Private Sub testRedmineRestApi()
    'https://github.com/VBA-tools/VBA-Web
    'http://www.r-labs.org/projects/r-labs/wiki/Redmine_REST_API
    'EnableLogging = True

    Dim oCli As New WebClient
    Dim oReq As New WebRequest
    Dim oRes As WebResponse
    
    oCli.BaseUrl = Sheets(cCfgShtName).Range("�x�[�XURL")
    
'    With oReq
'        .AddHeader "X-Redmine-API-Key", Sheets(cCfgShtName).Range("API�L�[")
'        .Resource = "issues.json"
'        .Method = WebMethod.HttpGet
'        .Format = WebFormat.Json
'        .AddQuerystringParam "project_id", Sheets(cCfgShtName).Range("�v���W�F�N�gID")
'    End With
'
'    Set oRes = oCli.Execute(oReq)


'    Dim Body As New Dictionary
'    Dim Issue As New Dictionary
'
'    Issue.Add "project_id", Sheets(cCfgShtName).Range("�v���W�F�N�gID")
'    Issue.Add "subject", "�Ă��Ƃw�w"
'    Issue.Add "status_id", "2"
'    Issue.Add "assigned_to_id", "testuser1"
'    Body.Add "issue", Issue
'
'    With oReq
'        .AddHeader "X-Redmine-API-Key", Sheets(cCfgShtName).Range("API�L�[")
'        .Resource = "issues.json"
'        .Method = WebMethod.HttpPost
'        .Format = WebFormat.Json
'        Set .Body = Body
'    End With
'
'    Set oRes = oCli.Execute(oReq)
'
'    Debug.Print oRes.Data("issues")(1)("subject")


'    Dim Body As New Dictionary
'    Dim Issue As New Dictionary
'
'    Issue.Add "status_id", "6"
'    Body.Add "issue", Issue
'
'    With oReq
'        .AddHeader "X-Redmine-API-Key", Sheets(cCfgShtName).Range("API�L�[")
'        .Resource = "issues/18424.json"
'        .Method = WebMethod.HttpPut
'        .Format = WebFormat.Json
'        Set .Body = Body
'    End With
'
'    Set oRes = oCli.Execute(oReq)
    
End Sub

