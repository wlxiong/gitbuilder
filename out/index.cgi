#!/usr/bin/perl -w
use strict;
use CGI qw/:standard *table start_ul start_div end_div/;
use POSIX qw(strftime);

use lib ".";
use Autobuilder;

my @branches = ();
my %revs = ();

sub load_revcache()
{
    open my $fh, "<revcache" 
        or return; # try to survive without it, then
    my $branch;
    my @list;
    while (<$fh>) {
	chomp;
	if (/^\:(.*)/) {
	    my ($topcommit, $newbranch) = split(" ", $1, 2);
	    if ($branch) {
		$revs{$branch} = join("\n", @list);
	    }
	    push @branches, "$topcommit $newbranch";
	    $branch = $newbranch;
	    @list = ();
	} else {
	    push @list, $_;
	}
    }
    if ($branch) {
	$revs{$branch} = join("\n", @list);
    }
    close $fh;
}
load_revcache();

my $currently_doing = (-f '.doing') && stripwhite(catfile(".doing")) || "";

sub run_cmd(@)
{
    my @cmdline = @_;
    
    open(my $fh, "-|", @cmdline)
      or die("Can't run $cmdline[0]: $!\n");
    my @out = <$fh>;
    chomp @out;
    close $fh;
    return @out;
}

sub revs_for_branch($)
{
    my $branch = shift;
    if (-x '../revlist.sh') {
	return run_cmd("../revlist.sh", $branch);
    } else {
	return split("\n", $revs{$branch});
    }
}

sub _list_branches()
{
    if (-x '../branches.sh') {
	return run_cmd("../branches.sh", "-v");
    } else {
	return @branches;
    }
}


sub list_branches()
{
    my @out = ();
    foreach my $line (_list_branches())
    {
        my ($commit, $branch) = split(" ", $line, 2);
        my $branchword = $branch;
        next if $branchword =~ /@/;
        $branchword =~ s{^.*/}{};
        push @out, "$branchword $branch $commit";
    }
    return @out;
}

my $gcc_version=`gcc --version | head -n 1 | awk \'{ print \$3 }\'`;
my $centos_version=`cat /etc/redhat-release`;
my $title = "Autobuilder on " . $centos_version . " using gcc " . $gcc_version;
my $project_name = project_name();
if ($project_name) {
    $title .= " for $project_name";
}

print header(-type => 'text/html; charset=utf-8'),
      start_html(
	-title => $title,
	-style => {-src => "index.css"}
);

print Link({-rel=>"alternate", -title=>$title,
	-href=>"rss.cgi", -type=>"application/rss+xml"});

print div({-class=>"logo"}, "compiled by ",
    a({-href=>"http://github.com/apenwarr/gitbuilder/"},
      "<b>git</b>builder"));

print h1($title,
    a({-href=>"rss.cgi",-title=>"Subscribe via RSS"},
      img({-src=>"feed-icon-28x28.png",-alt=>"[RSS]"})),
);

my @branchlist = list_branches();

sub branch_age($)
{
    my ($branchword, $branch, $topcommit) = split(" ", shift, 3);
    if (-f "fail/$topcommit") {
        return -M "fail/$topcommit";
    } elsif (-f "pass/$topcommit") {
        return -M "pass/$topcommit";
    } else {
        return -1;
    }
}

sub fixbranchprint($)
{
    my $branchprint = shift;
    $branchprint =~ s{^origin/}{};
    $branchprint =~ s{(.*/?)(.*)}{$1<b>$2</b>};
    return $branchprint;
}

sub status_to_statcode($)
{
    my $status = shift;
    if (!defined($status)) {
	return "pending";
    } elsif ($status eq "ok") {
        return "ok";
    } elsif ($status eq "BUILDING") {
        return "pending";
    } elsif ($status eq "(Pending)") {
        return "pending";
    } elsif ($status =~ m{^W[^/]*$}) {
        return "warn";
    } else {
        # some kind of FAIL marker by default
        return "err";
    }
}

print start_div({id=>"most_recent"}),
    "Most Recent:",
    start_ul({id=>"most_recent_list"});
for my $bpb (sort { branch_age($a) <=> branch_age($b) } @branchlist) {
    my ($branchword, $branch, $topcommit) = split(" ", $bpb, 3);
    my $branchprint = fixbranchprint($branch);
    my $fn;
    
    next if (-f "ignore/$topcommit");
    
    my ($warnmsg, $errs) = find_errors($topcommit);
    my $statcode = status_to_statcode($warnmsg);
    print li(a({href=>"#$branch"}, 
        span({class=>"status branch status-$statcode"}, $branchprint)));
    
    last if (branch_age($bpb) > 30);
}
print end_ul, end_div;


print start_table({class=>"results",align=>"center"});
print Tr({class=>"resultheader"},
    th({style=>'text-align: right'}, "Branch"),
    th("Status"), th("Commit"), th("Who"), th("Result"), th("Comment"));
    
sub spacer()
{
    return Tr({class=>"spacer"}, td({colspan=>6}, ""));
}

