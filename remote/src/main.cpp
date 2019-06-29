#include <Arduino.h>
#include <IRremote.h>

IRsend irsend;

unsigned int powerToggle = 0x20;
unsigned int intputNext = 0x82A;
unsigned int volumeUp = 0x24;
unsigned int volumeDown = 0x825;

unsigned int inputs[2][2] = {
    {2, 3},
    {powerToggle, intputNext}
};

void setup()
{
  for (size_t button = 0; button < (sizeof inputs[0] / sizeof(int)); button++)
  {
    pinMode(inputs[0][button], INPUT_PULLUP);
  }
}

void loop()
{
  for (size_t button = 0; button < (sizeof inputs[0] / sizeof(int)); button++)
  {
    if (digitalRead(inputs[0][button]) == LOW)
    {
      irsend.sendRC5(inputs[1][button], 12);
      delay(500);
    }
  }
}
