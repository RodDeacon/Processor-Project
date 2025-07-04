## Generated SDC file "Project.sdc"

## Copyright (C) 2020  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and any partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details, at
## https://fpgasoftware.intel.com/eula.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 20.1.1 Build 720 11/11/2020 SJ Lite Edition"

## DATE    "Sat Jun 07 13:58:11 2025"

##
## DEVICE  "EP4CE115F29C7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {altera_reserved_tck} -period 100.000 -waveform { 0.000 50.000 } [get_ports {altera_reserved_tck}]
create_clock -name {processorClock} -period 500.000 -waveform { 0.000 250.000 } [get_nets {Out}]
create_clock -name {MHz50Clock} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK_50}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
set_clock_uncertainty -rise_from [get_clocks {processorClock}] -rise_to [get_clocks {processorClock}]  1.000  
set_clock_uncertainty -rise_from [get_clocks {processorClock}] -fall_to [get_clocks {processorClock}]  1.000 
set_clock_uncertainty -fall_from [get_clocks {processorClock}] -rise_to [get_clocks {processorClock}]  1.000  
set_clock_uncertainty -fall_from [get_clocks {processorClock}] -fall_to [get_clocks {processorClock}]  1.000 

set_clock_uncertainty -rise_from [get_clocks {MHz50Clock}] -rise_to [get_clocks {MHz50Clock}]  1.000 
set_clock_uncertainty -rise_from [get_clocks {MHz50Clock}] -fall_to [get_clocks {MHz50Clock}]  1.000  
set_clock_uncertainty -fall_from [get_clocks {MHz50Clock}] -rise_to [get_clocks {MHz50Clock}]  1.000 
set_clock_uncertainty -fall_from [get_clocks {MHz50Clock}] -fall_to [get_clocks {MHz50Clock}]  1.000  

set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}]  1.000  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}]  1.000   
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}]  1.000 
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}]  1.000 


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 


#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

