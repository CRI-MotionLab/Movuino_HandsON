// Movuino data
float ax=0;
float ay=0;
float az=0;
float gx=0;
float gy=0;
float gz=0;
float mx=0;
float my=0;
float mz=0;

// Color swatch
color c0 = color(73, 81, 208);
color c1 = color(243, 240, 114);
color c2 = color(125, 222, 227);
color c3 = color(245, 91, 85);

int drawMode = 0;
PFont font;
String curMode = "";

void setup () {
  // set the window size:
  size(500,800,P3D);
  background(255);
  
  font = loadFont("MuseoSansRounded-300-48.vlw");
  textAlign(CENTER, CENTER);
  textFont(font, 30);
  
  callMovuino("127.0.0.1", 7400, 7401);
  movuino.smoothData(5);
  //movuino.noSmoothData();
}

void draw() {
  // Update data at each frame
  ax = movuino.ax;
  ay = movuino.ay;
  az = movuino.az;
  gx = movuino.gx;
  gy = movuino.gy;
  gz = movuino.gz;
  mx = movuino.mx;
  my = movuino.my;
  mz = movuino.mz;
  
  // Refresh screen
  background(255);
  
  //-------------------
  // Display modes: click with the mouse to switch mode
  //-------------------
  switch(drawMode){
    case 0:
      dataPlayground(ax,ay,az,gx,gy,gz,mx,my,mz);
      curMode = "PLAYGROUND";
      break;
    case 1:
      dataGizmo(ax,ay,az,0.6);
      curMode = "ACCELEROMETER";
      break;
   case 2:
      dataGizmo(gx,gy,gz,0.4);
      curMode = "GYROSCOPE";
      break;
   case 3:
      dataGizmo(mx,my,mz,0.5);
      curMode = "MAGNETOMETER";
      break; 
  }
  
  fill(c0);
  text(curMode + "\nclick to switch", width/2, height*6/7);  // draw score
}
void mousePressed() {
  drawMode = ++drawMode%4;
}