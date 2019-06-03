#include <Arduino.h>
#include <Keyboard.h>
#include "joystick.h"
#include "button.h"

Joystick::Joystick(Button *_buttons)
{
    buttons = _buttons;
}

Joystick::~Joystick()
{
    delete[] buttons;
}

void Joystick::initialize()
{
    for (int i = 0; i < N_BUTTONS; i++)
    {
        buttons[i].initialize();
    }
    Keyboard.begin();
#ifdef DEBUG_SERIAL
    Serial.begin(9600);
#endif
}

void Joystick::update()
{
    for (int i = 0; i < N_BUTTONS; i++)
    {
        buttons[i].update();
    }
    delay(UPDATE_DELAY_MS);
}
