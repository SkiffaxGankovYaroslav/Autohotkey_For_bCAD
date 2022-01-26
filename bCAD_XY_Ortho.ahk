doc := ComObjCreate("htmlfile")
doc.write("<meta http-equiv=""X-UA-Compatible"" content=""IE=9"">")


#NoEnv
#SingleInstance force
SetBatchLines -1
ListLines Off
SendMode Input

SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\Const_TreeView.ahk
#Include %A_ScriptDir%\Const_Process.ahk
#Include %A_ScriptDir%\Const_Memory.ahk
#Include %A_ScriptDir%\RemoteTreeViewClass.ahk

;переменные для XY_Ortho
hItem=0
findtext=""
ArrayWindowsWithTreeView:=[]
ArrayWindowsWithTreeView[1]:="Банк материалов"
ArrayWindowsWithTreeView[2]:="Сердцевина"
ArrayWindowsWithTreeView[3]:="Материал"
ArrayWindowsWithTreeView[4]:="Банк профилей"
ArrayWindowsWithTreeView[5]:="Крепеж и комплектующие"
ArrayWindowsWithTreeView[6]:="Вставка профилей"
ArrayWindowsWithTreeView[7]:="Лицевая"
ArrayWindowsWithTreeView[8]:="Тыльная"
ArrayWindowsWithTreeView[9]:="Основа"
couWWTV:=ArrayWindowsWithTreeView.MaxIndex()

found:=0
markerBezGroup:=true
vklucheno:=true
Stringbcad:="bCAD"
Stringbcadexe3:="b[cC][aA][dD].exe"
;Stringbcadexe3Reg:="bCAD.exe"
Stringbcadexe4:="bCAD1111"
Stringbcadexe:="b[cC][aA][dD]\.*"
dannieKlavi:=""
toolActive:=false

ZapomnitFindtext:=""
;код для Соответствия кромок
ToolTip, Загружаем файл соответствия кромки
FilenameIniSootvetstvieKromki:="\КромкаПоУмолчанию.ini"
FilenameIniSootvetstvieKromki:=A_ScriptDir FilenameIniSootvetstvieKromki
FileRead, tempBufferIni, %FilenameIniSootvetstvieKromki% ;считываем файл
if (ErrorLevel)
{
	MsgBox, ошибка чтения файла соответствия плит и кромки: %ErrorLevel%. Программа продолжает работу
}
MassivSootvetstviya:=[] ;массив оформлен в виде пар данных. Нечётные - это плита, чётные - это кромка для плиты
couMasSootv:=0
loop, parse, tempBufferIni, "`r`n"
{
		ToolTip, Читаем соответствие кромки из файла
		PosRazdelenie:=InStr(A_LoopField,";")
		if (PosRazdelenie) ;если этот символ есть, то значит это строка соответствия
		{
			;MsgBox, %A_LoopField%
			newline:="`r`n"
			strin1:=StrReplace(A_LoopField,newline)
			dlinaStroki:=StrLen(strin1)
			rightCount:=dlinaStroki-PosRazdelenie
			leftCount:=dlinaStroki-rightCount-1
			leftVal:=SubStr(strin1,1,leftCount)
			rightVal:=SubStr(strin1,PosRazdelenie+1,rightCount)
			loop ;удаляем пробелы в начале фразы (если они там есть)
			{
				firstSymb:=SubStr(rightVal,1,1)
				if (firstSymb=" ") ;если первый пробел, то удаляем его
				{
					rightVal:=SubStr(rightVal,2,StrLen(rightVal)-1)
				}
				else
					break
			}
			loop ;удаляем пробелы в начале фразы (если они там есть)
			{
				firstSymb:=SubStr(leftVal,1,1)
				if (firstSymb=" ") ;если первый пробел, то удаляем его
				{
					leftVal:=SubStr(leftVal,2,StrLen(leftVal)-1)
				}
				else
					break
			}
			;заполняем массив данными
			couMasSootv++
			MassivSootvetstviya[couMasSootv]:=leftVal
			couMasSootv++
			MassivSootvetstviya[couMasSootv]:=rightVal
		}
} ;конец чтения соответствия кромок
ToolTip, Чтение из файла завершено

counterPoiska:=0 ;счётчик кромки по умолчанию, увеличивается при нажатии F4. Используется для нахождения следующих кромок по умолчанию для конкретной плиты

SetKeyDelay, 1000, 0
for proc in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process")
{
	String1:=proc.Name
	foundpos:=InStr(String1,"bCAD_XY_Ortho")
;	String2:= String2 foundpos
	
	if(foundpos)
	{
		if (found>0)
		{
			ExitApp
		}
		found++
	}
}

