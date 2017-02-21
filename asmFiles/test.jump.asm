#--------------------------------------
# Test jump
#--------------------------------------
  org 0x0000
  ori   $1, $zero, 0x1234
  ori   $2, $zero, 0x5678
  ori   $3, $zero, 0xDCDC
  ori   $4, $zero, 0xDCDC
  ori   $5, $zero, 0xDCDC
  ori   $6, $zero, 0xDCDC
  ori   $7, $zero, 0xDCDC
  ori   $8, $zero, 0xDCDC

  jal loc
  or $9, $1, $2
  or $10, $3, $4
  or $13, $1, $2
  or $14, $3, $4

loc:
  add $11, $1, $2
  halt
