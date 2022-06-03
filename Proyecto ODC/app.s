.equ SCREEN_WIDTH, 	640
.equ SCREEN_HEIGH, 	480
.equ BITS_PER_PIXEL,  	32
.equ ancho,		50
.equ alto,		60
.equ pared_derecha, 	590 // SCREEN_WIDTH - ancho
.equ piso, 		420 // SCREEN_HEIGH - alto
.equ rojo, 0xff0000
.equ verde, 0x00ff00
.include "dvdfuns.s"

.globl main
main:
	// X0 contiene la direccion base del framebuffer
 	mov x20, x0	// Save framebuffer base address to x20	
	//---------------- CODE HERE ------------------------------------


	mov x15, 15	//vector movimiento en y
	mov x14, 15	//vector movimiento en x
	
	mov x5, 500		//pos.columna inicial
	mov x6, 300	//pos.fila inicial


	mov w11, rojo
	movz w13, 0xff, lsl 00


DVDLOOP:
	// FONDO
	mov x10, 127
	
	mov x1, SCREEN_WIDTH
	mov x2, SCREEN_HEIGH
	mov x3, 0	// pos.columna
	mov x4, 0	// pos.fila

	BL Pixeldir
	BL dibujarcuadrado

//BLoque
	
	mov x1, ancho
	mov x2, alto

	mov x3, x5	// pos.columna (x)
	cmp x3, pared_derecha //  pos.x == pared derecha
	B.GE rebote_horizontal1
	cmp x3, 0
	B.LE rebote_horizontal2
mov_x:
	add x3, x3, x14
	
	mov x4, x6	// pos.fila (y)
	cmp x4, piso  // pos.y == piso
	B.GE rebote_vertical1	
	cmp x4, 0
	B.LE rebote_vertical2	

mov_y:
	add x4, x4, x15
	mov w10, w11
	BL Pixeldir
	BL dibujarcuadrado


	mov x5, x3
	mov x6, x4

	BL DELAY
	
	b DVDLOOP

DELAY:
	movz x9, 0xff,lsl 16 
	movk x9, 0xffff, lsl 00
	loop:
	subs x9, x9, 1
	b.ne loop
ret

rebote_horizontal1:
	mov x13, 0
	sub x14, x13, x14
	movz w11, 0xff, lsl 16
	movk w11, 0x0000, lsl 00
	add w7, w7, 0xa3
	sub w11, w11, w7
	b mov_x
	
rebote_horizontal2:
	mov x13, 0
	sub x14, x13, x14
	movz w11, 0xff, lsl 16
	movk w11, 0x0f00, lsl 00
	add w7, w7, 0xa3
	add w11, w11, w7
	b mov_x

rebote_vertical1:
	mov x13, 0
	
	sub x15, x13, x15
	movz w11, 0x00, lsl 16
	movk w11, 0x0fa5, lsl 00
	sub w7, w7, 0xa3
	sub w11, w11, w7
	b mov_y
	
rebote_vertical2:
	mov x13, 0
	
	sub x15, x13, x15
	movz w11, 0x00, lsl 16
	movk w11, 0xfcff, lsl 00
	add w7, w7, 0xa3
	add w11, w11, w7
	b mov_y
