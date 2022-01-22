;MouseGetPos, xpos, ypos 

secondsTip:=1
SetdefaultMouseSpeed 1

SetTitleMatchMode, 1
SetTitleMatchMode, fast
stringbCAD:="bCAD"
Stringbcadexe:="bCAD.exe"
Stringbcadexe3:="bCAD.exe"
;Stringbcadexe3Reg:="bCAD.exe"
Stringbcadexe4:="bCAD1111"
StringbcadexeReg:="bCAD.*"
XImage:=0
YImage:=0
SetTitleMatchMode, RegEx
IfWinExist, ahk_exe %StringbcadexeReg%
{
	;сохраняем backup
	;~ WinMenuSelectItem,%stringbCAD%,,Файл,Сохранить как
	;~ WinWait, Сохранить как
	;~ WinActivate, Сохранить как
	;~ Send, D:\1.bdf
	;~ Send, {Enter}	
	
	;~ WinWait, Подтвердить сохранение, , 2
	;~ IfWinExist, Подтвердить сохранение
	;~ {
		;~ Send, {Tab}
		;~ Send, {Enter}
		;~ WinWaitClose, Подтвердить сохранение
	;~ }
	
	CoordMode, Mouse, Screen
	waittime:=1
	waittimewindow:=4
	
	;WinSet, Enable,, %stringbCAD%
	TrayTip, АвтоСдвиг, Кликайте мышкой в точках сдвига - слева-направо, 2
	SetTitleMatchMode, RegEx
	WinActivate, ahk_exe %StringbcadexeReg%
	WinGet, IDbCAD, ID, A ;получаем ID окна и потом используем его
	
	WinGetPos, Xwindow, Ywindow, WidthScreen, HeightScreen, ahk_id %IDbCAD% ;считываем размер окна, чтобы не выходить за его пределы
	SetTitleMatchMode, 2
	SetTitleMatchMode, Fast	
	
;Msgbox, Текущие координаты курсора: X%xpos% Y%ypos%. 

;KeyWait, LButton, D

;~ CtrlC := Chr(3) ; Store the character for Ctrl-C in the CtrlC var.
;~ Input, OutputVar, L1 M
;~ if (OutputVar = CtrlC)
    ;~ MsgBox, You pressed Control-C.
;~ ExitApp

;Input, SingleKey, L1

;ExitApp

; Gui, MyGui:Color, White
; Gui MyGui:-Caption
; Gui MyGui:+LastFound
; WinSet, TransColor, White
; Gui, MyGui:Show, % "x" Xwindow " y" Ywindow " h" HeightScreen " w" WidthScreen, New GUI Window
dlina_linii:=50 ;длина рисуемых линий на экране
shirina_linii:=1


Gui, cursor:Color, C0C0C0  ;вертикальная серая линия, следующая за курсором
Gui, cursor:-Caption
Gui, cursor:+ToolWindow
Gui, cursor:Show, % "x" Xwindow " y" Ywindow " h" HeightScreen " w" shirina_linii

Gui, cursorHor:Color, C0C0C0  ;вертикальная серая линия, следующая за курсором
Gui, cursorHor:+ToolWindow
Gui, cursorHor:-Caption
Gui, cursorHor:Show, % "x" Xwindow " y" Ywindow " h" shirina_linii " w" WidthScreen

 
#Persistent
MousePositions:=[]
tempString:=""
counterMassiv:=1
couClick:=0
;CoordMode, Mouse, Screen
SetTimer, WatchCursor, 10
cou111:=0
zaderzhkaSplash:=20
zaderzhkaSplash2:=zaderzhkaSplash/2
Ymin:=9999
Ymax:=0
YminCou:=0
YmaxCou:=0
Xmin:=9999
Xmax:=0
XminCou:=0
XmaxCou:=0
Stroka:=""
couWinLines:=0
keyEnter=Chr(`n)
SetTitleMatchMode, RegEx
WinSet, Disable,, ahk_exe %StringbcadexeReg%
SetTitleMatchMode, 2
SetTitleMatchMode, Fast	

proverkaDalee:
;KeyWait, LButton, D
;MsgBox, eeeee
KeyWait, Tab, D

if (counterMassiv<3)
	{
		Stroka:="Мало координат. Нужно ввести ещё координаты"
		Goto proverkaDalee
	}
;~ Input, SingleKey, L1 M B
;~ if (SingleKey="`n")
;~ {
	Stroka:=""
inputLabel:
if (StringRoundIterationSmeshenie)
{
	Gui, Destroy
}
Gui, cursor:Destroy
ToolTip
SetTimer, WatchCursor, Off
;MsgBox, EnterTheValue
InputBox, OutputVar, Сдвиг по Х, Введите итоговое значение сжатия по оси Х. Для расширения объекта значение должно быть со знаком "-" (минус),,,,,,Locale, ;,%SingleKey%
if (ErrorLevel=1)
{
	ExitApp
}
;~ }
;SplashImage, Off
;~ SplashImage 2:, Off
;~ SplashImage 3:, Off
;~ SplashImage 4:, Off
;~ SplashImage 5:, Off
SetTitleMatchMode, RegEx
WinSet, Enable,, ahk_exe %StringbcadexeReg%
SetTitleMatchMode, 2
SetTitleMatchMode, Fast	

iterationSmeshenie:=OutputVar
;proverkaNaDrob:=iterationSmeshenie/couIterations
da:=0
if OutputVar is Float
{
	;добавить вопрос про округление
	da:=1
}
else
{
	if OutputVar is Integer
	{
		da:=1
	}
	else
	{
		;MsgBox, Введённое значение не является числом. Введите число
		GoTo inputLabel
	}

}

couIterations:=((counterMassiv-1)/2)-2
iterationSmeshenie:=OutputVar
tempSmeshenie:=Round(iterationSmeshenie/couIterations,4)
tempSmeshenieRound:=Round(tempSmeshenie,0)

;~ if (tempSmeshenie<>tempSmeshenieRound)
;~ {
	;~ result:=CreateGUIOkruglit(tempSmeshenie)
	;~ MsgBox, %result%
	;~ ExitApp
	;~ ;if result<>"zanovo"
;~ }

tempiterationSmeshenie:=tempSmeshenieRound*couIterations
if (tempSmeshenie<>tempSmeshenieRound)
{
	BlockInput, Off
	Gui, Color, Default
	Gui, +Caption
	Gui, Add, Button, Default x12 y50 w110 h30 , &Да
	StringRoundIterationSmeshenie:=Round(tempiterationSmeshenie,0)
	Gui, Add, Text, x12 y10 w270 h40 +Center, Значение деления получилось дробным (%tempSmeshenie%). Округлить до %tempSmeshenieRound%? (Суммарно будет %StringRoundIterationSmeshenie%. Было: %iterationSmeshenie%)
	Gui, Add, Button, x162 y50 w110 h30 , &Нет
	Gui, Add, Button, x102 y90 w90 h20 , &ВвестиЗаново
	; Generated using SmartGUI Creator 4.0
	Gui, Show, x379 y228 h110 w308, Округлить дробное значение?
	Gui, +LastFound
	WinWaitClose
	
	proverkaDalee1:
	if (value1=1)
		GoTo Dalee2
	if (value1=2)
		GoTo Dalee2
	if (value1=3)
		GoTo inputLabel
	if (value1=0)
		ExitApp
	
	ButtonДа:
	value1:=1
	tempSmeshenie:=tempSmeshenieRound
	iterationSmeshenie:=tempiterationSmeshenie
	;MsgBox, tempSmeshenie %tempSmeshenie%
	;MsgBox, iterationSmeshenie %iterationSmeshenie%
	Pause, Off
	Gui, Destroy
	

	ButtonНет:
	value1:=2
	Pause, Off
	Gui, Destroy
	;MsgBox, не округлять ессно
	;GoTo inputLabel
	GoTo Dalee2
	
	ButtonВвестиЗаново:
	value1:=3
	Pause, Off
	Gui, Destroy
	;MsgBox, ввести заново

	GuiClose:
	Pause, Off
	GoTo, proverkaDalee1
	return
}

Dalee2:
if (da=1)
{
	SetTimer, AvariynoeZavershenie, 10 ;обработка нажатия Esc
	couKonecClick:=counterMassiv-1

	;цикл проверки максимальных и минимальных значений X Y
	Xmin:=9999
	Ymin:=9999
	Xmax:=0
	Ymax:=0
	kolvo1:=Round(couIterations+2,0)
	;MsgBox, %kolvo1%
	loop, %kolvo1%
	{
		if (MousePositions[A_Index*2-1]>Xmax)
			Xmax:=MousePositions[A_Index*2-1]
		if (MousePositions[A_Index*2-1]<Xmin)
			Xmin:=MousePositions[A_Index*2-1]
		if (MousePositions[A_Index*2]>Ymax)
			Ymax:=MousePositions[A_Index*2]
		if (MousePositions[A_Index*2]<Ymin)
			Ymin:=MousePositions[A_Index*2]
	}
	;доп.защита программы, если что-то было обрабтано неправильно
	if (Xmin=9999)
		ExitApp
	if (Xmax=0)
		ExitApp
	if (Ymin=9999)
		ExitApp
	if (Ymax=0)
		ExitApp
	
	;MsgBox, Xmax %Xmax% Xmin %Xmin% Ymax %Ymax% Ymin %Ymin%
	;~ MsgBox, % MousePositions[couKonecClick]
	
	;MsgBox, counterMassiv %counterMassiv%
	;~ MsgBox, couKonecClick %couKonecClick%
	;MsgBox, couIterations %couIterations%
	
	
	if (MousePositions[1]>MousePositions[couKonecClick-1])
	{
		obratnoLi:=-1
		;counterA_Index:=1
	}
	else
	{
		obratnoLi:=1
		;counterA_Index:=Round(couIterations, 0)
	}
	
	
	if (OutputVar>0)
	{
		counterA_Index:=Round(couIterations, 0)
	}
	else
	{
		counterA_Index:=1
	}
	
	iterationSmeshenie:=iterationSmeshenie*obratnoLi/couIterations
	if (OutputVar>0)
	{
		tekusheeSmeshenie:=iterationSmeshenie
	}
	else
	{
		tekusheeSmeshenie:=iterationSmeshenie*couIterations
	}
	;MsgBox, iterationSmeshenie %iterationSmeshenie%
	;активация инструмента сдвиг
	;WinMenuSelectItem,%stringbCAD%,,Инструменты,Трансформации,Сдвиг
	BlockInput, SendAndMouse
	;MsgBox, couIterations %couIterations%
	;CoordMode, Mouse, Relative
		loop, %couIterations%
		{
			
			;MsgBox, A_Index %A_Index% counterA_Index %counterA_Index% obratnoLi %obratnoLi%
			;SetTitleMatchMode, RegEx
			SetTitleMatchMode, 2
			SetTitleMatchMode, Fast	
			WinMenuSelectItem, ahk_id %IDbCAD%,,Инструменты,Трансформации,Сдвиг
			Sleep, waittime
			WinActivate, ahk_id %IDbCAD%
			
			Xiteration:=MousePositions[(counterA_Index+1)*2-1]
			Yiteration:=MousePositions[2]
			Yiteration:=Ymin
			;MsgBox, A_Index %A_Index% counterA_Index %counterA_Index% X %Xiteration% Y %Yiteration%
			MouseMove, Xiteration, Yiteration
			Click, Xiteration, Yiteration
			;MsgBox, первый клик завершён
			
			Sleep, waittime
			Xiteration:=MousePositions[(counterA_Index)*2-1]
			Yiteration:=MousePositions[couKonecClick]
			Yiteration:=Ymax
			;MsgBox, A_Index %A_Index% counterA_Index %counterA_Index% X %Xiteration% Y %Yiteration%
			MouseMove, Xiteration, Yiteration
			Click, Xiteration, Yiteration
			;MsgBox,ololo
			titleWindowWait:="Выберите объекты"
			Sleep, waittime
			WinWait, %titleWindowWait%,,0.1
			;~ if (ErrorLevel)
			;~ MsgBox, Some Problem with %titleWindowWait%
			ifWinExist, %titleWindowWait%
			{
				;MsgBox, вход в обработку
				Sleep, waittime
				SetTitleMatchMode, 1
				SetTitleMatchMode, slow
				;MsgBox, обнаружено окно выберите объекты
				WinActivate, %titleWindowWait%
				controlNeed:="Button1"
				ControlFocus, %controlNeed%, %titleWindowWait%
				Send, {Enter}
				WinWaitClose, %titleWindowWait%, waittimewindow
				if (ErrorLevel)
				{
					MsgBox, Some Problem with close %titleWindowWait%
					BlockInput, Off
				}
				SetTitleMatchMode, RegEx
				WinWait, ahk_id %IDbCAD%,,waittimewindow
				SetTitleMatchMode, 1
				SetTitleMatchMode, Fast	
				if (ErrorLevel)
				{
					MsgBox, Какая-то проблема с ожиданием возврата в окно bCAD
					BlockInput, Off
				}
			}
			Sleep, waittime
			Send, 0
			;MsgBox, сенд был
			titleWindowWait:="Расположение базовой точки"
			WinWait, %titleWindowWait%,, waittimewindow
			if (ErrorLevel)
			{
				MsgBox, Some Problem with wait %titleWindowWait%
				BlockInput, Off
			}
			WinActivate, %titleWindowWait%
			Send, {Space}
			Send, 0
			Sleep, waittime
			;MsgBox, Press Enter
			Send, {Enter}
			;MsgBox, Press Enter
			;MsgBox, tekusheeSmeshenie %tekusheeSmeshenie%
			Sleep, waittime
			WinWaitClose, %titleWindowWait%, waittimewindow
			Sleep, waittime
			WinWait, ahk_id %IDbCAD%,,waittimewindow
			;WinWaitActive, %IDbCAD%,,waittimewindow
			
			Send, @
			titleWindowWait:="Новое положение базовой точки"
			WinWait, %titleWindowWait%,, waittimewindow
			WinActivate, %titleWindowWait%
			Send, % Round(tekusheeSmeshenie,4)
			Send, {Space}
			Send, 0
			if (OutputVar>0)
				tekusheeSmeshenie:=tekusheeSmeshenie+iterationSmeshenie
			else
				tekusheeSmeshenie:=tekusheeSmeshenie-iterationSmeshenie
			
			Sleep, waittime
			;MsgBox, Press Enter
			
			Send, {Enter}
			WinWaitClose, %titleWindowWait%, waittimewindow
			
			WinWait, ahk_id %IDbCAD%,,waittimewindow
			;MsgBox, Press Enter
			Sleep, waittime
			
			;MsgBox, Click %Xiteration% %Yiteration%
			;ExitApp
			if (OutputVar<0)
			{
				counterA_Index++
			}
			else
			{
				counterA_Index--
			}
		}
		SetTimer, AvariynoeZavershenie, Off
		Send, {Esc}
		BlockInput, Off

}
else
{
	MsgBox, Введённое значение не является числом. Введите число
	GoTo inputLabel
}


BlockInput, Off
;ToolTip, %Stroka%
SetTitleMatchMode, RegEx
WinSet, Enable,, ahk_exe %StringbcadexeReg%
SetTitleMatchMode, 2
SetTitleMatchMode, Fast	
TrayTip, Сдвиг, Скрипт завершился, 1
ExitApp


AvariynoeZavershenie:
GetKeyState, StateKey, Esc
if (StateKey="D")
{
	BlockInput, Off
	MsgBox, Скрипт прерван пользователем
	SetTitleMatchMode, RegEx
	WinSet, Enable,, ahk_exe %StringbcadexeReg%
	SetTitleMatchMode, 2
	SetTitleMatchMode, Fast	
	ExitApp
}
return

WatchCursor:
;MouseGetPos, , , id, control
;CoordMode, Mouse, Screen
MouseGetPos, OutputVarX, OutputVarY
Gui, cursor:Show, % "x" OutputVarX
if (counterMassiv=1)
{
	Gui, cursorHor:Show, % "y" OutputVarY
}
else
{
	tempHorDlina:=OutputVarX-Xmin
	if (tempHorDlina>0)
	{
		Gui, cursorHor:Show, % "x" (OutputVarX-tempHorDlina) " y" OutputVarY " w" tempHorDlina
	}
	else
	{
		Gui, cursorHor:Hide
	}
}
;CoordMode, Mouse, Relative
;MouseGetPos, OutputVarX, OutputVarY
GetKeyState, StateKey, LButton

if (couClick<>0)
{
	ToolTip, %couClick%. Tab - далее
}
else
{
	ToolTip, %couClick%
}

if(StateKey="D")
{
	if (previousStateKey<>"D")
	{
		;Gui, cursorHor:Destroy
		previousStateKey:=StateKey
		MousePositions[counterMassiv]:=OutputVarX
		tempString:=tempString MousePositions[counterMassiv]
		counterMassiv++
		MousePositions[counterMassiv]:=OutputVarY
		tempString:=tempString MousePositions[counterMassiv]
		counterMassiv++
		couClick++
		
		;рисование линий
		Xposition:=OutputVarX
		Yposition:=OutputVarY

		
		if (OutputVarY>Ymax)
		{
			Ymax:=OutputVarY
			YmaxCou:=counterMassiv-1
		}
		if (OutputVarY<Ymin)
		{
			Ymin:=OutputVarY
			YminCou:=counterMassiv-1
		}
		if (OutputVarX>Xmax)
		{
			Xmax:=OutputVarX
			XmaxCou:=counterMassiv-2
		}
		if (OutputVarX<Xmin)
		{
			Xmin:=OutputVarX
			XminCou:=counterMassiv-2
		}
		
		visotaPryamougolnika:=Ymax-Ymin
		shirinaPryamougolnika:=Xmax-Xmin

		;первая позиция
		if (counterMassiv=3)
		{
			couWinLines++ ;счётчик линий
			couWinLines++
		}
		
		first:=1 ;первая линия
		Gui, %first%:Color, 00FF00
		Gui, %first%:-Caption
		Gui, %first%:+ToolWindow
		;~ Gui, %first%:-LastFound
		;~ WinSet, Disable
		;Gui, %first%:Show, % "x" MousePositions[1] " y" Ymin " h" dlina_linii " w" shirina_linii 	;для операции слева-направо
		Gui, %first%:Show, % "x" MousePositions[1] " y" MousePositions[2]-dlina_linii/2 " h" dlina_linii " w" shirina_linii	;перекрестие
		second:=2
		Gui, %second%:Color, 00FF00
		Gui, %second%:+ToolWindow
		Gui, %second%:-Caption
		;~ Gui, %second%:-LastFound
		;~ WinSet, Disable
		;Gui, %second%:Show, % "x" MousePositions[1] " y" Ymin " h" shirina_linii " w" dlina_linii
		Gui, %second%:Show, % "x" MousePositions[1]-dlina_linii/2 " y" MousePositions[2] " h" shirina_linii " w" dlina_linii ;перекрестие
		
		if (counterMassiv>3) ;если линий больше 3
		{
			couWinLines++
			Gui, %couWinLines%:Color, 00FF00
			Gui, %couWinLines%:-Caption
			Gui, %couWinLines%:+ToolWindow
			Gui, %couWinLines%:Show, % "x" Xposition " y" (Yposition-dlina_linii/2) " h" dlina_linii " w" shirina_linii
			couWinLines++
			Gui, %couWinLines%:Color, 00FF00
			Gui, %couWinLines%:-Caption
			Gui, %couWinLines%:+ToolWindow
			Gui, %couWinLines%:Show, % "x" (Xposition-dlina_linii/2) " y" Yposition " h" shirina_linii " w" dlina_linii
			if ((counterMassiv>5) && (couWinLines>4))
			{
				loop, %couWinLines%
				{
					if ((A_Index>2) && (A_Index<couWinLines-1))
					{
						tempcou1:=A_Index
						if (Mod(A_Index,2)=1) ;нечётная линия - вертикальная, её перерисовываем
						{
							;MsgBox, redraw %A_Index%
							Gui, %A_Index%:Color, 00FF00
							Gui, %A_Index%:-Caption
							Gui, %A_Index%:Show, % "x" MousePositions[tempcou1] " y" Ymin " h" visotaPryamougolnika " w" shirina_linii
						}
						else
						{
							;MsgBox, delete %A_Index%
							Gui, %A_Index%: Destroy ;удаляем ненужню линию
						}
					}
					
				}
			}
			
		 }
		
	}
}
else
{
	previousStateKey:="U"
	MouseGetPos, OutputVarX, OutputVarY
}
GetKeyState, StateKey, RButton
if(StateKey="D")
{
	SetTitleMatchMode, RegEx
	WinSet, Enable,, ahk_exe %StringbcadexeReg%
	SetTitleMatchMode, 2
	SetTitleMatchMode, Fast	
	ExitApp
}
return ;конец таймера

}
else
{
MsgBox, bCAD не запущен
ExitApp
}
;------------------------------------------------------end main