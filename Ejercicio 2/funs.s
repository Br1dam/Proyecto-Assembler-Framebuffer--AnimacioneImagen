.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480
.equ BITS_PER_PIXEL,  	32
.equ blanco, 0xFFFFFF
.equ negro, 0x000000

/*
Funciones aqui:
	- Pixeldir
	-Delay
	- dibujarcuadrado
	- dibujarCirculo
	- NO_SIGNAL
	- linea_estatica
	- dibujar_triangulo
	- dibujarcursor-
	- dibujarreloj
	-dibujarescritorio
	-dibujarfondo
	-dibujartriangulo(Parte 1 y parte 2)
*/

Pixeldir:
	mov x0, 640			
	mul x0, x0, x4						
	add x0, x0, x3						
	lsl x0, x0, 2						 
	add x0, x0, x20
 ret	
 
 DELAY:
	movz x9, 0xff,lsl 16 
	movk x9, 0xffff, lsl 00
	loop:
	subs x9, x9, 3
	b.GT loop
ret
 
 dibujarcuadrado:  
 //x3= x, x4 = y, x1/x9=Ancho, x2/x8=Alto  w10 = color
 
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
	
 ret
 


  dibujarCirculo:
/*
	parametros:
				centro = (x3, x4);  x3 es la columna, x4 la fila
				radio = x1
				w10 = color
						
	comportamiento:
				x0 empieza en esquina superior izquierdo del cuadrado que contiene el circulo
				y va recorriendo el cuadrado y si se cumple que x0 esta dentro del circulo dado por
					(x0.fila - x3)*2 + (x0.columna - x4)2 <= x1*2
					\------x9-----/     \------x11-----/   \--x12--/
					   \-------------x13-------------/							 
				se pinta el pixel
*/              
		
		sub sp, sp, #8 // Guardo el puntero de retorno en el stack
      		stur lr, [sp]
      		
		mov x26, x15
		
		add x5, x4,x1		// con x5 me fijo si llego a final de Y
		add x6, x3,x1		// con x6 me fijo si llega al final de X
					          
		
		mov x15, x3
		mov x16, x4
		sub x3, x3, x1      // Inicio X		
		
resetY:
		cmp x3, x6
		b.gt end
		sub x4, x5, x1
		sub x4, x4, x1      // Inicio Y
cirloop:
		cmp x4,x5
		b.eq next_fila

		sub x9, x3, x15			   
		mul x9, x9, x9				// x9 = (x0.fila - x3)**2 	
		
		sub x11, x4, x16			   
		mul x11, x11, x11			// x11 = (x0.columna - x4)**2

		add x13, x9, x11			// x13 = (x0.fila - x1)*2 + (x0.columna - x2)*2

		mov x12, x1
		mul x12, x12, x12			// x12 = radio**2

		cmp x12, x13
		B.GE color					//si x13 <= x12 
		B skip
color:		
		BL Pixeldir				// then pintar pixel
		stur w10,[x0]	
skip:
		add x4, x4, #1				// avanza pixel
		B cirloop
next_fila:
		add x3, x3, #1
		B resetY
end:	
	mov x15, x26
        ldur lr, [sp] // Recupero el puntero de retorno del stack
        add sp, sp, #8 

        br lr
		
	ret
 




