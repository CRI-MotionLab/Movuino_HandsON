void dataGizmo(float x_, float y_, float z_, float cr_){
  // Display a gizmo reacting to incoming XYZ data
  //background(255);
  
  // Graphic option & parameters
  blendMode(MULTIPLY);
  float sWeight_ = 10;   // stroke weight reference
  float coefReg_ = cr_;  // values mapping coefficient
  
  // Change coordinate system
  pushMatrix();  
  translate(width/2, height/2,0);        // middle screen (XY reference)
  
  // Compute coordinate values  
  float cx_ = coefReg_* width* x_;       // abscissa for the X-line value
  float cy_ = -coefReg_* width* y_;      // ordinate for the Y-line value
  float a0_ = -HALF_PI/2;                // reference angle of the Z-arc axis
  float a1_ = coefReg_*PI*z_ + a0_;      // angle of the Z-arc axis
  int r_ = width/2;                      // radius of the Z-arc axis
  float czx_ = r_/2*cos(a1_);            // abscissa of the Z value 
  float czy_ = r_/2*sin(a1_);            // ordinate of the Z value
  float czx0_ = r_/2*cos(QUARTER_PI);    // abscissa of the Z reference
  float czy0_ = -r_/2*sin(QUARTER_PI);   // ordinate of the Z reference
  
  //--------------------------------------------------------------
  //---------------------  DIPLAY VALUES  ------------------------
  //--------------------------------------------------------------
  
  noFill();
  strokeWeight(sWeight_);
  
  // Display X and Y values
  stroke(c1);
  line(0, 0, cx_, 0);                    // X-line values
  stroke(c2);
  line(0, 0, 0, cy_);                    // Y-line values
  
  // Display Z values on arc axis 
  if(a0_>a1_){
    // Reverse angle to draw arc in both senses (if Z<0)
    float a_ = a0_;
    a0_ = a1_;
    a1_ = a_;
  }  
  stroke(c3);
  arc(0, 0, r_, r_, a0_ , a1_);          // Z-arc axis
  arc(0, 0, r_, r_, a0_ + PI, a1_+PI);   // Z-arc axis reverse (style purpose)
  
  //--------------------------------------------------------------
  //--------------------  STYLE POLISH  --------------------------
  //--------------------------------------------------------------
  
  noStroke();
  
  // Line ending (circle)
  fill(c1);
  ellipse(cx_ ,0, 2*sWeight_, 2*sWeight_);         // X
  fill(c2);
  ellipse(0 , cy_, 2*sWeight_, 2*sWeight_);        // Y
  fill(c3);
  ellipse(czx_ , czy_, 2*sWeight_, 2*sWeight_);    // Z
  ellipse(-czx_ ,-czy_, 2*sWeight_, 2*sWeight_);   // Z reverse
  
  // Round cap for P3D mode
  translate(0,0,-1);
  fill(c1);
  ellipse(0,0, sWeight_, sWeight_);                // round cap X
  fill(c2);
  ellipse(0,0, sWeight_, sWeight_);                // round cap Y
  fill(c3);
  ellipse(czx0_, czy0_, sWeight_, sWeight_);       // round cap Z
  ellipse(-czx0_, -czy0_, sWeight_, sWeight_);     // round cap Z reverse
  
  // Visual landmarks
  translate(0,0,1);
  fill(c0);
  ellipse(0,0, sWeight_, sWeight_);                // origin XY
  ellipse(cx_,0, sWeight_, sWeight_);              // X
  ellipse(0,cy_, sWeight_, sWeight_);              // Y
  ellipse(czx0_ , czy0_, sWeight_, sWeight_);      // Origin Z
  ellipse(-czx0_ , -czy0_, sWeight_, sWeight_);    // Origin Z
  ellipse(czx_ , czy_, sWeight_, sWeight_);        // Z
  ellipse(-czx_ , -czy_, sWeight_, sWeight_);      // Z
  
  // Extra style
  fill(c1);
  ellipse(0,0, 4*sWeight_, 4*sWeight_);
  
  // Reference Z-axis
  noFill();
  stroke(c0);
  strokeWeight(sWeight_/4);
  line(-czx0_, -czy0_, czx0_, czy0_);  
  
  popMatrix();  // back to original coordinate system
}