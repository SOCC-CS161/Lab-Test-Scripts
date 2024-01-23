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
    # Pass decisions into the game. Assume up to four decisions (hit/stand).
    make_decision | make_decision | make_decision | make_decision | ./blackjack_game > output.txt

    # Check for hand value and cards on one line, and the score value on the next line
    hand_value_detected=false
    while IFS= read -r line; do
        echo "Game says: $line"  # Echo the game output for logging

        # Regex to match hand values and card face values on one line
        if [[ $line =~ ([0-9AJQK]{1,2}[[:space:]]+[0-9AJQK]{1,2}) ]]; then
            cards_line="$line"
            hand_value_detected=true
            echo "Detected cards: $cards_line"
        elif $hand_value_detected && [[ $line =~ [[:space:]]*([0-9]{1,2})[[:space:]]* ]]; then
            hand_value="${BASH_REMATCH[1]}"
            echo "Detected hand value: $hand_value"
            hand_value_detected=false

            # Check if hand value equals 21 for a blackjack
            if [[ "$hand_value" -eq 21 ]]; then
                echo "✅ PASSED: Blackjack detected with hand value $hand_value."
            elif [[ "$hand_value" -gt 21 ]]; then
                echo "✅ PASSED: Bust detected with hand value $hand_value."
            else
                echo "✅ PASSED: Hand value $hand_value detected and under 21."
            fi
        fi

        # Check for "hit" prompt on a separate line
        if echo "$line" | grep -iq "hit"; then
            echo "✅ PASSED: Hit prompt detected."
        fi
    done < output.txt
}

# Validate the output
# Check if the correct prompts are present
if ! grep -iq "blackjack" output.txt; then
    echo "❌ FAILED: Blackjack win message is not present."
fi

if ! grep -iq "bust" output.txt; then
    echo "❌ FAILED: Bust message is not present."
fi

if ! grep -iq "hit" output.txt; then
    echo "❌ FAILED: Hit prompt is not present."
fi

# Neatly print the program output
echo "--------------------------------------------------"
echo "Program Output:"
echo "--------------------------------------------------"
cat output.txt
echo "--------------------------------------------------"
echo "End of Program Output"
echo "--------------------------------------------------"
