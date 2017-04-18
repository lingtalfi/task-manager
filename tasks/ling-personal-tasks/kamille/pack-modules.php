<?php



use KamillePacker\Config\Config;
use KamillePacker\ModulePacker\ModulePacker;


date_default_timezone_set('Europe/Paris');

require "bigbang.php";




// FOR NOW, ONLY PACKING THE MODULE I'M WORKING ON...



$appDir = "/myphp/kaminos/app";
$packer = ModulePacker::create(Config::create()->set('appDir', $appDir));



$packer->pack("Authenticate");
$packer->pack("Core");


