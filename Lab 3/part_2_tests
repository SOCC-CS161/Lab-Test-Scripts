#!/bin/bash

# Compile the blackjack game
g++ -o blackjack_game main.cpp || { echo "❌ COMPILATION FAILED"; exit 1; }

# Function to play a round of blackjack
play_blackjack() {
    # Start the game and capture the output
    ./blackjack_game > game_output.txt

    # Initialize hand value and ace count
    hand_value=0
    ace_count=0

    # Read the game output line by line
    while IFS= read -r line; do
        echo "Game says: $line"  # Echo the game output for logging

        # Check for hand value (e.g., "Hand: 8 A")
        if [[ "$line" =~ [[:space:]]*([0-9]+)[[:space:]]+([0-9JQKA]+)[[:space:]]* ]]; then
            # Extract the hand value and cards from the line
            hand_value=$(echo "$line" | grep -oP '\d+')
            cards=$(echo "$line" | grep -oP '[0-9JQKA]+')

            echo "Detected hand value: $hand_value with cards: $cards"

            # Check for blackjack or bust conditions
            if [[ "$hand_value" -eq 21 ]]; then
                echo "✅ PASSED: Blackjack detected."
            elif [[ "$hand_value" -gt 21 ]]; then
                echo "✅ PASSED: Bust detected."
            else
                # Check for "hit" prompt
                if echo "$line" | grep -iq "hit"; then
                    echo "✅ PASSED: Hit prompt detected."
                else
                    echo "❌ FAILED: No hit prompt detected when expected."
                fi
            fi
        else
            echo "No hand value detected in this line."
        fi
    done < game_output.txt
}

# Play a round of blackjack and check the output
play_blackjack

# Validate the output
# Check if the correct prompts are present
if ! grep -iq "blackjack" game_output.txt; then
    echo "❌ FAILED: Blackjack win message is not present."
fi

if ! grep -iq "bust" game_output.txt; then
    echo "❌ FAILED: Bust message is not present."
fi

if ! grep -iq "hit" game_output.txt; then
    echo "❌ FAILED: Hit prompt is not present."
fi

# Neatly print the program output
echo "--------------------------------------------------"
echo "Program Output:"
echo "--------------------------------------------------"
cat output.txt
echo "--------------------------------------------------"
echo "End of Program Output"
echo "--------------------------------------------------"
