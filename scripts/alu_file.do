onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /alu_file_tb/PROG/pass
add wave -noupdate /alu_file_tb/aluf/negative
add wave -noupdate /alu_file_tb/aluf/overflow
add wave -noupdate /alu_file_tb/aluf/zero
add wave -noupdate /alu_file_tb/aluf/aluop
add wave -noupdate /alu_file_tb/aluf/portA
add wave -noupdate /alu_file_tb/aluf/portB
add wave -noupdate /alu_file_tb/aluf/outputPort
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
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
WaveRestoreZoom {0 ns} {1 us}
