#!/usr/bin/env bash

# This is a personal task I use to push the new version of universe (my php framework)

# then snap and pp are some shortcuts that I use
# https://github.com/lingtalfi/my-git-config



# import planets instead of symlinks
php -f "/pathto/php/projects/nullos-admin/tools/importToDirectories.php"


cd "/pathto/php/projects/nullos-admin"
git snap automatic commit from task manager 
git pp


# then convert back to symlinks
php -f "/pathto/php/projects/nullos-admin/tools/importToSymLinks.php"
 
