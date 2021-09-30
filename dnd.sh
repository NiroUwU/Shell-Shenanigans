#!/bin/bash

# VARIABLES

operation=$1                     # commands what exactly to do
validRoll=( 4 6 8 10 12 20 )     # array of valid die sides (only for --roll)
debug=false                      # debug and experimental stuff



# FUNCTIONS

function versionCommand() {
	local version="1.2"
	echo -e "DnD roll script by niro"\\\n"  Version:" $version
}

function helpCommand() {
	# everything for the --help command
	function commandInfo() {
		name=$1
		desc=$2
		echo -e " --"$name\\\n"	"$desc
	}

	echo -e "Command list:"\\\n"---------------------"
	commandInfo "help" "this screen"
	commandInfo "version" "displays script version"
	commandInfo "roll [x] [y]" "rolls x dice with y sides"
	commandInfo "freeroll [x] [y]" "rolls x dice with y sides (without regard to correctness)"
}

function roll() {
	# everything for the --roll and --freeroll command
	local LOCdice=$1
	local LOCsides=$2

	function rollStats() {
		local actionStats=$1

		case $actionStats in

			calculate)
				if [[ $debug == true ]]; then
					echo calculate called
					#  Maximum
					if [[ $max < $roll ]]; then
						echo -e \\\n"Max updated" $max "->" $roll
						max=$roll
					fi

					#  Minimum
					if [[ $min > $roll ]]; then
						echo -e \\\n"Min updated" $min "->" $roll
						min=$roll
					fi
				fi
				#  Sum of all sides
				sum=$(( sum + roll ))
				;;

			print)
				avg=$(( sum / sides ))

				#echo -e "Roll Statistics:"\\\n"Sum of all rolls: "$sum"  |  Average roll: "$avg"  |  Highest roll: "$max"  |  Lowest roll: "$min
				echo -e "Roll Statistics:"\\\n"Sum of all rolls: "$sum
				;;

			*)
				error custom "rollStats() function"
				;;

		esac
	}

	echo -e "You rolled:"

	for (( i = 0; i < $LOCdice; i++ )); do
		roll=$[ $RANDOM % $LOCsides + 1 ]
		
		printf " "$roll" "

		# Roll Stats
		rollStats calculate
	done
	echo -e ""\\\n

	# Prints stats of die roll / dice rolls
	rollStats print
}



function error() {
	# everything for errors
	local errorOn=$1
	local errorType=$2

	function unspecified() {
		if [[ $errorOn == "" ]]; then echo -e "Unspecified error occured!"
		else echo -e "Unspecified error on" $errorOn "occured!"; fi
	}

	printf "ERROR! - - "
	case $errorOn in
		roll)
			echo -e "Invalid Syntax for roll"
			case $errorType in
				general)
					# Error because dice and/or sides are an invalid integer
					echo -e "Error on '"$dice" dice and/or "$sides" sides'! Please make sure to only use integers above 0."
					;;
				dnd-range)
					# Error because 
					echo -e "Error on '"$"'. Dice sides need to be:"\\\n ${validRoll[*]}
					;;
				*)
					echo -e "Unspecified error on roll syntax."
					;;
			esac
		;;

		operation)
			echo -e "Error on operation '"$operation"'!"
			;;

		custom)
			echo -e $errorType
			;;

		*)
			unspecified
			;;
	esac

	# Standard help text
	echo -e \\\n"Type --help for instructions."
	exit 0
}



# MAIN

if [[ $operation == "-h" || $operation == "--help" ]]; then
	helpCommand

elif [[ $operation == "-v" || $operation == "--version" ]]; then
	versionCommand

elif [[ $operation == "-r" || $operation == "--roll" || $operation = "-fr" || $operation == "--froll" || $operation == "--freeroll" ]]; then
	dice=$2
	sides=$3

	#  Roll "stats"
	sum=0
	avg=0
	max=0
	min=$sides

	if [[ $dice > 0 && $sides > 0 && $dice =~ ^[0-9]+$ && $sides =~ ^[0-9]+$ ]]; then
		# Froll / Roll decide
		check=false
		if [[ $operation == "-r" || $operation == "--roll" ]]; then
			# Checks validity of roll
			for (( i = 0; i < ${#validRoll[@]}; i++ )); do
				if [[ $sides == ${validRoll[i]} ]]; then
					check=true
					break
				fi
			done

		# Froll bypass
		else check=true; fi

		# Rolls if valid
		if [[ $check == true ]]; then roll $dice $sides
		else error roll dnd-range; fi		
		
	else
		# Dice/Sides not an integer and/or smaller than 1
		errorRoll "all" $dice $sides
		break
	fi

else 
	# Error on operation
	error operation
fi

exit 0