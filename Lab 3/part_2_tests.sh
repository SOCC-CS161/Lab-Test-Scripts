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

# Play a round of blackjack and check the output
play_blackjack() {
    # Start the game
    echo "Starting the game..."
    # Pass decisions into the game based on the hand value
    hand_value=0  # Initial hand value
    ace_count=0  # Initial ace count
    decision=$(make_decision $hand_value)
    echo $decision | ./blackjack_game > game_output.txt

    # Process the game output
    while IFS= read -r line; do
        echo "Game says: $line"  # Echo the game output for logging

        # Extract the hand value if present
        if [[ "$line" =~ You\'ve\ got\ ([0-9]+) ]]; then
            hand_value=${BASH_REMATCH[1]}
            echo "Detected hand value: $hand_value"

            # Update the decision based on the new hand value
            decision=$(make_decision $hand_value)
            echo $decision > decision.txt  # Write decision to a file for input

            # If we have a blackjack or bust, break the loop
            if [[ "$hand_value" -eq 21 ]]; then
                echo "✅ PASSED: Blackjack detected."
                break
            elif [[ "$hand_value" -gt 21 ]]; then
                echo "✅ PASSED: Bust detected."
                break
            fi
        fi
    done < game_output.txt

    # Check for prompts and messages
    if grep -iq "blackjack" game_output.txt; then
        echo "✅ PASSED: Blackjack win message is present."
    else
        echo "❌ FAILED: Blackjack win message is not present."
    fi

    if grep -iq "bust" game_output.txt; then
        echo "✅ PASSED: Bust message is present."
    else
        echo "❌ FAILED: Bust message is not present."
    fi

    if grep -iq "hit" game_output.txt; then
        echo "✅ PASSED: Hit prompt is present."
    else
        echo "❌ FAILED: Hit prompt is not present."
    fi
}

# Play multiple rounds of blackjack
for i in {1..5}; do
    echo "=================================================="
    echo "Starting round $i of blackjack"
    echo "=================================================="
    sleep 1  # Ensure different seed for random function
    play_blackjack
done

# Neatly print the last round program output
echo "--------------------------------------------------"
echo "Program Output:"
echo "--------------------------------------------------"
cat game_output.txt
echo "--------------------------------------------------"
echo "End of Program Output"
echo "--------------------------------------------------"
