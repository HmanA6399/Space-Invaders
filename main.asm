; Including Macros Library
INCLUDE ship.inc
INCLUDE bullet.inc
INCLUDE refl.inc
INCLUDE name.inc
INCLUDE lib.inc
INCLUDE chatlib.inc


	.MODEL SMALL
	.386
        .STACK 64
        .DATA 
;CHAT_GET_USER_INP
;*************************************************
		CURSOR1_Y EQU 11D
		CURSOR2_Y EQU 23D
		CURSOR1_CUR_X DB 0
		CURSOR2_CUR_X DB 0
		CHAR1   DB  ?
		CHAR2   DB  ?
		CHAT_FLAG1 DB 0
		CHAT_FLAG2 DB 0
		game_flag1 db 0
		game_flag2 db 0
		GAME_LEVEL DB 0
		SEND_INVITATION DB 0
;name page
;****************************************************
		playership1 db 15 dup('$'),'$' ; NAME OF PLAYER SHIP 1
		;playership2 DB 15 DUP('$'),'$' ; NAME OF PLAYER SHIP 2
		PLAYERSHIP2 DB "ALI",'$'
		MES         DB 'Press enter to continue $','$'
		MESSHIP1    DB 'Please Enter the name $','$'
		SCN         DB 1  ; TO DETERMINE NAME PAGE TO PLAYER SHIP 1 '1'OR SHIP 2 '2'
		word_color equ 0fh	
		ActualSize1 DB 0
		SEND_NAME_F DB 0
		RECIVE_NAME_F DB 0
; Printing Strings
;****************************************************
		st0 db "to end game click f4 & TO PAUSE F1 $"
		st1 db "To Start Chatting Press F1",10,13,10,13,"       To Start Playing Game Press F2",10,13,10,13,"       To End The Programe Press Esc",10,13,10,13,'$'
		st2 db "press Enter to back to main menu",10,13,10,13,'$'
		st3 db "screen for chatting ",10,13,10,13,'$'
		st4 db "screen for playing ",10,13,10,13,'$'
		st5 db "screen for Exiting ",10,13,10,13,'$'
		st7 db 10,13,10,13,"Click f4 to return to main menu $"
		ST8 DB 'want TO CHAT YOU','$'
		ST9 DB 'want TO game with YOU','$'
		ST10 DB "To Start LEVEL ONE press 1 ",10,13,10,13,"       To Start LEVEL TWO press 2",'$'
		window_winner db "***  The Winner is  *** ",10,13,10,13,'$'
		equal_window db "***  no one  ****",'$'

; Printing and Drawing variables
;*****************************************************
		BGCOLOR         EQU 0H   ; background color
		REFLECTORCOLOR  EQU 56H  ; reflector color
		SHIP1COLOR      DB 33H  ; ship 1 color
		SHIP2COLOR      DB 33H  ; ship 1 color
		BOARDSCOLOR     EQU 043H ; boards color
		BOARDERTHICK    EQU  2   ; boards thickness
		BOARDER1FY      EQU 145  ; frist boarder y
		BOARDER1FX      EQU  0   ; boards frist x
		BOARDER1EX      EQU 640  ; boards end x
		REFLECTORlen    EQU  60  ;reflector length
		ShipSizep1y     EQU  30  ; part 1 in ship length
		ShipSizep2Y     EQU  8   ; part 2 in ship length
		PLAYER_SC_pY    EQU 13H  ;player score position y
		PLAYER1_SC_pX   EQU 01H  ;player 1 score position x
		PLAYER2_SC_pX   EQU 14H  ;player 2 score position y
		PLAYER1_msg_py  EQU 15H  ;player 1 message position y
		PLAYER2_msg_py  EQU 18H  ;player 2 message position y
		ship2Damage     EQU 44h  ; color to damage 
		ship1Damage     EQU 44h  ;color to damage
		helthfy         equ 151
		helthlen        equ 8
		helthsh1fx      dw 99 ,104,109,114,119,124,129,134,139,144
		helthsh1ex      dw 102,107,112,117,122,127,132,137,142,147
		helthcolor      equ 04h
		helthsh2fx      dw  249,254,259,264,269,274,279,284,289,294  
		helthsh2Ex	dw  252,257,262,267,272,277,282,287,292,297
; Player 1 Variables
;****************************************************
		Ship1_Speed  DW 1
		SH1PROTECT_FLAG DB 0
		SH1TIMES_PROTECT DB 0
		sh1health   Dw 10    
		sh1p1fy   DW 1
		sh1p2fy   DW 12
		sh1p1fx   EQU 5
		sh1p1ENDx equ 15
		sh1p2fx   EQU 16
		sh1p2ENDx equ 21
		p1_bulls   db   0       ; No of bullets fired
		fl       db   00h 

		; Player 2 Variables
		;****************************************************
		Ship2_Speed  DW 1
		SH2PROTECT_FLAG DB 0
		SH2TIMES_PROTECT DB 0
		sh2health   Dw 10   
		sh2p1fy   DW   1
		sh2p2fy   DW   12
		sh2p1fx   EQU 300
		sh2p1ENDx equ 310
		sh2p2fx   EQU 294
		sh2p2ENDx equ 299
		p2_bulls   db   0       ; No of bullets fired
		fr       db   00h
                ; IsThereAWinner - boolean value to determine if there's a final winner or not
                IsThereAWinner db 00H
                ; Reflector Variables
                ;****************************************************
		REFfristY DW    1
		REFfristX EQU  151
		REFendX   EQU  156 
		REFflag   db    01             ; it take one or two  to detrmine if it move down "if 1" or move up "if 0"
		REFSPEED  EQU   0fffh          ;It is the counter when equal zero the reflector step & it control speed of reflector
		REFCTR    dw    0fffh

; Bullets Variables
;****************************************************
		buW     equ     20      ; Bullet width. No need to keep its height, just 3.
; All Bullets Positions Array, Each bullet is represented by 2 words
; LSW => stores X of the top-left px.
; MSW => stores Y of the top-left px. in the first byte, and type of the bullet in the MSB
; Type of bullet is 0 for left-to-right bullet and 1 for right-to-left
		bullPoses   dw  100 dup(0FFFFH), 0FEFEH 
		bullRPwr    dW  5
		bullLPwr    dW  5
		bullLSpeed  EQU  00FFH   ; Speed of left-to-right bullets in gameloop units
		bullLCtr    dw   00FFH   ; Speed of left-to-right bullets in gameloop units
		bullRSpeed  EQU  0AFFH   ; Speed of right-to-left bullets in gameloop units
		bullRCtr    dw  0AFFH   ; Speed of right-to-left bullets in gameloop units
