# This file is automatically generated.
# It contains project source information necessary for synthesis and implementation.

# XDC: new/basys.xdc

# IP: ip/clk/clk.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==clk || ORIG_REF_NAME==clk} -quiet] -quiet

# XDC: ip/clk/clk_board.xdc
set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==clk || ORIG_REF_NAME==clk} -quiet] {/inst } ]/inst ] -quiet] -quiet

# XDC: ip/clk/clk.xdc
#dup# set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==clk || ORIG_REF_NAME==clk} -quiet] {/inst } ]/inst ] -quiet] -quiet

# XDC: ip/clk/clk_late.xdc
#dup# set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==clk || ORIG_REF_NAME==clk} -quiet] {/inst } ]/inst ] -quiet] -quiet

# XDC: ip/clk/clk_ooc.xdc