dibujarfondo:  //x3= x x4 = y x1/x9=Ancho x2/x8=Alto  w10 = color //Misma logica que dibujar cuadrado, pero cada 4 pixeles cambio de color
 
 	sub sp, sp, #8 // Guardo el puntero de retorno en el stack
      	stur lr, [sp]
 	
 	
 	add x17, x10, 1800
 	mov x12, x0
 	mov x8, x2
 	loopaf:
     	 mov x9, x1
     	 mov x7, x12
     	 
     	setx25:
     	mov x25, 4
     	 
     	colorearf:
     	  	
	  stur w10,[x12]	   
	  add x12,x12,4	   
	  sub x9,x9,1	
	  sub x25, x25, 1  
	  cbz x9,filaterminada
	  cbz x25, setx21
	  B colorearf
	  
	filaterminada:
	  mov x12, x7  
	  sub x8, x8, 1
	  add x12, x12,2560
	  cbnz x8,loopaf
	  B fin
	  
	setx21:
     	mov x21, 4 
     	
	colorearfsigpix:
	  stur w17,[x12]	   
	  add x12,x12,4	   
	  sub x9,x9,1	  
	  sub x21, x21, 1  
	  cbz x9,filaterminada
	  cbz x21,setx25
	  B colorearfsigpix
	fin: 
	ldur lr, [sp] // Recupero el puntero de retorno del stack
        add sp, sp, #8
        br lr




  dibujarescritorio:      
  
 	sub sp, sp, #8 // Guardo el puntero de retorno en el stack
      	stur lr, [sp]
      	
        movz x10, 0x3B,lsl 16 
 	movk x10, 0x3B90, lsl 00
	mov x1, SCREEN_WIDTH
	mov x2, 450
	mov x3, 0	// pos.columna
	mov x4, 0	// pos.fila
	BL Pixeldir
	BL dibujarcuadrado
	
	//BARRA DE TAREAS
	mov x4, 450
	mov x2, 30
	movz x10, 0xC5,lsl 16  // Color de fondo : Negro
	movk x10, 0xC5D5, lsl 00
	BL Pixeldir
	BL dibujarcuadrado
	
	//LOGO WINDOWS
	
	movz x10, 0x00,lsl 16  // Azul
	movk x10, 0x5CB2, lsl 00
	mov x4, 465
	mov x3, 15
	mov x1, 14
	BL Pixeldir
	BL dibujarCirculo
	
	
		movz x10, 0xFF,lsl 16  // Amarillo
		movk x10, 0xFF00, lsl 00
		sub x4, x4, 13
		sub x3, x3, 14
		mov x1, 8
		mov x2, 8
		BL Pixeldir
		BL dibujarcuadrado
		
		
		sub x3, x3, 9
		movz x10, 0x00,lsl 16  // Celeste
		movk x10, 0x82DF, lsl 00
		BL Pixeldir
		BL dibujarcuadrado
		

		sub x4, x4, 9
		movz x10, 0xFF,lsl 16  // Naranja
		movk x10, 0x8200, lsl 00
		BL Pixeldir
		BL dibujarcuadrado
		

		add x3, x3, 9
		movz x10, 0x00,lsl 16  // Verde
		movk x10, 0xDB00, lsl 00
		BL Pixeldir
		BL dibujarcuadrado
		
		
	//CARPETAS
	
	mov x3, 20 
	mov x4, 140
	mov x1, 35
	mov x2, 30
	
	sub x4, x4, 50
	
	movz x10, 0xA8,lsl 16  // Marron
	movk x10, 0x8000, lsl 00
	
	Bl Pixeldir
	Bl dibujarcuadrado
	
	sub x4, x4, 4
	mov x1, 15
	mov x2, 7
	
	Bl Pixeldir
	Bl dibujarcuadrado
	
	
	sub x4, x4, 60
	
	mov x1, 35
	mov x2, 30
	
	Bl Pixeldir
	bl dibujarcuadrado
	
	sub x4, x4, 4
	mov x1, 15
	mov x2, 7
	
	Bl Pixeldir
	Bl dibujarcuadrado
	
   	ldur lr, [sp] // Recupero el puntero de retorno del stack
        add sp, sp, #8
        br lr     
 
	
	
	


 
dibujarlineadiagonal:  //Utiliza la misma logica que la funcion dibujarcuadrado
 
 	sub sp, sp, #8 // Guardo el puntero de retorno en el stack
      	stur lr, [sp]
 
 	mov x12, x0
 	mov x8, x2
 	loopal:
     	 mov x9, x1
     	 mov x7, x12
     	 
     	colorearl:	
	  stur w10,[x12]	   
	  add x12,x12,4	   
	  sub x9,x9,1	  
	  cbnz x9,colorearl
	  mov x12, x7  
	  sub x8, x8, 1
	  add x12, x12,2564
	  cbnz x8,loopal
	  
	ldur lr, [sp] // Recupero el puntero de retorno del stack
        add sp, sp, #8
        br lr

