onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/DUT/CPU/CLK
add wave -noupdate /system_tb/DUT/CPU/nRST
add wave -noupdate /system_tb/DUT/CPU/halt
add wave -noupdate -divider DP0
add wave -noupdate /system_tb/DUT/CPU/DP0/pc
add wave -noupdate /system_tb/DUT/CPU/DP0/opC
add wave -noupdate /system_tb/DUT/CPU/DP0/func
add wave -noupdate -divider DP1
add wave -noupdate /system_tb/DUT/CPU/DP1/pc
add wave -noupdate /system_tb/DUT/CPU/DP1/opC
add wave -noupdate /system_tb/DUT/CPU/DP1/func
add wave -noupdate -divider dcache0
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/state
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/count
add wave -noupdate /system_tb/DUT/CPU/cif0/ccwait
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/cif/cctrans
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/cif/ccwrite
add wave -noupdate -divider dcache1
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/state
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/count
add wave -noupdate /system_tb/DUT/CPU/cif1/ccwait
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/cif/ccwrite
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/cif/cctrans
add wave -noupdate -divider MemContr
add wave -noupdate /system_tb/DUT/CPU/CC/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1226114 ps} 0}
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
WaveRestoreZoom {893309 ps} {1628161 ps}
