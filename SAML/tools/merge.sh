#!/bin/bash

# Pattern to match a requirement ID
REGEX="^\[.+]::"

function startTable() {
    : # Start table
    # echo '[cols="4a,1a,2a"]'
    # echo '|==='
    # echo '|Kantara Requirement|CATS Status|CATS Details'  
}

function endRequirement() {
    echo '===='
    echo
    if [[ $CATS_STATUS == 'Constrained' ]] ; then
        echo "*CATS Support*: _Constrained_"
        echo
        cat $CATS_DETAILS
        echo
    else
        echo "*CATS Support*: _${CATS_STATUS}_"
    fi
    echo
    echo "''''"
}

declare -A applicable
source ./src/applicable.dat

REQUIREMENT=
while read SOURCE_LINE; do
   if [[ $SOURCE_LINE =~ ^= && -n $REQUIREMENT ]] ; then
      endRequirement
      REQUIREMENT=
   fi

   if [[ $SOURCE_LINE =~ $REGEX ]] ; then # New Requirement
      if [[ -n $REQUIREMENT ]] ; then 
         endRequirement
      fi

      REQUIREMENT=$(echo $SOURCE_LINE | cut -f 1 -d ':' | tr -d '[]')
      SOURCE_LINE=${SOURCE_LINE#*:: }
      CATS_DETAILS=
      if  [[ -f ./src/constraints/$REQUIREMENT.adoc ]] ; then #CATS Constraints
         CATS_STATUS='Constrained'
         CATS_DETAILS="./src/constraints/$REQUIREMENT.adoc"
      elif [[ -n ${applicable[$REQUIREMENT]} ]] ; then
         CATS_STATUS=${applicable[$REQUIREMENT]}
      else
         CATS_STATUS='Supported'
         
      fi
      echo
      echo '*Kantara Requirement*: *_['$REQUIREMENT']_*'
      echo
      echo '===='
      echo
  fi
   
   echo "$SOURCE_LINE"
done

if [[ -n $REQUIREMENT ]] ; then
   endRequirement
fi
