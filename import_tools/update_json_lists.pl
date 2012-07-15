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

# Initialization of some basic stuff
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

my $itemNum = 0;

##################################################
# Actually Configurable stuff goes after this line
##################################################

# Set the start ID for UserAgent handler to grab from xiaomi servers
# for debugging you can set this pretty high
my $i = 0;

# How many items to get each request (50 is hardlimit by xiaomi server)
my $count = 50;

# Setup some values for UserAgent
# Timeout reasonably high for the crappy China Uplink.
$ua->timeout(30);

###################################################
# Dont touch anything beyond this line unless you know what i was and you are about to be doing ;)
###################################################

# Use a system wide Proxy-Server if configured
$ua->env_proxy;

# Connect to Database-Server
my $dbh = DBI->connect("DBI:mysql:$Config->{mysql}->{db}", $Config->{mysql}->{user}, $Config->{mysql}->{pass}
                   ) || die "Could not connect to database: $DBI::errstr";

# Loop through the category Array
foreach my $category ( @categorys ) {
	# Which we are working on this category loop forever until we come accross a defined breakpoint
        while ( 1 ) {
                print "[ITEM-LIST] Fetching new JSON data from server...\n";
		# prepare UserAgent handler to get the json stuff
                my $response = $ua->get("http://market.xiaomi.com/thm/list?category=$category&sortby=New&start=$i&count=$count");
		# only continue if we recive 200 / 302 or similar http header code
                if ($response->is_success) {
			# Use decode_json from the JSON module to parse the json into a array of hashes of arrays *HOLYFUCK*
                        my $json = decode_json $response->decoded_content;  # or whatever
			# Count the item numbers and give the item ID we are currently to our UserAgent handler so it can get the next item from xiaomi servers
                        $i = $i+$count;
			# Loop through every single item recived in the JSON data
                        for my $item( @{$json->{$category}} ){
				$itemNum++;
				# prepare Mysql query which is used to check for data which already was importet effectively preventing dublicates in our local mysql database
                                my $sth = $dbh->prepare("SELECT moduleType,frontCover FROM list WHERE moduleType='$item->{moduleType}' AND frontCover='$item->{frontCover}'");
                                $sth->execute();
                                my $dubl_check = $sth->fetchrow_hashref();
				# if we already have this entry in our DB, do nothing but notify the user about it
                                if ( defined $dubl_check->{frontCover} ) {
                                        print "[ITEM-LIST][". $itemNum . "][". $item->{moduleId} ."] Item Already imported into database, skipping...\n";
				# else import the item with all important values to our items table and tell the user about this aswell
                                } else {
                                        $dbh->do("INSERT INTO list (name, moduleId, fileSize, moduleType, assemblyId, frontCover, playTime)
                                   VALUES('$item->{name}','$item->{moduleId}','$item->{fileSize}','$item->{moduleType}','$item->{assemblyId}','$item->{frontCover}','$item->{playTime}')");
                                        print "[ITEM-LIST][" . $itemNum . "]";
                                        print $item->{frontCover} . " Imported as ";
                                        print $item->{moduleType} . "\n";
                                }

				# check for details and import them aswell but into a diffrent table [WORK IN PROGRESS]
                                my $responseImage = $ua->get("http://market.xiaomi.com/thm/details/$item->{moduleId}");
                                if ($responseImage->is_success) {
                                        my $jsonImage = decode_json $responseImage->decoded_content;
					my $mysqlRefId = $jsonImage->{"moduleId"};
                                	for my $image( @{$jsonImage->{"snapshotsUrl"}} ){
						my $sth2 = $dbh->prepare("SELECT moduleId,snapshotsUrl FROM images WHERE moduleId='$mysqlRefId' AND snapshotsUrl='$image'");
						$sth2->execute();
						my $dubl_check_Images = $sth2->fetchrow_hashref();
						# if we already have this entry in our DB, do nothing but notify the user about it
                        		        if ( defined $dubl_check_Images->{"snapshotsUrl"} ) {
                                		        print "[ITEM-IMAGE][". $itemNum . "][". $image ."] Image Already imported into database, skipping...\n";
                                		# else import the item with all important values to our items table and tell the user about this aswell
                                		} else {
							$dbh->do("INSERT INTO images (moduleId, snapshotsUrl) VALUES('$mysqlRefId','$image')");
		                                        print "[ITEM-IMAGE][" . $itemNum . "]";
                		                        print $image . " Imported for Item ";
                        		                print $mysqlRefId . "\n";
						}

					}
                                }

                        };
			# If we get an empty json result we probably reached the end of available data for this category, so switch to the next and start from 0
                        if (scalar(@{$json->{$category}})<=0) {
                                $i = 0;
				$itemNum = 0;
				print "[ITEM-LIST] Last json response was empty, assuming ". $category ." is completely in sync.\n";
				print "[ITEM-LIST][". $category ."] Complete, Switching to next Category\n";
                                last;
                        }
		# Let the script die with an error code when the UserAgent response code indicates a failure in getting the JSON data
		# also close the mysql connection
                } else {
                        $dbh->disconnect();
                        die $response->status_line;
                }
        }
}
# Close the mysql connection after we've imported everything
$dbh->disconnect();

