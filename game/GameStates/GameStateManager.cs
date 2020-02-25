using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Graphics;
using System;
using System.Collections.Generic;

namespace Arcade.GameStates
{
  public class GameStateManager
  {

    private static GameStateManager instance;

    private Stack<GameState> screens = new Stack<GameState>();
    private ContentManager content;

    public static GameStateManager Instance
    {
      get
      {
        if (instance == null)
        {
          instance = new GameStateManager();
        }
        return instance;
      }
    }

    public void SetContent(ContentManager content)
    {
      this.content = content;
    }

    // Adds a new screen to the stack 
    public void AddScreen(GameState screen)
    {
      try
      {
        screens.Push(screen);
        screens.Peek().Initialize();
        if (content != null)
        {
          screens.Peek().LoadContent(content);
        }
      }
      catch (Exception ex)
      {
        Console.WriteLine(ex);
      }
    }

    // Removes the top screen from the stack
    public void RemoveScreen()
    {
      if (screens.Count > 0)
      {
        try
        {
          screens.Pop();
        }
        catch (Exception ex)
        {
          Console.WriteLine(ex);
        }
      }
    }

    // Removes all screens from the stack
    public void ClearScreens()
    {
      while (screens.Count > 0)
      {
        screens.Pop();
      }
    }

    // Removes all screens from the stack and adds a new one 
    public void ChangeScreen(GameState screen)
    {
      try
      {
        ClearScreens();
        AddScreen(screen);
      }
      catch (Exception ex)
      {
        Console.WriteLine(ex);
      }
    }

    // Updates the top screen. 
    public void Update(GameTime gameTime)
    {
      try
      {
        if (screens.Count > 0)
        {
          screens.Peek().Update(gameTime);
        }
      }
      catch (Exception ex)
      {
        Console.WriteLine(ex);
      }
    }

    // Renders the top screen.
    public void Draw(SpriteBatch spriteBatch)
    {
      try
      {
        if (screens.Count > 0)
        {
          screens.Peek().Draw(spriteBatch);
        }
      }
      catch (Exception ex)
      {
        Console.WriteLine(ex);
      }
    }

    // Unloads the content from the screens
    public void UnloadContent()
    {
      foreach (GameState state in screens)
      {
        state.UnloadContent();
      }
    }
  }
}
