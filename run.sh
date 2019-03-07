#!/bin/bash

current_dir=$(pwd)
if [ -z ${1+x} ];
then
   echo "Please specify game name"
else
   open -n -a love "$current_dir/"$1"/"
fi
