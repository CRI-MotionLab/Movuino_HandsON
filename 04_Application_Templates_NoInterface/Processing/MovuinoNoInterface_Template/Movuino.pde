import processing.serial.*;
import oscP5.*;
import netP5.*;
//Thread
Movuino movuino;
Thread movuinoThread;

void callMovuino(String ip_, int portin_, int portout_) {
  movuino = new Movuino(ip_, portin_, portout_);
  movuinoThread = new Thread(movuino);
  movuinoThread.start();
  movuino.printRawDataCollect();
}

public class Movuino implements Runnable {
  ArrayList<float[]> rawData; // array list to store each data sent from the Movuino. The size of the list correspond to the size of the moving mean
  int N = 3; // Default size of moving mean
  int nDat = 9; // number of data receive from Movuino (example : N = 6 for Acc X, Y, Z and Gyr X, Y, Z)

  Thread thread;
  // OSC communication parameters
  OscP5 oscP5Movuino;
  NetAddress myMovuinoLocation;
  int portIn = 3010;
  int portOut = 3011;
  String ip;

  float ax; // current acceleration X
  float ay; // current acceleration Y
  float az; // current acceleration Z
  float gx; // current gyroscope X
  float gy; // current gyroscope Y
  float gz; // current gyroscope Z
  float mx; // current magnetometer X
  float my; // current magnetometer Y
  float mz; // current magnetometer Z

  public Movuino(String ip_, int portin_, int portout_) {
    this.ip = ip_;
    this.portIn = portin_;
    this.portOut = portout_;
    oscP5Movuino = new OscP5(this, this.portIn); // this port must be the same than the port on the Movuino
    NetInfo.print();
    this.rawData = new ArrayList<float[]>();
  }

  public void start() {
    thread = new Thread(this);
    thread.start();
  }

  public void run() {
    while (true) {   
      // Update Movuino data at each frame
      float[] mdat_ = getSmoothData();
      this.ax = mdat_[0];
      this.ay = mdat_[1];
      this.az = mdat_[2];
      this.gx = mdat_[3];
      this.gy = mdat_[4];
      this.gz = mdat_[5];
      this.mx = mdat_[6];
      this.my = mdat_[7];
      this.mz = mdat_[8];
      delay(5); // regulation
    }
  }

  public void stop() {
    thread = null;
  }

  void sendToMovuino(String addr_, String mess_) {
    // Send messages to Movuino through OSC protocol
    OscMessage myOscMessage = new OscMessage("/" + addr_); // create a new OscMessage with an address pattern
    myOscMessage.add(mess_); // add a value to the OscMessage
    
    if(myMovuinoLocation != null){
      oscP5Movuino.send(myOscMessage, myMovuinoLocation); // send the OscMessage to a remote location specified in myNetAddress
    }
    else{
      println("No Movuino address! Press Movuino button to send its location");
      delay(100);
    }
  }
  
  void vibroNow(boolean isVibro_) {
    OscMessage myOscMessage = new OscMessage("/vibroNow"); // create a new OscMessage with an address pattern
    if(isVibro_){
      myOscMessage.add(1); // add a value to the OscMessage
    }
    else{
      myOscMessage.add(0); // add a value to the OscMessage
    }
    
    if(myMovuinoLocation != null){
      oscP5Movuino.send(myOscMessage, myMovuinoLocation); // send the OscMessage to a remote location specified in myNetAddress
    }
    else{
      println("No Movuino address! Press Movuino button to send its location");
      delay(100);
    }
  }
  
  void vibroPulse(int on_, int off_, int n_) {
    OscMessage myOscMessage = new OscMessage("/vibroPulse"); // create a new OscMessage with an address pattern
    myOscMessage.add(on_);   // add active time to osc message
    myOscMessage.add(off_);  // add inactive time to osc message
    myOscMessage.add(n_);    // add number of repetitions to the osc message
    
    if(myMovuinoLocation != null){
      oscP5Movuino.send(myOscMessage, myMovuinoLocation); // send the OscMessage to a remote location specified in myNetAddress
    }
    else{
      println("No Movuino address! Press Movuino button to send its location");
      delay(100);
    }
  }

  void oscEvent(OscMessage theOscMessage) {
    // Receive data from Movuino on the channel /movuinOSC
    if (theOscMessage.checkAddrPattern("/movuinOSC")) {
      if (theOscMessage.checkTypetag("fffffffff")) {
        float[] rawdat_ = {theOscMessage.get(0).floatValue(), theOscMessage.get(1).floatValue(), theOscMessage.get(2).floatValue(), theOscMessage.get(3).floatValue(), theOscMessage.get(4).floatValue(), theOscMessage.get(5).floatValue(),theOscMessage.get(6).floatValue(), theOscMessage.get(7).floatValue(), theOscMessage.get(8).floatValue()};
        movuino.addRawData(rawdat_);
        return;
      }
    }
    
    if (theOscMessage.checkAddrPattern("/movuinoAddr")) {
      if (theOscMessage.checkTypetag("si")) {
        this.ip = theOscMessage.get(0).stringValue();
        this.portOut = theOscMessage.get(1).intValue();
        myMovuinoLocation = new NetAddress(this.ip, this.portOut);
        return;
      }
    }
    println("### received an osc message. with address pattern "+theOscMessage.addrPattern()+" and typetag "+theOscMessage.typetag());
  }
  
  //------------------------------------------------------------------
  // Moving mean filter functions
  
  void noSmoothData(){
    // Remove moving mean filter
    this.smoothData(1);
  }
  
  void smoothData(int n_){
    // Add a moving mean filter of size N
    this.N = n_;
  }
  
  float[] getSmoothData() {
    //Compute mean on raw data to smooth the signal
    float[] meanData = new float[nDat];
    for(int i=0; i<nDat; i++){
        meanData[i] = 0; // intialize mean at 0 
     }
      
    if(this.rawData.size() > 0){
      for (int i=0; i < this.rawData.size(); i++) {
          for (int j=0; j < this.nDat; j++) {
            if(this.rawData.get(i) != null){
              if(this.rawData.get(i).length == nDat){  
                meanData[j] += this.rawData.get(i)[j] / float(rawData.size()); // compute mean on each colums
            }
          }
        }
      }
    }
    return meanData;
  }
  
  void addRawData(float[] newDat_) {
    // Store new data into the raw data array
    // add new data
    this.rawData.add(newDat_);
    
    // Remove oldest values from the raw data array
    if(this.rawData.size() - N > 0){
      // remove oldest data if N unchanged (i=0 removed)
      // remove from 0 to rawdat.length - N + 1 if new N < old N
      for(int i=0 ; i < this.rawData.size() - N + 1 ; i++){
        this.rawData.remove(i);
      }
    }
  }
  
  void printRawDataCollect() {
    // Print raw data stored from the Movuino
    for (int i=0; i < this.rawData.size(); i++) {
      for (int j=0; j < this.rawData.get(i).length; j++) {
        if(this.rawData != null){
          print(this.rawData.get(i)[j] + " ");
        }
        if (j==this.nDat-1) {
          println();
        }
      }
    }
  }
}