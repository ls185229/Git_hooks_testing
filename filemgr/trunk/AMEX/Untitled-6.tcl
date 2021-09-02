##### MOVE CHARGEBACK FILES TO DNLOAD DIRECTORY #####

set file_is_there 0

if { [catch { set x [glob  $chgback_filename  ] } result] } {
         puts "\n !!!!!! There are no chargeback files for AMEX in /clearing/filemgr/AMEX directory !!!!!!\n"
    } else {
          set file_is_there 1
    }

if {$file_is_there == 1 } {
   foreach file $x {
        set out_filename $file

        if { [catch {file copy $out_filename "$chgback_dnload_dir/$out_filename.$filedate"} result ] } {
            puts "err returned: $result"
            puts "\n file copy of $out_filename to $chgback_dnload_dir/$out_filename.$filedate FAILED \n"
           } else {
            puts "\n file copy of $out_filename to $chgback_dnload_dir/$out_filename.$filedate successful \n"
            exec rm $out_filename
        }
    }
}