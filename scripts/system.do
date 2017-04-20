onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/DUT/CPU/CLK
add wave -noupdate /system_tb/DUT/CPU/nRST
add wave -noupdate /system_tb/DUT/CPU/halt
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/pc
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/opCmem
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/funcmem
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/exmemValue/instr
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/func
add wave -noupdate -expand -group DP0 {/system_tb/DUT/CPU/DP0/rf/regs[3]}
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/dpif/dmemload
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/dpif/dmemWEN
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/dcif0/dmemaddr
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/memwbValueOld/instr
add wave -noupdate /system_tb/DUT/CPU/DP0/rfif/WEN
add wave -noupdate /system_tb/DUT/CPU/DP0/memwbValue/ll
add wave -noupdate /system_tb/DUT/CPU/DP0/rfif/wsel
add wave -noupdate /system_tb/DUT/CPU/DP0/rfif/wdat
add wave -noupdate -group DP1 /system_tb/DUT/CPU/DP1/pc
add wave -noupdate -group DP1 /system_tb/DUT/CPU/DP1/opCmem
add wave -noupdate -group DP1 /system_tb/DUT/CPU/DP1/funcmem
add wave -noupdate -group DP1 /system_tb/DUT/CPU/DP1/exmemValue/instr
add wave -noupdate -group DP1 /system_tb/DUT/CPU/DP1/func
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/snoop_valid_nxt0
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/snoop_valid_nxt1
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/state
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/count
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/cif0/ccwait
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/cif/cctrans
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/cif/ccwrite
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/cif0/ccsnoopaddr
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/dcache
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/cif/ccinv
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/link_reg
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/snoop_valid_nxt0
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/snoop_valid_nxt1
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/isSnoopHit0
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/isSnoopHit1
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/state
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/count
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/cif1/ccwait
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/cif/ccwrite
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/cif/cctrans
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/cif1/ccsnoopaddr
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/dcache
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM0/cif/ccinv
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/link_reg
add wave -noupdate -divider MemContr
add wave -noupdate /system_tb/DUT/CPU/CC/state
add wave -noupdate /system_tb/DUT/CPU/CC/serviced
add wave -noupdate /system_tb/DUT/CPU/CC/ccwait
add wave -noupdate -group ram /system_tb/DUT/prif/ramWEN
add wave -noupdate -group ram /system_tb/DUT/prif/ramaddr
add wave -noupdate -group ram /system_tb/DUT/prif/ramstore
add wave -noupdate /system_tb/DUT/CPU/DP0/exmemValue/ll
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2937496 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 272
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
WaveRestoreZoom {2349011 ps} {3582027 ps}
