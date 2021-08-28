# ============================================================================ #
#                   __     __      _____   _____  _____                        #
#                   \ \   / //\   |  __ \ / ____|/ ____|                       #
#                    \ \_/ //  \  | |__) | (___ | |  __                        #
#                     \   // /\ \ |  _  / \___ \| | |_ |                       #
#                      | |/ ____ \| | \ \ ____) | |__| |                       #
#                      |_/_/    \_\_|  \_\_____/ \_____|                       #
#                                                                              #
#                        Yet Another RPG Style Game                            #
#                     a simple game by niro, with love                         #
#                                                                              #
# ============================================================================ #



# ------------------------------------------------------------------------------
# VARIABLES
# ------------------------------------------------------------------------------

launch=$1

# Enemy
enemyHPmax=20
enemyHP=$enemyHPmax
enemyAtk=""

# Player
playerHPmax=25
playerHP=$playerHPmax
playerStamina=20
pleayerPotions=3


# Attacks
enemyDMG=5

playerLightDMG=3
playerHeavyDMG=5

playerLightCost=2
playerHeavyCost=6

playerHeal=7




# ------------------------------------------------------------------------------
# FUNCTIONS
# ------------------------------------------------------------------------------

function actionPick() {
	while true; do
		echo $enemyAtk
		fight_print
		printf " >> "
		read input
		if (( input == 3 & pleayerPotions <= 0 )); then
			# No potions
			clear
			echo "!!! - You dont have enough potions to heal yourself! - !!!"
		elif (( input == 1 | input == 2 | input == 3 )); then
			# Action
			action $input
			break
		else
			# Bad input
			clear
			echo "!!! - Please put in only 1, 2 or 3 - !!!"
		fi
	done
}

function action() {
	case $1 in
		1)
			# Light Attack
			playerStamina=$(( playerStamina - playerLightCost ))
			enemyHP=$(( enemyHP - playerLightDMG ))
			break
		;;

		2)
			# Heavy Attack
			playerStamina=$(( playerStamina - playerHeavyCost ))
			enemyHP=$(( enemyHP - playerHeavyDMG ))
			break
		;;

		3)
			# Heal
			playerHP=$(( playerHP + playerHeal ))
			pleayerPotions=$(( pleayerPotions - 1 ))
			# Dont go over max HP thingy
			if (( playerHP > playerHPmax )); then playerHP=$playerHPmax; fi
			break
		;;

		*)
			echo "if you see this, some error accured :("
			break
		;;

	esac
}

function enemy_attack() {
	# Critical Damage Chance
	ran=$(( $RANDOM % 3 ))
	crit=1
	enemyAtk="The enemy attacked you with a normal attack!"
	
	# Crit DMG
	if (( ran == 0 )); then
		#Crit successful
		playerHP=$(( playerHP - crit ))
		enemyAtk="The enemy attacked you with a strong attack, dealing" $crit "more damage."
	elif (( ran == 1 )); then
		#Crit unsuccessful
		enemyAtk="The enemy attacked you with a weak attack, dealing" $crit "less damage."
		playerHP=$(( playerHP + crit ))
	fi
	# Standard DMG
	playerHP=$(( playerHP - enemyDMG ))
	echo ""
}

function fight_print() {
	echo "HP  Enemy: " $enemyHP"/"$enemyHPmax
	echo "HP Player: " $playerHP"/"$playerHPmax"  Stamina: " $playerStamina
	echo
	echo "	Type 1 for a light attack:" "  -  DMG:" $playerLightDMG " - Stamina Cost:" $playerLightCost
	echo "	Type 2 for heavy attack:  " "  -  DMG:" $playerHeavyDMG " - Stamina Cost:" $playerHeavyCost
	echo "	Type 3 to heal yourself:  " "  -  HP+:" $playerHeal " - Potions:" $pleayerPotions
}

function winScreen() {
	while true; do
		clear
		echo "__          ___                       "
		echo "\ \        / (_)                      "
		echo " \ \  /\  / / _ _ __  _ __   ___ _ __ "
		echo "  \ \/  \/ / | | '_ \| '_ \ / _ \ '__|"
 		echo "   \  /\  /  | | | | | | | |  __/ |   "
 		echo "    \/  \/   |_|_| |_|_| |_|\___|_|   "
 		echo "                                      "
 		echo "       You defeated the enemy!        "
 		echo "    Your HP:" $playerHP "- Your Stamina:" $playerStamina
 		echo "                                      "
 		echo "  <press enter to quit this program>  "
 		echo "                                      "
 		
 		printf " > > "
 		read exit
 		break
 	done
      
}
function loseScreen() {
	while true; do
		clear
		echo "    _____        __           _       "
		echo "   |  __ \      / _|         | |      "
		echo "   | |  | | ___| |_ ___  __ _| |_     "
		echo "   | |  | |/ _ \  _/ _ \/ _' | __|    "
		echo "   | |__| |  __/ ||  __/ (_| | |_     "
		echo "   |_____/ \___|_| \___|\__,_|\__|    "
		echo "                                      "
		if (( playerStamina < 0 )); then
			echo "       You ran out of stamina!        "
		else
			echo "     The enemy has defeated you!      "
		fi
 		echo "    Your HP:" $playerHP "- Your Stamina:" $playerStamina
 		echo "            Enemy HP:" $enemyHP
 		echo "                                      "
 		echo "  <press enter to quit this program>  "
 		echo "                                      "

 		printf " > > "
 		read exit
 		break
 	done
}

function welcome() {
	clear
	echo " __     __      _____   _____  _____  "
	echo " \ \   / //\   |  __ \ / ____|/ ____| "
	echo "  \ \_/ //  \  | |__) | (___ | |  __  "
	echo "   \   // /\ \ |  _  / \___ \| | |_ | "
	echo "    | |/ ____ \| | \ \ ____) | |__| | "
	echo "    |_/_/    \_\_|  \_\_____/ \_____| "
	echo "                                      "
	echo "      Yet Another RPG Style Game      "
	echo "         a simple game by niro        "
	echo "                                      "
	echo "    <press enter to start the game>   "
	echo "                                      "
 	printf " > > "
 	read start
}

function helpScreen() {
	echo \-\e "This is the help screen!"\\\n"Here you will find general information about the game:"
}



# ------------------------------------------------------------------------------
# MAIN LOOP
# ------------------------------------------------------------------------------

case $launch in
	h)
		helpScreen
	;;

	*)
		# Welcome screen
		welcome

		while true; do
			clear
			# Player Attack, Stamina Check, Enemy Alive Check
			actionPick
			if (( playerStamina < 0 )); then
				loseScreen
				break
			fi
			if (( enemyHP <= 0 )); then
				winScreen
				break
			fi

			# Enemy Attack and Player Alive Check
			sleep 0.2
			enemy_attack
			if (( playerHP <= 0 )); then
				loseScreen
				break
			fi
		done
	;;

esac
