; Estudiante: Abraham Meza Vega	2018168174
; Profesor: Kirstein Gätjens
; Fundamentos de Organización de Computadores	Grupo 1
; Fecha de entrega: 1 de junio de 2018
; Tarea ASM	Traductor Japonés

datos segment

    acercaDe DB 0Ah,0Dh,"Creado por: Abraham Meza",0Ah,0Dh,"Traductor de numeros a japones",0Ah,0Dh,0Ah,0Dh,"$"   ; Mensaje de acerca de
    ayuda DB 0Ah,0Dh,"AYUDA:",0Ah,0Dh,0Ah,0Dh,"Comandos admitidos:",0Ah,0Dh,"-H -> Despliega esta ayuda",0Ah,0Dh,"-J # -> Traduce el numero a japones",0Ah,0Dh,"Los numeros deben ser decimales entre 0 y 9999",0Ah,0Dh,,0Ah,0Dh,"Ejemplo de uso:",0Ah,0Dh,"18168174 -H -> Muestra esta ayuda",0Ah,0Dh,"18168174 -J 123 -> Hyaku Ni Ju San",0Ah,0Dh,"$"	;Cadana con mensaje para la ayuda
    comando DB 8 dup (?)    ; Almacenará el comando ingresado
    exito DB 0Ah,0Dh,0Ah,0Dh,"Traduccion realizada con exito!",0Ah,0Dh,"$"
    opcError DB 0Ah,0Dh,"Error: El comando ingresado no fue reconocido.",0Ah,0Dh,"Ingrese -h para mostrar la ayuda.",0Ah,0Dh,"$" ; Mensaje de error para comando ingresado
    noArgumentos DB 0Ah,0Dh,"Error: No se paso un numero.",0Ah,0Dh,"$"  ; Mensaje de error cuando no se ingresan números
    tooLargo DB 0Ah,0Dh,"Error: Debe ingresar un numero entre 0 y 9999 despues del comando.",0Ah,0Dh,"Ingrese -h para mostrar la ayuda.",0Ah,0Dh,"$"  ; Mensaje de error cuando no se ingresan números
    noEsNumero DB 0Ah,0Dh,"Error: El argumentos ingresado presenta un valor no numerico",0Ah,0Dh,"$"

    ;Números en japonés
    japones0 DB "rei $"
    japones1 DB "ichi $"
    japones2 DB "ni $"
    japones3 DB "san $"
    japones4 DB "shi $"
    japones5 DB "go $"
    japones6 DB "roku $"
    japones7 DB "shichi $"
    japones8 DB "hachi $"
    japones9 DB "kyu $"
    japones10 DB "ju $"
    japones100 DB "hyaku $"
    japones1000 DB "sen $"

datos ends

                  
pila segment stack 'stack'

    dw 256 dup (?)

pila ends


codigo segment

    assume  cs:codigo, ds:datos, ss:pila
                                                                             
 inicio: mov ax, datos   ; protocolo de inicialización del programa.
         mov ds, ax
         mov ax, pila
         mov ss, ax

         ; Muestra el acercaDe antes de hacer cualquier cosa
         mov ah,09h
         lea dx, acercaDe
         int 21h

	     ; Recupera la entrada
    	 mov si, 80h
         mov cl, BYTE PTR es:[si]
         xor ch, ch

	     cmp cl,00h	; Verifica si la entrada es nula
	     jz  help 	; Si lo es para a mostrar la ayuda
         cmp cl,09  ; Verifica si la entrada es demasiado larga
         jge  largo ; Si lo es para a mostrar el error
         mov bl, cl ; Si el formato está bien guarda el largo del formato en el bl (porque no se le da otro uso al bl)

         ;Guarda la entrada
 guarda: xor di, di
 ciclo:  inc si
         mov al, BYTE PTR es:[si]
         mov BYTE PTR comando[di], al
         inc di
         loop ciclo
         mov di, 4 ; Mueve al di un 4 para usarlo como contardor

         ; Valida la entrada
         cmp BYTE PTR comando[01], '-'  ; Verifica que siga el formato de -Letra
         jnz salto                      ; Si no, sale
         cmp BYTE PTR comando[02], 'h'  ; Verifica si la letra ingresada sea una h
         jz  help                       ; Si lo es, muestra la ayuda
         cmp BYTE PTR comando[02], 'H'  ; Verifica si la letra ingresada sea una H
         jz  help                       ; Si lo es, muestra la ayuda
         cmp BYTE PTR comando[02], 'j'  ; Verifica si la letra ingresada sea una j
         jz japoUM                      ; Pasa a traducir a japonés
         cmp BYTE PTR comando[02], 'J'  ; Verifica si la letra ingresada sea una J
         jz japoUM                      ; Pasa a traducir a japonés
         jnz opInv                      ; Si no, sale

	     ; Muestra la ayuda
 help:	 mov ah,09h
         lea dx, ayuda
         int 21h
	     jmp final

         ; Muestra el error de comando no reconocido
