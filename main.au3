;Code written by Kuntal Das
;Email: xkdash@gmail.com
;Project: S3PAS

#include<GUIconstantsEx.au3>
#include <StringConstants.au3>
#include<GuiButton.au3>
#include<Array.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <SQLite.au3>
#include <SQLite.dll.au3>
#include <Timers.au3>
#include <ButtonConstants.au3>
#NoTrayIcon
SplashImageOn("Loading",@WorkingDir & "\res\images\loading.jpg",@DesktopWidth/2 ,@DesktopHeight/2 ,-1,-1,1)
sleep(1000)
Global $rec_arr=_dbase()
SplashOff()

_Main()
Func _Main()
   Local $iMsg,$check,$s_Id,$sPasswd,$idRadio1,$idRadio2,$btn,$w_main,$r_val,$dw_add,$dh_add,$about
   $dw_add=(@DesktopWidth-510)/2
   $dh_add=(@DesktopHeight-400)/2
   $w_main=GUICreate("Login Assistant ver1.2",@DesktopWidth,@DesktopHeight,-1,-1,BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX))
   Opt("TrayIconHide", 1)
   WinSetState($w_main, "", @SW_RESTORE)

   GUICtrlCreatePic(@WorkingDir&"\res\images\"&Random(1,7,1)&".jpg",(@DesktopWidth-3500)/2,(@DesktopHeight-2500)/2, 0,0)
   GUICtrlSetState(-1, $GUI_DISABLE)

   $about=GUICtrlCreateButton("About",$dw_add+70,$dh_add+120,60,30)
   $idRadio1 = GUICtrlCreateRadio("Login Using Textual Password Scheme.", 100+$dw_add, 200+$dh_add, 340, 19)
   $idRadio2 = GUICtrlCreateRadio("Login Using S3PAS Powered Authentication System.", 100+$dw_add, 220+$dh_add, 340, 19)
   GUICtrlSetState($idRadio2, $GUI_CHECKED)

   $btn = GUICtrlCreateButton("Proceed to Login.", 355+$dw_add,300+$dh_add, 115, 30,$BS_DEFPUSHBUTTON)
   GUICtrlSetBkColor($idRadio1,"0xA5D7ED")
   GUICtrlSetBkColor($idRadio2,"0xA5D7ED")

   GUISetState(@SW_SHOW)
   While 1
	  $iMsg = GUIGetMsg()
	  Select

			Case $iMsg = $GUI_EVENT_CLOSE
			   GUIDelete()
			   Exit
			Case $iMsg = $idRadio1 And BitAND(GUICtrlRead($idRadio1), $GUI_CHECKED) = $GUI_CHECKED
               $check=$idRadio1
            Case $iMsg = $idRadio2 And BitAND(GUICtrlRead($idRadio2), $GUI_CHECKED) = $GUI_CHECKED
			   $check=$idRadio2
			Case $iMsg=$about
			   MsgBox(0,"About Xtreme Duo-Authentico.","-----CREATED BY KUNTAL DAS-----."&@CR&"-----1ST YEAR B-TECH, IIT PATNA.-----","",$w_main)
			Case $iMsg=$btn

			   if $check=$idRadio1 Then
				  GUISetState(@SW_DISABLE,$w_main)
				  $sPasswd=_text($w_main)
				  GUISetState(@SW_ENABLE,$w_main)
				  if $sPasswd=10 Then
					 GUIDelete()

						;Now login page is to be linked here.
					 Exit
				  EndIf

			   else
				  $s_Id = InputBox("UserId Gate", "Enter your UserId", "","",-1,150,(@DesktopWidth-300)/2,(@DesktopHeight-150)/2,"",$w_main)
				  if _isvalid($s_Id,0,0) = 15 Then
					 While 1
						$r_val=_sub($s_Id)
						GUISetState(@SW_ENABLE,$w_main)
						If $r_val=10 Then
						   ExitLoop
						   GUISetState(@SW_DISABLE,$w_main)
						ElseIf $r_val=20 Then
						   Exit
						EndIf
					 WEnd
				  Else
					 MsgBox(0,"Attention","Enter a valid user Id.","",$w_main)
				  EndIf
			   EndIf
			   WinActivate($w_main)
	  EndSelect
   WEnd
EndFunc
;FUNCTION TO CONNECT TO ID-PASSWORD DATABASE
Func _dbase()

   Local $Result, $iRows, $iColumns,$iRval,$f_arr
   _SQLite_Startup()

   If @error Then
	  MsgBox(16, "SQLite Error", "SQLite.dll Can't be Loaded!")
	  Exit -1
   EndIf

   _SQLite_Open(@WorkingDir & "\user.db",$SQLITE_OPEN_READONLY)
   If @error Then
	  MsgBox(16, "SQLite Error", "Can't Load Database!")
	  Exit -1
   EndIf
   $iRval = _SQLite_GetTable2d(-1, "SELECT * FROM XTDUOUIPVS;", $Result, $iRows, $iColumns)
   If $iRval = $SQLITE_OK Then

	  Return($Result)
   Else
	  MsgBox(16, "SQLite Error: " & $iRval, _SQLite_ErrMsg())
   EndIf
   _SQLite_Close()
   _SQLite_Shutdown()
EndFunc

;FUNCTION TO CREATE TEXTUAL PASSWORD SUITE

Func _text($w_m)
   local $t_id,$w_text,$t_pass,$t_log,$c_pass,$c_id,$temp,$t_stamp
   $w_text=GUICreate("Login Assistant ver1.2",300,200,-1,-1,BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX),"",$w_m)
   GUICtrlCreatePic(@WorkingDir&"\res\images\login.jpg",100,0, 0, 0)
   GUICtrlSetState(-1, $GUI_DISABLE)

   GUICtrlCreateLabel("Enter UserId",10,20,-1,20)
   $t_id = GUICtrlCreateInput("", 10,40, 200, 30)
   GUICtrlCreateLabel("Enter Password",10,85,-1,20)
   $t_pass = GUICtrlCreateInput("", 10,105, 200, 30,$ES_PASSWORD)
   $t_log=GUICtrlCreateButton("Login",10,155,60,30,$BS_DEFPUSHBUTTON)
   GUISetState(@SW_SHOW)
   $t_stamp=TimerInit()
   while 1
	  $iMsg=GUIGetMsg()
	  Select
		 case $iMsg=$GUI_EVENT_CLOSE
			GUIDelete()
			Return(20)
		 case $iMsg=$t_log
			if Not GUICtrlRead($t_id)="" Then
			   $temp=_isvalid($c_id,0,0)
			   if $temp=15 Then
				  If _isvalid($c_pass,1,0)<>15 Then
					 MsgBox(0,"Attention","Invalid Password","",$w_text)
				  Else
					 msgbox(0,"Success","You have Successfully Logged in."&@CR&"Login Time- "&Round(TimerDiff($t_stamp)/1000,3)&" secs.","",$w_text)
					 return(10)
				  EndIf
			   Elseif $temp<>15 Then
				  MsgBox(0,"Attention","Invalid User_Id","",$w_text)
			   EndIf
			EndIf
		 Case $iMsg=$t_id
			$c_id=GUICtrlRead($t_id)
		 Case $iMsg=$t_pass
			$c_pass=GUICtrlRead($t_pass)

	  EndSelect
   WEnd
