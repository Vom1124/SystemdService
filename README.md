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

The ExecStart command in the example (II) requires "/bin/bash -lc" to ensure a self-contained login shell is used such that all other install modules and packages are available to the shell. 


Once the Systemd service is created, following steps are then used to start at boot up.

    systemctl --user daemon-reload
    systemctl --user enable <filename>.service

To start/stop the service, the following commands are used

    systemctl --user start <filename>.service
    systemctl --user stop <filename>.service

If at all the service file is edited, make sure to disable the service first before enabling again. The order is critical.

    systemctl --user disable <filename>.service
    systemctl --user daemon-reload
    systemctl --user enable <filename>.service

Caveat:
Example (II) is preferred over Example(I) for old systems (including but not limited to ROS2 OS), especially where the service needs to start after the GUI and user login is loaded. A best case scenario for this to occur is when OpenCv package is used to stream the camera within a node. This means that is the node starts before the GUI, then the stream won't display and save the stream exiting the service with partial error.

