#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

ARG="$1"

if [[ -z $ARG ]]
then
  echo -e "Please provide an element as an argument."
  exit
fi

RUN_FOR_NUMBER() {

NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $ELEMENT")
SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ELEMENT")
NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ELEMENT")
TYPE=$($PSQL "SELECT type FROM types RIGHT JOIN properties ON properties.type_id = types.type_id WHERE atomic_number = $ELEMENT")
MASS=$($PSQL "SELECT atomic_mass FROM types RIGHT JOIN properties ON properties.type_id = types.type_id WHERE atomic_number = $ELEMENT")
MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM types RIGHT JOIN properties ON properties.type_id = types.type_id WHERE atomic_number = $ELEMENT")
BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM types RIGHT JOIN properties ON properties.type_id = types.type_id WHERE atomic_number = $ELEMENT")
}

RUN_FOR_SYMBOL_OR_NAME() {
  
NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $ELEMENT")
SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ELEMENT")
NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ELEMENT")
TYPE=$($PSQL "SELECT type FROM types RIGHT JOIN properties ON properties.type_id = types.type_id WHERE atomic_number = $ELEMENT")
MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $NUMBER")
MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ELEMENT")
BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ELEMENT")
}

if [[ $ARG =~ ^[1-9]+$ ]]
then
  ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $ARG")
  if [[ -z $ELEMENT ]]
  then
    echo -e "I could not find that element in the database."
    exit
  else
    RUN_FOR_NUMBER
  fi
else
  ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$ARG' OR name = '$ARG'")
  if [[ -z $ELEMENT ]]
  then
    echo -e "I could not find that element in the database."
    exit
  else
    RUN_FOR_SYMBOL_OR_NAME
  fi
fi

echo -e "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
