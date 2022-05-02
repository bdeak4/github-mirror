#!/bin/sh

tmp=$(mktemp)

htpasswd -c -B $tmp usr

sed -i '/^BASIC_AUTH_PASSWORD=/d' .env
echo BASIC_AUTH_PASSWORD=$(cat $tmp | cut -d':' -f2) >> .env

rm $tmp
