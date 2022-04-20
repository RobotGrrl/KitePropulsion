/*
 * KiteView
 * ---------
 * Vision tracking of a kite flying and sending 
 * the data over uart to the kite controller
 * 
 * Erin RobotGrrl
 * April 5, 2022
 * License: Something TBD
 */

import processing.video.*;
import com.hamoid.*; // VideoExport library
import gab.opencv.*;
import java.awt.Rectangle;
import controlP5.*;
import processing.serial.*;
import java.util.*;
import java.util.ArrayList;
import java.util.List;

static final boolean DEBUG = true;

static boolean CAMERA_ENABLED = false;

PrintWriter output;

Capture cam;
VideoExport sketchExport;
VideoExport camExport;
ControlP5 cp5;
Movie video;


OpenCV opencv;
PImage src;
ArrayList<Contour> contours_1;
ArrayList<Contour> contours_2;
ArrayList<Contour> contours_3;

// <1> Set the range of Hue values for our filter
//ArrayList<Integer> colors;
int maxColors = 3;
int[] hues;
int[] colors;
int rangeWidth = 25;//10;

PImage[] outputs;

int colorToChange = -1;


boolean recording = false;
// 648x486
// 1296x972
//int cam_w = 648;
//int cam_h = 486;
int cam_w = 1296;
int cam_h = 972;
int vid_w = 960;
int vid_h = 720;
float cam_scale = 0.5;
float vid_scale = 0.65;
int cam_x = 325;
int cam_y = 10;
int cam_w_scaled = (int)(cam_w*cam_scale);
int cam_h_scaled = (int)(cam_h*cam_scale);
int vid_w_scaled = (int)(vid_w*vid_scale);
int vid_h_scaled = (int)(vid_h*vid_scale);


boolean kite_pos = false;
int kite_x = 0;
int kite_y = 0;
int kite_w = 0;
int kite_h = 0;


int[] status_leds = {0, 0, 0, 0};


PFont font_lg;
PFont font_md;
PFont font_sm;


boolean trace = true;
final int TRACE_MAX = 50;
int[] trace_x = new int[TRACE_MAX];
int[] trace_y = new int[TRACE_MAX];
long last_track = 0;

boolean vidpaused = true;


void setup() {
  
  size(1280, 750);//, P2D); // P2D offloads some rendering to opengl, however in this sketch it makes it glitchy
  frameRate(10);
  //noSmooth();
  
  //video = new Movie(this, "hill-720p-4_3.mp4");
  video = new Movie(this, "hill-crop-720p-4_3.mp4");
  video.loop();
  video.volume(0);
  
  font_lg = loadFont("LucidaSans-48.vlw");
  font_md = loadFont("LucidaSans-24.vlw");
  font_sm = loadFont("LucidaSans-16.vlw");
  
  textFont(font_sm, 16);
  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);
  guiSetup();

  if(CAMERA_ENABLED) {
    
    String[] cameras = Capture.list();
    
    if (cameras.length == 0) {
      println("There are no cameras available for capture.");
      exit();
    } else {
      println("Available cameras:");
      for (int i = 0; i < cameras.length; i++) {
        print("[" + i + "] ");
        println(cameras[i]);
      }
      
      // The camera can be initialized directly using an 
      // element from the array returned by list():
      // 6: 648x486
      // 3: 1296x972
      //cam = new Capture(this, 648, 486, cameras[8]);
      
      cam = new Capture(this, 1296, 972, cameras[3]);
      cam.start();
    }
    
  }
  
  //imageMode(CENTER); // why was this here?
  
  sketchExport = new VideoExport(this);
  //camExport = new VideoExport(this, "camera.mp4", cam);
  
  sketchExport.setFrameRate(5);
  
  // set up opencv
  if(CAMERA_ENABLED) {
    opencv = new OpenCV(this, cam.width, cam.height);
  } else {
    opencv = new OpenCV(this, video.width, video.height);
  }
  
  contours_1 = new ArrayList<Contour>();
  contours_2 = new ArrayList<Contour>();
  contours_3 = new ArrayList<Contour>();
  
  // Array for detection colors
  colors = new int[maxColors];
  hues = new int[maxColors];
  
  outputs = new PImage[maxColors];
  
  resetTracePoints();
  defaultTrackHue();
  
  imageMode(CORNER);
  
  String fn = month() + "-" + day() + "-" + year() + "_" + hour() + "-" + minute() + "-" + second();
  output = createWriter("data/" + fn + ".csv");
  output.println("FRAME_COUNT,MILLIS,X,Y,W,H,SKIPPED");
  
}

