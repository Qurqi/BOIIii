onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lab7_check_tb/KEY
add wave -noupdate /lab7_check_tb/SW
add wave -noupdate /lab7_check_tb/LEDR
add wave -noupdate /lab7_check_tb/HEX0
add wave -noupdate /lab7_check_tb/HEX1
add wave -noupdate /lab7_check_tb/HEX2
add wave -noupdate /lab7_check_tb/HEX3
add wave -noupdate /lab7_check_tb/HEX4
add wave -noupdate /lab7_check_tb/HEX5
add wave -noupdate /lab7_check_tb/err
add wave -noupdate {/lab7_check_tb/DUT/MEM/mem[11]}
add wave -noupdate {/lab7_check_tb/DUT/MEM/mem[10]}
add wave -noupdate {/lab7_check_tb/DUT/MEM/mem[9]}
add wave -noupdate {/lab7_check_tb/DUT/MEM/mem[8]}
add wave -noupdate {/lab7_check_tb/DUT/MEM/mem[7]}
add wave -noupdate {/lab7_check_tb/DUT/MEM/mem[6]}
add wave -noupdate {/lab7_check_tb/DUT/MEM/mem[5]}
add wave -noupdate {/lab7_check_tb/DUT/MEM/mem[4]}
add wave -noupdate {/lab7_check_tb/DUT/MEM/mem[3]}
add wave -noupdate {/lab7_check_tb/DUT/MEM/mem[2]}
add wave -noupdate {/lab7_check_tb/DUT/MEM/mem[1]}
add wave -noupdate {/lab7_check_tb/DUT/MEM/mem[0]}
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/REGFILE/R0
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/REGFILE/R1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {384 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 376
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {790 ps}
