#!/bin/bash

# Compile the blackjack game
g++ -o blackjack_game ./source/main.cpp || { echo "❌ COMPILATION FAILED"; exit 1; }

# Function to play a round of blackjack and check the output
play_blackjack() {
    local input_sequence="$1"
    local blackjack_count=0
    local bust_count=0
    local win_count=0

    # Number of rounds to run
    local NUMBER_OF_ROUNDS=10000

    for i in $(seq 1 $NUMBER_OF_ROUNDS); do
        echo -e "$input_sequence" | ./blackjack_game > output.txt

        # Tally outcomes
        if grep -iq "blackjack" output.txt; then
            ((blackjack_count++))
        elif grep -iq "bust" output.txt; then
            ((bust_count++))
        elif grep -iq "win" output.txt; then
            ((win_count++))
        fi
    done

    # Print summary
    echo "Outcome for input sequence '$input_sequence':"
    echo "Blackjack: $blackjack_count times"
    echo "Bust: $bust_count times"
    echo "Win: $win_count times"
    echo "----------------------------------------"
}

# Define game input for different scenarios
no_hit_blackjack="" # No input needed, initial deal could be blackjack
no_hit_stand="n\n" # User decides to stand on the initial hand
one_hit="y\nn\n"
two_hits="y\ny\nn\n"
three_hits="y\ny\ny\nn\n"
four_hits="y\ny\ny\ny\nn\n"

# Run the game for each scenario
play_blackjack "$no_hit_blackjack"
play_blackjack "$no_hit_stand"
play_blackjack "$one_hit"
play_blackjack "$two_hits"
play_blackjack "$three_hits"
play_blackjack "$four_hits"
