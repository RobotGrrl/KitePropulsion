
void startRecording() {
  // start record
  recording = true;
  println("starting recording");
  String fn = month() + "-" + day() + "-" + year() + "_" + hour() + "-" + minute() + "-" + second();
  println("filename: " + fn);
  sketchExport.setMovieFileName(fn + "-screen.mp4");
  sketchExport.startMovie();
  //camExport.setMovieFileName(fn + "-camera.mp4");
  //camExport.startMovie();
}

void stopRecording() {
  recording = false;
  println("stopping recording");
  sketchExport.endMovie();
  camExport.endMovie();
}