TrayTip, Hotkeys bCAD enable, Press F8 to pause hotkeys, 1
SetTitleMatchMode, RegEx

Hotkey,~Break, LabelEnablebCAD

Hotkey, ~F3, LabelProstoAlt
Hotkey, ~F4, LabelProstoAlt
Hotkey, ~F7, LabelProstoAlt
;Hotkey, If, isWindowbCAD()
Hotkey, IfWinActive, ahk_exe %Stringbcadexe%
Hotkey, ~Left, labelLeft
Hotkey, ~Right, labelRight
Hotkey, ~Up, labelUp
Hotkey, ~Down, labelDown
Hotkey, ~x, LabelX
;Hotkey, IfWinActive, ahk_exe %Stringbcadexe%
Hotkey, ~y, LabelY

;Hotkey, IfWinActive, ahk_exe %Stringbcadexe%
Hotkey, ~+2, Labelkavychki

;Hotkey, IfWinActive, ahk_exe %Stringbcadexe%
Hotkey, Enter, EnterPress

;Hotkey, IfWinActive, ahk_exe %Stringbcadexe%
Hotkey, NumpadEnter, EnterPress

;Hotkey, IfWinActive, ahk_exe %Stringbcadexe%
Hotkey, ~Tab, LabelTab

;Hotkey, IfWinActive, ahk_exe %Stringbcadexe%
Hotkey, ~F8, LabelF8

Hotkey, IfWinActive, ahk_exe %Stringbcadexe3%
Hotkey, !^x, LabelCtrlAltx

Hotkey, ~RButton, LabelRClick

;Hotkey, IfWinActive, ahk_exe %Stringbcadexe%
Hotkey, ~Esc, LabelEsc

;~ Hotkey, IfWinActive, ahk_exe %Stringbcadexe%


;Hotkey, IfWinActive, ahk_exe %Stringbcadexe%
Hotkey, ~Alt & RButton, LabelAlt

;Hotkey, IfWinActive, ahk_exe %Stringbcadexe%
Hotkey, ~q, LabelQ

;Hotkey, IfWinActive, ahk_exe %Stringbcadexe%
Hotkey, ~w, LabelW

;Hotkey, IfWinActive, ahk_exe %Stringbcadexe%
Hotkey, r, LabelR

;Hotkey, IfWinActive, ahk_exe %Stringbcadexe%
Hotkey, a, LabelA

;Hotkey, IfWinActive, ahk_exe %Stringbcadexe%
Hotkey, ~s, LabelS

;Hotkey, IfWinActive, ahk_exe %Stringbcadexe%
Hotkey, ~d, LabelD

;Hotkey, IfWinActive, ahk_exe %Stringbcadexe%
Hotkey, ~v, LabelV

;Hotkey, IfWinActive, ahk_exe %Stringbcadexe%
Hotkey, ~c, Labelc

;Hotkey, IfWinActive, ahk_exe %Stringbcadexe%
Hotkey, ~m, LabelM

;Hotkey, IfWinActive, ahk_exe %Stringbcadexe%
Hotkey, ~z, LabelZ

;Hotkey, IfWinActive, ahk_exe %Stringbcadexe%
Hotkey, ~b, LabelB

;Hotkey, IfWinActive, ahk_exe %Stringbcadexe%
Hotkey, ~e, LabelE


SetTitleMatchMode, RegEx
Hotkey, IfWinActive, ahk_exe %Stringbcadexe%
Hotkey,~^f, LabelCtrlShiftA

;Hotkey, IfWinActive, ahk_exe %Stringbcadexe%
Hotkey,~^t Up, LabelCtrlShiftA

;Hotkey, IfWinActive, ahk_exe %Stringbcadexe%
Hotkey,~^l, LabelCtrlShiftA

;Hotkey, IfWinActive, ahk_exe %Stringbcadexe%
Hotkey,~^b, LabelCtrlShiftA

;Hotkey, IfWinActive, ahk_exe %Stringbcadexe%
Hotkey,~^r, LabelCtrlShiftA

;создаём список окон, где будет действовать ускоренный ввод
ArrayWin := []
ArrayWin[1]:="Первая точка"
ArrayWin[2]:="Расположение базовой точки"
ArrayWin[3]:="Базовая точка"
ArrayWin[4]:="Вторая точка"
ArrayWin[5]:="Новое положение базовой точки"
ArrayWin[6]:="Другой угол прямоугольника"

ArrayWinFirstPoint:=4
counterArr:=ArrayWin.MaxIndex()

ArrayAlterWin := []
ArrayAlterWin[1]:="Радиус"

