onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider dp
add wave -noupdate /system_tb/DUT/CPU/DP/CLK
add wave -noupdate /system_tb/DUT/CPU/dcif/halt
add wave -noupdate /system_tb/DUT/CPU/dcif/ihit
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
add wave -noupdate -group ifidValue /system_tb/DUT/CPU/DP/opCid
add wave -noupdate -group ifidValue /system_tb/DUT/CPU/DP/funcid
add wave -noupdate -group ifidValue /system_tb/DUT/CPU/DP/ifid/enable
add wave -noupdate -group ifidValue /system_tb/DUT/CPU/DP/ifid/flush
add wave -noupdate -group ifidValue /system_tb/DUT/CPU/DP/ifidValue/instr
add wave -noupdate -group idexValue /system_tb/DUT/CPU/DP/opCex
add wave -noupdate -group idexValue /system_tb/DUT/CPU/DP/funcex
add wave -noupdate -group idexValue /system_tb/DUT/CPU/DP/idexValue/instr
add wave -noupdate -group idexValue /system_tb/DUT/CPU/DP/idexValue/dest
add wave -noupdate -group idexValue /system_tb/DUT/CPU/DP/idexValue/outputPort
add wave -noupdate -group exmemValue /system_tb/DUT/CPU/DP/opCmem
add wave -noupdate -group exmemValue /system_tb/DUT/CPU/DP/funcmem
add wave -noupdate -group exmemValue /system_tb/DUT/CPU/DP/exmem/enable
add wave -noupdate -group exmemValue /system_tb/DUT/CPU/DP/exmemValue/instr
add wave -noupdate -group exmemValue /system_tb/DUT/CPU/DP/exmemValue/dest
add wave -noupdate -group exmemValue /system_tb/DUT/CPU/DP/exmemValue/outputPort
add wave -noupdate -group exmemValue /system_tb/DUT/CPU/DP/exmem/flush
add wave -noupdate -group memwbValue /system_tb/DUT/CPU/DP/opCwb
add wave -noupdate -group memwbValue /system_tb/DUT/CPU/DP/memwb/enable
add wave -noupdate -group memwbValue /system_tb/DUT/CPU/DP/memwb/flush
add wave -noupdate -group memwbValue /system_tb/DUT/CPU/DP/funcwb
add wave -noupdate -group memwbValue /system_tb/DUT/CPU/DP/memwbValue/instr
add wave -noupdate -group memwbValue /system_tb/DUT/CPU/DP/memwbValue/dest
add wave -noupdate -group memwbValue /system_tb/DUT/CPU/DP/memwbValue/outputPort
add wave -noupdate -group rfif /system_tb/DUT/CPU/DP/rf/regs
add wave -noupdate -group rfif /system_tb/DUT/CPU/DP/rfif/wsel
add wave -noupdate -group rfif /system_tb/DUT/CPU/DP/rfif/rsel1
add wave -noupdate -group rfif /system_tb/DUT/CPU/DP/rfif/rsel2
add wave -noupdate -group rfif /system_tb/DUT/CPU/DP/rfif/wdat
add wave -noupdate -group rfif /system_tb/DUT/CPU/DP/rfif/rdat1
add wave -noupdate -group rfif /system_tb/DUT/CPU/DP/rfif/rdat2
add wave -noupdate -divider cif
add wave -noupdate /system_tb/DUT/CPU/CM/cif/daddr
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/cif/dstore
add wave -noupdate -divider dCache
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/isHit1
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/isHit2
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/count
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/nxt_count
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/hitCount
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/hitCount_nxt
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/missCount
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/missCount_nxt
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/state
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/nxt_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4992000 ps} 0}
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
WaveRestoreZoom {4238534 ps} {5040072 ps}
