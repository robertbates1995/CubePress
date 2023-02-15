# CubePress


CubePress is a project designed to enhance the portability of the CUBOTino, a small robot that solves Rubik's cubes in under 90 seconds. This project features a Swift application that enables iPhone users to interface with their CUBOTino via remote network, as well as a modification to the CUBOTino's print files that allows users to mount their smartphones. CubePress is intended for use in conjunction with the [CUBOTino project](https://github.com/AndreaFavero71/CUBOTino_base_version), and enables users to create a portable version of the CUBOTino and take photos of their cubes using the camera on a Swift-compatible device of their choosing.

The CUBOTino base version is a small, simple, and inexpensive Rubik's cube-solving robot that can be built using the files available in [this repository](https://github.com/AndreaFavero71/CUBOTino_base_version). A PDF file and video tutorial are also provided to guide users through the building process and demonstrate how to present the cube to the camera. CubePress uses a Raspberry Pi Pico instead of an ESP32 board for its WiFi capabilities, allowing the majority of the project's processes to occur on the user's device rather than on the CUBOTino itself. This approach enables the use of a cheaper board for the CUBOTino.

## Features
- Wireless interaction between iphone and CUBOTino via local wifi connection
- New simplified settings menu for callibrating the CUBOTino directly from the phone
- real-time in-app 3D Cube visualizer
- Solution sequence creation
- Pictures interpreted via Machine Learning
- Updated model with phone holder
 
## Getting Started
1. Create a [CUBOTino](https://github.com/AndreaFavero71/CUBOTino_base_version)
2. Create a phone holder for the CUBOTino (TODO)
3. Install all server files to the CUBOTino
4. Install client app onto your iPhone

## Elements of the CUBOTino

## Goals
- Create a portable version of the CUBOTino
- allow users to use their smartphones to interface with CUBOTino
- uses RESTful api to link devices with CUBOTino via wifi

## Architecture

## Acknowledgements