counterAlterArr:=ArrayAlterWin.MaxIndex()


SetTimer, LoopDoska, 1000

Return
;конец кода инициализации программы. Ниже - обработчики Hotkey

LabelX:
;MsgBox, ololo1
if (isWindowbCAD())
{
	Send, {Backspace}
	Send, @X 0 0
	Send, {Enter}
}
Return

LabelY:
if (isWindowbCAD())
{
	Send, {Backspace}
	Send, @0 Y 0
	Send, {Enter}
}
Return

Labelkavychki:
if (isWindowbCAD())
{
	Send, {Backspace}
	Send, @
}
Return

;нажатие Энтер
EnterPress:
;MsgBox, ololo enter
SetTitleMatchMode, 1
SetTitleMatchMode, fast
sleepTime:=1
WinFirstPoint:=0
;MsgBox, vhod %counterArr%
loop, %counterArr%
{
	needle:=ArrayWin[A_Index]
	IfWinActive, %needle%
	{
		;MsgBox, % ArrayWin[A_Index]
		if (A_Index<ArrayWinFirstPoint)
		{
			WinFirstPoint:=1
		}
		foundSymb:=0
		;MsgBox, needle %needle%
		controlNeed:="Edit1"
		ControlGetText, textOutput, %controlNeed%
		;sleep, 1000
		;MsgBox, WinFirstPoint %WinFirstPoint%
		if (WinFirstPoint=1)
		{
			Send, {End}
			;sleep, sleepTime
			Send, +{Home}
			;sleep, sleepTime
			stroka1:="0 0"
			;MsgBox, stroka %stroka1%
			sleep, sleepTime
			Send, %stroka1%
			;sleep, 1000
			Send, {Enter}
			WinWaitClose, %needle%,, 1
		}
		;MsgBox, %textOutput%
		firstSymbol:=SubStr(textOutput,1,1)
		;если введена одна координата (без пробела)
		if (InStr(textOutput," ")=0)
		{
			;~ MsgBox, res %textOutput%
			;~ try res := doc.parentWindow.eval(textOutput)
			;~ catch {
			  ;~ MsgBox, Формула не распознана
			  ;~ Return
			;~ }
			;~ ;GuiControl, Focus, Edit1
			;~ res := RegExReplace(res, "\.(0+|(0*[^0]+)*\K0+)$")
			;~ MsgBox, res %res%
			;~ ;SendInput, {End}{Text} = %res%
			
			;~ textOutput:=res
			textOutput:=textOutput " 0"
		}
		else
		{
			foundSymb++
		}
		
		if (firstSymbol="@")
			textOutput:=StrReplace(textOutput,"@","")
		
		;преобразование арифметических действий
		NewTextOutput:=""
		loop, Parse, textOutput, %A_Space%
		{
			;MsgBox, A_LoopField %A_LoopField%
			
			try res := doc.parentWindow.eval(A_LoopField)
			catch {
			  MsgBox, Формула не распознана
			  Return
			}
			;GuiControl, Focus, Edit1
			res := RegExReplace(res, "\.(0+|(0*[^0]+)*\K0+)$")
			;MsgBox, res %res%
			
			if (A_Index=1)
				NewTextOutput:=res
			else
				NewTextOutput:=NewTextOutput A_Space res
		}
		
		NewTextOutput:="@" NewTextOutput
		;MsgBox, NewTextOutput %NewTextOutput%
		
		
		;~ if (firstSymbol<>"@")
		;~ {
			;~ NewTextOutput:="@" NewTextOutput
		;~ }
		;~ else
		;~ {
			;~ foundSymb++
		;~ }
		
		if (foundSymb<>2)
		{
			if (WinFirstPoint<>1)
			{
				;sleep, sleepTime
				Send, {End}
				;sleep, sleepTime
				Send, +{Home}
				;sleep, sleepTime
			}
			Send, %NewTextOutput%
			;sleep, sleepTime
			GoTo zavershenie
		}
	}
	else ;если это другое окно
	{
		controlNeed:="Edit1"
		ControlGetText, textOutput, %controlNeed%
		loop, %counterAlterArr%
		{
			needle:=ArrayAlterWin[A_Index]
			IfWinActive, %needle%
			{
			try res := doc.parentWindow.eval(textOutput)
			catch {
			  MsgBox, Формула не распознана
			  Return
			}
			;GuiControl, Focus, Edit1
			res := RegExReplace(res, "\.(0+|(0*[^0]+)*\K0+)$")
			Send, {End}
			;sleep, sleepTime
			Send, +{Home}
			;sleep, sleepTime
			Send, %res%
			GoTo zavershenie
			}
		}
	
		
	}
}
zavershenie:
Send, {Enter}
toolActive:=false
Return

