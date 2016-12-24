#!/usr/bin/env bash


## Below is the content of the geenrate-icons-factory.php script
## I use this in nullos to generate my IconsFactory from the icons.svg file,
## which is easier to manipulate than switch case statements.
# 
# 
# 
# <?php
# 
# 
# require_once __DIR__ . "/../init.php";
# 
# 
# use Icons\Util\FactoryGenerator;
# 
# 
# $className = 'IconsFactory';
# $svgFiles = [
#     APP_ROOT_DIR . "/class/Icons/icons.svg",
# ];
# $dstDir = APP_ROOT_DIR . "/class/Icons";
# 
# //------------------------------------------------------------------------------/
# // SCRIPT
# //------------------------------------------------------------------------------/
# FactoryGenerator::createFactory($className, $svgFiles, $dstDir);


php -f "/pathto/php/projects/nullos-admin/app-nullos/scripts/generate-icons-factory.php" 

