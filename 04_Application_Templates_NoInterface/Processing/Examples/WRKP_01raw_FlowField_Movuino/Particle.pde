class Particle {
  PVector loc;
  float life0, life, lifeRate;
  float angle;
  float r0;        // initial radius
  float r;         // current radius
  float dcolor0; // color gradient
  color col;     // current particle color
  
  Particle(float e_, float a_) {
    float energy0 = e_;                 // initial energy of the particle
    this.angle = a_;                    // initial angle direction of the particle
    this.dcolor0 = random(0.2) + e_;    // initial color variation (see display() function)
    this.col = getColor(this.dcolor0);  // initial color
    getPosition();                      // initialize particle's position randomly inside the text
    
    // randomly set a life and lifeRate for each Particle
    this.life0 = random(5) + round(15 * (1. - energy0));       // particle life time 
    this.r0 = random(80) + 400 * pow(1. - energy0,2);          // particle initial radius
    this.life = this.life0;                                    // initialize life progression
    this.lifeRate = random(0.05, 0.1);                         // decrease rate of the particle's life
  }

  void update() {
    // Update Position
    PVector vel = PVector.fromAngle(this.angle);
    loc.add(vel);
    
    // Update life time
    this.life -= this.lifeRate; // decrease life by the lifeRate (the particle is removed by the addRemoveParticles() method when no life is left)
    
    // Update color
    this.col = this.getColor(this.dcolor0 * this.life/this.life0); // color variation coefficient following particle life
    
    // Update radius
    this.r = this.r0 * this.life/this.life0; // new radius of the particle decreasing with particle life
  }

  void display() {
    // Display particle
    fill(this.col); // new particle color
    noStroke();
    ellipse(this.loc.x, this.loc.y, this.r, this.r); // draw particle
  }

  // get a random position inside the text
  void getPosition() {
    while (loc == null || !isInText (loc)) loc = new PVector(random(width), random(height));
  }

  // return if point is inside the text
  boolean isInText(PVector v) {
    return pg.get(int(v.x), int(v.y)) == PGRAPHICS_COLOR;
  }
  
  color getColor(float dc_){
    color c_;
    
    // Compute new color gradient of the particle
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
    
    return c_;
  }
}