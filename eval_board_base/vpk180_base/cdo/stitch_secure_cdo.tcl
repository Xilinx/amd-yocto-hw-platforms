# Copy the sysmon secure CDO to hw project root (if present)

puts "Executing POST device image TCL"
if { [file exists ../../../../cdo/secio-sysmon.v4.cdo] == 1 } {
   puts "Copying Sysmon Secure CDO to Project"
   file copy -force ../../../../cdo/secio-sysmon.v4.cdo ../../.
}

# Apply overlay CDO for secure sysmon usecase (if present)
if { [file exists ../../secio-sysmon.v4.cdo] == 1 } {
    puts "######### Regenerating PDI with overlay CDO applied #########"
    puts "CWD '[pwd]'"
    puts "Running '[exec which bootgen] -arch versal -image edf_base_pl_wrapper_boot.bif -w -o ./edf_base_pl_wrapper_boot.pdi -overlay_cdo ./hw_project/secio-sysmon.v4.cdo'"
    exec mv ./edf_base_pl_wrapper_boot.pdi ./edf_base_pl_wrapper_boot.pdi.orig
    exec [exec which bootgen] -arch versal -image edf_base_pl_wrapper_boot.bif -w -o ./edf_base_pl_wrapper_boot.pdi -overlay_cdo ../../secio-sysmon.v4.cdo
}

