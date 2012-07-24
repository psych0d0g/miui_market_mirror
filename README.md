miui_market_mirror
==================

Scripts and tools to create a local mirror of the miui theme market

* i had this idea after discovering that most of the time the downloads from the official theme market are taking ages to complete due to the fact that the source server is located in china (talking about ~20KB/s) so i created a project to code scripts and tools which can be used to host a local mirror of the official miui market (themes only) in your area. my test-server is located in europe / germany with a 100MBit dedicated connection.

This project is still under heavy development and far from complete.
if you want to help just fork it and drop me pull requests.


* TODO:
 *	extend the import scripts to also download the real resources and theme files
 * 	write php scripts to implement the basic functionality of json requests needed by the miui theme app


* Perl modules required for the scripts:
 *	LWP::UserAgent
 *	JSON
 *	DBI
 *	Config::Tiny
 *	File::Basename



* INFO:

URL's used in the unmodifyed miui-framework.jar which get patched to own server:

"http://market.xiaomi.com/thm/config/clazz/%s/zh-cn" 						=> lists subcategories for wallpapers and Ringtones
"http://market.xiaomi.com/thm/details/%s?" 							=> shows details and ressources of a single item
"http://market.xiaomi.com/thm/download/%s?"							=> direct link to the file, gets rewritten to filename
"http://market.xiaomi.com/thm/list?category=%s&sortby=%s&start=%s&count=%s"			=> list items in a category
"http://market.xiaomi.com/thm/search?category=%s&sortby=%s&start=%s&count=%s&keywords=%s"	=> Needs to be reversed, but should provide a search functionality
"http://market.xiaomi.com/thm/checkupdate?fileshash=%s"						=> Update check? Does nothing for now


If you want to have a chat, or ask further questions, drop by on the project's irc-channel:

irc://irc.freenode.net/miui-mm

Greetings
Cronix
