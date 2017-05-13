void sendMovuinoAddr() {
  if (WiFi.status() == WL_CONNECTED) {
    delay(50);
    // store Movuino IP address
    sprintf(movuinoIP, "%d.%d.%d.%d", WiFi.localIP()[0], WiFi.localIP()[1], WiFi.localIP()[2], WiFi.localIP()[3]);
    Serial.println(movuinoIP);

    delay(100);
    // Send Movuino address (IP & local port) to the host computer
    OSCMessage msg("/movuinoAddr"); // create an OSC message on address "/movuinOSC"
    msg.add(movuinoIP);
    msg.add(portIn);
    Udp.beginPacket(hostIP, portOut); // send message to computer target with "hostIP" on "port"
    msg.send(Udp);
    Udp.endPacket();
    msg.empty();
  }
}
