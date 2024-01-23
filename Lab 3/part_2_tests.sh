#!/bin/bash

# Compile the blackjack game
g++ -o blackjack_game ./source/main.cpp || { echo "❌ COMPILATION FAILED"; exit 1; }

# Function to play a round of blackjack
play_blackjack() {
    echo "=================================================="
    echo "Starting round of blackjack"
    echo "=================================================="

    # Prepare decisions for the game (maximum four decisions)
    decisions=$(printf "y\ny\ny\ny\n")

    # Run the game and capture the output
    echo -e "$decisions" | ./blackjack_game > output.txt
    echo -e "$decisions"

    # Analyze the output
    if grep -iq "blackjack" output.txt; then
        echo "✅ PASSED: Blackjack win message is present."
    fi

    if grep -iq "bust" output.txt; then
        echo "✅ PASSED: Bust message is present."
    fi

    if grep -iq "hit" output.txt; then
        echo "✅ PASSED: Hit prompt is present."
    fi

    # Print the program output for this round
    echo "--------------------------------------------------"
    echo "Program Output for this round:"
    cat output.txt
    echo "--------------------------------------------------"
    echo "End of Program Output for this round"
    echo "--------------------------------------------------"
}

# Run multiple rounds of blackjack
for i in {1..5}; do
    play_blackjack
    sleep 1 # Ensure different random seeds
done
