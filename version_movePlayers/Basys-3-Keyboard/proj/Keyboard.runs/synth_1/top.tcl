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
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/__Programowanie__/Vivado/PrzemyslawKurzak/Projekt_keyboard/Basys-3-Keyboard/proj/Keyboard.cache/wt [current_project]
set_property parent.project_path C:/__Programowanie__/Vivado/PrzemyslawKurzak/Projekt_keyboard/Basys-3-Keyboard/proj/Keyboard.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property board_part digilentinc.com:basys3:part0:1.1 [current_project]
set_property ip_repo_paths c:/__Programowanie__/Vivado/PrzemyslawKurzak/Projekt_keyboard/Basys-3-Keyboard/repo [current_project]
set_property ip_output_repo c:/__Programowanie__/Vivado/PrzemyslawKurzak/Projekt_keyboard/Basys-3-Keyboard/repo/cache [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  C:/__Programowanie__/Vivado/PrzemyslawKurzak/Projekt_keyboard/Basys-3-Keyboard/src/hdl/PS2Receiver.v
  C:/__Programowanie__/Vivado/PrzemyslawKurzak/Projekt_keyboard/Basys-3-Keyboard/src/hdl/bin2ascii.v
  C:/__Programowanie__/Vivado/PrzemyslawKurzak/Projekt_keyboard/Basys-3-Keyboard/src/hdl/debouncer.v
  C:/__Programowanie__/Vivado/PrzemyslawKurzak/Projekt_keyboard/Basys-3-Keyboard/src/hdl/uart_buf_con.v
  C:/__Programowanie__/Vivado/PrzemyslawKurzak/Projekt_keyboard/Basys-3-Keyboard/src/hdl/uart_tx.v
  C:/__Programowanie__/Vivado/PrzemyslawKurzak/Projekt_keyboard/Basys-3-Keyboard/src/hdl/top.v
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/__Programowanie__/Vivado/PrzemyslawKurzak/Projekt_keyboard/Basys-3-Keyboard/src/constraints/Basys3_Master.xdc
set_property used_in_implementation false [get_files C:/__Programowanie__/Vivado/PrzemyslawKurzak/Projekt_keyboard/Basys-3-Keyboard/src/constraints/Basys3_Master.xdc]


synth_design -top top -part xc7a35tcpg236-1 -flatten_hierarchy none -directive RuntimeOptimized -fsm_extraction off


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef top.dcp
