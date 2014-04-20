#!/usr/bin/perl
#

for (1 .. 2) {
	$! = $_;
	$str = $!;
	printf " \$!: %d => %s\n", $!, $!;
	printf " \$str: %d => %s\n", $str, $str;
}

#$! = 3;
#$string = $!;
#printf "%d => %s\n", $string, $string;