dibujarcursor: // Dibujo un triangulo rectangulo y luego una linea diagonal

	sub sp, sp, #8 // Guardo el puntero de retorno en el stack
      	stur lr, [sp]
      	
 	mov x1, 11
	mov x2, 11
 	mov x12, x0
 	mov x8, x2
 	mov x5, 1
 	loopatr:
     	 mov x9, x5
     	 mov x7, x12
     	 
     	coloreartr:	
	  stur w10,[x12]	   
	  add x12,x12,4	   
	  sub x9,x9,1	  
	  cbnz x9,coloreartr
	  mov x12, x7  
	  sub x8, x8, 1
	  add x12, x12,2560
	  add x5, x5, 1
	  cbnz x8,loopatr
	  
	mov x0 ,x12
	add x0, x0, 16
	mov x1, 3
	mov x2, 4
	bl dibujarlineadiagonal
	
	  ldur lr, [sp] // Recupero el puntero de retorno del stack
          add sp, sp, #8
          br lr

                 
 dibujartriangulo: //Solo le doy la altura como parametro inicial, parte de un pixel y va aumentando el largo de las filas siguientes hasta completar la altura
 
 	sub sp, sp, #8 // Guardo el puntero de retorno en el stack
      	stur lr, [sp]

 
 	
 	mov x8, x2
 	mov x5, 1
 	loopat:
     	 mov x9, x5
     	 mov x11, x0
     	 
     	coloreart:	
	  stur w10,[x0]	   
	  add x0,x0,4	   
	  sub x9,x9,1	  
	  cbnz x9,coloreart
	  mov x0, x11   
	  sub x8, x8, 1
	  sub x0, x0, 2564
	  add x5, x5, 2
	  cbnz x8,loopat
	
 	ldur lr, [sp] // Recupero el puntero de retorno del stack
        add sp, sp, #8 

        br lr
 
 dibujartrianguloparte2: 
 
 	sub sp, sp, #8 // Guardo el puntero de retorno en el stack
      	stur lr, [sp]

 
 	
 	mov x8, x2
 	mov x7, 1
 	loopat2:
     	 mov x9, x7
     	 mov x11, x0
     	 
     	coloreart2:	
	  stur w10,[x0]	   
	  add x0,x0,4	   
	  sub x9,x9,1	  
	  cbnz x9,coloreart2
	  mov x0, x11   
	  sub x8, x8, 1
	  add x0, x0, 2556
	  add x7, x7, 2
	  cbnz x8,loopat2
	
 	ldur lr, [sp] // Recupero el puntero de retorno del stack
        add sp, sp, #8 

        br lr
        
        
dibujarreloj:
	
	sub sp, sp, #8 // Guardo el puntero de retorno en el stack
      	stur lr, [sp]
	
	//reloj
	mov x12, x0
	bl dibujartriangulo
	mov x0, x12
	bl dibujartrianguloparte2
	
	//Arena dentro del reloj
	mov x1, 1
	mov x2, 1
	mov x0, x12
	mov x10, negro
	add x4, x4, 2
	bl Pixeldir
	bl dibujarcuadrado
	add x4,x4, 2
	bl Pixeldir
	bl dibujarcuadrado
	sub x4, x4, 6
	add x3,x3, 1
	bl Pixeldir
	bl dibujarcuadrado
	sub x3,x3, 2
	bl Pixeldir
	bl dibujarcuadrado
	add x3, x3, 1
	add x4, x4, 1
	bl Pixeldir
	bl dibujarcuadrado
	
	
	ldur lr, [sp] // Recupero el puntero de retorno del stack
        add sp, sp, #8 
        br lr
