; 显示函数

[SECTION .text]
extern disp_pos
global disp_str
global disp_int
global disp_clear
; ------------------------------------------------------------------------
;	DispStr
; 	显示一个字符串
;	通过堆栈传递一个4字节字符串起始位置变量
;	字符串结尾用0来标识
; ------------------------------------------------------------------------
disp_str:
	push	ebp              ; 从堆栈中取出字符串
	mov	ebp, esp
	push	ebx
	push	esi
	push	edi

	mov	esi, [ebp + 8]
	mov	edi, [disp_pos]
	mov	ah, 0Fh

.1:
	lodsb
	test	al, al					;test指令对符号位的影响和and指令相同
	jz	.2			;判断字符串是否已经显示完

	cmp	al, 0Ah					; 判断当前字符是否为回车
	jnz	.3

	push	eax
	mov	eax, edi
	mov	bl, 160
	div	bl
	and	eax, 0FFh
	inc	eax
	mov	bl, 160
	mul	bl
	mov	edi, eax
	pop	eax
	jmp	.1

.3:
	mov	[gs:edi], ax
	add	edi, 2
	jmp	.1

.2:
	mov	[disp_pos], edi

	pop	edi
	pop	esi
	pop	ebx
	pop	ebp
	ret
; DispStr 结束------------------------------------------------------------



; ------------------------------------------------------------------------
; DispAL显示 AL 中的数字
; ------------------------------------------------------------------------
DispAL:
	push	ecx
	push	edx
	push	edi

	mov	edi, [disp_pos]

	mov	ah, 0Fh			; 0000b: 黑底    1111b: 白字
	mov	dl, al
	shr	al, 4
	mov	ecx, 2

num_trans:
	; 把al中的数字转化成ascii码
	and	al, 01111b
	cmp	al, 9
	ja	big_num
	add	al, '0'
	jmp	display

big_num:
	; 对大于9的数字用A加上超过十的部分
	sub	al, 0Ah
	add	al, 'A'

display:
	;对显存进行操作
	mov	[gs:edi], ax
	add	edi, 2

	mov	al, dl
	loop	num_trans

	mov	[disp_pos], edi

	pop	edi
	pop	edx
	pop	ecx

	ret
; DispAL 结束-------------------------------------------------------------

; ------------------------------------------------------------------------------
; DispInt:显示一个整形数
; ------------------------------------------------------------------------------
disp_int:
	mov	eax, [esp + 4]
	shr	eax, 24
	call	DispAL

	mov	eax, [esp + 4]
	shr	eax, 16
	call	DispAL

	mov	eax, [esp + 4]
	shr	eax, 8
	call	DispAL

	mov	eax, [esp + 4]
	call	DispAL

	mov	ah, 07h			; 0000b: 黑底    0111b: 灰字
	mov	al, 'h'
	push	edi
	mov	edi, [disp_pos]
	mov	[gs:edi], ax
	add	edi, 4
	mov	[disp_pos], edi
	pop	edi

	ret
; DispInt 结束------------------------------------------------------------


; DispClear 清空屏幕-------------------------------------------------------
disp_clear:
	push	ecx
	push	edx
	push	edi

	mov edi, 0
	mov	ah, 0Fh			; 0000b: 黑底    1111b: 白字
	mov ecx, 80*25
	mov al, ' '

clear_process:
	mov	[gs:edi], ax
	add	edi, 2

	loop clear_process

	mov edi, (80 * 0 + 0) * 2
	mov	dword [disp_pos], edi

	pop	edi
	pop	edx
	pop	ecx

	ret
; -----------------------------------------------------------------------