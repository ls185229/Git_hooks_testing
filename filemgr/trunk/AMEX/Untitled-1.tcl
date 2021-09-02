##### MOVE BIN FILES TO ARCHIVE DIRECTORY #####

set file_is_there 0

if { [catch { set x [glob  $bin_filename  ] } result] } {
         puts "\n !!!!!! There are no bin files for AMEX in /clearing/filemgr/AMEX directory !!!!!!\n"
    } else {
          set file_is_there 1
    }

if {$file_is_there == 1 } {
   foreach file $x {
        set out_filename $file

        if { [catch {file copy $out_filename "$bin_archive_dir/$out_filename.$filedate"} result ] } {
            puts "err returned: $result"
            puts "\n file copy of $out_filename to $bin_archive_dir/$out_filename.$filedate FAILED \n"
           } else {
            puts "\n file copy of $out_filename to $bin_archive_dir/$out_filename.$filedate successful \n"
            exec rm $out_filename
        }
    }
}