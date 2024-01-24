#!/bin/bash

# Compile the blackjack game
g++ -o blackjack_game ./source/main.cpp || { echo "❌ COMPILATION FAILED"; exit 1; }

# Function to play a round of blackjack
play_blackjack() {
    local hits=$1
    local blackjacks=0
    local wins=0
    local busts=0

    for (( i=0; i<1000; i++ )); do
        # Run the game with predetermined hits
        yes 'y/' | head -n "$hits" | ./blackjack_game > game_output.txt
        yes 'n/' | ./blackjack_game >> game_output.txt

        # Check the outcome
        if grep -iq "blackjack" game_output.txt; then
            ((blackjacks++))
        elif grep -iq "win" game_output.txt; then
            ((wins++))
        elif grep -iq "bust" game_output.txt; then
            ((busts++))
        fi
    done

    echo "For $hits hits:"
    echo "Blackjacks: $blackjacks"
    echo "Wins: $wins"
    echo "Busts: $busts"
}

# Test different scenarios
for hits in {1..4}; do
    play_blackjack $hits
done
