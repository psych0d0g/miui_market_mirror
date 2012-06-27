#!/usr/bin/perl

use strict;
use warnings;
use DBI;

require "config.pl";

my $dbh = DBI->connect('DBI:mysql:$mysql_db", $mysql_user, $mysql_pass
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
