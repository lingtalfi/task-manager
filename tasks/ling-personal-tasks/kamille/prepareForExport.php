<?php


use CopyDir\WithFilterCopyDirUtil;
use DirScanner\YorgDirScannerTool;

require "bigbang.php";


//--------------------------------------------
// CONFIG
//--------------------------------------------
$itemType = "widget";
$appDir = "/myphp/kaminos/app";


//--------------------------------------------
// SCRIPT
//--------------------------------------------
$itemsDir = 0;
$appItemsDir = 0;
switch ($itemType) {
    case 'widget':
        $itemsDir = "/myphp/kamille-widgets";
        $appItemsDir = $appDir . "/class-widgets";
        break;
    default:
        throw new \Exception("Unknown item type: $itemType");
        break;
}


function copyDirExceptGit($srcDir, $dstDir)
{
    WithFilterCopyDirUtil::create()
        ->setFilter(function ($baseName) {
            if (0 === strpos($baseName, ".")) {
                return false;
            }
            return true;
        })
        ->copyDir($srcDir, $dstDir);
}


$dirs = YorgDirScannerTool::getDirs($appItemsDir, false, true);
foreach ($dirs as $dir) {
    $appItemDir = $appItemsDir . "/" . $dir;
    $targetDir = $itemsDir . "/" . $dir;
    copyDirExceptGit($appItemDir, $targetDir);
}









