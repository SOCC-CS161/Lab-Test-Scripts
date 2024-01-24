#!/bin/bash




     g++ -x c++ - -o blackjack_game || { echo "❌ COMPILATION FAILED"; exit 1; }

    # Run the game, pass the input and capture the output
    echo -e "$input" | ./blackjack_game > game_output.txt

  

    # Print the program output
    echo "--------------------------------------------------"
    echo "Program Output:"
    cat game_output.txt
    echo "--------------------------------------------------"
