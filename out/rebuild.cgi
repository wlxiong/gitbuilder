#!/usr/bin/perl -w
use strict;
use CGI::Pretty qw/:standard/;
use lib ".";
use Autobuilder;

my $branch = param('branch');
my $commit = param('rebuild');
$commit =~ s/[^0-9A-Za-z]/_/g;
$commit =~ s/^\./_/;

unless (-f "pending/$commit") {
    my $autobuilder = "/home/root1/autobuilder";
    system("nohup sudo $autobuilder/start build sha1 $commit $branch > /dev/null 2>&1 < /dev/null &");
}

print redirect(-location=>".");
