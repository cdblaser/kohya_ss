# Kohya's GUI

This repository mostly provides a Gradio GUI for [Kohya's Stable Diffusion trainers](https://github.com/kohya-ss/sd-scripts)... but support for Linux OS is also provided through community contributions. Macos is not great at the moment... but might work if the wind blow in the right direction...

The GUI allows you to set the training parameters and generate and run the required CLI commands to train the model.

## Table of Contents

- [Kohya's GUI](#kohyas-gui)
  - [Table of Contents](#table-of-contents)
  - [🦒 Colab](#-colab)
  - [Installation](#installation)
    - [Windows](#windows)
      - [Windows Pre-requirements](#windows-pre-requirements)
      - [Setup Windows](#setup-windows)
      - [Optional: CUDNN 8.9.6.50](#optional-cudnn-89650)
    - [Linux and macOS](#linux-and-macos)
      - [Linux Pre-requirements](#linux-pre-requirements)
      - [Setup Linux](#setup-linux)
      - [Install Location](#install-location)
    - [Runpod](#runpod)
      - [Manual installation](#manual-installation)
      - [Pre-built Runpod template](#pre-built-runpod-template)
    - [Docker](#docker)
      - [Local docker build](#local-docker-build)
      - [ashleykleynhans runpod docker builds](#ashleykleynhans-runpod-docker-builds)
  - [Upgrading](#upgrading)
    - [Windows Upgrade](#windows-upgrade)
    - [Linux and macOS Upgrade](#linux-and-macos-upgrade)
  - [Starting GUI Service](#starting-gui-service)
    - [Launching the GUI on Windows](#launching-the-gui-on-windows)
    - [Launching the GUI on Linux and macOS](#launching-the-gui-on-linux-and-macos)
  - [LoRA](#lora)
  - [Sample image generation during training](#sample-image-generation-during-training)
  - [Troubleshooting](#troubleshooting)
    - [Page File Limit](#page-file-limit)
    - [No module called tkinter](#no-module-called-tkinter)
  - [SDXL training](#sdxl-training)
  - [Change History](#change-history)
    - [2024/03/10 (v23.0.1)](#20240310-v2301)
    - [2024/03/02 (v23.0.0)](#20240302-v2300)

## 🦒 Colab

This Colab notebook was not created or maintained by me; however, it appears to function effectively. The source can be found at: <https://github.com/camenduru/kohya_ss-colab>.

I would like to express my gratitude to camendutu for their valuable contribution. If you encounter any issues with the Colab notebook, please report them on their repository.

| Colab                                                                                                                                                                          | Info               |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------ |
| [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/camenduru/kohya_ss-colab/blob/main/kohya_ss_colab.ipynb) | kohya_ss_gui_colab |

## Installation

### Windows

#### Windows Pre-requirements

To install the necessary dependencies on a Windows system, follow these steps:

1. Install [Python 3.10](https://www.python.org/ftp/python/3.10.9/python-3.10.9-amd64.exe).
   - During the installation process, ensure that you select the option to add Python to the 'PATH' environment variable.

2. Install [Git](https://git-scm.com/download/win).

3. Install the [Visual Studio 2015, 2017, 2019, and 2022 redistributable](https://aka.ms/vs/17/release/vc_redist.x64.exe).

#### Setup Windows

To set up the project, follow these steps:

1. Open a terminal and navigate to the desired installation directory.

2. Clone the repository by running the following command:

   ```shell
   git clone https://github.com/bmaltais/kohya_ss.git
   ```

3. Change into the `kohya_ss` directory:

   ```shell
   cd kohya_ss
   ```

4. Run the setup script by executing the following command:

   ```shell
   .\setup.bat
   ```

   During the accelerate config step use the default values as proposed during the configuration unless you know your hardware demand otherwise. The amount of VRAM on your GPU does not have an impact on the values used.

#### Optional: CUDNN 8.9.6.50

The following steps are optional but will improve the learning speed for owners of NVIDIA 30X0/40X0 GPUs. These steps enable larger training batch sizes and faster training speeds.

1. Run .\setup.bat and select `2. (Optional) Install cudnn files (if you want to use latest supported cudnn version)`

### Linux and macOS

#### Linux Pre-requirements

To install the necessary dependencies on a Linux system, ensure that you fulfill the following requirements:

- Ensure that `venv` support is pre-installed. You can install it on Ubuntu 22.04 using the command:

  ```shell
  apt install python3.10-venv
  ```

- Install the cudNN drivers by following the instructions provided in [this link](https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64).

- Make sure you have Python version 3.10.6 or higher (but lower than 3.11.0) installed on your system.

- If you are using WSL2, set the `LD_LIBRARY_PATH` environment variable by executing the following command:

  ```shell
  export LD_LIBRARY_PATH=/usr/lib/wsl/lib/
  ```

#### Setup Linux

To set up the project on Linux or macOS, perform the following steps:

1. Open a terminal and navigate to the desired installation directory.

2. Clone the repository by running the following command:

   ```shell
   git clone https://github.com/bmaltais/kohya_ss.git
   ```

3. Change into the `kohya_ss` directory:

   ```shell
   cd kohya_ss
   ```

4. If you encounter permission issues, make the `setup.sh` script executable by running the following command:

   ```shell
   chmod +x ./setup.sh
   ```

5. Run the setup script by executing the following command:

   ```shell
   ./setup.sh
   ```

   Note: If you need additional options or information about the runpod environment, you can use `setup.sh -h` or `setup.sh --help` to display the help message.

#### Install Location

The default installation location on Linux is the directory where the script is located. If a previous installation is detected in that location, the setup will proceed there. Otherwise, the installation will fall back to `/opt/kohya_ss`. If `/opt` is not writable, the fallback location will be `$HOME/kohya_ss`. Finally, if none of the previous options are viable, the installation will be performed in the current directory.

For macOS and other non-Linux systems, the installation process will attempt to detect the previous installation directory based on where the script is run. If a previous installation is not found, the default location will be `$HOME/kohya_ss`. You can override this behavior by specifying a custom installation directory using the `-d` or `--dir` option when running the setup script.

If you choose to use the interactive mode, the default values for the accelerate configuration screen will be "This machine," "None," and "No" for the remaining questions. These default answers are the same as the Windows installation.

### Runpod

#### Manual installation

To install the necessary components for Runpod and run kohya_ss, follow these steps:

1. Select the Runpod pytorch 2.0.1 template. This is important. Other templates may not work.

2. SSH into the Runpod.

3. Clone the repository by running the following command:

   ```shell
   cd /workspace
   git clone https://github.com/bmaltais/kohya_ss.git
   ```

4. Run the setup script:

   ```shell
   cd kohya_ss
   ./setup-runpod.sh
   ```

5. Run the gui with:

   ```shell
   ./gui.sh --share --headless
   ```

   or with this if you expose 7860 directly via the runpod configuration

   ```shell
   ./gui.sh --listen=0.0.0.0 --headless
   ```

6. Connect to the public URL displayed after the installation process is completed.

#### Pre-built Runpod template

To run from a pre-built Runpod template you can:

1. Open the Runpod template by clicking on <https://runpod.io/gsc?template=ya6013lj5a&ref=w18gds2n>

2. Deploy the template on the desired host

3. Once deployed connect to the Runpod on HTTP 3010 to connect to kohya_ss GUI. You can also connect to auto1111 on HTTP 3000.

### Docker

#### Local docker build

If you prefer to use Docker, follow the instructions below:

1. Ensure that you have Git and Docker installed on your Windows or Linux system.

2. Open your OS shell (Command Prompt or Terminal) and run the following commands:

   ```bash
   git clone --recursive https://github.com/bmaltais/kohya_ss.git
   cd kohya_ss
   docker compose up -d --build
   ```

   Note: The initial run may take up to 20 minutes to complete.

   Please be aware of the following limitations when using Docker:

   - All training data must be placed in the `dataset` subdirectory, as the Docker container cannot access files from other directories.
   - The file picker feature is not functional. You need to manually set the folder path and config file path.
   - Dialogs may not work as expected, and it is recommended to use unique file names to avoid conflicts.
   - This dockerfile has been designed to be easily disposable. You can discard the container at any time and docker build it with a new version of the code. To update the system, run update scripts outside of Docker and rebuild using `docker compose down && docker compose up -d --build`.

   If you are running Linux, an alternative Docker container port with fewer limitations is available [here](https://github.com/P2Enjoy/kohya_ss-docker).

#### ashleykleynhans runpod docker builds

You may want to use the following Dockerfile repos to build the images:

- Standalone Kohya_ss template: <https://github.com/ashleykleynhans/kohya-docker>
- Auto1111 + Kohya_ss GUI template: <https://github.com/ashleykleynhans/stable-diffusion-docker>

## Upgrading

To upgrade your installation to a new version, follow the instructions below.

### Windows Upgrade

If a new release becomes available, you can upgrade your repository by running the following commands from the root directory of the project:

1. Pull the latest changes from the repository:

   ```powershell
   git pull
   ```

2. Run the setup script:

   ```powershell
   .\setup.bat
   ```

### Linux and macOS Upgrade

To upgrade your installation on Linux or macOS, follow these steps:

1. Open a terminal and navigate to the root

 directory of the project.

2. Pull the latest changes from the repository:

   ```bash
   git pull
   ```

3. Refresh and update everything:

   ```bash
   ./setup.sh
   ```

## Starting GUI Service

To launch the GUI service, you can use the provided scripts or run the `kohya_gui.py` script directly. Use the command line arguments listed below to configure the underlying service.

```text
--listen: Specify the IP address to listen on for connections to Gradio.
--username: Set a username for authentication.
--password: Set a password for authentication.
--server_port: Define the port to run the server listener on.
--inbrowser: Open the Gradio UI in a web browser.
--share: Share the Gradio UI.
--language: Set custom language
```

### Launching the GUI on Windows

On Windows, you can use either the `gui.ps1` or `gui.bat` script located in the root directory. Choose the script that suits your preference and run it in a terminal, providing the desired command line arguments. Here's an example:

```powershell
gui.ps1 --listen 127.0.0.1 --server_port 7860 --inbrowser --share
```

or

```powershell
gui.bat --listen 127.0.0.1 --server_port 7860 --inbrowser --share
```

### Launching the GUI on Linux and macOS

To launch the GUI on Linux or macOS, run the `gui.sh` script located in the root directory. Provide the desired command line arguments as follows:

```bash
gui.sh --listen 127.0.0.1 --server_port 7860 --inbrowser --share
```

## LoRA

To train a LoRA, you can currently use the `train_network.py` code. You can create a LoRA network by using the all-in-one GUI.

Once you have created the LoRA network, you can generate images using auto1111 by installing [this extension](https://github.com/kohya-ss/sd-webui-additional-networks).

## Sample image generation during training

A prompt file might look like this, for example:

```txt
# prompt 1
masterpiece, best quality, (1girl), in white shirts, upper body, looking at viewer, simple background --n low quality, worst quality, bad anatomy, bad composition, poor, low effort --w 768 --h 768 --d 1 --l 7.5 --s 28

# prompt 2
masterpiece, best quality, 1boy, in business suit, standing at street, looking back --n (low quality, worst quality), bad anatomy, bad composition, poor, low effort --w 576 --h 832 --d 2 --l 5.5 --s 40
```

Lines beginning with `#` are comments. You can specify options for the generated image with options like `--n` after the prompt. The following options can be used:

- `--n`: Negative prompt up to the next option.
- `--w`: Specifies the width of the generated image.
- `--h`: Specifies the height of the generated image.
- `--d`: Specifies the seed of the generated image.
- `--l`: Specifies the CFG scale of the generated image.
- `--s`: Specifies the number of steps in the generation.

The prompt weighting such as `( )` and `[ ]` are working.

## Troubleshooting

If you encounter any issues, refer to the troubleshooting steps below.

### Page File Limit

If you encounter an X error related to the page file, you may need to increase the page file size limit in Windows.

### No module called tkinter

If you encounter an error indicating that the module `tkinter` is not found, try reinstalling Python 3.10 on your system.

## SDXL training

The documentation in this section will be moved to a separate document later.

## Change History

### 2024/03/10 (v23.0.1)

- Update bitsandbytes module to 0.43.0 as it provide native windows support
- Minor fixes to code

### 2024/03/02 (v23.0.0)

- Use sd-scripts release [0.8.4](https://github.com/kohya-ss/sd-scripts/releases/tag/v0.8.4) post commit [fccbee27277d65a8dcbdeeb81787ed4116b92e0b](https://github.com/kohya-ss/sd-scripts/commit/fccbee27277d65a8dcbdeeb81787ed4116b92e0b)
- Major code refactoring thanks to @wkpark , This will make updating sd-script cleaner by keeping sd-scripts files separate from the GUI files. This will also make configuration more streamlined with fewer tabs and more accordion elements. Hope you like the new style.
- This new release is implementing a significant structure change, moving all of the sd-scripts written by kohya under a folder called sd-scripts in the root of this project. This folder is a submodule that will be populated during setup or gui execution.
