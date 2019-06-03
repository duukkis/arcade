#pragma once
class Button
{
private:
    int pin;
    char character;
    int state;

public:
    enum Pin : int
    {
        LEFT = 2,
        RIGHT = 3,
        UP = 4,
        DOWN = 5,
        RED = 6,
        GREEN = 7,
        BLUE = 8,
    };
    Button(Button::Pin _pin, char _character);
    void initialize();
    void update();
};
