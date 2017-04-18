<?php



use KamillePacker\Config\Config;
use KamillePacker\ModulePacker\ModulePacker;
require "bigbang.php";




// FOR NOW, ONLY PACKING THE MODULE I'M WORKING ON...



$appDir = "/myphp/kaminos/app";
$packer = ModulePacker::create(Config::create()->set('appDir', $appDir));



$packer->pack("Authenticate");
$packer->pack("Core");


