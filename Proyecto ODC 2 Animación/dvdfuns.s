.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480
.equ BITS_PER_PIXEL,  	32
.equ ancho,				100
.equ alto,				80
.equ pared_derecha, 	540 // SCREEN_WIDTH - ancho
.equ piso, 				400 // SCREEN_HEIGH - alto


 Pixeldir:
	mov x0, 640			
	mul x0, x0, x4						
	add x0, x0, x3						
	lsl x0, x0, 2						 
	add x0, x0, x20
 ret	
 
 
 Pixeldir2:
	mov x0, 640			
	mul x0, x0, x8						
	add x0, x0, x7						
	lsl x0, x0, 2						 
	add x0, x0, x20
 ret
 
 
 dibujartriangulo: 
 
 	sub sp, sp, #8 // Guardo el puntero de retorno en el stack
      	stur lr, [sp]

 
 	mov x12, x0
 	mov x8, x2
 	mov x5, 1
 	loopat:
     	 mov x9, x5
     	 mov x11, x12
     	 
     	coloreart:	
	  stur w25,[x12]	   
	  add x12,x12,4	   
	  sub x9,x9,1	  
	  cbnz x9,coloreart
	  mov x12, x11   
	  sub x8, x8, 1
	  sub x12, x12,2564
	  add x5, x5, 2
	  cbnz x8,loopat
	
 	ldur lr, [sp] // Recupero el puntero de retorno del stack
        add sp, sp, #8 

        br lr
 
 
 
 
 
 dibujarcuadrado:  //x3= x x4 = y x1/x9=Ancho x2/x8=Alto  w10 = color
 
 	sub sp, sp, #8 // Guardo el puntero de retorno en el stack
      	stur lr, [sp]
 
 	mov x12, x0
 	mov x8, x2
 	loopa:
     	 mov x9, x1
     	 mov x7, x12
     	 
     	colorear:	
	  stur w10,[x12]	   
	  add x12,x12,4	   
	  sub x9,x9,1	  
	  cbnz x9,colorear
	  mov x12, x7  
	  sub x8, x8, 1
	  add x12, x12,2560
	  cbnz x8,loopa
	  
	ldur lr, [sp] // Recupero el puntero de retorno del stack
        add sp, sp, #8
        br lr
        
 

	
	 
 DELAY:
 	sub sp, sp, #8 // Guardo el puntero de retorno en el stack
      	stur lr, [sp]
	movz x9, 0xff,lsl 16 
	movk x9, 0xffff, lsl 00
	loop:
	subs x9, x9, 1
	b.ne loop
	ldur lr, [sp] // Recupero el puntero de retorno del stack
        add sp, sp, #8
        br lr


 	

dibujarfondo:    w10 = color
 
 	sub sp, sp, #8 // Guardo el puntero de retorno en el stack
      	stur lr, [sp]
      	movz x10, 0x00,lsl 16  // Color de fondo 
	movk x10, 0x00ff, lsl 00
	mov x3, 0	// pos.columna
	mov x4, 0	// pos.fila
	BL Pixeldir
 	mov x1, 640
 	mov x2, 60
 	mov x18, 480
 	loopd:
 	BL dibujarcuadrado
	mov x2, 60
        add x4, x4, 60
        BL Pixeldir
        sub x10, x10, 30
        cmp x4, x18
        B.NE loopd
        
       
        
        ldur lr, [sp] // Recupero el puntero de retorno del stack
        add sp, sp, #8
        br lr
       

cuadrado:
	sub sp, sp, #8 // Guardo el puntero de retorno en el stack
      	stur lr, [sp]
        mov x1, ancho
	mov x2, alto
    	mov x3, x5	// pos.columna (x)
	cmp x3, pared_derecha //  pos.x == pared derecha
	B.GE rebote_horizontal1
	cmp x3, 0
	B.LE rebote_horizontal1
 
        mov_x:
        
	add x3, x3, x14
	mov x4, x6	// pos.fila (y)
	cmp x4, piso  // pos.y == piso
	B.GE rebote_vertical1
	cmp x4, 0
	B.LE rebote_vertical1	
	
	mov_y:
	add x4, x4, x15
	mov x10, x11
	BL Pixeldir
	BL dibujarcuadrado
	mov x5, x3
	mov x6, x4
	B ending
	
	
	rebote_horizontal1:
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

	rebote_vertical1:
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
	
	 ending:	
		 ldur lr, [sp] // Recupero el puntero de retorno del stack
      		  add sp, sp, #8
      		  br lr
	
			

