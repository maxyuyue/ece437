
  #------------------------------------------------------------------
  # Test lw sw
  #------------------------------------------------------------------

  org   0x0000
  ori   $1, $zero, 0xF0
  nop
  nop
  nop
  nop
  ori   $2, $zero, 0x100
  ori   $3, $zero, 0x200
  ori   $4, $zero, 0x300
  ori   $5, $zero, 0x400
  lw    $6, 0($1)
  nop
  nop
  nop
  nop
  lw    $7, 4($1)
  nop
  nop
  nop
  nop
  lw    $8, 8($1)
  nop
  nop
  nop
  nop
  ori   $4, $zero, 0x500
  nop
  nop
  nop
  nop
  ori   $5, $zero, 0x600
  nop
  nop
  nop
  nop
  sw    $6, 0($2)
  nop
  nop
  nop
  nop
  sw    $7, 4($2)
  nop
  nop
  nop
  nop
  sw    $8, 8($2)
  nop
  nop
  nop
  nop
  halt      # that's all

  org   0x00F0
  cfw   0x7337
  cfw   0x2701
  cfw   0x1337
