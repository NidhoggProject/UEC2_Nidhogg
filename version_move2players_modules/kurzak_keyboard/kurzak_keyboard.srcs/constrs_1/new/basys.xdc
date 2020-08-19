# Constraints for CLK
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
#create_clock -name external_clock -period 10.00 [get_ports clk]

# Constraints for VS and HS
set_property PACKAGE_PIN R19 [get_ports {vs}]
set_property IOSTANDARD LVCMOS33 [get_ports {vs}]
set_property PACKAGE_PIN P19 [get_ports {hs}]
set_property IOSTANDARD LVCMOS33 [get_ports {hs}]

# Constraints for RED
set_property PACKAGE_PIN G19 [get_ports {r[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[0]}]
set_property PACKAGE_PIN H19 [get_ports {r[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[1]}]
set_property PACKAGE_PIN J19 [get_ports {r[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[2]}]
set_property PACKAGE_PIN N19 [get_ports {r[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[3]}]

# Constraints for GRN
set_property PACKAGE_PIN J17 [get_ports {g[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[0]}]
set_property PACKAGE_PIN H17 [get_ports {g[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[1]}]
set_property PACKAGE_PIN G17 [get_ports {g[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[2]}]
set_property PACKAGE_PIN D17 [get_ports {g[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[3]}]

# reset
set_property PACKAGE_PIN W2 [get_ports {rst}]
set_property IOSTANDARD LVCMOS33 [get_ports {rst}]

# Constraints for BLU
set_property PACKAGE_PIN N18 [get_ports {b[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[0]}]
set_property PACKAGE_PIN L18 [get_ports {b[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[1]}]
set_property PACKAGE_PIN K18 [get_ports {b[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[2]}]
set_property PACKAGE_PIN J18 [get_ports {b[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[3]}]

# Constraints for CFGBVS
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]


##Buttons
#Bank = 14, Pin name = ,					Sch name = BTNC
#set_property PACKAGE_PIN U18 [get_ports {BTN[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {BTN[4]}]
#Bank = 14, Pin name = ,					Sch name = BTNU
#set_property PACKAGE_PIN T18 [get_ports {BTN[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {BTN[0]}]
#Bank = 14, Pin name = ,	                Sch name = BTNL
#set_property PACKAGE_PIN W19 [get_ports {BTN[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {BTN[1]}]
#Bank = 14, Pin name = ,					Sch name = BTNR
#set_property PACKAGE_PIN T17 [get_ports {BTN[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {BTN[2]}]
#Bank = 14, Pin name = ,					Sch name = BTND
#set_property PACKAGE_PIN U17 [get_ports {BTN[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {BTN[3]}]

#----------------------------------------------------
#set_property PACKAGE_PIN W17 [get_ports rst]						
#	set_property IOSTANDARD LVCMOS33 [get_ports rst]
#set_property PACKAGE_PIN V16 [get_ports btnU]						
#	set_property IOSTANDARD LVCMOS33 [get_ports btnU]
#set_property PACKAGE_PIN W16 [get_ports btnL]						
#	set_property IOSTANDARD LVCMOS33 [get_ports btnL]
#set_property PACKAGE_PIN V17 [get_ports btnR]						
#	set_property IOSTANDARD LVCMOS33 [get_ports btnR]
#set_property PACKAGE_PIN W15 [get_ports btnD]						
	#set_property IOSTANDARD LVCMOS33 [get_ports btnD]
#----------------------------------------------------
	
#USB HID (PS/2)
set_property PACKAGE_PIN C17 [get_ports PS2Clk]						
set_property IOSTANDARD LVCMOS33 [get_ports PS2Clk]
set_property PULLUP true [get_ports PS2Clk]
set_property PACKAGE_PIN B17 [get_ports PS2Data]					
set_property IOSTANDARD LVCMOS33 [get_ports PS2Data]	
set_property PULLUP true [get_ports PS2Data]	