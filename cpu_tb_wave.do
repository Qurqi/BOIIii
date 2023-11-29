onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu_tb/N
add wave -noupdate /cpu_tb/V
add wave -noupdate /cpu_tb/Z
add wave -noupdate /cpu_tb/write_data
add wave -noupdate /cpu_tb/mem_addr
add wave -noupdate /cpu_tb/mem_cmd
add wave -noupdate /cpu_tb/clk
add wave -noupdate /cpu_tb/reset
add wave -noupdate /cpu_tb/err
add wave -noupdate /cpu_tb/read_data
add wave -noupdate /cpu_tb/load
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {1 ns}
