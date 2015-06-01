#!/bin/bash
### VARIABLES ###
USERFILE="/config/groups.json"
TEMPDIR="/tmp"
SCRIPTDIR="/root/json-parser"
# Get current list of groups
/opt/pynab/pynab.py group list | sed 's/\s.*$//' > $TEMPDIR/current-groups
#  Convert the user file to something far easier to work with
cat "$USERFILE" | $SCRIPTDIR/json.sh -b > $TEMPDIR/myUser.json
# Go through the list and enable / disable as required
ENTRY=0
while :
do
if ! cat $TEMPDIR/myUser.json | grep -i "\[$ENTRY,\"name\"]" > /dev/null
then
break
fi
GROUP=$(cat $TEMPDIR/myUser.json | grep -i "\[$ENTRY,\"name\"" | sed 's/^.*name/name/' | sed 's/^......//' | sed -e 's/^[ \t]*//' | sed 's/\"//g' )
ACTIVE=$(cat $TEMPDIR/myUser.json | grep -i "\[$ENTRY,\"active\"" | sed 's/^.*active/active/' | sed 's/^........//' | sed -e 's/^[ \t]*//' | sed 's/\"//g' | tr '[:upper:]' '[:lower:]' )
if [ $ACTIVE == "true" ]
then
python3 /opt/pynab/pynab.py group add $GROUP  >/dev/null 2>&1
else
python3 /opt/pynab/pynab.py group disable $GROUP >/dev/null 2>&1
fi
# get current user list of groups
echo $GROUP >> $TEMPDIR/user-groups
ENTRY=$((ENTRY + 1))
done

comm -13 <(sort $TEMPDIR/user-groups) <(sort $TEMPDIR/current-groups) > $TEMPDIR/delete-groups
cat "$TEMPDIR/delete-groups" | while read LINE

do
        python3 /opt/pynab/pynab.py group delete $LINE >/dev/null 2>&1
done

rm $TEMPDIR/myUser.json $TEMPDIR/user-groups $TEMPDIR/current-groups $TEMPDIR/delete-groups
