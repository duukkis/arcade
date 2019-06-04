#include <Arduino.h>
#include <Keyboard.h>
#include "Switch.h"
#include "ControlPanel.h"

Switch *switches = new Switch[N_SWITCHES]
{
#if defined(PLAYER_1)
    Switch(Joystick::LEFT, 'a'),
    Switch(Joystick::RIGHT, 'd'),
    Switch(Joystick::UP, 'w'),
    Switch(Joystick::DOWN, 's'),
    Switch(Button::RED, 'z'),
    Switch(Button::GREEN, 'x'),
    Switch(Button::BLUE, 'c'),
#elif defined(PLAYER_2)
    Switch(Joystick::LEFT, 'j'),
    Switch(Joystick::RIGHT, 'l'),
    Switch(Joystick::UP, 'i'),
    Switch(Joystick::DOWN, 'k'),
    Switch(Button::RED, 'b'),
    Switch(Button::GREEN, 'n'),
    Switch(Button::BLUE, 'm'),
#elif defined(TOGGLE_PANEL)
    Switch(Toggle::RED, '1'),
    Switch(Toggle::BLUE, '2'),
    Switch(Toggle::GREEN, '3'),
    Switch(Toggle::YELLOW, '4')
#else
#error Must define -DPLAYER_1, -DPLAYER_2 or -DTOGGLE_PANEL
#endif
};

ControlPanel controlPanel(switches);

void setup()
{
    controlPanel.initialize();
}

void loop()
{
    controlPanel.update();
}
