
void guiSetup() {
 
  int start_x = 20;
  int start_y = 320;
  int sp = 50;
  
  cp5.addButton("connectButton")
     .setValue(0)
     .setPosition(20,start_y+(sp*1))
     .setSize(200,40)
     .setFont(font_sm)
     .setLabel("Connect")
     ;
  
  cp5.addButton("testButton")
     .setValue(100)
     .setPosition(20,start_y+(sp*2))
     .setSize(200,40)
     .setFont(font_sm)
     .setLabel("System Test");
     ;
     
  cp5.addButton("zeroButton")
     .setValue(0)
     .setPosition(20,start_y+(sp*3))
     .setSize(200,40)
     .setFont(font_sm)
     .setLabel("Zero Positions");
     ;
  
  cp5.addButton("recordButton")
     .setValue(0)
     .setPosition(20,start_y+(sp*4))
     .setSize(200,40)
     .setFont(font_sm)
     .setLabel("Start Recording");
     ;
  
  cp5.addButton("traceButton")
     .setValue(0)
     .setPosition(20,start_y+(sp*5))
     .setSize(200,40)
     .setFont(font_sm)
     .setLabel("Start Trace");
     ;
  
  
  List l = new ArrayList();
  
  for(int i=0; i<Serial.list().length; i++) {
    if(DEBUG) println(Serial.list()[i]);
    l.add("" + Serial.list()[i]);
  }
  
  /* add a ScrollableList, by default it behaves like a DropdownList */
  cp5.addScrollableList("dropdown")
     .setPosition(start_x, start_y)
     .setSize(200, 300)
     .setBarHeight(40)
     .setItemHeight(40)
     .addItems(l)
     .setFont(font_sm)
     .setLabel("Ports")
     .setOpen(false)
     // .setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
     ;
  
  pitchGui();
  yawGui();
  reelGui();
  
}


void drawTitleGui() {
  
  fill(255);
  textFont(font_lg, 48);
  text("KiteView", 20, 60);
  textFont(font_md, 24);
  
  if(connected) {
    text("connected", 20, 90);  
  } else {
    text("not connected", 20, 90);
  }
  
  text(formatTimeStr(), 20, height-50);
  text(frameRate, 10, height-20);
  
  String str = "";
  float px = 0.0;
  textFont(font_sm, 16);
  
  px = ( (float)(kite_x-activity_view_x) / (float)cam_w )*100;
  str = ("kite x: " + kite_x + " px (" + nf(px, 0, 2) + "%)");
  text(str, 20, 120);

  px = ( (float)(kite_y-activity_view_y) / (float)cam_h )*100;
  str = ("kite y: " + kite_y + " px (" + nf(px, 0, 2) + "%)");
  text(str, 20, 140);
  
  px = ( (float)kite_w / (float)cam_w)*100.0;
  str = ("kite w: " + kite_w + " px (" + nf(px, 0, 2) + "%)");
  text(str, 20, 160);
  
  px = ( (float)kite_h / (float)cam_h )*100.0;
  str = ("kite h: " + kite_h + " px (" + nf(px, 0, 2) + "%)");
  text(str, 20, 180);
  
  str = ("hold 1,2,3 and click to select hue");
  text(str, 20, 200);
  
  str = ("z,x,c,v to simulate leds");
  text(str, 20, 220);
  
  str = ("l to set landscape");
  text(str, 20, 240);
  
  
  
  int start_x_actuators = 275;
  fill(255);
  textFont(font_md, 24);
  text("Pitch", start_x_actuators, 525);
  
  fill(255);
  textFont(font_md, 24);
  text("Yaw", start_x_actuators+250, 525);
  
  fill(255);
  textFont(font_md, 24);
  text("Reel", start_x_actuators+250+250, 525);
  
  
}