labelTab:
;msgBox, vhod
loop, %counterArr%
{
	needle:=ArrayWin[A_Index]
	IfWinActive, %needle%
	{
		Send, +{Tab}
		Send, {End}
		Send, {Space}
		Return
	}
}

;~ Send, {Tab}
;msgBox, vyhod
Return


LabelF8:
if (vklucheno=true)
{
	SetTitleMatchMode, 2
	SetTitleMatchMode, Slow
	TrayTip
	if SubStr(A_OSVersion,1,3) = "10." {
        Menu Tray, NoIcon
        Sleep 10  ; It may be necessary to adjust this sleep.
        Menu Tray, Icon
    }
	TrayTip, Disable, Hotkeys bCAD disable, 5, 1
	;TrayTip, Disable, Hotkeys bCAD disable until F8, 5
	;MsgBox, vklu false
	vklucheno:=false
	Hotkey, IfWinActive, ahk_exe %Stringbcadexe%
	Hotkey, x, Off
	Hotkey, y, Off
	Hotkey, +2, Off
	Hotkey, ~Left, Off
	Hotkey, ~Right, Off
	Hotkey, ~Up, Off
	Hotkey, ~Down, Off
	tempVar:= WinExist("ahk_exe" Stringbcadexe3)
	If (tempVar)
	{
		Hotkey, IfWinActive, ahk_exe %Stringbcadexe3%
		Hotkey, !^x, Off
		Hotkey, RButton, Off
		Hotkey, Esc, Off
		Hotkey, Alt & RButton, Off
		Hotkey, q, Off
		Hotkey, w, Off
		Hotkey, r, Off
		Hotkey, a, Off
		Hotkey, s, Off
		Hotkey, d, Off
		Hotkey, v, Off
		Hotkey, c, Off
		Hotkey, m, Off
		Hotkey, z, Off
		Hotkey, b, Off
		Hotkey, e, Off

	}
	;Sleep, 1000
}
else
{
	;MsgBox, vklu true
	TrayTip
	if SubStr(A_OSVersion,1,3) = "10." {
        Menu Tray, NoIcon
        Sleep 10  ; It may be necessary to adjust this sleep.
        Menu Tray, Icon
    }

	TrayTip, Enable, Hotkeys bCAD enable, 5
	vklucheno:=true
	Hotkey, IfWinActive, ahk_exe %Stringbcadexe%
	Hotkey, x, On
	Hotkey, y, On
	Hotkey, +2, On
	Hotkey, ~Left, On
	Hotkey, ~Right, On
	Hotkey, ~Up, On
	Hotkey, ~Down, On
	tempVar:=% WinExist("ahk_exe" Stringbcadexe3)
	If (tempVar)
	{
		Hotkey, IfWinActive, ahk_exe %Stringbcadexe3%
		Hotkey, !^x, On
		Hotkey, ~RButton, On
		Hotkey, ~Esc, On
		Hotkey, ~Alt & RButton, On
		Hotkey, q, On
		Hotkey, w, On
		Hotkey, r, On
		Hotkey, a, On
		Hotkey, s, On
		Hotkey, d, On
		Hotkey, v, On
		Hotkey, c, On
		Hotkey, m, On
		Hotkey, z, On
		Hotkey, b, On
		Hotkey, e, On
		
	}
	
	;Sleep, 100
}
Return

LabelCtrlAltx:
Sleep, 10
SetKeyDelay, 1, 0
WinActivate, %Stringbcad%
Send, {Alt}
Send, {Right 4}
Send, {Down 2}
Send, {Right}
;Sleep, 50
Send, {Esc 3}
VarSetCapacity(Name, 256, 0)
;проверка состояния флажка
WinGet,hWin,ID,%Stringbcad%
hMenu:=DllCall("GetMenu", "UInt", hWin)
hSubMenu:=DllCall("GetSubMenu", "UInt", hMenu, "UInt", 4)
hSubMenu:=DllCall("GetSubMenu", "UInt", hSubMenu, "UInt", 1)
index:=7
DllCall("GetMenuString", "UPtr"
			, hSubMenu, "UInt", index, "Str", Name, "Int", 128, "UInt", 0x400)
hSubMenu111:=DllCall("GetMenuState", "UInt", hSubMenu, "UInt", index, "UInt", 0x400)
;MsgBox, %hSubMenu111%
if (hSubMenu111&0x2) || (hSubMenu111&0x1)
{
	markerBezGroup:=false
}
if (markerBezGroup=false)
{
	;MsgBox, true ept %Name%
	;Send, !^x
}
else
{
	;MsgBox, false ept %Name%
	Send, ^g
	markerBezGroup:=false
	;Send, !^x
}
Send, !^x
Return

