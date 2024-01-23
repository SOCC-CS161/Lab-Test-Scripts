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

    # Start the game and direct output to a file
    decisions=""
    for _ in {1..4}; do
        decision=$(make_decision)
        decisions+="$decision\n"
        echo "Decision made: $decision"
    done
    echo -e "$decisions" | ./blackjack_game > output.txt

    # Read each line from the game's output
    initial_hand_blackjack=false
    while IFS= read -r line; do
        echo "Game says: $line"  # Echo the game output for logging

        # Check for "blackjack" or "bust" messages
        if echo "$line" | grep -iq "blackjack"; then
            echo "✅ PASSED: Blackjack win message is present."
            initial_hand_blackjack=true
        elif echo "$line" | grep -iq "bust"; then
            echo "✅ PASSED: Bust message is present."
        elif echo "$line" | grep -iq "hit"; then
            if ! $initial_hand_blackjack; then
                echo "✅ PASSED: Hit prompt is present."
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

# Run 5 rounds of blackjack
for i in {1..5}; do
    echo "=================================================="
    echo "Starting round $i of blackjack"
    echo "=================================================="
    play_blackjack
    sleep 1  # Ensure different random seeds
done
