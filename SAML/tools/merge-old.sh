#!/bin/bash

# Pattern to match a requirement ID
REGEX="^\[.+]::"

function startTable() {
    : # Start table
    # echo '[cols="4a,1a,2a"]'
    # echo '|==='
    # echo '|Kantara Requirement|CATS Status|CATS Details'  
}

function endRow() {
    echo '===='
    if [[ $CATS_STATUS == 'Supported' ]] ; then
        echo
        echo '*CATS Support*: _Required_'
        echo
    else
        echo
        echo '*CATS Support*: _Constrained_'
        echo
        echo $CATS_DETAILS
        echo
    fi
}

function endTable {
    endRow
    # echo '|==='
}


REQUIREMENT=
while read SOURCE_LINE; do
   if [[ $SOURCE_LINE =~ ^= && -n $REQUIREMENT ]] ; then
      endTable
      REQUIREMENT=
   fi

   if [[ $SOURCE_LINE =~ $REGEX ]] ; then # New Requirement
      if [[ -z $REQUIREMENT ]] ; then 
         startTable
      else # Finish previous requirement
         endRow
      fi

      REQUIREMENT=$(echo $SOURCE_LINE | cut -f 1 -d ':' | tr -d '[]')
      SOURCE_LINE=${SOURCE_LINE#*:: }
      if  [[ -f ./src/constraints/$REQUIREMENT.adoc ]] ; then #CATS Constraints
         CATS_STATUS='Constrained'
         CATS_DETAILS=$(cat ./src/constraints/$REQUIREMENT.adoc)
      else
         CATS_STATUS='Supported'
         CATS_DETAILS=
      fi
      echo
      echo '*Kantara Requirement*: *_'$REQUIREMENT'_*'
      echo
      echo '===='
      echo
  fi
   
   echo "$SOURCE_LINE"
done

if [[ -n $REQUIREMENT ]] ; then
   endTable
fi