void draw() {
  
  background(50);
  
  cp5.draw();
  
  
  if(CAMERA_ENABLED) {
    
    if (cam.available() == true) {
      cam.read();
    } else {
      return; 
    }
  
    image(cam, cam_x, cam_y, cam_w_scaled, cam_h_scaled);
    
    // <2> Load the new frame of our movie in to OpenCV
    opencv.loadImage(cam);
    
  } else {
    
    image(video, cam_x, cam_y, vid_w_scaled, vid_h_scaled);
    
    // <2> Load the new frame of our movie in to OpenCV
    opencv.loadImage(video);
    
  }
    
  // Tell OpenCV to use color information
  opencv.useColor();
  src = opencv.getSnapshot();
  
  // <3> Tell OpenCV to work in HSV color space.
  opencv.useColor(HSB);
  
  detectColors();
  
  
  // Show images
  int scaley = 5;
  for (int i=0; i<outputs.length; i++) {
    if (outputs[i] != null) {
      image(outputs[i], cam_x+cam_w_scaled+40, i*src.height/scaley+((i+1)*10), src.width/scaley, src.height/scaley);
      noStroke();
      fill(colors[i]);
      rect(cam_x+cam_w_scaled+10, i*src.height/scaley+((i+1)*10), 30, src.height/scaley);
    }
  }
  
  displayContoursBoundingBoxes();
 
  
  
  
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
  
  px = ( (float)(kite_x-cam_x) / (float)cam_w )*100;
  str = ("kite x: " + kite_x + " px (" + nf(px, 0, 2) + "%)");
  text(str, 20, 120);

  px = ( (float)(kite_y-cam_y) / (float)cam_h )*100;
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
  
  
  
  
  
  // show the colour bigger
  if(mouseX > cam_x && mouseX < (cam_x+cam_w_scaled) && mouseY > cam_y && mouseY < (cam_y+cam_h_scaled)) {
    fill(get(mouseX, mouseY));
    rect(mouseX+4, mouseY+4, 40, 40);
    fill(0);
    stroke(1);
    noStroke();
  }
  
  
  
  
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
  
  
  
  if(trace) {
    for(int i=0; i<TRACE_MAX; i++) {
      if(trace_x[i] == -1 || trace_y[i] == -1) {
        continue;
      }
      fill(144, 96, 214);
      ellipse(trace_x[i], trace_y[i], 15, 15);
      stroke(0);
      if(i>0) line(trace_x[i], trace_y[i], trace_x[i-1], trace_y[i-1]);
      noStroke();
    }
  }
  
  
  drawStatusLeds();
  
  
  
  if(connected) {
    char c;
    while(device.available() > 0) {
      c = device.readChar();
      readData(c);
    }
  }
  
  
  
  
  if(recording) {
    sketchExport.saveFrame();
    //camExport.saveFrame();
  }
  
  //println(mouseX + ", " + mouseY);
  
}



void movieEvent(Movie m) {
  m.read();
}




void slider(float theColor) {
  println("a slider event");
}



void mousePressed() {
    
  if (colorToChange > -1) {
    
    color c = get(mouseX, mouseY);
    println("r: " + red(c) + " g: " + green(c) + " b: " + blue(c));
   
    int hue = int(map(hue(c), 0, 255, 0, 180));
    
    colors[colorToChange-1] = c;
    hues[colorToChange-1] = hue;
    
    println("color index " + (colorToChange-1) + ", value: " + hue);
  }
}


void defaultTrackHue() {
  color track_colour = color(202, 27, 33);
  int track_hue = int(map(hue(track_colour), 0, 255, 0, 180));
  colors[0] = track_colour;
  hues[0] = track_hue;
  println("color index " + (0) + ", value: " + track_hue);
}


void mouseClicked() {
  
}



void keyPressed() {
  if(key == 'r') {
    if(!recording) {
      startRecording();
    } else {
      stopRecording();
    }
  }
  if(key == 'q') {
    // stop record, disconnect, and exit
    stopRecording();
    output.flush();
    output.close();
    exit();
  }
  
  
  if(key == '1') {
    colorToChange = 1;
  } else if(key == '2') {
    colorToChange = 2;
  } else if(key == '3') {
    colorToChange = 3;
  }
  
  
  if(key == 'z') {
    toggleStatusLed(0);
  } else if(key == 'x') {
    toggleStatusLed(1);
  } else if(key == 'c') {
    toggleStatusLed(2);
  } else if(key == 'v') {
    toggleStatusLed(3);
  }
  
  if(key == 'h') {
    // todo eh
  }
  
  if(key == 'g') {
    simulatePromulgate();
  } else if(key == 'h') {
    simulatePromulgateBig();
  }
  
  if(key == 'p') {
    if(vidpaused) {
      video.volume(0);
      video.play(); 
    } else {
      video.volume(0);
      video.pause(); 
    }
    vidpaused = !vidpaused;
  }
  
}

