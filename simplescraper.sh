#!/bin/bash

# This script is because I currently use uGet, but it can't scrape for filetypes.
# That and gwget now has a crapton of dependencies I don't want. So.


# I'm currently setting recursion at 1 and ignoring mirroring.
RECURSION=1

# whether or not to pipe to another program
if [[ "$@" == *"--pipe"* ]]; then
	OutPutOnly=1
else
	OutPutOnly=0
fi


# Get website
website_suck_level=2001;
while [ $website_suck_level -gt 2000 ]; do

if [ "$1" == "" ]; then
	szURL=$(zenity --entry --text "What URL to scrape from?" --entry-text "")
else
	szURL="$1"
fi
	if [[ `wget -S --spider $1  2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then 
		website_suck_level=1999
	else
		zenity --error --text "Website unreachable!"
	fi
done;

#If we're passing it elsewhere, who cares what the directory is?
if [[ OutPutOnly == 0 ]]; then
	#select directory to put output in
	if [ -d "$2" ]; then
		szSavePath="$2"
	else
		szSavePath=$(zenity --text "Where to put the resulting files?" --file-selection --directory)
	fi
fi	


#use zenity checklist to choose extensions
#have mirror as option for ENTIRE website

string=$(zenity  --list  --text "What types of files to get?" --checklist  --column "Pick" --column "options" FALSE "mirror" TRUE "images" FALSE "video" FALSE "archives" FALSE "sounds" FALSE "documents" --separator=","); 

if [[ "$string" == *"$mirror"* ]]; then
    filetypes="mirror"
else
	if [[ "$string" == *"$images"* ]]; then
		filetypes="gif|jpg|jpeg|svg|png|tiff|tif|ico|pbm|pcx"
	fi
	if [[ "$string" == *"$sounds"* ]]; then
		filetypes="mp3|midi|mod|s3m|wav|ogg|m3u|pls|flac|ape|m4a"
	fi
	if [[ "$string" == *"$documents"* ]]; then
		filetypes="doc|docx|xls|xlsx|odt|odf|css|html|djvu|rtf|csv|tsv|pdf|epub|azw|kf8"
	fi
	if [[ "$string" == *"$archives"* ]]; then
		filetypes="7z|zip|tar|gz|rar|arj|bz2|tgz|iso|apk|pup|pet|ebuild|appx|appxbundle|deb|rpm|yum|msi"
	fi
	if [[ "$string" == *"$video"* ]]; then
		filetypes="avi|mov|m4v|mpg|mpeg|flv|mkv|wmv|mp4"
	fi
fi

# This is done so that if you want to add, remove, or otherwise change filetypes for each category it only has to be done once.
WGetString=$(echo "filetypes" | /bin/sed -e 's/|/,/g')
GrepString=$(echo "filetypes" | /bin/sed 's/^/|/' | /bin/sed -e 's/|/http.+/g')



if [ $OutPutOnly == 1 ]; then
