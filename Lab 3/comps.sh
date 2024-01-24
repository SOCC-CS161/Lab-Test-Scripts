#!/bin/bash




     g++ -o blackjack_game ./source/main.cpp || { echo "Compilation failed";}


    # Run the game, pass the input and capture the output
    echo -e "$input" | ./blackjack_game > game_output.txt

  

    # Print the program output
    echo "--------------------------------------------------"
    echo "Program Output:"
    cat game_output.txt
    echo "--------------------------------------------------"
