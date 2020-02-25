using Arcade.GameStates;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;

namespace Arcade
{
  public class Hippa : Game
  {
    private GraphicsDeviceManager graphics;
    private SpriteBatch spriteBatch;

    public Hippa()
    {
      graphics = new GraphicsDeviceManager(this);
      Content.RootDirectory = "Content";
      IsMouseVisible = true;
    }

    protected override void Initialize()
    {
      base.Initialize();
    }

    protected override void LoadContent()
    {
      spriteBatch = new SpriteBatch(GraphicsDevice);
      GameStateManager.Instance.SetContent(Content);
      GameStateManager.Instance.AddScreen(new MatchState(GraphicsDevice));
    }

    protected override void UnloadContent()
    {
      GameStateManager.Instance.UnloadContent();
    }

    protected override void Update(GameTime gameTime)
    {
      if (GamePad.GetState(PlayerIndex.One).Buttons.Back == ButtonState.Pressed || Keyboard.GetState().IsKeyDown(Keys.Escape))
        GameStateManager.Instance.RemoveScreen();

      GameStateManager.Instance.Update(gameTime);
      base.Update(gameTime);
    }

    protected override void Draw(GameTime gameTime)
    {
      GraphicsDevice.Clear(Color.CornflowerBlue);

      GameStateManager.Instance.Draw(spriteBatch);
      base.Draw(gameTime);
    }
  }
}
