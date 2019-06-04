#pragma once
#include "Switch.h"

#ifdef TOGGLE_PANEL
#define N_SWITCHES 4
#else
#define N_SWITCHES 7
#endif

#define UPDATE_DELAY_MS 1

class ControlPanel
{
private:
    Switch *switches;

public:
    ControlPanel(Switch *switches);
    ~ControlPanel();
    void initialize();
    void update();
};
