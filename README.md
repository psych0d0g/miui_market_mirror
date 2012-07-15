miui_market_mirror
==================

Scripts and tools to create a local mirror of the miui theme market

* i had this idea after discovering that most of the time the downloads from the official theme market are taking ages to complete due to the fact that the source server is located in china (talking about ~20KB/s) so i created a project to code scripts and tools which can be used to host a local mirror of the official miui market (themes only) in your area. my test-server is located in europe / germany with a 100MBit dedicated connection.

This project is still under heavy development and far from complete.
if you want to help just fork it and drop me pull requests.


* TODO:
 * 	reverse the json structures of the official MIUI market to extend the import script
 * 	reverse the Path's the theme apk needs to get all the data it wants
 * 	modify the import scripts to also act as a update script (jump to next category when the item already exists in database) [DONE]
 *	extend the import scripts to also download the real resources and theme files
 * 	write php scripts to implement the basic functionality of json requests needed by the miui theme app


* CHEATSHEET:
 *	leech the thumbnails: "for i in `perl download_thumbnails.pl`; do mkdir `echo $i | cut -b 1,2,3` && wget http://file.market.xiaomi.com/thumbnail/jpeg/w232/$i -O $i; done"

* INFO:

URL's used in the unmodifyed miui-framework.jar which get patched to own server:

out/miui/app/resourcebrowser/service/online/OnlineService.smali:    const-string v3, "http://market.xiaomi.com/thm/config/clazz/%s/zh-cn"
out/miui/app/resourcebrowser/service/online/OnlineService.smali:    const-string v1, "http://market.xiaomi.com/thm/details/%s?"
out/miui/app/resourcebrowser/service/online/OnlineService.smali:    const-string v1, "http://market.xiaomi.com/thm/download/%s?"
out/miui/app/resourcebrowser/service/online/OnlineService.smali:    const-string v3, "http://market.xiaomi.com/thm/list?category=%s&sortby=%s&start=%s&count=%s"
out/miui/app/resourcebrowser/service/online/OnlineService.smali:    const-string v3, "http://market.xiaomi.com/thm/search?category=%s&sortby=%s&start=%s&count=%s&keywords=%s"
out/miui/app/resourcebrowser/service/online/OnlineService.smali:    const-string v3, "http://market.xiaomi.com/thm/checkupdate?fileshash=%s"


If you want to have a chat, or ask further questions, drop by on the project's irc-channel:

irc://irc.freenode.net/miui-mm

Greetings
Cronix