void pitchGui() {
 
  int startx = 275-30;
  int sp = 50;
  
  cp5.addSlider("sliderPitch")
     .setPosition(startx,530+10)
     .setWidth(200)
     .setHeight(20)
     .setRange(-100,100)
     .setValue(0)
     .setNumberOfTickMarks(10+1)
     .setSliderMode(Slider.FLEXIBLE)
     .setFont(font_sm)
     .setLabel("");
     ;
  
  cp5.getController("sliderPitch").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0).setPaddingY(10);
  
  cp5.addButton("pitchlockButton")
     .setValue(0)
     .setPosition(startx,600)
     .setSize(200,40)
     .setFont(font_sm)
     .setLabel("Lock");
     ;
  
  cp5.addButton("pitchhomeButton")
     .setValue(0)
     .setPosition(startx,600+(sp*1))
     .setSize(200,40)
     .setFont(font_sm)
     .setLabel("Home");
     ;
  
  cp5.addButton("pitchaddButton")
     .setValue(0)
     .setPosition(startx,600+(sp*2))
     .setSize(90,40)
     .setFont(font_sm)
     .setLabel("+ 10");
     ;
  
  cp5.addButton("pitchsubButton")
     .setValue(0)
     .setPosition(startx+110,600+(sp*2))
     .setSize(90,40)
     .setFont(font_sm)
     .setLabel("- 10");
     ;
  
}

void yawGui() {
 
  int startx = 275+250-30;
  int sp = 50;
  
  cp5.addSlider("sliderYaw")
     .setPosition(startx,530+10)
     .setWidth(200)
     .setHeight(20)
     .setRange(-100,100)
     .setValue(0)
     .setNumberOfTickMarks(10+1)
     .setSliderMode(Slider.FLEXIBLE)
     .setFont(font_sm)
     .setLabel("");
     ;
  
  cp5.getController("sliderYaw").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0).setPaddingY(10);
  
  cp5.addButton("yawlockButton")
     .setValue(0)
     .setPosition(startx,600)
     .setSize(200,40)
     .setFont(font_sm)
     .setLabel("Lock");
     ;
  
  cp5.addButton("yawhomeButton")
     .setValue(0)
     .setPosition(startx,600+(sp*1))
     .setSize(200,40)
     .setFont(font_sm)
     .setLabel("Home");
     ;
  
  cp5.addButton("yawaddButton")
     .setValue(0)
     .setPosition(startx,600+(sp*2))
     .setSize(90,40)
     .setFont(font_sm)
     .setLabel("+ 10");
     ;
  
  cp5.addButton("yawsubButton")
     .setValue(0)
     .setPosition(startx+110,600+(sp*2))
     .setSize(90,40)
     .setFont(font_sm)
     .setLabel("- 10");
     ;
  
}

void reelGui() {
 
  int startx = 275+250+250-30;
  int sp = 50;
  
  cp5.addSlider("sliderReel")
     .setPosition(startx,530+10)
     .setWidth(200)
     .setHeight(20)
     .setRange(-100,100)
     .setValue(0)
     .setNumberOfTickMarks(10+1)
     .setSliderMode(Slider.FLEXIBLE)
     .setFont(font_sm)
     .setLabel("");
     ;
  
  cp5.getController("sliderReel").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0).setPaddingY(10);
  
  cp5.addButton("reellockButton")
     .setValue(0)
     .setPosition(startx,600)
     .setSize(200,40)
     .setFont(font_sm)
     .setLabel("Lock");
     ;
  
  cp5.addButton("reelhomeButton")
     .setValue(0)
     .setPosition(startx,600+(sp*1))
     .setSize(200,40)
     .setFont(font_sm)
     .setLabel("Home");
     ;
  
  cp5.addButton("reeladdButton")
     .setValue(0)
     .setPosition(startx,600+(sp*2))
     .setSize(90,40)
     .setFont(font_sm)
     .setLabel("+ 10");
     ;
  
  cp5.addButton("reelsubButton")
     .setValue(0)
     .setPosition(startx+110,600+(sp*2))
     .setSize(90,40)
     .setFont(font_sm)
     .setLabel("- 10");
     ;
  
}


public void connectButton(int theValue) {
  if(millis() < 5000) return; // weird cp5 behaviour
  
  println("a button event from connectButton: "+theValue);
  
  if(!connected) {
  
    if(port != 99) {
      device = new Serial(this, Serial.list()[port], 9600);
      println("connected");
      connected = true;
      cp5.getController("connect").setCaptionLabel("Disconnect");
    } else {
      println("need to select a port!"); 
    }
  
  } else {
    
    device.clear();
    device.stop();
    
    cp5.getController("connect").setCaptionLabel("Connect");
    //port = 99;
    connected = false;
    
  }
  
}

