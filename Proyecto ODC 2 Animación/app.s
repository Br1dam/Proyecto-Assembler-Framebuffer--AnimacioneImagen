.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480
.equ BITS_PER_PIXEL,  	32
.equ ancho,				60
.equ alto,				60
.equ pared_derecha, 	580 // SCREEN_WIDTH - ancho
.equ piso, 				420 // SCREEN_HEIGH - alto
.equ limite,          	100
.equ blanco, 0xFFFFFF

.include "dvdfuns.s"

.globl main
main:
	// X0 contiene la direccion base del framebuffer
 	mov x20, x0	// Save framebuffer base address to x20	
	//---------------- CODE HERE ------------------------------------
//Vector movimiento (de preferencia que sean divisores de pared_derecha y piso)/
	mov x15, -2	//vector movimiento en y
	mov x14, -2	//vector movimiento en x
	
	mov x5, 300		//pos.columna inicial
	mov x6, 300		//pos.fila inicial

	movz x11, 0xfa, lsl 16 // color BLoque
	movk x11, 0xa2a5, lsl 0 
	
	movz x18, 0x0a, lsl 16 // color fondo
	movk x18, 0x2225, lsl 0 
	

	
	mov x22, -1	//vector movimiento en x
	mov x23,300
	mov x24,300
	
// ESCENA SCREENSAVER

escenamouse:
	
	escena:
	
	BL dibujarescritorio
	mov x10, blanco
	mov x3, x23
	mov x4, x24
	

	cmp x3, 350 
	B.EQ moverderizq

	cmp x3, 250
	B.EQ moverderizq

	add x3, x3, x22
	
		
	BL Pixeldir
	Bl dibujarcursor
	/*Almacena posicion */
	mov x23, x3
	mov x24, x4
	
	BL DELAY
	b escena

moverderizq:
	mov x13, 0
	sub x22, x13, x22
	B quieto

quieto:

	add x4, x4,5
 	mov x2, 7
 	BL Pixeldir
	Bl dibujarreloj
 	mov x9, 0xfffffff
	delay:
	sub x9, x9, 1
	cbnz x9, delay
	

	
	
		


DVDLOOP:
	// FONDO ---------------------
	mov x10, x18
	
	mov x1, SCREEN_WIDTH
	mov x2, SCREEN_HEIGH
	mov x3, 0	// pos.columna
	mov x4, 0	// pos.fila

	BL Pixeldir
	BL dibujarfondo

	mov x18, x10  // guarde color fondo en x18

//BLoque --------------------------
	//Cargo color actual/
	mov x10, x11

	mov x1, ancho
	mov x2, alto
	mov x3, x5	// pos.columna (x)
	mov x4, x6	// pos.fila (y)

//* Rebote Esquinas */

	cmp x3, 0 
	B.EQ filas_esquinas

	cmp x3, pared_derecha
	B.EQ filas_esquinas

	B REBOTAR_PAREDES

filas_esquinas:
	cmp x4, 0
	B.EQ esta_en_esquina

	cmp x4, piso
	B.EQ esta_en_esquina

	B REBOTAR_PAREDES

esta_en_esquina:
	add x18, x18, x11 // cambio color de fondo

REBOTAR_PAREDES:

	/* Rebote Paredes */
	cmp x3, pared_derecha //  pos.x == pared derecha
	B.GE rebote_horizontal
	cmp x3, 0
	B.LE rebote_horizontal
mov_x:
	add x3, x3, x14
	
	cmp x4, piso  // pos.y == piso
	B.GE rebote_vertical	
	cmp x4, 0
	B.LE rebote_vertical	
mov_y:
	add x4, x4, x15
		
	BL Pixeldir
	BL dibujarcuadrado
	/*Almacena posicion */
	mov x5, x3
	mov x6, x4
	/*Almaceno color actual */
	mov x11, x10

	
	
	BL DELAY
	
	b DVDLOOP
//--------- FIN de AnNimaCIon --------------/


rebote_horizontal:
	mov x13, 0
	sub x14, x13, x14
	/* Cambia de color */
	mul x9, x14, x15 
	cmp x9, x13
	B.LE sumar1_color
	B sumar_color
sumar1_color:
	movz x13, 0x88, lsl 16
	movk x13, 0x0255, lsl 0 
	add x10, x10, x13
sumar_color:
	movz x13, 0x87, lsl 16
	movk x13, 0xb2a3, lsl 0 
	add x10, x10, x13	
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
	movk x13, 0x7595, lsl 0 
	sub x10, x10, x13
sumar_colorv:
	movz x13, 0x45, lsl 16
	movk x13, 0x7d85, lsl 0 
	add x10, x10, x13
	b mov_y
