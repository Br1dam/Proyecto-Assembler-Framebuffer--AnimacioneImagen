
NO_SIGNAL:
	sub sp, sp, #8 // Guardo el puntero de retorno en el stack
    stur lr, [sp]

	mov x19, 200
loop_signal:
// COLUMNA BLANCO
	movz x10, 0xFF,lsl 16  
	movk x10, 0xFFFF, lsl 00
	
	mov x1, 80 // ancho de cada columna, SCREEN_WIDTH/cant de columnas
	mov x2, SCREEN_HEIGH
	mov x3, 0	// pos.columna
	mov x4, 0	// pos.fila

	BL Pixeldir
	BL dibujarcuadrado
// COLUMNA AMARILLO
	movz x10, 0xf9,lsl 16  
	movk x10, 0xFb00, lsl 00
	
	add x3, x3, 80  // pos.columna

	BL Pixeldir
	BL dibujarcuadrado

// COLUMNA verde-azul
	movz x10, 0x02,lsl 16  
	movk x10, 0xfeff, lsl 00
	
	add x3, x3, 80	// pos.columna

	BL Pixeldir
	BL dibujarcuadrado

// COLUMNA verde
	movz x10, 0x01,lsl 16  
	movk x10, 0xff00, lsl 00
	
	add x3, x3, 80	// pos.columna

	BL Pixeldir
	BL dibujarcuadrado

// COLUMNA violeta
	movz x10, 0xfd,lsl 16  
	movk x10, 0x00fb, lsl 00
	
	add x3, x3, 80	// pos.columna

	BL Pixeldir
	BL dibujarcuadrado

// COLUMNA violeta
	movz x10, 0xfb,lsl 16  
	movk x10, 0x0102, lsl 00
	
	add x3, x3, 80	// pos.columna

	BL Pixeldir
	BL dibujarcuadrado

// COLUMNA azul
	movz x10, 0x03,lsl 16  
	movk x10, 0x01fc, lsl 00
	
	add x3, x3, 80	// pos.columna

	BL Pixeldir
	BL dibujarcuadrado

// COLUMNA negro
	movz x10, 0x00,lsl 16  
	movk x10, 0x0000, lsl 00
	
	add x3, x3, 80	// pos.columna

	BL Pixeldir
	BL dibujarcuadrado

	sub x19, x19, 1
	cmp x19, 0
	B.GT loop_signal

	mov x19, limite
	ldur lr, [sp] // Recupero el puntero de retorno del stack
    add sp, sp, #8 

    br lr

ret