;******************************************************
;power ups 

		POWERUP_XFLAG     DB  1          ; TO DETRMINE RIGTH '0' OR LEFT '1'
		POWERUP_fy        dw  8          ; FRIST Y
		POWERUP_COUNTER   dD  0Fffffh    ; COUNTER
		POWERUP_color     DB 04h         ; COLOR &TYPE
		POWERUP_ON        DB 0           ;IF IN SCREEN
                POWERUP_L_IS_DRAWN DB 0
                POWERUP_R_IS_DRAWN DB 0

		POWERUP_LEN     EQU 8
		POWERUPR_fx     EQU 206 		; RIGTH SIDE FRIST X
		POWERUPR_ex     EQU 211 		; RIGTH SIDE END X
		POWERUPL_fx     EQU 95	 	    ; LEFT SIDE FRIST X
		POWERUPL_ex     EQU 101 		    ; LEFT SIDE END X
		POWERUP_TODROW  EQU 03FFFFH     ;THE MAIN VALUE TO FILL COUNTER WHEN DISAPEARE
		POWERUP_TODELETE  EQU 03FFFFH   ;THE MAIN VALUE TO FILL COUNTER WHEN APEARE
		POWERUP_MAXY    EQU 130         ; MaX VALUE OF Y
		HELTH_UP        EQU 04H			;COLOR OF HEALTH BACKET
		SPEAD_UP        EQU 02H			; COLOR OF SPEED UP
		SPEAD_DOWN      EQU 01H			; COLOR SPEAD_DOWN
		PROTECT         EQU 03H			; COLOR PROTECT
;************************************************************
;ROCKET 

		ROCKET_XFLAG     DB  1          ; TO DETRMINE RIGTH '0' OR LEFT '1'
		ROCKET_fy        dw  4          ; FRIST Y
		ROCKET_COUNTER   dD  0Affffh    ; COUNTER
		ROCKET_color     DB 0Ch         ; COLOR 
		ROCKET_ON        DB 0           ;IF IN SCREEN
        ROCK_L_IS_DRAWN  DB 0
        ROCK_R_IS_DRAWN  DB 0
		ROCKET_LEN     EQU 28
		ROCKETR_fx     EQU 226 		; RIGTH SIDE FRIST X
		ROCKETR_ex     EQU 231 		; RIGTH SIDE END X
		ROCKETL_fx     EQU 75	 	    ; LEFT SIDE FRIST X
		ROCKETL_ex     EQU 80 		    ; LEFT SIDE END X
		ROCKET_TODROW  EQU 03FFFFH     ;THE MAIN VALUE TO FILL COUNTER WHEN DISAPEARE
		ROCKET_TODELETE  EQU 03FFFFH   ;THE MAIN VALUE TO FILL COUNTER WHEN APEARE
		ROCKET_MAXY    EQU 110         ; MaX VALUE OF Y
                
;*******************************************************
;buffer to take name
		MyBuffer LABEL BYTE ; TO READ IN 
		BufferSize db 40
		ActualSize db ?
		BufferData db 40 dup('$')	

   .CODE
MAIN	PROC	FAR

        MOV	AX,@DATA
        MOV	DS,AX
        ;**********************; TO USE STRING OPERATION
		mov AX,DS   
        mov ES,AX 
		;***********************
		cmp playership1,'$'  ; to check if i need to enter player name or if it aready exist
		jnz main_menu_pre
		name_page
		main_menu_pre:
        ; But DI at the first element of the bullets array
        MOV DI,offset bullPoses
        ; Changes to the mode 
        DETERMINE_MODE 13H ,0H ; VIDEO MODE
MAIN_MENU:
        CALL SHOW_MAIN_MENU
        CONFIG
MAIN_GET_USER_INP:
        GETKEY_NOWAIT
        JZ MAIN_RECIVE_USER_INP
        COMPARE_KEY 03BH        ; Scan code of F1 Key
        JNE CMP_F2_TO_GAME
        MOV CHAT_FLAG2,1
        MOV CHAR1,0FFH
        SENDMSG
        JMP CHAT
 CMP_F2_TO_GAME:
        COMPARE_KEY 03CH        ; Scan code of F2 Key
        JnE compare_esc
        MOV game_FLAG2,1
        MOV CHAR1,0FeH
        SENDMSG
		jmp game
compare_esc:   
		COMPARE_KEY 01H        ; Scan code of ESC key
        JE  ENDG
        JMP MAIN_RECIVE_USER_INP
MAIN_RECIVE_USER_INP:
        RECMSG                  ; Function to recieve a byte, stores ASCII in AH, if nothing is sent, it puts CHAR2=0
        CMP CHAR2,0             ; Means nothing to recieve
        JZ  MAIN_GET_USER_INP  ; Go to the top of the loop
       COMPARE_KEY_ASCII 0FFH            
        JNZ compare_for_game_loop ; Go to the top of the loop
        MOV CHAT_FLAG1,1
        JMP CHAT
compare_for_game_loop:
		COMPARE_KEY_ASCII 0FeH            
        JNZ MAIN_GET_USER_INP  ; Go to the top of the loop
        MOV game_FLAG1,1
        JMP game
		CALL SHOW_GAME
        JMP MAIN_MENU 
		
; Branch of Chatting screen calls the SHOW_CHAT Proc.
CHAT:   CALL SHOW_CHAT 
        JMP MAIN_GET_USER_INP

; Branch of Game screen calls the SHOW_GAME Proc.
GAME:   CALL SHOW_GAME_level
        JMP MAIN_GET_USER_INP            ; If the user clicks enter, go to main-menu

ENDG:   DETERMINE_MODE 03H, 00H
        HALT
MAIN	ENDP
; Procedures
;***********************************************************
SHOW_MAIN_MENU  PROC
    PREP_BACKBROUND BGCOLOR; TO PREPARE BACKGROUD COLOR & QUALITIES
    MOVE_CURSOR 7H,7H,0 ;to write in the middle of screen
    PRINTMESSAGE st1   ;Print 3 cases
    RET
SHOW_MAIN_MENU ENDP

;*************************************************
; **** SHOW_CHAT - Showes the Chat screen ****
; * USES :  AX, BX, CX , DX
; * PARAMS :  NONE
; ************************************************
SHOW_CHAT PROC
		CMP CHAT_FLAG1,1
		JZ PRINT_CMP_FLAG2
		RET
