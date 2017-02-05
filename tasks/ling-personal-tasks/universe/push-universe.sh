#!/usr/bin/env bash

# This is a personal task I use to push the new version of universe (my php framework)

# then snap and pp are some shortcuts that I use
# https://github.com/lingtalfi/my-git-config


php -f "/myphp/universe-snapshot/tools/duplicate.php"
cd "/myphp/universe-snapshot"
git snap automatic commit from task manager 
git pp

 