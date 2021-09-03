# VARIABLES

#   Input:
operation=$1

#   Scripts:
HELP="help.sh"
GAME="main.sh"
README="README.txt"

#   Other:
version="1.0"



# FUNCTIONS

function launch() {
	name=$1
	# Script Launch:
	./scripts/$name
}

function operationError() {
	echo -e "Invalid operation."\\\n"Type --help for instructions."
}



# MAIN

if [[ $operation == "--help" || $operation == "-h" ]]; then
	# Help File
	launch $HELP

elif [[ $operation == "--version" || $operation == "-v" ]]; then
	# Version
	echo -e "Blackjack by niro v"$version

elif [[ $operation == "--readme" || $operation == "-r" ]]; then
	cat $README

elif [[ $operation == "" ]]; then
	# Game/Main File
	launch $GAME

else
	# Invalid Operation
	operationError

fi
