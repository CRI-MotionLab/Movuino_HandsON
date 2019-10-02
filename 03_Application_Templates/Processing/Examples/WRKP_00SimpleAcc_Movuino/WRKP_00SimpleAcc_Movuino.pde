// Color swatch
color c0 = color(73, 81, 208,255);
color c1 = color(243, 240, 114, 255);
color c2 = color(125, 222, 227, 255);
color c3 = color(245, 91, 85, 255);

void setup() {
  size(500, 500);
  callMovuino("127.0.0.1", 3000, 3001); // do not change values if using the Movuino interface
}

void draw(){
  //movuino.printInfo(); // uncomment to print sensor information in the console
  
  background(255);
  int r = 15;
  float X = width/2 * (1 + movuino.ax);
  float Y = height/2 * (1 - movuino.ay);
  
  //-------------------------------
  // Axis
  strokeWeight(4);
  stroke(c1);
  line(width/2, height/2, X, height/2);
  stroke(c2);
  line(width/2, height/2, width/2, Y);
  
  // Origin
  noStroke();
  fill(c0);
  ellipse(width/2, height/2,r,r);
  
  // Point
  fill(c3);
  ellipse(X, Y,2*r,2*r);
}
