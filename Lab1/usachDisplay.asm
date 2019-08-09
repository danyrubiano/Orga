.data

# El display parte en la direccion de memoria 0x100100000 que es el primer segmento de dato que se encuetra
# en el area .data
# Por eso "display" debe ir antes que todos los demas datos
display: .word 0:131072




.text


la $a0, romboLinea  # la direccion del rombo
la $a1, display     # la direcion del display
   
jal MOSTRAR2        # llamamos a mostrar



# $a0 direccion del array
# $a1 direcion de inicio del display
MOSTRAR2:
add $t6, $a0, $zero		# t6 direccion del array
add $t7, $a1, $zero		# t7 direccion del display
addi $t5, $zero, 0		# columna actual

WHILE_COLUMNA2:                     # mientras mostremos una columna
lw $t1, 0($t6)                     # cargamos la palabra de la direccion dem meoria del array
beq $t1, 0x01000000, SALTAR_FILA2            # si nos encontramos con un cero hay que saltar a la siguiente fila
sw $t1, 0($t7)                     # si no nos saltamos la fila, entonces copiamos el valor al display
addi $t6, $t6, 4                   # nos movemos una palabra en el array
addi $t7, $t7, 4                   # nos movemos una palabra en el display
j WHILE_COLUMNA2

SALTAR_FILA2:                        # Nos vamos a saltar una fila, pero debemos revisar si no hemos terminado (dos ceros seguidos)
addi $t6, $t6, 4                    # Nos movemos al siguiente elemento del array
lw $t1, 0($t6)                      # cargamos el siguiente elemento del array
beq $t1, 0x01000000, FIN_MOSTRAR2             # ¿Hay un cero?, entonces encontramos dos ceros seguidos y terminamos

addi $t5, $t5, 1                    # ¿no encontramos un cero?, entonces nos movemos a la siguiente columa

mul $t1, $t5, 2048                  # la direccion de la siguiente columna es: NUMERO_COLUMNA * 2048), 2048 ya que es un array de words: 4*512

add $t7, $a1, $t1                   # la nueva direccion del display es: NUMERO_COLUMNA * 2048 + Display => offset + display
j WHILE_COLUMNA2                     # mostramos la siguiente columa

FIN_MOSTRAR2:                        # Encontramos los dos ceros seguidos asi que terminamos
jr $ra                              # retornamos



FIN: