#!/bin/sh

set -e

REPOS_PATH=${REPOS_PATH:-./git}

mkdir -p $REPOS_PATH/public
mkdir -p $REPOS_PATH/private

curl -s "https://$GITHUB_USER:$GITHUB_TOKEN@api.github.com/user/repos" |
jq -r ".[] | select(.owner.login == \"$GITHUB_USER\") | @base64" |
while read row; do
	_jq() {
		echo $row | base64 --decode | jq -r $1
	}

	path=$REPOS_PATH/public/$(_jq .name)
	if [ "$(_jq '.private')" = "true" ]; then
		path=$(printf $path | sed 's|/public/|/private/|')
	fi

	if [ -d "$path" ]; then
		git -C $path fetch --all --quiet
	else
		git clone --mirror $(_jq '.clone_url') $path
	fi

	mkdir -p $path/info/web
	git -C $path for-each-ref --sort=-authordate --count=1 \
		--format='%(authordate:iso8601)' > $path/info/web/last-modified

	_jq '.description' | sed 's/^null$//g' > $path/description
done
