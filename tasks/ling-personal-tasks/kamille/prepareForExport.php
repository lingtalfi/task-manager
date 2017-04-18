<?php


use CopyDir\WithFilterCopyDirUtil;
use DirScanner\YorgDirScannerTool;

require "bigbang.php";




//--------------------------------------------
// CONFIG
//--------------------------------------------
if(array_key_exists(1, $argv)){


    $itemType = $argv[1];
    $allowedItemTypes = ["widget", "module"];

    if(in_array($itemType, $allowedItemTypes)){    

        $appDir = "/myphp/kaminos/app";


        //--------------------------------------------
        // SCRIPT
        //--------------------------------------------
        $br = ("cli" === php_sapi_name())?PHP_EOL:"<br>";
        $itemsDir = 0;
        $appItemsDir = 0;
        switch ($itemType) {
            case 'widget':
                $itemsDir = "/myphp/kamille-widgets";
                $appItemsDir = $appDir . "/class-widgets";
                break;
            case 'module':
                $itemsDir = "/myphp/kamille-modules";
                $appItemsDir = $appDir . "/class-modules";
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
            echo "processing $itemType $dir" . $br;
            $appItemDir = $appItemsDir . "/" . $dir;
            $targetDir = $itemsDir . "/" . $dir;
            copyDirExceptGit($appItemDir, $targetDir);
        }
    }
    else{
        throw new \Exception("This type of item is not allowed: $itemType");        
    }
}
else{
    throw new \Exception("Please provide the type of item as the first argument: widget|module");
}