void keyReleased() {
  colorToChange = -1; 
}




void addTracePoint(int x, int y) {
  
  if(!trace) return;
  
  int THRESH_FAR = 75;
  boolean skip = false;
  
  // if there's been points added already
  if(trace_x[0] != -1 || trace_y[0] != -1) {
    
    // it's too far away
    if(abs(x-trace_x[0]) >= THRESH_FAR || abs(y-trace_y[0]) >= THRESH_FAR) {
      
      // if it's been some time since the last skip, then add it anyway
      if(millis()-last_track >= 2000 || last_track == 0) {
        println("new point is far away, but it's been a while - add anyway");
      } else {
        println("new point is too far away - skip");
        skip = true;
      }
      
    }
  }
  
  if(!skip) {
    
    for(int i=TRACE_MAX-1; i>0; i--) {
      trace_x[i] = trace_x[i-1];
      trace_y[i] = trace_y[i-1];
    }
    
    trace_x[0] = x;
    trace_y[0] = y;
    
    last_track = millis(); 
  }
  
  // FRAME_COUNT,MILLIS,X,Y,W,H,SKIPPED
  output.print(frameCount + "," + millis() + ",");
  if(!skip) {
    output.print(trace_x[0] + "," + trace_y[0] + ",");
  } else {
    output.print(x + "," + y + ",");
  }
  output.print(kite_w + "," + kite_h + ",");
  if(skip) {
    output.println("1");
  } else {
    output.println("0");
  }
  
}

void resetTracePoints() {
 for(int i=0; i<TRACE_MAX; i++) {
   trace_x[i] = -1;
   trace_y[i] = -1;
 }
}





//////////////////////
// Detect Functions
//////////////////////

void detectColors() {
    
  for (int i=0; i<hues.length; i++) {
    
    if (hues[i] <= 0) continue;
    
    opencv.loadImage(src);
    opencv.useColor(HSB);
    
    // <4> Copy the Hue channel of our image into 
    //     the gray channel, which we process.
    opencv.setGray(opencv.getH().clone());
    
    int hueToDetect = hues[i];
    //println("index " + i + " - hue to detect: " + hueToDetect);
    
    // <5> Filter the image based on the range of 
    //     hue values that match the object we want to track.
    opencv.inRange(hueToDetect-rangeWidth/2, hueToDetect+rangeWidth/2);
    
    //opencv.dilate();
    opencv.erode();
    
    // TO DO:
    // Add here some image filtering to detect blobs better
    
    // <6> Save the processed image for reference.
    outputs[i] = opencv.getSnapshot();
  }
  
  // <7> Find contours in our range image.
  //     Passing 'true' sorts them by descending area.
  if (outputs[0] != null) {
    opencv.loadImage(outputs[0]);
    contours_1 = opencv.findContours(true,true);
  }
  
  if(outputs[1] != null) {
    opencv.loadImage(outputs[1]);
    contours_2 = opencv.findContours(true,true);
  }
  
  if(outputs[2] != null) {
    opencv.loadImage(outputs[2]);
    contours_3 = opencv.findContours(true,true);
  }
  
}

void displayContoursBoundingBoxes() {
  
  kite_pos = false;
  for(int i=0; i<contours_1.size(); i++) {
  
    Contour contour = contours_1.get(i);
    Rectangle r = contour.getBoundingBox();
    
    if (r.width < 10 || r.height < 10)
      continue;
    
    //println("1 [" + i + "]: " + r);
    color c = colors[0];
    color c_new = color(red(c), green(c), blue(c), 100);
    stroke(255, 255, 255, 100);
    fill(c_new);
    strokeWeight(2);
    
    if(CAMERA_ENABLED) {
      rect(r.x*cam_scale+cam_x, r.y*cam_scale+cam_y, r.width*cam_scale, r.height*cam_scale);
    } else {
      rect(r.x*vid_scale+cam_x, r.y*vid_scale+cam_y, r.width*vid_scale, r.height*vid_scale);
    }
    
    noStroke();
    
    if(!kite_pos) {
      
      if(CAMERA_ENABLED) {
        kite_x = (int)(r.x*cam_scale+cam_x);
        kite_y = (int)(r.y*cam_scale+cam_y);
        kite_w = (int)(r.width*cam_scale);
        kite_h = (int)(r.height*cam_scale);
      } else {
        kite_x = (int)(r.x*vid_scale+cam_x);
        kite_y = (int)(r.y*vid_scale+cam_y);
        kite_w = (int)(r.width*vid_scale);
        kite_h = (int)(r.height*vid_scale);
      }
      
      addTracePoint(kite_x+(kite_w/2), kite_y+(kite_h/2));
      
      kite_pos = true;
    }
    
  }
  
  
  for(int i=0; i<contours_2.size(); i++) {
  
    Contour contour = contours_2.get(i);
    Rectangle r = contour.getBoundingBox();
    
    if (r.width < 60 || r.height < 60)
      continue;
    
    //println("2 [" + i + "]: " + r);
    color c = colors[1];
    color c_new = color(red(c), green(c), blue(c), 100);
    stroke(255, 255, 255, 100);
    fill(c_new);
    strokeWeight(2);
    rect(r.x*cam_scale+cam_x, r.y*cam_scale+cam_y, r.width*cam_scale, r.height*cam_scale);
    noStroke();
    
  }
  
  
  for(int i=0; i<contours_3.size(); i++) {
  
    Contour contour = contours_3.get(i);
    Rectangle r = contour.getBoundingBox();
    
    if (r.width < 60 || r.height < 60)
      continue;
    
    //println("3 [" + i + "]: " + r);
    color c = colors[2];
    color c_new = color(red(c), green(c), blue(c), 100);
    stroke(255, 255, 255, 100);
    fill(c_new);
    strokeWeight(2);
    rect(r.x*cam_scale+cam_x, r.y*cam_scale+cam_y, r.width*cam_scale, r.height*cam_scale);
    noStroke();
    
  }
  
}





