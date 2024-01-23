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
        echo "n"  # Choose to stand
    fi
}

# Function to play a round of blackjack and check the output
play_blackjack() {
    echo "Starting round of blackjack"

    # Initialize variables
    hand_value=0
    decision=""

    # Start the game and interact with it based on the hand value
    ( while true; do
        # Read the next line from the game's output
        if ! IFS= read -r line; then
            break
        fi

        echo "Game says: $line"  # Echo the game output for logging

        # Check if the line contains the hand value
        if [[ "$line" =~ You\'ve\ got\ ([0-9]+) ]]; then
            hand_value="${BASH_REMATCH[1]}"
            echo "Detected hand value: $hand_value"

            # Make a decision based on the hand value
            decision=$(make_decision "$hand_value")
            echo "Decision made: $decision"
            echo $decision
        fi
    done ) | ./blackjack_game > output.txt

    # Neatly print the program output for this round
    echo "--------------------------------------------------"
    echo "Program Output for this round:"
    cat output.txt
    echo "--------------------------------------------------"
    echo "End of Program Output for this round"
    echo "--------------------------------------------------"
}

# Run 5 rounds of blackjack
for i in {1..5}; do
    echo "=================================================="
    echo "Starting round $i of blackjack"
    echo "=================================================="
    play_blackjack
    sleep 1  # Ensure different random seeds
done
