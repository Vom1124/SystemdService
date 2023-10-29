# SystemdService
Starting a Systemd Service at Boot Up to Launch a ROS2 node

There are two modes to start a Systemd service: System mode and User mode.

This example exploits the User mode to benefit from Display startup and what not, as System mode starts before even graphical interface starts up, many services will not take effect using this mode.

A service file is created under /etc/systemd/user/ as "<filename>.service", where "<filename>" can be replaced with any desired name.

This file is then edited as follows:


