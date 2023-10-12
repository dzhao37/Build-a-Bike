// https://arduinogetstarted.com/tutorials/arduino-joystick
// https://howtomechatronics.com/tutorials/arduino/how-to-control-ws2812b-individually-addressable-leds-using-arduino/



// initialize LED library and strip properties
#include <FastLED.h>

#define LED_PIN 3
#define NUM_LEDS 60
#define BRIGHTNESS 64
#define LED_TYPE WS2811
#define COLOR_ORDER GRB

// global variables to control how many LEDs are on
int leds_activated;
int times_run = 0;

// array to control each LED and other LED strip initialization
CRGB leds[NUM_LEDS];
#define UPDATES_PER_SECOND 100

CRGBPalette16 currentPalette;
TBlendType currentBlending;

extern CRGBPalette16 myRedWhiteBluePalette;
extern const TProgmemPalette16 myRedWhiteBluePalette_p PROGMEM;


// assign motor and button pins
const int buttonPin = 13;
const int frontMotorPin = 10;
const int backMotorPin = 9;


// global variables to control button presses, outputs, timing, and score
int buttonState;
int timesButtonPushed = 0;
int column = 0;
int score = 1;

bool choosing_mission = false;
bool started = false;
bool choosing_selection = false;
bool complete_selection = false;
bool fireworks = false;
bool result = false;

// time variables to do things while delaying
unsigned long lastJoystickReading, lastMotorOn, timeNow;



void setup() {
  // set up button and motor
  pinMode(buttonPin, INPUT_PULLUP);
  pinMode(frontMotorPin, OUTPUT);
  pinMode(backMotorPin, OUTPUT);


  // set up LED strip
  FastLED.addLeds<LED_TYPE, LED_PIN, COLOR_ORDER>(leds, NUM_LEDS).setCorrection(TypicalLEDStrip);
  FastLED.setBrightness(BRIGHTNESS);

  currentPalette = RainbowColors_p;
  currentBlending = LINEARBLEND;

  FastLED.clear();
  FastLED.show();


  // initliaize serial monitor
  Serial.begin(9600);
  Serial.println("showing title screen");
}



