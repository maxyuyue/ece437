# set the address where you want this
# code segment

main:
  org 0x0000
  addi $29, $0, 0xFFFC

  addi $2, $0, 2
  addi $3, $0, 3

  push $2
  push $3

  j multiply

continue:
  push $4     
  halt


  multiply:
    #load 2nd and then 1st operand into a register
    pop $3
    pop $2
    and $4, $4, $0

  loop:
    beq $3, $0, exit
    add $4, $4, $2
    addi $3, $3, -1
    j loop
  exit:
    j continue
