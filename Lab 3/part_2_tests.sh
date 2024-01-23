#!/bin/bash

# Compile the blackjack game
g++ -o blackjack_game ./source/main.cpp || { echo "❌ COMPILATION FAILED"; exit 1; }

# Function to play a round of blackjack and check the output
play_blackjack() {
    echo "=================================================="
    echo "Starting round of blackjack"
    echo "=================================================="

    # Start the game and redirect its output to a file
    ./blackjack_game > output.txt &

    # Get the PID of the game process
    game_pid=$!

    # Function to make a decision based on the hand value
    make_decision() {
        hand_value="$1"
        if [[ "$hand_value" -lt 17 ]]; then
            echo "y"  # Choose to hit
        else
            echo "n"  # Choose to stand
        fi
    }

    # Read each line from the game's output
    while IFS= read -r line; do
        echo "$line"  # Echo the game output for logging

        # Check for the player's hand value
        if [[ "$line" =~ "You've got" ]]; then
            hand_value=$(echo "$line" | grep -oP '\d+')
            decision=$(make_decision "$hand_value")
            echo "Decision made: $decision"
            
            # Send decision to the game
            kill -SIGUSR1 "$game_pid"
            echo "$decision" > /proc/"$game_pid"/fd/0
        fi

        # Check for game end conditions
        if [[ "$line" =~ "Blackjack" || "$line" =~ "Bust" ]]; then
            echo "✅ PASSED: Game ended with a message: $line"
            break
        fi
    done < output.txt

    echo "--------------------------------------------------"
    echo "End of Program Output for this round"
    echo "--------------------------------------------------"
}

# Run a round of blackjack
play_blackjack
