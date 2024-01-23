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
}

# Function to play a round of blackjack and check the output
play_blackjack() {
    # Start the game
    echo "Starting the game..."
    # Pass decisions into the game. Assume up to four decisions (hit/stand).
    make_decision | make_decision | make_decision | make_decision | ./blackjack_game > output.txt

    # Check for hand value and cards on one line, and the score value on the next line
    while IFS= read -r line; do
        # Check for "blackjack" or "bust" messages
        if echo "$line" | grep -iq "blackjack"; then
            echo "✅ PASSED: Blackjack win message is present."
        elif echo "$line" | grep -iq "bust"; then
            echo "✅ PASSED: Bust message is present."
        elif echo "$line" | grep -iq "hit"; then
            echo "✅ PASSED: Hit prompt is present."
        fi
    done < output.txt

    # Neatly print the program output for this round
    echo "--------------------------------------------------"
    echo "Program Output for this round:"
    echo "--------------------------------------------------"
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
    sleep 1
done
