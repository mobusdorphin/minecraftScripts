#!/bin/bash

#Define Session and Window Names
source minecraft.var #Contains variables $SESSION, $server[]. $ROOT_MC_DIR, and $MC_EXEC
count=0 #Variable to be incremented after each server is loaded, denotes window number
ZERO=0 #Constant variable to compare with $count
#Change to first directory and start first server in default window
cd $ROOT_MC_DIR/"${server[0]}"
tmux new-session -s "$SESSION" -n ${server[0]} -d ./$MC_EXEC #Initiate tmux session and start first server in default window

#Change directory to each folder and run respective startup scripts for each modpack
for window in "${server[@]}"
do
	if [ $count -ne $ZERO ] #Skip first instance because it was already initiated on the default window
	then
		cd $ROOT_MC_DIR/"$window" #Change to directory name specified in server array
		tmux new-window -t "$SESSION:$count" -n ${window} ./$MC_EXEC #Initate new tmux window within the same session using the name of the directory as the name of the tmux window
	fi
	count=$((count+1)) #Increment count variable so next iteration starts on next window
done

#Attach the newly-created tmux session that should display each of our Minecraft consoles for each respective server using variable in case other tmux sessions are running
tmux attach -t $SESSION
