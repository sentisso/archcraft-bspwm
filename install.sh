#!/bin/bash

## Script Termination
exit_on_signal_SIGINT () {
    { printf "\n\n%s\n" "Script interrupted." 2>&1; echo; }
    exit 0
}

exit_on_signal_SIGTERM () {
    { printf "\n\n%s\n" "Script terminated." 2>&1; echo; }
    exit 0
}

trap exit_on_signal_SIGINT SIGINT
trap exit_on_signal_SIGTERM SIGTERM

./build.sh

install_pkg () {
  echo -e "\nInstalling Package - \n"
  sudo pacman -U archcraft-bspwm-*.pkg.tar.zst
}

## Execute
install_pkg
