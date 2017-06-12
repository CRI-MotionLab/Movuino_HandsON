// Simple graphic script dealing with Movuino raw data
// >>> Try to reach the target moving Movuino
// this script compute your behavior and send the data to PureData in order to generate dynamic sounds
// the screen is just for debug, you have to reach the target just focusing on the sound

import processing.serial.*;
import oscP5.*;
import netP5.*;

// Color swatch
color c0 = color(73, 81, 208);
color c1 = color(243, 240, 114);
color c2 = color(125, 222, 227);
color c3 = color(245, 91, 85);

// OSC
OscP5 oscP5;
NetAddress myBroadcastLocation;
boolean isOSC = false; // check if new data came from OSC

// GAME DATA
PFont font;
int screenSize = 600;
int count = 0; // score
long timer0 = 0; // timer to manage taunt sounds
float waitTime = 0;

// TARGET DATA
int dc = 50; // target diameter
int xc = int(random(200, 600)); // target pos X
int yc = int(random(200, 400)); // target pos Y
int oldXc = 0; // store pos X val
int oldYc = 0; // store pos Y val

void setup () {
  // set the window size:
  size(600, 600);
  background(c0);
  
  // OSC client to Pure Data
  myBroadcastLocation = new NetAddress("127.0.0.1", 7000);
  oscP5 = new OscP5(this, 5000);

  // Initialize first target
  newTarget(); // update xc and yc

  // Initalization timer
  timer0 = millis();
  waitTime = random(7000, 25000);
  
  font = loadFont("MuseoSansRounded-300-48.vlw");
  textFont(font, 30);
  
  callMovuino("127.0.0.1",3010,3011);
}


void draw() {
  float ax = mapToDraw(movuino.ax, screenSize);
  float ay = mapToDraw(-movuino.ay, screenSize);
  
  // UPDATE SCORE
  if (dist(ax, ay, xc, yc) < dc*0.5) {
    if (count < 5) {
      count++;
    } else {
      count = 0; 
    }
    
    newOSCMessage("osc/score", count); // send score to pure data to generate sounds
    movuino.vibroPulse(100,60,2);
    
    oldXc = xc;
    oldYc = yc;
    newTarget(); // update xc and yc

    timer0 = millis();
    waitTime = random(7000, 25000);
  } else {
    // check taunt timer
    if (millis() - timer0 > waitTime) {
      //newOSCMessage("osc/score", -1); // taunt message if player takes too much time
      timer0 = millis();
      waitTime = random(7000, 25000);
    }
  }

  // Clear screen
  background(c0);

  fill(c1);
  text("SCORE/ " + count, 10, 30);  // draw score

  noStroke();
  ellipse(xc, yc, dc/4, dc/4); // draw target
  strokeWeight(2);
  stroke(c1);
  noFill();
  ellipse(xc, yc, dc, dc); // draw target

  strokeWeight(6);
  line(screenSize/2, screenSize/2, ax, ay); // draw player line

  float d = dist(ax, ay, xc, yc) / sqrt(pow(screenSize, 2) + pow(screenSize, 2));
  float dx = abs(ax-xc + dc/2) / float(screenSize);
  float dy = abs(ay-yc + dc/2) / float(screenSize);

  newOSCMessage("osc/s1", pow(1-d, 6));
  newOSCMessage("osc/s2", dx/1.4);
  newOSCMessage("osc/s3", dy/1.4);
}

float mapToDraw(float f_, float r_) {
  f_ *= r_/0.3;
  f_ += r_/2;
  f_ = constrain(f_, 0, r_);
  return f_;
}

void newTarget() {
  // Quick and extremely dirty method, please do not copy this shit
  do {
    xc = int(random(screenSize/4, screenSize));
    yc = int(random(screenSize/4, screenSize));
  } while (dist(screenSize/2, screenSize/2, xc, yc) < screenSize/4 || (dist(oldXc, oldYc, xc, yc) < screenSize/4)); // check if target is not too close from the center and from previous target position
}

// SEND OSC MESSAGES
void newOSCMessage(String canal, float message) {
  /* create a new OscMessage with an address pattern, in this case /test. */
  OscMessage myOscMessage = new OscMessage("/" + canal);
  /* add a value (an integer) to the OscMessage */
  myOscMessage.add(message);
  /* send the OscMessage to a remote location specified in myNetAddress */
  oscP5.send(myOscMessage, myBroadcastLocation);
}