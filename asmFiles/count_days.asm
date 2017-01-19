#---------------------------------------
# sample asm file for tutorial
#---------------------------------------

# set the address where you want this
# code segment
  org 0x0000

  ori $29, $0, 0xFFFC
  ori $9,  $0, 0x0002   # Current Day
  ori $10, $0, 0x0002   # Current Month
  ori $11, $0, 0x07D2   # Current Year

  ori $2,  $0, 0x0002
  ori $3,  $0, 0x0003
  ori $4,  $0, 0x0004
  ori $5,  $0, 0x07D0   # 2000 (for year)
  ori $6,  $0, 0x016D   # 365 days
  ori $7,  $0, 0x001E   # 30 days
  ori $8,  $0, 0x0001   # 1 (for month)
  
  # Calculate days due to year
  subu $15,$11,$5   # yearDif = CurrentYear - 2000
  push $15
  push $6
  push $2
  jal mult_procedure
  pop $15           # $15 = days due to year

  # Calculate days due to month
  ori $2,  $0, 0x0002 # reset
  subu $16,$10,$8   # monthDif = CurrentMonth - 1
  push $16
  push $7
  push $2
  jal mult_procedure
  pop $16           # $16 = days due to month

  addu $17,$15,$16   # $17 = days due to month + days due to year
  addu $20,$17,$9    # 20 = totaly days
  push $20
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