PRINT_CMP_FLAG2:
		MOVE_CURSOR 7H,11H,0 ;to write in the END of screen
		PRINTMESSAGE playership2   ;Print 
		MOVE_CURSOR 7H,12H,0 ;to write in the middle of screen
		PRINTMESSAGE ST8   
		CMP CHAT_FLAG2,1
		JZ GO_CHAT_MODE
		RET
GO_CHAT_MODE:		
		MOV CHAT_FLAG1,0
		MOV CHAT_FLAG2,0
        DETERMINE_MODE 07H,00H
		CHAT_MODE1
		CALL MAIN 
        RET
SHOW_CHAT ENDP

;**************************************************
;***show game levels two choose level
;**************************************************
SHOW_GAME_level proc
		CMP game_FLAG1,1
		JZ PRIN_CMP_FLAG2
		MOV SEND_INVITATION,1
		RET
PRIN_CMP_FLAG2:
		CMP game_FLAG2,1
		JZ START_LEVEL_PAGE
		MOVE_CURSOR 7H,11H,0 ;to write in the END of screen
		PRINTMESSAGE playership2   ;Print 
		MOVE_CURSOR 7H,12H,0 ;to write in the middle of screen
		PRINTMESSAGE ST9   
		MOV SEND_INVITATION,2
		
		RET
START_LEVEL_PAGE:
		CMP SEND_INVITATION,1
		JNZ RECIVE_LEVEL
		DETERMINE_MODE 13H,00H
		 PREP_BACKBROUND BGCOLOR
		 MOVE_CURSOR 7H,7H,0 ;to write in the middle of screen
		 PRINTMESSAGE st10   ;Print 3 cases
TAKE_LEVEL:
		 GETKEY
		 CMP AL,'1'
		 JNZ LEVEL_TWO
		 MOV GAME_LEVEL ,1
		 MOV CHAR1,1
        SENDMSG
		CALL SHOW_GAME
		RET
		LEVEL_TWO:
		CMP AL,'2'
		 JNZ TAKE_LEVEL
		 MOV GAME_LEVEL ,2
		 MOV CHAR1,2
        SENDMSG
		MOV game_FLAG1,0
		MOV game_FLAG2,0
		MOV SEND_INVITATION,0
		CALL SHOW_GAME
		RET
	RECIVE_LEVEL:
        RECMSG                  ; Function to recieve a byte, stores ASCII in AH, if nothing is sent, it puts CHAR2=0
        CMP CHAR2,0             ; Means nothing to recieve
        JZ  RECIVE_LEVEL  ; Go to the top of the loop
		 CMP CHAR2,1
		 JNZ RECIVE_LEVEL_TWO
		 MOV GAME_LEVEL ,1
		 CALL SHOW_GAME
		 RET
		RECIVE_LEVEL_TWO:
		CMP CHAR2,2
		 JNZ RECIVE_LEVEL
		 MOV GAME_LEVEL ,2
		 MOV game_FLAG1,0
		 MOV game_FLAG2,0
		 MOV SEND_INVITATION,0
		 CALL SHOW_GAME
		 RET
SHOW_GAME_level endp
;*************************************************
; **** SHOW_GAME - Shows the game screen ****
; * USES :  ALL
; * PARAMS :  DI => *First_Empty_Byte
; ************************************************
SHOW_GAME PROC
		
GO_game_MODE:		
        ; Reseting all game variables in the memory
        CALL CLRMEMORY
        ; Drawing and preparing
        PREP_BACKBROUND BGCOLOR
        CALL DRWINFO
        CALL DRWSHIPS
        call drawhelthsh1
        call drawhelthsh2
		CMP GAME_LEVEL,1
		JNZ GM_LP
		CALL DRWREFL
		
GM_LP:
        ; Handling counters and drawing of Powerups		
        DEC POWERUP_COUNTER
        CMP POWERUP_COUNTER,0
        JNZ continue2
        CMP POWERUP_ON,0
        JZ  DROW_POWERUP
        JNZ DELETE_POWERUP
DROW_POWERUP:		
        DROWPRE_POWERUP
        JMP continue2
DELETE_POWERUP:
        DELETEP_POWERUP
        JMP continue2			
continue2:
        DEC ROCKET_COUNTER
        CMP ROCKET_COUNTER,0
        JNZ continue0
        CMP ROCKET_ON,0
        JZ   DROW_ROCKET
        JNZ DELETE_ROCKET		
DROW_ROCKET:		
        DROWPRE_ROCKET
        JMP continue0
DELETE_ROCKET:
        DELETEP_ROCKET
        JMP continue0	

continue0:
		CMP GAME_LEVEL,1
		JNZ CHK_BULL
continue1:
        ; Moving Reflector and bullets
        ; Cheking for Moving the Reflector
        CMP REFCTR,0
        JE  MVREFL_LB 
        ; Checking for Moving Bullets and moving them
CHK_BULL:
        CMP bullLCtr,0
        JNE  DEC_CTRS_LB
        MOV bullLCtr,bullLSpeed
        CALL FAR PTR MVBULLSPROC
        ; Here we check if it happens to be a winner, then we exit the game function
        CMP IsThereAWinner, 00h
        JE DEC_CTRS_LB
EXIT_IF_F4:
        GETKEY
        COMPARE_KEY 03EH
        JNE EXIT_IF_F4
        RET
        ; Decrementing speed counter
DEC_CTRS_LB:
        DEC REFCTR
        DEC bullLCtr
        DEC bullRCtr
        JMP FAR PTR USER_INP

        ; Moving Reflector Branch
MVREFL_LB:
        MVREFL
        JMP CHK_BULL

        ; Branch of handling User Input
USER_INP:
        GETKEY_NOWAIT
        ; Handle Pause and stop clicks
        COMPARE_KEY 03EH        ; Scan code for f4
        JNE CHK_PAUSE
        CALL DRWWINNER
		call main
        RET                     ; Ends the game if f4 is clicked
CHK_PAUSE:
        COMPARE_KEY 03BH        ; Scan code of f1
        JNE GO
        PAUSE

        ; Handle click of first player
