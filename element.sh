#!/bin/bash

#---freeCodeCamp Relational Databases Lesson 13: Periodic Table Project---

# Use postgreSQL in bash file
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

PRINT_OUTPUT(){
  TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER;")
  MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER;")
  MELT_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER;")
  BOIL_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER;")
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT_POINT celsius and a boiling point of $BOIL_POINT celsius."
}

# Check to see if there is an argument
if [[ $1 ]]
then 
  
  # Identify elements by atomic_number
  
  if [[ $1 =~ ^[0-9]+$ ]]
  then 
    # Check for valid element number 
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1;")
    # Take actions is the element number is valid
    if [[ $NAME ]]
    then 
      ATOMIC_NUMBER=$1
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER;")
      TRACKER=true
      PRINT_OUTPUT
    fi
  else 
    # Check to see if the input is the name 
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1';")
    
    # take action when the input IS a name
    if [[ $ATOMIC_NUMBER ]]
    then 
      NAME=$1
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$NAME';")
      TRACKER=true
      PRINT_OUTPUT
    fi 

    # Check to see if the input is the symbol
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1';")

    if [[ $ATOMIC_NUMBER ]]
    then
      SYMBOL=$1
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$SYMBOL';")
      NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$SYMBOL';")
      TRACKER=true
      PRINT_OUTPUT
    fi

    # Print message if argument element is invalid
    if [[ ! $TRACKER ]]
    then 
      echo 'I could not find that element in the database.'
    fi
  fi
  
# Print message when there is no argument
else 
  echo 'Please provide an element as an argument.'
fi


