[org 0x0100]
	jmp start

; Data
msgst1:		db '-----WELCOME TO-----', 0
msgscore:	db 'SCORE ', 0
msgtime:	db 'TIME ', 0
msgnextsh:	db 'NEXT SHAPE ',0
rows1:		dw 0
cols1:		dw 3
rows2:		dw 1
cols2:		dw 5
rows3:		dw 2
cols3:		dw 6
msgend:		db '------------------THE END------------------', 0
msgscoreend:	db 'TOTAL SCORE IS: ', 0
score:		dw 0
highscore:	dw 0
msgstart:	db '---------Press Any Key to Start the Game---------', 0
var1:		dw 0
msghighend:	db 'HIGH SCORE IS: ', 0
msgerr:		db "You Gave the Invalid Input than the Given One (Error)", 0
colstart:	dw 25
rowstart:	dw 3
randNum: 	db 0
movement:	dw 1000
randNum1:	db 0
oldisr: 	dd 0 		; space for saving old isr
columns:	dw 25
rows:		dw 3
nextgo:		dw 0
nextgoright:	dw 0
nextgoleft:	dw 0
second1: 	dw 0
second2: 	dw 0
minutes:	dw 0
ldisr: 		dw 0
tickcount: 	dw 0
oldkb: 		dd 0
forr3:		dw 0
level:		dw 0
levelmsg:	db 'Press 1 for Easy & 2 for Medium Level & 3 for High Level', 0

;------------------------------------------------------------------------------------------------------------------------------------------------
clrscr:						; Screen Clearing
	push ax
        push di
	push cx
        push es
        mov ax, 0xb800    			;b800 starting adress
        mov es, ax
        xor di, di    	 			;xor answer will be zero,so di initialized to zero
	mov ax, 0x0720 				; 0=backgroud black,7=forground white of spaces so not visible
	mov cx, 2000    

	cld					; Will set DF=0. So, it'll move from lower to higher address
	rep stosw				; Will push spaces until whole screen become clear

        pop es
	pop cx
        pop di
        pop ax
ret

;------------------------------------------------------------------------------------------------------------------------------------------------
input_for_level:
	mov ax, 12				;Columns
	push ax
	mov ax, 12				;Rows
	push ax
	mov ax, 0x2e
	push ax
	mov ax, levelmsg
	push ax
	call printstr
	mov ah, 0
	int 0x16
	mov byte [level], al
ret

;------------------------------------------------------------------------------------------------------------------------------------------------
welcome_screen:						
	push ax
        push di
        push es
        mov ax, 0xb800
        mov es, ax
        mov di, 0
    nextloca:					; Until whole screen place has covered with spaces
		mov word[es:di], 0x9900
                add di, 2
                cmp di, 4000
                jne nextloca
        pop es
        pop di
        pop ax
ret

;------------------------------------------------------------------------------------------------------------------------------------------------
welcome_screen_printing:						; Screen Clearing
	mov ax, 30				;Columns
	push ax
	mov ax, 3				;Rows
	push ax
	mov ax, 0x74
	push ax
	mov ax, msgst1
	push ax
	call printstr
ret

;------------------------------------------------------------------------------------------------------------------------------------------------
print_S_down1:
	push bp				; Pushing so that previous value can be safe
	mov bp, sp
	push es				
	push di				
	push cx

	mov ax, 0xb800
	mov es, ax
	mov bx, [bp+4]

print_S_row1:					
	add bx, 1		
	mov ax, 80
	mul bx
	add ax, [bp+6]
	shl ax, 1
	mov di, ax
	mov cx, 4			
	mov ax, 0x6d7c		

print_S_downer1:
	mov [es:di], ax
	add di, 2
	sub cx, 2
	cmp cx, 0
	jnz print_S_downer1
	cmp bx, 8
	jnz print_S_row1

	pop cx
	pop di
	pop es
	pop bp
ret 4

;------------------------------------------------------------------------------------------------------------------------------------------------
print_S_down2:
	push bp				; Pushing so that previous value can be safe
	mov bp, sp
	push es				
	push di				
	push cx

	mov ax, 0xb800
	mov es, ax
	mov bx, [bp+4]

print_S_row2:					
	add bx, 1		
	mov ax, 80
	mul bx
	add ax, [bp+6]
	shl ax, 1
	mov di, ax
	mov cx, 4			
	mov ax, 0x6d7c		

print_S_downer2:
	mov [es:di], ax
	add di, 2
	sub cx, 2
	cmp cx, 0
	jnz print_S_downer2
	cmp bx, 10
	jnz print_S_row2

	pop cx
	pop di
	pop es
	pop bp
ret 4

;------------------------------------------------------------------------------------------------------------------------------------------------
print_horizontal:
	push bp				; Pushing so that previous value can be safe
	mov bp, sp
	push es				
	push di				
	push cx

	mov ax, 0xb800
	mov es, ax
	mov bx, [bp+6]
	mov ax, 80
	mul bx
	add ax, [bp+8]
	shl ax, 1
	mov di, ax
	mov cx, 16			
	mov ax, [bp+4]			; Attribute

print_upper:
	mov [es:di], ax
	add di, 2
	sub cx, 2
	cmp cx, 0
	jnz print_upper

	pop cx
	pop di
	pop es
	pop bp
ret 6

;------------------------------------------------------------------------------------------------------------------------------------------------
print_vertical:
	push bp				; Pushing so that previous value can be safe
	mov bp, sp
	push es				
	push di				
	push cx

	mov ax, 0xb800
	mov es, ax
	mov bx, [bp+6]

print_row:					
	add bx, 1		
	mov ax, 80
	mul bx
	add ax, [bp+8]
	shl ax, 1
	mov di, ax
	mov cx, 4			
	mov ax, [bp+4]		

print_downer:
	mov [es:di], ax
	add di, 2
	sub cx, 2
	cmp cx, 0
	jnz print_downer
	cmp bx, 10
	jnz print_row

	pop cx
	pop di
	pop es
	pop bp
ret 6
;------------------------------------------------------------------------------------------------------------------------------------------------
tetris_printing:
	;-----------------First 'T'-----------------							
	mov ax, 11		; Cols
	push ax
	mov ax, 5		; Rows
	push ax
	mov ax, 0x0e7c
	push ax
	call print_horizontal
	mov ax, 14		; Cols
	push ax
	mov ax, 5		; Rows
	push ax
	mov ax, 0x0e7c
	push ax
	call print_vertical
	call sound_caller
	call delaycaller
	;-----------------'E'-----------------							
	mov ax, 21		; Cols
	push ax
	mov ax, 5		; Rows
	push ax
	mov ax, 0x297c
	push ax
	call print_horizontal
	mov ax, 21		; Cols
	push ax
	mov ax, 5		; Rows
	push ax
	mov ax, 0x297c
	push ax
	call print_vertical
	mov ax, 21		; Cols
	push ax
	mov ax, 8		; Rows
	push ax
	mov ax, 0x297c
	push ax
	call print_horizontal
	mov ax, 21		; Cols
	push ax
	mov ax, 10		; Rows
	push ax
	mov ax, 0x297c
	push ax
	call print_horizontal
	call sound_caller
	call delaycaller
	;-----------------Second 'T'-----------------						
	mov ax, 31		; Cols
	push ax
	mov ax, 5		; Rows
	push ax
	mov ax, 0x3a7c
	push ax
	call print_horizontal
	mov ax, 34		; Cols
	push ax
	mov ax, 5		; Rows
	push ax
	mov ax, 0x3a7c
	push ax
	call print_vertical
	call sound_caller
	call delaycaller
	;-----------------'r'-----------------							
	mov ax, 41		; Cols
	push ax
	mov ax, 6		; Rows
	push ax
	mov ax, 0x4b7c
	push ax
	call print_horizontal
	mov ax, 41		; Cols
	push ax
	mov ax, 4		; Rows
	push ax
	mov ax, 0x4b7c
	push ax
	call print_vertical
	call sound_caller
	call delaycaller
	;-----------------'I'-----------------
	mov ax, 54		; Cols
	push ax
	mov ax, 4		; Rows
	push ax
	mov ax, 0x5c7c
	push ax
	call print_vertical
	call sound_caller
	call delaycaller
	;-----------------'S'-----------------							
	mov ax, 61		; Cols
	push ax
	mov ax, 5		; Rows
	push ax
	mov ax, 0x6d7c
	push ax
	call print_horizontal
	mov ax, 61		; Cols
	push ax
	mov ax, 5		; Rows
	push ax
	call print_S_down1
	mov ax, 61		; Cols
	push ax
	mov ax, 8		; Rows
	push ax
	mov ax, 0x6d7c
	push ax
	call print_horizontal
	mov ax, 61		; Cols
	push ax
	mov ax, 10		; Rows
	push ax
	mov ax, 0x6d7c
	push ax
	call print_horizontal
	mov ax, 67		; Cols
	push ax
	mov ax, 8		; Rows
	push ax
	call print_S_down2
	call sound_caller
	call delaycaller
	;-------------------------------------
ret

;------------------------------------------------------------------------------------------------------------------------------------------------
clrvar:						; Clearing all the variables. In order to get rid of garbage values
	xor ax, ax				
	xor bx, bx				
	xor cx, cx				
	xor dx, dx				
	xor si, si				
	xor di, di				
