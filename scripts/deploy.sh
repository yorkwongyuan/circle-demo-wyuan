#!/bin/sh
# 构想 https://gist.github.com/motemen/8595451

# 基于 https://github.com/eldarlabs/ghpages-deploy-script/blob/master/scripts/deploy-ghpages.sh
# MIT许可 https://github.com/eldarlabs/ghpages-deploy-script/blob/master/LICENSE

# abort the script if there is a non-zero error
set -e
pwd
remote=$(git config remote.origin.url)
echo 'remote is: '$remote