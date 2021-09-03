# ------------------------------------------------------------------------------
# SCRIPTS
# ------------------------------------------------------------------------------

INTRO="start.sh"



# ------------------------------------------------------------------------------
# VARIABLES
# ------------------------------------------------------------------------------

cardsName=( "2" "3" "4" "5" "6" "7" "8" "9" "King" "Queen" "Joker" "Ace"  )
cardsValue=( 2 3 4 5 6 7 8 9 10 10 10 11 )
# Player
playerALIVE=true
playerCARDS=""
playerDECK=0
# Dealer
dealerCARDS=""
dealerDECK=0
# Counter
dealerWINS=0
playerWINS=0



# ------------------------------------------------------------------------------
# FUNCTIONS
# ------------------------------------------------------------------------------

### System Things:
function launch() {
	type=$1
	name=$2

	if [[ $type == "script" ]]; then
		./$name
	else
		echo -e "ERROR on lauch() function in main.sh! (invalid type)"
		exit 0
	fi
}

### Ascii-Art:

function asciiart() {
	request=$1

	case $request in 
		win)
			echo -e " _       ___                       __"\\\n"| |     / (_)___  ____  ___  _____/ /"\\\n"| | /| / / / __ \/ __ \/ _ \/ ___/ / "\\\n"| |/ |/ / / / / / / / /  __/ /  /_/  "\\\n"|__/|__/_/_/ /_/_/ /_/\___/_/  (_)   "\\\n
			;;
		lose)
			echo -e "    __                    __"\\\n"   / /   ____  ________  / /"\\\n"  / /   / __ \/ ___/ _ \/ / "\\\n" / /___/ /_/ (__  )  __/_/  "\\\n"/_____/\____/____/\___(_)   "\\\n
			;;
		draw)
			echo -e "    ____                      __"\\\n"   / __ \_________ __      __/ /"\\\n"  / / / / ___/ __ '/ | /| / / / "\\\n" / /_/ / /  / /_/ /| |/ |/ /_/  "\\\n"/_____/_/   \__,_/ |__/|__(_)   "\\\n
			;;
		*)
			echo -e "This is not supposed to happen..."\\\n
			;;
	esac
}


### Game:
function reset() {
	# Player:
	playerALIVE=true
	playerDECK=0
	playerCARDS=""
	# Dealer:
	dealerDECK=0
	dealerCARDS=""
}

function replay() {
	while true; do

		echo -e \\\n"To replay press ENTER. To quit type 'q'/'quit'!"
		printf " >> "
		read action

		if [[ $action == "q" || $action == "quit" || $action == "Q" || $action == "QUIT" || $action == "n" || $action == "no" ]]; then
			exit 0
		elif [[ $action == "" || $action == "y" || $action == "yes" ]]; then
			reset
			break
		else
			echo -e "Invalid operation. Please retry!"
			sleep 1
		fi

	done

}

# add a new card
function addCard() {
	who=$1
	# Card Value:
	amount=0
	card=$[ $RANDOM % ${#cardsValue[@]} ]
	amount=${cardsValue[$card]}
	name=${cardsName[$card]}

	if [[ $who == "player" || $who == "p" ]]; then
		# Player:
		playerDECK=$(( $playerDECK + $amount ))
		playerCARDS=${playerCARDS}$name" "
	elif [[ $who == "dealer" || $who == "d" ]]; then
		# Dealer:
		dealerDECK=$[ $dealerDECK + $amount ]
		dealerCARDS=${dealerCARDS}$name" "
	else
		# Invalid recipient
		echo -e "ERROR!"\\\n"addCard() function in main.sh has an invalid recipient!"
		exit 0
	fi
}

# Prints the state of the game ( minus "invisible card of dealer" )
function printGame() {
	echo -e "Dealer Card Value: "$dealerDECK\\\n$dealerCARDS\\\n
	echo -e "Player Card Value: "$playerDECK\\\n$playerCARDS\\\n
	echo ""
}

# endgame: "ai" of dealer
function dealerDescision() {
	while true; do
		if [[ $dealerDECK > 19 ]]; then
			# dealer has 20 or 21 points - SAFE
			break
		elif [[ $dealerDECK < $playerDECK && playerDECK > 22 ]]; then
			# points lower than 20 and player has more points - RISKY
			addCard dealer
		else 
			# dealer has more points than player - VERY SAFE
			break
		fi
	done
}

# judges the game state at the end - win/lose/draw
function judgeGame() {
	if [[ $playerDECK > 21 && $dealerDECK > 21 ]]; then
		# Both over 21:
		gameEnd draw
	else
		# One over 21:
		if [[ $playerDECK > 21 ]]; then
			gameEnd lose
		elif [[ $dealerDECK > 21 ]]; then
			gameEnd win
		else 
			# Higher Points:
			if [[ $playerDECK == $dealerDECK ]]; then
				gameEnd draw
			elif [[ $playerDECK < $dealerDECK ]]; then
				gameEnd lose
			elif [[ $playerDECK > $dealerDECK ]]; then
				gameEnd win
			else 
				echo -e "An error accured in the function judgeGame()! Invalid game state"
				exit 0
			fi
		fi
	fi
	# please ignore this messy code - i was struggling to get it to work at midnight
}

function gameEnd() {
	state=$1

	# Print results:
	clear
	printGame

	asciiart $state

	case $state in 
		draw)
			echo -e "The game ended in a draw!"
			;;
		win)
			echo -e "Congratulations! You won! :D"
			playerWINS=$[ $playerWINS + 1 ]
			;;
		lose)
			echo -e "Kinda sad... you lost :("
			dealerWINS=$[ $dealerWINS + 1 ]
			;;
		*)
			echo -e "An error accured - invalid game state!"
			exit 0
			;;
	esac

	echo -e \\\n"Player Wins: "$playerWINS"  - -  Dealer WIns: "$dealerWINS\\\n
}



# ------------------------------------------------------------------------------
# MAIN LOOP
# ------------------------------------------------------------------------------

# Intro:
cd scripts
launch script $INTRO

# Main Loop:
while true; do
	reset
	# Start Game:
	addCard dealer
	for (( i = 0; i < 2; i++ )); do addCard player; done


	# Mid Game:
	pass=false
	while (($playerALIVE == true && $pass == false)); do
		clear
		printGame
		echo -e "Do you want to draw another card?"
		printf "[y/n] >> "
		read add

		if [[ $add == "y" || $add == "yes" ]]; then
			addCard player
		elif [[ $add == "n" || $add == "no" ]]; then
			pass=true
			break
		else 
			echo -e "Invalid operation, please retry."
			sleep 2
		fi
		
		# Player Check
		if [[ $playerDECK > 21 ]]; then break; fi
	done
	

	# Endgame:

	# Card "invisible" to player being added to dealer:
	addCard dealer

	if (( $playerDECK <= 21 )); then
		dealerDescision
	fi

	# judges and sends back game results
	judgeGame

	# End of Game / Replay?
	replay
done
