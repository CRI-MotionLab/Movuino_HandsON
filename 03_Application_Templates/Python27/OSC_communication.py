import OSC
import sys
import threading
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
		#Initialize OSC communication (to receive message)
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
######################          MAIN          #######################
#####################################################################
def main(args = None):
	
	#############  EXAMPLES  #############
	#############   CLIENT   #############
	osc_client = OSCclient('127.0.0.1', 3011) # Init client communication on specific Ip and port
	osc_client.sendOSCMessage('vibroNow',1) # send value True to address "/vibroNow" on IP 127.0.0.1 port 3011
	time.sleep(1)
	osc_client.sendOSCMessage('vibroNow',0) # send value False to address "/vibroNow" on IP 127.0.0.1 port 3011
	######################################


	#############  EXAMPLES  #############
	#############   SERVER   #############
	# Start OSCServer
	osc_server = OSCserver('127.0.0.1', 3010) # Init server communication on specific Ip and port
	osc_server.addListener('sensorData') # add listener on address "sensorData"
	osc_server.addListener('sensorRep') # add listener on address "sensorRep"
	osc_server.addListener('xmm') # add listener on address "xmm"

	timer0 = time.time()
	timer1 = timer0
	while (timer1-timer0 < 5):
		timer1 = time.time()
		time.sleep(0.05)

		print osc_server.get_CurrentMessage()

	osc_server.closeServer() # ERROR MESSAGE but close the OSC server without killing the app
	# osc_client.closeClient()
	######################################

if __name__ == '__main__':
	sys.exit(main())