void loop() {
  // if the introduction + directions have been read, run the following code
  if (started) {  // selection and result code
    // if the bike is being chosing, activate the joystick
    if (choosing_selection) {
      // joystick code; read analog pins and print the direction to the serial monitor
      // to communicate with Processing and display the corresponding the screen output
      if (analogRead(A2) < 30) {
        Serial.println("Right");
        Serial.println("Stop");
        delay(300);

        // check to see if a selection has been made in all 3 columns
        // read the column data sent from Processing
        if (Serial.available()) {
          column = Serial.read();
        }

        // if the user has moved to column 2, a complete selection has been made
        if (column == 2) {
          complete_selection = true;
        }
      } else if (analogRead(A3) < 30) {
        Serial.println("Left");
        Serial.println("Stop");
        delay(300);
      } else if (analogRead(A4) < 30) {
        Serial.println("Up");
        Serial.println("Stop");
        delay(150);
      } else if (analogRead(A5) < 30) {
        Serial.println("Down");
        Serial.println("Stop");
        delay(150);
      } else {
        Serial.println("Stop");
      }

      // 200 ms while loop delay that simultaneously checks if the submit button is pressed
      lastJoystickReading = millis();
      timeNow = millis();
      while (timeNow - lastJoystickReading < 200) {
        // only allow a submission if the user has gone through all 3 columns
        if (complete_selection) {
          buttonState = digitalRead(buttonPin);

          // if the submit button is pressed, activate the output and deactivate the joystick
          if (buttonState == LOW) {
            // tell processing to play pipe sound effect
            Serial.println("pipe");
            Serial.println("stop");
            delay(700);

            fireworks = true;
            choosing_selection = false;
          }
        }

        timeNow = millis();
      }
    }



    // if the submit button has been pressed, play sound effects + music,
    // turn on motors, and turn on LED strip
    if (fireworks) {
      // tell Processing to display chosen bike and play the corresponding music
      Serial.println("result");
      Serial.println("stop");
      delay(2000);


      // tell Processing to calculate the score and display the corresponding mission result
      Serial.println("display mission result");
      Serial.println("stop");
      delay(4000);


      // read the score data sent from Processing
      if (Serial.available()) {
        score = Serial.read();
      }
      Serial.println(score);

      // the score is divided into 3 buckets: low (0 - 15), medium (16 - 20),
      // high (21+); control the fireworks output based on the score; the higher
      // the score the more intense the outputs
      if (score < 16) {  // low score output
        // tell Processing to play the mario die sound effect
        Serial.println("mario die");
        Serial.println("Stop");


        // turn on motors to the lowest of the 3 power levels
        analogWrite(frontMotorPin, 200);
        analogWrite(backMotorPin, 200);


        // turn on a third of the LEDs
        leds_activated = 20;
        // create a simple blue LED display, most basic LED output;
        // starts with all off, then slowly all 20 turn on
        for (int i = 0; i < leds_activated; i++) {
          leds[i] = CRGB::Blue;
          FastLED.show();
          delay(250);
        }

        // display entire low output for 7.5s
        delay(2500);

      } else if (score < 21) {  // medium score output
        // tell Processing to play power up sound effect
        Serial.println("power up");
        Serial.println("stop");


        // turn on motors to the middle of the 3 power levels
        analogWrite(frontMotorPin, 230);
        analogWrite(backMotorPin, 230);


        // start with 1 LED on
        leds_activated = 1;
        // 10s while loop delay that simultaneously keeps the motor on and
        // displays medium intensity LED output (display entire medium output for 10s)
        lastMotorOn = millis();
        timeNow = millis();
        while (timeNow - lastMotorOn < 10000) {
          // variable that records how many times the while loop runs
          // used to increase the number of LEDs turned on
          times_run++;

          // slowly turn more LEDs on and cap the number of LEDs on at 40
          if (leds_activated < 40) {
            leds_activated = round(times_run / 15);
          }

          // fancy LED code from online
          static uint8_t startIndex = 0;
          startIndex = startIndex + 1; /* motion speed */
          FillLEDsFromPaletteColors(startIndex);
          FastLED.show();
          FastLED.delay(1000 / UPDATES_PER_SECOND);

          timeNow = millis();
        }

      } else if (score >= 21) {  // high score output
        // tell Processing to play Shooting Star sound effect
        Serial.println("Shooting Star");
        Serial.println("Stop");


        // turn the motors on full speed
        analogWrite(frontMotorPin, 255);
        analogWrite(backMotorPin, 255);


        // start with 1 LED on
        leds_activated = 1;
        // 15s while loop delay that simultaneously keeps the motor on and
        // displays high intensity LED output (display entire medium output for 15s)
        lastMotorOn = millis();
        timeNow = millis();
        while (timeNow - lastMotorOn < 15000) {
          // variable that records how many times the while loop runs
          // used to increase the number of LEDs turned on
          times_run++;

          // quickly turn more LEDs on and cap the number of LEDs on at 60
          if (leds_activated < 60) {
            leds_activated = round(times_run / 7);
          }

          // fancy LED code from online
          ChangePalettePeriodically();
          static uint8_t startIndex = 0;
          startIndex = startIndex + 1; /* motion speed */
          FillLEDsFromPaletteColors(startIndex);
          FastLED.show();
          FastLED.delay(1000 / UPDATES_PER_SECOND);

          timeNow = millis();
        }
      }


      // turn off motors
      analogWrite(frontMotorPin, 0);
      analogWrite(backMotorPin, 0);

      // turn off LED strip
      FastLED.clear();
      FastLED.show();

      // reset the output
      fireworks = false;
      result = true;
    }



    // if the results have been displayed run the following code
    if (result) {
      buttonState = digitalRead(buttonPin);
      if (buttonState == LOW) {
        // tell Processing to play the coin sound effect
        Serial.println("coin");
        Serial.println("stop");

        // deactivate selection and result code, activate introduction
        // code, and reset global variables
        result = false;
        started = false;
        complete_selection = false;
        timesButtonPushed = 0;
        times_run = 0;
        column = 0;

        // tell Processing to display the start screen and play music
        Serial.println("reset");
        Serial.println("stop");

        delay(700);
      }
    }

  } else {  // introduction code
    // joystick mission select; read analog pins and print the direction to the serial monitor
    // to communicate with Processing and display the corresponding the screen output
    if (choosing_mission) {
      if (analogRead(A2) < 30) {
        Serial.println("Right");
        Serial.println("Stop");
        delay(300);
      } else if (analogRead(A3) < 30) {
        Serial.println("Left");
        Serial.println("Stop");
        delay(300);
      } else {
        Serial.println("Stop");


        // 100 ms while loop delay that simultaenously checks if the button is pressed
        lastJoystickReading = millis();
        timeNow = millis();
        while (timeNow - lastJoystickReading < 100) {
          buttonState = digitalRead(buttonPin);
          if (buttonState == LOW) {
            // tell Processing to play the coin sound effect
            Serial.println("coin");
            Serial.println("stop");

            // deactivate joystick mission select
            choosing_mission = false;
            timesButtonPushed++;
            Serial.println("show mission");
            delay(700);
          }
          timeNow = millis();
        }
      }
    } else {
      buttonState = digitalRead(buttonPin);
      if (buttonState == LOW) {
        // tell Processing to play the coin sound effect every time the button is pressed
        Serial.println("coin");
        Serial.println("stop");

        // using the timeButtonPushed counter, display the introduction screens in
        // the order: start, mission select, mission, directions, and finally selection
        if (timesButtonPushed == 0) {
          // activate joystick to select mission
          choosing_mission = true;
          timesButtonPushed++;
          // tell Processing to display the corresponding screen and sound effects
          Serial.println("show mission select");
          Serial.println("stop");
          delay(700);
        } 
        else if (timesButtonPushed == 2) {
          timesButtonPushed++;
          // tell Processing to display the corresponding screen and sound effects
          Serial.println("show directions");
          Serial.println("stop");
          delay(700);
        } else if (timesButtonPushed == 3) {
          // activate selection and result code
          started = true;
          // activate joystick to select bike
          choosing_selection = true;
          // tell Processing to display the corresponding screen and sound effects
          Serial.println("begin selection");
          Serial.println("stop");
          delay(700);
        }
      }
    }
  }
}

