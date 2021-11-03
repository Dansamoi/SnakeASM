IDEAL
MODEL small
STACK 9999h
DATASEG

;for pictures
MAX_BMP_WIDTH = 320
MAX_BMP_HEIGHT = 200
SMALL_BMP_HEIGHT = 40
SMALL_BMP_WIDTH = 40

; --------------------------
eyesBefore dw 100, 99, 100, 101
snakeLength dw 8 ;the snake length. every square is 4
snakePushed dw 0 ;the times the head X or Y coordinates pushed
waiting dw 2000h ;waiting time between drawing the head
headArr dw 102, 99 ;the coordinates of the head
points dw 159, 30, 228, 168, 90, 99, 228, 99, 159, 168, 87, 30, 240,96 ;the white point coordinates
thisPoint dw 159, 30 ;the point the snake need to it this time
pointer dw 0
score dw -1, 0, 0 ;the score right now
scoreCord dw 283, 273, 263, 60 ;the score pictures bmpLeft value
counter dw ?
direction db 2 ;0 - for horizontal, 1 - for vertical, 2- no direction
side db ? ;0 - left, 1 - right, 2-up, 3- down
changed db 0 ;does he already changed in the waiting loop

;for pictures
ScreenLineMax db MAX_BMP_WIDTH dup (0)  ; One Color line read buffer
;BMP Files data
FileHandle dw ?
Header db 54 dup(0)
Palette db 400h dup (0)
picPause db 'pause.bmp',0
MainMenuPic db 'MainMenu.bmp',0
GameOverPic db 'GameOver.bmp',0
TutorialPic db 'rules.bmp',0
border1pic db 'border1.bmp', 0
border2pic db 'border2.bmp', 0
pic0 db 'num0.bmp', 0
pic1 db 'num1.bmp', 0
pic2 db 'num2.bmp', 0
pic3 db 'num3.bmp', 0
pic4 db 'num4.bmp', 0
pic5 db 'num5.bmp', 0
pic6 db 'num6.bmp', 0
pic7 db 'num7.bmp', 0
pic8 db 'num8.bmp', 0
pic9 db 'num9.bmp', 0
ErrorFile db 0
BmpLeft dw ?
BmpTop dw ?
BmpColSize dw ?
BmpRowSize dw ?	 

; --------------------------
CODESEG
; ---------------------------------------------
; all the following procedures use the pictures
; ---------------------------------------------

