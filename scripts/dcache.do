onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dcache_tb/DUT/CLK
add wave -noupdate /dcache_tb/DUT/nRST
add wave -noupdate /dcache_tb/DUT/debugState
add wave -noupdate /dcache_tb/DUT/state
add wave -noupdate /dcache_tb/DUT/stateNext
add wave -noupdate /dcache_tb/DUT/lru
add wave -noupdate -expand /dcache_tb/DUT/query
add wave -noupdate -expand -subitemconfig {{/dcache_tb/DUT/dcache[1]} -expand {/dcache_tb/DUT/dcache[1][0]} -expand} /dcache_tb/DUT/dcache
add wave -noupdate /dcache_tb/DUT/lruBlock
add wave -noupdate -divider dcif
add wave -noupdate /dcache_tb/DUT/dcif/dhit
add wave -noupdate /dcache_tb/DUT/dcif/dmemWEN
add wave -noupdate /dcache_tb/DUT/dcif/dmemREN
add wave -noupdate /dcache_tb/DUT/dcif/dmemload
add wave -noupdate /dcache_tb/DUT/dcif/dmemaddr
add wave -noupdate /dcache_tb/DUT/dcif/dmemstore
add wave -noupdate -divider cif
add wave -noupdate /dcache_tb/DUT/cif/dwait
add wave -noupdate /dcache_tb/DUT/cif/dWEN
add wave -noupdate /dcache_tb/DUT/cif/dREN
add wave -noupdate /dcache_tb/DUT/cif/dload
add wave -noupdate /dcache_tb/DUT/cif/daddr
add wave -noupdate /dcache_tb/DUT/cif/dstore
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {30 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 140
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
WaveRestoreZoom {60 ns} {155 ns}