ret

;------------------------------------------------------------------------------------------------------------------------------------------------
delay:						; To create delay in program running
		push ax
		push cx
		mov cx, 0xffff

l1:		
		mov ax, 10
l2:
		dec ax
		jnz l2
		dec cx
		jnz l1
		pop cx
		pop ax
ret

;------------------------------------------------------------------------------------------------------------------------------------------------
delay1:						; To create delay in program running
		push ax
		push cx
		mov cx, 0xcfff

l1_1:		
		mov ax, 5
l2_1:
		dec ax
		jnz l2_1
		dec cx
		jnz l1_1
		pop cx
		pop ax
ret

;------------------------------------------------------------------------------------------------------------------------------------------------
delay2:						; To create delay in program running
		push ax
		push cx
		mov cx, 0x11ff

l1_2:		
		mov ax, 5
l2_2:
		dec ax
		jnz l2_2
		dec cx
		jnz l1_2
		pop cx
		pop ax
ret

;------------------------------------------------------------------------------------------------------------------------------------------------
grey_board:					; It'll print grey color board on black color board
		mov ax, [cols3]			; For columns / x-position
		push ax
		mov ax, [rows3]			; For rows / y-position
		push ax
		call grey_printing

grey_printing:					; For grey color printing
		push bp				; Pushing so that previous value can be safe
		mov bp, sp
		push es				
		push di				
		push cx				

		mov ax, 0xb800
		mov es, ax
		mov bx, [bp+4]
print_grey_row:					; This is the loop for printing grey color in each row
		add bx, 1
		mov ax, 80
		mul bx
		add ax, [bp+6]
		shl ax, 1
		mov di, ax
		mov cx, 84			; After taking 6 columns from start and 10 columns from end
		mov ax, 0x7000			; Grey on Black Board

print_grey:
		mov [es:di], ax
		add di, 2
		sub cx, 2
		cmp cx, 0
		jnz print_grey
		cmp bx, 21
		jnz print_grey_row

		pop cx
		pop di
		pop es
		pop bp
		pop ax
		pop ax
		pop ax
ret

;------------------------------------------------------------------------------------------------------------------------------------------------
score_board:					; It'll print grey color board on black color board
		mov ax, 55			; For columns / x-position
		push ax
		mov ax, 2			; For rows / y-position
		push ax
		call score_printing

score_printing:					; For grey color printing
		push bp				; Pushing so that previous value can be safe
		mov bp, sp
		push es				
		push di				
		push cx				

		mov ax, 0xb800
		mov es, ax
		mov bx, [bp+4]
print_score_row:				; This is the loop for printing grey color in each row
		add bx, 1
		mov ax, 80
		mul bx
		add ax, [bp+6]
		shl ax, 1
		mov di, ax
		mov cx, 30			; After taking 6 columns from start and 10 columns from end
		mov ax, 0x7000			; Grey on Black Board

print_score:
		mov [es:di], ax
		add di, 2
		sub cx, 2
		cmp cx, 0
		jnz print_score
		cmp bx, 4
		jnz print_score_row

		pop cx
		pop di
		pop es
		pop bp
		pop ax
		pop ax
		pop ax
ret

;------------------------------------------------------------------------------------------------------------------------------------------------
time_board:					; It'll print grey color board on black color board
		mov ax, 55			; For columns / x-position
		push ax
		mov ax, 7			; For rows / y-position
		push ax
		call time_printing

time_printing:					; For grey color printing
		push bp				; Pushing so that previous value can be safe
		mov bp, sp
		push es				
		push di				
		push cx				

		mov ax, 0xb800
		mov es, ax
		mov bx, [bp+4]
print_time_row:					; This is the loop for printing grey color in each row
		add bx, 1
		mov ax, 80
		mul bx
		add ax, [bp+6]
		shl ax, 1
		mov di, ax
		mov cx, 30			; After taking 6 columns from start and 10 columns from end
		mov ax, 0x7000			; Grey on Black Board

print_time1:
		mov [es:di], ax
		add di, 2
		sub cx, 2
		cmp cx, 0
		jnz print_time1
		cmp bx, 11
		jnz print_time_row

		pop cx
		pop di
		pop es
		pop bp
		pop ax
		pop ax
		pop ax
ret

;------------------------------------------------------------------------------------------------------------------------------------------------
next_shape_board:					; It'll print grey color board on black color board
		mov ax, 53			; For columns / x-position
		push ax
		mov ax, 15			; For rows / y-position
		push ax
		call next_shape_printing

next_shape_printing:					; For grey color printing
		push bp				; Pushing so that previous value can be safe
		mov bp, sp
		push es				
		push di				
		push cx				

		mov ax, 0xb800
		mov es, ax
		mov bx, [bp+4]
print_next_shape_row:					; This is the loop for printing grey color in each row
		add bx, 1
		mov ax, 80
		mul bx
		add ax, [bp+6]
		shl ax, 1
		mov di, ax
		mov cx, 40			; After taking 6 columns from start and 10 columns from end
		mov ax, 0x7000			; Grey on Black Board

print_next_shape:
		mov [es:di], ax
		add di, 2
		sub cx, 2
		cmp cx, 0
		jnz print_next_shape
		cmp bx, 22
		jnz print_next_shape_row

		pop cx
		pop di
		pop es
		pop bp
		pop ax
		pop ax
		pop ax
ret

;------------------------------------------------------------------------------------------------------------------------------------------------
cyan_screen:					; It will make all screen white
	push ax
        push di
	push cx
        push es
        mov ax, 0xb800
        mov es, ax
        xor di, di
	mov ax, 0x3000
	mov cx, 2000

	cld					; Will set DF=0. So, it'll move from lower to higher address
	rep stosw				; Will push white color until whole screen become clear

        pop es
	pop cx
        pop di
        pop ax
ret

;------------------------------------------------------------------------------------------------------------------------------------------------
strlen:		
		push bp
		mov bp, sp
		push es
		push cx
		push di
		les di, [bp+4]
		mov cx, 0xffff
		xor al, al
		repne scasb
		mov ax, 0xffff
		sub ax, cx
		dec ax
		pop di
		pop cx
		pop es
		pop bp
ret 2

;------------------------------------------------------------------------------------------------------------------------------------------------
printstr:	
		push bp
		mov bp, sp
		push es
		push ax
		push cx
		push si
		push di
	
		push ds
		pop es
		mov di, [bp+4]
		mov cx, 0xffff
		xor al, al
		repne scasb
		mov ax, 0xffff
		sub ax, cx
		dec ax
		jz exit
	
		mov cx, ax
		mov ax, 0xb800
		mov es, ax
		mov al, 80
		mul byte [bp+8]
		add ax, [bp+10]
		shl ax, 1
		mov di, ax
		mov si, [bp+4]
		mov ah, [bp+6]
		cld

nextchar:	lodsb
		stosw
		loop nextchar

exit:		pop di
		pop si
		pop cx
		pop ax
		pop es
		pop bp
ret 8

;------------------------------------------------------------------------------------------------------------------------------------------------
printstrend:	
		push bp
		mov bp, sp
		push es
		push ax
		push cx
		push si
		push di
	
		push ds
		pop es
		mov di, [bp+4]
		mov cx, 0xffff
		xor al, al
		repne scasb
		mov ax, 0xffff
		sub ax, cx
		dec ax
		jz exit2
	
		mov cx, ax
		mov ax, 0xb800
		mov es, ax
		mov al, 80
		mul byte [bp+8]
		add ax, [bp+10]
		shl ax, 1
		mov di, ax
		mov si, [bp+4]
		mov ah, [bp+6]
		cld

nextchar2:	lodsb
		stosw
		loop nextchar2

		mov word ax, [score] 	
		mov bx, 10
		mov cx, 0

nextdigit2:	
		mov dx, 0
		div bx				; Because it is define word then the remainder will store in dx
		add dl, 0x30
		push dx
		inc cx
		cmp ax, 0
		jnz nextdigit2

nextpos2:	
		pop dx
		mov dh, 0x71
		mov [es:di], dx
		add di, 2
		loop nextpos2

exit2:
		pop di
		pop si
		pop cx
		pop ax
		pop es
		pop bp
ret 8

;------------------------------------------------------------------------------------------------------------------------------------------------
printing_t_s_n:						; Screen Clearing
	;-------------------
	mov ax, 55
	push ax
	mov ax, 2
	push ax
	mov ax, 0x71
	push ax
	mov ax, msgscore
	push ax
	call printstr
	;-------------------------		
	mov ax, 55
	push ax
	mov ax, 7
	push ax
	mov ax, 0x76
	push ax
	mov ax, msgtime
	push ax
	call printstr
	;-------------------------		
	mov ax, 53
	push ax
	mov ax, 15
	push ax
	mov ax, 0x74
	push ax
	mov ax, msgnextsh
	push ax
	call printstr
ret

;------------------------------------------------------------------------------------------------------------------------------------------------
randGen:
        push bp
        mov bp, sp
        push cx
        push dx
        push ax

        rdtsc                   ;getting a random number in ax dx
        xor dx, dx               ;making dx 0
        mov cx, 4
        div cx                  ;dividing by 'Paramter' to get numbers from 0 - Parameter
	add dl, 1
        mov [randNum], dl      ;moving the random number in variable

        pop ax
        pop dx
        pop cx
        pop bp