my $last_ended_in_spacer = 0;
for my $bpb (sort { lc($a) cmp lc($b) } @branchlist) {
    our ($branchword, $branch, $topcommit) = split(" ", $bpb, 3);
    our $branchprint = fixbranchprint($branch);

    our $last_was_pending = 0;
    our $print_pending = 1;
    
    my @branchout = ();
    
    sub do_pending_dots(\@)
    {
        my $_branchout = shift;
	if ($last_was_pending > $print_pending) {
	    $last_was_pending -= $print_pending;
	    $print_pending = 0;
	    push @{$_branchout}, Tr(
	        td($branchprint),
		td({class=>"status"}, "...$last_was_pending..."),
		td(""), td(""), td(""));
	    $branchprint = "";
	}
	$last_was_pending = 0;
    }
    
    foreach my $rev (revs_for_branch($branch)) {
	my ($commit, $email, $comment) = split(" ", $rev, 3);
	
	my $failed;
	my $logcgi = "log.cgi?type=build&log=$commit";
	my $shortbranch = `basename $branch`;
	my $rebuildcgi = "rebuild.cgi?branch=$shortbranch&rebuild=$commit";
	my $testlog = "log.cgi?type=test&log=$commit";
	my $version = `../get-version.sh $branch $commit`;
	my $nightly = "../nightly-build/gfs-bin-$version.tar.gz";
	$email =~ s/\@.*//;
	my $commitlink = commitlink($commit, shorten($commit, 7, ""));
	$comment =~ s/^\s*-?\s*//;
	
        sub pushrow(\@$$$$$$$$$)
        {
            my ($_branchout, $status, $commitlink,
                $email, $codestr, $comment, $logcgi, $testlog, $nightly, $rebuildcgi) = @_;
                
            my $statcode = status_to_statcode($status);
            
            do_pending_dots(@{$_branchout});
            push @{$_branchout},
                Tr({class=>"result"},
                    td({class=>"branch"},
                        $branchprint),
                    td({class=>"status status-$statcode"}, $status),
                    td({class=>"commit"}, $commitlink),
                    td({class=>"committer"}, $email),
                    td({class=>"details"},
                        a({class=>"hyper", name=>$branch}, "") . div(
                          span({class=>"link"},
                            $logcgi ? a({-href=>$logcgi}, 
				("$statcode" eq "ok") ? "Build" : $codestr) : $codestr,
                            ("$statcode" eq "ok" || "$statcode" eq "warn") ? "/ " .
                              a({-href=>$testlog}, "Test") : "",
                            ("$statcode" eq "ok" || "$statcode" eq "warn") ? "/ " .
                              a({-href=>$nightly}, "Nightly") : "")
                        )),
                    td({class=>"details"},
                          span({class=>"comment"}, "  " . $comment),
                          span({class=>"link"},
                              a({-href=>$rebuildcgi}, "[ Rebuild ]")))
                    );
            $branchprint = "";
        }
        
	if (-f "pass/$commit") {
	    $failed = 0;
	    # fall through
	} elsif (-f "fail/$commit") {
	    $failed = 1;
	    # fall through
	} elsif ($commit eq $currently_doing) {
	    # currently building this one
	    pushrow(@branchout, "BUILDING", 
	            $commitlink, $email, "build log", $comment, $logcgi, "", "", "");
	    next;
	} elsif ($print_pending && -f "pending/$commit") {
	    # first pending in a group: print (Pending)
	    pushrow(@branchout, "(Pending)",
	            $commitlink, $email, "", $comment, "", "", "", "");
	    next;
	} elsif ($print_pending) {
	    # first pending in a group: print (Pending)
	    pushrow(@branchout, "N/A",
	            $commitlink, $email, "", $comment, "", "", "", $rebuildcgi);
	    $last_was_pending++;
	    next;
	} else {
	    # no info yet: just count, don't print
	    $last_was_pending++;
	    next;
	}
	    
	my ($warnmsg, $errs) = find_errors($commit);
	my $status = ($warnmsg eq "ok") ? "ok" 
	    : ($warnmsg =~ /^Warnings\(\d+\)$/) ? "Warn" : "FAIL";
	pushrow(@branchout, $status,
		$commitlink, $email, $warnmsg, $comment, $logcgi, $testlog, $nightly, $rebuildcgi);
    }
    
    do_pending_dots(@branchout);
    
    if (@branchout > 1) {
        if (!$last_ended_in_spacer) {
            print spacer;
        }
        print @branchout, spacer;
        $last_ended_in_spacer = 1;
    } else {
        print @branchout;
        $last_ended_in_spacer = 0;
    }
}

print end_table();

my $server_time = `date +"%Y-%m-%d %T"`;
print div({class=>"update"}, "Server time: $server_time");
my $update_time = `tail -n 10 ../event_log | grep add | tail -n 1 | awk \'{ print \$1, \$2 }\'`;
print div({class=>"update"}, "Last build at: $update_time");
my $update_info = `sudo ../git-update.sh 2>&1`;
print div({class=>"update"}, "$update_info");

print div({class=>"extraspace"}, "&nbsp;");
print end_html;
exit 0;