;showScore proc is control the score that shown
;in the right side of the screen. The method uses
;the pictures of the numbers and show the right
;picture for the right number in the score array.
proc showScore
	;set the parameters that simillar for every num
	mov bx, offset score
	push ax
	mov ax, [offset scoreCord + 6]
	mov [BmpTop], ax
	pop ax
	mov [BmpColSize], 40
	mov [BmpRowSize], 40
	
	;this part set the right numbers in the score array
	;if number is equal to 10 it turn to 0 and inc the
	;next one
	inc [word ptr bx]
	xor si, si
	NextNum:
	cmp [word ptr bx + si], 10
	je addOneToNext
	jmp afterCheck
	addOneToNext:
		sub [word ptr bx + si], 10
		add si, 2
		cmp si, 4
		je afterCheck
		inc [word ptr bx + si]
		jmp NextNum
		
	;at this part the code choose the right pic for the
	;right num and show it
	afterCheck:
	mov bx, offset score
	mov si, 4
	afterCheck1:
	cmp [word ptr offset score + si], 0
	je num0
	cmp [word ptr offset score + si], 1
	je num1
	cmp [word ptr offset score + si], 2
	je num2
	cmp [word ptr offset score + si], 3
	je num3
	cmp [word ptr offset score + si], 4
	je num4Station
	cmp [word ptr offset score + si], 5
	je num5Station
	cmp [word ptr offset score + si], 6
	je num6Station
	cmp [word ptr offset score + si], 7
	je num7Station
	cmp [word ptr offset score + si], 8
	je num8Station
	cmp [word ptr offset score + si], 9
	je num9Station
	;stations used to jmp from one point 
	;to other because it too far
	num4Station:
		jmp num4
	num5Station:
		jmp num5
	num6Station:
		jmp num6
	num7Station:
		jmp num7
	num8Station:
		jmp num8
	num9Station:
		jmp num9
	;show number0
	num0:
		push si
		mov bx, offset scoreCord
		mov cx, [bx + si]
		mov [BmpLeft],cx
		mov dx,offset pic0
		call OpenShowBmp
		pop si
		jmp afterShow
	;show number1
	num1:
		push si
		mov bx, offset scoreCord
		mov cx, [bx + si]
		mov [BmpLeft],cx
		mov dx,offset pic1
		call OpenShowBmp
		pop si
		jmp afterShow
	;show number2
	num2:
		push si
		mov bx, offset scoreCord
		mov cx, [bx + si]
		mov [BmpLeft],cx
		mov dx,offset pic2
		call OpenShowBmp
		pop si
		jmp afterShow
	;show number3
	num3:
		push si
		mov bx, offset scoreCord
		mov cx, [bx + si]
		mov [BmpLeft],cx
		mov dx,offset pic3
		call OpenShowBmp
		pop si
		jmp afterShow
	;show number4
	num4:
		push si
		mov bx, offset scoreCord
		mov cx, [bx + si]
		mov [BmpLeft],cx
		mov dx,offset pic4
		call OpenShowBmp
		pop si
		jmp afterShow
	;show number5
	num5:
		push si
		mov bx, offset scoreCord
		mov cx, [bx + si]
		mov [BmpLeft],cx
		mov dx,offset pic5
		call OpenShowBmp
		pop si
		jmp afterShow
	;show number6
	num6:
		push si
		mov bx, offset scoreCord
		mov cx, [bx + si]
		mov [BmpLeft],cx
		mov dx,offset pic6
		call OpenShowBmp
		pop si
		jmp afterShow
	;show number7
	num7:
		push si
		mov bx, offset scoreCord
		mov cx, [bx + si]
		mov [BmpLeft],cx
		mov dx,offset pic7
		call OpenShowBmp
		pop si
		jmp afterShow
	;show number8
	num8:
		push si
		mov bx, offset scoreCord
		mov cx, [bx + si]
		mov [BmpLeft],cx
		mov dx,offset pic8
		call OpenShowBmp
		pop si
		jmp afterShow
	;show number9
	num9:
		push si
		mov bx, offset scoreCord
		mov cx, [bx + si]
		mov [BmpLeft],cx
		mov dx,offset pic9
		call OpenShowBmp
		pop si
		jmp afterShow
	afterShow:
	cmp si, 0
	je exitFromShow
	sub si, 2
	jmp afterCheck1
	exitFromShow:
	ret
endp showScore

;this method enter the player to main menu and show
;the picture of the main menu until he press space or Esc
proc mainMenu
	mov ax, 13h
	int 10h
	mov [BmpLeft],0
	mov [BmpTop],0
	mov [BmpColSize], 320
	mov [BmpRowSize] ,200
	mov dx,offset MainMenuPic
	call OpenShowBmp
	mainMenu1:
	in al, 60h
	;check if Esc is pressed
	cmp al, 1h
	jne afterEsc
	mov ah,0
	int 16h
	mov ax,2
	int 10h
	mov ax, 4c00h
	int 21h	
	afterEsc:
	;check if Space is pressed
	cmp al, 39h
	je exitFromMenu
	jmp mainMenu1
	exitFromMenu:
	mov ah,0
	int 16h
	mov ax,2
	int 10h
	ret
endp mainMenu


;this method enter the player to pause menu when he press P
;and show the picture of the pause menu until he press space
;or press esc for exit the game
proc pauseMenu
	mov ax, 13h
	int 10h
	mov [BmpLeft],0
	mov [BmpTop],0
	mov [BmpColSize], 320
	mov [BmpRowSize] ,200
	mov dx,offset picPause
	call OpenShowBmp
	pauseMenu1:
	in al, 60h
	;check if Esc is pressed
	cmp al, 1h
	jne afterEsc1
	mov ah,0
	int 16h
	mov ax,2
	int 10h
	mov ax, 4c00h
	int 21h	
	afterEsc1:
	cmp al, 39h
	je exitFromMenu1
	jmp pauseMenu1
	exitFromMenu1:
	mov ah,0
	int 16h
	mov ax,2
	int 10h
	ret