LabelAlt:
;MsgBox, ololo
RbuttonState:=GetKeyState("RButton","P")
;ToolTip, %RbuttonState%
if (RbuttonState)
{
	napravlenie:=""
	MouseGetPos, mouseX1, mouseY1

	vtoriekoordinaty:
	RbuttonState:=GetKeyState("RButton","P")
	;if (RbuttonState)
	;	GoTo vtoriekoordinaty
	;sleep, 3000
	
	

}
else
{
	
}
getAlt:
StateAlt:=GetKeyState("Alt","P")
If (stateAlt)
	Goto getAlt

Sleep,10
MouseGetPos, mouseX2, mouseY2
difX21:=mouseX2-mouseX1
difY21:=mouseY2-mouseY1
;MsgBox, %difX21% %difY21%
;определяем, по какой оси было больше перемещение
if (Abs(difX21)>Abs(difY21))
{
;MsgBox, %mouseX2% %mouseY2%
		if (difX21>0) ;смещение вправо
		{
			napravlenie:="right"
			;Goto LabelCtrlShiftA
		}
		else ;смещение влево
		{
			napravlenie:="left"
			;Goto LabelCtrlShiftA
		}
}
else
{
	if (difY21>0) ;смещение вниз
		{
			napravlenie:="down"
			;Goto LabelCtrlShiftA
		}
		else ;смещение вверх
		{
			napravlenie:="up"
			;Goto LabelCtrlShiftA
		}
	
}

if (InStr(napravlenie,"right"))
{
	Send, ^r
	Goto LabelCtrlShiftA
}
else if (InStr(napravlenie,"left"))
{
	Send, ^l
	Goto LabelCtrlShiftA
}
else if (InStr(napravlenie,"up"))
{
	Send, ^t
	Goto LabelCtrlShiftA
}
else if (InStr(napravlenie,"down"))
{
	Send, ^f
	Goto LabelCtrlShiftA
}
else
{
}
;MsgBox, napravlenie %napravlenie% %difX21% %difY21%

Return

