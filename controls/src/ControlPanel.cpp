#include <Arduino.h>
#include <Keyboard.h>
#include "ControlPanel.h"
#include "Switch.h"

ControlPanel::ControlPanel(Switch *_switches)
{
    switches = _switches;
}

ControlPanel::~ControlPanel()
{
    delete[] switches;
}

void ControlPanel::initialize()
{
    for (int i = 0; i < N_SWITCHES; i++)
    {
        switches[i].initialize();
    }
    Keyboard.begin();
#ifdef DEBUG_SERIAL
    Serial.begin(9600);
#endif
}

void ControlPanel::update()
{
    for (int i = 0; i < N_SWITCHES; i++)
    {
        switches[i].update();
    }
    delay(UPDATE_DELAY_MS);
}
