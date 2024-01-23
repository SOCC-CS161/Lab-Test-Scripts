#!/bin/bash

# Compile the blackjack game
g++ -o blackjack_game ./source/main.cpp || { echo "❌ COMPILATION FAILED"; exit 1; }

# Function to play a round of blackjack and check the output
play_blackjack() {
    echo "=================================================="
    echo "Starting round of blackjack"
    echo "=================================================="

    # Start the game and handle its output/input dynamically
    {
        while IFS= read -r line; do
            echo "Game says: $line"  # Echo the game output for logging

            # Check for "blackjack" or "bust" messages
            if echo "$line" | grep -iq "blackjack"; then
                echo "✅ PASSED: Blackjack win message is present."
                break
            elif echo "$line" | grep -iq "bust"; then
                echo "✅ PASSED: Bust message is present."
                break
            elif echo "$line" | grep -iq "hit"; then
                echo "✅ PASSED: Hit prompt is present."
                # Extract hand value
                hand_value=$(echo "$line" | grep -oP '\d+')
                # Make a decision based on the hand value
                if [[ "$hand_value" -lt 17 ]]; then
                    echo "y"  # Choose to hit
                    echo "Decision made: Hit"
                else
                    echo "n"  # Choose to stand
                    echo "Decision made: Stand"
                fi
            fi
        done
    } | ./blackjack_game | tee output.txt
}

# Run 5 rounds of blackjack
for i in {1..5}; do
    play_blackjack
    sleep 1  # Ensure different random seeds
done
