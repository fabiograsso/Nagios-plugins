#!/usr/bin/perl -w
use Getopt::Long;

# comando: snmpwalk -v 1 -c public 192.168.2.1 .1.3.6.1.4.1.9.9.23.1.2.1.1.6 -Ov

my $o_host;
my $o_number=1;
my $o_community;
my $o_neigh;

GetOptions(
      'H:s'     => \$o_host,
      'C:s'     => \$o_community,
      'S:s'     => \$o_neigh,
      'N:i'	=> \$o_number,
);

if(!$o_host || !$o_community || !$o_neigh ){
	print "\n\ncheck_snmp_cdp.pl Version 0.1 beta\n\n";
	print "Copyright (C) 2010 Fabio Grasso - fabio.grasso\@gmail.com\n";
	print "www.itatis.net\n\n";
	print "Usage:\n";
	print "./check_snmp_cdp.pl -H [hostname/IP] -C [community] -S [neighbor name] -N [count]\n\n";
	print "-N is optional. Default value -N 1\n\n";
	print "Plugin output:\n";
	print "- OK: CDP Neighbor present and path full redundant\n";
	print "- WARNING: path not redundant\n";
	print "- CRITICAL: Neighbor not prsent\n\n";
	print "This version works only with SNMP v1";
	exit(3);
}

$count=`snmpwalk -v 1 -c $o_community $o_host .1.3.6.1.4.1.9.9.23.1.2.1.1.6 -Ov | grep -ic $o_neigh`;

chomp $count;


if($count == 0){
	print "CRITICAL! Neighbor ".$o_neigh." not present.\n";
	exit(2);
}

if($o_number == $count){
	print "OK! Neighbor ".$o_neigh." present with ".$count." path.\n";
	exit(0);
}
elsif($o_number != $count){
	print "WARNING! Neighbor ".$o_neigh." present but fault redundancy (".$count." instead of ".$o_number.")\n";
	exit(1);
}

print "UNKNOW STATUS!";

exit(3);


