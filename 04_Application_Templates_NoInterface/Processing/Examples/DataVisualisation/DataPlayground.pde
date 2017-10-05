void dataPlayground(float ax_, float ay_, float az_, float gx_, float gy_, float gz_, float mx_, float my_, float mz_){
  // Display a scene reacting simultaneously to each raw data : accelerometer, gyroscope and magnetometer
  //background(255);
  
  // Graphic option & parameters
  blendMode(NORMAL);
  int rmax_ = width/2;    // scale coefficient on accelerometer
  float cgyr = 4.0;       // scale coefficient on gyroscope 
  int lCube = width/10;   // size of the cube to display 
  
  //--------------------------------------------------------------
  //---------------  CUBE along ACC and gy_R  ---------------------
  //--------------------------------------------------------------
  
  // change coordinate system
  pushMatrix();
  
  // translate the cube according to acceleration data along each ax_is
  translate(width/2 + ax_*rmax_, height/2 - ay_*rmax_, az_*rmax_*0.75);
  
  // rotate the cube according to gy_roscope data along each ax_is
  rotateX(-cgyr*gx_);
  rotateY(-cgyr*gy_);
  rotateZ(cgyr*gz_);
  
  // display_ settings
  blendMode(NORMAL);
  noStroke();
  
  // display_ the cube drawing each faces 2 per 2
  fill(c2);             // c2 faces (normal to Y axis)
  beginShape();  
  vertex(-lCube/2, -lCube/2, lCube/2);
  vertex(lCube/2, -lCube/2, lCube/2);
  vertex(lCube/2, -lCube/2, -lCube/2);
  vertex(-lCube/2, -lCube/2, -lCube/2);
  vertex(-lCube/2, -lCube/2, lCube/2);
  endShape(CLOSE);
  beginShape();
  vertex(-lCube/2, lCube/2, lCube/2);
  vertex(lCube/2, lCube/2, lCube/2);
  vertex(lCube/2, lCube/2, -lCube/2);
  vertex(-lCube/2, lCube/2, -lCube/2);
  vertex(-lCube/2, lCube/2, lCube/2);
  endShape(CLOSE);
  
  rotateZ(HALF_PI);
  fill(c1);             // c1 faces (normal to X axis)
  noStroke();
  beginShape();  
  vertex(-lCube/2, -lCube/2, lCube/2);
  vertex(lCube/2, -lCube/2, lCube/2);
  vertex(lCube/2, -lCube/2, -lCube/2);
  vertex(-lCube/2, -lCube/2, -lCube/2);
  vertex(-lCube/2, -lCube/2, lCube/2);
  endShape(CLOSE);
  beginShape();
  vertex(-lCube/2, lCube/2, lCube/2);
  vertex(lCube/2, lCube/2, lCube/2);
  vertex(lCube/2, lCube/2, -lCube/2);
  vertex(-lCube/2, lCube/2, -lCube/2);
  vertex(-lCube/2, lCube/2, lCube/2);
  endShape(CLOSE);
  
  rotateX(HALF_PI);
  fill(c3);             // c3 faces (normal to Z axis)
  noStroke();
  beginShape();  
  vertex(-lCube/2, -lCube/2, lCube/2);
  vertex(lCube/2, -lCube/2, lCube/2);
  vertex(lCube/2, -lCube/2, -lCube/2);
  vertex(-lCube/2, -lCube/2, -lCube/2);
  vertex(-lCube/2, -lCube/2, lCube/2);
  endShape(CLOSE);
  //--
  beginShape();
  vertex(-lCube/2, lCube/2, lCube/2);
  vertex(lCube/2, lCube/2, lCube/2);
  vertex(lCube/2, lCube/2, -lCube/2);
  vertex(-lCube/2, lCube/2, -lCube/2);
  vertex(-lCube/2, lCube/2, lCube/2);
  endShape(CLOSE);
  
  popMatrix(); // back to original coordinate system
  
  //--------------------------------------------------------------
  //----------------  GIZMO following MAG  -----------------------
  //--------------------------------------------------------------
  
  int rsphere = width/35; // sphere radius
  
  // Normalize magnetometers data
  float M_ = sqrt(pow(mx_,2) + pow(my_,2) + pow(mz_,2)); // compute Euclidian norm
  mx_ /= M_; // normalize magnetometer data, X...
  my_ /= M_; // Y...
  mz_ /= M_; // and Z
  
  // Compute polar angle according to magnetometer data
  float theta = 0.0; // rotation angle around Z axis
  if(mx_ != 0 && my_ != 0){
    if(my_ >= 0){
      theta = acos(mx_/sqrt(pow(mx_,2)+pow(my_,2)));
    }
    if(my_ < 0){
      theta = 2*PI - acos(mx_/sqrt(pow(mx_,2)+pow(my_,2)));
    }
  }
  float phi = acos(mz_) ; // rotation angle around Y axis in new coordinate system (after theta rotation around Z ax_is)
  
  // Change coordinate system
  pushMatrix();
  translate(width/2, height/2,0);
  rotateZ(-theta);
  rotateY(phi);
  
  // Display the sphere following 3D magnetic North
  noStroke();
  fill(c3);
  translate(0,0,rmax_);
  sphere(rsphere);
  translate(0,0,-rmax_);
  
  // Display the sphere following 3D magnetic South
  fill(c3);
  translate(0,0,-rmax_);
  sphere(rsphere);
  translate(0,0,rmax_);
  
  // Display circle normal to magnetic axis
  noFill();
  strokeWeight(rsphere/2.5);
  stroke(c0);
  ellipse(0,0,1.5*rmax_,1.5*rmax_);
  noStroke();
  fill(c0);
  translate(0,0,0);
  sphere(rsphere/2.5); // center of the ellipse
  
  // Display landmarks on the circle to get orientation
  noStroke();
  fill(c2);
  translate(0,1.5*rmax_/2, 0);
  sphere(rsphere);
  translate(0,-2*1.5*rmax_/2, 0);
  sphere(rsphere);
  fill(c1);
  translate(1.5*rmax_/2, 1.5*rmax_/2,0);
  sphere(rsphere);
  translate(-2*1.5*rmax_/2, 0,0);
  sphere(rsphere);
  
  popMatrix(); // back to original coordinate system
}