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
  float[] rawData; // array list to store each data sent from the Movuino. The size of the list correspond to the size of the moving mean
  int nDat = 9; // number of data receive from Movuino (example : N = 6 for Acc X, Y, Z and Gyr X, Y, Z)

  Thread thread;
  // OSC communication parameters
  OscP5 oscP5Movuino;
  NetAddress myMovuinoLocation;
  int portIn = 3010;
  int portOut = 3011;
  String ip;

  float ax=0.0f; // current acceleration X
  float ay=0.0f; // current acceleration Y
  float az=0.0f; // current acceleration Z
  float gx=0.0f; // current gyroscope X
  float gy=0.0f; // current gyroscope Y
  float gz=0.0f; // current gyroscope Z
  float mx=0.0f; // current magnetometer X
  float my=0.0f; // current magnetometer Y
  float mz=0.0f; // current magnetometer Z
  boolean repAcc=false;
  boolean repGyr=false;
  boolean repMag=false;
  int xmmGestId=0;
  float xmmGestProg=0.0f;

  public Movuino(String ip_, int portin_, int portout_) {
    this.ip = ip_;
    this.portIn = portin_;
    this.portOut = portout_;
    oscP5Movuino = new OscP5(this, this.portIn); // this port must be the same than the port on the Movuino
    myMovuinoLocation = new NetAddress(this.ip, this.portOut);
    NetInfo.print();
    this.rawData = new float[nDat];
  }

  public void start() {
    thread = new Thread(this);
    thread.start();
  }

  public void run() {
    while (true) {   
      // Update Movuino data at each frame
      this.ax = this.rawData[0];
      this.ay = this.rawData[1];
      this.az = this.rawData[2];
      this.gx = this.rawData[3];
      this.gy = this.rawData[4];
      this.gz = this.rawData[5];
      this.mx = this.rawData[6];
      this.my = this.rawData[7];
      this.mz = this.rawData[8];
      
      //this.repAcc = 
      delay(5); // regulation
    }
  }

  public void stop() {
    thread = null;
  }

  void printRawDataCollect() {
    // Print raw data store from the Movuino
    for (int j=0; j < this.nDat; j++) {
      if (this.rawData != null) {
        print(this.rawData[j] + " ");
      }
      if (j==this.nDat-1) {
        println();
      }
    }
  }

  void sendToMovuino(String addr_, String mess_) {
    // Send messages to Movuino through OSC protocol
    OscMessage myOscMessage = new OscMessage("/" + addr_); // create a new OscMessage with an address pattern
    myOscMessage.add(mess_); // add a value to the OscMessage
    oscP5Movuino.send(myOscMessage, myMovuinoLocation); // send the OscMessage to a remote location specified in myNetAddress
  }
  
  void vibroNow(boolean isVibro_) {
    OscMessage myOscMessage = new OscMessage("/vibroNow"); // create a new OscMessage with an address pattern
    myOscMessage.add(isVibro_); // add a value to the OscMessage
    oscP5Movuino.send(myOscMessage, myMovuinoLocation); // send the OscMessage to a remote location specified in myNetAddress
  }
  
  void vibroPulse(int on_, int off_, int n_) {
    OscMessage myOscMessage = new OscMessage("/vibroPulse"); // create a new OscMessage with an address pattern
    myOscMessage.add(on_);   // add active time to osc message
    myOscMessage.add(off_);  // add inactive time to osc message
    myOscMessage.add(n_);    // add number of repetitions to the osc message
    oscP5Movuino.send(myOscMessage, myMovuinoLocation); // send the OscMessage to a remote location specified in myNetAddress
  }

  void oscEvent(OscMessage theOscMessage) {
    // Receive data from Movuino on the channel /movuinOSC
    if (theOscMessage.checkAddrPattern("/sensorData")) {
      if (theOscMessage.checkTypetag("fffffffff")) {
        for(int i=0; i<nDat; i++){
          this.rawData[i] = theOscMessage.get(i).floatValue(); 
        }
        return;
      }
    }
    if (theOscMessage.checkAddrPattern("/sensorRep")) {
      if (theOscMessage.checkTypetag("iii")) {
        this.repAcc = boolean(theOscMessage.get(0).intValue());
        this.repGyr = boolean(theOscMessage.get(1).intValue());
        this.repMag = boolean(theOscMessage.get(2).intValue());
        return;
      }
    }
    if (theOscMessage.checkAddrPattern("/xmm")) {
      if (theOscMessage.checkTypetag("if")) {
        this.xmmGestId = theOscMessage.get(0).intValue();
        this.xmmGestProg = theOscMessage.get(1).floatValue();
        this.xmmGestProg = constrain(this.xmmGestProg,0,1);
        return;
      }
    }
    println("### received an osc message. with address pattern "+theOscMessage.addrPattern()+" and typetag "+theOscMessage.typetag());
  }
}