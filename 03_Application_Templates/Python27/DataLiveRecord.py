import sys
import time
from threading import Thread
import OSC_communication as osc

#####################################################################
####################			 MAIN			#####################
#####################################################################
def main(args = None):
	#############  EXAMPLES  #############
	#############   CLIENT   #############
	osc_client = osc.OSCclient('127.0.0.1', 3011) # Init client communication on specific Ip and port
	osc_client.sendOSCMessage('vibroNow',1) # send value True to address "/vibroNow" on IP 127.0.0.1 port 3011
	print 'Movuino vibrator is ON'
	time.sleep(1)
	osc_client.sendOSCMessage('vibroNow',0) # send value False to address "/vibroNow" on IP 127.0.0.1 port 3011
	print 'Movuino vibrator is OFF'
	######################################


	#############  EXAMPLES  #############
	#############   SERVER   #############
	# Start OSCServer
	osc_server = osc.OSCserver('127.0.0.1', 3010) # Init server communication on specific Ip and port
	osc_server.addListener('sensorData') # add listener on address "sensorData"
	osc_server.addListener('sensorRep') # add listener on address "sensorRep"
	osc_server.addListener('xmm') # add listener on address "xmm"

	timer0 = time.time()
	timer1 = timer0
	while (timer1-timer0 < 1):
		timer1 = time.time()
		time.sleep(0.05)

		print osc_server.get_CurrentMessage()

	time.sleep(.1)
	osc_client.sendOSCMessage('vibroPulse',100,150,3)

	osc_server.closeServer() # ERROR MESSAGE but close the OSC server without killing the app
	osc_client.closeClient()
	######################################

if __name__ == '__main__':
	sys.exit(main())