LabelF3:
LabelProstoAlt:
;ToolTip, Alt
;Sleep, 500
SetTitleMatchMode, RegEx
If WinExist("ahk_exe" Stringbcadexe)
;if (isWindowbCAD())
{
;	ToolTip, bCAD Exist

	sleepTime:=1
	WinFirstPoint:=0
	
	WinId := WinActive("A")
			SetTitleMatchMode, 1
			SetTitleMatchMode, fast
			;MsgBox, "WinActiveID: " %WinId% %needle%
			controlNeed:="WFC.SysTreeView321"
			ControlGet TVId, Hwnd,,%controlNeed%, % "ahk_id " WinId
			if (ErrorLevel)
			{
				PrintString:="TreeView не найдено"
				if ((tooltipstring<>"") And (tooltipstring<>"-1")) ;если соответствие не пусто, то выводим соответствие
					PrintString:=tooltipstring
				ToolTip, %PrintString%
				SetTimer, RemoveToolTip, -1000
				Return
				;MsgBox, Ошибка. TreeView не найден
			}
			ControlGetPos, XTree, YTree,,,%controlNeed%,% "ahk_id " WinId
			;MsgBox, XTree %XTree% YTree %YTree%
			MyTV := new RemoteTreeView(TVId)
			;MsgBox, ololo
			;MsgBox, A_ThisHotkey %A_ThisHotkey%
			massivFraz:=[]
			fraza:="Фраза или ключевые слова через пробел. Можно ввести часть слова или часть фразы. Поиск ищет вхождение всех слов (в любой последовательности). Поиск не чувствителен к регистру. При нажатии F7 поиск производится с начала дерева. При нажатии F3 поиск производится с последней найденной позиции до конца дерева"
			If (A_ThisHotkey="~F7") ;если Hotkey F7, то вводим данные. Если Hotkey любой другой, то данные не вводим
			{
				;ToolTip, F7
				;Sleep, 1000
				If (ZapomnitFindtext<>"")
				{
					findtext:=ZapomnitFindtext
				}
				hItem:=0 ;будем вести поиск с начала дерева
				if (findtext<>"")
					InputBox, findtext, Поиск, %fraza%,,200,100,,,,,%findtext% ;просим пользователя ввести искомую фразу
				Else
					InputBox, findtext, Поиск, %fraza%,,200,100
				If (ErrorLevel)
					Return
				ZapomnitFindtext:=findtext
				ToolTip, %findtext%
			}
			else
			{
				if (A_ThisHotkey="~F4") ;если F4
				{
					counterPoiska++
					UBound:=massivSootvetstvieKromki.maxIndex()
					if (counterPoiska>UBound) ;если счётчик кромки по умолчанию меньше длины массива, то переходим к соответствующему значению в массиве
						counterPoiska:=1
					findtext:=massivSootvetstvieKromki[counterPoiska]
					hItem:=0 ;будем всегда искать с начала дерева
					
					;~ if ((findtextPublic<>"") And (findtextPublic<>"-1")) ;проверка на пустую строку
						;~ findtext:=findtextPublic
					if ((findtext<>"") And (findtext<>"-1")) ;проверка на пустую строку
						ToolTip, %tooltipstring%
					else
					{
						ToolTip, Кромки соответствия не найдено
						Sleep, 500
						Return
					}
				}
				;else
					;ToolTip, %findtext%
			}
			
			findtextNoLower:=findtext
			findtext:=StrReplace(findtext,"х","x") ;заменяем русскую х на английскую х
			StringLower, findtext, findtext
			
			if (findtext="") ;если искомая фраза пуста, то ничего не ищем
			{
				ToolTip, Строка поиска пуста
				SetTimer, RemoveToolTip, -1000
				Return
			}
			else
			{
				loop, Parse, findtext, %A_Space% ;парсим искомую строку строку на отдельные части для поиска. Разделителями являются пробелы
				{
					massivFraz[A_Index]:=A_LoopField
				}
				couMassivFraz:=massivFraz.maxIndex()
				
			}
			
			
			
			;hItem = 0  ; Causes the loop's first iteration to start the search at the top of the tree.
			Loop
			{
				previoushItem:=hItem
				hItem := MyTV.GetNext(hItem, "Full")
				if not hItem  ; No more items in tree.
				{
					ToolTip, %findtext% . Конец дерева
					SetTimer, RemoveToolTip, -1000
					break
				}
				ItemText := MyTV.GetText(hItem)
				ItemText:=StrReplace(ItemText,"х","x") ;заменяем русскую х на английскую х
				StringLower, ItemText, ItemText
				;StringLower, findtext1, findtext
				Naideno:=0
				If (A_ThisHotkey="~F4")
				{
					If (InStr(ItemText,findtext)) ; при Hotkey F4 важно соответствие фразы
						Naideno:=1
					else
						Naideno:=0
				}
				Else ;при любой другой Hotkey (не F4) проводим проверку на соответствие каждого из слов
				{
					Loop, %couMassivFraz%
					{
						findtext1:=massivFraz[A_Index]
						StringLower, findtext1, findtext1
						if (InStr(ItemText,findtext1))
						{
							Naideno:=1
							if (previoushItem>=hItem)
							{
							;	ToolTip, %findtext% . Поиск начат сначала
								;SetTimer, RemoveToolTip, -1000
								;Return
							}
						}
						else
						{
							Naideno:=0
							break
						}
					}
				}
				
				if (Naideno=1)
				{
					MyTV.SetSelection(hItem)
					CoordMode, Mouse, Screen
					MouseGetPos, OutputVarX, OutputVarY ;считываем координаты мыши (потом вернём её в них)
					CoordMode, Mouse, Relative
					MouseMove, 105, YTree+10 ;перемещаем курсор в первую позицию дерева
					Sleep, 50
					Click
					CoordMode, Mouse, Screen
					MouseMove, OutputVarX, OutputVarY ;возвращаем курсор в исходное положение
					Click, WheelUp
					
					if (ololo<>hItem) ;если найденная ячейка не выделена сейчас, то пытаемся её выделить
					{
						loop, 100
						{
							Sleep, 10
							ololo:=MyTV.GetSelection()
							;ItemText := MyTV.GetText(ololo)
							
							if (ololo=hItem)
							{
								;MsgBox, naideno
								SetTimer, RemoveToolTip, -1000
								Return
							}
							else
							{
								ControlFocus, %controlNeed%, % "ahk_id " WinId
								Send, {Down}
							}
						}
					}
					
					
					
					SetTimer, RemoveToolTip, -1000
					;MsgBox, SetSelection
					Return
					;~ If (ErrorLevel)
						;~ MsgBox, Error %ErrorLevel%
				}
			}
			
		;~ }
	;~ }
ToolTip, %findtextNoLower%. Не найдено
counterPoiska:=0
SetTimer, RemoveToolTip, -1000
}
Return


LabelEsc:
LabelRClick:
;MsgBox, Rclick %markerBezGroup%
if (isWindowbCAD())
{
	if (markerBezGroup=false)
	{
		;MsgBox, Enter
		Send, ^g
		markerBezGroup=true
	}
}