ret

;------------------------------------------------------------------------------------------------------------------------------------------------
print_randGen_Shape_Side:
	mov ax, 0
	
	mov al, [randNum]
	cmp byte al, 4
	je its4

	mov al, [randNum]
	cmp byte al, 3
	je its3

	mov al, [randNum]
	cmp byte al, 2
	je its2
	jmp its1

its4:
	mov ax, 58		; Cols
	push ax
	mov ax, 17		; Rows
	push ax
	call print_T_shape
ret
	
its3:
	mov ax, 58		; Cols
	push ax
	mov ax, 17		; Rows
	push ax
	call print_J_shape
ret

its2:
	mov ax, 58		; Cols
	push ax
	mov ax, 17		; Rows
	push ax
	call print_O_shape
ret

its1:
	mov ax, 58		; Cols
	push ax
	mov ax, 17		; Rows
	push ax
	call print_L_shape
ret

;------------------------------------------------------------------------------------------------------------------------------------------------
delay2caller:						; To create delay in program running
		mov cx, 10

calldelay2:
		call delay2
		loop calldelay2
ret		

;------------------------------------------------------------------------------------------------------------------------------------------------
animation:		
		call delay2caller

		mov ax, 0xb800
		mov es, ax
		mov bx, 0
		sub bx, 1
anim1_row:					; This is the loop for printing grey color in each row
		add bx, 1
		mov ax, 80
		mul bx
		add ax, 0
		shl ax, 1
		mov di, ax
		mov cx, 40			; After taking 6 columns from start and 10 columns from end
		mov ax, 0x2000			; Grey on Black Board

anim1_1_row:
		mov [es:di], ax
		add di, 2
		sub cx, 1
		cmp cx, 0
		jnz anim1_1_row
		cmp bx, 13
		jnz anim1_row

		call delay2caller

		mov ax, 0xb800
		mov es, ax
		mov bx, 13
anim2_row:					; This is the loop for printing grey color in each row
		add bx, 1
		mov ax, 80
		mul bx
		add ax, 0
		shl ax, 1
		mov di, ax
		mov cx, 40			; After taking 6 columns from start and 10 columns from end
		mov ax, 0x3000			; Grey on Black Board

anim2_1_row:
		mov [es:di], ax
		add di, 2
		sub cx, 1
		cmp cx, 0
		jnz anim2_1_row
		cmp bx, 25
		jnz anim2_row

		call delay2caller

		mov ax, 0xb800
		mov es, ax
		mov bx, 0
		sub bx, 1
anim3_row:					; This is the loop for printing grey color in each row
		add bx, 1
		mov ax, 80
		mul bx
		add ax, 40
		shl ax, 1
		mov di, ax
		mov cx, 40			; After taking 6 columns from start and 10 columns from end
		mov ax, 0x5000			; Grey on Black Board

anim3_1_row:
		mov [es:di], ax
		add di, 2
		sub cx, 1
		cmp cx, 0
		jnz anim3_1_row
		cmp bx, 13
		jnz anim3_row

		call delay2caller

		mov ax, 0xb800
		mov es, ax
		mov bx, 13
anim4_row:					; This is the loop for printing grey color in each row
		add bx, 1
		mov ax, 80
		mul bx
		add ax, 40
		shl ax, 1
		mov di, ax
		mov cx, 40			; After taking 6 columns from start and 10 columns from end
		mov ax, 0x6000			; Grey on Black Board

anim4_1_row:
		mov [es:di], ax
		add di, 2
		sub cx, 1
		cmp cx, 0
		jnz anim4_1_row
		cmp bx, 25
		jnz anim4_row

ret

;------------------------------------------------------------------------------------------------------------------------------------------------
animation_1:		
		call delay2caller

		mov ax, 0xb800
		mov es, ax
		mov bx, 0
		sub bx, 1
anim1_row_1:					; This is the loop for printing grey color in each row
		add bx, 1
		mov ax, 80
		mul bx
		add ax, 0
		shl ax, 1
		mov di, ax
		mov cx, 40			; After taking 6 columns from start and 10 columns from end
		mov ax, 0x5000			; Grey on Black Board

anim1_1_row_1:
		mov [es:di], ax
		add di, 2
		sub cx, 1
		cmp cx, 0
		jnz anim1_1_row_1
		cmp bx, 13
		jnz anim1_row_1

		call delay2caller

		mov ax, 0xb800
		mov es, ax
		mov bx, 13
anim2_row_1:					; This is the loop for printing grey color in each row
		add bx, 1
		mov ax, 80
		mul bx
		add ax, 0
		shl ax, 1
		mov di, ax
		mov cx, 40			; After taking 6 columns from start and 10 columns from end
		mov ax, 0x2000			; Grey on Black Board

anim2_1_row_1:
		mov [es:di], ax
		add di, 2
		sub cx, 1
		cmp cx, 0
		jnz anim2_1_row_1
		cmp bx, 25
		jnz anim2_row_1

		call delay2caller

		mov ax, 0xb800
		mov es, ax
		mov bx, 0
		sub bx, 1
anim3_row_1:					; This is the loop for printing grey color in each row
		add bx, 1
		mov ax, 80
		mul bx
		add ax, 40
		shl ax, 1
		mov di, ax
		mov cx, 40			; After taking 6 columns from start and 10 columns from end
		mov ax, 0x6000			; Grey on Black Board

anim3_1_row_1:
		mov [es:di], ax
		add di, 2
		sub cx, 1
		cmp cx, 0
		jnz anim3_1_row_1
		cmp bx, 13
		jnz anim3_row_1

		call delay2caller

		mov ax, 0xb800
		mov es, ax
		mov bx, 13
anim4_row_1:					; This is the loop for printing grey color in each row
		add bx, 1
		mov ax, 80
		mul bx
		add ax, 40
		shl ax, 1
		mov di, ax
		mov cx, 40			; After taking 6 columns from start and 10 columns from end
		mov ax, 0x3000			; Grey on Black Board

anim4_1_row_1:
		mov [es:di], ax
		add di, 2
		sub cx, 1
		cmp cx, 0
		jnz anim4_1_row_1
		cmp bx, 25
		jnz anim4_row_1

ret

;------------------------------------------------------------------------------------------------------------------------------------------------
animation_2:		
		call delay2caller

		mov ax, 0xb800
		mov es, ax
		mov bx, 0
		sub bx, 1
anim1_row_2:					; This is the loop for printing grey color in each row
		add bx, 1
		mov ax, 80
		mul bx
		add ax, 0
		shl ax, 1
		mov di, ax
		mov cx, 40			; After taking 6 columns from start and 10 columns from end
		mov ax, 0x6000			; Grey on Black Board

anim1_1_row_2:
		mov [es:di], ax
		add di, 2
		sub cx, 1
		cmp cx, 0
		jnz anim1_1_row_2
		cmp bx, 13
		jnz anim1_row_2

		call delay2caller

		mov ax, 0xb800
		mov es, ax
		mov bx, 13
anim2_row_2:					; This is the loop for printing grey color in each row
		add bx, 1
		mov ax, 80
		mul bx
		add ax, 0
		shl ax, 1
		mov di, ax
		mov cx, 40			; After taking 6 columns from start and 10 columns from end
		mov ax, 0x5000			; Grey on Black Board

anim2_1_row_2:
		mov [es:di], ax
		add di, 2
		sub cx, 1
		cmp cx, 0
		jnz anim2_1_row_2
		cmp bx, 25
		jnz anim2_row_2

		call delay2caller

		mov ax, 0xb800
		mov es, ax
		mov bx, 0
		sub bx, 1
anim3_row_2:					; This is the loop for printing grey color in each row
		add bx, 1
		mov ax, 80
		mul bx
		add ax, 40
		shl ax, 1
		mov di, ax
		mov cx, 40			; After taking 6 columns from start and 10 columns from end
		mov ax, 0x3000			; Grey on Black Board

anim3_1_row_2:
		mov [es:di], ax
		add di, 2
		sub cx, 1
		cmp cx, 0
		jnz anim3_1_row_2
		cmp bx, 13
		jnz anim3_row_2

		call delay2caller

		mov ax, 0xb800
		mov es, ax
		mov bx, 13
anim4_row_2:					; This is the loop for printing grey color in each row
		add bx, 1
		mov ax, 80
		mul bx
		add ax, 40
		shl ax, 1
		mov di, ax
		mov cx, 40			; After taking 6 columns from start and 10 columns from end
		mov ax, 0x2000			; Grey on Black Board

anim4_1_row_2:
		mov [es:di], ax
		add di, 2
		sub cx, 1
		cmp cx, 0
		jnz anim4_1_row_2
		cmp bx, 25
		jnz anim4_row_2

		call delay2caller
		call delay2caller
		call delay2caller

ret

;------------------------------------------------------------------------------------------------------------------------------------------------
animation_caller:

	call animation
	call animation_1
	call animation_2

	call animation
	call animation_1
	call animation_2

	call animation
	call animation_1
	call animation_2
ret

