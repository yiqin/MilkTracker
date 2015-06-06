// create a global variabled called led and assign pin9 to it
led <- hardware.pin9;
photocell <- hardware.pin2;
 
// configure led to be a digital output
led.configure(DIGITAL_OUT);
photocell.configure(ANALOG_IN);


function poll() {
	local temp = photocell.read()
	server.log("FSR sensor: " + temp)
	
	agent.send("ping", temp);
	
	imp.wakeup(1, poll)
}
 
// Call the function to make an inital poll
poll()