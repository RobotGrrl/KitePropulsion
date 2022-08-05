#define NUM_SIGNALS 17  // max count: 256

struct Signal {
  String name;
  uint8_t pin;
  uint16_t val;
  uint16_t prev_val;
  unsigned long long last_read;
};

extern struct Signal *(all_signals[NUM_SIGNALS]);
extern struct Signal *selected;

struct Signal T5V_SIG;
struct Signal IN_SIG;
struct Signal S03_SIG4;
struct Signal S03_SIG3;
struct Signal S03_SIG2;
struct Signal S03_SIGSMPS;
struct Signal S03_SIG1;
struct Signal S06_SIG1;
struct Signal S06_SIGSMPS;
struct Signal S04_SIG1;
struct Signal S04_SIG2;
struct Signal S04_SIG3;
struct Signal S04_SIGSMPS;
struct Signal S05_SIGNP;
struct Signal S05_SIG2;
struct Signal S05_SIG1;
struct Signal S05_SIGSMPS;

String signal_names[] = {
  "Teensy 5V Supply",
  "Battery Input",
  "Stage 3 - Signal 4",
  "Stage 3 - Signal 3",
  "Stage 3 - Signal 2",
  "Stage 3 - Switching",
  "Stage 3 - Signal 1",
  "Stage 6 - Signal 1",
  "Stage 6 - Switching",
  "Stage 4 - Signal 1",
  "Stage 4 - Signal 2",
  "Stage 4 - Signal 3",
  "Stage 4 - Switching",
  "Stage 5 - Neopixels",
  "Stage 5 - Signal 2",
  "Stage 5 - Signal 1",
  "Stage 4 - Switching"
  };

int signal_pins[] = {
  T5V_SIG_PIN,
  IN_SIG_PIN,
  S03_SIG4_PIN,
  S03_SIG3_PIN,
  S03_SIG2_PIN,
  S03_SIGSMPS_PIN,
  S03_SIG1_PIN,
  S06_SIG1_PIN,
  S06_SIGSMPS_PIN,
  S04_SIG1_PIN,
  S04_SIG2_PIN,
  S04_SIG3_PIN,
  S04_SIGSMPS_PIN,
  S05_SIGNP_PIN,
  S05_SIG2_PIN,
  S05_SIG1_PIN,
  S05_SIGSMPS_PIN
};


void initSignals() {

  for(uint8_t i=0; i<NUM_SIGNALS; i++) {
    selected = all_signals[i];
    selected->val = 0;
    selected->prev_val = 0;
    selected->last_read = 0;
  }
  
}


void setSignals() {

  T5V_SIG.pin = signal_pins[0];
  T5V_SIG.name = signal_names[0];
  
  IN_SIG.pin = signal_pins[1];
  IN_SIG.name = signal_names[1];
  
  S03_SIG4.pin = signal_pins[2];
  S03_SIG4.name = signal_names[2];
  
  S03_SIG3.pin = signal_pins[3];
  S03_SIG3.name = signal_names[3];
  
  S03_SIG2.pin = signal_pins[4];
  S03_SIG2.name = signal_names[4];
  
  S03_SIGSMPS.pin = signal_pins[5];
  S03_SIGSMPS.name = signal_names[5];
  
  S03_SIG1.pin = signal_pins[6];
  S03_SIG1.name = signal_names[6];
  
  S06_SIG1.pin = signal_pins[7];
  S06_SIG1.name = signal_names[7];
  
  S06_SIGSMPS.pin = signal_pins[8];
  S06_SIGSMPS.name = signal_names[8];
  
  S04_SIG1.pin = signal_pins[9];
  S04_SIG1.name = signal_names[9];
  
  S04_SIG2.pin = signal_pins[10];
  S04_SIG2.name = signal_names[10];
  
  S04_SIG3.pin = signal_pins[11];
  S04_SIG3.name = signal_names[11];
  
  S04_SIGSMPS.pin = signal_pins[12];
  S04_SIGSMPS.name = signal_names[12];
  
  S05_SIGNP.pin = signal_pins[13];
  S05_SIGNP.name = signal_names[13];
  
  S05_SIG2.pin = signal_pins[14];
  S05_SIG2.name = signal_names[14];
  
  S05_SIG1.pin = signal_pins[15];
  S05_SIG1.name = signal_names[15];
  
  S05_SIGSMPS.pin = signal_pins[16];
  S05_SIGSMPS.name = signal_names[16];

  all_signals[0] = &T5V_SIG;
  all_signals[1] = &IN_SIG;
  all_signals[2] = &S03_SIG4;
  all_signals[3] = &S03_SIG3;
  all_signals[4] = &S03_SIG2;
  all_signals[5] = &S03_SIGSMPS;
  all_signals[6] = &S03_SIG1;
  all_signals[7] = &S06_SIG1;
  all_signals[8] = &S06_SIGSMPS;
  all_signals[9] = &S04_SIG1;
  all_signals[10] = &S04_SIG2;
  all_signals[11] = &S04_SIG3;
  all_signals[12] = &S04_SIGSMPS;
  all_signals[13] = &S05_SIGNP;
  all_signals[14] = &S05_SIG2;
  all_signals[15] = &S05_SIG1;
  all_signals[16] = &S05_SIGSMPS;

}
