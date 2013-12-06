#!/usr/bin/perl -w
use strict;
use CGI::Pretty qw/:standard/;
use lib ".";
use Autobuilder;

my $commit = param('log');
$commit =~ s/[^0-9A-Za-z]/_/g;
$commit =~ s/^\./_/;

my $fn;
foreach $fn ("fail/$commit", "pass/$commit") {
    if (-f $fn) {
        unlink($fn);
    }
}
unless (-f "pending/$commit") {
    system("touch pending/$commit");
    system("../start > /dev/null 2>&1 &");
}

print redirect(-location=>".");
