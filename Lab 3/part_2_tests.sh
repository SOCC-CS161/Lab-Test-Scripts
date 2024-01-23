#!/bin/bash

# Compile the blackjack game
g++ -o blackjack_game ./source/main.cpp || { echo "❌ COMPILATION FAILED"; exit 1; }

# Function to play a round of blackjack and check the output
play_blackjack() {
    # Start the game
    echo "Starting the game..."
    ./blackjack_game > output.txt

    # Initialize hand value
    hand_value=0

    # Read the game output line by line
    while IFS= read -r line; do
        echo "Game says: $line"  # Echo the game output for logging

        # Check for hand value
        if [[ "$line" =~ [[:space:]]*Hand:[[:space:]]*([0-9]+)[[:space:]]* ]]; then
            hand_value="${BASH_REMATCH[1]}"
            echo "Detected hand value: $hand_value"

            # Make a decision based on the hand value
            if [[ "$hand_value" -lt 17 ]]; then
                decision="y\n"
            else
                decision="n\n"
            fi
            echo "Decision made: $decision" >> output.txt

            # Send the decision to the game
            echo "$decision" > decision_pipe
        fi

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

# Create a named pipe for decisions
mkfifo decision_pipe

# Run 5 rounds of blackjack
for i in {1..5}; do
    echo "=================================================="
    echo "Starting round $i of blackjack"
    echo "=================================================="
    play_blackjack
    sleep 1
done

# Clean up
rm decision_pipe
