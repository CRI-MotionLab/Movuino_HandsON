import sys
import time
from threading import Thread
import Movuino as mvn

#####################################################################
####################			 MAIN			#####################
#####################################################################
def main(args = None):
	computerIP = "192.168.0.101" # set here your computer IP
	movuinoIP = "192.168.0.100" # set here your Movuino IP once its connected to the same wifi network as your computer
	movuino = mvn.Movuino(computerIP, movuinoIP, 7400, 7401)
	movuino.start()

	movuino.vibroNow(True)
	time.sleep(1)
	movuino.vibroNow(False)

	timer0 = time.time()
	while (time.time()-timer0 < 1):
		print "Accelerometer data:", movuino.ax, movuino.ay, movuino.az
		print "Gyroscope data:", movuino.gx, movuino.gy, movuino.gz
		print "Magnetometer data:", movuino.mx, movuino.my, movuino.mz
		print "---"
		time.sleep(.05)
	
	movuino.vibroPulse(150,100,3)

	movuino.stop()

if __name__ == '__main__':
	sys.exit(main())