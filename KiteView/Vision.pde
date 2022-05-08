
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
  //for(int i=0; i<1; i++) {
  
    Contour contour = contours_1.get(i);
    Rectangle r = contour.getBoundingBox();
    
    if (r.width < 10 || r.height < 10) {
      continue;
    }
    
    
    if(landscapeDrawn()) {
      
      // check the x&y below the landscape 
      
      if( (int)(r.y*activity_scale) > landscapeLineY( (int)(r.x*activity_scale) )) {
        println("do not display");
        continue;
      }
      
    }
    
    
    //println("1 [" + i + "]: " + r);
    color c = colors[0];
    color c_new = color(red(c), green(c), blue(c), 100);
    stroke(255, 255, 255, 100);
    fill(c_new);
    strokeWeight(2);
    
    if(CAMERA_ENABLED) {
      rect(r.x*cam_scale+activity_view_x, r.y*cam_scale+activity_view_y, r.width*cam_scale, r.height*cam_scale);
    } else {
      rect(r.x*vid_scale+activity_view_x, r.y*vid_scale+activity_view_y, r.width*vid_scale, r.height*vid_scale);
    }
    
    noStroke();
    
    if(!kite_pos) {
      
      if(CAMERA_ENABLED) {
        kite_x = (int)(r.x*cam_scale+activity_view_x);
        kite_y = (int)(r.y*cam_scale+activity_view_y);
        kite_w = (int)(r.width*cam_scale);
        kite_h = (int)(r.height*cam_scale);
      } else {
        kite_x = (int)(r.x*vid_scale+activity_view_x);
        kite_y = (int)(r.y*vid_scale+activity_view_y);
        kite_w = (int)(r.width*vid_scale);
        kite_h = (int)(r.height*vid_scale);
      }
      
      addTracePoint(kite_x+(kite_w/2), kite_y+(kite_h/2));
      
      kite_pos = true;
    }
    
  }
  
  
  
  // are we actually going to use tracking > 1 colour?
  /*
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
  */
  
}