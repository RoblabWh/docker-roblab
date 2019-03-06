FROM ros:kinetic

RUN apt-get update && apt-get upgrade -y && \
	apt-get install -y \
		software-properties-common \
		curl

#Gosu
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.10/gosu-$(dpkg --print-architecture)" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.10/gosu-$(dpkg --print-architecture).asc" \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu

RUN apt-get update && apt-get install -y \
	libcanberra-gtk-module \
	openssh-client \
	gitk \
	ros-kinetic-openni2-launch \
	libx264-dev \
	ros-kinetic-lms1xx \
	ros-kinetic-dynamixel-motor \
	ros-kinetic-urg-node \
	&& rm -rf /var/lib/apt/lists/*

#Navigation stack
RUN apt-get update && apt-get upgrade -y && \
        apt-get install -y \
                ros-${ROS_DISTRO}-navigation \
        && rm -rf /var/lib/apt/lists/*

#install Cmake
RUN         curl -O https://cmake.org/files/v3.7/cmake-3.7.2.tar.gz \
                && tar -xvf cmake-3.7.2.tar.gz \
           && cd cmake-3.7.2 && ./bootstrap \
                && make \
                && make install \
		&& cd .. && rm -r cmake-3.7.2 && rm cmake-3.7.2.tar.gz

#RUN apt-get update && apt-get install -y jackd1 ros-kinetic-sound-play && rm -rf /var/lib/apt/lists/*

#*************************Adding User****************************************
RUN useradd --no-log-init -m -d /home/user -p $(openssl passwd -crypt ros) -s /bin/bash user
RUN usermod -G video -a 'user'
RUN usermod -G sudo -a 'user'

#**************************************************QT CREATOR*************************************************************

#Add Repositorys
RUN apt-get update && apt-get upgrade -y \
	&& add-apt-repository ppa:levi-armstrong/qt-libraries-xenial \
	&& add-apt-repository ppa:levi-armstrong/ppa

#Install QT Serial Package (Robot Batterystatus)
RUN	apt-get update && apt-get install -y \
	qt57serial*

#Install QT Creator
RUN apt-get update && apt-get install -y \
		qt59creator \
		qt57creator-plugin-ros \
	&& ln -s /opt/qt59/bin/qtcreator-wrapper /usr/bin/qtcreator


#Install Rviz with QT5
#ADD extrafiles/rviz_ws.tar /tmp
#RUN mv /bin/sh /bin/shx && ln -s /bin/bash /bin/sh
#RUN source /opt/ros/kinetic/setup.bash && source /opt/qt57/bin/qt57-env.sh && cd /tmp/rviz_ws && catkin_make -DCMAKE_INSTALL_PREFIX=/opt/ros/kinetic install
#RUN rm -r /tmp/rviz_ws && rm /bin/sh && mv /bin/shx /bin/sh

#Install other programms
RUN apt-get update && apt-get upgrade -y \
	&& apt-get install -y \
		nano \
		terminator \
		wget \
		bash \
		iputils-ping \
		iproute2 \
		net-tools \
		emacs

#**************************************************Baxter******************************************************************

RUN apt-get update && apt-get upgrade -y \
	&& apt-get install -y \
		ros-kinetic-joystick-drivers \
		ros-kinetic-moveit \
		ros-kinetic-control-msgs \
		ros-kinetic-gazebo-ros-control \
		python-wstool \
		&& rm -rf /var/lib/apt/lists/*


#**************************************************Kuka YouBot*************************************************************

RUN apt-get update && apt-get upgrade -y \
	&& apt-get install -y \
	qt4-dev-tools \
	libboost-dev \
	libboost-thread-dev \
	libboost-filesystem-dev \
	libboost-regex-dev libeigen3-dev \
	&& rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get upgrade -y \
	&& apt-get install -y \
	sudo

RUN echo "sudo ALL=(ALL:ALL) ALL" >> /etc/sudoers

USER user
COPY files/.bashrc /tmp/
COPY files/entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