EndFunc

;FUNCTION TO CHECK AVAILABILITY OF DATABASE ENTRIES

Func _isvalid($data,$param,$use)
   local $iRows,$i,$found=0
   Global $rec_arr
   $iRows = UBound($rec_arr, $UBOUND_ROWS)
   For $i=1 to $iRows-1
	  if StringCompare(String($rec_arr[$i][$param]),$data, $STR_CASESENSE)=0 Then
		 $found=$i
		 ExitLoop
	  EndIf
   next
   if $found>0 Then
	  if $use=0 Then
		 Return(15)
	  elseif $use=1 Then
		 return($rec_arr[$found][1])
	  EndIf
   EndIf
EndFunc

;FUNCTION TO CREATE S3PAS AUTHENTICATION SUITE

Func _sub($u_code)

   ;DECLARATION
   Local $iMsg,$i=0,$s_char,$s_btn,$ch="",$wnd,$btn_co[60][2],$cnt=0,$area[4]=[0,0,0,0],$point[4],$x=95,$y=180,$r,$p_size,$chk_sum=0,$f_cnt=0,$txt,$t_char[200],$t_size,$t_point[4],$t_cnt=0
   Local $chr_list[90]=["~","@","2","3","#","4","$","5","%","6","^","7","8","*","9","(","0",")","-","_","=","+","[","{","}","]",";",":",",","<",">",".","?","/","\","Q","W","E","R","T","Y","U","I","O","P","A","S","D","F","G","H","J","K","L","Z","X","C","V","B","N","M","q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","z","x","c","v","b","n","m","|","1","!"],$btn[90]
   Local $pass,$i,$new,$fin[50],$s_cnt=0,$t_stamp
   Static Local $count_retry_time=0, $count_retries=0,$save_time=0 ,$save_retries=0

   ;RANDOMIZATON
   _ArrayShuffle($chr_list)

   ;PASSWORD FORMAT GENERATION
   $pass=_isvalid($u_code,0,1)
   $p_size=StringLen($pass)
   $new=$pass & StringLeft($pass,2)

   if $p_size=3 Then
	  For $i=1 to 3
		 $fin[$i]=StringMid($pass,$i,1)
		 $cnt=$cnt+1
	  Next
	  $chk_sum=1
   Else
	  For $i=1 to $p_size+2
		 $fin[$i]=StringMid($new,$i,1)
		 $cnt=$cnt+1
	  Next
	  $chk_sum=$p_size
   EndIf
   ; PASSWORD FORMAT GENERATED
   ;CREATING GUI

   $wnd=GUICreate("Login Assistant ver1.2", "600", "720",-1,-1,BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX))

   GUICtrlCreatePic(@WorkingDir&"\res\images\back_2.jpg", 0, 0, 600, 720)
   GUICtrlSetState(-1, $GUI_DISABLE)

   For $i=0 To 89
	  $btn[$i] = GUICtrlCreateButton($chr_list[$i], $x, $y, 40, 40,$BS_ICON)
	  GUICtrlSetImage($btn[$i],@WorkingDir &"\res\icon\"& asc($chr_list[$i]) & ".bmp",0) ; image button
	  $x=$x+40
	  if $x=495 Then
		 $x=95
		 $y=$y+40
	  EndIf
   Next

   GUICtrlCreateLabel("Enter Charachters.",50,625,150,20)
   GUICtrlSetFont(-1, 10, 400,"","")
   $s_char = GUICtrlCreateInput("", 80,650, 350, 30)
   $s_btn = GUICtrlCreateButton("Accept", 450,650, 100, 30,$BS_DEFPUSHBUTTON)
   GUICtrlSetFont(-1, 14, 400)

   GUISetState(@SW_SHOW)

   ;GUI CREATED
   ;GENERATING BUTTON COORDINATES
   For $i=0 to $cnt-1
	  $temp=ControlGetPos($wnd,"",$fin[$i+1])
	  $btn_co[$i][0]=$temp[0]
	  $btn_co[$i][1]=$temp[1]
   Next

   ;BUTTON COORDINATES GENERATED
   ;TIMER
   $t_stamp= _Timer_Init()

   ;LOOPING
   $i=0
   While 1
	  $iMsg = GUIGetMsg()
		 Select
			Case $iMsg = $GUI_EVENT_CLOSE
				  GUIDelete()
				  Return(10)
			   Case $iMsg=$s_char

				  $txt=GUICtrlRead($s_char)
				  $t_size=StringLen($txt)
				  if $t_size=$chk_sum Then
					 For $i=1 to $t_size
						$t_char[$i-1]=StringMid($txt,$i,1)
					 Next
					 For $i=0 To $t_size-1
						$t_point=ControlGetPos($wnd,"",$t_char[$i])
						$area[0]=_Area($btn_co[$i][0],$btn_co[$i+1][0],$btn_co[$i+2][0],$btn_co[$i][1],$btn_co[$i+1][1],$btn_co[$i+2][1])
						$area[1]=_Area($btn_co[$i][0],$btn_co[$i+1][0],$t_point[0],$btn_co[$i][1],$btn_co[$i+1][1],$t_point[1])
						$area[2]=_Area($btn_co[$i+1][0],$btn_co[$i+2][0],$t_point[0],$btn_co[$i+1][1],$btn_co[$i+2][1],$t_point[1])
						$area[3]=_Area($btn_co[$i][0],$btn_co[$i+2][0],$t_point[0],$btn_co[$i][1],$btn_co[$i+2][1],$t_point[1])
						if ($btn_co[$i][0]=$btn_co[$i+1][0]=$btn_co[$i+2][0]) and ($btn_co[$i][1]=$btn_co[$i+1][1]=$btn_co[$i+2][1]) Then
						   $r=_Dist($btn_co[$i][0],$t_point[0],$btn_co[$i][1],$t_point[1])
						   If ($r-120)< 0 Then
							  $t_cnt=$t_cnt+1
						   Else
							  $t_cnt=$p_size+10
						   EndIf
						ElseIf $area[0]=0 Then
						   If ((_Dist($btn_co[$i][0],$t_point[0],$btn_co[$i][1],$t_point[1])+_Dist($btn_co[$i+1][0],$t_point[0],$btn_co[$i+1][1],$t_point[1]))-_Dist($btn_co[$i][0],$btn_co[$i+1][0],$btn_co[$i][1],$btn_co[$i+1][1]))<20 Then
							  $t_cnt=$t_cnt+1
						   Else
							  $t_cnt=$p_size+10
						   EndIf
						Else
						   If Abs($area[0]-($area[1]+$area[2]+$area[3]))< 2000 Then
							  $t_cnt=$t_cnt+1
						   Else
							  $t_cnt=$p_size+10
						   EndIf
						EndIf
					 Next
				  EndIf

			Case $iMsg>0 And StringCompare("Accept", _GUICtrlButton_GetText($iMsg), $STR_CASESENSE)<>0
				  $ch=$ch&_GUICtrlButton_GetText($iMsg)
				  GUICtrlSetData($s_char,$ch," ")

			Case $iMsg=$s_btn
				  if $t_cnt=$chk_sum And $t_size=$chk_sum Then
					 if $count_retries>=5 Then
						if Round(TimerDiff($t_stamp)/1000,3)/$count_retries <10 Then
						   MsgBox(0,"Caution","For Security Purpose we would like you to login once again","",$wnd)
						   $save_time=$count_retry_time+$save_time+Round(TimerDiff($t_stamp)/1000,3)
						   $count_retry_time=$count_retry_time-$count_retry_time
						   $save_retries=$count_retries+$save_retries
						   $count_retries=$count_retries-$count_retries
						   GUIDelete($wnd)
						   Return(25)
						EndIf
					 else
						$save_time=$save_time+$count_retry_time              ; in case retries are < 5.
						msgbox(0,"Success","Login Successful"&@CR&"Login Time- "&$save_time+Round(TimerDiff($t_stamp)/1000,3)&" secs.","",$wnd)
					 EndIf
					 Return(20)
				  Else
					 msgbox(0,"Failure","Wrong Password","",$wnd)
					 $t_cnt=0
					 $f_cnt=$f_cnt+1
					 $count_retries=$count_retries+1
					 If $f_cnt=3 Then
						$count_retry_time=$count_retry_time+Round(TimerDiff($t_stamp)/1000,3)
						GUIDelete($wnd)
						Return(25)
					 EndIf
				  Endif
				  GUICtrlSetData($s_char,"","")
		 EndSelect
			$ch=""
   WEnd
EndFunc
;End
;FUNCTION FOR AREA CALCUATION
Func _Area($x1,$x2,$x3,$y1,$y2,$y3)
   Local $s=Abs(0.5*(($x1-$x2)*($y1-$y3)-(($x1-$x3)*($y1-$y2))))
   Return($s)
EndFunc
;FUNCTION FOR CALCULATING DISTANCE BETWEEN ANY TWO POINTS
Func _Dist($x1,$x2,$y1,$y2)
   Return(Sqrt((($x1-$x2)^2)+(($y1-$y2)^2)))
EndFunc