GO:     COMPARE_KEY  72   ; Scan code for UP arrow
        CALL_MACRO_IF_EQUAL MVSH1UP
        COMPARE_KEY  80   ; Scan code for DOWN arrow
        CALL_MACRO_IF_EQUAL MVSH1DOWN
        COMPARE_KEY 39H   ; Scan code for Space
        CALL_MACRO_IF_EQUAL ADDBULL

        ; Handle click of second player
        COMPARE_KEY 11H    ; Scan code for W
        CALL_MACRO_IF_EQUAL MVSH2UP
        COMPARE_KEY 1FH
        CALL_MACRO_IF_EQUAL MVSH2DOWN
        COMPARE_KEY 02DH    ; Scan code for X
        CALL_MACRO_IF_EQUAL ADDBULR

        JMP GM_LP

        RET
SHOW_GAME ENDP

;*************************************************
; ****  DRWINFO - Draws Players' Info ****
; * USES :  AX, BX, CX, DX
; * PARAMS :  NONE
; ************************************************
DRWINFO PROC
        ; Drawing Borders
        drow_thick_line BOARDER1FX,BOARDER1EX ,BOARDER1FY,BOARDERTHICK,BOARDSCOLOR  ; "dROW_THICK_line" IS MACRO TO DRAW UPPER BOARD
	drow_thick_line BOARDER1FX,BOARDER1EX,BOARDER1FY+15,BOARDERTHICK,BOARDSCOLOR  ; "dROW_THICK_line" IS MACRO TO DRAW MIDLE BOARD
	drow_thick_line BOARDER1FX,BOARDER1EX ,BOARDER1FY+32,BOARDERTHICK,BOARDSCOLOR  ; "dROW_THICK_line" IS MACRO TO DRAW down BOARD
	
	
	   ; Printing Strings
        MOVE_CURSOR  PLAYER1_SC_pX,PLAYER_SC_pY,0
        PRINTMESSAGE playership1
        MOVE_CURSOR  PLAYER2_SC_pX,PLAYER_SC_pY,0
        PRINTMESSAGE playership2
        ; Draw Chat Area
        MOVE_CURSOR  PLAYER1_SC_pX,PLAYER1_msg_py,0
        PRINTMESSAGE playership1
        MOVE_CURSOR  PLAYER1_SC_pX,PLAYER2_msg_py-1,0
        PRINTMESSAGE playership2
        MOVE_CURSOR  PLAYER1_SC_pX,PLAYER2_msg_py,0
        ; Draw End game statment
        PRINTMESSAGE st0
        RET
DRWINFO ENDP
;******************************************
;****DRAW heath 
;*****************************************
drawhelthsh1 proc
	push cx
	push si
	push di
	mov cx,0
	mov si,offset helthsh1fx
	mov di,offset helthsh1ex
	
	labh2:
	push cx
	drow_thick_line [si],[di] ,helthfy,helthlen,BGCOLOR
	add di,2
	add si,2
	pop cx
	inc cx
	cmp cx,10
	jnz labh2
	mov cx,0
	mov si,offset helthsh1fx
	mov di,offset helthsh1ex
	labh1:
	push cx
	drow_thick_line [si],[di] ,helthfy,helthlen,helthcolor
	add di,2
	add si,2
	pop cx
	inc cx
	cmp cx,sh1health
	jnz labh1
	
	pop di
	pop si 
	pop cx
	ret
drawhelthsh1 endp
;************************************************
drawhelthsh2 proc
	push cx
	push si
	push di
	mov cx,0
	mov si,offset helthsh2fx
	mov di,offset helthsh2ex
	
	labh3:
	push cx
	drow_thick_line [si],[di] ,helthfy,helthlen,BGCOLOR
	add di,2
	add si,2
	pop cx
	inc cx
	cmp cx,10
	jnz labh3
	mov cx,0
	mov si,offset helthsh2fx
	mov di,offset helthsh2ex
	labh4:
	push cx
	drow_thick_line [si],[di] ,helthfy,helthlen,helthcolor
	add di,2
	add si,2
	pop cx
	inc cx
	cmp cx,sh2health
	jnz labh4
	
	pop di
	pop si 
	pop cx
	ret
drawhelthsh2 endp

;*******************************************************
;*******************************************************
;               Game Helper functions
;*******************************************************
;*******************************************************

;*************************************************
; **** DRWWINNER - Function draws winner screen for 5 seconds ****
; * USES :  AX, BX, CX, DX
; * PARAMS :  NONE
; ************************************************
DRWWINNER PROC
        PREP_BACKBROUND 00h
        MOVE_CURSOR  07,07,0
        PRINTMESSAGE window_winner
        MOVE_CURSOR  0fh,09,0
        mov ax,sh2health
        CMP sh1health,ax
        ja labt1
        je labt2
        jb labt3
        labt1:
                PRINTMESSAGE playership1
                jmp endtlab
        labt2:
                PRINTMESSAGE equal_window
                jmp endtlab
        labt3:
                PRINTMESSAGE playership2
                jmp endtlab
        endtlab:
                DELAY
        RET
DRWWINNER ENDP

;*************************************************
; **** GAMECHAT - Function for in-game chatting ****
; * USES :  AX, BX, CX, DX
; * PARAMS : NONE
; ************************************************
GAMECHAT PROC
        RET
GAMECHAT ENDP

;*******************************************************
;*******************************************************
;               Ship drawing functions
;*******************************************************
;       can be moved into a separate module
;*******************************************************
;*******************************************************

;*************************************************
; **** DRWSHIPL - Draws both ship ****
; * USES :  ALL
; * PARAMS :  Param1 => Reg, Param2 => Reg, ...
; ************************************************
DRWSHIPS PROC
        drow_thick_line  sh1p1fx,sh1p1ENDx,sh1p1fy,ShipSizep1y,ship1color  ; "dROW_THICK_line" IS MACRO TO DRAW SHIP 1 PART 1
        drow_thick_line  sh1p2fx,sh1p2ENDx,sh1p2fy,ShipSizep2y,ship1color  ; "dROW_THICK_line" IS MACRO TO DRAW SHIP 1 PART 2
        drow_thick_line  sh2p1fx,sh2p1ENDx,sh2p1fy,ShipSizep1y,ship2color  ; "dROW_THICK_line" IS MACRO TO DRAW SHIP 2 PART 1
        drow_thick_line  sh2p2fx,sh2p2ENDx,sh2p2fy,ShipSizep2y,ship2color  ; "dROW_THICK_line" IS MACRO TO DRAW SHIP 2 PART 2
        RET
DRWSHIPS ENDP

;*******************************************************
;               Reflector drawing functions
;*******************************************************
;       can be moved into a separate module
;*******************************************************

;*************************************************
; ****  DRWREFL - Draws the reflector ****
; * USES :  AX, BX, CX, DX
; * PARAMS :  NONE
; ************************************************
DRWREFL PROC
        drow_thick_line REFfristX,REFendX,REFfristY,REFLECTORlen,REFLECTORCOLOR 
        RET
