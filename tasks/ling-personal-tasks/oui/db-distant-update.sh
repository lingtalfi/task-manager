#!/usr/bin/env bash


# http://www.commandlinefu.com/commands/view/887/copy-a-mysql-database-to-a-new-server-via-ssh-with-one-command
# this one liner exports a local database to a remote server
# note: kom is just a ssh identifier in my ~/.ssh/config file
 mysqldump --add-drop-table --extended-insert --force -uroot -proot oui | ssh -C kom "mysql -u my_user -myPass40gE oui"



 