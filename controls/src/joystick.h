#pragma once
#include "button.h"

#define N_BUTTONS 7
#define UPDATE_DELAY_MS 1

class Joystick
{
private:
    Button* buttons;
public:
    Joystick(Button* _buttons);
    ~Joystick();
    void initialize();
    void update();
};
