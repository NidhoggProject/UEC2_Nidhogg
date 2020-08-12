# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param xicom.use_bs_reader 1
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/kurzak_keyboard/kurzak_keyboard.cache/wt [current_project]
set_property parent.project_path C:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/kurzak_keyboard/kurzak_keyboard.xpr [current_project]
set_property XPM_LIBRARIES XPM_CDC [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part digilentinc.com:basys3:part0:1.1 [current_project]
set_property ip_output_repo c:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/kurzak_keyboard/kurzak_keyboard.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  C:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/kurzak_keyboard/kurzak_keyboard.srcs/sources_1/imports/new/PS2Receiver.v
  C:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/kurzak_keyboard/kurzak_keyboard.srcs/sources_1/imports/new/debouncer.v
  C:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/kurzak_keyboard/kurzak_keyboard.srcs/sources_1/imports/new/image_rom.v
  C:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/kurzak_keyboard/kurzak_keyboard.srcs/sources_1/imports/new/image_rom_player.v
  C:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/kurzak_keyboard/kurzak_keyboard.srcs/sources_1/imports/new/keyboard.v
  C:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/kurzak_keyboard/kurzak_keyboard.srcs/sources_1/imports/new/players.v
  C:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/kurzak_keyboard/kurzak_keyboard.srcs/sources_1/imports/new/start.v
  C:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/kurzak_keyboard/kurzak_keyboard.srcs/sources_1/imports/new/state_machine.v
  C:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/kurzak_keyboard/kurzak_keyboard.srcs/sources_1/imports/new/vga_timing.v
  C:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/kurzak_keyboard/kurzak_keyboard.srcs/sources_1/imports/new/nidhogg.v
}
read_ip -quiet c:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/kurzak_keyboard/kurzak_keyboard.srcs/sources_1/ip/clk/clk.xci
set_property used_in_implementation false [get_files -all c:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/kurzak_keyboard/kurzak_keyboard.srcs/sources_1/ip/clk/clk_board.xdc]
set_property used_in_implementation false [get_files -all c:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/kurzak_keyboard/kurzak_keyboard.srcs/sources_1/ip/clk/clk.xdc]
set_property used_in_implementation false [get_files -all c:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/kurzak_keyboard/kurzak_keyboard.srcs/sources_1/ip/clk/clk_late.xdc]
set_property used_in_implementation false [get_files -all c:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/kurzak_keyboard/kurzak_keyboard.srcs/sources_1/ip/clk/clk_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/kurzak_keyboard/kurzak_keyboard.srcs/constrs_1/new/basys.xdc
set_property used_in_implementation false [get_files C:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/kurzak_keyboard/kurzak_keyboard.srcs/constrs_1/new/basys.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]

synth_design -top nidhogg -part xc7a35tcpg236-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef nidhogg.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file nidhogg_utilization_synth.rpt -pb nidhogg_utilization_synth.pb"
