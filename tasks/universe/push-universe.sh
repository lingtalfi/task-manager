#!/usr/bin/env bash

# This is a personal task I use to push the new version of universe (my php framework) here: https://github.com/karayabin/universe-snapshot

# then snap and pp are some git shortcuts that I use
# https://github.com/lingtalfi/my-git-config


php -f "/pathto/php/projects/universe-snapshots/private/scripts/duplicate.php"
git snap "automatic commit from task manager"
git pp

 



# The content of the php duplicate.php script is as follow:



# <?php



# //------------------------------------------------------------------------------/
# // Duplicate
# // LingTalfi - 2016-02-08
# //------------------------------------------------------------------------------/
# /**
#  * This script will duplicate the given universe, and put it in another given directory.
#  * It will also clean the copy from the following:
#  *
#  * - private/
#  * - .git/
#  * - .gitignore
#  * - .DS_Store
#  *
#  */


# //------------------------------------------------------------------------------/
# // CONFIG
# //------------------------------------------------------------------------------/


# $universeDir = "/pathto/php/projects/universe/planets";
# $universeCopyDir = "/pathto/php/projects/universe-snapshots/planets";

# $bigbangSrc = "/pathto/php/projects/universe/bigbang.php";
# $bigbangDst = "/pathto/php/projects/universe-snapshots/bigbang.php";



# //------------------------------------------------------------------------------/
# // SCRIPT
# //------------------------------------------------------------------------------/
# use Bat\FileSystemTool;
# use DirScanner\DirScanner;

# require_once "/pathto/php/projects/universe/bigbang.php";



# /**
#  * First create a fresh copy of the universe.
#  */
# FileSystemTool::remove($universeCopyDir);
# FileSystemTool::copyDir($universeDir, $universeCopyDir);


# /**
# * Then copy the bigbang.php script
# */
# FileSystemTool::remove($bigbangDst);
# copy($bigbangSrc, $bigbangDst);





# function line($m){
#     if('cli' === PHP_SAPI){
#         echo "\n";
#     }
#     else{
#         echo "<br>";
#     }
#     echo $m;
# }

# function hr(){
#     if('cli' === PHP_SAPI){
#         echo "\n----------------------------";
#     }
#     else{
#         echo "<hr>";
#     }   
# }


# /**
#  * Then clean that out
#  */
# $files2Remove = [
#     '.DS_Store',
#     '.gitignore',
# ];
# $dirs2Remove = [
#     'private',
#     '.git',
# ];
# DirScanner::create()->scanDir($universeCopyDir, function ($path, $rPath) use ($files2Remove, $dirs2Remove) {
# //    echo $rPath;
#     $base = basename($rPath);
#     if (in_array($base, $files2Remove, true) && is_file($path)) {
#         line("removing $rPath");
#         FileSystemTool::remove($path);
#     }
#     if (in_array($base, $dirs2Remove, true) && is_dir($path)) {
#         line("removing dir $rPath");
#         FileSystemTool::remove($path);
#     }
#     //hr();
# });

