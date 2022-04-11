void simulatePromulgateBig() {
  
  if(DEBUG) println("simulating promulgate");
  String test = "#L1,1003,L2,1012!";
  for(int i=0; i<test.length(); i++) {
    readDataBig(test.charAt(i));
  }
  
  String test2 = "#R5,99,L9,!";
  for(int i=0; i<test2.length(); i++) {
    readDataBig(test2.charAt(i));
  }
  
  // technically this wouldn't happen coming from a uint
  String test3 = "#R5,99,L9,-1!";
  for(int i=0; i<test3.length(); i++) {
    readDataBig(test3.charAt(i));
  }
  
  String test4 = "#R5,99,L9,1!";
  for(int i=0; i<test4.length(); i++) {
    readDataBig(test4.charAt(i));
  }
  
}


void readDataBig(char c) {
  
  if(c == '~' || c == '@' || c == '#' || c == '^' || c == '&') {
    reading = true;
    completed = false;
    start_read = millis();
  }
  
  if(reading) {
    if(DEBUG) println("readChar(): " + c + " msgIndex: " + msgIndex);
    
    msg[msgIndex++] = c;
  
    // @L1,1023! = 9
    // @L1,3! = 6
    // @L1,1,L2,3! = 11
    if(c == '!' || c == '?' || c == ';') {
      if(msgIndex >= 11-1) {// ehhh, is this necessary?
        completed = true;
      } else {
        if(DEBUG) println("promulgate error: received delimeter before the message was long enough"); 
      }
    }
    
    if(completed == true) {
      msgLen = msgIndex;
      msgIndex = 0;
      reading = false;
      parse_message_big();
      return;
    }
    
    // @L255,1023! = 11
    // @L255,1023,L255,1023! = 20
    if(msgIndex >= 20-1) {
      if(DEBUG) println("promulgate warning: index exceeded max message length");
      msgIndex = 0;
      msgLen = 0;
    }
    
    if(millis()-start_read >= MAX_READ_MS) {
      if(DEBUG) println("promulgate warning: read time exceeded max amount, stopping read");
      return;
    }

  }
}


void parse_message_big() {
  
  if(DEBUG) {
    println("parsing message now");
    for(int i=0; i<msgLen; i++) {
      print(msg[i]);
    }
    println("\n(end)");
  }
  
  char action = '0';
  char cmd = '0';
  int key_msg = 0;
  int val = 0;
  char cmd2 = '0';
  int key2_msg = 0;
  int val2 = 0;
  char delim = '0';
  
  String temp_key = "";
  String temp_val = "";
  int comma_index = 4;
  int comma2_index = -1;
  int delim_index = msgLen-1;
  
  // setting the action and command
  action = msg[0];
  cmd = msg[1];
  
  
  // finding the key
  for(int i=2; i<msgLen-1; i++) {
    
    if(msg[i] == ',') {
      comma_index = i;
      break;
    } else {
      temp_key = temp_key + msg[i];
    }
    
  }
  
  try {
    key_msg = (int)Integer.parseInt(temp_key);
  } catch(Exception e) {
    println("promulgate error: failed to parse int for key");
    println(e);
    return;
  }
  
  
  // finding the val
  for(int i=comma_index+1; i<msgLen-1; i++) {
    
    char c = msg[i];
    
    if(c == ',') {
      comma2_index = i;
      break;
    } else {
      temp_val = temp_val + msg[i];
    }
    
  }
  
  try {
    val = (int)Integer.parseInt(temp_val);
  } catch(Exception e) {
    println("promulgate error: failed to parse int for val");
    println(e);
    return;
  }
  
  
  // -------------------------------
  // ----------- part 2 ------------
  // -------------------------------
  
  cmd2 = msg[comma2_index+1];
  temp_key = "";
  temp_val = "";
  
  
  // finding the key2
  for(int i=comma2_index+2; i<msgLen-1; i++) {
    
    if(msg[i] == ',') {
      comma_index = i;
      break;
    } else {
      temp_key = temp_key + msg[i];
    }
    
  }
  
  try {
    key2_msg = (int)Integer.parseInt(temp_key);
  } catch(Exception e) {
    println("promulgate error: failed to parse int for key2");
    println(e);
    return;
  }
  
  
  // finding the val2
  for(int i=comma_index+1; i<msgLen-1; i++) {
    
    char c = msg[i];
    
    if(c == ',') {
      comma2_index = i;
      break;
    } else {
      temp_val = temp_val + msg[i];
    }
    
  }
  
  try {
    val2 = (int)Integer.parseInt(temp_val);
  } catch(Exception e) {
    println("promulgate error: failed to parse int for val2");
    println(e);
    return;
  }
  
  
  // setting the delimeter
  delim = msg[delim_index];
  
  
  // finally done!
  received_action_big(action, cmd, key_msg, val, cmd2, key2_msg, val2, delim);
  
}


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