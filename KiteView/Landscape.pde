/*
 * notes to self
 * landscape_y1 & y2 are absolute (mouseY)
 *
 * the filter is evaluating based on relative units to activity view
 * the drawing is based on absolute units
 */


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
  //float rise = (float)( absoluteToRelativeActivityView_Y(landscape_y1) - absoluteToRelativeActivityView_Y(landscape_y2) );  
  float rise = landscape_y1-landscape_y2;
  float run = (float)( (activity_view_x) - (getActivityViewWidth()+activity_view_x) );  
  slope = rise / run;  
  
  return slope;
}


int landscapeLineY(int x) {
  
  // y=mx+b
  //float mx = landscapeLineSlope()*(float)x;
  //float b = (float)absoluteToRelativeActivityView_Y(landscape_y1);
  
  float mx = landscapeLineSlope()*(float)x;
  float b = landscape_y1;
  
  int y = (int)(mx+b);
  
  return y;
}



float landscapeLineSlopeRelative() {
  
  float slope = 0;
  float rise = (float)( absoluteToRelativeActivityView_Y(landscape_y1) - absoluteToRelativeActivityView_Y(landscape_y2) );  
  //float rise = landscape_y1-landscape_y2;
  float run = (float)( (activity_view_x) - (getActivityViewWidth()+activity_view_x) );  
  slope = rise / run;  
  
  return slope;
}


int landscapeLineYRelative(int x) {
  
  // y=mx+b
  float mx = landscapeLineSlopeRelative()*(float)x;
  float b = (float)absoluteToRelativeActivityView_Y(landscape_y1);
  int y = (int)(mx+b);
  
  return y;
}



int absoluteToRelativeActivityView_Y(int p) {
  int a = (int)((float)p*activity_scale)-activity_view_y;
  return a;
}