import OSC
import sys
import threading
from threading import Thread
import time
import socket, traceback

#####################################################################
######################       OSC CLIENT       #######################
#####################################################################
class OSCclient():
	def __init__(self, ip, port):
		#Initialize OSC communication (to send message)
		self.isSendingOSC = False
		self.c = OSC.OSCClient()
		self.c.connect((ip, port))
		print "OSC Client defined on ip", ip, "through port", port

	def sendOSCMessage(self, address, *message):
		try:
			# Send message to client through OSC
			oscmsg = OSC.OSCMessage()
			oscmsg.setAddress("/" + address)
			for m_ in message:
				oscmsg.append(message)
			self.c.send(oscmsg)
			# print "Sent message : ", message, " at ", address
		except:
			print "No receiver"

	def closeClient(self):
		self.c.close()

#####################################################################
######################       OSC SERVER       #######################
#####################################################################
class OSCserver():
	def __init__(self, ip, port):
		self.receive_address = ip, port
		self.s = OSC.ThreadingOSCServer(self.receive_address)
		self.s.addDefaultHandlers() # this registers a 'default' handler (for unmatched messages)
		self.st = threading.Thread(target=self.s.serve_forever)
		self.st.start()

		#Initialize variables
		self.curAddr = "No OSC address"
		self.curMess = "No OSC message"

		print "Starting OSCServer"

	# define a message-handler function for the server to call.
	def printing_handler(self, addr, tags, stuff, source):
		# Store address and message
		self.curAddr = addr.split("/")[1] # remove part we don't care
		self.curMess = stuff

	# define address to listen via OSC
	def addListener(self, addr):
		self.s.addMsgHandler("/" + addr, self.printing_handler)
		print "Start listening address:", addr, self.receive_address

	# Return receive values
	def get_CurrentMessage(self):
		return self.curAddr, self.curMess

	def closeServer(self):
		self.s.close()
		self.st.join()
		print "OSC server close"


#####################################################################
#######################       MOVUINO       #########################
#####################################################################
class Movuino(Thread):
	def __init__(self, ip_, portIn_, portOut_):
		self.ax = 0.0
		self.ay = 0.0
		self.az = 0.0
		self.gx = 0.0
		self.gy = 0.0
		self.gz = 0.0
		self.mx = 0.0
		self.my = 0.0
		self.mz = 0.0
		self.repAcc = False
		self.repGyr = False
		self.repMag = False
		self.xmmId = -1
		self.xmmProg = 0.0

		#############   SERVER   #############
		# Start OSCServer
		self.osc_server = OSCserver(ip_, portIn_) # Init server communication on specific Ip and port
		self.osc_server.addListener('sensorData') # add listener on address "sensorData"
		self.osc_server.addListener('sensorRep') # add listener on address "sensorRep"
		self.osc_server.addListener('xmm') # add listener on address "xmm"

		#############   CLIENT   #############
		self.osc_client = OSCclient(ip_, portOut_) # Init client communication on specific Ip and port
		######################################

		self.isMovuinoRunning = True
		self.thrd = Thread.__init__(self)

	def run(self):
		while self.isMovuinoRunning:
			curAddr, curVal = self.osc_server.get_CurrentMessage() # extract address and values of current message
			if curAddr == 'sensorData' :
				self.ax = curVal[0]
				self.ay = curVal[1]
				self.az = curVal[2]
				self.gx = curVal[3]
				self.gy = curVal[4]
				self.gz = curVal[5]
				self.mx = curVal[6]
				self.my = curVal[7]
				self.mz = curVal[8]
			if curAddr == 'sensorRep' :
				self.repAcc = curVal[0]
				self.repGyr = curVal[1]
				self.repMag = curVal[2]
			if curAddr == 'xmm' :
				self.xmmId = curVal[0]
				self.xmmProg = curVal[1]

			time.sleep(0.05)

	def stop(self):
		self.isMovuinoRunning = False
		time.sleep(.5)
		self.osc_server.closeServer() # ERROR MESSAGE but close the OSC server without killing the app
		self.osc_client.closeClient()
		self.thrd.join()

	def vibroNow(self,isVib):
		if isVib:
			self.osc_client.sendOSCMessage('vibroNow',1) # send value True to address "/vibroNow" on IP 127.0.0.1 port 3011
		else:
			self.osc_client.sendOSCMessage('vibroNow',0) # send value False to address "/vibroNow" on IP 127.0.0.1 port 3011

	def vibroPulse(self,on_,off_,rep_):
		self.osc_client.sendOSCMessage('vibroPulse',on_,off_,rep_)

#####################################################################
######################          MAIN          #######################
#####################################################################
def main(args = None):
	movuino = Movuino("127.0.0.1", 3010, 3011)
	movuino.start()

	movuino.vibroNow(True)
	time.sleep(1)
	movuino.vibroNow(False)

	timer0 = time.time()
	while (time.time()-timer0 < 4):
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