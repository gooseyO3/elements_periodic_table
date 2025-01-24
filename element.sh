#! /bin/bash 
#Making accesible our database called "periodic_table"
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --tuples-only -c"

if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
  exit
fi

if [[ $1 =~ ^[1-9]+$ ]]
then
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = '$1'")
else
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE name = '$1' OR symbol = '$1'")
fi

# If the element argument is null, return and exit program.
if [[ -z $ELEMENT ]]
then
  echo -e "I could not find that element in the database."
  exit
fi

echo $ELEMENT | while IFS=" |" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING_POINT BOILING_POINT 
do
# testing output
  echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
done
