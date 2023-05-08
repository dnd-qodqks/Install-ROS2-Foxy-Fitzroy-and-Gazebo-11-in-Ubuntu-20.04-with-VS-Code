#! /bin/bash
# : Install ROS2 Foxy Fitzroy and Gazebo 11 in Ubuntu 20.04 with VS Code

set -x

echo "[Install VS Code]"
sudo apt update && sudo apt install -y locales
sudo apt install -y software-properties-common apt-transport-https wget
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update
sudo apt install code

# Delete Cache
sudo rm /var/lib/apt/lists/lock
sudo rm /var/cache/apt/archives/lock
sudo rm /var/lib/dpkg/lcok*
sudo dpkg --configure -a
sudo apt update

name_ws="ros2_ws"
name_ros2_distro="foxy"

echo "[Setup Locales(UTF-8)]"
sudo apt update
sudo apt install locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

echo "[Setup Sources]"
sudo apt install -y software-properties-common
sudo add-apt-repository universe

sudo apt update && sudo apt install curl
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

echo "[Installing ROS2 Foxy]"
sudo apt update
sudo apt install -y ros-${name_ros2_distro}-desktop python3-argcomplete

# Delete Cache
sudo rm /var/lib/apt/lists/lock
sudo rm /var/cache/apt/archives/lock
sudo rm /var/lib/dpkg/lcok*
sudo dpkg --configure -a
sudo apt update

echo "[Installing ROS2 Tools]"
sudo apt update && sudo apt install -y \
build-essential \
cmake \
git \
libbullet-dev \
python3-colcon-common-extensions \
python3-flake8 \
python3-pip \
python3-pytest-cov \
python3-rosdep \
python3-setuptools \
python3-vcstool \
wget

python3 -m pip install -U \
argcomplete \
flake8-blind-except \
flake8-builtins \
flake8-class-newline \
flake8-comprehensions \
flake8-deprecated \
flake8-docstrings \
flake8-import-order \
flake8-quotes \
pytest-repeat \
pytest-rerunfailures \
pytest

sudo apt install --no-install-recommends -y \
libasio-dev \
libtinyxml2-dev \
libcunit1-dev

echo "[Making the catkin workspace and testing the catkin_make]"
source /opt/ros/$name_ros2_distro/setup.bash
mkdir -p ~/$name_ws/src
cd ~/$name_ws/
colcon build --symlink-install

echo "[Setting the ROS evironment]"
sh -c "echo \"alias rf='source /opt/ros/${name_ros2_distro}/setup.bash; source ~/${name_ws}/install/local_setup.bash; echo Activate foxy!'\" >> ~/.bashrc"

# sh -c "echo \"source /opt/ros/${name_ros2_distro}/setup.bash\" >> ~/.bashrc"
# sh -c "echo \"source ~/${name_ws}/install/local_setup.bash\" >> ~/.bashrc"
sh -c "echo \"source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash\" >> ~/.bashrc"
sh -c "echo \"source /usr/share/vcstool-completion/vcs.bash\" >> ~/.bashrc"
sh -c "echo \"source /usr/share/colcon_cd/function/colcon_cd.sh\" >> ~/.bashrc"

sh -c "echo \"export _colcon_cd_root=~/${name_ws}\" >> ~/.bashrc"

sh -c "echo \"export ROS_DOMAIN_ID=7\" >> ~/.bashrc"
sh -c "echo \"export ROS_NAMESPACE=robot1\" >> ~/.bashrc"

sh -c "echo \"export RMW_IMPLEMENTATION=rmw_fastrtps_cpp\" >> ~/.bashrc"
# export RMW_IMPLEMENTATION=rmw_fastrtps_cpp
# export RMW_IMPLEMENTATION=rmw_connext_cpp
# export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
# export RMW_IMPLEMENTATION=rmw_gurumdds_cpp

# export RCUTILS_CONSOLE_OUTPUT_FORMAT='[{severity} {time}] [{name}]: {message} ({function_name}() at {file_name}:{line_number})'
sh -c "echo \"export RCUTILS_CONSOLE_OUTPUT_FORMAT='[{severity}]: {message}'\" >> ~/.bashrc"
sh -c "echo \"export RCUTILS_COLORIZED_OUTPUT=1\" >> ~/.bashrc"
sh -c "echo \"export RCUTILS_LOGGING_USE_STDOUT=0\" >> ~/.bashrc"
sh -c "echo \"export RCUTILS_LOGGING_BUFFERED_STREAM=1\" >> ~/.bashrc"

echo "[Set ROS2 alias]"
sh -c "echo \"alias sb='source ~/.bashrc'\" >> ~/.bashrc"
sh -c "echo \"alias gb='gedit ~/.bashrc'\" >> ~/.bashrc"

sh -c "echo \"alias cw='cd ~/${name_ws}'\" >> ~/.bashrc"
sh -c "echo \"alias cs='cd ~/${name_ws}/src'\" >> ~/.bashrc"

sh -c "echo \"alias cb='cd ~/${name_ws} && colcon build --symlink-install'\" >> ~/.bashrc"
sh -c "echo \"alias cba='colcon build --symlink-install'\" >> ~/.bashrc"
sh -c "echo \"alias cbp='colcon build --symlink-install --packages-select'\" >> ~/.bashrc"

sh -c "echo \"alias rt='ros2 topic list'\" >> ~/.bashrc"
sh -c "echo \"alias re='ros2 topic echo'\" >> ~/.bashrc"
sh -c "echo \"alias rn='ros2 node list'\" >> ~/.bashrc"

sh -c "echo \"alias killg='killall -9 gazebo & killall -9 gzserver  & killall -9 gzclient'\" >> ~/.bashrc"

sh -c "echo \"alias testpub='ros2 run demo_nodes_cpp talker'\" >> ~/.bashrc"
sh -c "echo \"alias testsub='ros2 run demo_nodes_cpp listener'\" >> ~/.bashrc"

# Delete Cache
sudo rm /var/lib/apt/lists/lock
sudo rm /var/cache/apt/archives/lock
sudo rm /var/lib/dpkg/lcok*
sudo dpkg --configure -a
sudo apt update

echo "[Install Gazebo 11]"
sudo sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
wget https://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
sudo apt update

sudo apt install gazebo11 libgazebo11-dev -y
sudo apt install ros-foxy-gazebo-ros-pkgs -y

echo "[Complete!!!]"
exec bash
exit 0
