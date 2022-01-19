#!/bin/bash

# String Input:
input=$1
# Modified String Output:
output=""

# Minecarft Colour Codes:
prefix="§"
gay=( "c" "e" "a" "b" "9" "d" )

for (( i=0; i<${#input}; i++ )); do
	# Minecraft Colour Code
	cur=$prefix${gay[$(($i % ${#gay[@]}))]}
	
	# Add character and colour code to output
	char=${input:$i:1}
	output=$output$cur$char
done

echo -e "$output"
