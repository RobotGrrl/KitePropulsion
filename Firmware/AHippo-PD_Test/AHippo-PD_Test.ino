
#include "Board.h"
#include "Signal.h"

#define NUM_SIGNALS 17

struct Signal all_signals[NUM_SIGNALS];
struct Signal *selected = NULL;

void setup() {
  Serial.begin(9600);

  pinInit();

  digitalWrite(LED_PIN, HIGH);

  all_signals[0] = T5V_SIG;
  all_signals[1] = IN_SIG;
  all_signals[2] = S03_SIG4;
  all_signals[3] = S03_SIG3;
  all_signals[4] = S03_SIG2;
  all_signals[5] = S03_SIGSMPS;
  all_signals[6] = S03_SIG1;
  all_signals[7] = S06_SIG1;
  all_signals[8] = S06_SIGSMPS;
  all_signals[9] = S04_SIG1;
  all_signals[10] = S04_SIG2;
  all_signals[11] = S04_SIG3;
  all_signals[12] = S04_SIGSMPS;
  all_signals[13] = S05_SIGNP;
  all_signals[14] = S05_SIG2;
  all_signals[15] = S05_SIG1;
  all_signals[16] = S05_SIGSMPS;

  
  T5V_SIG.pin = T5V_SIG_PIN;
  IN_SIG.pin = IN_SIG_PIN;
  S03_SIG4.pin = S03_SIG4_PIN;
  S03_SIG3.pin = S03_SIG3_PIN;
  S03_SIG2.pin = S03_SIG2_PIN;
  S03_SIGSMPS.pin = S03_SIGSMPS_PIN;
  S03_SIG1.pin = S03_SIG1_PIN;
  S06_SIG1.pin = S06_SIG1_PIN;
  S06_SIGSMPS.pin = S06_SIGSMPS_PIN;
  S04_SIG1.pin = S04_SIG1_PIN;
  S04_SIG2.pin = S04_SIG2_PIN;
  S04_SIG3.pin = S04_SIG3_PIN;
  S04_SIGSMPS.pin = S04_SIGSMPS_PIN;
  S05_SIGNP.pin = S05_SIGNP_PIN;
  S05_SIG2.pin = S05_SIG2_PIN;
  S05_SIG1.pin = S05_SIG1_PIN;
  S05_SIGSMPS.pin = S05_SIGSMPS_PIN;

  // test
  selected = &all_signals[2];
  Serial.print(selected->pin);

}

void loop() {
  

}


void pinInit() {
  pinMode(LED_S03C_PIN, OUTPUT);
  pinMode(LED_S01_PIN, OUTPUT);
  pinMode(LED_S03_PIN, OUTPUT);
  pinMode(LED_S04_PIN, OUTPUT);
  pinMode(LED_S05_PIN, OUTPUT);
  pinMode(LED_S06_PIN, OUTPUT);
  pinMode(LED_S03D_PIN, OUTPUT);
  pinMode(BUZZER_PIN, OUTPUT);
  pinMode(FREE1_PIN, INPUT);
  pinMode(BUTTON1_PIN, INPUT);
  pinMode(BUTTON2_PIN, INPUT);
  pinMode(BUTTON3_PIN, INPUT);
  pinMode(FREE2_PIN, INPUT);
  pinMode(FREE3_PIN, INPUT);
  pinMode(LED_S03A_PIN, OUTPUT);
  pinMode(LED_S03B_PIN, OUTPUT);
  pinMode(T5V_SIG_PIN, INPUT);
  pinMode(IN_SIG_PIN, INPUT);
  pinMode(S03_SIG4_PIN, INPUT);
  pinMode(S03_SIG3_PIN, INPUT);
  pinMode(S03_SIG2_PIN, INPUT);
  pinMode(S03_SIGSMPS_PIN, INPUT);
  pinMode(S03_SIG1_PIN, INPUT);
  pinMode(S06_SIG1_PIN, INPUT);
  pinMode(S06_SIGSMPS_PIN, INPUT);
  pinMode(LED_PIN, OUTPUT);
  pinMode(S04_SIG1_PIN, INPUT);
  pinMode(S04_SIG2_PIN, INPUT);
  pinMode(S04_SIG3_PIN, INPUT);
  pinMode(S04_SIGSMPS_PIN, INPUT);
  pinMode(S05_SIGNP_PIN, INPUT);
  pinMode(S05_SIG2_PIN, INPUT);
  pinMode(S05_SIG1_PIN, INPUT);
  pinMode(S05_SIGSMPS_PIN, INPUT);
}