endp pauseMenu

;this method enter the player to game over screen and show the 
;picture of the game over screen until the player press Esc
;the player enter this screen when he lose the game
;(touched himself or the borders).
proc GameOver
	mov ax, 13h
	int 10h
	mov [BmpLeft],0
	mov [BmpTop],0
	mov [BmpColSize], 320
	mov [BmpRowSize] ,200
	mov dx,offset GameOverPic
	call OpenShowBmp
	
	;showScore inc the score
	dec [word ptr offset score]
	
	;set new cord
	mov [word ptr offset scoreCord], 198
	mov [word ptr offset scoreCord + 2], 188
	mov [word ptr offset scoreCord + 4], 178
	mov [word ptr offset scoreCord + 6], 120
	call showScore
	
	gameOver1:
	in al, 60h
	cmp al, 1
	je exitFromGameOver
	jmp gameOver1
	exitFromGameOver:
	ret
endp GameOver

;this method enter the player to tutorial screen and show the 
;picture of the tutorial screen until the player press Esc
;the player enter this screen when he press F1 while in-game.
proc tutorial
	mov ax, 13h
	int 10h
	mov [BmpLeft],0
	mov [BmpTop],0
	mov [BmpColSize], 320
	mov [BmpRowSize] ,200
	mov dx,offset TutorialPic
	call OpenShowBmp
	TutorialMenu1:
	in al, 60h
	cmp al, 1
	je exitFromTutorial
	jmp TutorialMenu1
	exitFromTutorial:
	ret
endp tutorial

;this method show the borders that on them make the game
;more estetic and show the player the score on them and the
;how to enter the tutorial.
proc borders
	mov ax, 13h
	int 10h
	mov [BmpLeft],0
	mov [BmpTop],-1
	mov [BmpColSize], 60
	mov [BmpRowSize] ,200
	mov dx,offset border1pic
	call OpenShowBmp
	mov [BmpLeft],261
	mov [BmpTop],-1
	mov dx,offset border2pic
	call OpenShowBmp
	ret
endp borders

;for pictures
; ---------------------------------------------
; all the following procedures are used to show
; pictures. The following code was sent by Yanon
; Barnea in the moodle.
; ---------------------------------------------

; input :
;	1.BmpLeft offset from left (where to start draw the picture) 
;	2. BmpTop offset from top
;	3. BmpColSize picture width , 
;	4. BmpRowSize bmp height 
;	5. dx offset to file name with zero at the end 
proc OpenShowBmp near
	push cx
	push bx
	call OpenBmpFile
	cmp [ErrorFile],1
	je @@ExitProc
	call ReadBmpHeader
	; from  here assume bx is global param with file handle. 
	call ReadBmpPalette
	call CopyBmpPalette
	call ShowBMP 
	call CloseBmpFile
@@ExitProc:
	pop bx
	pop cx
	ret
endp OpenShowBmp	
; input dx filename to open
proc OpenBmpFile	near						 
	mov ah, 3Dh
	xor al, al
	int 21h
	jc @@ErrorAtOpen
	mov [FileHandle], ax
	jmp @@ExitProc	
@@ErrorAtOpen:
	mov [ErrorFile],1
@@ExitProc:	
	ret
endp OpenBmpFile

proc CloseBmpFile near
	mov ah,3Eh
	mov bx, [FileHandle]
	int 21h
	ret
endp CloseBmpFile

; Read 54 bytes the Header
proc ReadBmpHeader	near					
	push cx
	push dx
	mov ah,3fh
	mov bx, [FileHandle]
	mov cx,54
	mov dx,offset Header
	int 21h
	pop dx
	pop cx
	ret
endp ReadBmpHeader