opInv:   mov ah,09h
         lea dx, opcError
         int 21h
         jmp final

         ; Muestra el error de no hay argumentos
noArg:   mov ah,09h
         lea dx, noArgumentos
         int 21h
         jmp final

         ; Muestra el error de que el argumento es demasiado largo
largo:   mov ah,09h
         lea dx, tooLargo
         int 21h
         jmp final

         ; Muestra el error de que todo salió bien
exitoso: mov ah,09h
         lea dx, exito
         int 21h
         jmp final

         ; Muestra el error de que no es un número
noNum:	 mov ah,09h
         lea dx, noEsNumero
         int 21h
         jmp final

salto: 	 jmp final   ; Salto de conejo

japoUM: cmp BYTE PTR comando[di], 00h    ;Verifica que haya números
         jz noArg                         ;Si no, marca el error
         inc di 						  ;Incrementa el di
         cmp BYTE PTR comando[di], 00h    ;Verifica que no haya más caracteres
         jz salto14                        ;Si no los hay pasa a las unidades
         dec di 						  ;Decrementa el di
         cmp bl, 8						  ;Valida que haya por lo menos 4 números
         jl salto11						  ;Si no, pasa a las decenas
         cmp BYTE PTR comando[di], '0'    ;Verifica si entró un 0
         jz salto10                      ;Va a imprimir el 0
         cmp BYTE PTR comando[di], '1'    ;Verifica si entró un 1
         jz japo1000                      ;Va a imprimir el 1
         cmp BYTE PTR comando[di], '2'    ;Verifica si entró un 2
         jz japo2000                      ;Va a imprimir el 2
         cmp BYTE PTR comando[di], '3'    ;Verifica si entró un 3
         jz japo3000                      ;Va a imprimir el 3
         cmp BYTE PTR comando[di], '4'    ;Verifica si entró un 4
         jz japo4000                      ;Va a imprimir el 4
         cmp BYTE PTR comando[di], '5'    ;Verifica si entró un 5
         jz japo5000                      ;Va a imprimir el 5
         cmp BYTE PTR comando[di], '6'    ;Verifica si entró un 6
         jz japo6000                      ;Va a imprimir el 6
         cmp BYTE PTR comando[di], '7'    ;Verifica si entró un 7
         jz japo7000                      ;Va a imprimir el 7
         cmp BYTE PTR comando[di], '8'    ;Verifica si entró un 8
         jz japo8000                      ;Va a imprimir el 8
         cmp BYTE PTR comando[di], '9'    ;Verifica si entró un 9
         jz salto12        			      ;Va a imprimir el 9
         jmp noNum 						  ;Muesta el error de que no es un número

Salto10: inc di 	 ; Incrementa el di antes irse a las decenas
salto11: jmp japoC   ; Salto de conejo
salto12: jmp japo9000; Salto de conejo
salto14: jmp japoCD  ; Salto de conejo

japo1000:mov ah,09h
         lea dx, japones1000
         int 21h
         inc di
         jmp japoC

         ; Muestra el 20 en japonés
japo2000:mov ah,09h
         lea dx, japones2
         int 21h
         lea dx, japones1000
         int 21h
         inc di
         jmp japoC

         ; Muestra el 30 en japonés
