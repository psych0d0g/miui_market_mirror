#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use JSON;
use DBI;
use Config::Tiny;
use Data::Dumper;
use File::Basename;
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

my $i = 0;

my $ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->env_proxy;

my $dbh = DBI->connect("DBI:mysql:$Config->{mysql}->{db}", $Config->{mysql}->{user}, $Config->{mysql}->{pass}
	           ) || die "Could not connect to database: $DBI::errstr";

foreach my $category ( @categorys ) {
	while ( 1 ) {
		my $response = $ua->get("http://market.xiaomi.com/thm/list?category=$category&sortby=New&start=$i&count=1");
		if ($response->is_success) {
			my $json = decode_json $response->decoded_content;  # or whatever
			$i++;
			for my $item( @{$json->{$category}} ){
				my $sth = $dbh->prepare("SELECT moduleType,frontCover FROM list WHERE moduleType='$item->{moduleType}' AND frontCover='$item->{frontCover}'");
				$sth->execute();
				my $dubl_check = $sth->fetchrow_hashref();
				if ( defined $dubl_check->{frontCover} ) {
					print "[". $i . "] Item Already imported into database, skipping...\n";
				} else {
					$dbh->do("INSERT INTO list (name, moduleId, fileSize, moduleType, assemblyId, frontCover, playTime)
				   VALUES('$item->{name}','$item->{moduleId}','$item->{fileSize}','$item->{moduleType}','$item->{assemblyId}','$item->{frontCover}','$item->{playTime}')");
					print "[" . $i . "]";
					print $item->{frontCover} . " Imported as ";
					print $item->{moduleType} . "\n";
				}
			};
			if (scalar(@{$json->{$category}})<=0) {
				last;
			}
		} else {
			$dbh->disconnect();
			die $response->status_line;
		}
	}
}

$dbh->disconnect();