;------------------------------------------------------------------------------------------------------------------------------------------------
ending_screen:					; It will call after the game ends for showing score
		call clrscr
		call animation_caller
		call cyan_screen
		;------------------------
		mov ax, 25			; Columns / x-position
		push ax
		mov ax, 10			; Rows / y-position
		push ax
		mov ax, 0x71			; Blue on White
		push ax
		mov ax, msgscoreend
		push ax
		call printstrend
		;------------------------
		mov ax, 12			; Columns / x-position
		push ax
		mov ax, 16			; Rows / y-position
		push ax
		mov ax, 0x70			; Blue on White
		push ax
		mov ax, msgend
		push ax
		call printstr
		call sound_caller
ret	

;------------------------------------------------------------------------------------------------------------------------------------------------
printnum:	
		push bp
		mov bp, sp
		push es
		push ax
		push bx
		push cx
		push dx
		push di

		mov ax, 0xb800
		mov es, ax
		mov al, 80
		mul byte [bp+8]
		add ax, [bp+10]
		shl ax, 1
		mov di, ax
		mov ax, [bp+4]
		mov bx, 10
		mov cx, 0

nextdigit_dig:	mov dx, 0
		div bx
		add dl, 0x30
		push dx
		inc cx
		cmp ax, 0
		jnz nextdigit_dig
	
nextpos_pos:	pop dx
		mov dh, [bp+6]
		mov [es:di], dx
		add di, 2
		loop nextpos_pos
		
		pop di
		pop dx
		pop cx
		pop bx
		pop ax
		pop es
		pop bp
ret 8

;------------------------------------------------------------------------------------------------------------------------------------------------
printing_score:			
		mov ax, 60			; Columns / x-position
		push ax
		mov ax, 4			; Rows / y-position
		push ax
		mov ax, 0x75			; Blue on White
		push ax
		mov ax, [score]
		push ax
		call printnum
ret

;------------------------------------------------------------------------------------------------------------------------------------------------
delaycaller:
	mov ax, 2
del:	
	call delay1
	dec ax
	cmp ax, 0
	jnz del
ret

;------------------------------------------------------------------------------------------------------------------------------------------------
;------------------Shapes------------------
	;------------------------------------------
print_O_shape:
	push bp				; Pushing so that previous value can be safe
	mov bp, sp
	push es				
	push di				
	push cx

	mov ax, 0xb800
	mov es, ax
	mov bx, [bp+4]
	add word [bp+4], 2
	sub bx, 1

print_O_st:					
	add bx, 1		
	mov ax, 80
	mul bx
	add ax, [bp+6]
	shl ax, 1
	mov di, ax
	mov cx, 12			
	mov ax, 0x0e7c		

print_O_stand:
	mov [es:di], ax
	add di, 2
	sub cx, 2
	cmp cx, 0
	jnz print_O_stand
	cmp word bx, [bp+4]
	jnz print_O_st

	pop cx
	pop di
	pop es
	pop bp
ret 4

	;------------------------------------------

print_L_shape:
	push bp				; Pushing so that previous value can be safe
	mov bp, sp
	push es				
	push di				
	push cx

	mov ax, 0xb800
	mov es, ax
	mov bx, [bp+4]
	sub bx, 1
	add word [bp+4], 2

print_L_row:					
	add bx, 1		
	mov ax, 80
	mul bx
	add ax, [bp+6]
	shl ax, 1
	mov di, ax
	mov cx, 4			
	mov ax, 0x2e7c		

print_L_downer:
	mov [es:di], ax
	add di, 2
	sub cx, 2
	cmp cx, 0
	jnz print_L_downer
	cmp word bx, [bp+4]
	jnz print_L_row

	mov ax, 0xb800
	mov es, ax
	mov bx, [bp+4]
	mov ax, 80
	mul bx
	add ax, [bp+6]
	shl ax, 1
	mov di, ax
	mov cx, 20			
	mov ax, 0x2e7c			; Attribute

print_L_upper:
	mov [es:di], ax
	add di, 2
	sub cx, 2
	cmp cx, 0
	jnz print_L_upper

	pop cx
	pop di
	pop es
	pop bp
ret 4

	;------------------------------------------
print_J_shape:
	push bp				; Pushing so that previous value can be safe
	mov bp, sp
	push es				
	push di				
	push cx

	mov ax, 0xb800
	mov es, ax
	mov bx, [bp+4]
	mov ax, 80
	mul bx
	add ax, [bp+6]
	shl ax, 1
	mov di, ax
	mov cx, 20			
	mov ax, 0x4e7c			; Attribute

print_J_upper:
	mov [es:di], ax
	add di, 2
	sub cx, 2
	cmp cx, 0
	jnz print_J_upper

	mov ax, 0xb800
	mov es, ax
	mov bx, [bp+4]
	sub bx, 1
	add word [bp+4], 2
	add word [bp+6], 8

print_J_row:					
	add bx, 1		
	mov ax, 80
	mul bx
	add ax, [bp+6]
	shl ax, 1
	mov di, ax
	mov cx, 4			
	mov ax, 0x4e7c		

print_J_downer:
	mov [es:di], ax
	add di, 2
	sub cx, 2
	cmp cx, 0
	jnz print_J_downer
	cmp word bx, [bp+4]
	jnz print_J_row

	pop cx
	pop di
	pop es
	pop bp
ret 4

	;------------------------------------------
print_T_shape:
	push bp				; Pushing so that previous value can be safe
	mov bp, sp
	push es				
	push di				
	push cx

	mov ax, 0xb800
	mov es, ax
	mov bx, [bp+4]
	mov ax, 80
	mul bx
	add ax, [bp+6]
	shl ax, 1
	mov di, ax
	mov cx, 20			
	mov ax, 0x5e7c			; Attribute

print_T_upper:
	mov [es:di], ax
	add di, 2
	sub cx, 2
	cmp cx, 0
	jnz print_T_upper

	mov ax, 0xb800
	mov es, ax
	mov bx, [bp+4]
	sub bx, 1
	add word [bp+4], 2
	add word [bp+6], 4

print_T_row:					
	add bx, 1		
	mov ax, 80
	mul bx
	add ax, [bp+6]
	shl ax, 1
	mov di, ax
	mov cx, 4			
	mov ax, 0x5e7c		

print_T_downer:
	mov [es:di], ax
	add di, 2
	sub cx, 2
	cmp cx, 0
	jnz print_T_downer
	cmp word bx, [bp+4]
	jnz print_T_row

	pop cx
	pop di
	pop es
	pop bp
ret 4

;------------------------------------------------------------------------------------------------------------------------------------------------
;------------------Shapes Covers------------------
	;------------------------------------------
print_O_shape_cover:
	push bp				; Pushing so that previous value can be safe
	mov bp, sp
	push es				
	push di				
	push cx

	mov ax, 0xb800
	mov es, ax
	mov bx, [bp+4]
	add word [bp+4], 2
	sub bx, 1

print_O_st_cover:					
	add bx, 1		
	mov ax, 80
	mul bx
	add ax, [bp+6]
	shl ax, 1
	mov di, ax
	mov cx, 12			
	mov ax, 0x7000		

print_O_stand_cover:
	mov [es:di], ax
	add di, 2
	sub cx, 2
	cmp cx, 0
	jnz print_O_stand_cover
	cmp word bx, [bp+4]
	jnz print_O_st_cover

	pop cx
	pop di
	pop es
	pop bp
ret 4

	;------------------------------------------

print_L_shape_cover:
	push bp				; Pushing so that previous value can be safe
	mov bp, sp
	push es				
	push di				
	push cx

	mov ax, 0xb800
	mov es, ax
	mov bx, [bp+4]
	sub bx, 1
	add word [bp+4], 2

print_L_row_cover:					
	add bx, 1		
	mov ax, 80
	mul bx
	add ax, [bp+6]
	shl ax, 1
	mov di, ax
	mov cx, 4			
	mov ax, 0x7000		

print_L_downer_cover:
	mov [es:di], ax
	add di, 2
	sub cx, 2
	cmp cx, 0
	jnz print_L_downer_cover
	cmp word bx, [bp+4]
	jnz print_L_row_cover

	mov ax, 0xb800
	mov es, ax
	mov bx, [bp+4]
	mov ax, 80
	mul bx
	add ax, [bp+6]
	shl ax, 1
	mov di, ax
	mov cx, 20			
	mov ax, 0x7000			; Attribute

print_L_upper_cover:
	mov [es:di], ax
	add di, 2
	sub cx, 2
	cmp cx, 0
	jnz print_L_upper_cover

	pop cx
	pop di
	pop es
	pop bp
ret 4

	;------------------------------------------
print_J_shape_cover:
	push bp				; Pushing so that previous value can be safe
	mov bp, sp
	push es				
	push di				
	push cx

	mov ax, 0xb800
	mov es, ax
	mov bx, [bp+4]
	mov ax, 80
	mul bx
	add ax, [bp+6]
	shl ax, 1
	mov di, ax
	mov cx, 20			
	mov ax, 0x7000			; Attribute

print_J_upper_cover:
	mov [es:di], ax
	add di, 2
	sub cx, 2
	cmp cx, 0
	jnz print_J_upper_cover

	mov ax, 0xb800
	mov es, ax
	mov bx, [bp+4]
	sub bx, 1
	add word [bp+4], 2
	add word [bp+6], 8

print_J_row_cover:					
	add bx, 1		
	mov ax, 80
	mul bx
	add ax, [bp+6]
	shl ax, 1
	mov di, ax
	mov cx, 4			
	mov ax, 0x7000		

