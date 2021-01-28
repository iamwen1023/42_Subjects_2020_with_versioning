#!/bin/bash

caffeinate -s -d -t 5400 &
CAFF_PID=$!

# date +%F
# output 2020-05-18
date=$(date +%F)

#Folder to keep the logs of each update
mkdir -p cron_logs/subjects


test -f ${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs && source ${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs

DESKTOP=${XDG_DESKTOP_DIR:-$HOME/Desktop}
name="starting______sub______update.txt"
logs='./src/logs.txt'
no_changes='./src/t.txt'


touch  $DESKTOP"/"$name

# delete the repository and reclone it everytime
#rm -rf v
#git clone git@github.com:Kwevan/42_Subjects_2020_with_versioning.git v



# getting the script to update the subjects
$(which git) clone git@github.com:Kwevan/update_versionning.git u

if [ ! -d ./u/ ]; then
    echo "Update directory not found!"
    exit 1
fi


rm -rf v/src v/.env v/update.sh
mv u/src u/.env u/update.sh v/
rm -rf u


# start updating

cd v && ./update.sh 

# end of update


# check if there is new subjects

git status  > $logs

cat $logs

DIFF=$(diff ${logs} ${no_changes})

if [ "$DIFF" != "" ]
then
	#this will only get modified files not new files
	echo $(echo $(git diff --name-only   |  cut -d'/' -f2 -f1 ) | sed 's/ /, /g' )  - update > $logs
	cp ./src/logs.txt $DESKTOP"/subjects_update.txt"

	# don't get why the \n doesn't work so I add a new line in the string...
	../send_email.sh "Updates sur les sujets gro: $diff

https://github.com/Kwevan/42_Subjects_2020_with_versioning"
#	../push.sh
fi


rm  $DESKTOP"/"$name

kill $CAFF_PID
cd ..
touch ~/cron_logs/subjects/$date