Return

LabelQ:
if (isWindowbCAD())
{
	WinMenuSelectItem, %stringbCAD%,,Правка,Пометить
}

LabelW:
if (isWindowbCAD())
{
	WinMenuSelectItem, %stringbCAD%,,Правка,Снять пометку
}
Return

LabelR:
if (isWindowbCAD())
{
	WinMenuSelectItem, %stringbCAD%,,Инструменты,Трансформации,Повернуть
}
else
	Send, к
Return

LabelA:
if (isWindowbCAD())
{
	WinMenuSelectItem, %stringbCAD%,,Инструменты,Трансформации,Переместить
}
else
	Send, ф
Return

LabelS:
if (isWindowbCAD())
{
	WinMenuSelectItem, %stringbCAD%,,Инструменты,Трансформации,Копировать
}
Return

LabelD:
if (isWindowbCAD())
{
	WinMenuSelectItem, %stringbCAD%,,Инструменты,Трансформации,Сдвиг
}
Return

LabelV:
if (isWindowbCAD())
{
	WinMenuSelectItem, %stringbCAD%,,Инструменты,Измерения,Вертикальный размер
}
Return

LabelC:
if (isWindowbCAD())
{
	WinMenuSelectItem, %stringbCAD%,,Инструменты,Измерения,Горизонтальный размер
}
Return

LabelM:
if (isWindowbCAD())
{
	WinMenuSelectItem, %stringbCAD%,,Инструменты,Трансформации,Зеркально отразить
}
Return

LabelZ:
if (isWindowbCAD())
{
	WinMenuSelectItem, %stringbCAD%,,Инструменты,Установки редактора,Масштабирование области
}
Return

LabelB:
if (isWindowbCAD())
{
	WinMenuSelectItem, %stringbCAD%,,Инструменты,Трансформации,Собрать в группу
}
Return

LabelE:
if (isWindowbCAD())
{
	WinMenuSelectItem, %stringbCAD%,,Инструменты,Трансформации,Разделить группу
}
Return

