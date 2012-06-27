miui_market_mirror
==================

Scripts and tools to create a local mirror of the miui theme market

* i had this idea after discovering that most of the time the downloads from the official theme market are taking ages to complete due to the fact that the source server is located in china (talking about ~20KB/s) so i created a project to code scripts and tools which can be used to host a local mirror of the official miui market (themes only) in your area. my test-server is located in europe / germany with a 100MBit dedicated connection.

This project is still under heavy development and far from complete.
if you want to help just fork it and drop me pull requests.


* TODO:
 * 	reverse the json structures of the official MIUI market to extend the import script
 * 	reverse the Path's the theme apk needs to get all the data it wants
 * 	modify the import script to also act as a update script (jump to next category when the item already exists in database
 * 	write php scripts to implement the basic functionality of json requests needed by the miui theme app


* CHEATSHEET:
 *	leech the thumbnails: "for i in `perl download_thumbnails.pl`; do mkdir `echo $i | cut -b 1,2,3` && wget http://file.market.xiaomi.com/thumbnail/jpeg/w232/$i -O $i; done"

* INFO:

the json structure looks like this:



    $VAR1 = [
    {
    'name' => "\x{79cb}\x{7ea2}\x{4f3c}\x{706b}",
    'moduleId' => '70d422ca-2e09-4527-a36f-25763617de24',
    'fileSize' => 609250,
    'moduleType' => 'generic_picture',
    'assemblyId' => '44cbcad1-52c0-4fed-a239-746af4ccbf57',
    'frontCover' => '6b4/5a4ac4b384e23e3cd188fb5e6393100e272e8f36',
    'playTime' => 0,
    'downloadUrlRoot' => 'http://file.market.xiaomi.com/thumbnail/'
    }
    ];
    $VAR1 = [
    {
    'name' => "\x{8499}\x{4f4f}\x{53cc}\x{773c}",
    'moduleId' => 'c2cc3ea6-2dfa-4871-addc-207e37c25ae2',
    'fileSize' => 122631,
    'moduleType' => 'generic_picture',
    'assemblyId' => '45279297-7e98-4e63-9384-8b971b453039',
    'frontCover' => '918/0a38d01138a72b1dfb50daff902b6b448f7b4069',
    'playTime' => 0,
    'downloadUrlRoot' => 'http://file.market.xiaomi.com/thumbnail/'
    }
    ];
    $VAR1 = [
    {
    'name' => "\x{7af9}\x{6797}\x{5e7d}\x{5f84}",
    'moduleId' => '3d80ef72-ec7c-49c9-81e2-0c20454f2dfa',
    'fileSize' => 364347,
    'moduleType' => 'generic_picture',
    'assemblyId' => '48f28ea9-952c-401f-98eb-c8fe395c35ed',
    'frontCover' => 'b95/34e3eb94d5e6a1b90bf1d6a4b55e20901e16a52b',
    'playTime' => 0,
    'downloadUrlRoot' => 'http://file.market.xiaomi.com/thumbnail/'
    }
    ];





If you want to have a chat, or ask further questions, drop by on the project's irc-channel:

irc://irc.freenode.net/miui-mm

Greetings
Cronix
