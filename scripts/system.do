onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider dp
add wave -noupdate /system_tb/DUT/CPU/DP/CLK
add wave -noupdate /system_tb/DUT/CPU/dcif/halt
add wave -noupdate /system_tb/DUT/CPU/dcif/ihit
add wave -noupdate /system_tb/DUT/CPU/dcif/imemREN
add wave -noupdate /system_tb/DUT/CPU/DP/opCif
add wave -noupdate /system_tb/DUT/CPU/dcif/imemload
add wave -noupdate /system_tb/DUT/CPU/dcif/imemaddr
add wave -noupdate /system_tb/DUT/CPU/dcif/dhit
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemREN
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemWEN
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemload
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemstore
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemaddr
add wave -noupdate -divider ifidValue
add wave -noupdate /system_tb/DUT/CPU/DP/opCid
add wave -noupdate /system_tb/DUT/CPU/DP/ifidValue/instr
add wave -noupdate /system_tb/DUT/CPU/DP/ifidValue/pc
add wave -noupdate -divider idexValue
add wave -noupdate /system_tb/DUT/CPU/DP/opCex
add wave -noupdate /system_tb/DUT/CPU/DP/idexValue/instr
add wave -noupdate /system_tb/DUT/CPU/DP/idexValue/WEN
add wave -noupdate /system_tb/DUT/CPU/DP/idexValue/pc
add wave -noupdate -divider exmemValue
add wave -noupdate /system_tb/DUT/CPU/DP/opCmem
add wave -noupdate /system_tb/DUT/CPU/DP/exmem/enable
add wave -noupdate /system_tb/DUT/CPU/DP/exmemValue/instr
add wave -noupdate /system_tb/DUT/CPU/DP/exmemValue/WEN
add wave -noupdate /system_tb/DUT/CPU/DP/exmemValue/pc
add wave -noupdate -divider memwbValue
add wave -noupdate /system_tb/DUT/CPU/DP/opCwb
add wave -noupdate /system_tb/DUT/CPU/DP/memwb/enable
add wave -noupdate /system_tb/DUT/CPU/DP/memwbValue/instr
add wave -noupdate /system_tb/DUT/CPU/DP/memwbValue/WEN
add wave -noupdate /system_tb/DUT/CPU/DP/memwbValue/pc
add wave -noupdate /system_tb/DUT/CPU/DP/rf/regs
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {308882 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 132
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
WaveRestoreZoom {0 ps} {484083 ps}
