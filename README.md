# SystemdService
Starting a Systemd Service at Boot Up to Launch a ROS2 node

There are two modes to start a Systemd service: System mode and User mode.

This example exploits the User mode to benefit from Display startup and what not, as System mode starts before even graphical interface starts up, many services will not take effect using this mode.

A service file is created under /etc/systemd/user/ as "<filename>.service", where "<filename>" can be replaced with any desired name.

This file is then edited as follows:

  (I)
      
    [Unit]
    Description=Yansa Vision Startup Script
    #After=graphical.target
    
    [Service]
    WorkingDirectory=/home/vom
    #Environment="Home=root"
    #User=root
    ExecStart=<FileDirectory>/<startup.sh>
    Restart=always
    
    [Install]
    WantedBy=default.target
-------------------------------------- OR -------------------------------------

  (II)
  
    [Unit]
    Description=Yansa Vision Startup Script
    #After=graphical.target
    
    [Service]
    WorkingDirectory=/home/vom
    #Environment="Home=root"
    #User=root
    ExecStart=/bin/bash -lc 'source /opt/ros/humble/setup.bash;\
    source /home/vom/ros2_ws/install/setup.bash;\
    ros2 launch yansa_vision_bringup vision.launch.py'
    Restart=always
    
    [Install]
    WantedBy=default.target

If a custom startup.sh file is used, then implement (I), and if the executable(s) are directly launched, then use the (II). 

Replace the "<startup.sh>" in example (I) with desired name and "<FileDirectory>" is the directory to which the custom startup.sh is saved. A custom startup.sh can be something like shown below, where the source and launch codes are edited according to the system and file requriements. 

    #!/bin/bash

    source /opt/ros/humble/setup.bash
    source /home/vom/ros2_ws/install/setup.bash

    ros2 launch yansa_vision_bringup vision.launch.py
    #ros2 run rgb_camera rgb_grab
