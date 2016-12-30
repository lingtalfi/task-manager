#!/usr/bin/env bash



fileA="/pathto/php/projects/universe/planets/Explorer/Explorer"
fileB="/pathto/php/projects/universe/planets/Explorer/Importer"
fileC="/pathto/php/projects/universe/planets/Explorer/Log"
fileD="/pathto/php/projects/universe/planets/Explorer/Util"
fileE="/pathto/php/projects/universe/planets/Explorer/explorer-script/explorer.php"



cd "/pathto/php/projects/universe/planets/Explorer/explorer-script"

cp "$fileE" .
cd pack
rm -r Explorer
mkdir Explorer
cd Explorer
cp -r "$fileA" .
cp -r "$fileB" .
cp -r "$fileC" .
cp -r "$fileD" .



cd "/me/explorer-script"


cp "$fileE" .
cd pack
rm -r Explorer
mkdir Explorer
cd Explorer
cp -r "$fileA" .
cp -r "$fileB" .
cp -r "$fileC" .
cp -r "$fileD" .


 
