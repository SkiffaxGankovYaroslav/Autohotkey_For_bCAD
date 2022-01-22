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
    ;LV_Add("", proc.Name)
}
;MsgBox, %String2%
;~ PID := DllCall("GetCurrentProcessId")
;~ MsgBox, %PID%
;~ Process,Exist ,bCAD_XY_Ortho.exe
;~ MsgBox, %ErrorLevel%
;~ if (ErrorLevel=0)
;~ {
TrayTip, Hotkeys bCAD enable, Press F8 to pause hotkeys, 1
;~ SetTitleMatchMode, 1
;~ SetTitleMatchMode, Slow
SetTitleMatchMode, RegEx

Hotkey,~Break, LabelEnablebCAD

Hotkey, ~F3, LabelProstoAlt
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

Return

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
				ToolTip, TreeView не найдено
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
			If (A_ThisHotkey="~F7")
			{
				;ToolTip, F7
				;Sleep, 1000
				hItem=0
				if (findtext<>"")
					InputBox, findtext, Поиск, %fraza%,,200,100,,,,,%findtext%
				Else
					InputBox, findtext, Поиск, %fraza%,,200,100
				If (ErrorLevel)
					Return
			}
			if (findtext="")
			{
				ToolTip, Строка поиска пуста
				SetTimer, RemoveToolTip, -1000
				Return
			}
			else
			{
				loop, Parse, findtext, %A_Space%
				{
					;MsgBox, A_LoopField %A_LoopField%
					massivFraz[A_Index]:=A_LoopField
					;MsgBox, % massivFraz[A_Index]
				}
				couMassivFraz:=massivFraz.maxIndex()
				;парсим строку
			}
			
			ToolTip, %findtext%
			
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
				StringLower, ItemText, ItemText
				;StringLower, findtext1, findtext
				Naideno:=0
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
				
				if (Naideno=1)
				{
					MyTV.SetSelection(hItem)
					CoordMode, Mouse, Relative
					
					MouseMove, 105, YTree+10 ;перемещаем курсор в позицию дерева
					Sleep, 50
					Click
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
ToolTip, %findtext%. Не найдено
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
			if (A_ThisHotkey="~Down") ;если вниз, то перед значением нужно добавить знак "-"
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
			Send, 0 %znachenie% 0
			sleep, 50
			GoTo EnterPress
		}
	}
}

labelRight:
labelLeft:
currentHotkey:=A_ThisHotkey
;Sleep,500
If (isWindowbCAD())
{
	if (toolActive=false)
	{
		toolActive:=true
		;Key1:="X"
		SetTimer, OtobrazhenieVvoda, 20
		If (currentHotkey="~Left")
		{
			Napravlenie:="Влево"
			stroka:="-"
		}
		else
			If (currentHotkey="~Right")
			{
				Napravlenie:="Вправо"
				stroka:=""
			}
			else
				If (currentHotkey="~Up")
				{
					Napravlenie:="Верх"
					stroka:=""
				}
				else
					If (currentHotkey="~Down")
					{
						Napravlenie:="Вниз"
						stroka:="-"
					}
		
		;MyTimer:=0
		ChitaemDalee:
		SetTitleMatchMode, RegEx
		WinSet, Disable,, ahk_exe %Stringbcadexe%
		SetTitleMatchMode, 2
		SetTitleMatchMode, Slow
		MyTimer+=1
		;BlockInput, Off
		;ToolTip, Ждём ввода
		SetTimer, OtobrazhenieVvoda, On
		Input, dannieKlavi,L1 T0.6,{Enter}
		;~ WinGetTitle, titleWindow, A
		;~ If !InStr(titleWindow,"bCAD")
		;~ {
			;~ SetTimer, OtobrazhenieVvoda, Off
			;~ MsgBox, Error1okno
			;~ Return
		;~ }
		if (dannieKlavi<>"")
			stroka:=stroka dannieKlavi
		
		if (InStr(ErrorLevel,"EndKey")) Or (InStr(ErrorLevel,"Timeout")) ;если обнаружено такое, то завершаем
		{
			SetTimer, OtobrazhenieVvoda, Off
			SetTitleMatchMode, RegEx
			WinSet, Enable,, ahk_exe %Stringbcadexe%
			SetTitleMatchMode, 2
			SetTitleMatchMode, Slow
			if (stroka<>0) And (stroka<>"-0") And (stroka<>"-")
			{
				If (currentHotkey="~Left") Or (currentHotkey="~Right")
				{
					Xcoord:=stroka
					Ycoord:=0
				}
				else
					If (currentHotkey="~Up") Or (currentHotkey="~Down")
					{
						Xcoord:=0
						Ycoord:=stroka
					}
					else
					{
						ToolTip, currentHotkey %currentHotkey%
						MsgBox, какая-то ошибка
					}
				
				BlockInput,On
				Send,@
				Sleep,20
				Send,%Xcoord% %Ycoord%
				;ToolTip, Perehodim
				ToolTip
				Sleep,80
				BlockInput,Off
				GoTo EnterPress
			}
		}
		else
		{
				if (ErrorLevel="Max")
				{
					SetTimer, OtobrazhenieVvoda, Off
					;SetTimer, OtobrazhenieVvoda, Off
					;WinSet, Enable,, ahk_exe %StringbcadexeReg%
					GoTo ChitaemDalee
				}
				else
				{
					;BlockInput, Off
					ToolTip
					SetTimer, OtobrazhenieVvoda, Off
					SetTitleMatchMode, RegEx
					WinSet, Enable,, ahk_exe %Stringbcadexe%
					SetTitleMatchMode, 2
					SetTitleMatchMode, Slow
					return
				}
		}
	}
}
;BlockInput, Off
SetTimer, OtobrazhenieVvoda, Off
SetTitleMatchMode, RegEx
WinSet, Enable,, ahk_exe %Stringbcadexe%
SetTitleMatchMode, 2
SetTitleMatchMode, Slow
ToolTip
toolActive:=false
return

;~ OtobrazhenieVvoda1:
OtobrazhenieVvoda:
ToolTip, %Napravlenie%: %stroka%
WinGetTitle, titleWindow, A
If !InStr(titleWindow,"bCAD") ;если это не окно bCAD, то перезапускаем скрипт
{
;	SetTimer, OtobrazhenieVvoda, Off
	Reload
	ExitApp
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