#include <Arduino.h>
#include <Keyboard.h>

enum Button
{
    LEFT = 2,
    RIGHT = 3,
    UP = 4,
    DOWN = 5,
    RED = 6,
    GREEN = 7,
    BLUE = 8,
};

Button getButton(int pin)
{
    return static_cast<Button>(pin);
}

char getCharacter(Button button)
{
    switch (button)
    {
    case LEFT:
        return 'a';
    case RIGHT:
        return 'd';
    case UP:
        return 'w';
    case DOWN:
        return 's';
    case RED:
        return 'z';
    case GREEN:
        return 'x';
    case BLUE:
        return 'c';
    }
}

void setup()
{
    for (int pin = LEFT; pin <= BLUE; pin++)
    {
        pinMode(pin, INPUT_PULLUP);
        digitalWrite(pin, HIGH);
    }
    Keyboard.begin();
}

void loop()
{
    for (int pin = LEFT; pin <= BLUE; pin++)
    {
        if (digitalRead(pin) == 0)
        {
            Button button = getButton(pin);
            Keyboard.print(getCharacter(button));
        }
    }
    delay(100);
}