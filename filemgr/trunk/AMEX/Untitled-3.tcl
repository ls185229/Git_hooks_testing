##### MOVE CONFIRMATION FILES TO ARCHIVE DIRECTORY #####

set file_is_there 0

if { [catch { set x [glob  $confirmation_filename  ] } result] } {
         puts "\n !!!!!! There are no confirmation files for AMEX in /clearing/filemgr/AMEX directory !!!!!!\n"
    } else {
          set file_is_there 1
    }

if {$file_is_there == 1 } {
   foreach file $x {
        set out_filename $file

        if { [catch {file copy $out_filename "$confirmation_archive_dir/$out_filename"} result ] } {
            puts "err returned: $result"
            puts "\n file copy of $out_filename to $confirmation_archive_dir/$out_filename FAILED \n"
           } else {
            puts "\n file copy of $out_filename to $confirmation_archive_dir/$out_filename successful \n"
            exec rm $out_filename
        }
    }
}