print_J_downer_cover:
	mov [es:di], ax
	add di, 2
	sub cx, 2
	cmp cx, 0
	jnz print_J_downer_cover
	cmp word bx, [bp+4]
	jnz print_J_row_cover

	pop cx
	pop di
	pop es
	pop bp
ret 4

	;------------------------------------------
print_T_shape_cover:
	push bp				; Pushing so that previous value can be safe
	mov bp, sp
	push es				
	push di				
	push cx

	mov ax, 0xb800
	mov es, ax
	mov bx, [bp+4]
	mov ax, 80
	mul bx
	add ax, [bp+6]
	shl ax, 1
	mov di, ax
	mov cx, 20			
	mov ax, 0x7000			; Attribute

print_T_upper_cover:
	mov [es:di], ax
	add di, 2
	sub cx, 2
	cmp cx, 0
	jnz print_T_upper_cover

	mov ax, 0xb800
	mov es, ax
	mov bx, [bp+4]
	sub bx, 1
	add word [bp+4], 2
	add word [bp+6], 4

print_T_row_cover:					
	add bx, 1		
	mov ax, 80
	mul bx
	add ax, [bp+6]
	shl ax, 1
	mov di, ax
	mov cx, 4			
	mov ax, 0x7000		

print_T_downer_cover:
	mov [es:di], ax
	add di, 2
	sub cx, 2
	cmp cx, 0
	jnz print_T_downer_cover
	cmp word bx, [bp+4]
	jnz print_T_row_cover

	pop cx
	pop di
	pop es
	pop bp
ret 4

;------------------------------------------------------------------------------------------------------------------------------------------------
printnum1: 
	push bp 
 	mov bp, sp 
 	push es 
 	push ax 
 	push bx 
 	push cx 
 	push dx 
 	push di 
 
	mov ax, 0xb800 
 	mov es, ax			; point es to video base 
 	mov ax, [bp+4] 			; load number in ax 
 	mov bx, 10 			; use base 10 for division 
 	mov cx, 0 			; initialize count of digits 

nextdigit: 
	mov dx, 0 			; zero upper half of dividend 
 	div bx 				; divide by 10 
 	add dl, 0x30 			; convert digit into ascii value 
 	push dx 			; save ascii value on stack 
 	inc cx 				; increment count of values 
 	cmp ax, 0 			; is the quotient zero 
 	jnz nextdigit 			; if no divide it again 
 	mov di, [bp+6] 			; point di to 70th column 
nextpos: 
	pop dx 				; remove a digit from the stack 
 	mov dh, 0x7e 			; use normal attribute 
 	mov [es:di], dx	 		; print char on screen 
 	add di, 2 			; move to next screen location 
 	loop nextpos 			; repeat for all digits on stack 
 
	pop di 
 	pop dx 
 	pop cx 
 	pop bx 
 	pop ax
 	pop es 
 	pop bp 
 ret 4

;------------------------------------------------------------------------------------------------------------------------------------------------
timer:
	jmp started

ended:
	jmp endscreen

started:
        cmp word[cs:minutes], 5
        je ended
 	push ax
	inc word [cs:tickcount]		; increment tick count
	cmp word[cs:tickcount], 18
	je update
	cmp word[cs:tickcount], 18
	jne k2

update:
    	mov word[cs:tickcount], 0
	inc word[cs:second2]
    	cmp word[cs:second2], 10
	jl k2
	
	mov word[cs:second2], 0
	inc word[cs:second1]
	cmp word[cs:second1], 6	
	jne k2
	
	inc word [cs:minutes] 
	mov word [cs:second1], 0
	cmp word [cs:minutes], 5
	je ended

k2:
        mov ax, 1720
	push ax
	push word [cs:minutes]
	call printnum1 
	
	mov ax, 0xb800
	mov es, ax
	mov ah, 0x7e
	mov al, ':'
	mov word[es:1722], ax
		
    	mov ax, 1724
	push ax
	push word [cs:second1]
	call printnum1 
	
	mov ax, 1726
	push ax
	push word [cs:second2]
	call printnum1 
	
kl:
	mov al, 0x20
	out 0x20, al 		; end of interrupt
	pop ax
iret 				; return from interrupt

;------------------------------------------------------------------------------------------------------------------------------------------------
print_next_shape_by_rand:

	mov ax, 0
	mov word [rowstart], 3
	mov word [colstart], 25
	mov word [rows], 3
	mov word [columns], 25
	
	mov al, [randNum1]
	cmp byte al, 4
	je its4r

	mov al, [randNum1]
	cmp byte al, 3
	je itsr3

	mov al, [randNum1]
	cmp byte al, 2
	je itsr2
	jmp its1r

itsr2:
	jmp its2r

itsr3:
	jmp its3r

its4r:
	mov ax, [columns]
	mov [colstart], ax
	mov ax, [rows]
	mov [rowstart], ax
	mov ax, [colstart]		; Cols
	push ax
	mov ax, [rowstart]		; Rows
	push ax
	call print_T_shape
	mov byte al, [level]
	cmp al, 0x33
	je highdelay
	mov byte al, [level]
	cmp al, 0x32
	je highdelay_1
	jmp highdelay_2

highdelay:
	call delay2
	add word [rowstart], 1
	mov ax, [colstart]		; Cols
	push ax
	mov ax, [rowstart]		; Rows
	push ax
	call check_next_down
	cmp word [nextgo], 1
	jne move4_r
	sub word [rowstart], 1
	mov ax, [columns]
	mov [colstart], ax
	mov ax, [rows]
	mov [rowstart], ax	
	mov ax, [colstart]		; Cols
	push ax
	mov ax, [rowstart]		; Rows
	push ax
	call print_T_shape_cover
	add word [rowstart], 1
	add word [rows], 1
	jmp its4r
move4_r:
	jmp move4

highdelay_1:
	call delay1
	add word [rowstart], 1
	mov ax, [colstart]		; Cols
	push ax
	mov ax, [rowstart]		; Rows
	push ax
	call check_next_down
	cmp word [nextgo], 1
	jne move4_rr
	sub word [rowstart], 1
	mov ax, [columns]
	mov [colstart], ax
	mov ax, [rows]
	mov [rowstart], ax	
	mov ax, [colstart]		; Cols
	push ax
	mov ax, [rowstart]		; Rows
	push ax
	call print_T_shape_cover
	add word [rowstart], 1
	add word [rows], 1
	jmp its4r
move4_rr:
	jmp move4

highdelay_2:
	call delay
	add word [rowstart], 1
	mov ax, [colstart]		; Cols
	push ax
	mov ax, [rowstart]		; Rows
	push ax
	call check_next_down
	cmp word [nextgo], 1
	jne move4
	sub word [rowstart], 1
	mov ax, [columns]
	mov [colstart], ax
	mov ax, [rows]
	mov [rowstart], ax	
	mov ax, [colstart]		; Cols
	push ax
	mov ax, [rowstart]		; Rows
	push ax
	call print_T_shape_cover
	add word [rowstart], 1
	add word [rows], 1
	jmp its4r
move4:
	ret

its3r:
	mov ax, [columns]
	mov [colstart], ax
	mov ax, [rows]
	mov [rowstart], ax
	mov ax, [colstart]		; Cols
	push ax
	mov ax, [rowstart]		; Rows
	push ax
	call print_J_shape
	mov byte al, [level]
	cmp al, 0x33
	je highdelay_4
	mov byte al, [level]
	cmp al, 0x32
	je highdelay_5
	jmp highdelay_6

highdelay_4:
	call delay2
	add word [rowstart], 1
	mov ax, [colstart]		; Cols
	push ax
	mov ax, [rowstart]		; Rows
	push ax
	call check_next_down
	cmp word [nextgo], 1
	jne move3_r
	sub word [rowstart], 1
	mov ax, [columns]
	mov [colstart], ax
	mov ax, [rows]
	mov [rowstart], ax	
	mov ax, [colstart]		; Cols
	push ax
	mov ax, [rowstart]		; Rows
	push ax
	call print_J_shape_cover
	add word [rowstart], 1
	add word [rows], 1
	jmp its3r
move3_r:
	jmp move3

highdelay_5:
	call delay1
	add word [rowstart], 1
	mov ax, [colstart]		; Cols
	push ax
	mov ax, [rowstart]		; Rows
	push ax
	call check_next_down
	cmp word [nextgo], 1
	jne move3_rr
	sub word [rowstart], 1
	mov ax, [columns]
	mov [colstart], ax
	mov ax, [rows]
	mov [rowstart], ax	
	mov ax, [colstart]		; Cols
	push ax
	mov ax, [rowstart]		; Rows
	push ax
	call print_J_shape_cover
	add word [rowstart], 1
	add word [rows], 1
	jmp its3r

move3_rr:
	jmp move3

highdelay_6:
	call delay
	add word [rowstart], 1
	mov ax, [colstart]		; Cols
	push ax
	mov ax, [rowstart]		; Rows
	push ax
	call check_next_down
	cmp word [nextgo], 1
	jne move3
	sub word [rowstart], 1
	mov ax, [columns]
	mov [colstart], ax
	mov ax, [rows]
	mov [rowstart], ax	
	mov ax, [colstart]		; Cols
	push ax
	mov ax, [rowstart]		; Rows
	push ax
	call print_J_shape_cover
	add word [rowstart], 1
	add word [rows], 1
	jmp its3r
