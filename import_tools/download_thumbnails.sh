#!/bin/bash

# Run this script from /var/www/your-vhost/mobi/thumbail/jpeg/w232
# And change the patch to download_thumbnails.pl in the for loop below accordingly

for i in `perl download_thumbnails.pl`; do mkdir `echo $i | cut -b 1,2,3` && wget http://file.market.xiaomi.com/thumbnail/jpeg/w232/$i -O $i; done
