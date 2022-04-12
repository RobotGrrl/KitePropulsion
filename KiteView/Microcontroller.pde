// -- device -- //
Serial device;
int port = 99;
boolean connected = false;


// this is where we action the received info from the device!
void received_action_big(char action, char cmd, int key_msg, int val, char cmd2, int key_msg2, int val2, char delim) {
  
  if(DEBUG) {
    println("---RECEIVED ACTION!---");
    println("action: " + action);
    println("cmd: " + cmd);
    println("key: " + key_msg);
    println("val: " + val);
    println("cmd2: " + cmd2);
    println("key2: " + key_msg2);
    println("val2: " + val2);
    println("delim: " + delim);
  }
  
}


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


void transmit_action_big(char action, char cmd, int key_msg, int val, char cmd2, int key_msg2, int val2, char delim) {
  
  if(key_msg > 255 || key_msg2 > 255) {
    println("promulgate error: key has to be <= 255");
    return;
  }
  
  if(val > 1023 || val2 > 1023) {
    println("promulgate error: val has to be <= 1023");
    return;
  }
  
  String s = (action + "" + cmd + "" + key_msg + "," + val + "," + cmd2 + "" + key_msg2 + "," + val2 + "" + delim);
  println(s);
  if(connected) {
    device.write(s);
    transmit_complete();
  }
  
}

void transmit_action(char action, char cmd, int key_msg, int val, char delim) {
  
  if(key_msg > 255) {
    println("promulgate error: key has to be <= 255");
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