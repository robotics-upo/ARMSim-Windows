	.equ	SWI_EXIT,		0x11

	.equ	LCD_ACTIVBUFFER,	0x0c300000
	.equ	SCR_WIDTH_CHARS,	40
	.equ	SCR_HEIGHT_CHARS,	15
	
	.global _start
_start:

	mov		r0,#0
	mov		r1,#5
	mov		r2,#'A'
	bl		lcd_drawChar
	
	bl		FillCharPattern
	swi		0x11
	
	ldr		r3,=strMsg
	mov		r0,#0
	mov		r1,#0
loop:
	ldrb	r2,[r3],#1
	cmp		r2,#0
	beq		done

	bl		lcd_drawChar
	add		r0,r0,#1
	bal		loop		
done:
	swi	0x11

FillCharPattern:
	stmfd	sp!,{r0-r5,lr}
	mov		r5,#'A' - 1
	mov		r3,#0
fcp05:
	add		r5,r5,#1
	mov		r4,#0
	mov		r2,r5
fcp10:
	mov		r0,r4
	mov		r1,r3
	bl		lcd_drawChar

	add		r2,r2,#1
	add		r4,r4,#1
	cmp		r4,#SCR_WIDTH_CHARS
	blt		fcp10

	add		r3,r3,#1
	cmp		r3,#SCR_HEIGHT_CHARS
	blt		fcp05
	
	ldmfd	sp!,{r0-r5,pc}

@Draw a single ascii character on the LCD
@R0:xpos
@R1:ypos
@R2:ascii character to draw
lcd_drawChar:
	stmfd	sp!,{r0-r5,lr}

	add		r1,r1,r1,lsl#2			@mult by 5
	mov		r3,r1,lsl#9				@mult by 32*16 (ypos * 160)
	add		r3,r3,r0,lsl#2
	ldr		r1,=LCD_ACTIVBUFFER
	add		r3,r3,r1
	
	ldr		r1,=g_auc_Ascii8x16
	add		r1,r1,r2,lsl#4

	mov		r2,#16	
ldc05:
	ldrb	r0,[r1],#1
	mov		r4,#8
	mov		r5,#0
ldc10:
	movs	r0,r0,ror#1
	orrcs	r5,r5,#0xf0000000
	mov		r5,r5,lsr#4
	subs	r4,r4,#1
	bne		ldc10
	
	str		r5,[r3]

	add		r3,r3,#160	
	subs	r2,r2,#1
	bne		ldc05
	
	ldmfd	sp!,{r0-r5,pc}


	.data
	.align

