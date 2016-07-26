# fact.s
# Programa que factoriza un numero natural
#
# Planificacion de registros
##########################################
#										 #
# $t0 Dividendo							 #
# $t1 Divisor							 #
# $t2 Posicion							 #
# $t3 Resto								 #
# $t4 Temporal							 #
# $t5 Contador							 #
# $t6 Sub-indice						 #
# $t7 Auxiliar							 #
#										 #
##########################################
	
	.data
	
	arreglo:	.space 1000
	cadena1:	.asciiz "Introduzca numero "
	cadena2:	.asciiz "La factorizacion es "
	cadena3:	.asciiz "^"
	cadena4:	.asciiz "*"
	cadena5:	.asciiz "\n\n"
	cadena6:	.asciiz "Programa Finalizado"
	cadena7:	.asciiz "El numero introducido no es factorizable"
	
	.text
	
	main:	la $v0, 4
			la $a0, cadena1
			syscall
			li $v0, 5
			syscall
			move $t0, $v0
			beq $t0, 1, excepciones
			bltz $t0, excepciones
			beqz $t0, fin_programa					# Salir del programa si no se recibe ningun natural
			li $t1, 2
			li $t2, 0	
			
	loop:	div $t0, $t1							# Divide el natural introducido por 2 (y asi sucesivamente)
			mfhi $t3								# ($t3) <- resto
			beqz $t3, resto_z						# Salto de linea si el resto ($t3) es igual a cero
			bnez $t3, resto_nz						# Salto de linea si el resto ($t3) es distinto a cero
			
	resto_z: 	sw $t1, arreglo + 0($t2)			# Carga el primer elemento del arreglo en ($t1)
				addi $t2, $t2, 4
				mflo $t0							# ($t0) <- cociente
				bge $t0, $t1, loop					# Salto de linea si ($t0) es mayor igual ($t1)
				bgt $t1, $t0, mostrar_mensaje		# Salto de linea si ($t0) es mayor ($t1)
	
	resto_nz:	addi $t1, $t1, 1
				bge $t0, $t1, loop
				bgt $t1, $t0, mostrar_mensaje
	
	mostrar_mensaje:	li $t6, 0
						li $t5, 1
						addi $t2, $t2, -4
						li $v0, 4
						la $a0, cadena2
						syscall
						lw $v0, arreglo + 0($t6)	# Carga el primer elemento del arreglo en ($v0)
						move $t4, $v0				# ($t4) <- ($v0)
						li $t6, 4
						lw $v0, arreglo + 0($t6)	# Carga el elemento [k+1] del arreglo en ($v0)
						move $t7, $v0				# ($t7) <- ($v0)
						li $t6, 0
						blt $t6, $t2, imprimir		# Salto de linea si ($t6) es menor ($t2)
						b resultado_final
						
	imprimir:	beq $t4, $t7, imprimir_e			# Salta de linea si ($t4) es igual a ($t7)
				bne $t4, $t7, imprimir_ne			# Salta de linea si ($t4) es diferente a ($t7)
			
	imprimir_e:		addi $t5, $t5, 1 
					addi $t6, $t6, 8 
					lw $v0, arreglo + 0($t6)
					move $t7, $v0
					addi $t6, $t6, -4
					blt $t6, $t2, imprimir
					b resultado_final

	imprimir_ne:	li $v0, 1
					move $a0, $t4
					syscall							# Llama al sistema para imprimir la base
					li $v0, 4
					la $a0, cadena3
					syscall
					li $v0, 1
					move $a0, $t5					
					syscall							# Llama al sistema para imprimir el exponente
					li $v0, 4
					la $a0, cadena4
					syscall
					li $t5, 1
					addi $t6, $t6, 4
					lw $v0, arreglo + 0($t6)
					move $t4, $v0
					addi $t6, $t6, 4
					lw $v0, arreglo + 0($t6)
					move $t7, $v0
					addi $t6, $t6, -4
					blt $t6, $t2, imprimir
					b resultado_final				# Salta de linea
		
	resultado_final:	li $v0, 1
						move $a0, $t4
						syscall						# Llama al sistema para imprimir la ultima base
						li $v0,4
						la $a0, cadena3
						syscall
						li $v0, 1
						move $a0, $t5
						syscall						# Llama al sistema para imprimir el ultimo exponente
						li $v0, 4
						la $a0, cadena5
						syscall
						b main						# Salta linea para el inicio del programa
						
	excepciones:	li $v0, 4
					la $a0, cadena7
					syscall
					li $v0, 4
					la $a0, cadena5
					syscall
					b main
	
	fin_programa:	li $v0, 4
					la $a0, cadena6
					syscall
					li $v0, 10						# Llama al systema para finalizar
					syscall