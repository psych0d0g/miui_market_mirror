#!/usr/bin/perl

#    This script gets the thumbnail hashes from the database to be used within a for loop with wget
#    Copyright (C) 2012  Lukas W.
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation version 2 of the License.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

use strict;
use warnings;
use Config::Tiny;
use DBI;
use File::Basename;
my $dirname = dirname(__FILE__);

my $Config = Config::Tiny->read( $dirname.'/config.cfg' ) or die "you must first create a config.cfg \nyou can use the config.dist.cfg as a starting point \n".Config::Tiny->errstr;

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
