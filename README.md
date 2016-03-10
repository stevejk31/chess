# Chess

## About
This is a two-player chess game written in Ruby and played in the console. It
features the full range of chess win conditions including checkmate and stalemate. 
Creating this game involved using a series of algorithms to check the validity 
of potential moves. There is a multi-level class inheritance structure to make piece 
movement logic DRY.

## How To Play
Download the repo. In the chess folder, run `ruby /lib/game.rb`

## Features
- Validates full range of chess movement
- Chess coordinate notation for ease of input
- Check, checkmate, and stalemate checks and notifications

## To-Do
- Add castling and pawn promotion
- Basic AI that uses breadth-first searches to choose moves
- Fully transition to chess notation from coordinate notation
- A printout of the full game's chess notation to allow real-world sharing