DRWREFL ENDP

; ***************************************************************
;       SOME BULLET FUNCTIONS
;****************************************************************
; MVBULLS - Main bullet movement logic 
MVBULLSPROC PROC FAR
        ; 1: Use SI to point to the start of the array
        MOV SI, offset bullPoses
BUL_START_LB:   
        ; 2: At the beginning of the loop check if SI points to bullet data
        ; We also check if no data here or reached the mark of the end and if so we break the loop to outside
        CMP [SI],0FFFFH
        JNE  COMPARE_FEFE
        RET
COMPARE_FEFE:
        CMP [SI],0FEFEH
        JNE  GO_BULLS_GO
        RET
GO_BULLS_GO:
        ; 3: Put the initial position of X and Y of the current bullet to CX, DX
        MOV CX, [SI]
        MOV DX, [SI+2]
        ; Note that SI is kept at the X position so as for MVBULL1 to store the new X position in
        ; To call the right function according to the type of the bullet, we know that the type of the bullet
        ; is stored in the MSB of YPos of the bullet, 1 if right and 0 if left, Ok ?
        ; This means that if the bullet is left, YPos will be less than 8000H
        ; We can use this piece of information to make condition on the type
        ; Recall that : CMP dist,src : if dist<src, CF is set (=1)
        CMP DX,8000H
        JNC R_MV        ; No carry means YPos > 8000H i.e. Right Bullet

        ;***************************************************************************
        ; LEFT BULLET CHECKS GOES HERE
        ;***************************************************************************
        ; 1. End of screen
        MOV AX,CX
        ADD AX,buW
        CMP AX, 320D
        JE DEL_BUL_LEFT
        ; 2. Ship
        ; TODO: -for me- Add comments
        MOV AX,CX
        ADD AX,buW
        INC AX
        CMP AX,sh2p2fx
        JNE BULL_CHECK_REFL
        MOV AX,sh2p1fy
        ADD AX,ShipSizep1y
        SUB AX,DX
        CMP AX,ShipSizep1y+3
        JNC BULL_CHECK_REFL
		mov fl,01h
        CALL DECP2HEALTH
        JMP DEL_BUL_LEFT
		
BULL_CHECK_REFL:
		CMP GAME_LEVEL,1
		JNZ BULL_CHECK_OTHERS  ; TO CHECK LEVEL ONE 
        ; 3.CONSTANT  Reflector
        ; TODO: -for me- Add comments
        MOV AX,CX
        ADD AX,buW
        INC AX
        CMP AX,REFfristX
        JNZ BULL_CHECK_OTHERS
        MOV AX,REFfristY
        ADD AX,REFLECTORlen
        SUB AX,DX
        CMP AX,REFLECTORlen+3
        JNC BULL_CHECK_OTHERS
        JMP INV_BULL

BULL_CHECK_OTHERS:
		;*******************************************************
		;ROCKET CHECKS
		;*******************************************************
		BULL_CHECK_Rocket:
		CMP ROCKET_ON,0
		JZ CHECK_POWER_UP
		; CMP ROCKET_XFLAG,0
		; JZ BULL_CHECK_HELTHROCKRIGHT
BULL_CHECK_HELTROCKLEFT:	
        MOV AX,CX
        ADD AX,buW
        INC AX
        CMP AX,ROCKETL_fx
        JE FOUND_X_ROCK_LEFT
        CMP AX,ROCKETR_fx
        JE FOUND_X_ROCK_RIGHT
        JMP CHECK_POWER_UP
FOUND_X_ROCK_LEFT:
        MOV ROCKET_XFLAG,0
        JMP SEARCH_ROCK_Y
FOUND_X_ROCK_RIGHT:
        MOV ROCKET_XFLAG,1
SEARCH_ROCK_Y:
        MOV AX,ROCKET_fy
        ADD AX,ROCKET_LEN
        SUB AX,DX
        CMP AX,ROCKET_LEN+3
        JNC CHECK_POWER_UP
		CMP ROCKET_COLOR,0DH
		JNZ DELETE_ROCK_ONLYL
		JMP INV_BULL
    DELETE_ROCK_ONLYL:
        JMP DEL_BUL_LEFT
        ;*******************************************************
        ;POWER UP CHECKS
        ;*******************************************************
CHECK_POWER_UP:
        CMP POWERUP_ON,0
        JZ  MOVE_BULLET_LEFT
        CMP POWERUP_L_IS_DRAWN,1
        JNZ BULL_CHECK_POWERUPRIGHT
	MOV AX,CX
        ADD AX,buW
        INC AX
        CMP AX,POWERUPL_fx
        JNE  BULL_CHECK_POWERUPRIGHT
        MOV POWERUP_XFLAG,0
        JMP SEARCH_POWERUP_Y
BULL_CHECK_POWERUPRIGHT:
        CMP POWERUP_R_IS_DRAWN,1
        JNZ MOVE_BULLET_LEFT
        MOV AX,CX
        ADD AX,buW
        INC AX
        CMP AX,POWERUPR_fx
        JNE MOVE_BULLET_LEFT
        MOV POWERUP_XFLAG,1
SEARCH_POWERUP_Y:        
        MOV AX,POWERUP_fy
        ADD AX,POWERUP_LEN
        SUB AX,DX
        CMP AX,POWERUP_LEN+3
        JNC MOVE_BULLET_LEFT
        CALL POWER_UP_CHECK_TYPE_SH1
        DELETE_POWERUP_ONLY
        JMP DEL_BUL_LEFT
       

        ; Call MVBULL, it moves the left bullet and stores the new position in [SI]
MOVE_BULLET_LEFT:
        CALL MVBULL
        JMP  END_BUL_LP
        
        ; Branch for left bullet deletion
DEL_BUL_LEFT:
        DEC p1_bulls
        JMP DEL_BUL

R_MV:   
        ; Don't forget that we store the type of the bullet in the MSB of YPos 
        ; but we don't want this to affect our drawing
        ; so we must make sure it's 0 before drawing or deleting
        AND DX, 7FFFH   
        
        ;***************************************************************************
        ; RIGHT BULLET CHECKS GOES HERE
        ;***************************************************************************
        ; 1. End of screen
        CMP CX, 00D
        JE  DEL_BUL_RIGHT
        ; 2. Ship
        ; TODO: -for me- Add comments
        MOV AX,CX
        DEC AX
        CMP AX,sh1p2ENDx
        JNZ BULR_CHECK_REFL
        MOV AX,sh1p1fy
        ADD AX,ShipSizep1y
        SUB AX,DX
        CMP AX,ShipSizep1y+3
        JNC BULR_CHECK_REFL
	mov fr,01h
        CALL DECP1HEALTH
        JMP DEL_BUL_RIGHT

