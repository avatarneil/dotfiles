#!/usr/bin/env bash

#-- sourced from https://gist.github.com/TheMengzor/968e5ea87e99d9c41782
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
echo "project directory: $DIR"
#--
read -p "will delete previous backup folder (if it exists). continue? y/n" $response
if [[ $response = "y"]]
then
    rm -rf ~/.backups
    echo "copying previous config files to ~/.backups/"
    mkdir -p ~/.backups
    mv ~/.emacs ~/.backups/.emacs
    mv ~/.config/ ~/.backups/.config/
    mv ~/.hyper.js ~/.backups/.emacs

    echo "deleting previous config files..."
    rm -rf ~/.emacs
    rm -rf ~/.config/
    rm -rf ~/.hyper.js

    echo "beginning linking operation"
    echo "linking emacs to ~/.emacs"
    ln -s "$DIR/emacs" ~/.emacs

    echo "linking karabiner to ~/.config/karabiner"
    ln -s "$DIR/karabiner" ~/.config/

    echo "linking hyper.js to ~/.hyper.js"
    ln -s "$DIR/hyper.js" ~/.hyper.js
else
    echo "please manually move your files :)"