//------------------------------------------------------------------------------------------------

// LED strip functions
void FillLEDsFromPaletteColors(uint8_t colorIndex) {
  uint8_t brightness = 255;

  for (int i = leds_activated - 1; i >= 0; i--) {
    leds[i] = ColorFromPalette(currentPalette, colorIndex, brightness, currentBlending);
    colorIndex += 3;
  }
}

void ChangePalettePeriodically() {
  uint8_t secondHand = (millis() / 1000) % 60;
  static uint8_t lastSecond = 99;

  if (lastSecond != secondHand) {
    lastSecond = secondHand;
    if (secondHand == 0) {
      currentPalette = RainbowColors_p;
      currentBlending = LINEARBLEND;
    }
    if (secondHand == 10) {
      currentPalette = RainbowStripeColors_p;
      currentBlending = NOBLEND;
    }
    if (secondHand == 15) {
      currentPalette = RainbowStripeColors_p;
      currentBlending = LINEARBLEND;
    }
    if (secondHand == 20) {
      SetupPurpleAndGreenPalette();
      currentBlending = LINEARBLEND;
    }
    if (secondHand == 25) {
      SetupTotallyRandomPalette();
      currentBlending = LINEARBLEND;
    }
    if (secondHand == 30) {
      SetupBlackAndWhiteStripedPalette();
      currentBlending = NOBLEND;
    }
    if (secondHand == 35) {
      SetupBlackAndWhiteStripedPalette();
      currentBlending = LINEARBLEND;
    }
    if (secondHand == 40) {
      currentPalette = CloudColors_p;
      currentBlending = LINEARBLEND;
    }
    if (secondHand == 45) {
      currentPalette = PartyColors_p;
      currentBlending = LINEARBLEND;
    }
    if (secondHand == 50) {
      currentPalette = myRedWhiteBluePalette_p;
      currentBlending = NOBLEND;
    }
    if (secondHand == 55) {
      currentPalette = myRedWhiteBluePalette_p;
      currentBlending = LINEARBLEND;
    }
  }
}

// This function fills the palette with totally random colors.
void SetupTotallyRandomPalette() {
  for (int i = 0; i < 16; i++) {
    currentPalette[i] = CHSV(random8(), 255, random8());
  }
}

// This function sets up a palette of black and white stripes,
// using code.  Since the palette is effectively an array of
// sixteen CRGB colors, the various fill_* functions can be used
// to set them up.
void SetupBlackAndWhiteStripedPalette() {
  // 'black out' all 16 palette entries...
  fill_solid(currentPalette, 16, CRGB::Black);
  // and set every fourth one to white.
  currentPalette[0] = CRGB::White;
  currentPalette[4] = CRGB::White;
  currentPalette[8] = CRGB::White;
  currentPalette[12] = CRGB::White;
}

// This function sets up a palette of purple and green stripes.
void SetupPurpleAndGreenPalette() {
  CRGB purple = CHSV(HUE_PURPLE, 255, 255);
  CRGB green = CHSV(HUE_GREEN, 255, 255);
  CRGB black = CRGB::Black;

  currentPalette = CRGBPalette16(
    green, green, black, black,
    purple, purple, black, black,
    green, green, black, black,
    purple, purple, black, black);
}


// This example shows how to set up a static color palette
// which is stored in PROGMEM (flash), which is almost always more
// plentiful than RAM.  A static PROGMEM palette like this
// takes up 64 bytes of flash.
const TProgmemPalette16 myRedWhiteBluePalette_p PROGMEM = {
  CRGB::Red,
  CRGB::Gray,  // 'white' is too bright compared to red and blue
  CRGB::Blue,
  CRGB::Black,

  CRGB::Red,
  CRGB::Gray,
  CRGB::Blue,
  CRGB::Black,

  CRGB::Red,
  CRGB::Red,
  CRGB::Gray,
  CRGB::Gray,
  CRGB::Blue,
  CRGB::Blue,
  CRGB::Black,
  CRGB::Black
};