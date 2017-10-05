// You need to install oscP5 librairie and use the Movuino Interface

void setup() {
  size(400, 400);
  callMovuino("127.0.0.1", 7400, 7401); // no need to change if using the Movuino interface on the same computer
  //movuino.smoothData(5); // smooth data (here on 5 data window, larger window implies smoother signal)
  movuino.noSmoothData(); // remove the data filter
}

void draw() {
  // RECEIVE DATA
  println("Movuino accelerometer data:", movuino.ax, movuino.ay, movuino.az);
  println("Movuino gyroscope data:", movuino.gx, movuino.gy, movuino.gz);
  println("Movuino magnetometer data:", movuino.mx, movuino.my, movuino.mz);
  println("-------------------------");
  
  //--------------------
  //--------------------
  //--------------------
  
  // MAKE MOVUINO VIBRATE
  //!!\\ BE SURE TO GET THE MOVUINO ADDRESS IN THE INTERFACE //!!\\
  //!!\\ BE SURE TO GET THE MOVUINO ADDRESS IN THE INTERFACE //!!\\
  //!!\\ BE SURE TO GET THE MOVUINO ADDRESS IN THE INTERFACE //!!\\
  // Plug the Movuino on the USB, refresh "Available serials" and select the one corresponding to Movuino
  
  // USE vibroNow function: see mouse pressed/released function
  
  // USE vubroPulse function
  float gyr_ = sqrt(pow(movuino.gx,2) + pow(movuino.gy, 2) + pow(movuino.gz, 2)); // just an example
  gyr_  /= sqrt(3);
  if(gyr_ > 0.9){
    movuino.vibroPulse(100,150,5); // send 5 pulsations of 100ms separate by 150ms
  }
}

void mousePressed(){
  movuino.vibroNow(true);  // activate continuous vibration
}

void mouseReleased(){
  movuino.vibroNow(false); // turn off vibrator
}