#!/usr/bin/perl 

my $str = `lvcreate -S cow -L1G -s /dev/VG-8G/base`;
print "lvcreate *-cdpstore: ".$str."\n";
$str = `lvcdpmark -c /dev/VG-8G/base`;
print "lvcdpmark: ".$str."\n";
#$str = `lvcreate -n snap0 --snapid 0 -s /dev/VG-8G/base`;
#print "lvcreate snapshot volume: ".$str."\n";
#$str = `lvremove /dev/VG-8G/base-cdpstore`;
