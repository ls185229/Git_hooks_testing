proc log_msg {msg msgtype} {
  # msgtype: N = Normal W = Warning E = Error D = Debug
  global log_fd debugmode warnings
  switch $msgtype {
    "W" {
      set msg "WARNING: $msg"
    }
    "E" {
      set msg "ERROR: $msg"
    }
    "D" {
      set msg "DEBUG: $msg"
    }
  }
  if {$debugmode == 1} {
    puts $msg
  }
  if {[info level] == 1} {
    set caller MAIN
  } else {
    set caller [lrange [info level -1] 0 0]
  }
  if {[info exists log_fd]} {
    puts $log_fd "[clock format [clock seconds] -format %Y%m%d%H%M%S] $caller - $msg"
    flush $log_fd
  }
  if {$msgtype == "W"} {
    append warnings "$msg\n"
  }
}
