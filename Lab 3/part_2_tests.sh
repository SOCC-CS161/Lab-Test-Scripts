#!/bin/bash

# Compile the blackjack game
g++ -o blackjack_game ./source/main.cpp || { echo "❌ COMPILATION FAILED"; exit 1; }

# Function to play a round of blackjack and check the output
play_blackjack() {
    echo "=================================================="
    echo "Starting round of blackjack"
    echo "=================================================="

    # Create a named pipe (FIFO) for communication with the game
    mkfifo game_pipe
    exec 3<> game_pipe

    # Start the game with input from the pipe
    ./blackjack_game <&3 > output.txt &

    # Read each line from the game's output
    while IFS= read -r line; do
        echo "$line"  # Echo the game output for logging

        # Check for hand value
        if [[ "$line" =~ "You've got" ]]; then
            hand_value=$(echo "$line" | grep -oP '\d+')
            # Standard blackjack strategy: hit if hand value is less than 17
            decision="n"  # Default to stand
            if [[ "$hand_value" -lt 17 ]]; then
                decision="y"  # Choose to hit
            fi
            echo "Decision made: $decision"  # Log the decision
            echo "$decision" >&3  # Send decision to the game
        fi

        # Check for game end conditions
        if [[ "$line" =~ "Blackjack" || "$line" =~ "Bust" ]]; then
            echo "✅ PASSED: Game ended with a message: $line"
            break
        fi
    done < output.txt

    # Clean up
    exec 3>&-
    rm game_pipe

    echo "--------------------------------------------------"
    echo "End of Program Output for this round"
    echo "--------------------------------------------------"
}

# Run a round of blackjack
play_blackjack
