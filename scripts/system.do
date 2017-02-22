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
add wave -noupdate -divider idexValue
add wave -noupdate /system_tb/DUT/CPU/DP/opCex
add wave -noupdate /system_tb/DUT/CPU/DP/funcex
add wave -noupdate /system_tb/DUT/CPU/DP/idexValue/instr
add wave -noupdate /system_tb/DUT/CPU/DP/idexValue/dest
add wave -noupdate -divider exmemValue
add wave -noupdate /system_tb/DUT/CPU/DP/opCmem
add wave -noupdate /system_tb/DUT/CPU/DP/funcmem
add wave -noupdate /system_tb/DUT/CPU/DP/exmem/enable
add wave -noupdate /system_tb/DUT/CPU/DP/exmemValue/instr
add wave -noupdate /system_tb/DUT/CPU/DP/exmemValue/dest
add wave -noupdate -divider memwbValue
add wave -noupdate /system_tb/DUT/CPU/DP/opCwb
add wave -noupdate /system_tb/DUT/CPU/DP/memwb/enable
add wave -noupdate /system_tb/DUT/CPU/DP/funcwb
add wave -noupdate /system_tb/DUT/CPU/DP/memwbValue/instr
add wave -noupdate /system_tb/DUT/CPU/DP/memwbValue/dest
add wave -noupdate -divider RFIF
add wave -noupdate /system_tb/DUT/CPU/DP/rf/regs
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/wsel
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/rsel1
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/rsel2
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/wdat
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/rdat1
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/rdat2
add wave -noupdate -divider forwarding_unit
add wave -noupdate /system_tb/DUT/CPU/DP/forward/rsel1
add wave -noupdate /system_tb/DUT/CPU/DP/forward/rsel2
add wave -noupdate /system_tb/DUT/CPU/DP/forward/rdat1Fwd
add wave -noupdate /system_tb/DUT/CPU/DP/forward/rdat2Fwd
add wave -noupdate /system_tb/DUT/CPU/DP/forward/r1Fwd
add wave -noupdate /system_tb/DUT/CPU/DP/forward/r2Fwd
add wave -noupdate -divider Hazard
add wave -noupdate /system_tb/DUT/CPU/DP/hazard/dREN
add wave -noupdate /system_tb/DUT/CPU/DP/hazard/jumpBranch
add wave -noupdate /system_tb/DUT/CPU/DP/hazard/rsel1
add wave -noupdate /system_tb/DUT/CPU/DP/hazard/rsel2
add wave -noupdate /system_tb/DUT/CPU/DP/hazard/idexWsel
add wave -noupdate /system_tb/DUT/CPU/DP/hazard/exmemWsel
add wave -noupdate /system_tb/DUT/CPU/DP/hazard/stallPC
add wave -noupdate /system_tb/DUT/CPU/DP/hazard/ifidFlush
add wave -noupdate /system_tb/DUT/CPU/DP/hazard/idexFlush
add wave -noupdate /system_tb/DUT/CPU/DP/hazard/ifidFreeze
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1311776378 ps} 0}
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
WaveRestoreZoom {1311703440 ps} {1312184030 ps}
