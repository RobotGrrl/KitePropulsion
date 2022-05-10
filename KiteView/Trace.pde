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