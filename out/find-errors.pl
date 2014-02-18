#!/usr/bin/perl -w
use strict;

use lib ".";
use Autobuilder;

my $commit = $ARGV[0];
my ($warnmsg, $errs) = find_errors($commit);
print "$warnmsg\n";
if ($warnmsg eq "ok") {
    exit 0;
} else {
    exit 1;
}
