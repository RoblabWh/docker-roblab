#!/bin/bash

set -e

# init setup, only if is new workspace 
if [ ! -e ~/.config/init ]
then
	rm -rf ~/.bashrc
	cp /tmp/.bashrc ~/
  	mkdir -p ~/.config/terminator
	touch ~/.config/terminator/config
 	source "/opt/ros/$ROS_DISTRO/setup.bash"
	cd ~
	mkdir -p ~/docker_ws/src && cd ~/docker_ws/src && catkin_init_workspace && cd ~/docker_ws/ && catkin_make
	cd ~/docker_ws/src && wstool init . && wstool merge https://raw.githubusercontent.com/RethinkRobotics/baxter/master/baxter_sdk.rosinstall
	wstool update && cd ~/catkin_ws/src && git clone https://github.com/ros-planning/moveit_robots.git

	# setup ros environment
 	echo 'source /opt/ros/$ROS_DISTRO/setup.bash' >> ~/.bashrc
  	echo 'source ~/docker_ws/devel/setup.bash' >> ~/.bashrc
	cd ~/docker_ws && catkin_make && catkin_make install
	wget https://github.com/RethinkRobotics/baxter/raw/master/baxter.sh
	#Setup Qtcreator
	echo 'source /opt/qt59/bin/qt59-env.sh' >> ~/.bashrc
	touch ~/.config/init
fi

cd ~

#exec /usr/local/bin/gosu `awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd` "$@"
exec "$@"