BULR_CHECK_REFL:        
		CMP GAME_LEVEL,1
		JNZ BULR_CHECK_OTHERS   ; BECOUSE LEVEL ONE ONLY HAS CONSTANT REFLECTOR
        ; 3. CONSTANT Reflector
        ; TODO: -for me- Add comments
        CMP CX,REFendX
        JNE BULR_CHECK_OTHERS
        MOV AX,REFfristY
        ADD AX,REFLECTORlen
        SUB AX,DX
        CMP AX,REFLECTORlen+3
        JNC BULR_CHECK_OTHERS
        JMP INV_BULR

BULR_CHECK_OTHERS:

		
        ;*******************************************************
		; CHECK ROCKET
        ;*******************************************************
        BULL_CHECK_Rocket1:
        CMP ROCKET_ON,0
        JZ CHECK_POWER_UP_R
BULR_CHECK_HELTHROCKLEFT:		
        MOV AX,CX
        DEC AX
        CMP AX,ROCKETL_Ex
        JZ  R_FOUND_X_ROCK_LEFT
        CMP AX,ROCKETR_Ex
        JZ  R_FOUND_X_ROCK_RIGHT
        JMP CHECK_POWER_UP_R
R_FOUND_X_ROCK_LEFT:
        MOV ROCKET_XFLAG,0
        JMP R_SEARCH_ROCK_Y
R_FOUND_X_ROCK_RIGHT:
        MOV ROCKET_XFLAG,1
R_SEARCH_ROCK_Y:
        MOV AX,ROCKET_fy
        ADD AX,ROCKET_LEN
        SUB AX,DX
        CMP AX,ROCKET_LEN+3
        JNC CHECK_POWER_UP_R
		CMP ROCKET_COLOR,0DH
		JNZ DELETE_ROCK_ONLYr
		JMP INV_BULR	
      DELETE_ROCK_ONLYr:
        JMP DEL_BUL_RIGHT
        ;*******************************************************
		; CHECK POWERUP
        ;*******************************************************
CHECK_POWER_UP_R:
        CMP POWERUP_ON,0
        JZ MOVE_BULLET_RIGHT
        CMP POWERUP_L_IS_DRAWN,1
        JNZ BULR_CHECK_POWERUPRIGHT
        MOV AX,CX
        DEC AX
        CMP AX,POWERUPL_Ex
        JNE BULR_CHECK_POWERUPRIGHT
        MOV POWERUP_XFLAG,0
        JMP R_SEARCH_POWERUP_Y
BULR_CHECK_POWERUPRIGHT:
        CMP POWERUP_R_IS_DRAWN,1
        JNZ MOVE_BULLET_RIGHT
	MOV AX,CX
        DEC AX
        CMP AX,POWERUPR_Ex
        JNE MOVE_BULLET_RIGHT
        MOV POWERUP_XFLAG,1
R_SEARCH_POWERUP_Y:
        MOV AX,POWERUP_fy
        ADD AX,POWERUP_LEN
        SUB AX,DX
        CMP AX,POWERUP_LEN+3
        JNC MOVE_BULLET_RIGHT
        CALL POWER_UP_CHECK_TYPE_SH2
        DELETE_POWERUP_ONLY
        JMP DEL_BUL_RIGHT

MOVE_BULLET_RIGHT:
        ; Call MVBULR, it moves the left bullet and stores the new position in [SI]
        CALL MVBULR
        JMP END_BUL_LP 

        ; Branch for right bullet deletion
DEL_BUL_RIGHT:
        DEC p2_bulls        
DEL_BUL:
        CALL DELBUL
		CALL changeColor
        JMP END_BUL_LP_WITHOUT_INC
        
        ;Increment SI by 4 to get a new bullet position
END_BUL_LP:        
        ADD SI,4
END_BUL_LP_WITHOUT_INC:
        JMP BUL_START_LB

        ; Invert Left Bullet Branch
INV_BULL:
        CALL INVBUL
        CALL MVBULR
        JMP END_BUL_LP

        ; Invert Right Bullet Branch
INV_BULR:
        CALL INVBUL
        CALL MVBULL
        JMP END_BUL_LP

        ; 7: Sometimes we don't need to increment SI, e.g. after deleting a bullet due to the way we do deletion by shifting


BULL_OUT_LB: RET
MVBULLSPROC ENDP

;*******************************************
; **** MOVE  LEFT BULLET FUNCTION ***************
; **** Also saves the new position to memory
; * USES : CX , DX, DI
; * PARAMS : X_START => CX, Y_START => DX, 
;          : X_Store => DI     
; *****************************************
MVBULL PROC
        ; Black the first coloumn of the bullet
        DRWPX 00H        
        INC DX
        DRWPX 00H
        INC DX
        DRWPX 00H
        ; Save the new buX in memory
        INC CX
        MOV [SI],CX
        ; Set the position after the end of the bullet
        ADD CX,13H
        ;  White a new column after the end
        DRWPX 0FH        
        DEC DX
        DRWPX 0FH
        DEC DX
        DRWPX 0FH
        RET
MVBULL ENDP

;*******************************************
; **** MOVE RIGHT BULLET FUNCTION ***************
; **** Also saves the new position to memory
; * USES : CX , DX, DI
; * PARAMS : X_END => CX, Y_END => DX, 
;          : X_Store => DI     
; *****************************************
MVBULR PROC
        ; Save the new buX in memory
        DEC CX
        MOV [SI],CX
        ;  White a new coloumn before the start
        DRWPX 0FH        
        INC DX
        DRWPX 0FH
        INC DX
        DRWPX 0FH
        ; Set the position at the end of the bullet
        ADD CX,15H
        ; Black the last column of the bullet
        DRWPX 00H        
        DEC DX
        DRWPX 00H
        DEC DX
        DRWPX 00H
        RET
MVBULR ENDP

