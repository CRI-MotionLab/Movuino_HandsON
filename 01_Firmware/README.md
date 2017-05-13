# Movuino Wifi with OSC

## Presentation

Movuino is a wireless sensor board. It includes an accelerometer, a gyroscope and a magnetometer.  
Here is a code template to stream those data from the board to your computer using Wifi, and then to stream them to any application using Open Sound Control:
* Presentation:  http://opensoundcontrol.org/
* Reference: http://opensoundcontrol.org/spec-1_0

## Content
Here you will find:
* **1_Movuino_FirmwareOSC/Arduino** this folder contains the firmware for the Movuino. You can edit and use it with the Arduino software;
* **2_MovuinoDesktop_OSC** this one contains template to receive the data from Movuino on various application:
 * Python
 * Max/MSP
 * Processing
 * Unity
 * Pure Data Extended
 * to be continued... (sounds so intense)

## Installation
  
### Movuino (1_Movuino_FirmwareOSC/)
* Download and install the Arduino software: https://www.arduino.cc/en/Main/Software
* Download and install the CP2014 driver: http://www.silabs.com/products/mcu/Pages/USBtoUARTBridgeVCPDrivers.aspx
* Inside Arduino
  * Install the card ESP8266 following those instructions: https://learn.sparkfun.com/tutorials/esp8266-thing-hookup-guide/installing-the-esp8266-arduino-addon
 * Go to Tools/Board, select "Adafruit HUZZAH ESP8266" with:
      * CPU Frequency: 80 MHz
      * Flash Size: 4M (3M SPIFFS)
      * Upload Speed: 115200
      * Port: the one corresponding to the Movuino
  * Copy the content of the Arduino folder into your own Arduino folder (Macintosh and Windows: Documents/Arduino). It includes the libraries you need, but you can also install them by yourself. In the Arduino software go to "Sketch/Include Library/Manage Libraries...", here seek and install:  
    * I2Cdev
    * OSC
    * MPU6050
      * for this one you need to make a correction in the library file. Go to Arduino/libraries/MPU6050/ and edit the file "MPU6050.h" (open it in NotePad, SublimeText, NotePad++ or anykind of text editor).
        * line 58, replace the line: `#define MPU6050_DEFAULT_ADDRESS MPU6050_ADDRESS_AD0_LOW`
        * **by:** `#define MPU6050_DEFAULT_ADDRESS MPU6050_ADDRESS_AD0_HIGH`
  * Restart Arduino and follow instructions inside the code (ip, rooter, password, port...)
     * `const char * ssid = "my_box_name";` set the name of your wifi network
     * `const char * pass = "my_password";` type the password of the network
     * `const char * hostIP = "192.168.1.35";` set the ip address of **YOUR COMPUTER** which is also connected to the same Wifi network and on which you will receive Movuino data
     * `const unsigned int port = 7400;` (optional) here you can set the port on which the data are sent. If you don't use other ports or if you have no idea of what I'm talking about you can let 7400.
     * `const unsigned int localPort = 3011;` (optional) here you can set the port on which Movuino can receive OSC message. Idem, better to let it at 3011.
  * Upload firmware and check on the Arduino monitor window if everything is good!
  * You can shut down (partially) and turn on the Movuino by pressing the button during 1 second.
  * **You can also send message to the Movuino, also using OSC.**
  
### Movuino desktop application (2_MovuinoDesktop_OSC/)
Check the README file into each folders.  
![](https://media.giphy.com/media/SDogLD4FOZMM8/giphy.gif)

