#include <Arduino.h>
#include <Keyboard.h>
#include "Switch.h"

Switch::Switch(int _pin, char _character)
{
    pin = _pin;
    character = _character;
    state = HIGH;
}

void Switch::initialize()
{
    pinMode(pin, INPUT_PULLUP);
    digitalWrite(pin, state);
}

void Switch::update()
{
    int newState = digitalRead(pin);

    if (newState == state)
    {
        return;
    }

#ifdef DEBUG_SERIAL
    Serial.println(String(character) + ": " + String(state));
#endif

    if (newState == LOW)
    {
        Keyboard.press(character);
    }
    else
    {
        Keyboard.release(character);
    }

    state = newState;
}
