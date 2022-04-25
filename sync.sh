#!/bin/sh

set -e

curl -s "https://$GITHUB_USER:$GITHUB_TOKEN@api.github.com/user/repos" |
jq -r ".[] | select(.owner.login == \"$GITHUB_USER\") | [.private, .name, .ssh_url] | @tsv" |
while read repo; do
	is_private=$(echo $repo | awk '{print $1}')
	name=$(echo $repo | awk '{print $2}')	
	clone_url=$(echo $repo | awk '{print $3}')
	path="./repositories/public/$name"

	if [ "$is_private" = "true" ]; then
		path=$(printf $path | sed 's|/public/|/private/|')
	fi

	echo $path

	if [ -d "$path" ]; then
		git -C "$path" fetch --all
	else
		git clone --mirror "$clone_url" "$path"
	fi
done
