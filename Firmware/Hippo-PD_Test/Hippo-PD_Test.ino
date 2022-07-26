
#include "Board.h"

void setup() {
  Serial.begin(9600);

  pinMode(LED_S03C, OUTPUT);
  pinMode(LED_S01, OUTPUT);
  pinMode(LED_S03, OUTPUT);
  pinMode(LED_S04, OUTPUT);
  pinMode(LED_S05, OUTPUT);
  pinMode(LED_S06, OUTPUT);
  pinMode(LED_S03D, OUTPUT);
  pinMode(BUZZER, OUTPUT);
  pinMode(FREE1, INPUT);
  pinMode(BUTTON1, INPUT);
  pinMode(BUTTON2, INPUT);
  pinMode(BUTTON3, INPUT);
  pinMode(FREE2, INPUT);
  pinMode(FREE3, INPUT);
  pinMode(LED_S03A, OUTPUT);
  pinMode(LED_S03B, OUTPUT);
  pinMode(5V_SIG, INPUT);
  pinMode(IN_SIG, INPUT);
  pinMode(S03_SIG4, INPUT);
  pinMode(S03_SIG3, INPUT);
  pinMode(S03_SIG2, INPUT);
  pinMode(S03_SIGSMPS, INPUT);
  pinMode(S03_SIG1, INPUT);
  pinMode(S06_SIG1, INPUT);
  pinMode(S06_SIGSMPS, INPUT);
  pinMode(LED, OUTPUT);
  pinMode(S04_SIG1, INPUT);
  pinMode(S04_SIG2, INPUT);
  pinMode(S04_SIG3, INPUT);
  pinMode(S04_SIGSMPS, INPUT);
  pinMode(S05_SIGNP, INPUT);
  pinMode(S05_SIG2, INPUT);
  pinMode(S05_SIG1, INPUT);
  pinMode(S05_SIGSMPS, INPUT);


}

void loop() {
  

}
