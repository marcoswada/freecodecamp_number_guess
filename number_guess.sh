#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME
if [[ -z $USERNAME ]]
then
  exit
fi

RESULT=$($PSQL "SELECT count(username) as games, MIN(score) as best FROM number_guess WHERE username='$USERNAME'")

echo $RESULT|while IFS="|" read GAMES BEST
do
  if [[  $GAMES -eq 0 ]]
  then
    echo "Welcome, $USERNAME! It looks like this is your first time here."
  else
    echo "Welcome back, $USERNAME! You have played $GAMES games, and your best game took $BEST guesses."
  fi
done

NUMBER=$(( $RANDOM % 1000 + 1 ))
TRIES=0

echo "Guess the secret number between 1 and 1000:"

while true
do
  read GUESS
  TRIES=$(( $TRIES + 1 ))
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  elif [[ $GUESS > $NUMBER ]]
  then
    echo "It's lower than that, guess again:"
  elif [[ $GUESS < $NUMBER ]]
  then
    echo "It's higher than that, guess again:"
  else
    echo "You guessed it in $TRIES tries. The secret number was $NUMBER. Nice job!"
    RESULT=$($PSQL "INSERT INTO number_guess (username, score) VALUES ('$USERNAME', $TRIES)")
    exit
  fi

done

