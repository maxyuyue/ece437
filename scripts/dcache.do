onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dcache_tb/CLK
add wave -noupdate /dcache_tb/nRST
add wave -noupdate /dcache_tb/DUT/state
add wave -noupdate /dcache_tb/DUT/nextState
add wave -noupdate -expand /dcache_tb/DUT/query
add wave -noupdate /dcache_tb/DUT/isHit
add wave -noupdate /dcache_tb/DUT/isValid
add wave -noupdate -expand /dcache_tb/DUT/dcache
add wave -noupdate -divider dcif
add wave -noupdate /dcache_tb/DUT/dcif/dhit
add wave -noupdate /dcache_tb/DUT/dcif/dmemload
add wave -noupdate /dcache_tb/DUT/dcif/dmemaddr
add wave -noupdate -divider cif
add wave -noupdate /dcache_tb/DUT/cif/dwait
add wave -noupdate /dcache_tb/DUT/cif/dWEN
add wave -noupdate /dcache_tb/DUT/cif/dload
add wave -noupdate /dcache_tb/DUT/cif/dstore
add wave -noupdate /dcache_tb/DUT/cif/daddr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {37 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ns} {42 ns}