/*
Available cameras:
[0] name=USB Camera,size=2592x1944,fps=30
[1] name=USB Camera,size=2592x1944,fps=15
[2] name=USB Camera,size=2592x1944,fps=1
[3] name=USB Camera,size=1296x972,fps=30
[4] name=USB Camera,size=1296x972,fps=15
[5] name=USB Camera,size=1296x972,fps=1
[6] name=USB Camera,size=648x486,fps=30
[7] name=USB Camera,size=648x486,fps=15
[8] name=USB Camera,size=648x486,fps=1
[9] name=USB Camera,size=324x243,fps=30
[10] name=USB Camera,size=324x243,fps=15
[11] name=USB Camera,size=324x243,fps=1
[12] name=GoPro Webcam,size=1920x1080,fps=30
[13] name=GoPro Webcam,size=1920x1080,fps=15
[14] name=GoPro Webcam,size=1920x1080,fps=1
[15] name=GoPro Webcam,size=960x540,fps=30
[16] name=GoPro Webcam,size=960x540,fps=15
[17] name=GoPro Webcam,size=960x540,fps=1
[18] name=GoPro Webcam,size=480x270,fps=30
[19] name=GoPro Webcam,size=480x270,fps=15
[20] name=GoPro Webcam,size=480x270,fps=1
[21] name=GoPro Webcam,size=240x135,fps=30
[22] name=GoPro Webcam,size=240x135,fps=15
[23] name=GoPro Webcam,size=240x135,fps=1
[24] name=OBS Virtual Camera,size=1280x720,fps=30
[25] name=OBS Virtual Camera,size=1280x720,fps=15
[26] name=OBS Virtual Camera,size=1280x720,fps=1
[27] name=OBS Virtual Camera,size=640x360,fps=30
[28] name=OBS Virtual Camera,size=640x360,fps=15
[29] name=OBS Virtual Camera,size=640x360,fps=1
[30] name=OBS Virtual Camera,size=320x180,fps=30
[31] name=OBS Virtual Camera,size=320x180,fps=15
[32] name=OBS Virtual Camera,size=320x180,fps=1
[33] name=OBS Virtual Camera,size=160x90,fps=30
[34] name=OBS Virtual Camera,size=160x90,fps=15
[35] name=OBS Virtual Camera,size=160x90,fps=1
[36] name=OBS Virtual Camera,size=80x45,fps=30
[37] name=OBS Virtual Camera,size=80x45,fps=15
[38] name=OBS Virtual Camera,size=80x45,fps=1
[39] name=FaceTime HD Camera,size=1280x720,fps=30
[40] name=FaceTime HD Camera,size=1280x720,fps=15
[41] name=FaceTime HD Camera,size=1280x720,fps=1
[42] name=FaceTime HD Camera,size=640x360,fps=30
[43] name=FaceTime HD Camera,size=640x360,fps=15
[44] name=FaceTime HD Camera,size=640x360,fps=1
[45] name=FaceTime HD Camera,size=320x180,fps=30
[46] name=FaceTime HD Camera,size=320x180,fps=15
[47] name=FaceTime HD Camera,size=320x180,fps=1
[48] name=FaceTime HD Camera,size=160x90,fps=30
[49] name=FaceTime HD Camera,size=160x90,fps=15
[50] name=FaceTime HD Camera,size=160x90,fps=1
[51] name=FaceTime HD Camera,size=80x45,fps=30
[52] name=FaceTime HD Camera,size=80x45,fps=15
[53] name=FaceTime HD Camera,size=80x45,fps=1
*/