proc ReadBmpPalette near ; Read BMP file color palette, 256 colors * 4 bytes (400h)
						 ; 4 bytes for each color BGR + null)			
	push cx
	push dx
	mov ah,3fh
	mov cx,400h
	mov dx,offset Palette
	int 21h
	pop dx
	pop cx
	ret
endp ReadBmpPalette


; Will move out to screen memory the colors
; video ports are 3C8h for number of first color
; and 3C9h for all rest
proc CopyBmpPalette		near					
										
	push cx
	push dx
	mov si,offset Palette
	mov cx,256
	mov dx,3C8h
	mov al,0  ; black first							
	out dx,al ;3C8h
	inc dx	  ;3C9h
CopyNextColor:
	mov al,[si+2] 		; Red				
	shr al,2 			; divide by 4 Max (cos max is 63 and we have here max 255 ) (loosing color resolution).				
	out dx,al 						
	mov al,[si+1] 		; Green.				
	shr al,2            
	out dx,al 							
	mov al,[si] 		; Blue.				
	shr al,2            
	out dx,al 							
	add si,4 			; Point to next color.  (4 bytes for each color BGR + null)				
								
	loop CopyNextColor
	pop dx
	pop cx
	ret
endp CopyBmpPalette

proc ShowBMP 
; BMP graphics are saved upside-down.
; Read the graphic line by line (BmpRowSize lines in VGA format),
; displaying the lines from bottom to top.
	push cx
	mov ax, 0A000h
	mov es, ax
	mov cx,[BmpRowSize]
	mov ax,[BmpColSize] ; row size must dived by 4 so if it less we must calculate the extra padding bytes
	xor dx,dx
	mov si,4
	div si
	mov bp,dx
	mov dx,[BmpLeft]
@@NextLine:
	push cx
	push dx
	mov di,cx  ; Current Row at the small bmp (each time -1)
	add di,[BmpTop] ; add the Y on entire screen
	; next 5 lines  di will be  = cx*320 + dx , point to the correct screen line
	mov cx,di
	shl cx,6
	shl di,8
	add di,cx
	add di,dx
	; small Read one line
	mov ah,3fh
	mov cx,[BmpColSize]  
	add cx,bp  ; extra  bytes to each row must be divided by 4
	mov dx,offset ScreenLineMax
	int 21h
	; Copy one line into video memory
	cld ; Clear direction flag, for movsb
	mov cx,[BmpColSize]  
	mov si,offset ScreenLineMax
	rep movsb ; Copy line to the screen
	pop dx
	pop cx
	loop @@NextLine
	pop cx
	ret
endp ShowBMP 

proc SetGraphic
	mov ax,13h   ; 320 X 200 
				 ;Mode 13h is an IBM VGA BIOS mode. It is the specific standard 256-color mode 
	int 10h
	ret
endp SetGraphic

; ----------------------------------------------
; all the following procedures used to the snake
; game itself.
; ----------------------------------------------


;the one_dot method is a help method, it used in a
;lot of other methods to draw a dot on the screen
proc one_dot
	mov bh,0h
	mov ah,0ch
	int 10h
	ret
endp one_dot

