#!/bin/bash

# requires link checker (pip install linkchecker)

# take user input for the urls of the new and old project
echo Enter the url of the new project.

read url

echo Enter the url of the old project.

read url2

# check new project links
linkchecker --user-agent "Mozilla/4.0" $url > ezlinks.txt

# sort by unique broken links
grep Real ezlinks.txt | sort | uniq | sed -ne 's/.*\(http[^"]*\).*/\1/p' > ezbrokenlinks.txt

# extract the basename from the broken links
while read line; do basename "$line" | sed -e 's/^default.aspx?name=//'; done < ezbrokenlinks.txt > ezbrokenbasename.txt


# repeat for old project links
linkchecker --user-agent "Mozilla/4.0" $url2 > oldlinks.txt

grep Real oldlinks.txt | sort | uniq | sed -ne 's/.*\(http[^"]*\).*/\1/p' > oldbrokenlinks.txt

# strip 'default.aspx?name=' prefix from old basenames
while read line; do basename "$line" | sed -e 's/^default.aspx?name=//'; done < oldbrokenlinks.txt > oldbrokenbasename.txt

# grep for differnces, saving those unique to the new project in ezBaseNames.txt
grep -Fxvf oldbrokenbasename.txt ezbrokenbasename.txt > ezBaseNames.txt

# print unique basenames of broken urls in the new project
cat ezBaseNames.txt
