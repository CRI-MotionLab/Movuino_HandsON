/*
 * This example is based on the UsingGeomerative example of the Generative Typography example
 * Here is the link of the original source: https://github.com/AmnonOwed/CAN_GenerativeTypography
 */

import geomerative.*;           // library for text manipulation and point extraction

// Color swatch
color c0 = color(73, 81, 208,0);
color c1 = color(243, 240, 114, 200);
color c2 = color(125, 222, 227, 100);
color c3 = color(245, 91, 85, 200);

float nextPointSpeed = 0.65;    // speed at which the sketch cycles through the points
RShape shape;                   // holds the base shape created from the text
RPoint[][] allPaths;            // holds the extracted points

void setup() {
  size(1000, 500);

  // initialize the Geomerative library
  RG.init(this);
  // create font used by Geomerative
  RFont font = new RFont("FreeSans.ttf", 350);
  // create base shape from text using the loaded font
  shape = font.toShape("123");
  // center the shape in the middle of the screen
  shape.translate(width/2 - shape.getWidth()/2, height/2 + shape.getHeight()/2);
  // set Segmentator (read: point retrieval) settings
  RCommand.setSegmentator(RCommand.UNIFORMLENGTH); // use a uniform distance between points
  RCommand.setSegmentLength(10); // set segmentLength between points
  // extract paths and points from the base shape using the above Segmentator settings
  allPaths = shape.getPointsInPaths();
}

void draw() {
  // --------------------------------------------------------------------------
  // --------------------------------------------------------------------------
  float globalEnergy;   // affect color
  int curGlif = 0;      // select current caracter to draw
  float progGlif = 0;   // define progression of the  (float between 0.0 and 1.0)
  
  curGlif = int(3*mouseX/width);
  curGlif = constrain(curGlif,0,2);
  progGlif = mouseY/float(height);
  //globalEnergy = (pow(mouseX,2) + pow(mouseY,2)) / (pow(width,2) + pow(height,2));
  globalEnergy = cos(3*mouseY/float(height))/2.+0.5;
  println(globalEnergy);
  // --------------------------------------------------------------------------
  // --------------------------------------------------------------------------
  
  background(c0); // reset screen
  
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
  // LINES
  // draw thin transparant lines between two points within a path (a letter can have multiple paths)
  // dynamically set the 'opposite' point based on the current frameCount
  int fc = int(frameCount * nextPointSpeed);  
  stroke(c_);
  strokeWeight(0.75);
  RPoint[] singlePath = allPaths[curGlif];
  beginShape(LINES);
  progGlif = constrain(progGlif,0,1);
  for (int i=0; i < progGlif * singlePath.length; i++) {
    RPoint p = singlePath[i];
    vertex(p.x, p.y);
    RPoint n = singlePath[(fc+i)%singlePath.length];
    vertex(n.x, n.y);
  }
  endShape();
}