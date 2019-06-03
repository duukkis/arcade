#include <Arduino.h>
#include <Keyboard.h>
#include "button.h"
#include "joystick.h"

Button *buttons = new Button[N_BUTTONS]
{
#if defined(PLAYER_1)
    Button(Button::LEFT, 'a'),
    Button(Button::RIGHT, 'd'),
    Button(Button::UP, 'w'),
    Button(Button::DOWN, 's'),
    Button(Button::RED, 'z'),
    Button(Button::GREEN, 'x'),
    Button(Button::BLUE, 'c'),
#elif defined(PLAYER_2)
    Button(Button::LEFT, 'j'),
    Button(Button::RIGHT, 'l'),
    Button(Button::UP, 'i'),
    Button(Button::DOWN, 'k'),
    Button(Button::RED, 'b'),
    Button(Button::GREEN, 'n'),
    Button(Button::BLUE, 'm'),
#else
#error Must define -DPLAYER_1 or -DPLAYER_2
#endif
};

Joystick joystick(buttons);

void setup()
{
    joystick.initialize();
}

void loop()
{
    joystick.update();
}
