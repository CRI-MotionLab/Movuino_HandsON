/*
 * This example is based on the UsingGeomerative example of the Generative Typography example
 * Here is the link of the original source: https://github.com/AmnonOwed/CAN_GenerativeTypography
 */

import geomerative.*;           // library for text manipulation and point extraction

// Color swatch
color c0 = color(73, 81, 208);
color c1 = color(243, 240, 114);
color c2 = color(125, 222, 227);
color c3 = color(245, 91, 85);
int backMode = 0;
color cbackground = c0;

RShape shape;                   // holds the base shape created from the text
RPoint[][] allPaths;            // holds the extracted points
float timer0 = 0.0;

void setup() {
  size(1000, 500);
  background(c0);

  // initialize the Geomerative library
  RG.init(this);
  // create font used by Geomerative
  RFont font = new RFont("FreeSans.ttf", 350);
  // create base shape from text using the loaded font
  shape = font.toShape("TYPE");
  // center the shape in the middle of the screen
  shape.translate(width/2 - shape.getWidth()/2, height/2 + shape.getHeight()/2);
  // set Segmentator (read: point retrieval) settings
  RCommand.setSegmentator(RCommand.UNIFORMLENGTH); // use a uniform distance between points
  RCommand.setSegmentLength(17); // set segmentLength between points
  // extract paths and points from the base shape using the above Segmentator settings
  allPaths = shape.getPointsInPaths();
  
  //callMovuino("127.0.0.1", 3010, 3011);
}

void draw() {
  // --------------------------------------------------------------------------
  // --------------------------------------------------------------------------
  float globalEnergy;  // affect color
  float angle;         // affect lines orientation
  float shiftX;        // shift animation along X axis
  float shiftY;        // shift animation along Y axis
  
  float x_ = (mouseX - width/2) / float(width/2);
  float y_ = -(mouseY - height/2) / float(height/2);
  globalEnergy = (pow(x_,2) + pow(y_,2)) / 2;
  angle = getOrientationAngle(x_, y_);
  shiftX =  - 250*cos(angle);
  shiftY = 250*sin(angle);
  timer0 = timer0/1; // ---> SEE MOUSEPRESSED() FUNCTION
  // points appear and background color change when you reset timer0 at current millis() value
  
  // --------------------------------------------------------------------------
  // --------------------------------------------------------------------------
  
  background(cbackground); // reset screen
  
  // COLOR
  // Compute color based on globalEnergy
  float dc_ = 1.2*globalEnergy; // color variation
  dc_ = constrain(dc_, 0, 1);
  color c_;
  if(dc_ > 0.66){
    c_ = lerpColor(c1, c3, 3*(dc_-0.66)); // from c3 to c1
  }
  else{
    if(dc_ > 0.33){
      c_ = lerpColor(c2, c1, 3*(dc_-0.33)); // from c1 to c2
    }
    else{
      c_ = lerpColor(c0, c2, 3*dc_); // from c2 to c0
    }
  }
  
  //----------------------------------
  //----------------------------------
  // POINTS
  // Compute radius
  float r = PI * (millis()-timer0)/500.; 
  r = constrain(r,0,PI);
  r = 10*sin(r);
  r = constrain(r,0,10);
  
  // Switch background color
  if(millis()-timer0 < 20){
    backMode++;
  }
  switch(backMode%4){
    case 0 :
      cbackground = c0;
      break;
    case 1 :
      cbackground = c1;
      break;
   case 2 :
      cbackground = c2;
      break;
   case 3 :
      cbackground = c3;
      break;
   default :
     cbackground = c0;
     break;
  }
  
  // draw points
  stroke(c_);
  strokeWeight(r);
  beginShape(POINTS);
  for (RPoint[] singlePath : allPaths) {
    for (RPoint p : singlePath) {
      vertex(p.x, p.y);
    }
  }
  endShape();
  
  //----------------------------------
  //----------------------------------
  // LINES
  // draw thin transparant lines between two points within a path (a letter can have multiple paths)
  // dynamically set the 'opposite' point based on the current frameCount
  stroke(c_);
  strokeWeight(0.75);
  for (RPoint[] singlePath : allPaths) {
    beginShape(LINES);
    for (int i=0; i<singlePath.length; i++) {
      RPoint p = singlePath[i];
      vertex(p.x + shiftX, p.y + shiftY);
      RPoint n = singlePath[int(i +(cos(angle)+1)*singlePath.length/4)%singlePath.length];
      vertex(n.x, n.y);
    }
    endShape();
  }
}

void mousePressed(){
  timer0 = millis(); // reset timer to draw points and switch background color
}

float getOrientationAngle(float x_, float y_) {
  float angle_ = 0.0f;
  if (x_ != 0) {
    if (x_>0) {
      angle_ = atan(y_/x_);
    } else {
      angle_ = atan(y_/x_) + PI;
    }
  } else {
    angle_ = 0.0f;
    if (y_ > 0) {
      angle_ = PI;
    } else {
      angle_ = 3*PI/4.0f;
    }
  }
  return angle_;
}