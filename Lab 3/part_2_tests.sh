#!/bin/bash

# Compile the blackjack game
g++ -o blackjack_game ./source/main.cpp || { echo "❌ COMPILATION FAILED"; exit 1; }

# Function to simulate a player decision based on the hand value
make_decision() {
    local hand_value=$1
    # Standard blackjack strategy: hit if hand value is less than 17
    if [[ "$hand_value" -lt 17 ]]; then
        echo "y"  # Choose to hit
    else
        echo "n"  # Choose to stay
    fi
}

# Function to play a round of blackjack
play_blackjack() {
    # Start the game
    echo "Starting the game..."
    ./blackjack_game > game_output.txt

    # Read the game output line by line and make decisions
    while IFS= read -r line; do
        echo "Game says: $line"  # Echo the game output for logging

        # Check for hand value and make decision based on that
        if [[ "$line" =~ You\'ve\ got\ ([0-9]+) ]]; then
            hand_value="${BASH_REMATCH[1]}"
            echo "Hand value: $hand_value"
            decision=$(make_decision "$hand_value")
            echo "$decision" # Output the decision for the game to read
        fi
    done < game_output.txt
}

# Play five rounds of blackjack
for i in {1..5}; do
    echo "=================================================="
    echo "Starting round $i of blackjack"
    echo "=================================================="
    play_blackjack
    # Delay to ensure different random outcomes
    sleep 1
done
