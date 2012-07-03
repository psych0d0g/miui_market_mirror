#!/usr/bin/perl -w

#    This script recives JAR files via post, patches them and repacks them into and android flashable update.zip
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
use CGI; # Modul fuer CGI-Programme
use Digest::MD5;
use IO::Handle;
my $io = IO::Handle->new();
$io->autoflush(1);
STDOUT->autoflush(1);

my $cgi = new CGI; # neues Objekt erstellen
my $ctx = Digest::MD5->new;
my $html_text;
my $upload_success;

# Content-type fuer die Ausgabe
print $cgi->header(-type => 'text/html');

# die datei-daten holen
my $file = $cgi->param("myfile");
$ctx->add($file);
my $digest = $ctx->hexdigest;

# dateinamen erstellen und die datei auf dem server speichern
my $fname = 'file_'.$digest;

if (!-e $fname) {
	open DAT,'>'.$fname or die 'Error processing file: ',$!;
	
	# Dateien in den Binaer-Modus schalten
	binmode $file;
	binmode DAT;

	my $data;
	while(read $file,$data,1024) {
		print DAT $data;
	}
	close DAT;
	$html_text = "$file successfully uploaded, we're now patching it... please stand by...";
	$upload_success = 1;
} else {
	$html_text = "file already uploaded by someone else, redirecting to patched update.zip";
	$upload_success = 0;
}

print <<"HTML";
<html>
<head>
<title>Fileupload</title>
</head>
<body bgcolor="#FFFFFF">
<p>
  $html_text
</p>
HTML

