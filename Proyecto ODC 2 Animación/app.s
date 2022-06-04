.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480
.equ BITS_PER_PIXEL,  	32
.equ ancho,				50
.equ alto,				60
.equ pared_derecha, 	590 // SCREEN_WIDTH - ancho
.equ piso, 				420 // SCREEN_HEIGH - alto

.include "dvdfuns.s"

.globl main
main:
	// X0 contiene la direccion base del framebuffer
 	mov x20, x0	// Save framebuffer base address to x20	
	//---------------- CODE HERE ------------------------------------


	mov x15, 3	//vector movimiento en y
	mov x14, 3	//vector movimiento en x
	
	mov x5, 500		//pos.columna inicial
	mov x6, 300	//pos.fila inicial
	movz x7, 0x10, lsl 16
	movk x7, 0x0000, lsl 00
	movz x11, 0xff,lsl 16  
	movk x11, 0xffff, lsl 00
	


DVDLOOP:
	// FONDO
	movz x10, 0x00,lsl 16  // Color de fondo : Negro
	movk x10, 0x00ff, lsl 00
	
	mov x1, SCREEN_WIDTH
	mov x2, SCREEN_HEIGH
	mov x3, 0	// pos.columna
	mov x4, 0	// pos.fila

	BL Pixeldir
	BL dibujarcuadrado

//BLoque
	movz x10, 0x57,lsl 16  // Color de fondo : Celeste
	movk x10, 0xb7ff, lsl 00

	mov x1, ancho
	mov x2, alto

	mov x3, x5	// pos.columna (x)
	cmp x3, pared_derecha //  pos.x == pared derecha
	B.GE rebote_horizontal
	cmp x3, 0
	B.LE rebote_horizontal
mov_x:
	add x3, x3, x14
	
	mov x4, x6	// pos.fila (y)
	cmp x4, piso  // pos.y == piso
	B.GE rebote_vertical	
	cmp x4, 0
	B.LE rebote_vertical	
mov_y:
	add x4, x4, x15
	mov x10, x11
	BL Pixeldir
	BL dibujarcuadrado

	mov x5, x3
	mov x6, x4

	BL DELAY
	
	b DVDLOOP

rebote_horizontal:
	mov x13, 0
	sub x14, x13, x14
	/* Cambia de color */
	mul x9, x14, x15 
	cmp x9, x13
	B.LE resto_color
	B sumar_color
resto_color:
	movz x13, 0xaa, lsl 16
	movk x13, 0x0255, lsl 0 
	sub x11, x11, x13
	b mov_x
sumar_color:
	movz x13, 0xae, lsl 16
	movk x13, 0xa2a5, lsl 0 
	add x11, x11, x13	
	b mov_x

rebote_vertical:
	mov x13, 0
	sub x15, x13, x15
	/* Cambia de color */
	mul x9, x14, x15 
	cmp x9, x13
	B.GE resto_colorv
	B sumar_colorv
resto_colorv:
	movz x13, 0x33, lsl 16
	movk x13, 0x2e95, lsl 0 
	sub x11, x11, x13
	b mov_y
sumar_colorv:
	movz x13, 0x45, lsl 16
	movk x13, 0x7d85, lsl 0 
	add x11, x11, x13
	b mov_y