;the following method check the direction of the
;snake, and give the player change it by using the
;A S D and W keys, but if the direction vertical,
;the user can change to horizontal and if the direction 
;horizontal, the user can change to vertical
;if hasn't direction - he can change to everything he want
proc directionChange
	cmp [changed], 1
	je beforeExitFromChange
	cmp [direction], 0;check if was horizontal
	je vertical
	cmp [direction], 1;check if was vertical
	je horizontal
	cmp [direction], 2;check if was none
	je noneODirection
	
	noneODirection:
	in al, 60h
	;check if S is pressed
	cmp al, 1Fh
	je down
	;check if W is pressed
	cmp al, 11h
	je up
	;check if D is pressed
	cmp al, 20h
	je right
	jmp exitFromChange
	
	;if was horizontal, checks this
	vertical:
	in al, 60h
	;check if S is pressed
	cmp al, 1Fh
	je down
	;check if W is pressed
	cmp al, 11h
	je up
	jmp exitFromChange
	
	;if was vertical, checks this
	horizontal:
	in al, 60h
	;check if A is pressed
	cmp al, 1Eh
	je left
	;check if D is pressed
	cmp al, 20h
	je right
	jmp exitFromChange
	
	up:
	mov [direction], 1 ;change to vertical
	mov [side], 2 ;change to up
	jmp beforeExitFromChange
	
	left:
	mov [direction], 0 ;change to horizontal
	mov [side], 0 ;change to left
	jmp beforeExitFromChange
	
	right:
	mov [direction], 0 ;change to horizontal
	mov [side], 1 ;change to right
	jmp beforeExitFromChange
	
	down:
	mov [direction], 1 ;change to vertical
	mov [side], 3 ;change to down
	jmp beforeExitFromChange
	
	beforeExitFromChange:
	mov [changed], 1
	exitFromChange:
	ret

endp directionChange

;the following method check the direction of the
;snake, change the head coordinates in accordance.
proc directionAdd
	cmp [side], 0
	je left1
	cmp [side], 1
	je right1
	cmp [side], 2
	je up1
	cmp [side], 3
	je down1
	up1:
	;moving the head up
	sub [word ptr offset headArr + 2], 3
	mov [direction], 1
	mov [side], 2
	jmp exitFromAdd
	
	left1:
	;moving the head left 
	sub [word ptr offset headArr], 3
	mov [direction], 0
	mov [side], 0 
	jmp exitFromAdd
	
	right1:
	;moving the head right
	add [word ptr offset headArr], 3
	mov [direction], 0
	mov [side], 1
	jmp exitFromAdd
	
	down1:
	;moving the head down
	add [word ptr offset headArr + 2], 3
	mov [direction], 1
	mov [side], 3
	jmp exitFromAdd
	
	exitFromAdd:
	ret
endp directionAdd

;the isTouchedItself method is check every time the player
;has moved if he touched the other parts of him. By using 
;snakeLength, the method knows where the last element of
;the stack that he need to check.
proc isTouchedItself
	push bp
	mov bp, sp
	mov si, 4
	;check if the x of the head is simillar to the x
	;of that in the stack. if yes, it checks if the y 
	;is similar to the element next to the x element
	;(the y). The register ax is used like a flag, if
	;he touched itself ax=1, if not ax=0. after this
	;method, it checks if ax is 1 and if so it resets
	;the game
	checkX:
		cmp si, [snakeLength]
		je False
		add si, 4
		mov cx, [offset headArr]
		mov ax, [bp + si]
		cmp ax, cx
		je checkY
		jmp checkX
	checkY:
		mov cx, [offset headArr + 2]
		add si, 2
		mov ax, [bp + si]
		cmp cx, ax
		je True
		sub si, 2
		jmp checkX
	True:
	mov ax, 1
	jmp exitFromHere
	False:
	xor ax, ax
	exitFromHere:
	pop bp
	ret
endp isTouchedItself

;the procedure is draw the eyes of the snake.
proc eyesDraw
	;erase last eyes
	mov al, 2
	mov cx, [offset eyesBefore]
	mov dx, [offset eyesBefore + 2]
	call one_dot
	
	mov cx, [offset eyesBefore + 4]
	mov dx, [offset eyesBefore + 6]
	call one_dot
	
	mov al, 1111111b
	cmp [direction], 1
	je verticalEyes
	
	;draw eyes in horizontal direction
	;draw first eye
	mov cx, [offset headArr]
	mov dx, [offset headArr + 2]
	inc cx
	call one_dot
	mov [word ptr offset eyesBefore], cx
	mov [word ptr offset eyesBefore + 2], dx
	
	;draw second eye
	add dx, 2
	call one_dot
	mov [word ptr offset eyesBefore + 4], cx
	mov [word ptr offset eyesBefore + 6], dx
	jmp exitDrawEyes
	
	;draw eyes in vertical direction
	verticalEyes:
	;draw first eye
	mov cx, [offset headArr]
	mov dx, [offset headArr + 2]
	inc dx
	call one_dot
	mov [word ptr offset eyesBefore], cx
	mov [word ptr offset eyesBefore + 2], dx
	
	;draw second eye
	add cx, 2
	call one_dot
	mov [word ptr offset eyesBefore + 4], cx
	mov [word ptr offset eyesBefore + 6], dx
	exitDrawEyes:
	ret
