#!/bin/bash

# ---------------------------------------------------------------
# | This script compiles a .java file to a .class file, runs it |
# |   and if $2 provided, deletes the .class file afterwards.   |
# ---------------------------------------------------------------

# Script Stuff:
colourRED='\e[0;31m'
colourWHT='\e[0;37m'

# File Arguments:
file=$1
mode=$2

# Java Compiler:
compiler=javac



# FUNCTIONS

# Checks if requested file exists
function checkFile() {
	if ! [[ -f $file".java" ]]; then
		echo -e "File ${colourRED}$file.java${colourWHT} not found!"

		exit 0
	fi
}

# Compiles the java source code to a .class file
function compileSource() {
	$compiler $file".java"
}

# Runs the java class file
function runCompiled() {
	java $file
}

# Removes the java class file if mode is not empty
function removeClass() {
	if [[ $mode != "" && -f $file".class" ]]; then
		rm $file".class"
	fi
}



# MAIN

checkFile
compileSource
runCompiled
removeClass
