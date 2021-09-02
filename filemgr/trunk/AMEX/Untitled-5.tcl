##### MOVE INQUIRY FILES TO DNLOAD DIRECTORY #####

set file_is_there 0

if { [catch { set x [glob  $inquiry_filename  ] } result] } {
         puts "\n !!!!!! There are no inquiry files for AMEX in /clearing/filemgr/AMEX directory !!!!!!\n"
    } else {
          set file_is_there 1
    }

if {$file_is_there == 1 } {
   foreach file $x {
        set out_filename $file

        if { [catch {file copy $out_filename "$inquiry_dnload_dir/$out_filename.$filedate"} result ] } {
            puts "err returned: $result"
            puts "\n file copy of $out_filename to $inquiry_dnload_dir/$out_filename.$filedate FAILED \n"
           } else {
            puts "\n file copy of $out_filename to $inquiry_dnload_dir/$out_filename.$filedate successful \n"
            exec rm $out_filename
        }
   }
}