#!/bin/bash

DIR1=/root/afs/git/af-webgui
DIR2=/root/afs/git/af-webgui.syin

echo
echo "=== Doing comparison of the following directories:"
echo DIR1 = $DIR1
echo DIR2 = $DIR2
echo
echo
echo "=== Differences in directory contents:"
echo
echo = Files that exist in DIR1 but not DIR2:
diff <(cd ${DIR1}; find . | sort) <(cd ${DIR2}; find . | sort) | grep ^\< | grep -v '.pyc$' | grep -v '.pyo$' | grep -v ^'< ./.git'
echo
echo = Files that exist in DIR2 but not DIR1:
diff <(cd ${DIR1}; find . | sort) <(cd ${DIR2}; find . | sort) | grep ^\> | grep -v '.pyc$' | grep -v '.pyo$' | grep -v ^'> ./.git'
echo
echo
echo "=== Comparing DIR1 listing against DIR2 (unique files in DIR2 are not evaluated):"
cd ${DIR1}
find . -type f -print0 | while read -d $'\0' FILE
do

   ### If there are files you don't care about comparing, check for them and skip to the next iteration of the loop.
   if [[ $(echo "$FILE" | grep -e '\.pyc$' -e '\.pyo$' -e ^'./.git' | wc -l) -ne 0 ]]
   then
      continue
   fi

   ### Check to see if file from DIR1 is present in DIR2.  If so, proceed, else print an error.
   if [[ -e "${DIR2}/${FILE}" ]]
   then
       if [[ $(md5sum "${DIR1}/${FILE}" | awk '{print $1}') != $(md5sum "${DIR2}/${FILE}" | awk '{print $1}') ]]
       then
          echo $FILE
       fi
    else
       echo "WARNING: $FILE exists in DIR1 but not in DIR2."
    fi

done
echo
