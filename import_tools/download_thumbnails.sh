#!/bin/bash

# Run this script from /var/www/your-vhost/mobi/thumbail/jpeg/w232
# And change the path to download_thumbnails.pl in the for loop below accordingly


for i in `perl /abssolute/path/to/download_thumbnails.pl`; do wget -Nr http://file.market.xiaomi.com/thumbnail/jpeg/w232/$i -O $i ; done