g_auc_Ascii8x16:
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00	@0x00
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 @0x01
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 @0x02
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 @0x03
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 @0x04
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 @0x05
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 @0x06
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 @0x07
	.byte	0x00,0x00,0x00,0x18,0x08,0xc8,0x08,0x08,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 @0x08
	.byte	0x00,0x00,0x7f,0x60,0x60,0x60,0x60,0x60,0x60,0x60,0x60,0xe0,0x60,0x20,0x00,0x00 @0x09
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 @0x0a
	.byte	0x00,0x00,0x18,0x18,0x18,0x10,0x10,0x10,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 @0x0b
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x08,0x08,0x08,0x0c,0x0c,0x0c,0x00,0x00 @0x0c
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 @0x0d
	.byte	0x00,0x00,0x6c,0x38,0x10,0x00,0x7c,0xc6,0x70,0x1c,0xc6,0x7c,0x00,0x00,0x00,0x00 @0x0e
	.byte	0x00,0x00,0x10,0x38,0x6c,0x00,0x78,0x0c,0x7c,0xcc,0xcc,0x76,0x00,0x00,0x00,0x00 @0x0f
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x7c,0xc6,0x70,0xc0,0xc6,0x7c,0x00,0x00,0x00,0x00 @0x10
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x6c,0x96,0x7c,0xd0,0xd6,0x6c,0x00,0x00,0x00,0x00 @0x11
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x7c,0xc6,0x06,0x06,0xc6,0x7c,0x00,0x00,0x00,0x00 @0x12
	.byte	0x00,0x00,0x00,0x38,0x6c,0xc6,0xc6,0xfe,0xc6,0xc6,0x6c,0x38,0x00,0x00,0x00,0x00 @0x13
	.byte	0x00,0x00,0x00,0x00,0x00,0x10,0x38,0x28,0x6c,0x44,0xc6,0xc6,0x00,0x00,0x00,0x00 @0x14
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x7c,0xc6,0x06,0xfe,0xc6,0x7c,0x00,0x00,0x00,0x00 @0x15
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0xdc,0x66,0x66,0x66,0xf6,0x06,0x06,0x66,0x3c,0x00 @0x16
	.byte	0x00,0x00,0x00,0x6c,0x38,0xf8,0x0c,0x7e,0xc6,0xc6,0xc6,0x7c,0x00,0x00,0x00,0x00 @0x17
	.byte	0x00,0x00,0x00,0x0e,0x1b,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0xd8,0x70,0x00,0x00 @0x18
	.byte	0x00,0x00,0x00,0x00,0x00,0xfe,0x86,0x0c,0x18,0x0c,0x06,0x06,0xc6,0x7c,0x00,0x00 @0x19
	.byte	0x00,0x00,0x76,0xdc,0x00,0x00,0x78,0x0c,0x7c,0xcc,0xcc,0x76,0x00,0x00,0x00,0x00 @0x10
	.byte	0x00,0x00,0x76,0xdc,0x00,0x00,0x7c,0xc6,0x06,0x06,0xc6,0x7c,0x00,0x00,0x00,0x00 @0x1b
	.byte	0x00,0x00,0x76,0xdc,0x00,0x00,0xdc,0x66,0x66,0x66,0x66,0x66,0x00,0x00,0x00,0x00 @0x1c
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x76,0x99,0x9f,0x98,0x99,0x6f,0x00,0x00,0x00,0x00 @0x1d
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x0c,0x06,0x06,0x00,0x00 @0x1e
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x3c,0x66,0x66,0x3c,0x00,0x00 @0x1f
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 @0x20
	.byte	0x00,0x00,0x00,0x18,0x3c,0x3c,0x3c,0x18,0x18,0x00,0x18,0x18,0x00,0x00,0x00,0x00 @0x21
	.byte	0x00,0x00,0xc6,0xc6,0xc6,0x44,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 @0x22
	.byte	0x00,0x00,0x00,0x6c,0x6c,0xfe,0x6c,0x6c,0x6c,0xfe,0x6c,0x6c,0x00,0x00,0x00,0x00 @0x23
	.byte	0x00,0x18,0x18,0x7c,0xc6,0xc2,0xc0,0x7c,0x06,0x86,0xc6,0x7c,0x18,0x18,0x00,0x00 @0x24
	.byte	0x00,0x00,0x00,0x00,0x00,0xc3,0xc6,0x0c,0x18,0x30,0x63,0xc3,0x00,0x00,0x00,0x00 @0x25
	.byte	0x00,0x00,0x00,0x38,0x6c,0x6c,0x38,0x76,0xdc,0xcc,0xcc,0x76,0x00,0x00,0x00,0x00 @0x26
	.byte	0x00,0x00,0x30,0x30,0x30,0x60,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 @0x27
	.byte	0x00,0x00,0x00,0x18,0x30,0x60,0x60,0x60,0x60,0x60,0x30,0x18,0x00,0x00,0x00,0x00 @0x28
	.byte	0x00,0x00,0x00,0x18,0x0c,0x06,0x06,0x06,0x06,0x06,0x0c,0x18,0x00,0x00,0x00,0x00 @0x29
	.byte	0x00,0x00,0x00,0x00,0x00,0x6c,0x38,0xfe,0x38,0x6c,0x00,0x00,0x00,0x00,0x00,0x00 @0x2a
	.byte	0x00,0x00,0x00,0x00,0x18,0x18,0x18,0x7e,0x18,0x18,0x18,0x00,0x00,0x00,0x00,0x00 @0x2b
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x18,0x18,0x18,0x30,0x00,0x00,0x00 @0x2c
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xfe,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 @0x2d
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x18,0x18,0x00,0x00,0x00,0x00 @0x2e
	.byte	0x00,0x00,0x00,0x02,0x06,0x0c,0x18,0x30,0x60,0xc0,0x80,0x00,0x00,0x00,0x00,0x00 @0x2f
	.byte	0x00,0x00,0x00,0x7c,0xc6,0xce,0xde,0xf6,0xe6,0xc6,0xc6,0x7c,0x00,0x00,0x00,0x00 @0x30
	.byte	0x00,0x00,0x00,0x18,0x38,0x78,0x18,0x18,0x18,0x18,0x18,0x7e,0x00,0x00,0x00,0x00 @0x31
	.byte	0x00,0x00,0x00,0x7c,0xc6,0x06,0x0c,0x18,0x30,0x60,0xc6,0xfe,0x00,0x00,0x00,0x00 @0x32
	.byte	0x00,0x00,0x00,0x7c,0xc6,0x06,0x06,0x3c,0x06,0x06,0xc6,0x7c,0x00,0x00,0x00,0x00 @0x33
	.byte	0x00,0x00,0x00,0x0c,0x1c,0x3c,0x6c,0xcc,0xfe,0x0c,0x0c,0x1e,0x00,0x00,0x00,0x00 @0x34
	.byte	0x00,0x00,0x00,0xfe,0xc0,0xc0,0xc0,0xfc,0x06,0x06,0xc6,0x7c,0x00,0x00,0x00,0x00 @0x35
	.byte	0x00,0x00,0x00,0x38,0x60,0xc0,0xc0,0xfc,0xc6,0xc6,0xc6,0x7c,0x00,0x00,0x00,0x00 @0x36
	.byte	0x00,0x00,0x00,0xfe,0xc6,0x06,0x0c,0x18,0x30,0x30,0x30,0x30,0x00,0x00,0x00,0x00 @0x37
	.byte	0x00,0x00,0x00,0x7c,0xc6,0xc6,0xc6,0x7c,0xc6,0xc6,0xc6,0x7c,0x00,0x00,0x00,0x00 @0x38
	.byte	0x00,0x00,0x00,0x7c,0xc6,0xc6,0xc6,0x7e,0x06,0x06,0x0c,0x78,0x00,0x00,0x00,0x00 @0x39
	.byte	0x00,0x00,0x00,0x00,0x18,0x18,0x00,0x00,0x00,0x18,0x18,0x00,0x00,0x00,0x00,0x00 @0x3a
	.byte	0x00,0x00,0x00,0x00,0x18,0x18,0x00,0x00,0x00,0x18,0x18,0x30,0x00,0x00,0x00,0x00 @0x3b
	.byte	0x00,0x00,0x00,0x06,0x0c,0x18,0x30,0x60,0x30,0x18,0x0c,0x06,0x00,0x00,0x00,0x00 @0x3c
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x7e,0x00,0x00,0x7e,0x00,0x00,0x00,0x00,0x00,0x00 @0x3d
	.byte	0x00,0x00,0x00,0x60,0x30,0x18,0x0c,0x06,0x0c,0x18,0x30,0x60,0x00,0x00,0x00,0x00 @0x3e
	.byte	0x00,0x00,0x00,0x7c,0xc6,0xc6,0x0c,0x18,0x18,0x00,0x18,0x18,0x00,0x00,0x00,0x00 @0x3f
	.byte	0x00,0x00,0x00,0x7c,0xc6,0xc6,0xde,0xde,0xde,0xdc,0xc0,0x7c,0x00,0x00,0x00,0x00 @0x40
	.byte	0x00,0x00,0x00,0x10,0x38,0x6c,0xc6,0xc6,0xfe,0xc6,0xc6,0xc6,0x00,0x00,0x00,0x00 @0x41
	.byte	0x00,0x00,0x00,0xfc,0x66,0x66,0x66,0x7c,0x66,0x66,0x66,0xfc,0x00,0x00,0x00,0x00 @0x42
	.byte	0x00,0x00,0x00,0x3c,0x66,0xc2,0xc0,0xc0,0xc0,0xc2,0x66,0x3c,0x00,0x00,0x00,0x00 @0x43
	.byte	0x00,0x00,0x00,0xf8,0x6c,0x66,0x66,0x66,0x66,0x66,0x6c,0xf8,0x00,0x00,0x00,0x00 @0x44
	.byte	0x00,0x00,0x00,0xfe,0x66,0x62,0x68,0x78,0x68,0x62,0x66,0xfe,0x00,0x00,0x00,0x00 @0x45
	.byte	0x00,0x00,0x00,0xfe,0x66,0x62,0x68,0x78,0x68,0x60,0x60,0xf0,0x00,0x00,0x00,0x00 @0x46
	.byte	0x00,0x00,0x00,0x3c,0x66,0xc2,0xc0,0xc0,0xde,0xc6,0x66,0x3a,0x00,0x00,0x00,0x00 @0x47
	.byte	0x00,0x00,0x00,0xc6,0xc6,0xc6,0xc6,0xfe,0xc6,0xc6,0xc6,0xc6,0x00,0x00,0x00,0x00 @0x48
	.byte	0x00,0x00,0x00,0x3c,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x3c,0x00,0x00,0x00,0x00 @0x49
	.byte	0x00,0x00,0x00,0x1e,0x0c,0x0c,0x0c,0x0c,0x0c,0xcc,0xcc,0x78,0x00,0x00,0x00,0x00 @0x4a
	.byte	0x00,0x00,0x00,0xe6,0x66,0x6c,0x6c,0x78,0x6c,0x6c,0x66,0xe6,0x00,0x00,0x00,0x00 @0x4b
	.byte	0x00,0x00,0x00,0xf0,0x60,0x60,0x60,0x60,0x60,0x62,0x66,0xfe,0x00,0x00,0x00,0x00 @0x4c
	.byte	0x00,0x00,0x00,0xc6,0xee,0xfe,0xd6,0xc6,0xc6,0xc6,0xc6,0xc6,0x00,0x00,0x00,0x00 @0x4d
	.byte	0x00,0x00,0x00,0xc6,0xe6,0xf6,0xfe,0xde,0xce,0xc6,0xc6,0xc6,0x00,0x00,0x00,0x00 @0x4e
	.byte	0x00,0x00,0x00,0x38,0x6c,0xc6,0xc6,0xc6,0xc6,0xc6,0x6c,0x38,0x00,0x00,0x00,0x00 @0x4f
	.byte	0x00,0x00,0x00,0xfc,0x66,0x66,0x66,0x7c,0x60,0x60,0x60,0xf0,0x00,0x00,0x00,0x00 @0x50
	.byte	0x00,0x00,0x00,0x7c,0xc6,0xc6,0xc6,0xd6,0xde,0x7c,0x0c,0x0e,0x00,0x00,0x00,0x00 @0x51
	.byte	0x00,0x00,0x00,0xfc,0x66,0x66,0x66,0x7c,0x6c,0x66,0x66,0xe6,0x00,0x00,0x00,0x00 @0x52
	.byte	0x00,0x00,0x00,0x7c,0xc6,0xc6,0x60,0x38,0x0c,0xc6,0xc6,0x7c,0x00,0x00,0x00,0x00 @0x53
	.byte	0x00,0x00,0x00,0x7e,0x5a,0x18,0x18,0x18,0x18,0x18,0x18,0x3c,0x00,0x00,0x00,0x00 @0x54
	.byte	0x00,0x00,0x00,0xc6,0xc6,0xc6,0xc6,0xc6,0xc6,0xc6,0xc6,0x7c,0x00,0x00,0x00,0x00 @0x55
	.byte	0x00,0x00,0x00,0xc6,0xc6,0xc6,0xc6,0xc6,0xc6,0x6c,0x38,0x10,0x00,0x00,0x00,0x00 @0x56
	.byte	0x00,0x00,0x00,0xc6,0xc6,0xc6,0xc6,0xc6,0xd6,0xfe,0xee,0xc6,0x00,0x00,0x00,0x00 @0x57
	.byte	0x00,0x00,0x00,0xc6,0xc6,0xc6,0x6c,0x38,0x6c,0xc6,0xc6,0xc6,0x00,0x00,0x00,0x00 @0x58
	.byte	0x00,0x00,0x00,0xc6,0xc6,0xc6,0x6c,0x38,0x38,0x38,0x38,0x7c,0x00,0x00,0x00,0x00 @0x59
	.byte	0x00,0x00,0x00,0xfe,0xc6,0x8c,0x18,0x30,0x60,0xc2,0xc6,0xfe,0x00,0x00,0x00,0x00 @0x5a
	.byte	0x00,0x00,0x00,0x3c,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x3c,0x00,0x00,0x00,0x00 @0x5b
	.byte	0x00,0x00,0x00,0x80,0xc0,0xe0,0x70,0x38,0x1c,0x0e,0x06,0x02,0x00,0x00,0x00,0x00 @0x5c
	.byte	0x00,0x00,0x00,0x3c,0x0c,0x0c,0x0c,0x0c,0x0c,0x0c,0x0c,0x3c,0x00,0x00,0x00,0x00 @0x5d
	.byte	0x00,0x10,0x38,0x6c,0xc6,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 @0x5e
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xfe,0x00,0x00 @0x5f
	.byte	0x00,0x00,0x30,0x30,0x18,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 @0x60
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x78,0x0c,0x7c,0xcc,0xcc,0x76,0x00,0x00,0x00,0x00 @0x61
	.byte	0x00,0x00,0x00,0xe0,0x60,0x60,0x78,0x6c,0x66,0x66,0x66,0xdc,0x00,0x00,0x00,0x00 @0x62
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x7c,0xc6,0xc0,0xc0,0xc6,0x7c,0x00,0x00,0x00,0x00 @0x63
	.byte	0x00,0x00,0x00,0x1c,0x0c,0x0c,0x3c,0x6c,0xcc,0xcc,0xcc,0x76,0x00,0x00,0x00,0x00 @0x64
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x7c,0xc6,0xfe,0xc0,0xc6,0x7c,0x00,0x00,0x00,0x00 @0x65
	.byte	0x00,0x00,0x00,0x1c,0x36,0x32,0x30,0x7c,0x30,0x30,0x30,0x78,0x00,0x00,0x00,0x00 @0x66
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x76,0xcc,0xcc,0xcc,0x7c,0x0c,0xcc,0x78,0x00,0x00 @0x67
	.byte	0x00,0x00,0x00,0xe0,0x60,0x60,0x6c,0x76,0x66,0x66,0x66,0xe6,0x00,0x00,0x00,0x00 @0x68
	.byte	0x00,0x00,0x00,0x18,0x18,0x00,0x38,0x18,0x18,0x18,0x18,0x3c,0x00,0x00,0x00,0x00 @0x69
	.byte	0x00,0x00,0x00,0x06,0x06,0x00,0x0e,0x06,0x06,0x06,0x06,0x66,0x66,0x3c,0x00,0x00 @0x6a
	.byte	0x00,0x00,0x00,0xe0,0x60,0x60,0x66,0x6c,0x78,0x6c,0x66,0xe6,0x00,0x00,0x00,0x00 @0x6b
	.byte	0x00,0x00,0x00,0x38,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x3c,0x00,0x00,0x00,0x00 @0x6c
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x44,0xfe,0xd6,0xd6,0xd6,0xd6,0x00,0x00,0x00,0x00 @0x6d
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0xdc,0x66,0x66,0x66,0x66,0x66,0x00,0x00,0x00,0x00 @0x6e
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x7c,0xc6,0xc6,0xc6,0xc6,0x7c,0x00,0x00,0x00,0x00 @0x6f
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0xdc,0x66,0x66,0x66,0x7c,0x60,0x60,0xf0,0x00,0x00 @0x70
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x76,0xcc,0xcc,0xcc,0x7c,0x0c,0x0c,0x1e,0x00,0x00 @0x71
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0xdc,0x76,0x66,0x60,0x60,0xf0,0x00,0x00,0x00,0x00 @0x72
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x7c,0xc6,0x70,0x1c,0xc6,0x7c,0x00,0x00,0x00,0x00 @0x73
	.byte	0x00,0x00,0x00,0x10,0x30,0x30,0xfc,0x30,0x30,0x30,0x36,0x1c,0x00,0x00,0x00,0x00 @0x74
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0xcc,0xcc,0xcc,0xcc,0xcc,0x76,0x00,0x00,0x00,0x00 @0x75
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0xc6,0xc6,0xc6,0x6c,0x38,0x10,0x00,0x00,0x00,0x00 @0x76
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0xc6,0xc6,0xc6,0xd6,0xfe,0x6c,0x00,0x00,0x00,0x00 @0x77
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0xc6,0x6c,0x38,0x38,0x6c,0xc6,0x00,0x00,0x00,0x00 @0x78
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0xc6,0xc6,0xc6,0xc6,0x7e,0x06,0x0c,0x78,0x00,0x00 @0x79
	.byte	0x00,0x00,0x00,0x00,0x00,0x00,0xfe,0xcc,0x18,0x30,0x66,0xfe,0x00,0x00,0x00,0x00 @0x7a
	.byte	0x00,0x00,0x00,0x0e,0x18,0x18,0x18,0x70,0x18,0x18,0x18,0x0e,0x00,0x00,0x00,0x00 @0x7b
	.byte	0x00,0x00,0x00,0x18,0x18,0x18,0x18,0x00,0x18,0x18,0x18,0x18,0x00,0x00,0x00,0x00 @0x7c
	.byte	0x00,0x00,0x00,0x70,0x18,0x18,0x18,0x0e,0x18,0x18,0x18,0x70,0x00,0x00,0x00,0x00 @0x7d
	.byte	0x00,0x00,0x00,0x76,0xdc,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 @0x7e
	.byte	0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff @0x7f

strMsg:	.asciz	"Hi Dale"

	.end

