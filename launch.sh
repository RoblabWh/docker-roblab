#!/bin/bash

#git pull
#docker pull cerka/ros-indigo-desktop-dev

if [ ! -e robotic_ws ]
then
	mkdir robotic_ws
fi
xhost +local:
QT_GRAPHICSSYSTEM="native" docker run -it --rm \
	--name roblabuser \
    	--privileged \
   	-e DISPLAY=unix$DISPLAY \
	-e LOCAL_USER_ID=`id -u $USER` \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v /etc/machine-id:/etc/machine-id \
	-v /home/$USER/docker/rob_env/robotic_ws:/home/user \
	--network="host" \
	roblab/environment \
	bash

xhost -local:

#wat