print ('
<textarea cols="150" rows="30">
');
if ($upload_success == 1) {
	system ('unzip', $fname, '-dworking');
	print ("Extracted JAR contents, now decompiling classes.dex\n");
	system ('baksmali', 'working/classes.dex');
        print ("Decompiled classes.dex, now patching market-URLs\n");
        system ('sed', '-i', 's/http:\/\/market.xiaomi.com\/thm\/config\/clazz\/%s\/zh-cn/http:\/\/market.s0uthp4rk.eu\/mobi\/categories.php?list=%s/g', 'out/miui/app/resourcebrowser/service/online/OnlineService.smali');
        system ('sed', '-i', 's/http:\/\/market.xiaomi.com\/thm\/details\/%s?/http:\/\/market.s0uthp4rk.eu\/mobi\/details.php?item=%s/g', 'out/miui/app/resourcebrowser/service/online/OnlineService.smali');
        system ('sed', '-i', 's/http:\/\/market.xiaomi.com\/thm\/download\/%s?/http:\/\/market.s0uthp4rk.eu\/mobi\/download.php?item=%s/g', 'out/miui/app/resourcebrowser/service/online/OnlineService.smali');
        system ('sed', '-i', 's/http:\/\/market.xiaomi.com\/thm\/list?category=%s\&sortby=%s\&start=%s\&count=%s/http:\/\/market.s0uthp4rk.eu\/mobi\/list.php?category=%s\&sortby=%s\&start=%s\&count=%s/g', 'out/miui/app/resourcebrowser/service/online/OnlineService.smali');
        system ('sed', '-i', 's/http:\/\/market.xiaomi.com\/thm\/search?category=%s\&sortby=%s\&start=%s\&count=%s\&keywords=%s/http:\/\/market.s0uthp4rk.eu\/mobi\/search.php?category=%s\&sortby=%s\&start=%s\&count=%s\&keywords=%s/g', 'out/miui/app/resourcebrowser/service/online/OnlineService.smali');
        system ('sed', '-i', 's/http:\/\/market.xiaomi.com\/thm\/checkupdate?fileshash=%s/http:\/\/market.s0uthp4rk.eu\/mobi\/checkupdate.php?fileshash=%s/g', 'out/miui/app/resourcebrowser/service/online/OnlineService.smali');
        system ('sed', '-i', 's/http:\/\/market.xiaomi.com\/thm\//http:\/\/market.s0uthp4rk.eu\/mobi\//g', 'out/miui/app/resourcebrowser/service/online/OnlineService.smali');
	system ('sed', '-i', 's/http:\/\/market.xiaomi.com\/thm\/config\/clazz\/%s\/zh-cn/http:\/\/market.s0uthp4rk.eu\/mobi\/categories.php?list=%s/g', 'out/miui/app/resourcebrowser/service/online/OnlineProtocolConstants.smali');
        system ('sed', '-i', 's/http:\/\/market.xiaomi.com\/thm\/details\/%s?/http:\/\/market.s0uthp4rk.eu\/mobi\/details.php?item=%s/g', 'out/miui/app/resourcebrowser/service/online/OnlineProtocolConstants.smali');
        system ('sed', '-i', 's/http:\/\/market.xiaomi.com\/thm\/download\/%s?/http:\/\/market.s0uthp4rk.eu\/mobi\/download.php?item=%s/g', 'out/miui/app/resourcebrowser/service/online/OnlineProtocolConstants.smali');
        system ('sed', '-i', 's/http:\/\/market.xiaomi.com\/thm\/list?category=%s\&sortby=%s\&start=%s\&count=%s/http:\/\/market.s0uthp4rk.eu\/mobi\/list.php?category=%s\&sortby=%s\&start=%s\&count=%s/g', 'out/miui/app/resourcebrowser/service/online/OnlineProtocolConstants.smali');
        system ('sed', '-i', 's/http:\/\/market.xiaomi.com\/thm\/search?category=%s\&sortby=%s\&start=%s\&count=%s\&keywords=%s/http:\/\/market.s0uthp4rk.eu\/mobi\/search.php?category=%s\&sortby=%s\&start=%s\&count=%s\&keywords=%s/g', 'out/miui/app/resourcebrowser/service/online/OnlineProtocolConstants.smali');
        system ('sed', '-i', 's/http:\/\/market.xiaomi.com\/thm\/checkupdate?fileshash=%s/http:\/\/market.s0uthp4rk.eu\/mobi\/checkupdate.php?fileshash=%s/g', 'out/miui/app/resourcebrowser/service/online/OnlineProtocolConstants.smali');
        system ('sed', '-i', 's/http:\/\/market.xiaomi.com\/thm\//http:\/\/market.s0uthp4rk.eu\/mobi\//g', 'out/miui/app/resourcebrowser/service/online/OnlineProtocolConstants.smali');
	print ("Patched, now recompiling classes.dex\n");
	system ('smali', 'out');
	print ("Compiled, now reassembling the jar file\n");
        system ('mv', 'out.dex', 'classes.dex');
        system ('mv', 'working/META-INF', '.');
        system ('zip', '-9', '-r', 'miui-framework.jar', 'META-INF/', 'classes.dex');
	print ("Assembled, Cleaning up\n");
	system ('rm', 'classes.dex', 'META-INF', 'out/', 'working/classes.dex', '-r');
	print ("Building your update.zip\n");
	system ('mv', 'miui-framework.jar', 'update_zip_template/system/framework/');
	system ('cp', 'update_zip_template/system/', '.', '-r');
        system ('cp', 'update_zip_template/META-INF/', '.', '-r');
	system ('zip', '-9', '-r', 'MOD_MIUI-Framework_'.$digest.'.zip', 'system/', 'META-INF');
	print ("Update.zip is finished, cleaning up again\n");
	system ('rm', '-rf', 'system/', 'META-INF', 'update_zip_template/system/framework/miui-framework.jar');
	print ('</textarea>');
	print "<p><p>completed, your download-link is here: <a href=\"MOD_MIUI-Framework_".$digest.".zip\">Download</a><p><p>";
} else {
	print ("nothing needs to be done, file already patched\n");
	print ('</textarea>');
	print "<p><p>your download-link is here: <a href=\"MOD_MIUI-Framework_".$digest.".zip\">Download</a><p><p>";
}
