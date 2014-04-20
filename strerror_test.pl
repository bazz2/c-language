#!/usr/bin/perl 
# run the followed command in console:
# perl -MPOSIX -e 'print strerror(3)."\n";'

use POSIX;
my $str = strerror(1)."\n";
print $str;