move3:
	ret

its2r:
	mov ax, [columns]
	mov [colstart], ax
	mov ax, [rows]
	mov [rowstart], ax
	mov ax, [colstart]		; Cols
	push ax
	mov ax, [rowstart]		; Rows
	push ax
	call print_O_shape
	mov byte al, [level]
	cmp al, 0x33
	je highdelay_8
	mov byte al, [level]
	cmp al, 0x32
	je highdelay_9
	jmp highdelay_10

highdelay_8:
	call delay2
	add word [rowstart], 1
	mov ax, [colstart]		; Cols
	push ax
	mov ax, [rowstart]		; Rows
	push ax
	call check_next_down
	cmp word [nextgo], 1
	jne move2_r
	sub word [rowstart], 1
	mov ax, [columns]
	mov [colstart], ax
	mov ax, [rows]
	mov [rowstart], ax	
	mov ax, [colstart]		; Cols
	push ax
	mov ax, [rowstart]		; Rows
	push ax
	call print_O_shape_cover
	add word [rowstart], 1
	add word [rows], 1
	jmp its2r

move2_r:
	jmp move2

highdelay_9:
	call delay1
	add word [rowstart], 1
	mov ax, [colstart]		; Cols
	push ax
	mov ax, [rowstart]		; Rows
	push ax
	call check_next_down
	cmp word [nextgo], 1
	jne move2_rr
	sub word [rowstart], 1
	mov ax, [columns]
	mov [colstart], ax
	mov ax, [rows]
	mov [rowstart], ax	
	mov ax, [colstart]		; Cols
	push ax
	mov ax, [rowstart]		; Rows
	push ax
	call print_O_shape_cover
	add word [rowstart], 1
	add word [rows], 1
	jmp its2r

move2_rr:
	jmp move2

highdelay_10:
	call delay
	add word [rowstart], 1
	mov ax, [colstart]		; Cols
	push ax
	mov ax, [rowstart]		; Rows
	push ax
	call check_next_down
	cmp word [nextgo], 1
	jne move2
	sub word [rowstart], 1
	mov ax, [columns]
	mov [colstart], ax
	mov ax, [rows]
	mov [rowstart], ax	
	mov ax, [colstart]		; Cols
	push ax
	mov ax, [rowstart]		; Rows
	push ax
	call print_O_shape_cover
	add word [rowstart], 1
	add word [rows], 1
	jmp its2r
move2:
	ret

its1r:
	mov ax, [columns]
	mov [colstart], ax
	mov ax, [rows]
	mov [rowstart], ax
	mov ax, [colstart]		; Cols
	push ax
	mov ax, [rowstart]		; Rows
	push ax
	call print_L_shape
	mov byte al, [level]
	cmp al, 0x33
	je highdelay_12
	mov byte al, [level]
	cmp al, 0x32
	je highdelay_13
	jmp highdelay_14

highdelay_12:
	call delay2
	add word [rowstart], 1
	mov ax, [colstart]		; Cols
	push ax
	mov ax, [rowstart]		; Rows
	push ax
	call check_next_down
	cmp word [nextgo], 1
	jne move1_r
	sub word [rowstart], 1
	mov ax, [columns]
	mov [colstart], ax
	mov ax, [rows]
	mov [rowstart], ax	
	mov ax, [colstart]		; Cols
	push ax
	mov ax, [rowstart]		; Rows
	push ax
	call print_L_shape_cover
	add word [rowstart], 1
	add word [rows], 1
	jmp its1r
move1_r:
	jmp move1

highdelay_13:
	call delay1
	add word [rowstart], 1
	mov ax, [colstart]		; Cols
	push ax
	mov ax, [rowstart]		; Rows
	push ax
	call check_next_down
	cmp word [nextgo], 1
	jne move1_rr
	sub word [rowstart], 1
	mov ax, [columns]
	mov [colstart], ax
	mov ax, [rows]
	mov [rowstart], ax	
	mov ax, [colstart]		; Cols
	push ax
	mov ax, [rowstart]		; Rows
	push ax
	call print_L_shape_cover
	add word [rowstart], 1
	add word [rows], 1
	jmp its1r
move1_rr:
	jmp move1

highdelay_14:
	call delay
	add word [rowstart], 1
	mov ax, [colstart]		; Cols
	push ax
	mov ax, [rowstart]		; Rows
	push ax
	call check_next_down
	cmp word [nextgo], 1
	jne move1
	sub word [rowstart], 1
	mov ax, [columns]
	mov [colstart], ax
	mov ax, [rows]
	mov [rowstart], ax	
	mov ax, [colstart]		; Cols
	push ax
	mov ax, [rowstart]		; Rows
	push ax
	call print_L_shape_cover
	add word [rowstart], 1
	add word [rows], 1
	jmp its1r
move1:
	ret

;------------------------------------------------------------------------------------------------------------------------------------------------
check_next_down:
	mov ax, 0
	mov al, [randNum1]
	cmp byte al, 4
	je its4check

	mov al, [randNum1]
	cmp byte al, 3
	je its3check

	mov al, [randNum1]
	cmp byte al, 2
	je its2check
	jmp its1check_down
	
its4check:
	jmp its4check_down

its3check:
	jmp its3check_down

its2check:
	jmp its2check_down
	;---------------------------
its1check_down:
	push bp				; Pushing so that previous value can be safe
	mov bp, sp
	push es				
	push di				
	push cx

	mov ax, 0xb800
	mov es, ax
	mov cx, 10
	sub word [bp+6], 1
	
loop_for_check_1_down:
	mov bx, [bp+4]
	add bx, 2
	mov ax, 80
	mul bx
	inc word [bp+6]
	add ax, [bp+6]
	shl ax, 1
	mov di, ax
	mov word ax, [es:di]
	cmp ax, 0x7000
	jne cannotgo_1_downer
	mov word [nextgo], 1
	loop loop_for_check_1_down
	jmp exit_its1check_down

cannotgo_1_downer:
	mov word [nextgo], 0
	jmp exit_its1check_down

exit_its1check_down:
	pop cx
	pop di
	pop es
	pop bp
ret 4

		;---------------------------
its2check_down:
	push bp				; Pushing so that previous value can be safe
	mov bp, sp
	push es				
	push di				
	push cx

	mov ax, 0xb800
	mov es, ax
	mov cx, 6
	sub word [bp+6], 1

check_2:
	mov bx, [bp+4]
	add bx, 2
	mov ax, 80
	mul bx
	add word [bp+6], 1
	add ax, [bp+6]
	shl ax, 1
	mov di, ax
	mov word ax, [es:di]
	cmp ax, 0x7000
	jne cannotgo_2_down
	mov word [nextgo], 1
	loop check_2
	jmp exit_its2check_down

cannotgo_2_down:
	mov word [nextgo], 0
	jmp exit_its2check_down

exit_its2check_down:
	pop cx
	pop di
	pop es
	pop bp
ret 4

	;---------------------------
its3check_down:
	push bp				; Pushing so that previous value can be safe
	mov bp, sp
	push es				
	push di				
	push cx

	mov ax, 0xb800
	mov es, ax
	mov cx, 8
	sub word [bp+6], 1

loop_for_check_3_down:	
	mov bx, [bp+4]
	mov ax, 80
	mul bx
	add word [bp+6], 1
	add ax, [bp+6]
	shl ax, 1
	mov di, ax
	mov word ax, [es:di]
	cmp ax, 0x7000
	jne cannotgo_3_downer
	mov word [nextgo], 1
	loop loop_for_check_3_down

	mov ax, 0xb800
	mov es, ax
	mov cx, 2

loop_for_check_3_down_1:	
	mov bx, [bp+4]
	add bx, 2
	mov ax, 80
	mul bx
	add word [bp+6], 1
	add ax, [bp+6]
	shl ax, 1
	mov di, ax
	mov word ax, [es:di]
	cmp ax, 0x7000
	jne cannotgo_3_downer
	mov word [nextgo], 1
	loop loop_for_check_3_down_1
	jmp exit_its3check_down

cannotgo_3_downer:
	mov word [nextgo], 0
	jmp exit_its3check_down

exit_its3check_down:
	pop cx
	pop di
	pop es
	pop bp
ret 4

	;---------------------------
its4check_down:
	push bp				; Pushing so that previous value can be safe
	mov bp, sp
	push es				
	push di				
	push cx

	mov ax, 0xb800
	mov es, ax
	
	mov bx, [bp+4]
	mov ax, 80
	mul bx
	add ax, [bp+6]
	shl ax, 1
	mov di, ax
	mov word ax, [es:di]
	cmp ax, 0x7000
	jne cannotgo_4_down
	mov word [nextgo], 1

	mov ax, 0xb800
	mov es, ax
	
	mov bx, [bp+4]
	add bx, 2
	mov ax, 80
	mul bx
	add word [bp+6], 4
	add ax, [bp+6]
	shl ax, 1
	mov di, ax
	mov word ax, [es:di]
	cmp ax, 0x7000
	jne cannotgo_4_down
	mov word [nextgo], 1

	mov ax, 0xb800
	mov es, ax
	
	mov bx, [bp+4]
	mov ax, 80
	mul bx
	add word [bp+6], 4
	add ax, [bp+6]
	shl ax, 1
	mov di, ax
	mov word ax, [es:di]
	cmp ax, 0x7000
	jne cannotgo_4_down
	mov word [nextgo], 1
	jmp exit_its4check_down

