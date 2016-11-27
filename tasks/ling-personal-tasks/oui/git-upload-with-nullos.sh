#!/usr/bin/env bash

# use git workflow here to mirror your local website to the server: 
# https://github.com/lingtalfi/server-notes/blob/master/doc/deploy-website.md

# then snap and pp are some shortcuts that I use
# https://github.com/lingtalfi/my-git-config


originalNullosApp="/pathto/php/projects/nullos-admin/app-nullos"
targetNullosApp="/komin/oui/app-nullos"

rm -r "$targetNullosApp"
cp -r "$originalNullosApp" "$targetNullosApp"

rm "$targetNullosApp/init.php"

cp "/komin/oui/private/nullos-init.php" "$targetNullosApp/init.php"


cd "/komin/oui"
git snap automatic commit
git pp


 
