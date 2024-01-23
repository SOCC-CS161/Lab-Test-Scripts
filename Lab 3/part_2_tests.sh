#!/bin/bash

# Compile the blackjack game
g++ -o blackjack_game ./source/main.cpp || { echo "❌ COMPILATION FAILED"; exit 1; }

# Function to play a round of blackjack and check the output
play_blackjack() {
    echo "Starting round of blackjack"

    # Start the game and direct output to a file
    ./blackjack_game > output.txt

    # Read each line from the game's output
    while IFS= read -r line; do
        echo "Game says: $line"  # Echo the game output for logging

        # Detect hand value and make decisions
        if [[ "$line" =~ You\'ve\ got\ ([0-9]+) ]]; then
            hand_value="${BASH_REMATCH[1]}"
            echo "Detected hand value: $hand_value"

            # Decide whether to hit or stay based on hand value
            if [[ "$hand_value" -lt 17 ]]; then
                decision="y\n"  # Hit
            else
                decision="n\n"  # Stay
            fi
            echo "Decision made: $decision"
            echo -e "$decision" > decision.txt

            # Check for blackjack, bust, or hit prompt
            if [[ "$hand_value" -eq 21 ]]; then
                echo "✅ PASSED: Blackjack detected."
            elif [[ "$hand_value" -gt 21 ]]; then
                echo "✅ PASSED: Bust detected."
            elif echo "$line" | grep -iq "hit"; then
                echo "✅ PASSED: Hit prompt detected."
            fi
        fi
    done < output.txt

    # Neatly print the program output for this round
    echo "--------------------------------------------------"
    echo "Program Output for this round:"
    cat output.txt
    echo "--------------------------------------------------"
    echo "End of Program Output for this round"
    echo "--------------------------------------------------"
}

# Run multiple rounds of blackjack
for i in {1..5}; do
    echo "=================================================="
    echo "Starting round $i of blackjack"
    echo "=================================================="
    play_blackjack
    sleep 1  # Ensure different random seeds
done