public void testButton(int theValue) {
  if(millis() < 5000) return; // weird cp5 behaviour
  
  println("a button event from testButton: "+theValue);
}

public void zeroButton(int theValue) {
  if(millis() < 5000) return; // weird cp5 behaviour
  
  println("a button event from zeroButton: "+theValue);
}

public void recordButton(int theValue) {
  if(millis() < 5000) return; // weird cp5 behaviour
  
  println("a button event from recordButton: "+theValue);
  
  if(recording) {
    stopRecording();
  } else {
    startRecording();
  }
  
}

public void traceButton(int theValue) {
  if(millis() < 5000) return; // weird cp5 behaviour
  
  println("a button event from traceButton: "+theValue);
  
  if(!trace) {
    cp5.getController("traceButton")
     .setLabel("Stop Trace");
    resetTracePoints();
  } else {
    cp5.getController("traceButton")
     .setLabel("Start Trace");
  }
  
  trace = !trace;
  
}


void dropdown(int n) {
  /* request the selected item based on index n */
  println(n, cp5.get(ScrollableList.class, "dropdown").getItem(n));
  
  /* here an item is stored as a Map  with the following key-value pairs:
   * name, the given name of the item
   * text, the given text of the item by default the same as name
   * value, the given value of the item, can be changed by using .getItem(n).put("value", "abc"); a value here is of type Object therefore can be anything
   * color, the given color of the item, how to change, see below
   * view, a customizable view, is of type CDrawable 
   */
  
  CColor c = new CColor();
  c.setBackground(color(255,0,0));
  cp5.get(ScrollableList.class, "dropdown").getItem(n).put("color", c);
  
}


void drawStatusLeds() {
 
  int start_x = 35;
  int start_y = 280;
  
  // red
  if(status_leds[0] == 0) {
    fill(255, 0, 0, 50); 
  } else if(status_leds[0] == 1) {
    fill(255, 0, 0, 255);
  }
  ellipse(start_x, start_y, 30, 30);
  
  // green
  if(status_leds[1] == 0) {
    fill(0, 255, 0, 50); 
  } else if(status_leds[1] == 1) {
    fill(0, 255, 0, 255);
  }
  ellipse(start_x+50, start_y, 30, 30);
  
  // blue
  if(status_leds[2] == 0) {
    fill(0, 0, 255, 50); 
  } else if(status_leds[2] == 1) {
    fill(0, 0, 255, 255);
  }
  ellipse(start_x+50+50, start_y, 30, 30);
  
  // yellow
  if(status_leds[3] == 0) {
    fill(200, 200, 0, 50); 
  } else if(status_leds[3] == 1) {
    fill(200, 200, 0, 255);
  }
  ellipse(start_x+50+50+50, start_y, 30, 30);
  
}

void toggleStatusLed(int i) {
  if(status_leds[i] == 0) {
    status_leds[i] = 1;
  } else if(status_leds[i] == 1) {
    status_leds[i] = 0; 
  }
}


String formatTimeStr() {
  String str = "";
  if(hour() < 10) {
    str += "0";
  }
  str += hour() + ":";
  if(minute() < 10) {
    str += "0";
  }
  str += minute() + ":";
  if(second() < 10) {
    str += "0";
  }
  str += second() + ":" + millis();
  
  return str;
}


int getActivityViewWidth() {
  return activity_w_scaled;
}

int getActivityViewMappedX(int x) {
  return (int)((float)x*activity_scale)+activity_view_x;
}

int getActivityViewMappedY(int y) {
  return (int)((float)y*activity_scale)+activity_view_y;
}

/*
what is needed:
mouseX (absolute) -> point relative to activity view
activity view -> absolute point
*/

int absToActX(int x) {
  int r = (int)((float)x*activity_scale)+activity_view_x;
  return r;
}

int absToActY(int y) {
  int r = (int)((float)y*activity_scale)+activity_view_y;
  return r;
}

int actToAbsX(int n) {
  //int r = ;
  return 0;
}

int actToAbsY(int n) {
  
  return 0;
}