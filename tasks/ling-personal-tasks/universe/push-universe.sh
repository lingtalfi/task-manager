#!/usr/bin/env bash

# This is a personal task I use to push the new version of universe (my php framework)

# then snap and pp are some shortcuts that I use
# https://github.com/lingtalfi/my-git-config


php -f "/pathto/php/projects/universe-snapshots/private/scripts/duplicate.php"
cd "/pathto/php/projects/universe-snapshots"
git snap automatic commit from task manager 
git pp

 
