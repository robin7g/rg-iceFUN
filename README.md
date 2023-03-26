# rg-iceFUN

The repository contains FPGA code examples for the iceFUN board. I created these as I was learning how to code Verilog. 

More details about the board can be found here 

[www.robot-electronics.co.uk](https://www.robot-electronics.co.uk/products/fpga/icefun.html)


The example below is a scrolling 'HELLO WORLD!' display.  

![iceFUN-E](https://github.com/robin7g/rg-iceFUN/blob/main/images/iceFUN-Animated.gif)

## Prerequisites

You need open source FPGA development tools for the ice40 FPGA like **yosys**, **nextpnr-ice40**, **icepack** and **iceFUNprog**. I pretty much work on MacOS and these tools work great there but will also install on a Windows or Linux machine. Here is a link to an up to date tool chain.

https://github.com/YosysHQ/oss-cad-suite-build

I started working on ice40 FPGAs using the FOMU workshop which has some goo instructions on ice40 toolchains and how to get setup. I will leave a link here 

https://workshop.fomu.im/en/latest/requirements/software.html

For **iceFUNprog** if you are on MacOS you can download and build my version here which fixes a segmentation fault in the original Linux version. 

https://github.com/robin7g/iceFUNprog

## Install & Build

Install Code
```
git clone git@github.com:robin7g/rg-iceFUN.git
cd rg-iceFUN
```
Change into chosen project directory
```
cd scrolltext
```
Make and then install on your iceFUN
```
make
make burn
```

## The VGA projects 

All the project which have VGA in thier title require a small circuit to be built using just resisters and a VGA connector. The schematic for this is shown below. 

![iceFUNVGASchematic](https://github.com/robin7g/rg-iceFUN/blob/main/images/IceFUNVGASchematic.jpg)


### VGA Rainbow
![vgarainbow](https://github.com/robin7g/rg-iceFUN/blob/main/images/vgarainbow.gif)

### VGA Circles
![vgacircles](https://github.com/robin7g/rg-iceFUN/blob/main/images/vgacircles.gif)

### VGA Bitmap
![vgabitmap](https://github.com/robin7g/rg-iceFUN/blob/main/images/vgabitmap.png)
