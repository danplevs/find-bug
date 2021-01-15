#!/bin/bash
git bisect start
git bisect bad
git bisect good 1.0
encoded_file=home-screen-text.txt
decoded_file=/tmp/decoded.txt
bisect_last_revision=/tmp/out.txt
while true 
do
    cat $encoded_file | openssl enc -base64 -A -d > $decoded_file
    if grep "jackass" $decoded_file
    then
	    git bisect bad > $bisect_last_revision
    else
	    git bisect good > $bisect_last_revision
    fi
    if grep '0 revisions left' $bisect_last_revision; then break; fi
done
first_bugged_commit=`tail -n 1 $bisect_last_revision | cut -c 2-6`
git push origin $first_bugged_commit:find-bug
