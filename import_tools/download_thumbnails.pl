#!/usr/bin/perl

use strict;
use warnings;
use Config::Tiny;
use DBI;

my $Config = Config::Tiny->read( 'config.cfg' ) or die "you must first create a config.cfg \nyou can use the config.dist.cfg as a starting point \n";

my $dbh = DBI->connect("DBI:mysql:$Config->{mysql}->{db}", $Config->{mysql}->{user}, $Config->{mysql}->{pass}
	           ) || die "Could not connect to database: $DBI::errstr";

my $sth = $dbh->prepare('select id, frontCover from list')
    || die "$DBI::errstr";
$sth->execute();

# Print number of rows found
if ($sth->rows < 0) {
    print "Sorry, no domains found.\n";
} else {
    # Loop if results found
    while (my $results = $sth->fetchrow_hashref) {
        my $hashofimage = $results->{frontCover}; # get the domain name field
        print $hashofimage."\n";
    }
}

# Disconnect
$sth->finish;
$dbh->disconnect;