japo3000:mov ah,09h
         lea dx, japones3
         int 21h
         lea dx, japones1000
         int 21h
         inc di
         jmp japoC

         ; Muestra el 40 en japonés
japo4000: mov ah,09h
          lea dx, japones4
          int 21h
          lea dx, japones1000
          int 21h
          inc di
          jmp japoC

         ; Muestra el 50 en japonés
japo5000:mov ah,09h
         lea dx, japones5
         int 21h
         lea dx, japones1000
         int 21h
         inc di
         jmp japoC

         ; Muestra el 60 en japonés
japo6000:mov ah,09h
         lea dx, japones6
         int 21h
         lea dx, japones1000
         int 21h
         inc di
         jmp japoC

         ; Muestra el 70 en japonés
japo7000:mov ah,09h
         lea dx, japones7
         int 21h
         lea dx, japones1000
         int 21h
         inc di
         jmp japoC

         ; Muestra el 80 en japonés
japo8000:mov ah,09h
         lea dx, japones8
         int 21h
         lea dx, japones1000
         int 21h
         inc di
         jmp japoC

         ; Muestra el 90 en japonés
japo9000:mov ah,09h
         lea dx, japones9
         int 21h
         lea dx, japones1000
         int 21h
         inc di
         jmp japoC

salto13: jmp noArg 	; Salto de conejo

japoCD:  dec di 						  ; decrementa el di
japoC:   inc di 						  ;Incrementa el di
         cmp BYTE PTR comando[di], 00h    ;Verifica que no haya más caracteres
         jz salto15                        ;Si no los hay pasa a las unidades
         dec di 						  ;Decrementa el di
         cmp bl, 7						  ;Valida que haya por lo menos 3 números
         jl salto7						  ;Si no, pasa a las decenas
         cmp BYTE PTR comando[di], '0'    ;Verifica si entró un 0
         jz salto9                        ;Va a imprimir el 0
         cmp BYTE PTR comando[di], '1'    ;Verifica si entró un 1
         jz japo100                       ;Va a imprimir el 1
         cmp BYTE PTR comando[di], '2'    ;Verifica si entró un 2
         jz japo200                       ;Va a imprimir el 2
         cmp BYTE PTR comando[di], '3'    ;Verifica si entró un 3
         jz japo300                       ;Va a imprimir el 3
         cmp BYTE PTR comando[di], '4'    ;Verifica si entró un 4
         jz japo400                       ;Va a imprimir el 4
         cmp BYTE PTR comando[di], '5'    ;Verifica si entró un 5
         jz japo500                       ;Va a imprimir el 5
         cmp BYTE PTR comando[di], '6'    ;Verifica si entró un 6
         jz japo600                       ;Va a imprimir el 6
         cmp BYTE PTR comando[di], '7'    ;Verifica si entró un 7
         jz japo700                       ;Va a imprimir el 7
         cmp BYTE PTR comando[di], '8'    ;Verifica si entró un 8
         jz salto16                        ;Va a imprimir el 8
         cmp BYTE PTR comando[di], '9'    ;Verifica si entró un 9
         jz salto8        				  ;Va a imprimir el 9
         jmp noNum 						  ;Muesta el error de que no es un número

salto4: jmp japoU   ; Salto de conejo
salto8: jmp japo900 ; Salto de conejo
Salto9: inc di 		; Incrementa el di antes irse a las decenas
salto7: jmp japoD   ; Salto de conejo
salto15:jmp japoDD	; Salto de conejo
salto16:jmp japo800	; Salto de conejo

