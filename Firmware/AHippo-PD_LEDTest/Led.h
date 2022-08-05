#define NUM_LEDS 10

struct TheLED {
  uint8_t pin;
  bool on;
  uint8_t mode;
  unsigned long long last_on;
};

extern struct TheLED *(all_leds[NUM_LEDS]);
extern struct TheLED *selected;

struct TheLED LED_S03C;
struct TheLED LED_S01;
struct TheLED LED_S03;
struct TheLED LED_S04;
struct TheLED LED_S05;
struct TheLED LED_S06;
struct TheLED LED_S03D;
struct TheLED LED_S03A;
struct TheLED LED_S03B;
struct TheLED LED_BOARD;

uint16_t led_pins[] = {
  LED_S03C_PIN,
  LED_S01_PIN,
  LED_S03_PIN,
  LED_S04_PIN,
  LED_S05_PIN,
  LED_S06_PIN,
  LED_S03D_PIN,
  LED_S03A_PIN,
  LED_S03B_PIN,
  LED_PIN
  };


void initLeds() {
  for(uint8_t i=0; i<NUM_LEDS; i++) {
    selected = all_leds[i];
    pinMode(selected->pin, OUTPUT);
  }
}


void setLeds() {

  LED_S03C.pin = led_pins[0];
  LED_S01.pin = led_pins[1];
  LED_S03.pin = led_pins[2];
  LED_S04.pin = led_pins[3];
  LED_S05.pin = led_pins[4];
  LED_S06.pin = led_pins[5];
  LED_S03D.pin = led_pins[6];
  LED_S03A.pin = led_pins[7];
  LED_S03B.pin = led_pins[8];
  LED_BOARD.pin = led_pins[9];
  
  all_leds[0] = &LED_S03C;
  all_leds[1] = &LED_S01;
  all_leds[2] = &LED_S03;
  all_leds[3] = &LED_S04;
  all_leds[4] = &LED_S05;
  all_leds[5] = &LED_S06;
  all_leds[6] = &LED_S03D;
  all_leds[7] = &LED_S03A;
  all_leds[8] = &LED_S03B;
  all_leds[9] = &LED_BOARD;

  for(uint8_t i=0; i<NUM_LEDS; i++) {
    selected = all_leds[i];
    selected->on = false;
    selected->mode = 0;
  }
}


void updateLeds() {
  
  for(uint8_t i=0; i<NUM_LEDS; i++) {
    selected = all_leds[i];
    
    switch(selected->mode) {
      case 0: // off
        digitalWrite(selected->pin, LOW);
      break;
      case 1: // on
        digitalWrite(selected->pin, HIGH);
        selected->on = true;
        selected->last_on = millis();
      break;
      case 2: // blink
        if(millis()-selected->last_on >= 100) {
          selected->on = !selected->on;
          selected->last_on = millis();
        }
        if(selected->on) {
          digitalWrite(selected->pin, HIGH);
        } else {
          digitalWrite(selected->pin, LOW); 
        }
      break;
    }
    
  }
  
}
