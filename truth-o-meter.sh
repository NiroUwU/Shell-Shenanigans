# VARIABLES

prct=$(( $RANDOM % 100 ))
do=$1
statement=$2



# FUNCTIONS

function helpMessage() {
	echo -e "List of all commands:"

	# Command list
	echo -e " --help / -h                          --   displays this screen"
	echo -e " --truth \"<string>\" / -t \"<string>\"   --   get the truth value of a statement"

	echo -e \\\n"Info:"\\\n" Small simple script made by niro. :)"
}

function truthometer() {
	echo "The statement *"$statement"* is" $prct"% true!"
}



# MAIN METHOD

if [[ $do == "-h" || $do == "--help" ]]; then
	helpMessage

elif [[ $do == "-t" || $do == "--truth" ]]; then
	if [[ $statement == "" ]]; then
		# Check if empty
		echo -e "The statement cant be empty."\\\n"Type --help for instructions."
		break
	else
		# Do the funky stuff
		truthometer
	fi

else
	echo -e "Invalid command."\\\n"Type --help for instructions."

fi