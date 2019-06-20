#include <Arduino.h>
#include <IRremote.h>

#define CHANNEL_UP 0x20DF00FF
#define INPUT_CHANGE 0x20DFD02F
#define SIGNAL_BITS 28

#define SEND_DELAY 1000

IRsend irsend;

void setup() {}

void loop()
{
  // TODO send sequence if button pressed
  irsend.sendLG(CHANNEL_UP, SIGNAL_BITS);
  delay(SEND_DELAY);
  irsend.sendLG(INPUT_CHANGE, SIGNAL_BITS)
}
