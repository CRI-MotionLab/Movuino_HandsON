# Movuino HandsON

## Presentation

Movuino is a wireless sensor board. It includes an accelerometer, a gyroscope and a magnetometer.  
Here is a code template to stream those data from the board to your computer using Wifi, and then to stream them to any application using Open Sound Control:
* Presentation:  http://opensoundcontrol.org/
* Reference: http://opensoundcontrol.org/spec-1_0

## Content
Here you will find:
* **01_Firmware** this folder contains the firmware for the Movuino. You can edit and use it with the Arduino software;
* **02_DesktopInterface** this one contains an interface developped to visualize and handle Movuino data. The interface re-stream all those data on your computer allowing you to use it directly with predifined templates.
* **03_Application_Templates** this one contains template to receive the data from the Movuino interface on various application:
 * Python27
 * Max/MSP
 * Processing
 * Unity
 * Pure Data Extended
 * other comming soon...

## Installation
  
### Movuino (01_Firmware/)
* Download and install the Arduino software: https://www.arduino.cc/en/Main/Software
* Download and install the CP2014 driver: http://www.silabs.com/products/mcu/Pages/USBtoUARTBridgeVCPDrivers.aspx
  * **NOTE**
    * On most of Windows computer, the driver is installed automatically by the system by pluging the Movuino on the USB port;
    * If your computer OS version is old (like Lion on Mac) you may need to install the older version of the driver: http://www.silabs.com/products/development-tools/software/usb-to-uart-bridge-vcp-drivers
* Inside Arduino
  * Install the card ESP8266 following those instructions: https://learn.sparkfun.com/tutorials/esp8266-thing-hookup-guide/installing-the-esp8266-arduino-addon
 * Go to Tools/Board, select "Adafruit HUZZAH ESP8266" with:
      * CPU Frequency: 80 MHz
      * Flash Size: 4M (3M SPIFFS)
      * Upload Speed: 115200
      * Port: the one corresponding to the Movuino
  * Copy the content of the Arduino folder into your own Arduino folder (Macintosh and Windows: Documents/Arduino). It includes the libraries you need.
  * Restart Arduino and follow instructions inside the code (ip, rooter, password, port...)
     * `const char * ssid = "my_box_name";` set the name of your wifi network
     * `const char * pass = "my_password";` type the password of the network
     * `const char * hostIP = "192.168.0.0";` set the ip address of **YOUR COMPUTER** which is also connected to the same Wifi network and on which you will receive Movuino data
  * Upload firmware and check on the Arduino monitor window if everything is good!
  
### Movuino desktop application (2_MovuinoDesktop_OSC/)
Check the README file into each folders.  
![](https://media.giphy.com/media/SDogLD4FOZMM8/giphy.gif)



Download link for Movuino desktop interface:
* WINDOWS: https://dl.dropboxusercontent.com/u/22837472/MOVUINO/MovuinoInterface_Windows.zip
* MAC OSX: https://dl.dropboxusercontent.com/u/22837472/MOVUINO/MovuinoInterface_MacOSX.zip
