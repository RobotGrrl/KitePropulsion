
// check if there is a landscape
boolean landscapeDrawn() {
  if(landscape_y1 != -1 && landscape_y2 != -1) {
    return true;
  }
  return false;
}

// called from keyPressed()
void landscape() {

  draw_landscape_mode = !draw_landscape_mode;
  if(draw_landscape_mode) {
    // reset
    landscape_y1 = -1;
    landscape_y2 = -1;
  }
  
}

float landscapeLineSlope() {
  
  float slope = 0;
  float rise = (float)( (landscape_y1*activity_scale)-activity_view_y - (landscape_y2*activity_scale)-activity_view_y );
  float run = (float)( (activity_view_x*activity_scale) - getActivityViewWidth() );
  slope = rise / run;  
  
  return slope;
}


int landscapeLineY(int x) {
  
  float kx = ((float)x)*activity_scale;
  
  // y=mx+b
  float mx = (float)(landscapeLineSlope()*kx);
  float the_y = mx + landscape_y1 - (activity_view_y*2.5); // 2.5 fudge factor
  int y = (int)the_y;
  
  return y;
}