onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /StateMachine_tb/Clk
add wave -noupdate /StateMachine_tb/ResetN
add wave -noupdate /StateMachine_tb/IR
add wave -noupdate /StateMachine_tb/D_wr
add wave -noupdate /StateMachine_tb/RF_s
add wave -noupdate /StateMachine_tb/RF_W_en
add wave -noupdate /StateMachine_tb/PC_clr
add wave -noupdate /StateMachine_tb/IR_ld
add wave -noupdate /StateMachine_tb/PC_up
add wave -noupdate /StateMachine_tb/D_Addr
add wave -noupdate /StateMachine_tb/RF_W_addr
add wave -noupdate /StateMachine_tb/RF_Ra_addr
add wave -noupdate /StateMachine_tb/RF_Rb_addr
add wave -noupdate /StateMachine_tb/Alu_s0
add wave -noupdate /StateMachine_tb/CurrentState
add wave -noupdate /StateMachine_tb/NextState
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
