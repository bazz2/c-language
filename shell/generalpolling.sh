#string=$(echo '03000061' |sed -e 's/../\\x&/g')
#string2="<omc>\n\t<packcd>6002</packcd>\n\t<taskid>277</taskid>\n\t<style>1</style>\n\t<areaid>13</areaid>\n</omc>\n"
#echo -ne $string$string2 |nc 192.168.60.141 8801


string="\x03\x00\x00\x61<omc>\n\t<packcd>6002</packcd>\n\t<taskid>277</taskid>\n\t<style>1</style>\n\t<areaid>13</areaid>\n</omc>\n"
#echo -ne $string |nc 192.168.60.141 8801
echo -ne $string |nc 127.0.0.1 8801