;*************************************************
; **** DELETE BULLET FUNCTION ****
; * USES : CX, DX, SI
; * PARAMS :  CX => Start_X, DX => Start_Y, SI => Store_X
; ************************************************
DELBUL  PROC
        ; OK, know we need to apply the best property of our array, shifted deletion !
        ; That is, if some bullet data is to be deleted, we move it at the end of the array and move the last element to its position
        ; This is valid because our array is a bag and we don't care about the order
        ; Our data to be deleted is in [SI],[SI+2]; and the last element is at [DI-4], [DI-2], so lets move it 
        PUSH [DI-4]
        POP  [SI]
        PUSH [DI-2]
        POP  [SI+2]
        ; Then we move DI backward in the array
        SUB  DI,4
        ; And we delete the last element data
        MOV  [DI], 0FFFFH
        MOV  [DI+2],0FFFFH
        PUSH SI         ; We will use it for looping, however, we still need it to complete the bullet loop
        MOV SI,CX
        ADD SI,buW
        INC SI        ; Fixing an error in deleting the right bullet
        ; Don't forget to correct YPos of the bullet to delete the effect of the type bit
        AND DX,7FFFH
UNDRW_L:  
        DRWPX 00H     ;DRAW PIXEL ON LINE ONE
        INC DX              ;GO DOWN A LINE
        DRWPX 00H     ;DRAW PIXEL ON LINE TWO
        INC DX              ;GO DOWN A LINE
        DRWPX 00H     ;DRAW PIXEL ON LINE TWO
        SUB DX,2
        INC CX              
        CMP CX,SI
        JNE UNDRW_L
        POP SI
        RET
DELBUL  ENDP


;*************************************************
; **** INVERT BULLET FUNCTION ****
; * USES : SI
; * PARAMS :  SI => Store_X
; ************************************************
INVBUL  PROC
        XOR [SI+2],8000H
        MOV DX, [SI+2]
        AND DX,7FFFH
        RET
INVBUL  ENDP

;*************************************************



;************************************************************************************************

; **** DECP1HEALTH - Decreases health of player1 and redraws the number + handles winning of P2****
; * USES :  AX, BX, CX, DX
; * PARAMS :  NONE
; ************************************************
DECP1HEALTH PROC
        MOV AX,sh1health
        SUB AX,bullRPwr
		pusha
		CMP sh1health, 1
        JlE PLAYER2_WINS        ; Because the signed value of the health can be negative so we need signed comparison
		CMP SH1PROTECT_FLAG,0
		JZ LABDC1
		DEC SH1TIMES_PROTECT
		CMP SH1TIMES_PROTECT,0
		JNZ EMDD
		MOV SH1PROTECT_FLAG,0
		MOV SHIP1COLOR,33H
		CALL DRWSHIPS
		JMP EMDD
		LABDC1:
		dec sh1health
		call drawhelthsh1
		EMDD:
		popa
        JMP OUT_DECH1_LB
		
        ; TODO: Redraw the number
PLAYER2_WINS: ; winner 
        MOV IsThereAWinner, 01H
	PREP_BACKBROUND 00h
        MOVE_CURSOR  07,07,0
        PRINTMESSAGE window_winner
        MOVE_CURSOR  0fh,09,0
        PRINTMESSAGE playership2
        PRINTMESSAGE st7
        DELAY
OUT_DECH1_LB:        
        RET
DECP1HEALTH ENDP

;*************************************************
; **** DECP2HEALTH - Decreases health of player2 and redraws the number + handles winning of P1****
; * USES :  AX, BX, CX, DX
; * PARAMS :  NONE
; ************************************************
DECP2HEALTH PROC
        MOV AX,sh2health
        SUB AX,bullLPwr
		pusha
		CMP sh2health, 1
        JlE PLAYER1_WINS        ; Because the signed value of the health can be negative so we need signed comparison
		CMP SH2PROTECT_FLAG,0
		JZ LABDC21
		DEC SH2TIMES_PROTECT
		CMP SH2TIMES_PROTECT,0
		JNZ EMDD2
		MOV SH2PROTECT_FLAG,0
		MOV SHIP2COLOR,33H
		CALL DRWSHIPS
		JMP EMDD2
		LABDC21:
		dec sh2health
		call drawhelthsh2
		EMDD2:
		popa
        JMP OUT_DECH2_LB
PLAYER1_WINS:
		MOV IsThereAWinner, 01H
		PREP_BACKBROUND 00h
        MOVE_CURSOR  07,07,0
        PRINTMESSAGE window_winner
        MOVE_CURSOR  0fh,09,0
        PRINTMESSAGE playership1
        PRINTMESSAGE st7
        DELAY
OUT_DECH2_LB:      
        RET
DECP2HEALTH ENDP


POWER_UP_CHECK_TYPE_SH2 Proc
		CMP POWERUP_COLOR,HELTH_UP
		JNZ CMPARE_SPEAD_UP
		CALL INCSH2HEALTH
		JMP ENDPROC
		CMPARE_SPEAD_UP:
		CMP POWERUP_COLOR,SPEAD_UP
		JNZ CMPARE_SPEAD_DOWN
		CALL Speed_UP_Sh2_Health
		JMP ENDPROC
		CMPARE_SPEAD_DOWN:
		CMP POWERUP_COLOR,SPEAD_DOWN
		JNZ CMPARE_PROTECT
		CALL DELAY_SPEED2
		JMP ENDPROC
		CMPARE_PROTECT:
		CMP POWERUP_COLOR,PROTECT
		JNZ ENDPROC
		CALL INC_PROTECTBULLETRIGHT
		ENDPROC:
			RET
POWER_UP_CHECK_TYPE_SH2 ENDP

POWER_UP_CHECK_TYPE_SH1 Proc
		CMP POWERUP_COLOR,HELTH_UP
		JNZ CMPARE_SPEAD_UP1
		CALL INCSH1HEALTH
		JMP ENDPROC1
		CMPARE_SPEAD_UP1:
		CMP POWERUP_COLOR,SPEAD_UP
		JNZ CMPARE_SPEAD_DOWN1
		CALL Speed_UP_Sh1_Health
		JMP ENDPROC1
		CMPARE_SPEAD_DOWN1:
		CMP POWERUP_COLOR,SPEAD_DOWN
		JNZ CMPARE_PROTECT1
		CALL DELAY_SPEED1
		JMP ENDPROC1
		CMPARE_PROTECT1:
		CMP POWERUP_COLOR,PROTECT
		JNZ ENDPROC1
		CALL INC_PROTECTBULLETLEFT
		ENDPROC1:
			RET
POWER_UP_CHECK_TYPE_SH1 ENDP

INC_PROTECTBULLETLEFT Proc
	    PUSHA
		PUSH DI
		PUSH SI
		MOV SH1PROTECT_FLAG,1
		MOV SHIP1COLOR,PROTECT
		CALL DRWSHIPS
		MOV SH1TIMES_PROTECT,5
		POP SI
		POP DI
		POPA
		RET
