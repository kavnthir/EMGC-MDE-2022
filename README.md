# NASA(LaRC)/SSAI Extendable Mast Gimbal PI Controller 

[![VHDL version](https://img.shields.io/badge/VHDL-IEEE%201076--2019-blue)](https://en.wikipedia.org/wiki/VHDL)
[![Vivado version](https://img.shields.io/badge/Vivado-v2022.2%20(64--bit)-yellow)](https://www.xilinx.com/support/download.html)

This repository stores a Xilinx Vivado Project file which describes the hardware model of a PI controller meant to control the leveling and deployment of a VSAT (Vertical Solar Array Technology) remote power collecter.

## Synthesis Hardware

<img src="./images/arty-a7.png" width="40%" height="40%">

The FPGA being used to host the hardware model of the PI controller is the Arty A7: Artix-7 development board, should this design need to be deployed elsewhere, an FPGA which is space graded should be used.

## High Level Hardware Design

<img src="./images/high-level.png" width="40%" height="40%">