japo100: mov ah,09h
         lea dx, japones100
         int 21h
         inc di
         jmp japoD

         ; Muestra el 20 en japonés
 japo200: mov ah,09h
         lea dx, japones2
         int 21h
         lea dx, japones100
         int 21h
         inc di
         jmp japoD

         ; Muestra el 30 en japonés
 japo300: mov ah,09h
         lea dx, japones3
         int 21h
         lea dx, japones100
         int 21h
         inc di
         jmp japoD

         ; Muestra el 40 en japonés
 japo400: mov ah,09h
          lea dx, japones4
          int 21h
          lea dx, japones100
          int 21h
          inc di
          jmp japoD

         ; Muestra el 50 en japonés
 japo500: mov ah,09h
         lea dx, japones5
         int 21h
         lea dx, japones100
         int 21h
         inc di
         jmp japoD

         ; Muestra el 60 en japonés
 japo600: mov ah,09h
         lea dx, japones6
         int 21h
         lea dx, japones100
         int 21h
         inc di
         jmp japoD

         ; Muestra el 70 en japonés
 japo700: mov ah,09h
         lea dx, japones7
         int 21h
         lea dx, japones100
         int 21h
         inc di
         jmp japoD

         ; Muestra el 80 en japonés
 japo800: mov ah,09h
         lea dx, japones8
         int 21h
         lea dx, japones100
         int 21h
         inc di
         jmp japoD

         ; Muestra el 90 en japonés
 japo900: mov ah,09h
         lea dx, japones9
         int 21h
         lea dx, japones100
         int 21h
         inc di
         jmp japoD

japoDD:  dec di 						  ;Decrementa el di
japoD:   inc di 						  ;Incrementa el di
         cmp BYTE PTR comando[di], 00h    ;Verifica que no haya más caracteres
         jz salto2                        ;Si no los hay pasa a las unidades
         dec di 						  ;Decrementa el di
         cmp BYTE PTR comando[di], '0'    ;Verifica si entró un 0
         jz salto5                        ;Va a imprimir el 0
         cmp BYTE PTR comando[di], '1'    ;Verifica si entró un 1
         jz japo10                        ;Va a imprimir el 10
         cmp BYTE PTR comando[di], '2'    ;Verifica si entró un 2
         jz japo20                        ;Va a imprimir el 20
         cmp BYTE PTR comando[di], '3'    ;Verifica si entró un 3
         jz japo30                        ;Va a imprimir el 30
         cmp BYTE PTR comando[di], '4'    ;Verifica si entró un 4
         jz japo40                        ;Va a imprimir el 40
         cmp BYTE PTR comando[di], '5'    ;Verifica si entró un 5
         jz japo50                        ;Va a imprimir el 50
         cmp BYTE PTR comando[di], '6'    ;Verifica si entró un 6
         jz japo60                        ;Va a imprimir el 60
         cmp BYTE PTR comando[di], '7'    ;Verifica si entró un 7
         jz japo70                        ;Va a imprimir el 70
         cmp BYTE PTR comando[di], '8'    ;Verifica si entró un 8
         jz japo80                        ;Va a imprimir el 80
         cmp BYTE PTR comando[di], '9'    ;Verifica si entró un 9
         jz salto6                        ;Va a imprimir el 90
         jmp noNum 						  ;Muesta el error de que no es un número

 salto2: jmp japoU   ; Salto de conejo
 salto5: inc di 	 ; Incrementa el di
 		 jmp japo 	 ; Salto de conejo
 salto6: jmp japo90  ; Salto de conejo

         ; Muestra el 10 en japonés
 japo10: mov ah,09h
         lea dx, japones10
         int 21h
         inc di
         jmp japo

         ; Muestra el 20 en japonés
 japo20: mov ah,09h
         lea dx, japones2
         int 21h
         lea dx, japones10
         int 21h
         inc di
         jmp japo

         ; Muestra el 30 en japonés
 japo30: mov ah,09h
         lea dx, japones3
         int 21h
         lea dx, japones10
         int 21h
         inc di
         jmp japo
         ; Muestra el 40 en japonés
 japo40: mov ah,09h
         lea dx, japones4
         int 21h
         lea dx, japones10
         int 21h
         inc di
         jmp japo

         ; Muestra el 50 en japonés
 japo50: mov ah,09h
         lea dx, japones5
         int 21h
         lea dx, japones10
         int 21h
         inc di
         jmp japo

         ; Muestra el 60 en japonés
 japo60: mov ah,09h
         lea dx, japones6
         int 21h
         lea dx, japones10
         int 21h
         inc di
         jmp japo

         ; Muestra el 70 en japonés
 japo70: mov ah,09h
         lea dx, japones7
         int 21h
         lea dx, japones10
         int 21h
         inc di
         jmp japo

         ; Muestra el 80 en japonés
 japo80: mov ah,09h
         lea dx, japones8
         int 21h
         lea dx, japones10
         int 21h
         inc di
         jmp japo

         ; Muestra el 90 en japonés
 japo90: mov ah,09h
         lea dx, japones9
         int 21h
         lea dx, japones10
         int 21h
         inc di
         jmp japo