cannotgo_4_down:
	mov word [nextgo], 0
	jmp exit_its4check_down

exit_its4check_down:
	pop cx
	pop di
	pop es
	pop bp
ret 4

;------------------------------------------------------------------------------------------------------------------------------------------------
check_next_right:
	mov ax, 0
	mov al, [randNum1]
	cmp byte al, 4
	je its4checkrigh

	mov al, [randNum1]
	cmp byte al, 3
	je its3checkri

	mov al, [randNum1]
	cmp byte al, 2
	je its2checkri
	jmp its1checkri

its4checkrigh:
	jmp its4checkri

	;---------------------------
its1checkri:
	push bp				; Pushing so that previous value can be safe
	mov bp, sp
	push es				
	push di				
	push cx

	mov ax, [bp+4]
	add ax, 6
	cmp ax, 42
	jg cannotgo_1_right
	mov word [nextgoright], 1
	jmp exit_its1check_right

cannotgo_1_right:
	mov word [nextgoright], 0
	jmp exit_its1check_right

exit_its1check_right:
	pop cx
	pop di
	pop es
	pop bp
ret 2

		;---------------------------
its2checkri:
	push bp				; Pushing so that previous value can be safe
	mov bp, sp
	push es				
	push di				
	push cx

	mov ax, [bp+4]
	add ax, 2
	cmp ax, 42
	jg cannotgo_2_right
	mov word [nextgoright], 1
	jmp exit_its2check_right

cannotgo_2_right:
	mov word [nextgoright], 0
	jmp exit_its2check_right

exit_its2check_right:
	pop cx
	pop di
	pop es
	pop bp
ret 2
	;---------------------------
its3checkri:
	push bp				; Pushing so that previous value can be safe
	mov bp, sp
	push es				
	push di				
	push cx

	mov ax, [bp+4]
	add ax, 6
	cmp ax, 42
	jg cannotgo_3_right
	mov word [nextgoright], 1
	jmp exit_its3check_right

cannotgo_3_right:
	mov word [nextgoright], 0
	jmp exit_its3check_right

exit_its3check_right:
	pop cx
	pop di
	pop es
	pop bp
ret 2

	;---------------------------
its4checkri:
	push bp				; Pushing so that previous value can be safe
	mov bp, sp
	push es				
	push di				
	push cx

	mov ax, [bp+4]
	add ax, 6
	cmp ax, 42
	jg cannotgo_4_right
	mov word [nextgoright], 1
	jmp exit_its4check_right

cannotgo_4_right:
	mov word [nextgoright], 0
	jmp exit_its4check_right

exit_its4check_right:
	pop cx
	pop di
	pop es
	pop bp
ret 2

;------------------------------------------------------------------------------------------------------------------------------------------------
check_next_left:
	push bp				; Pushing so that previous value can be safe
	mov bp, sp
	push es				
	push di				
	push cx

	mov ax, [bp+4]
	sub ax, 1
	cmp ax, 6
	jl cannotgo_left
	
	mov word [nextgoleft], 1
	jmp exit_itscheck_left

cannotgo_left:
	mov word [nextgoleft], 0
	jmp exit_itscheck_left

exit_itscheck_left:
	pop cx
	pop di
	pop es
	pop bp
ret 2

;------------------------------------------------------------------------------------------------------------------------------------------------
row_3_checker: 						; It'll print grey color board on black color board
		mov ax, 25			; For columns / x-position
		push ax
		mov ax, 3			; For rows / y-position
		push ax
		call count_r3

count_r3:					; For grey color printing
		push bp				; Pushing so that previous value can be safe
		mov bp, sp
		push es				
		push di				
		push cx				

		mov ax, 0xb800
		mov es, ax
		mov bx, [bp+4]
		mov ax, 80
		mul bx
		add ax, [bp+6]
		shl ax, 1
		mov di, ax	
		mov word ax, [es:di]		; Grey on Black Board
		cmp ax, 0x7000
		jne cant
		mov word [forr3], 0
		jmp exitr3
		call vanish

cant:
		mov word [forr3], 1
		jmp exitr3
		call vanish

exitr3:
		pop cx
		pop di
		pop es
		pop bp
		pop ax
		pop ax
		pop ax
ret

;------------------------------------------------------------------------------------------------------------------------------------------------
one_row_grey_board:					; It'll print grey color board on black color board
		mov ax, 6			; For columns / x-position
		push ax
		mov ax, 3			; For rows / y-position
		push ax
		call grey_printing1

grey_printing1:					; For grey color printing
		push bp				; Pushing so that previous value can be safe
		mov bp, sp
		push es				
		push di				
		push cx				

		mov ax, 0xb800
		mov es, ax
		mov bx, [bp+4]
		mov ax, 80
		mul bx
		add ax, [bp+6]
		shl ax, 1
		mov di, ax
		mov cx, 84			; After taking 6 columns from start and 10 columns from end
		mov ax, 0x7000			; Grey on Black Board

print_grey1:
		mov [es:di], ax
		add di, 2
		sub cx, 2
		cmp cx, 0
		jnz print_grey1

		pop cx
		pop di
		pop es
		pop bp
		pop ax
		pop ax
		pop ax
ret

;------------------------------------------------------------------------------------------------------------------------------------------------
kbisr: 
	mov ax, 0
	
	mov al, [randNum1]
	cmp byte al, 4
	je movement4

	mov al, [randNum1]
	cmp byte al, 3
	je gomovement3

	mov al, [randNum1]
	cmp byte al, 2
	je gomovement2
	jmp movement1

gomovement2:
	jmp movement2
	
gomovement3:
	jmp movement3

movement4:
	push ax
 	push es
 	in al, 0x60  		; read a char from keyboard port
 	cmp al, 0x4b 		; is the key left shift
 	jne nextcmp4  		; no, try next comparison
 
	mov word ax, [colstart]
	mov word [columns], ax
	
	mov word ax, [rowstart]
	mov word [rows], ax

	mov word ax, [columns]
	push ax
	call check_next_left
	cmp word [nextgoleft], 1
	jne nomatch4

	mov ax, [columns]		; Cols
	push ax
	mov ax, [rows]			; Rows
	push ax
	call print_T_shape_cover
	
	dec word [columns]

	mov ax, [columns]		; Cols
	push ax
	mov ax, [rows]			; Rows
	push ax
	call print_T_shape

 	jmp nomatch4     	; leave interrupt routine
 
nextcmp4: 
	cmp al, 0x4d 		; is the key right shift
 	jne nomatch4 		; no, leave interrupt routine

	mov word ax, [colstart]
	mov word [columns], ax
	
	mov word ax, [rowstart]
	mov word [rows], ax

	mov word ax, [columns]
	dec ax
	push ax
	call check_next_right
	cmp word [nextgoright], 1
	jne nomatch4
	
	mov ax, [columns]		; Cols
	push ax
	mov ax, [rows]			; Rows
	push ax
	call print_T_shape_cover
	
	inc word [columns]

	mov ax, [columns]		; Cols
	push ax
	mov ax, [rows]			; Rows
	push ax
	call print_T_shape

nomatch4: 
 	pop es
 	pop ax
 	jmp far [cs:oldisr] 	; call the original ISR

movement3:
	push ax
 	push es
 	in al, 0x60  		; read a char from keyboard port
 	cmp al, 0x4b 		; is the key left shift
 	jne nextcmp3  		; no, try next comparison
 
	mov word ax, [colstart]
	mov word [columns], ax
	
	mov word ax, [rowstart]
	mov word [rows], ax

	mov word ax, [columns]
	push ax
	call check_next_left
	cmp word [nextgoleft], 1
	jne nomatch3

	mov ax, [columns]		; Cols
	push ax
	mov ax, [rows]			; Rows
	push ax
	call print_J_shape_cover
	
	dec word [columns]

	mov ax, [columns]		; Cols
	push ax
	mov ax, [rows]			; Rows
	push ax
	call print_J_shape

 	jmp nomatch3     	; leave interrupt routine
 
nextcmp3: 
	cmp al, 0x4d 		; is the key right shift
 	jne nomatch3 		; no, leave interrupt routine

	mov word ax, [colstart]
	mov word [columns], ax
	
	mov word ax, [rowstart]
	mov word [rows], ax

	mov word ax, [columns]
	dec ax
	push ax
	call check_next_right
	cmp word [nextgoright], 1
	jne nomatch3
	
	mov ax, [columns]		; Cols
	push ax
	mov ax, [rows]			; Rows
	push ax
	call print_J_shape_cover
	
	inc word [columns]

	mov ax, [columns]		; Cols
	push ax
	mov ax, [rows]			; Rows
	push ax
	call print_J_shape

nomatch3: 
 	pop es
 	pop ax
 	jmp far [cs:oldisr] 	; call the original ISR

