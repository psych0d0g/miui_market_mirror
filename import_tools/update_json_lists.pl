#!/usr/bin/perl

#    This script parses json from xiaomi and puts stuff it parsed into a mysql database
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
use LWP::UserAgent;
use JSON;
use DBI;
use Config::Tiny;
use Data::Dumper;
use File::Basename;

my $ua = LWP::UserAgent->new;

my $dirname = dirname(__FILE__);

my $Config = Config::Tiny->read( $dirname.'/config.cfg' ) or die "you must first create a config.cfg \nyou can use the config.dist.cfg as a starting point \n".Config::Tiny->errstr;

my @categorys = (
        "Compound",
        "LockStyle",
        "Launcher",
        "Clock",
        "PhotoFrame",
        "Icon",
        "StatusBar",
        "Mms",
        "Contact",
        "BootAnimation",
        "WallpaperUnion",
        "RingtoneUnion",
);

# Set the start ID for UserAgent handler to grab from xiaomi servers
# for debugging you can set this pretty high
my $i = 0;

# How many items to get each request (50 is hardlimit by xiaomi server)
my $count = 10;

# Variable used for item numbering
my $itemNum = 0;

# Setup some values for UserAgent
# Timeout reasonably high for the crappy China Uplink.
$ua->timeout(30);

# Use a system wide Proxy-Server if configured
$ua->env_proxy;

# Connect to Database-Server
my $dbh = DBI->connect("DBI:mysql:$Config->{mysql}->{db}", $Config->{mysql}->{user}, $Config->{mysql}->{pass}
                   ) || die "Could not connect to database: $DBI::errstr";

# Loop through the category Array
foreach my $category ( @categorys ) {
	# Which we are working on this category loop forever until we come accross a defined breakpoint
        while ( 1 ) {
		# prepare UserAgent handler to get the json stuff
                my $response = $ua->get("http://market.xiaomi.com/thm/list?category=$category&sortby=New&start=$i&count=$count");
		# only continue if we recive 200 / 302 or similar http header code
                if ($response->is_success) {
			# Use decode_json from the JSON module to parse the json into a array of hashes of arrays *HOLYFUCK*
                        my $json = decode_json $response->decoded_content;  # or whatever
			# Count the item numbers and give the item ID we are currently to our UserAgent handler so it can get the next item from xiaomi servers
                        $i = $i+$count;
                        for my $item( @{$json->{$category}} ){
				$itemNum++;
                                my $sth = $dbh->prepare("SELECT moduleType,frontCover FROM list WHERE moduleType='$item->{moduleType}' AND frontCover='$item->{frontCover}'");
                                $sth->execute();
                                my $dubl_check = $sth->fetchrow_hashref();
                                if ( defined $dubl_check->{frontCover} ) {
                                        print "[ITEM-LIST][". $itemNum . "][". $item->{assemblyId} ."] Item Already imported into database, skipping...\n";
                                } else {
                                        $dbh->do("INSERT INTO list (name, moduleId, fileSize, moduleType, assemblyId, frontCover, playTime)
                                   VALUES('$item->{name}','$item->{moduleId}','$item->{fileSize}','$item->{moduleType}','$item->{assemblyId}','$item->{frontCover}','$item->{playTime}')");
                                        print "[ITEM-LIST][" . $itemNum . "]";
                                        print $item->{frontCover} . " Imported as ";
                                        print $item->{moduleType} . "\n";
                                }
                                my $responseImage = $ua->get("http://market.xiaomi.com/thm/details/$item->{assemblyId}");
                                if ($responseImage->is_success) {
                                        my $jsonImage = decode_json $responseImage->decoded_content;
                                        print Dumper( $jsonImage );
                                }

                        };
                        if (scalar(@{$json->{$category}})<=0) {
                                $i = 0;
                                last;
                        }
                } else {
                        $dbh->disconnect();
                        die $response->status_line;
                }
        }
}

$dbh->disconnect();

