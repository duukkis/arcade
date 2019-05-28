#include <Arduino.h>
#include <Keyboard.h>

#define N_BUTTONS 7

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
    Joystick(Button* _buttons)
    {
        buttons = _buttons;
    }

    ~Joystick()
    {
        delete[] buttons;
    }

    void initialize()
    {
        for (int i = 0; i <= N_BUTTONS ; i++)
        {
            buttons[i].initialize();
        }
        Keyboard.begin();
    }

    void update()
    {
        for (int i = 0; i <= N_BUTTONS ; i++)
        {
            buttons[i].update();
        }
    }

private:
    Button *buttons;
};

#if defined(PLAYER_1)
    Joystick joystick(new Button[N_BUTTONS] {
        Button(Button::LEFT, 'a'),
        Button(Button::RIGHT, 'd'),
        Button(Button::UP, 'w'),
        Button(Button::DOWN, 's'),
        Button(Button::RED, 'z'),
        Button(Button::GREEN, 'x'),
        Button(Button::BLUE, 'c')
    });
#elif defined(PLAYER_2)
    Joystick joystick(new Button[N_BUTTONS] {
        Button(Button::LEFT, 'j'),
        Button(Button::RIGHT, 'l'),
        Button(Button::UP, 'i'),
        Button(Button::DOWN, 'k'),
        Button(Button::RED, 'b'),
        Button(Button::GREEN, 'n'),
        Button(Button::BLUE, 'm')
    });
#else
    #error Must define -DPLAYER_1 or -DPLAYER_2
#endif

void setup()
{
    joystick.initialize();
}

void loop()
{
    joystick.update();
}