endp eyesDraw

;before call the drawSnake method, the color of the snake or
;the background moved to al. the method draw all over the snake,
;by going over all the elements in the stack, with this color and
;wait some time. by repeating calling this method I created
;animation that of the snake death, or just call the procedure
;after returning to the game screen.
proc drawSnake
	push bp
	mov bp, sp
	mov bx, 0
	xor si, si
	eraseDraw:
		cmp si, [snakeLength]
		je afterIt
		add si, 4
		mov cx, [bp + si]
		mov dx, [bp + si + 2]
		dec dx
		mov di, 4
		LoopY:
		mov [counter], 3
		mov cx, [bp + si]
		inc dx
		dec di
		cmp di, 0
		je eraseDraw
		LoopX:
		call one_dot
		inc cx
		dec [counter]
		cmp [counter], 0
		je LoopY
		jmp LoopX
		afterit:
	mov cx, 9000h
	waitingFor:
		push cx
		mov cx, 27h
		waitingFor1:
		loop waitingFor1
		pop cx
	loop waitingFor
	
	call eyesDraw
	
	pop bp
	ret
endp drawSnake

;drawPoint method is called when the game starts or the the snake
;ate the point. the method draw the next point that the snake need
;eat and make him bigger by increasing the snakeLength.
;it choose the next point from the points array, draw it and set it
;as thisPoint.
proc drawPoint
	push bp
	mov bp, sp
	;check if the x of the point is simillar to the x
	;of the snake in the stack. if yes, it check if the y 
	;is similar to the element next to the x element
	;(the y). If it simmilar, the point changed to the next
	;point. If the snake touch all the the point (repeat the
	;loop 6 times, until counter is zero), the point is not shown
	mov [counter], 6
	mov bx, offset points
	mov di, [pointer]
	sub [pointer], 4
	sub di, 4
	nextPoint:
	add [pointer], 4
	cmp [pointer], 24
	jne resetPointer
	mov [pointer], 0
	resetPointer:
	cmp [counter], 0
	je ending
	dec [counter]
	cmp di, 20
	jne after
	sub di, 24
	after:
	add di, 4
	xor si, si
	mov cx, [bx + di]
	mov dx, [bx + di + 2]
	
	checkSnake:
	cmp si, [snakeLength]
	je thisIs
	add si, 4
	cmp [bp + si], cx
	jne checkSnake
	cmp [bp + si + 2], dx
	je nextPoint
	jmp checkSnake
	thisIs:
	add [snakeLength], 4
	mov bx, offset points
	mov cx, [bx + di]
	mov dx, [bx + di + 2]
	mov bx, offset thisPoint
	mov [bx], cx
	mov [bx + 2], dx
	mov al, 255
	mov di, cx ;save cx for compare
	mov si, dx ;save dx for compare
	dec di
	dec si
	add dx, 2
	dec cx
	before:
	add cx, 3
	drawX:
	call one_dot
	dec cx
	cmp cx, di
	jne drawX
	dec dx
	cmp dx, si
	jne before
	ending:
	pop bp
	ret
endP drawPoint


;eraseLast method erase the last part of the snake body
;by using snakeLength to get the x and y from the stack
proc eraseLast
	push bp
	mov bp, sp
	mov al, 12
	mov si, [snakeLength]
	add si, 4
	mov cx, [bp + si]
	mov dx, [bp + si + 2]
	mov di, cx ;save cx for compare
	mov si, dx ;save dx for compare
	dec di
	dec si
	add dx, 2
	dec cx
	beforeIt:
	add cx, 3
	Xloop1:
	call one_dot
	dec cx
	cmp cx, di
	jne Xloop1
	dec dx
	cmp dx, si
	jne beforeIt
	pop bp
	ret
