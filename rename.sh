#!/usr/bin/env bash

# rename.sh
# Script for renaming files with unwanted characters.
# Based on Advanced Bash Scripting Guide, p. 799-800
# Wrote with patiently help of Anon.

E_BADARGS=1

DIR=$1
PATTERN=$2
REPLACE=$3

if [ -z "$1" ] || [ -z "$2" ]; then
	echo "Usage: $0" '$DIRECTORY $PATTERN $REPLACE'
	echo '$DIRECTORY is path to directory, containing incorrect filenames;'
	echo '$PATTERN is unwanted character or pattern in filename, e.g. "[? ]" (both question mark and space);'
	echo '$REPLACE is correct character to replace, e.g. "_" or "".'
	echo 'You should use escapes with arguments, containing whitespaces:'
	echo "$0 PATH\ TO\ DIR ? _"
	echo 'or use quotes:'
	echo "$0" '"./PATH/TO/DIR" " " "_"'
	exit $E_BADARGS; fi

RenameFiles()
{
for SUBDIR_WRONG in "$1"/*; do
	SUBDIR_RIGHT=`echo "$SUBDIR_WRONG" | sed "s/$PATTERN/$REPLACE/g"`
	if [ "$SUBDIR_WRONG" != "$SUBDIR_RIGHT" ]; then
		mv --interactive --verbose "$SUBDIR_WRONG" "$SUBDIR_RIGHT"
		echo ""; fi
	if [ -d "$SUBDIR_RIGHT" ]; then
		RenameFiles "$SUBDIR_RIGHT"; fi; done
}

RenameFiles "$DIR"

exit 0
