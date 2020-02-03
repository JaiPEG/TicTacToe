# TicTacToe

## About

This project contains an interactive tic-tac-toe program that users can play
on the command-line. It allows any combination of human and computer players.
The computer plays optimally using the
[minimax](https://en.wikipedia.org/wiki/Minimax) algorithm.

This project was written as the first Julia assignment for Computational
Physics course at the Perimeter Institute in 2020.

## Running TicTacToe

In order to run the program you must first ensure that Julia is installed on
your machine and is present in your PATH environment variable. Next, make sure
your current directory is in the project directory and then type the following
on the command-line,

	julia --project=@. src/Main.jl

## Future Goals

Future goals include implementing alpha-beta pruning to make the minimax search
more efficient.