endP eraseLast

;headDraw method is draw the head of the snake by using
;the coordinates of it that in headArr array.
proc headDraw
	mov bx, offset headArr
	xor si, si
	mov al, 2
	mov cx, [bx]
	mov dx, [bx + 2]
	mov di, cx ;save cx for compare
	mov si, dx ;save dx for compare
	dec di
	dec si
	add dx, 2
	dec cx
	Lup:
	add cx, 3
	Xlup:
	call one_dot
	dec cx
	cmp cx, di
	jne XLup
	dec dx
	cmp dx, si
	jne Lup
	ret
endp headDraw

;reset_background method is draw the play area of the game.
proc reset_background
	;background
	mov al, 12
	mov dx, 200
	y:
		mov cx, 60
		x:
			call one_dot
			inc cx
			cmp cx, 260
			jle x
			dec dx
			cmp dx, 0
			jge y
	
	mov al, 255
	mov cx, 59
	background1:
		inc cx
		xor dx, dx
		call one_dot
		mov dx, 1
		call one_dot
		mov dx, 2
		call one_dot
		mov dx, 199
		call one_dot
		mov dx, 198
		call one_dot
		mov dx, 197
		call one_dot
		cmp cx, 260
		jl background1
		
	xor dx, dx
	background2:
		inc dx
		mov cx, 60
		call one_dot
		mov cx, 61
		call one_dot
		mov cx, 62
		call one_dot
		mov cx, 260
		call one_dot
		mov cx, 259
		call one_dot
		mov cx, 258
		call one_dot
		cmp dx, 200
		jl background2
	xor dx, dx
	xor cx, cx
	ret
endp reset_background

;The starting of the game
start:
	mov ax, @data
	mov ds, ax
; --------------------------
	;call the main menu and then all the play area
	call mainMenu
	call borders
	call reset_background
	call showScore
	
	;give the stack some values for good work of the eraseLast method
	push 99
	push 99
	push 99
	push 102
	
	;draw the place the player starts
	mov al, 2
	call drawSnake

	;draw the first point
	call drawPoint
	
	;draw point add 4 to snakeLength, but in the
	;beggining there is no need the lengh to increase
	sub [snakeLength], 4
	
;wait for the first key to be pressed
WaitForKey:
	call directionChange
	cmp [direction], 2 ;check if not change direction
	jne KeyPressed
	;check if F1 is pressed
	;if yes, call to tutorial
	cmp al, 3Bh
	jne WaitForKey
	call tutorial
	;after exiting the tutorial, return to the play screen
	call borders
	call reset_background
	mov bx, offset score
	dec [word ptr bx]
	call showScore
	call drawPoint
	sub [snakeLength], 4
	mov al, 2
	call drawSnake
	jmp WaitForKey		

