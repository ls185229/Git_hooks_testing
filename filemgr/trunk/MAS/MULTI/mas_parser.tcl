#!/usr/bin/env tclsh
#$Id: mas_parser.tcl 3817 2016-06-29 21:21:44Z bjones $
# Script is used to create a mas file dump

proc unoct {s} {
    set u >[string trimleft $s 0]
    if {$u == ""} {
        return 0
    } else {
        return $u
    }
};# end unoct


#    puts ": >[string range $line_in ]<"


proc file_header_rec {line_in} {
    puts "File Header Record"
    puts "    tran_type:         >[string range $line_in 0  1]<"
    puts "    file_type:         >[string range $line_in 2  3]<"
    puts "    file_date_time:    >[string range $line_in 4  19]<"
    puts "    activity_source:   >[string range $line_in 20  35]<"
    puts "    activity_job_name: >[string range $line_in 36 43]<"
    puts "    suspend_level:     >[string range $line_in 44 45]<\n\n"
};# end file_header_rec



proc batch_header_rec {line_in} {
    puts "Batch Header Record"
    puts "    tran_type:         >[string range $line_in 0  1]<"
    puts "    batch_curr:        >[string range $line_in 2  4]<"
    puts "    activity_date_time:>[string range $line_in 5  20]<"
    puts "    merchantId:        >[string range $line_in 21 50]<"
    puts "    inBatchNbr:        >[string range $line_in 51 59]<"
    puts "    inFileNbr:         >[string range $line_in 60 68]<"
    puts "    billInd:          >[string range $line_in 68    69]<"
    puts "    orig_batch_id:    >[string range $line_in 70    78]<"
    puts "    orig_file_id:     >[string range $line_in 79    87]<"
    puts "    ext_batch_id:     >[string range $line_in 88    112]<"
    puts "    ext_file_id:      >[string range $line_in 113    137]<"
    puts "    sender_id:        >[string range $line_in 138    162]<"
    puts "    microfilm_nbr:    >[string range $line_in 163    192]<"
    puts "    institution_id:   >[string range $line_in 193    202]<"
    puts "    batch_capture_dt: >[string range $line_in 203    203]<\n\n"
};# end batch_header_rec



proc detail_rec {line_in}  {
    puts "Detail Record"
    puts "    trans_type:        >[string range    $line_in    0    1      ]<"
    puts "    trans_id:          >[string range    $line_in    2    13     ]<"
    puts "    entity_id:         >[string range    $line_in    14    31    ]<"
    puts "    card_scheme:       >[string range    $line_in    32    33    ]<"
    puts "    mas_code:          >[string range    $line_in    34    58    ]<"
    puts "    mas_code_downgrade:>[string range    $line_in    59    83    ]<"
    puts "    nbr_of_items:      >[string range    $line_in    84    93    ]<"
    puts "    amt_original:      >[string range    $line_in    94    105   ]<"
    puts "    add_cnt1:          >[string range    $line_in    106    115  ]<"
    puts "    add_amt1:          >[string range    $line_in    116    127  ]<"
    puts "    add_cnt2:          >[string range    $line_in    128    137  ]<"
    puts "    add_amt2:          >[string range    $line_in    138    149  ]<"
    puts "    external_trans_id: >[string range    $line_in    150    174  ]<"
    puts "    trans_ref_data:    >[string range    $line_in    175    199  ]<"
    puts "    suspend_reason:    >[string range    $line_in    200    201  ]<\n\n"
};# end detail_rec


proc batch_trailer_rec {line_in} {
    puts "Batch Trailer Record"
    puts "    trans_type:        >[string range $line_in 0    1]<"
    puts "    batch_amt:         >[string range $line_in 2    13]<"
    puts "    batch_cnt:         >[string range $line_in 14    23]<"
    puts "    batch_add_amt1:    >[string range $line_in 24    35]<"
    puts "    batch_add_cnt1:    >[string range $line_in 36    45]<"
    puts "    batch_add_amt2:    >[string range $line_in 46    57]<"
    puts "    batch_add_cnt2:    >[string range $line_in 58    67]<\n\n"
};# end batch_trailer_rec



proc file_trailer_rec {line_in} {
    puts "File Trailer Record"
    puts "    trans_type:    >[string range  $line_in    0   1]<"
    puts "    file_amt:      >[string range  $line_in    2   13]<"
    puts "    file_cnt:      >[string range  $line_in    14  23]<"
    puts "    file_add_amt1: >[string range  $line_in    24  35]<"
    puts "    file_add_cnt1: >[string range  $line_in    36  45]<"
    puts "    file_add_amt2: >[string range  $line_in    46  57]<"
    puts "    file_add_cnt2: >[string range  $line_in    58  67]<\n\n"
};# end file_trailer_rec

#****** Main Code ******
if {$argc != 1} {
	error "Usage: mas_parser.tcl filename"
}

set input_file [open [lindex $argv 0] r]

while {[gets $input_file line] >=0} {
    set rec_type [string range $line 0 1]

    switch $rec_type {
        "FH" {file_header_rec $line}
        "BH" {batch_header_rec $line}
        "01" {detail_rec $line} 
        "BT" {batch_trailer_rec $line}
        "FT" {file_trailer_rec $line}
        default { puts "Unknown record type - $rec_type"}
        }
}

close $input_file
puts "\nScript mas_parser.tcl complete\n\n"

exit 0
