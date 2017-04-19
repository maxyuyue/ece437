# Multicore coherence test
# stores 0xDEADBEEF to value
# $t0 = r8  $t1 = r9  $t2 = r10   $t3 = r11  $t4 = r12
# 0x0000400 = 0b
# 0x0000408 = 0b0100 0000 1000
  # query.idx = 0b001
# 0x0000414 = 0b0100 0001 0100
  # query.idx 0 0b010

#core 1
org 0x0000
  ori $8, $0, word1           #r8  = 0x0000040C
  lw  $9, 0($8)               #r9  = 0x0000DEAD
  sll $9, $9, 16              #r9  = 0xDEAD0000
  ori $12, $0, value          #r12 = 0x00000408
  ori $10, $0, flag           #r10 = 0x00000400

# wait for core 2 to finish
wait1:
  lw  $11, 0($10)             #r11 = 0x00000001 (after core 2 sets it)
  beq $11, $0, wait1

# complete store
  lw  $8, 0($12)              #r8  = 0x0000BEEF
  or  $8, $8, $9              #r8  = 0xDEADBEEF
  sw  $8, 0($12)              

  halt

# core 2
org 0x0200
  ori $8, $0, word2           #r8  = 0x00000414
  lw  $9, 0($8)               #r9  = 0x0000BEEF
  ori $10, $0, value          #r10 = 0x00000408
  sw  $9, 0($10)

# set flag
  ori $9, $0, flag            #r9  = 0x00000400
  ori $10, $0, 1              #r10 = 0x00000001

  sw  $10, 0($9)
  halt

org 0x0400
flag:
  cfw 0   #will eventually be 0x00000001 by core 2

org 0x0408
value:
  cfw 0   #will eventually be 0x0000BEEF by core 2 then 0xDEADBEEF by core 1

word1:
  cfw 0x0000DEAD
  cfw 0
word2:
  cfw 0x0000BEEF