;KeyPressed is an infinite loop, the player enter this
;loop when he press any movement key (A, D, S or W)
KeyPressed:
	;check if P is pressed
	;if yes he entered the main menu
	cmp al, 19h
	jne afterP
	call pauseMenu
	call borders
	call reset_background
	mov bx, offset score
	dec [word ptr bx]
	call showScore
	call drawPoint
	sub [snakeLength], 4
	mov al, 2
	call drawSnake
	afterP:
	
	;check if F1 is pressed
	;if yes entering the tutorial
	cmp al, 3Bh
	jne afterTutorial
	call tutorial
	call borders
	call reset_background
	mov bx, offset score
	dec [word ptr bx]
	call showScore
	call drawPoint
	sub [snakeLength], 4
	mov al, 2
	call drawSnake
	
	afterTutorial:
	;moving the head
	call directionAdd

	add [snakePushed], 2
	;adding this x and y to the snake in the stack
	push [offset headArr + 2] ;push dx
	push [offset headArr] ;push cx
	
	;check if the snake touched itself
	;if yes: ax = 1
	;if no: ax = 0
	add [snakeLength], 4
	call isTouchedItself
	;if yes - reset
	cmp ax, 1
	je reset
	sub [snakeLength], 4
	
	;erase the last part of the snake 
	;for making the animation of moving
	call eraseLast
	
	;drawing the head in the new place
	call headDraw

	;draw the eyes
	call eyesDraw
	
	;check if the snake touch the sides, check left side.
	cmp [word ptr offset headArr], 63
	je reset
	;check if the snake touch the sides, check top side.
	cmp [word ptr offset headArr + 2], 0
	je reset
	;check if the snake touch the sides, check right side.
	cmp [word ptr offset headArr], 255
	je reset
	;check if the snake touch the sides, check bottom side.
	cmp [word ptr offset headArr + 2], 195
	je reset
	
	;check if he touch the point
	mov cx, [offset headArr]
	mov dx, [offset headArr + 2]
	;check if the X value is same
	;if yes he check the Y value
	cmp cx, [offset thisPoint]
	jne waitForAnother
	;check if the Y value is same
	cmp dx, [offset thisPoint + 2]
	jne waitForAnother
	;if the Y value the same it call the the drawPoint, but before it check if
	;the [pointer] var, that show the point it is now at, is not out of range
	;of the array, if yes, it is mov in it 0, after it call the the drawPoint
	;and then it is update the score.
	CallPoint:
	cmp [pointer], 24
	jne subPoint
	mov [pointer], 0
	subPoint:
	add [pointer], 4
	call drawPoint
	call showScore
	;AwaitForAnother is a loop of 3000, that between every loop in
	;AKeyPressed. it make the game slower, so it wouldn't fast too much
	waitForAnother:
	cmp [waiting], 0
	je addWaiting
	;checking if new key was pressed
	call directionChange
	dec [waiting]
	jmp waitForAnother
	
;return [waiting] the value 6000 for the next time
;and then return to AKeyPressed infinite loop
addWaiting:
	mov [changed], 0
	add [waiting], 2000h
	jmp KeyPressed
	
	
reset:
	;animation of snake death
	mov al, 12
	call drawSnake
	mov al, 2
	call drawSnake
	mov al, 12
	call drawSnake
	mov al, 2
	call drawSnake
	mov al, 12
	call drawSnake
	
	;enter game over screen
	call GameOver
	
	;reset score
	mov bx, offset score
	mov [word ptr bx], -1
	mov si, 2
	removeArr:
		mov [word ptr bx + si], 0
		add si, 2
		cmp si, 6
		jne removeArr
	
	xor si, si
	
	;reset scoreCord
	mov [word ptr offset scoreCord], 283
	mov [word ptr offset scoreCord + 2], 273
	mov [word ptr offset scoreCord + 4], 263
	mov [word ptr offset scoreCord + 6], 60
	
	;erase all snake from stack
	xor ax, ax
	add [byte ptr snakePushed], 1
	eraseStack:
	dec [byte ptr snakePushed]
	pop cx
	cmp [byte ptr snakePushed], 0
	jg eraseStack
	
	;reset the play area
	call borders
	call reset_background
	
	;reset to first point
	mov [pointer], 0
	mov [word ptr offset thisPoint], 159
	mov [word ptr offset thisPoint + 2], 30
	xor cx, cx
	
	;reset Point
	call drawPoint
	
	;reset length
	mov [snakeLength], 8
	mov [waiting], 2000h
	
	;reset head
	mov [word ptr offset headArr], 102
	mov [word ptr offset headArr + 2], 99
	push 99
	push 99
	push 99
	push 102
	
	;reset eyes
	mov [word ptr offset eyesBefore], 100
	mov [word ptr offset eyesBefore + 2], 99
	mov [word ptr offset eyesBefore + 4], 100
	mov [word ptr offset eyesBefore + 6], 101
	;draw the place the player starts
	mov al, 2
	call drawSnake
	
	;show the score
	call showScore
	
	;reset the movement
	mov [direction], 2
	mov [side], 5
	
	jmp WaitForKey
	
; --------------------------
	
exit:
	mov ax, 4c00h
	int 21h
END start

