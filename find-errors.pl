#!/usr/bin/perl -w
use strict;

use lib "out/";
use Autobuilder;

my $commit = $ARGV[0];
my ($warnmsg, $errs) = find_errors($commit);
print "$warnmsg\n";
