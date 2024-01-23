#!/bin/bash

# Compile the blackjack game
g++ -o blackjack_game ./source/main.cpp || { echo "❌ COMPILATION FAILED"; exit 1; }

# Function to simulate a player decision based on the hand value
make_decision() {
    local hand_value=$1
    # Standard blackjack strategy: hit if hand value is less than 17
    if [[ "$hand_value" -lt 17 ]]; then
        echo "y\n"  # Choose to hit
    else
        echo "n\n"  # Choose to stand
    fi
} | ./blackjack_game

# Function to play a round of blackjack and check the output
play_blackjack() {
    echo "=================================================="
    echo "Starting round of blackjack"
    echo "=================================================="

    # Start the game and direct output to a file
    { 
        while true; do
            if read -r line; then
                echo "$line"  # Echo the game output for logging
                if [[ "$line" =~ "You've got" ]]; then
                    hand_value=$(echo "$line" | grep -oP '\d+')
                    decision=$(make_decision "$hand_value")
                    echo "$decision"  # Make a decision based on the hand value
                elif [[ "$line" =~ "Blackjack" ]]; then
                    echo "✅ PASSED: Blackjack detected."
                    break
                elif [[ "$line" =~ "Bust" ]]; then
                    echo "✅ PASSED: Bust detected."
                    break
                fi
            else
                break  # Exit the loop if there's no more input
            fi
        done
    }

    echo "--------------------------------------------------"
    echo "End of Program Output for this round"
    echo "--------------------------------------------------"
}

# Run a round of blackjack
play_blackjack
