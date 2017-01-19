#---------------------------------------
# sample asm file for tutorial
#---------------------------------------

# set the address where you want this
# code segment
  org 0x0000

  ori $29, $0, 0xFFFC
  ori $1,  $0, 0x0002 # Operand 1
  ori $2,  $0, 0x0002 # Operand 2
  ori $3,  $0, 0x0003 # Operand 3
  ori $4,  $0, 0x0003 # Number of operands used
  push $1
  push $2
  push $3
  push $4   # Number of operands
  jal mult_procedure
  pop $20   # Result for easy viewing
  halt

mult_procedure:
  # Initial setup
  ori $4, $0,0x1  # Ensures $4 is  1 (will be used to increment)
  pop $5          # Number of operands
  subu $5,$5,$4   # operandNums = operandNums - 1
  j getValues     # Get first 2 values off of stack

getValues:
  ori $3, $0,0x0  # Ensures $3 is initially 0 (will be result register)
  pop $1      # Value a
  pop $2      # Value b
  beq $2, $0, zero  # if b = 0 then done
  j addAgain


addAgain:
  addu $3,$1,$3   # x = a + x
  subu $2,$2,$4   # b = b - 1
  beq $2, $0, done  # if b = 0 then done
  j addAgain

done:
  push $3
  subu $5,$5,$4   # operandNums = operandNums - 1
  beq $5, $0, actuallyDone
  j getValues 

actuallyDone:
  jr $31


zero:
  push $2 # answer is 0. Push to stack
  j actuallyDone