LabelCtrlShiftA:
{
	wait1:
	KeyIsDown := GetKeyState("Ctrl","P")
	If (KeyIsDown)
		Goto wait1
	;Sleep, 1
	Sleep, 1
	SetKeyDelay, 0, 0
	Send, ^+a
	Sleep, 10
	Click, WD
	;WinMenuSelectItem, %stringbCAD%,,Инструменты,Установки редактора,Уменьшить на 10`%
	;Sleep, 1000
}
Return


isWindowbCAD()
{
	ID:=WinActive()
	WinGet, WinExeName, ProcessName, ahk_id %ID%
	if (InStr(WinExeName,"bCAD."))
	{
		;MsgBox, WinExeName %WinExeName%
		WinGetTitle, name1, ahk_id %ID%
		;MsgBox, name1 %name1%		
		if (InStr(name1,"bCAD"))
		{
			;ToolTip, bCAD
			return true
		}
		else
		{
			;ToolTip, NOT bCAD
			return false
		}
	}
}

RemoveToolTip:
ToolTip
return

labelDown:
labelUp:
labelLeft:
labelRight:
;проверяем, в каком мы окне
loop, %counterArr%
{
	needle:=ArrayWin[A_Index]
	IfWinActive, %needle%
	{
		;запоминаем значение
		controlNeed:="Edit1"
		ControlGetText, znachenie, %controlNeed%
		;проверяем значение
		if (!InStr(znachenie," ")) ;если нет пробелов, то введёная координата одна и с ней можно работать дальше
		{
			
			znachenie:=StrReplace(znachenie,"@","") ;перезаписываем значение, если оно не такое, как нужно
			if (A_ThisHotkey="~Down") Or (A_ThisHotkey="~Left") ;если вниз, то перед значением нужно добавить знак "-"
			{
				firstSymbol:=SubStr(znachenie,1,1)
				if (firstSymbol=" ")
				{
					znachenie:=SubStr(znachenie,2,StrLen(znachenie)-1)
					firstSymbol:=SubStr(znachenie,1,1)
					MsgBox, znachenieBezProbela %znachenie%
				}
				
				if (firstSymbol<>"-")
				{
					znachenie:="-"znachenie
				}
			}
			;MsgBox, znachenie %znachenie%
			Send, {End}
			;sleep, sleepTime
			Send, +{Home}
			sleep, 50
			;MsgBox, stroka %stroka1%
			if (A_ThisHotkey="~Down") Or (A_ThisHotkey="~Up")
				Send, 0 %znachenie% 0
			else
				Send, %znachenie% 0 0
			
			sleep, 50
			GoTo EnterPress
		}
	}
}
Return

LabelEnablebCAD:
ID1:=WinExist("ahk_exe" Stringbcadexe)
if (ID1<>0)
{
	SetTitleMatchMode, RegEx
	WinSet, Enable,, ahk_exe %Stringbcadexe%
	SetTitleMatchMode, 2
	SetTitleMatchMode, Slow
	Reload
	ExitApp
}
Return

LoopDoska:
cou2:=0
WindowProstaDoska:="Простая доска"
loop ; бесконечный цикл ожидания окна Простая Доска и обработки
{
	SetTitleMatchMode, RegEx
	IDwindow:= WinExist("ahk_exe" Stringbcadexe) ;если bCAD запущен, то проводим доп.проверку
	if (IDwindow<>0)
	{
		cou2++
		SetTimer, RemoveToolTip, -100
		SetTitleMatchMode, 1
		SetTitleMatchMode, slow
		WinWait, %WindowProstaDoska%
		WinWaitActive,%WindowProstaDoska%
		;читаем данные с кнопки Сердцевина
		;WinActivate, ahk_id %IDwindow%
		controlNeed:="WFC.BUTTON10" ;считываем данные с названия Сердцевины плиты
		ControlGetText, Serdcevina, %controlNeed%, A
		if (ErrorLevel)
		{
			ToolTip, Данные не распознаны
			SetTimer, RemoveToolTip, -1000
			Return
		}
		;отсекаем часть, если в наименовании Сердцевины указан путь
		PosSlash:=InStr(Serdcevina,"\")
		if (PosSlash)
		{
			Serdcevina:=SubStr(Serdcevina,PosSlash+1,StrLen(Serdcevina)-PosSlash)
			;MsgBox, Serdcevina %Serdcevina%
		}
		
		;ищем название плиты среди базы (которая была загружена из файла)
		kolvoSootvetstviy:=couMasSootv/2
		naideno:=false
		loop, %kolvoSootvetstviy%
		{
			;MsgBox, % MassivSootvetstviya[A_Index*2-1] ":" Serdcevina
			if (MassivSootvetstviya[A_Index*2-1]=Serdcevina) ;если сердцевина найдена, то записываем соответствующее значение для кромки
			{
				SootvetstvieKromki:=MassivSootvetstviya[A_Index*2]
				;MsgBox, Serdcevina %Serdcevina% naideno %SootvetstvieKromki%
				naideno:=true
			}
		}
		
		If (naideno=false) ;если ничего не найдено, то прекращаем работу
		{
			;MsgBox, Соответствие не найдено
			ToolTip, Соответствие кромки не найдено
			massivSootvetstvieKromki:=[]
			findtextPublic:="-1"
			SetTimer, RemoveToolTip, -1200
			;Sleep, 500
			;return
		}
		else
		{
			;ToolTip, %SootvetstvieKromki%
			;парсим соответствие
			
			massivSootvetstvieKromki:=[]
			tooltipstring:=""
			;MsgBox, % massivSootvetstvieKromki.maxIndex()
			NewLine:="`n"
			loop, Parse, SootvetstvieKromki, ";"
			{
				massivSootvetstvieKromki[A_Index]:=A_LoopField
				if (tooltipstring<>"")
					tooltipstring:=tooltipstring NewLine ;добавляем новую линию
				tooltipstring:=tooltipstring A_LoopField
				;tooltipstring+="`n"
				;~ ToolTip, % massivSootvetstvieKromki[A_Index]
				
			}
			ToolTip,%tooltipstring%
			;MsgBox, % massivSootvetstvieKromki.maxIndex()
			
			findtextPublic:=SootvetstvieKromki
			SetTimer, RemoveToolTip, -1200
		}
		
		;MsgBox, SootvetstvieKromki %SootvetstvieKromki%
		;BlockInput, On
		;CoordMode, Mouse, Relative
		;Sleep, 100
		;Click, 158 45
		
		SetTitleMatchMode, 1
		;IDwindowDoska:=WinExist("A")
		;controlNeed:="WFC.Window.812"
		;ControlGetPos, PosX, PosY, ControlWidth, ControlHeight, %controlNeed%, ahk_id %IDwindowDoska%

		;MsgBox, PosX %PosX%
		;PosAllKromkaX:=PosX+ControlWidth/2
		;PosAllKromkaY:=PosY+ControlHeight/2
		WinWaitNotActive, %WindowProstaDoska%
		;~ MsgBox, ololo1
		;~ WinWaitClose, %WindowProstaDoska%
		;~ MsgBox, ololo2
	}
}
Return