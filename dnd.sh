# VARIABLES

operation=$1
validRoll=( 4 6 8 10 12 20 )



# FUNCTIONS

function commandInfo() {
	name=$1
	desc=$2
	echo -e " --"$name\\\n"	"$desc
}

function helpCommand() {
	echo -e "Command list:"\\\n"---------------------"
	commandInfo "help" "this screen"
	commandInfo "roll [x] [y]" "rolls x dice with y sides"
	commandInfo "freeroll [x] [y]" "rolls x dice with y sides (without regard to physical correctness)"
}

function roll() {
	dice=$1
	sides=$2

	echo -e "You rolled:"

	for (( i = 0; i < $dice; i++ )); do
		roll=$[ $RANDOM % $sides + 1 ]
		printf $roll"  "
	done

	echo ""
}

function errorRoll() {
	if [[ $1 == "all" ]]; then
		echo -e "Error on '"$2" dice and/or "$3" sides'! Please make sure to only use integers above 0."\\\n"Type --help for instructions."
	elif [[ $1 == "roll" ]]; then
		echo -e "Error on '"$3"'. Dice sides need to be:"\\\n${validRoll[*]}\\\n"Type --help for instructions."
	else
		echo -e "An error accured."
	fi
}

function errorOperation() {
	echo -e "Error on operation '"$operation"'!"\\\n"Type --help for instructions."
}



# MAIN

if [[ $operation == "-h" || $operation == "--help" ]]; then
	helpCommand

elif [[ $operation == "-r" || $operation == "--roll" || $operation = "-fr" || $operation == "--froll" || $operation == "--freeroll" ]]; then
	dice=$2
	sides=$3

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
		else errorRoll "roll" $dice $sides; fi		
		
	else
		# Dice/Sides not an integer and/or smaller than 1
		errorRoll "all" $dice $sides
		break
	fi

else 
	# Error on operation
	errorOperation
fi