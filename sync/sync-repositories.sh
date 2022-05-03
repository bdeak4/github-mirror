#!/bin/sh

set -e

REPOS_PATH=${REPOS_PATH:-./git}

mkdir -p $REPOS_PATH/public
mkdir -p $REPOS_PATH/private

cleanup() {
	rm -f $github_response
	exit 1
}
trap cleanup EXIT

page=1
github_response=$(mktemp)
repos_url="https://$GITHUB_USER:$GITHUB_TOKEN@api.github.com/user/repos"

while true; do
	curl -s "$repos_url?page=$page&per_page=100" |
	jq -r ".[] | @base64" > $github_response

	cat $github_response

	[ $(wc -l $github_response | cut -d' ' -f1) -eq "100" ] || break
	page=$((page+1))
done |
while read row; do
	_jq() {
		echo $row | base64 --decode | jq -r $1
	}

	path=$REPOS_PATH/public/$(_jq .name)
	if [ "$(_jq '.private')" = "true" ]; then
		path=$(printf $path | sed 's|/public/|/private/|')
	fi

	echo $path

	if [ -d "$path" ]; then
		git -C $path fetch --all
	else
		url=$(_jq '.clone_url' | sed "s|//|//$GITHUB_USER:$GITHUB_TOKEN@|")
		git clone --mirror $url $path
	fi

	mkdir -p $path/info/web
	git -C $path for-each-ref --sort=-authordate --count=1 \
		--format='%(authordate:iso8601)' > $path/info/web/last-modified

	_jq '.description' | sed 's/^null$//g' > $path/description
done
