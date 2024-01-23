#!/bin/bash

# Compile the blackjack game
g++ -o blackjack_game ./source/main.cpp || { echo "❌ COMPILATION FAILED"; exit 1; }

# Function to play a round of blackjack and check the output
play_blackjack() {
    echo "Starting round of blackjack"

    # Start the game and direct output to a file
    {
        while IFS= read -r line; do
            echo "Game says: $line"  # Echo the game output for logging

            # Check for "blackjack" or "bust" messages
            if echo "$line" | grep -iq "blackjack"; then
                echo "✅ PASSED: Blackjack win message is present."
                break  # End the loop if blackjack is achieved
            elif echo "$line" | grep -iq "bust"; then
                echo "✅ PASSED: Bust message is present."
                break  # End the loop if bust occurs
            elif echo "$line" | grep -iq "hit"; then
                echo "✅ PASSED: Hit prompt is present."
                # Extract the hand value and make a decision
                hand_value=$(echo "$line" | grep -oP '\d+')
                if [[ "$hand_value" -lt 17 ]]; then
                    echo "Decision made: Hit"
                    echo "y"  # Choose to hit
                else
                    echo "Decision made: Stand"
                    echo "n"  # Choose to stand
                fi
            fi
        done
    } | ./blackjack_game > output.txt

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
