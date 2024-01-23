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
    ./blackjack_game > output.txt &

    # Get the PID of the game process
    game_pid=$!

    # Function to process the game output
    process_game_output() {
        while IFS= read -r line; do
            echo "Game says: $line"  # Echo the game output for logging

            # Check for "blackjack" or "bust" messages
            if echo "$line" | grep -iq "blackjack"; then
                echo "✅ PASSED: Blackjack win message is present."
            elif echo "$line" | grep -iq "bust"; then
                echo "✅ PASSED: Bust message is present."
            elif echo "$line" | grep -iq "hit"; then
                hand_value=$(echo "$line" | grep -oP '\d+')
                decision=$(make_decision "$hand_value")
                echo "Decision made: $decision"
                
                # Send decision to the game
                echo "$decision" > /proc/"$game_pid"/fd/0
                sleep 1  # Wait a second for the game to process the input
            fi
        done < output.txt
    }

    # Process the game output
    process_game_output

    echo "--------------------------------------------------"
    echo "End of Program Output for this round"
    echo "--------------------------------------------------"
}

# Run a round of blackjack
play_blackjack
