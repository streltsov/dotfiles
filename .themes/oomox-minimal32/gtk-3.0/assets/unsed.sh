#!/bin/sh
sed -i \
         -e 's/rgb(0%,0%,0%)/#fbf1c7/g' \
         -e 's/rgb(100%,100%,100%)/#3c3836/g' \
    -e 's/rgb(50%,0%,0%)/#fbf1c7/g' \
     -e 's/rgb(0%,50%,0%)/#cc241d/g' \
 -e 's/rgb(0%,50.196078%,0%)/#cc241d/g' \
     -e 's/rgb(50%,0%,50%)/#fbf1c7/g' \
 -e 's/rgb(50.196078%,0%,50.196078%)/#fbf1c7/g' \
     -e 's/rgb(0%,0%,50%)/#3c3836/g' \
	"$@"