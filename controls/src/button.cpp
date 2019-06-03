#include <Arduino.h>
#include <Keyboard.h>
#include "button.h"

Button::Button(Button::Pin _pin, char _character)
{
    pin = static_cast<int>(_pin);
    character = _character;
    state = HIGH;
}

void Button::initialize()
{
    pinMode(pin, INPUT_PULLUP);
    digitalWrite(pin, state);
}

void Button::update()
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
