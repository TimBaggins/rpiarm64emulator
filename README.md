# RaspiOS QEMU Setup

This project provides a simple, automated script to set up and run a RaspiOS Lite (Buster) virtual machine using QEMU on a host system. The script handles the entire process, including downloading necessary files, compiling a Linux kernel for the ARM64 architecture, and configuring a user with SSH access. This is an excellent tool for creating a lightweight, headless Raspberry Pi environment for development or testing.

##  Environment

This script has been tested and confirmed to work on **WSL (Windows Subsystem for Linux) running Ubuntu 22.04**.

---

##  Getting Started

### Prerequisites

* **WSL (Windows Subsystem for Linux)** with **Ubuntu 22.04**.
* Basic command-line tools and permissions to install software.

### Step 1: Run the Initial Setup Script

This script performs all the one-time setup tasks.

1.  **Clone this repository** to your local machine and move the applicable scripts to the home directory of your WSL:

    ```bash
    git clone [https://github.com/](https://github.com/)TimBaggins/rpiarm64emulator.git
    cd rpiarm64emulator
    cp rpiemulator.sh run_raspios_qemu.sh ~/
    cd ~/
    ```

2.  **Make the script executable**:

    ```bash
    chmod +x rpiemulatorsetup.sh
    ```

3.  **Run the script**:

    ```bash
    ./rpiemulatorsetup.sh
    ```

4.  Follow the on-screen prompts to enter a username and password for the new user. The script will take some time to download and compile the necessary files.

---

### Step 2: Run the Emulator

Once the initial setup is complete, you can use a separate script to launch the emulator and continue working on your persistent image.

1.  **Make the launch script executable**:

    ```bash
    chmod +x run_raspios_qemu.sh
    ```

2.  **Launch the emulator**:

    ```bash
    ./run_raspios_qemu.sh
    ```

---

##  The Scripts

### `raspios-qemu-setup.sh`

This script automates the entire one-time setup process. Here is a breakdown of what it accomplishes:

1.  **Installs Dependencies**: It first uses `sudo apt-get` to install all necessary packages, including QEMU and the cross-compilation toolchain for ARM64.
2.  **Downloads and Extracts RaspiOS**: It downloads the RaspiOS Lite ARM64 disk image directly from the official Raspberry Pi website and extracts it.
3.  **Compiles the Kernel**: It fetches a stable Linux kernel tarball from `kernel.org` and compiles it for the `arm64` architecture, a crucial step for the QEMU emulation.
4.  **Configures the Image**: It mounts the downloaded disk image, adds a new user with the password you provide, and enables SSH access.
5.  **Starts QEMU**: Finally, it launches the virtual machine using QEMU, configured to use the newly compiled kernel. It also sets up network port forwarding, allowing you to connect via SSH.

### `run_raspios_qemu.sh`

This script is designed for recurring use. It bypasses all the setup steps and directly launches the QEMU emulator, loading the pre-configured disk image. This allows you to quickly continue your work where you left off.

---

##  Connecting to the VM

After the QEMU window appears and the virtual machine has booted, you can connect to it via SSH from a new terminal using the following command:

```bash
ssh -p 2222 <username>@localhost
```
