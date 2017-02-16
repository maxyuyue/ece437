onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider dp
add wave -noupdate /system_tb/DUT/CPU/DP/CLK
add wave -noupdate /system_tb/DUT/CPU/dcif/halt
add wave -noupdate /system_tb/DUT/CPU/dcif/ihit
add wave -noupdate /system_tb/DUT/CPU/dcif/imemREN
add wave -noupdate /system_tb/DUT/CPU/DP/opCif
add wave -noupdate /system_tb/DUT/CPU/DP/func
add wave -noupdate -radix hexadecimal /system_tb/DUT/CPU/dcif/imemload
add wave -noupdate /system_tb/DUT/CPU/dcif/imemaddr
add wave -noupdate /system_tb/DUT/CPU/dcif/dhit
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemREN
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemWEN
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemload
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemstore
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemaddr
add wave -noupdate -divider ifidValue
add wave -noupdate /system_tb/DUT/CPU/DP/opCid
add wave -noupdate /system_tb/DUT/CPU/DP/funcid
add wave -noupdate /system_tb/DUT/CPU/DP/ifid/enable
add wave -noupdate /system_tb/DUT/CPU/DP/ifid/flush
add wave -noupdate /system_tb/DUT/CPU/DP/ifidValue/instr
add wave -noupdate /system_tb/DUT/CPU/DP/ifidValue/pc
add wave -noupdate -divider idexValue
add wave -noupdate /system_tb/DUT/CPU/DP/opCex
add wave -noupdate /system_tb/DUT/CPU/DP/funcex
add wave -noupdate /system_tb/DUT/CPU/DP/idexValue/instr
add wave -noupdate /system_tb/DUT/CPU/DP/idexValue/WEN
add wave -noupdate /system_tb/DUT/CPU/DP/idexValue/pc
add wave -noupdate -divider exmemValue
add wave -noupdate /system_tb/DUT/CPU/DP/opCmem
add wave -noupdate /system_tb/DUT/CPU/DP/funcmem
add wave -noupdate /system_tb/DUT/CPU/DP/exmem/enable
add wave -noupdate /system_tb/DUT/CPU/DP/exmemValue/instr
add wave -noupdate /system_tb/DUT/CPU/DP/exmemValue/WEN
add wave -noupdate /system_tb/DUT/CPU/DP/exmemValue/pc
add wave -noupdate -divider memwbValue
add wave -noupdate /system_tb/DUT/CPU/DP/opCwb
add wave -noupdate /system_tb/DUT/CPU/DP/memwb/enable
add wave -noupdate /system_tb/DUT/CPU/DP/funcwb
add wave -noupdate /system_tb/DUT/CPU/DP/memwbValue/instr
add wave -noupdate /system_tb/DUT/CPU/DP/memwbValue/WEN
add wave -noupdate /system_tb/DUT/CPU/DP/memwbValue/pc
add wave -noupdate /system_tb/DUT/CPU/DP/rf/regs
add wave -noupdate -divider Hazard
add wave -noupdate /system_tb/DUT/CPU/DP/hazard/WEN
add wave -noupdate /system_tb/DUT/CPU/DP/hazard/jumpBranch
add wave -noupdate /system_tb/DUT/CPU/DP/hazard/rsel1
add wave -noupdate /system_tb/DUT/CPU/DP/hazard/rsel2
add wave -noupdate /system_tb/DUT/CPU/DP/hazard/idexWsel
add wave -noupdate /system_tb/DUT/CPU/DP/hazard/exmemWsel
add wave -noupdate /system_tb/DUT/CPU/DP/hazard/stallPC
add wave -noupdate /system_tb/DUT/CPU/DP/hazard/ifidFlush
add wave -noupdate /system_tb/DUT/CPU/DP/hazard/idexFlush
add wave -noupdate -divider RFIF
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/WEN
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/wsel
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/rsel1
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/rsel2
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/wdat
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/rdat1
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/rdat2
add wave -noupdate -divider pc
add wave -noupdate /system_tb/DUT/CPU/DP/progCount/pc
add wave -noupdate /system_tb/DUT/CPU/DP/progCount/imemload
add wave -noupdate /system_tb/DUT/CPU/DP/progCount/extendOut
add wave -noupdate /system_tb/DUT/CPU/DP/progCount/rdat1
add wave -noupdate /system_tb/DUT/CPU/DP/progCount/zero
add wave -noupdate /system_tb/DUT/CPU/DP/progCount/newPC
add wave -noupdate /system_tb/DUT/CPU/DP/progCount/incPC
add wave -noupdate /system_tb/DUT/CPU/DP/progCount/jumpBranch
add wave -noupdate /system_tb/DUT/CPU/DP/progCount/branchPC
add wave -noupdate /system_tb/DUT/CPU/DP/progCount/mux1Out
add wave -noupdate /system_tb/DUT/CPU/DP/progCount/mux2Out
add wave -noupdate /system_tb/DUT/CPU/DP/progCount/branch
add wave -noupdate /system_tb/DUT/CPU/DP/progCount/jump
add wave -noupdate /system_tb/DUT/CPU/DP/progCount/jump2
add wave -noupdate /system_tb/DUT/CPU/DP/progCount/countIf/regDst
add wave -noupdate /system_tb/DUT/CPU/DP/progCount/countIf/branch
add wave -noupdate /system_tb/DUT/CPU/DP/progCount/countIf/WEN
add wave -noupdate /system_tb/DUT/CPU/DP/progCount/countIf/aluSrc
add wave -noupdate /system_tb/DUT/CPU/DP/progCount/countIf/jmp
add wave -noupdate /system_tb/DUT/CPU/DP/progCount/countIf/jl
add wave -noupdate /system_tb/DUT/CPU/DP/progCount/countIf/jmpReg
add wave -noupdate /system_tb/DUT/CPU/DP/progCount/countIf/memToReg
add wave -noupdate /system_tb/DUT/CPU/DP/progCount/countIf/dREN
add wave -noupdate /system_tb/DUT/CPU/DP/progCount/countIf/dWEN
add wave -noupdate /system_tb/DUT/CPU/DP/progCount/countIf/lui
add wave -noupdate /system_tb/DUT/CPU/DP/progCount/countIf/bne
add wave -noupdate /system_tb/DUT/CPU/DP/progCount/countIf/zeroExt
add wave -noupdate /system_tb/DUT/CPU/DP/progCount/countIf/shiftSel
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {441264 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 139
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {192236 ps} {672826 ps}
