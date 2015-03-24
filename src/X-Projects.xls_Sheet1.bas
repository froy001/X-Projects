'========================================================
' X-Projects v0.3.1 - Copyright (C) 2011 M.Nomura
'========================================================
' �ύX����
'  v0.1.0 �����o�[�W����
'  v0.2.0 ���t�v�Z���Ȃ��S����ǉ�
'  v0.2.1 �񓚗��ǉ��A���O�𐮗�
'  v0.2.2 �ݒ�V�[�g�ɐi����񗓂�ǉ�
'  v0.3.0 CCPM�Ή��A�S���ҏ󋵂Ɨ\��H��������ǉ�
'  v0.3.1 CCPM����Ȃ��i���Ǘ����o�b�N�|�[�g
'========================================================

'�ݒ�V�[�g��
Const cCfgShtName = "�ݒ�"
Const cYkrShtName = "�\��H������"

Dim nDayKosu       '�P���ƌv�Z����H��
Dim nDefKosu       '�����͎��̗\��H��
Dim sHolidayOfWeek '�x���̗j��
Dim sReCalcDate    '�Čv�Z����J�n���t

Private Sub btnMakeCsv_Click()

' **********************************
'              �����ݒ�
' **********************************

' �I�u�W�F�N�g�ϐ��̒�`
    Dim file_source As Object
    Dim file_target As Object

' �ۑ��t�@�C����������
    csv_file_name = ActiveWorkbook.Path + "\" + ActiveSheet.Name + ".csv"

' �����R�[�h���w��
    code_source = "Shift_JIS"
    code_target = "UTF-8"

' �u���������w��
    char_source = ","
    char_target = ";"

' �\������
    Application.DisplayAlerts = False
   

' **********************************
'          CSV�t�@�C���̕ۑ�
' **********************************
    
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

Private Sub btnCalcDate_Click()

    '�S���҂��ƁA���A���Ń\�[�g����
    '�ŏ��̊J�n������x�����l������
    '�\��H�����犄��o����������
    '�J�n���A�����������v�Z����
    
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
    
    '�\��H�������̍쐬
    If Sheets(cCfgShtName).Range("�\��H������").Value = "�쐬����" Then
        With Sheets(cYkrShtName)
           nYkrCol = .Range("�\��H�����𐗌^��").Column
            Do Until .Cells(1, nYkrCol).Value = ""
                nYkrCol = nYkrCol + 1
            Loop
            .Range("�\��H�����𐗌^��").Copy .Columns(nYkrCol)
            Columns(Range("No").Column).Copy .Columns(1)
            Columns(Range("�薼").Column).Copy .Columns(2)
            Columns(Range("�S����").Column).Copy .Columns(3)
            .Columns(nYkrCol).Value = Columns(Range("�\��H��").Column).Value
            .Cells(1, nYkrCol).Value = Format(Now, "yyyy/mm/dd")
            With .Range(.Columns(1), .Columns(nYkrCol))
                .AutoFilter
                .AutoFilter
            End With
        End With
    End If
    
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
    sDateGT = ""
    
    '�S���҃��X�g�擾
    Set oTantos = CreateObject("Scripting.Dictionary")
    
    arTantos = Range(Cells(2, nTantoCol), Cells(nLastRow, nTantoCol))
    
    For Each sTanto In arTantos
        If Not oTantos.Exists(sTanto) And Trim(sTanto) <> "" Then
            oTantos.Add sTanto, Null
        End If
    Next
    
    '�i���񍐓��Z�b�g
    Sheets(cCfgShtName).Range("�i���񍐓�").Value = Format(Now, "yyyy/mm/dd")
    Sheets(cCfgShtName).Range("�i���񍐓�2").Value = Format(Now, "yyyy/mm/dd")
    
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
                        
                        '�����̐ݒ�
                        sDate = WorkDateAdd(sDate, nDay)
                        Cells(i, nEDateCol) = sDate
                        sEDate = sDate
                        
                        '���̊J�n�����v�Z
                        If nYKosu <> 0 And nKosu = 0 Then
                            sDate = WorkDateAdd(sDate, 1)
                        End If
                        
                        '�S���Ҍv�A�����v�̌v�Z
                        nTKosuColST = nTKosuColST + nTKosu
                        nYKosuColST = nYKosuColST + nYKosu
                        nTKosuColGT = nTKosuColGT + nTKosu
                        nYKosuColGT = nYKosuColGT + nYKosu
                        
                    End If
                
                Else '���t�Čv�Z���Ȃ��S���҂̏ꍇ
                    
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
                .Value = Array(sTanto, sEDate, nTKosuColST, nYKosuColST, "", "", "")
                .Cells(1, 5).FormulaR1C1 = "=RC[-1]/�H���P��"
                .Cells(1, 6).FormulaR1C1 = "=RC[-1]/20"
                .Cells(1, 7).FormulaR1C1 = "=(RC[-3]/RC[-4]-1)*100"
            End With
            nTjOff = nTjOff + 1
        End With
        
        If sDateGT < sEDate Then sDateGT = sEDate
        
    Next

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
            .Cells(1, 5).FormulaR1C1 = "=RC[-1]/�H���P��"
            .Cells(1, 6).FormulaR1C1 = "=RC[-1]/20"
            .Cells(1, 7).FormulaR1C1 = "=(RC[-3]/RC[-4]-1)*100"
        End With
        nTjOff = nTjOff + 1
    End With

LOOP_EXIT:
    
    Range("�f�[�^").Sort _
        Key1:=Range("No"), Order1:=xlAscending, _
        Header:=xlGuess, OrderCustom:=1, MatchCase:=False, Orientation:=xlTopToBottom, SortMethod:=xlPinYin, _
        DataOption1:=xlSortNormal, DataOption2:=xlSortTextAsNumbers, DataOption3:=xlSortNormal
    
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

