#!/usr/bin/env perl -w
use FileHandle;
use IO::Dir;
use File::stat;
use Fcntl ':mode';
use strict;

sub main {
    my ($mod, $file);

    $mod = shift(@ARGV);

    foreach $file (@ARGV) {
    &mangle_file ($file, $mod);
    }
}

sub mangle_file {
    my ($file, $mod) = @_;
    my ($fh, @lines, $lines, $new_lines, $changed);

    $fh = new FileHandle;
    $fh->open($file, "r");

    @lines = $fh->getlines();
    $fh->close();
    $lines = join("", @lines);

    $new_lines = $lines;
    eval "\$changed = (\$new_lines =~ $mod)"; die $@ if $@;

    if ($changed) {
    $fh = new FileHandle;
    $fh->open($file, "w");
    $fh->print($new_lines);
    $fh->close();
    }
}

main();
