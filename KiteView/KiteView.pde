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

int activity_view_x = 325;
int activity_view_y = 10;
float activity_scale;
int activity_w_scaled;
int activity_h_scaled;


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

boolean draw_landscape_mode = false;
int landscape_y1 = 300;//-1;
int landscape_y2 = 350;//-1;


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
    activity_scale = cam_scale;
    activity_w_scaled = (int)(cam_w*cam_scale);
    activity_h_scaled = (int)(cam_h*cam_scale);
  } else {
    activity_scale = vid_scale;
    activity_w_scaled = (int)(vid_w*vid_scale);
    activity_h_scaled = (int)(vid_h*vid_scale); 
  }
  

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
  
    image(cam, activity_view_x, activity_view_y, activity_w_scaled, activity_h_scaled);
    
    // <2> Load the new frame of our movie in to OpenCV
    opencv.loadImage(cam);
    
  } else {
    
    image(video, activity_view_x, activity_view_y, activity_w_scaled, activity_h_scaled);
    
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
      image(outputs[i], activity_view_x+activity_w_scaled+40, i*src.height/scaley+((i+1)*10), src.width/scaley, src.height/scaley);
      noStroke();
      fill(colors[i]);
      rect(activity_view_x+activity_w_scaled+10, i*src.height/scaley+((i+1)*10), 30, src.height/scaley);
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
  
  
  
  
  
  // show the colour bigger
  if(mouseX > activity_view_x && mouseX < (activity_view_x+activity_w_scaled) && mouseY > activity_view_y && mouseY < (activity_view_y+activity_h_scaled)) {
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
  
  
  
  if(draw_landscape_mode) {
    
    boolean draw_it = false;
    
    if(mouseX > activity_view_x && mouseX < (activity_view_x+activity_w_scaled) && mouseY > activity_view_y && mouseY < (activity_view_y+activity_h_scaled)) {
      draw_it = true;
    }
    
    if(draw_it) {
      fill(235, 222, 52);
      ellipse(mouseX-4, mouseY+4, 15, 15);
    }
    
  }
  
  
  if(landscapeDrawn()) {
    
    /*
    for(int i=activity_view_x; i<getActivityViewWidth()+activity_view_x; i+=10) {
      for(int j=activity_view_y; j<activity_h_scaled+activity_view_y; j+=10) {
        //if( getActivityViewMappedY(j) > landscapeLineY( getActivityViewMappedX(j) )) {
        if( j > landscapeLineY( i-activity_view_x )) {
          fill(255,0,0);
          ellipse(i,j,5,5);
        } else {
          fill(0,255,0);
          ellipse(i,j,5,5);
        }
      }
    }
    */
    
    
    // draw in blue the landscape line func result
    for(int i=activity_view_x; i<getActivityViewWidth()+activity_view_x; i++) {
      fill(0,0,255);
      ellipse(i, landscapeLineY( i-activity_view_x ), 5, 5);
    }
    
    
    //draw_landscape_mode = false; // auto-exit
    
    int x1 = activity_view_x;
    int x2 = 0;
    int y_max = 0;
    
    x2 = (activity_view_x+activity_w_scaled);
    y_max = activity_view_y+activity_h_scaled;
    
    // draw circles at points
    fill(235, 222, 52);
    ellipse(x1, landscape_y1, 15, 15);
    ellipse(x2, landscape_y2, 15, 15);
    
    // colour outline of top part yellow too
    noFill();
    stroke(235, 222, 52);
    strokeWeight(2);
    beginShape();
    vertex(x1, landscape_y1);
    vertex(x2, landscape_y2);
    vertex(x2, activity_view_y);
    vertex(x1, activity_view_y);
    endShape(CLOSE);
    
    // colour bottom part grey
    /*
    // TODO: uncomment this after debugging
    color c1 = 50;//235, 222, 52;
    fill(c1, 220);
    stroke(50, 50, 50);
    strokeWeight(2);
    beginShape();
    vertex(x1, landscape_y1);
    vertex(x2, landscape_y2);
    vertex(x2, y_max);
    vertex(x1, y_max);
    endShape(CLOSE);
    */
    
    // colour line yellow
    stroke(235, 222, 52);
    strokeWeight(2);
    line(x1, landscape_y1, x2, landscape_y2);
    
    noStroke();
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
  
  
  
  if(draw_landscape_mode) {
    
    float halfway = 0.0;
    
    halfway = activity_view_x+(activity_w_scaled/2.0);
    
    if(mouseX < halfway) {
      landscape_y1 = mouseY;
      println("landscape_y1: " + landscape_y1);
    } else if(mouseX >= halfway) {
      landscape_y2 = mouseY;
      println("landscape_y2: " + landscape_y2);
    }
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
  
  if(key == 'l') {
    landscape();
  }
  
}

void keyReleased() {
  colorToChange = -1; 
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