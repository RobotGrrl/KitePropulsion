
// this is where we action the received info from the device!
void received_action(char action, char cmd, int key_msg, int val, char delim) {
  
  if(DEBUG) {
    println("---RECEIVED ACTION!---");
    println("action: " + action);
    println("cmd: " + cmd);
    println("key: " + key_msg);
    println("val: " + val);
    println("delim: " + delim);
  }
  
}


void transmit_complete() {
  if(DEBUG) println("message sent");
}


void transmit_action(char action, char cmd, int key_msg, int val, char delim) {
  
  if(key_msg > 256) {
    println("promulgate error: key has to be <= 256");
    return;
  }
  
  if(val > 1023) {
    println("promulgate error: val has to be <= 1023");
    return;
  }
  
  String s = (action + "" + cmd + "" + key_msg + "," + val + "" + delim);
  println(s);
  if(connected) {
    device.write(s);
    transmit_complete();
  }
  
}


void simulatePromulgate() {
  
  if(DEBUG) println("simulating promulgate");
  String test = "#L1,1003!";
  for(int i=0; i<test.length(); i++) {
    readData(test.charAt(i));
  }
  
}