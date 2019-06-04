#pragma once

enum class Joystick : int
{
    LEFT = 2,
    RIGHT = 3,
    UP = 4,
    DOWN = 5,
};

enum class Toggle : int
{
    BLUE = 2,
    RED = 3,
    YELLOW = 4,
    GREEN = 5,
};

enum class Button : int
{
    RED = 6,
    GREEN = 7,
    BLUE = 8,
};

class Switch
{
private:
    int pin;
    char character;
    int state;

public:
    Switch(int pin, char character);
    Switch(Joystick pin, char character) : Switch(static_cast<int>(pin), character) {};
    Switch(Toggle pin, char character) : Switch(static_cast<int>(pin), character) {};
    Switch(Button pin, char character) : Switch(static_cast<int>(pin), character) {};
    void initialize();
    void update();
};
