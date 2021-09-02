#!/bin/bash

for file in `find . -type 'f' \! -name '*.asc'`;
	do
		gpg --encrypt --armor --recipient 7DDAE50B $file
		rm -f $file
	done

