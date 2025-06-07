#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else

  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$1
  else

    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = INITCAP('$1');")
    if [[ -z $ATOMIC_NUMBER ]]
    then

      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = INITCAP('$1');")
    fi
  fi
-
  if [[ -n $ATOMIC_NUMBER ]]
  then
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER;")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER;")
    CLASS=$($PSQL "SELECT class FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")

    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $CLASS, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  else
    echo "I could not find that element in the database."
  fi
fi
