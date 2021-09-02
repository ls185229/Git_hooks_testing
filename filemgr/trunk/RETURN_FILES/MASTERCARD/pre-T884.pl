#!/usr/bin/env perl -w

# $Id: pre-T884.pl 927 2010-02-01 17:54:37Z ssimpson $

$infile = $ARGV[0];
open(F, "+<", $infile) or die "can't read $infile: $!";
$out = "";


# read through each line
# strip out lines meeting the NO ACTIVITY and anything with at least 2 spaces and nothing else at beginning of the line
# append substitution results in $out
# right now, as a kludge, I'm specifying the 2 digit year as the initial anchor for the regex
# this will cover 2010 and 2011
# I'm looking for a more permanent solution for later.
while (<F>) {
    s/^10.+NO ACTIVITY*//g;
    s/^11.+NO ACTIVITY*//g;
    s/^ [ ]*//g;
    $out .= $_;
}

# at this point, we have the modified file contents in memory
# seek back to the beginning of the file
# write the contents back to the file and truncate any remainder past the new contents
seek(F,0,0) or die "can't seek back to start of $infile: $!";
print F $out or die "can't print to $infile: $!";
truncate(F, tell(F)) or die "can't truncate $infile: $!";
close(F) or die "can't close to $infile: $!";


