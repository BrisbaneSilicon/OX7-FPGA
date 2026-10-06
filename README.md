
# OX7-FPGA


Example project for the FPGA component of the [OX-Tile7](https://brisbanesilicon.com.au/ox-tile7) SiP-FPGA tile board by [BrisbaneSilicon](https://brisbanesilicon.com.au/).
<br><br>

## Table of Contents

*   [Overview](#overview)
*   [Getting Started](#getting-started)
*   [License Setup](#license-setup)
    *   [Public License Servers](#public-license-servers)
*   [Environment Variables](#environment-variables)
*   [Build](#build)
*   [Program](#program)
*   [Demonstration](#demonstration)
*   [Embedded Logic Analyzer](#embedded-logic-analyzer)
*   [Development](#development)
*   [Documentation](#documentation)
*   [Roadmap](#roadmap)
*   [HowTo](#howto)
    *   [WINUSB Setup](#winusb-setup)
    *   [FTDI Setup](#ftdi-setup)
    *   [OpenOCD Setup](#openocd-setup)
    *   [FcapZ Setup](#fcapz-setup)
<br>

## Overview

This project allows the user to build an FPGA bitstream and program it onto the [OX-Tile7](https://brisbanesilicon.com.au/ox-tile7) MCU-FPGA development board.

It can also be extended by the user to include their custom, application-specific, RTL modules.

The project workflow is fully scripted (fetch, build, program); it does not require the use of a GUI-based program at any point.

A core component of this project (together with its [OX7-Drivers](https://github.com/BrisbaneSilicon/OX7-Drivers) sister project) is a CPU-FPGA comms layer. This layer can be leveraged by the user for 'out of the box' CPU-FPGA communication, upon which their custom functionality can be developed.


![MCU FPGA Comms](img/mcu_fpga_comms.png)


After this project has been built and flashed to the FPGA, its [OX7-BSP](https://github.com/BrisbaneSilicon/OX7-BSP) flashed to the SiP and its [OX7-Drivers](https://github.com/BrisbaneSilicon/OX7-Drivers) sister project uploaded and running on the SiP, communication between the two IC's is as simple as:

#### SiP

On the RP2350 MCU, via a Python program or REPL:

```c
<TODO>
```

#### FPGA

The 'C' snippet above will produce a AXI-Lite (ish) write transaction, with wdata=0xFF and addr=0x4. This interface is plumbed to the user module '[user.sv](https://github.com/BrisbaneSilicon/OX7-FPGA/blob/master/proj/common/systemverilog/user.sv)':

```systemverilog
input       [31:0]  cpu_addr,
input       [31:0]  cpu_wdata,
input       [3:0]   cpu_wstrb,
output  reg [31:0]  cpu_rdata,
input               cpu_valid,
output  reg         cpu_ready,
```

<br>

## Getting Started

Fulfill the below prerequisites.

### Prerequisites

1. A PC running an x64 compatible, Debian-based flavour of Linux or Windows 11.
   - Other flavours of Linux may work but aren't officially supported.
   - We recommend [Ubuntu](https://ubuntu.com/).
2. An installation of [GIT](https://git-scm.com/).
3. An installation of Xilinx Vivado (2024 onward).
4. A copy of this repository.
   - Launch a terminal program.
   - Navigate to the directory in which you wish to host the OX7-Tile repository.
   - `git clone https://github.com/BrisbaneSilicon/OX7-FPGA.git`<br>


<br>

## License Setup

TODO

## Environment Variables

### Linux

TODO

## Build

After fulfilling all of the prerequisites, and initializing your build environment, you are ready to build the OX-Tile7 firmware! Simply perform the following:

### Linux

```bash
cd <this repository directory>/build
./build.sh
```

That's all there is to it!<br><br>

The build script supports various customizations via command line arguments. To view the full set of supported command line arguments, simply perform the following:
```bash
./build.sh -h
```
<br>

The most commonly used are listed below.
<br>

| Build Argument | Description |
| :----------: | :----------: |
| -p, --proj_only | Only generate the project file, then exit. Useful if the user wishes to utilize Vivado IDE.|
| -s, --synth_only | Only proceed with build until synthesis is complete, then exit. Useful to check FPGA utilization, timing etc. |
| -y, --list_supported_system_clock_frequencies | List the supported system clock frequencies and exit. |
| -k, --clock_frequency FREQUENCY_MHZ | Use a frequency of FREQUENCY_MHZ for the system clock (default 51 MHz). |
| -e, --embedded_logic_analyzer| Include an Embedded Logic Analyzer (fpgacapZero) in the bitstream. |
| -t, --cpu_bus_test | Include a readback register set for the CPU bus and ELA the bus signaling. Required for OX7-Drivers 'cpu_bus_test.c' test program. |
| -a, --clean_all_platforms | Perform cleanup of the entire build and exit. |

### Windows

Open PowerShell (Admin not required), `cd` into the repository root, then the 'build' directory, and then run:

```powershell
.\build.ps1
```
<br><br>

## Program

After building the OX7-Tile firmware you are ready to program it to the board! It is worth noting that this stage also programs the internal non-volatile bitstream flash, so your firmware will auto-load after board power on! <br><br>After plugging the board into your PC via the USB-C cable, simply perform the following:

### Linux

The '\<this repository directory>' is the directory in which you performed Step (4) of [prerequisites](#prerequisites) - i.e. the directory in which you cloned this repository.

```bash
cd <this repository directory>/prog
./program.sh
```
<br>

That's all there is to it!
<br>

> [!NOTE]
> The 'program' script will trigger a build the OX7-Tile firmware (with no command line customization arguments) if it detects it hasn't already been built.
<br>

Again, the program script supports various customizations via command line arguments. To view the full set of supported command line arguments, simply perform the following:

```bash
./program.sh -h
```
<br>
The most commonly used are listed below.
<br>

| Program Argument | Description |
| :----------: | :----------: |
| -f, --program_flash | Program the OX7-Tile embedded Flash, as opposed to the SRAM (default). |
| -d, --list_default_target | List the default build target. |
| -c, --clean_target_prior | Clean TARGET build prior to building and programming the OX7-Tile board. |
| -b, --check_if_target_built | Print firmware built status of provided target board and exit. |
| -o, --open_fpga_loader CUSTOM_TARGET | Program the OX7-Tile using 'openFPGALoader' instead of the Xilinx toolchain (Linux only). |
<br>

### Windows

#### Program Board

> [!WARNING]
> Make sure there are no conflicts between FTDI driver versions before running this script — see [Other](#ftdi-driver-setup).

The '\<this repository directory>' is the directory in which you performed Step (4) of [prerequisites](#prerequisites) - i.e. the directory in which you cloned this repository.

```powershell
cd '<this repository directory>\prog\'
.\program_board.ps1
```

## Demonstration

> [!NOTE]
> TODO - describe how to read FPGA version string via MCU

<br>

## Embedded Logic Analyzer

This project can be built to include an Embedded Logic Analyzer to showcase injecting and probing an fpgacapZero ELA core. Ensure you have completed [OpenOCD Setup](#openocd-setup) and [FcapZ Setup](#fcapz-setup) and pulled the 'fpgaCapZero' foreign git submodule (command below) prior to performing the steps below.
```bash
cd <this repository directory>
git submodule update --init
```

To inject an ELA core into the firmware, build the firmware with the '-e' command line argument (below) and then program the board as per [program](#program).<br>
```bash
./build.sh -e
```
Once the board has been programmed, run OpenOCD as per [OpenOCD Setup](#openocd-setup), and then probe the ELA core via fpgacapZ:<br>
```bash
TODO
```
This should produce the following:
```
{
  "version_major": 0,
  "version_minor": 4,
  "core_id": 19521,
  "sample_width": 8,
  "depth": 64,
  "num_channels": 6,
  "trig_stages": 1,
  "has_storage_qualification": false,
  "has_decimation": false,
  "has_ext_trigger": false,
  "has_timestamp": false,
  "timestamp_width": 0,
  "num_segments": 1,
  "probe_mux_w": 0,
  "compare_caps": 197059,
  "compare_modes": [
    0,
    1,
    6,
    7,
    8
  ],
  "has_dual_compare": true
}
```
Next, trigger on Channel 3 (index 2), which is an 8-bit counter (see the 'autogen_top_wrapper.sv' that was built).
```
TODO
```
Open the resulting capture (note the trigger location, and depth) in a waveform viewer, for example, [surfer](https://surfer-project.org/):
```
surfer capture.vcd
```
![Alt text](img/surfer.png)

See the table below for details on the captured channels. Note that you can manually trigger the ELA via:

1. Holding Pushbutton 2.
2. Running the 'fcapz' command, triggering on Channel 4 as '0'.
3. Releasing Pushbutton 2.

| Build Switches | fcapZ CH1 | fcapZ CH2 | fcapZ CH3 | fcapZ CH4 | fcapZ CH5 | fcapZ CH6|
| :------:|:------:|:------:|:------:|:------:|:------:|:------:|
| ./build.sh -e |FPGA Pin 1-8 State|FPGA Pin 9-16 State|8-bit Counter|Button 2 State|0|0|


<br>

## Development

Extending the project with your custom firmware is quite straightforward, simply modify the __user.sv__ file (located in \<this repository directory>/proj/common/systemverilog/). You can also instantiate your own Systemverilog or VHDL modules, but ensure you add them to the appropriate build script file __synth.tcl__ ('scripts' directories).

Further information related to user development with the OX7-Tile is detailed official documentation, see section [documentation](#documentation) below.

<br>

## Documentation

Official documentation for the OX-Tile7 is available [here](https://brisbanesilicon.com.au/docs/OX7_Datasheet.pdf).

<br>

### FTDI Setup
TODO


### OpenOCD Setup

OpenOCD, the Open On-Chip Debugger, is used to connect fpgacapZero to the ELA (Embedded Logic Analyzer). Note that on Windows you must perform [WINUSB Setup](#winusb-setup) prior to setting up OpenOCD.

To install OpenOCD, simply follow the OS-specific instructions [here](https://github.com/openocd-org/openocd/#installing-openocd). Alternatively, if you are on Windows you can download a binary from [here](https://openocd.org/pages/getting-openocd.html). 

To connect OpenOCD to the OX-Tile7, ensure it is plugged into the PC and then run the terminal command(s) below.

```
cd <this repository directory>
openocd -f foreign/openocd/ox7.cfg
```
If OpenOCD has connected successfully, the output will be similar to the following.

```
TODO
```

### FcapZ Setup

FpgacapZero is an open-source, vendor-agnostic FPGA debug core, an Embedded Logic Analyzer (ELA) for waveform capture, an Embedded I/O (EIO) for runtime read/write of fabric signals.

To install fpgacapZero, simply follow [OpenOCD Setup](#openocd-setup) and then the instructions available [here](https://github.com/lcapossio/fpgacapZero#quick-start). Once fpgacapZero is installed, follow [Embedded Logic Analyzer](#embedded-logic-analyzer) to inject and probe an ELA core.

<br>

## Roadmap


<br>

## Authors

- [@brisbanesilicon](https://github.com/BrisbaneSilicon)

<br>

## Appendix

For developing with the project, we recommend [Sublime Text](https://www.sublimetext.com/), with the VHDL and/or Systemverilog syntax highlighing enabled.<br><br>
If you like this project, follow us on X [here](https://x.com/brisbanesilicon)!
<br>

## Support

For support, email support@brisbanesilicon.com.au.
