#include <Arduino.h>
#include <Keyboard.h>

enum Button {
    LEFT = 2,
    RIGHT = 3,
    UP = 4,
    DOWN = 5,
    RED = 6,
    GREEN = 7,
    BLUE = 8,
};

char getCharacter(Button button) {
    switch (button)
    {
        case LEFT: return 'a';
        case RIGHT: return 'd';
        case UP: return 'w';
        case DOWN: return 's';
        case RED: return 'z';
        case GREEN: return 'x';
        case BLUE: return 'c';
    }
}

void setup()
{
    for (int button = LEFT; button <= BLUE; button++)
    {
        pinMode(button, INPUT_PULLUP);
        digitalWrite(button, HIGH);
    }
    Keyboard.begin();
}

void loop()
{
    for (int button = LEFT; button <= BLUE; button++)
    {
        if (digitalRead(button) == 0)
        {
            Keyboard.print(getCharacter(static_cast<Button>(button)));
        }
    }
    delay(100);
}