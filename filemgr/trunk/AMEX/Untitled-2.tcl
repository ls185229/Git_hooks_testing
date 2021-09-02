##### MOVE MERCHANT RESPONSE FILES TO RESPONSE DIRECTORY #####

set file_is_there 0

if { [catch { set x [glob  $spor_filename  ] } result] } {
         puts "\n !!!!!! There are no sponsered merchant response files for AMEX in /clearing/filemgr/AMEX directory !!!!!!\n"
    } else {
          set file_is_there 1
    }

if {$file_is_there == 1 } {
   foreach file $x {
        set out_filename $file

        if { [catch {file copy $out_filename "$spmerchant_response_dir/$out_filename.$filedate"} result ] } {
            puts "err returned: $result"
            puts "\n file copy of $out_filename to $spmerchant_response_dir/$out_filename.$filedate FAILED \n"
           } else {
            puts "\n file copy of $out_filename to $spmerchant_response_dir/$out_filename.$filedate successful \n"
            exec rm $out_filename
        }
    }
}