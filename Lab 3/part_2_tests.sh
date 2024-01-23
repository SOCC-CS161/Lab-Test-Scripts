#!/bin/bash

# Compile the blackjack game
g++ -o blackjack_game ./source/main.cpp || { echo "❌ COMPILATION FAILED"; exit 1; }

# Function to simulate a player decision based on the hand value
make_decision() {
    local hand_value=$1
    # Standard blackjack strategy: stand if hand value is 17 or more
    if [[ "$hand_value" -lt 17 ]]; then
        echo "y"  # Choose to hit
    else
        echo "n"  # Choose to stand
    fi
}

# Function to play a round of blackjack
play_blackjack() {
    # Start the game and redirect input from a subshell that makes decisions
    (for i in {1..4}; do
        read -r line
        hand_value=$(echo "$line" | grep -oP '\d+$')  # Extract hand value
        decision=$(make_decision "$hand_value")        # Make a decision based on the hand value
        echo "Decision made: $decision"                # Print the decision
        echo $decision                                 # Send the decision to the game
        sleep 1                                        # Sleep to allow for game processing
    done) | ./blackjack_game > game_output.txt
    
    # Process the game output
    hand_value=0
    bust_detected=false
    blackjack_detected=false
    hit_prompt_detected=false
    while IFS= read -r line; do
        echo "Game says: $line"  # Echo the game output for logging

        if [[ "$line" =~ You\'ve\ got\ ([0-9]+) ]]; then
            hand_value="${BASH_REMATCH[1]}"
            echo "Detected hand value: $hand_value"
            if [[ "$hand_value" -eq 21 ]]; then
                echo "✅ PASSED: Blackjack detected."
                blackjack_detected=true
            elif [[ "$hand_value" -gt 21 ]]; then
                echo "✅ PASSED: Bust detected."
                bust_detected=true
            fi
        fi

        if echo "$line" | grep -iq "Hit?"; then
            echo "✅ PASSED: Hit prompt detected."
            hit_prompt_detected=true
        fi
    done < game_output.txt

    # Print appropriate message based on game outcome
    if $blackjack_detected; then
        echo "✅ Blackjack win message is present."
    elif $bust_detected; then
        echo "✅ Bust message is present."
    elif $hit_prompt_detected; then
        echo "✅ Hit prompt is present."
    else
        echo "❌ FAILED: The expected outcome message was not detected."
    fi
}

# Play a round of blackjack and check the output
play_blackjack

# Neatly print the program output
echo "--------------------------------------------------"
echo "Program Output:"
echo "--------------------------------------------------"
cat game_output.txt
echo "--------------------------------------------------"
echo "End of Program Output"
echo "--------------------------------------------------"
