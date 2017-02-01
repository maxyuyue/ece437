onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/PROG/cycles
add wave -noupdate /system_tb/syif/halt
add wave -noupdate /system_tb/syif/load
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/halt
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/ihit
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/imemREN
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/imemload
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/imemaddr
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/dhit
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/dmemREN
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/dmemWEN
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/dmemload
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/dmemstore
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/dmemaddr
add wave -noupdate -radix hexadecimal -childformat {{{/system_tb/DUT/CPU/DP/rf/regs[31]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[30]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[29]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[28]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[27]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[26]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[25]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[24]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[23]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[22]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[21]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[20]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[19]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[18]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[17]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[16]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[15]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[14]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[13]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[12]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[11]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[10]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[9]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[8]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[7]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[6]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[5]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[4]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[3]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[2]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[1]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[0]} -radix hexadecimal}} -subitemconfig {{/system_tb/DUT/CPU/DP/rf/regs[31]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[30]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[29]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[28]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[27]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[26]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[25]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[24]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[23]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[22]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[21]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[20]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[19]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[18]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[17]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[16]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[15]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[14]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[13]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[12]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[11]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[10]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[9]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[8]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[7]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[6]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[5]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[4]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[3]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[2]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[1]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[0]} {-height 17 -radix hexadecimal}} /system_tb/DUT/CPU/DP/rf/regs
add wave -noupdate /system_tb/DUT/CPU/DP/controler/rType
add wave -noupdate /system_tb/DUT/CPU/DP/controler/iType
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1543421 ps} 0}
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
WaveRestoreZoom {1465840 ps} {1832308 ps}
