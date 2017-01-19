#---------------------------------------
# sample asm file for tutorial
#---------------------------------------

# set the address where you want this
# code segment
  org 0x0000

  ori $29, $0, 0xFFFC
  ori $1,  $0, 0x0002	# Value a
  ori $2,  $0, 0x0003	# Value b
  push $1
  push $2
  jal mult
  pop $20				# Stores result for easy viewing 
  halt

mult:
  pop $1 			# Value a
  pop $2 			# Value b
  ori $3, $0,0x0	# Ensures $3 is initially 0 (will be result register)
  ori $4, $0,0x1	# Ensures $4 is initially 1 (will be used to increment)
  beq $2, $0, done  # if b = 0 then done
  j addAgain


addAgain:
  addu $3,$1,$3		# x = a + x
  subu $2,$2,$4		# b = b - 1
  beq $2, $0, done  # if b = 0 then done
  j addAgain

done:
  push $3
  jr $31


