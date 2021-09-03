function commandInfo() {
	cmd=$1
	desc=$2

	echo -e " "$cmd\\\n"    "$desc
}

function gameInfo() {
	echo -e \\\n\\\n"Blackjack is a gambling game - the goal is to get as close to 21 points, but without going above it."\\\n"You will be drawing a random card (card values are between 2 and 11)."
}


# General Info
echo -e "This is a simple blackjack script."\\\n"Please make sure to launch from the blackjack.sh script to prevent unexpected behaviour!"\\\n\\\n

# Commands
echo -e "Available commands:"\\\n
commandInfo "--help / -h" "displays this screen"
commandInfo "--version / -v" "shows the script version"
commandInfo "--readme / -r" "displays the readme file"

gameInfo
exit 0