salto3: jmp exitoso; Salto de conejo

japoU:   dec di 						  ;Si solo hay un dígito decrementa el di
japo:    cmp BYTE PTR comando[di], '0'    ;Verifica si entró un 0
         jz japo0                         ;Va a imprimir el 0
         cmp BYTE PTR comando[di], '1'    ;Verifica si entró un 1
         jz japo1                         ;Va a imprimir el 1
         cmp BYTE PTR comando[di], '2'    ;Verifica si entró un 2
         jz japo2                         ;Va a imprimir el 2
         cmp BYTE PTR comando[di], '3'    ;Verifica si entró un 3
         jz japo3                         ;Va a imprimir el 3
         cmp BYTE PTR comando[di], '4'    ;Verifica si entró un 4
         jz japo4                         ;Va a imprimir el 4
         cmp BYTE PTR comando[di], '5'    ;Verifica si entró un 5
         jz japo5                         ;Va a imprimir el 5
         cmp BYTE PTR comando[di], '6'    ;Verifica si entró un 6
         jz japo6                         ;Va a imprimir el 6
         cmp BYTE PTR comando[di], '7'    ;Verifica si entró un 7
         jz japo7                         ;Va a imprimir el 7
         cmp BYTE PTR comando[di], '8'    ;Verifica si entró un 8
         jz japo8                         ;Va a imprimir el 8
         cmp BYTE PTR comando[di], '9'    ;Verifica si entró un 9
         jz japo9                         ;Va a imprimir el 9
         jmp noNum 						  ;Muesta el error de que no es un número

         ; Muestra el 0 en japonés
 japo0:  dec di
 		 cmp BYTE PTR comando[di], '0'    ;Verifica si entró un 0
 		 jnz japoX0
 		 cmp di, 4
 		 jnz japo0
 		 cmp di, 5	;Si el di es mayor o igual a 5 significa que este 0 no hace falta ponerlo
 japoX0: jge salto3 ;Por lo que sale
 japo00: mov ah,09h
         lea dx, japones0
         int 21h
         jmp exitoso

         ; Muestra el 1 en japonés
 japo1:  mov ah,09h
         lea dx, japones1
         int 21h
         jmp exitoso

         ; Muestra el 2 en japonés
 japo2:  mov ah,09h
         lea dx, japones2
         int 21h
         jmp exitoso

         ; Muestra el 3 en japonés
 japo3:  mov ah,09h
         lea dx, japones3
         int 21h
         jmp exitoso
         ; Muestra el 4 en japonés
 japo4:  mov ah,09h
         lea dx, japones4
         int 21h
         jmp exitoso

         ; Muestra el 5 en japonés
 japo5:  mov ah,09h
         lea dx, japones5
         int 21h
         jmp exitoso

         ; Muestra el 6 en japonés
 japo6:  mov ah,09h
         lea dx, japones6
         int 21h
         jmp exitoso

         ; Muestra el 7 en japonés
 japo7:  mov ah,09h
         lea dx, japones7
         int 21h
         jmp exitoso

         ; Muestra el 8 en japonés
 japo8:  mov ah,09h
         lea dx, japones8
         int 21h
         jmp exitoso

         ; Muestra el 9 en japonés
 japo9:  mov ah,09h
         lea dx, japones9
         int 21h
         jmp exitoso

 final:	 mov ax, 4C00h    ; protocolo de finalización del programa.
         int 21h
     
codigo ends

end inicio