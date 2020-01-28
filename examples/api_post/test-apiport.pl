#!/usr/bin/perl

use lib $ENV{IPMS_HOME}.'/lib';
use IPMS qw(get_apihostport);


my ($host,$port) = &get_apihostport;

print "host: $host\n";
print "port: $port\n";
exit $?;
1;
