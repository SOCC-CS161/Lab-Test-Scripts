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
    echo "=================================================="
    echo "Starting round of blackjack"
    echo "=================================================="

    # Start the game
    ./blackjack_game | while IFS= read -r line; do
        echo "$line"  # Echo the game output for logging

        # Check for hand value
        if [[ "$line" =~ "You've got" ]]; then
            hand_value=$(echo "$line" | grep -oP '\d+')
            decision=$(make_decision "$hand_value")
            echo "Decision made: $decision"  # Log the decision
            echo "$decision" >&3  # Send decision to the game
        fi

        # Check for game end conditions
        if [[ "$line" =~ "Blackjack" || "$line" =~ "Bust" ]]; then
            echo "✅ PASSED: Game ended with a message: $line"
            break
        fi
    done 3>&1

    echo "--------------------------------------------------"
    echo "End of Program Output for this round"
    echo "--------------------------------------------------"
}

# Run a round of blackjack
play_blackjack