INC_PROTECTBULLETLEFT ENDP

INC_PROTECTBULLETRIGHT Proc
	    PUSHA
		PUSH DI
		PUSH SI
		MOV SH2PROTECT_FLAG,1
		MOV SHIP2COLOR,PROTECT
		CALL DRWSHIPS
		MOV SH2TIMES_PROTECT,5
		POP SI
		POP DI
		POPA
		RET
INC_PROTECTBULLETRIGHT ENDP

;*****************************************************
 Speed_UP_Sh1_Health Proc
	 PUSHA
	 PUSH DI
	 PUSH SI
	 inc Ship1_Speed	
	 POP SI
	 POP DI
	 POPA
	 RET
 Speed_UP_Sh1_Health ENDP
;************************************

;**********************************
Speed_UP_Sh2_Health PROC
	PUSHA
	PUSH DI
	PUSH SI
	inc Ship2_Speed
	POP SI
	POP DI
	POPA
	RET
RET
Speed_UP_Sh2_Health ENDP
;***********************************************************************
DELAY_SPEED1 Proc
	PUSHA
	PUSH DI
	PUSH SI	 
	cmp Ship1_Speed,1
JBE exit_out
dec Ship1_Speed
exit_out:	
	POP SI
	POP DI
	POPA	
	RET
DELAY_SPEED1 ENDP
;**********************************************
DELAY_SPEED2 Proc
	PUSHA
	PUSH DI
	PUSH SI	 
	cmp Ship2_Speed,1
JBE exit_out1
dec Ship2_Speed
exit_out1:	
	POP SI
	POP DI
	POPA	
	RET
DELAY_SPEED2 ENDP


INCSH2HEALTH PROC 
	PUSHA
	PUSH DI
	PUSH SI
	cmp sh2health,10
	jz  conthb2
	inc sh2health
	call drawhelthsh2
	conthb2:
	POP SI
	POP DI
	POPA
	RET
INCSH2HEALTH ENDP

INCSH1HEALTH PROC 
	PUSHA
	PUSH DI
	PUSH SI
	cmp sh1health,10
	jz  conthb
	inc sh1health
	call drawhelthsh1
	conthb:
	POP SI
	POP DI
	POPA
	RET

INCSH1HEALTH ENDP

changeColor proc
cmp fr,01h;flag for ship1 if bullet touch ship1
je color_Right; if yes chang color of ship1
jne check_color_Left;check for ship2
color_Right:
call changeColorRight
check_color_Left:
cmp fl,00h;flag if bullet touch screen 
JE exit1;do nothing
;else change color of ship2
drow_thick_line  sh2p1fx,sh2p1ENDx,sh2p1fy,ShipSizep1y,ship2Damage; "dROW_THICK_line" IS MACRO TO DRAW SHIP 2 PART 1
drow_thick_line  sh2p2fx,sh2p2ENDx,sh2p2fy,ShipSizep2y,ship2Damage  ; "dROW_THICK_line" IS MACRO TO DRAW SHIP 2 PART 2
jmp continue ; to avoide out of range
;******************
exit1:
jmp exit;to avoide out of range
;***************
continue:
push ax; to save it's value ,if it used in other function before 
mov ax,0ffffh;time of change color of ship
Time_loop_Continue:
 cmp ax,0
 dec ax
 jz Time_loop_End
 jnz Time_loop_Continue
Time_loop_End:
pop ax
;Returne color of ship 
drow_thick_line  sh2p1fx,sh2p1ENDx,sh2p1fy,ShipSizep1y,ship2color  ; "dROW_THICK_line" IS MACRO TO DR
drow_thick_line  sh2p2fx,sh2p2ENDx,sh2p2fy,ShipSizep2y,ship2color  ; "dROW_THICK_line" IS MACRO TO DRA
mov fl,00h;return default of flag value
exit:
ret
changeColor endp
;**************************************
changeColorRight proc
;change color of ship1
drow_thick_line  sh1p1fx,sh1p1ENDx,sh1p1fy,ShipSizep1y,ship2Damage  ; "dROW_THICK_line" IS MACRO TO DRAW SHIP 1 PART 1
drow_thick_line  sh1p2fx,sh1p2ENDx,sh1p2fy,ShipSizep2y,ship2Damage  ; "dROW_THICK_line" 
;***************
push ax
mov ax,0ffffh;time of change color of ship
Time_loop_Continue1:
cmp ax,0
dec ax
jz Time_loop_End1
jnz Time_loop_Continue1
Time_loop_End1:
pop ax
;return color of ship1
drow_thick_line  sh1p1fx,sh1p1ENDx,sh1p1fy,ShipSizep1y,ship1color  ; "dROW_THICK_line" IS MACRO TO DRAW SHIP 1 PART 1
drow_thick_line  sh1p2fx,sh1p2ENDx,sh1p2fy,ShipSizep2y,ship1color  ; "dROW_THICK_line" 
mov fr,00h;return default of flag value
exit3:
ret
changeColorRight endp

CLRMEMORY PROC
        ; Reset winner flag
        MOV IsThereAWinner, 00H
        ; Reset variable data of ship1
        MOV sh1p1fy,1D
        MOV sh1p2fy,12D
        ; Reset variable data of ship2
        MOV sh2p1fy,1D
        MOV sh2p2fy,12D
        ; Reset variable data of the reflector
        MOV REFfristY, 1D
        MOV REFflag, 1D
        MOV REFCTR, 0FFFH
        ; Reset bullets array
        CMP [DI], 0FEFEH
        JNE START_WITHOUT_INITIAL_DECREMENT
        SUB DI,4
START_WITHOUT_INITIAL_DECREMENT:
        MOV [DI], 0FFFFH
        MOV [DI+2], 0FFFFH
        CMP DI,offset bullPoses
        JE FINISHED_CLEANING_BULLS
        SUB DI,4
        JMP START_WITHOUT_INITIAL_DECREMENT
FINISHED_CLEANING_BULLS:
        ; Reset bullets counter
        MOV bullLCtr, bullLSpeed
        MOV bullRCtr, bullRSpeed
        ; Reset health
	MOV sh1health,10D
        MOV sh2health,10D  
		MOV ROCKET_COLOR,0CH
        ; Check for any undeleted powerups and delete them
       ; MOV HB_ON,0H
        RET
CLRMEMORY ENDP
END	MAIN