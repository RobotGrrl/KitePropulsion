/*
 * Hippo-PD Display Test
 * ----------------------
 * Test the OLED display (128 x 64) for Hippo-PD
 * Connected to I2C on Teensy 3.6
 * Aug. 3, 2022
 */

#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 64 // OLED display height, in pixels

// Declaration for an SSD1306 display connected to I2C (SDA, SCL pins)
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, -1);

// -----
struct Signal {
  String name;
  uint8_t pin;
  uint16_t val;
  uint16_t prev_val;
  unsigned long long last_read;
};

Signal test1;
Signal test2;

long last_change = 0;
uint8_t page_index = 0;
// -----

void setup() {
  Serial.begin(9600);

  test1.name = "Bat Signal";
  test1.val = 3000;
  test2.name = "Fish Signal";
  test2.val = 500;

  if(!display.begin(SSD1306_SWITCHCAPVCC, 0x3C)) { // Address 0x3D for 128x64
    Serial.println(F("SSD1306 allocation failed"));
    for(;;);
  }
  delay(2000);
  display.clearDisplay();

  display.setTextSize(1);
  display.setTextColor(WHITE);
  display.setCursor(0, 10);
  // Display static text
  display.println("Hello, world!");
  display.display();

  display.clearDisplay();
  
}

void loop() {

  if(millis()-last_change >= 2000) {

    display.clearDisplay();

    display.setTextSize(1);
    display.setTextColor(WHITE);
    display.setCursor(0, 0);

    switch(page_index) {
      case 0:
        display.println(test1.name);
      break;
      case 1:
        display.println(test2.name);
      break;
    }

    display.setCursor(40, 30);
    display.setTextSize(5);
    display.setTextColor(WHITE);

    switch(page_index) {
      case 0:
        display.println(test1.val);
      break;
      case 1:
        display.println(test2.val);
      break;
    }

    display.display();

    page_index++;
    if(page_index > 1) page_index = 0;
    last_change = millis();
  }
  
}
