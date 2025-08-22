# rpiarm64emulator

#RaspiOS QEMU Setup

#This project provides a simple, automated script to set up and run a RaspiOS Lite (Buster) virtual machine using QEMU on a host system. The script handles the entire process, including downloading necessary files, compiling a Linux kernel for the ARM64 architecture, and configuring a user with SSH access. This is an excellent tool for creating a lightweight, headless Raspberry Pi environment for development or testing.

#Environment

#This script has been tested and confirmed to work on WSL (Windows Subsystem for Linux) running Ubuntu 22.04.

#Getting Started

#Prerequisites

#WSL (Windows Subsystem for Linux) with Ubuntu 22.04.

#Basic command-line tools and permissions to install software.

#How to Run the Script

#Clone this repository to your local machine:

#Bash

#git clone https://github.com/TimBaggins/rpiarm64emulator.git

#cd rpiarm64emulator

#cp rpiemulatorsetup.sh ~/

#Change back to your home directory as the script calls for the file to execute from there.

#cd ~

#Make the script executable:

#Bash

#chmod +x raspios-qemu-setup.sh

#Run the script:

#Bash

#./raspios-qemu-setup.sh

#Follow the on-screen prompts to enter a username and password for the new user.

#The Script (raspios-qemu-setup.sh)

#The script automates the entire setup process. Here is a breakdown of what it accomplishes:

#Installs Dependencies: It first uses sudo apt-get to install all necessary packages, including QEMU and the cross-compilation toolchain for ARM64.

#Downloads and Extracts RaspiOS: It downloads the RaspiOS Lite ARM64 disk image directly from the official Raspberry Pi website and extracts it.

#Compiles the Kernel: It fetches a stable Linux kernel tarball from kernel.org and compiles it for the arm64 architecture, a crucial step for the QEMU emulation.

#Configures the Image: It mounts the downloaded disk image, adds a new user with the password you provide, and enables SSH access.

#Starts QEMU: Finally, it launches the virtual machine using QEMU, configured to use the newly compiled kernel. It also sets up network port forwarding, allowing you to connect via SSH.

#Connecting to the VM

#After the QEMU window appears and the virtual machine has booted, you can connect to it via SSH from a new terminal using the following command:

#Bash

#ssh -p 2222 <username>@localhost

#Replace <username> with the username you provided when running the script.

#Resources and References

#The process of building and running a RaspiOS VM in QEMU requires several specific steps and file configurations. Much of the methodology for this automated script was inspired by and adapted from the following GitHub Gist, which served as an invaluable resource:

#Raspbian Buster on QEMU ARM64: https://gist.github.com/cGandom/23764ad5517c8ec1d7cd904b923ad863

#The script also relies on these external resources for the necessary files:

#RaspiOS Lite ARM64 Image: https://downloads.raspberrypi.com/raspios_lite_arm64/images/raspios_lite_arm64-2020-08-24/2020-08-20-raspios-buster-arm64-lite.zip

#Linux Kernel Tarball: https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.1.34.tar.xz
