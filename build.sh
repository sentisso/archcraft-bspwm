#!/usr/bin/env bash

## Copyright (C) 2020-2024 Aditya Shakya <adi1090x@gmail.com>

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

## Build packages
build_pkg () {
  rm -rf *.pkg.tar.zst

	echo -e "\nBuilding Package - \n"
	makepkg -scf
	
	RDIR='../../pkgs/x86_64'
	if [[ -d "$RDIR" ]]; then
		mv -f *.pkg.tar.zst "$RDIR"
		echo -e "\nPackage moved to Repository.\n[!] Don't forget to update the database.\n"
	fi
}

## Execute
build_pkg
