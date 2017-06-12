import sys
import time
from threading import Thread
import Movuino as mvn

#####################################################################
####################			 MAIN			#####################
#####################################################################
def main(args = None):
	movuino = mvn.Movuino("127.0.0.1", 3010, 3011)
	movuino.start()

	movuino.vibroNow(True)
	time.sleep(1)
	movuino.vibroNow(False)

	timer0 = time.time()
	while (time.time()-timer0 < 1):
		print movuino.ax, movuino.ay, movuino.az
		print movuino.gx, movuino.gy, movuino.gz
		print movuino.mx, movuino.my, movuino.mz
		print movuino.repAcc, movuino.repGyr, movuino.repMag
		print movuino.xmmId, movuino.xmmProg
		time.sleep(.05)
	
	movuino.vibroPulse(150,100,3)

	movuino.stop()

if __name__ == '__main__':
	sys.exit(main())