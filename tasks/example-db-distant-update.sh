#!/usr/bin/env bash


# http://www.commandlinefu.com/commands/view/887/copy-a-mysql-database-to-a-new-server-via-ssh-with-one-command
# this one liner exports a local database to a remote server
# note: kom is just a ssh identifier in my ~/.ssh/config file
 mysqldump --add-drop-table --extended-insert --force -uroot -proot example_db | ssh -C kom "mysql -u example_db_admin -Ri11gsRLEkg40 example_db"



 