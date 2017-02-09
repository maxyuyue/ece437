onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider System_tb
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate -divider DUT
add wave -noupdate /system_tb/DUT/halt
add wave -noupdate /system_tb/DUT/CPUCLK
add wave -noupdate -divider DUT/CPU/dcif
add wave -noupdate /system_tb/DUT/CPU/dcif/ihit
add wave -noupdate /system_tb/DUT/CPU/dcif/imemREN
add wave -noupdate /system_tb/DUT/CPU/dcif/imemload
add wave -noupdate /system_tb/DUT/CPU/dcif/imemaddr
add wave -noupdate /system_tb/DUT/CPU/dcif/dhit
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemREN
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemWEN
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemload
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemstore
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemaddr
add wave -noupdate -divider DP
add wave -noupdate /system_tb/DUT/CPU/DP/pc
add wave -noupdate /system_tb/DUT/CPU/DP/newPC
add wave -noupdate /system_tb/DUT/CPU/DP/incPC
add wave -noupdate /system_tb/DUT/CPU/DP/extendOut
add wave -noupdate /system_tb/DUT/CPU/DP/opC
add wave -noupdate /system_tb/DUT/CPU/DP/func
add wave -noupdate /system_tb/DUT/CPU/DP/memwbEnable
add wave -noupdate -radix hexadecimal -childformat {{{/system_tb/DUT/CPU/DP/rf/regs[31]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[30]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[29]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[28]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[27]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[26]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[25]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[24]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[23]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[22]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[21]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[20]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[19]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[18]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[17]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[16]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[15]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[14]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[13]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[12]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[11]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[10]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[9]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[8]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[7]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[6]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[5]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[4]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[3]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[2]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[1]} -radix hexadecimal} {{/system_tb/DUT/CPU/DP/rf/regs[0]} -radix hexadecimal}} -subitemconfig {{/system_tb/DUT/CPU/DP/rf/regs[31]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[30]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[29]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[28]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[27]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[26]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[25]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[24]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[23]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[22]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[21]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[20]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[19]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[18]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[17]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[16]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[15]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[14]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[13]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[12]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[11]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[10]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[9]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[8]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[7]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[6]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[5]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[4]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[3]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[2]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[1]} {-height 17 -radix hexadecimal} {/system_tb/DUT/CPU/DP/rf/regs[0]} {-height 17 -radix hexadecimal}} /system_tb/DUT/CPU/DP/rf/regs
add wave -noupdate -divider ifid
add wave -noupdate /system_tb/DUT/CPU/DP/opCifid
add wave -noupdate /system_tb/DUT/CPU/DP/funcifid
add wave -noupdate /system_tb/DUT/CPU/DP/ifid/CLK
add wave -noupdate /system_tb/DUT/CPU/DP/ifid/enable
add wave -noupdate /system_tb/DUT/CPU/DP/ifid/prIFID_in/instr
add wave -noupdate /system_tb/DUT/CPU/DP/ifid/prIFID_in/incPC
add wave -noupdate /system_tb/DUT/CPU/DP/ifid/prIFID_in/pc
add wave -noupdate -divider {ifid out}
add wave -noupdate /system_tb/DUT/CPU/DP/ifid/prIFID_out/instr
add wave -noupdate /system_tb/DUT/CPU/DP/ifid/prIFID_out/incPC
add wave -noupdate /system_tb/DUT/CPU/DP/ifid/prIFID_out/pc
add wave -noupdate -divider DP/rfif
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/WEN
add wave -noupdate -radix decimal /system_tb/DUT/CPU/DP/rfif/wsel
add wave -noupdate -radix decimal /system_tb/DUT/CPU/DP/rfif/rsel1
add wave -noupdate -radix decimal /system_tb/DUT/CPU/DP/rfif/rsel2
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/wdat
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/rdat1
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/rdat2
add wave -noupdate -divider idex
add wave -noupdate /system_tb/DUT/CPU/DP/opCidex
add wave -noupdate /system_tb/DUT/CPU/DP/funcidex
add wave -noupdate /system_tb/DUT/CPU/DP/idex/enable
add wave -noupdate /system_tb/DUT/CPU/DP/idex/prIDEX_in/instr
add wave -noupdate /system_tb/DUT/CPU/DP/idex/prIDEX_in/pc
add wave -noupdate -divider idex_out
add wave -noupdate /system_tb/DUT/CPU/DP/idex/prIDEX_out/regDst
add wave -noupdate /system_tb/DUT/CPU/DP/idex/prIDEX_out/WEN
add wave -noupdate /system_tb/DUT/CPU/DP/idex/prIDEX_out/aluSrc
add wave -noupdate /system_tb/DUT/CPU/DP/idex/prIDEX_out/zeroExt
add wave -noupdate /system_tb/DUT/CPU/DP/idex/prIDEX_out/shiftSel
add wave -noupdate /system_tb/DUT/CPU/DP/idex/prIDEX_out/aluOp
add wave -noupdate /system_tb/DUT/CPU/DP/idex/prIDEX_out/instr
add wave -noupdate /system_tb/DUT/CPU/DP/idex/prIDEX_out/incPC
add wave -noupdate /system_tb/DUT/CPU/DP/idex/prIDEX_out/pc
add wave -noupdate /system_tb/DUT/CPU/DP/idex/prIDEX_out/rdat1
add wave -noupdate /system_tb/DUT/CPU/DP/idex/prIDEX_out/rdat2
add wave -noupdate -divider aluf
add wave -noupdate /system_tb/DUT/CPU/DP/aluf/negative
add wave -noupdate /system_tb/DUT/CPU/DP/aluf/overflow
add wave -noupdate /system_tb/DUT/CPU/DP/aluf/zero
add wave -noupdate /system_tb/DUT/CPU/DP/aluf/aluop
add wave -noupdate /system_tb/DUT/CPU/DP/aluf/portA
add wave -noupdate /system_tb/DUT/CPU/DP/aluf/portB
add wave -noupdate /system_tb/DUT/CPU/DP/aluf/outputPort
add wave -noupdate -divider exmem
add wave -noupdate /system_tb/DUT/CPU/DP/opCexmem
add wave -noupdate /system_tb/DUT/CPU/DP/funcexmem
add wave -noupdate -divider memwb
add wave -noupdate /system_tb/DUT/CPU/DP/opCmemwb
add wave -noupdate /system_tb/DUT/CPU/DP/funcmemwb
add wave -noupdate /system_tb/DUT/CPU/DP/countIf/shiftSel
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {40000 ps} 0}
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
WaveRestoreZoom {0 ps} {269999 ps}
