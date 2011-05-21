#!/bin/bash

command=$0
if [[ $command == "-bash" ]]; then
    home="$PWD"
else
    home=`dirname "${command}"`
fi
if [[ ${home:0:1} != "/" && "$home" != "." ]]; then
  home="$PWD/$home"
fi

PATH=${PATH}:${home}/bin
complete -C ${home}/bin/did_autocomplete did
