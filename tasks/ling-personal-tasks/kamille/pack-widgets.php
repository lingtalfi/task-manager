<?php



use KamillePacker\Config\Config;
use KamillePacker\WidgetPacker\WidgetPacker;
require "bigbang.php";




// FOR NOW, ONLY PACKING THE WIDGET I'M WORKING ON...



$appDir = "/myphp/kaminos/app";
$packer = WidgetPacker::create(Config::create()->set('appDir', $appDir));




$packer->pack("Notification");