movement2:
	push ax
 	push es
 	in al, 0x60  		; read a char from keyboard port
 	cmp al, 0x4b 		; is the key left shift
 	jne nextcmp2  		; no, try next comparison
 
	mov word ax, [colstart]
	mov word [columns], ax
	
	mov word ax, [rowstart]
	mov word [rows], ax

	mov word ax, [columns]
	push ax
	call check_next_left
	cmp word [nextgoleft], 1
	jne nomatch2

	mov ax, [columns]		; Cols
	push ax
	mov ax, [rows]			; Rows
	push ax
	call print_O_shape_cover
	
	dec word [columns]

	mov ax, [columns]		; Cols
	push ax
	mov ax, [rows]			; Rows
	push ax
	call print_O_shape

 	jmp nomatch2     	; leave interrupt routine
 
nextcmp2: 
	cmp al, 0x4d 		; is the key right shift
 	jne nomatch2 		; no, leave interrupt routine

	mov word ax, [colstart]
	mov word [columns], ax
	
	mov word ax, [rowstart]
	mov word [rows], ax

	mov word ax, [columns]
	dec ax
	push ax
	call check_next_right
	cmp word [nextgoright], 1
	jne nomatch2
	
	mov ax, [columns]		; Cols
	push ax
	mov ax, [rows]			; Rows
	push ax
	call print_O_shape_cover
	
	inc word [columns]

	mov ax, [columns]		; Cols
	push ax
	mov ax, [rows]			; Rows
	push ax
	call print_O_shape

nomatch2: 
 	pop es
 	pop ax
 	jmp far [cs:oldisr] 	; call the original ISR

movement1:
	push ax
 	push es
 	in al, 0x60  		; read a char from keyboard port
 	cmp al, 0x4b 		; is the key left shift
 	jne nextcmp1 		; no, try next comparison
 
	mov word ax, [colstart]
	mov word [columns], ax
	
	mov word ax, [rowstart]
	mov word [rows], ax

	mov word ax, [columns]
	push ax
	call check_next_left
	cmp word [nextgoleft], 1
	jne nomatch1

	mov ax, [columns]		; Cols
	push ax
	mov ax, [rows]			; Rows
	push ax
	call print_L_shape_cover
	
	dec word [columns]

	mov ax, [columns]		; Cols
	push ax
	mov ax, [rows]			; Rows
	push ax
	call print_L_shape

 	jmp nomatch1     	; leave interrupt routine
 
nextcmp1: 
	cmp al, 0x4d 		; is the key right shift
 	jne nomatch1 		; no, leave interrupt routine

	mov word ax, [colstart]
	mov word [columns], ax
	
	mov word ax, [rowstart]
	mov word [rows], ax

	mov word ax, [columns]
	dec ax
	push ax
	call check_next_right
	cmp word [nextgoright], 1
	jne nomatch1
	
	mov ax, [columns]		; Cols
	push ax
	mov ax, [rows]			; Rows
	push ax
	call print_L_shape_cover
	
	inc word [columns]

	mov ax, [columns]		; Cols
	push ax
	mov ax, [rows]			; Rows
	push ax
	call print_L_shape

nomatch1: 
 	pop es
 	pop ax
 	jmp far [cs:oldisr] 	; call the original ISR

;------------------------------------------------------------------------------------------------------------------------------------------------
input_to_start:
	mov ax, 17				;Columns
	push ax
	mov ax, 15				;Rows
	push ax
	mov ax, 0x74
	push ax
	mov ax, msgstart
	push ax
	call printstr
	mov ah, 0
	int 0x16
	jmp game_start	
ret

;------------------------------------------------------------------------------------------------------------------------------------------------
greenscreen:
	push ax
        push di
	push cx
        push es
        mov ax, 0xb800    			;b800 starting adress
        mov es, ax
        xor di, di    	 			;xor answer will be zero,so di initialized to zero
	mov ax, 0x2200 				; 0=backgroud black,7=forground white of spaces so not visible
	mov cx, 2000    

	cld					; Will set DF=0. So, it'll move from lower to higher address
	rep stosw				; Will push spaces until whole screen become clear

        pop es
	pop cx
        pop di
        pop ax
ret

;------------------------------------------------------------------------------------------------------------------------------------------------
vanish:
	push es
	push di
	push cx
	push ax
	push bx

	mov ax, 0xb800
	mov es, ax
	mov bx, 21
	add bx, 1

loop_for_vanish:
	sub bx, 1
	mov ax, 80
	mul bx
	add ax, 6
	shl ax, 1
	mov di, ax
	mov cx, 36

nextcheck:
	mov word ax, [es:di]
	cmp cx, 0
	je compare
	sub cx, 1
	add di, 2
	cmp ax, 0x7000
	jne nextcheck
	je loop_for_vanish

compare:
	call delay
	mov ax, [score]
	add ax, 10
	mov [score], ax
	call printing_score
	push bx
	call scroll
	cmp bx, 3
	jg loop_for_vanish
	
	mov ax, [score]
	sub ax, 10
	mov [score], ax
	call printing_score

	pop bx
	pop ax
	pop cx
	pop di
	pop es
ret

;------------------------------------------------------------------------------------------------------------------------------------------------
scroll:
	push bp
 	mov bp,sp
 	push ax
 	push cx
 	push si
 	push di
 	push es
 	push ds

 	mov ax, 0xb800
 	mov es, ax 		; point es to video base
 	mov ds, ax
 	mov ax, 80 		; load al with columns per row
	mov bx, [bp+4]
 	mul bx 			; multiply with y position
 	add ax, 6 		; add x position
 	shl ax, 1 		; turn into byte offset
 	mov di, ax 
	mov si, di
	sub si, 160
	mov cx, 42
	mov dx, 18

scrolldownouterloop:
	push si
	push di

scrolldownloop: 
	movsw			; scroll up
	dec cx
	jnz scrolldownloop

	pop di
	pop si

	sub di, 160
	sub si, 160
	mov cx, 42
	dec dx
	jnz scrolldownouterloop
	call one_row_grey_board
	
	add word [bp+4], 1
	mov word bx, [bp+4]

	call sound_caller

 	pop ds
 	pop es
 	pop di
 	pop si
 	pop cx
 	pop ax
 	pop bp
ret 2

;------------------------------------------------------------------------------------------------------------------------------------------------
sound:
	push ax
	push bx
	mov al, 182
	out 43h, al
	mov ax, 2711
	out 42h, al
	mov al, ah
	out 42h, al
	in al, 61h
	or al, 00000011b
	out 61h, al
	mov bx, cx
.pause1:
	mov cx, 65535
.pause2:
	dec cx
	jne .pause2
	dec bx
	jne .pause1

	in al, 61h
	and al, 11111100b
	out 61h, al

	pop bx
	pop ax
ret

;------------------------------------------------------------------------------------------------------------------------------------------------
sound_caller:
		push cx
 		mov cx, 2
		call sound
		pop cx
ret
	
;------------------------------------------------------------------------------------------------------------------------------------------------
game_start:
		call greenscreen
		call sound_caller
		call input_for_level
		call clrscr
		call sound_caller
		call grey_board
		call sound_caller
		call delaycaller
		call score_board
		call time_board
		call next_shape_board
		call printing_t_s_n
		call printing_score
		call sound_caller
		call delaycaller
		
	start1:  
		xor ax, ax 
		mov es, ax 			; point es to IVT base 
		cli 				; disable interrupts 
		mov word [es:8*4], timer	; store offset at n*4 
		mov [es:8*4+2], cs 		; store segment at n*4+2 
		sti 				; enable interrupts 
			
		mov dx, start1 			; end of resident portion 
		add dx, 15 			; round up to next para 
		mov cl, 4 
 		shr dx, cl 			; number of paras	

		xor ax, ax
 		mov es, ax 			; point es to IVT base
 		mov ax, [es:9*4]
 		mov [oldisr], ax 		; save offset of old routine
 		mov ax, [es:9*4+2]
 		mov [oldisr+2], ax	 	; save segment of old routine

		cli 				; disable interrupts
 		mov word [es:9*4], kbisr 	; store offset at n*4
 		mov [es:9*4+2], cs 		; store segment at n*4+2
 		sti 	

		call randGen
		call print_randGen_Shape_Side
 
	only:
		mov byte al, [randNum]
		mov byte [randNum1], al
		call next_shape_board
		call randGen
		call print_randGen_Shape_Side
		call print_next_shape_by_rand
		call sound_caller 
		call row_3_checker
		cmp word [forr3], 1
		je endscreen
		sub word [movement], 1
		jnz only

	leftorright: 
		mov ah, 0 			; service 0 – get keystroke
 		int 0x16 			; call BIOS keyboard service
 		cmp al, 27 			; is the Esc key pressed
 		jne leftorright 		; if no, check for next key
 		mov ax, [oldisr]		; read old offset in ax
 		mov bx, [oldisr+2] 		; read old segment in bx
		cli 				; disable interrupts
 		mov [es:9*4], ax 		; restore old offset from ax
 		mov [es:9*4+2], bx 		; restore old segment from bx
 		sti				; enable interrupts
endscreen:
		call ending_screen
ret
		
;------------------------------------------------------------------------------------------------------------------------------------------------
start:						; Start of our program
		call clrscr
		call clrvar
		call welcome_screen
		call delaycaller
		call sound_caller
		call welcome_screen_printing
		call sound_caller
		call delaycaller
		call tetris_printing
		call input_to_start

;------------------------------------------------------------------------------------------------------------------------------------------------
end:		
		mov ah, 0x1			; Work as system("pause")
		int 0x21

		mov ax, 0x3100
		int 0x21