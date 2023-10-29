#!/bin/bash

source /opt/ros/humble/setup.bash
source /home/vom/ros2_ws/install/setup.bash

ros2 launch yansa_vision_bringup vision.launch.py
#ros2 run rgb_camera rgb_grab
