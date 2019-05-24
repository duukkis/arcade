#include <Arduino.h>
#include <Keyboard.h>

class Button
{
public:
    enum Pin
    {
        LEFT = 2,
        RIGHT = 3,
        UP = 4,
        DOWN = 5,
        RED = 6,
        GREEN = 7,
        BLUE = 8,
    };

    Button(Button::Pin _pin, char _character)
    {
        pin = static_cast<int>(_pin);
        character = _character;
        state = HIGH;
    }

    void initialize()
    {
        pinMode(pin, INPUT_PULLUP);
        digitalWrite(pin, state);
    }

    void update()
    {
        int newState = digitalRead(pin);

        if (newState == state)
        {
            return;
        }

        if (newState == LOW)
        {
            Keyboard.press(character);
        }
        else
        {
            Keyboard.release(character);
        }

        state = newState;
    }

private:
    int pin;
    char character;
    int state;
};

class Joystick
{
public:
    Joystick()
    {
        buttons = new Button[N_BUTTONS] {
            Button(Button::LEFT, 'a'),
            Button(Button::RIGHT, 'd'),
            Button(Button::UP, 'w'),
            Button(Button::DOWN, 's'),
            Button(Button::RED, 'z'),
            Button(Button::GREEN, 'x'),
            Button(Button::BLUE, 'c')
        };
    }

    ~Joystick()
    {
        if (buttons)
        {
            delete[] buttons;
        }
    }

    void initialize()
    {
        for (int i = 0; i <= N_BUTTONS ; i++)
        {
            buttons[i].initialize();
        }
    }

    void update()
    {
        for (int i = 0; i <= N_BUTTONS ; i++)
        {
            buttons[i].update();
        }
    }

private:
    static const int N_BUTTONS = 7;
    Button *buttons;
};

Joystick joystick;

void setup()
{
    joystick.initialize();
    Keyboard.begin();
}

void loop()
{
    joystick.update();
    delay(10);
}

