-makelib ies_lib/xil_defaultlib -sv \
  "C:/Xilinx/Vivado/2017.3/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies_lib/xpm \
  "C:/Xilinx/Vivado/2017.3/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../kurzak_18092020.srcs/sources_1/ip/clk/clk_clk_wiz.v" \
  "../../../../kurzak_18092020.srcs/sources_1/ip/clk/clk.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

