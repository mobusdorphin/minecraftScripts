#!/bin/bash
source ~/minecraft.var


#Begin 5 minute warning, sleep for 225 seconds (4 minutes minus the next 15 seconds that are slept at the beginning of the next loop)
for window in "${server[@]}"
do
	tmux send-keys -t "$session:$window" "/say Server will restart in 5 minutes" enter
done
sleep 225

#Finish final 15 seconds of first 4 minutes, begin final minute countdown in increments of 15 seconds until 15 seconds left
for sec in 60 45 30 15
do
	sleep 15
	for window in "${server[@]}"
	do
		tmux send-keys -t "$session:$window" "/say Server will restart in $sec seconds" enter
	done
done

#Bring timer to 5 seconds in 5 second intervals
for sec in 10 5
do
	sleep 5
	for window in "${server[@]}"
	do
		tmux send-keys -t "$session:$window" "/say Server will restart in $sec seconds" enter
	done
done

#Sleep for final 5 seconds

sleep 5

#Send final shutdown message
for window in "${server[@]}"
do
	tmux send-keys -t "$session:$window" "/say Server will restart NOW" enter
done

#1 second filler to allow clients to see final shutdown message

sleep 1

#Send graceful stop command through MC Console
for window in "${server[@]}"
do
	tmux send-keys -t "$session:$window" stop enter
done

#Wait an additional 60 seconds to allow servers to gracefully close before forcing screens to close completely.
sleep 60
tmux kill-server
