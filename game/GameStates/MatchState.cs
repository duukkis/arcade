using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Graphics;

namespace Arcade.GameStates
{
  public class MatchState : GameState
  {
    public Player PlayerOne;
    public Player PlayerTwo;
    private GraphicsDevice graphicsDevice;

    public MatchState(GraphicsDevice graphicsDevice) : base(graphicsDevice)
    {
      this.graphicsDevice = graphicsDevice;
    }

    public override void Initialize()
    {
      PlayerOne = new Player();
      PlayerTwo = new Player();
    }

    public override void LoadContent(ContentManager content)
    {
      Vector2 playerOnePosition = new Vector2(graphicsDevice.Viewport.TitleSafeArea.X, graphicsDevice.Viewport.TitleSafeArea.Y + graphicsDevice.Viewport.TitleSafeArea.Height / 2);
      Vector2 playerTwoPosition = new Vector2(graphicsDevice.Viewport.TitleSafeArea.X + 200, graphicsDevice.Viewport.TitleSafeArea.Y + graphicsDevice.Viewport.TitleSafeArea.Height / 2);
      PlayerOne.Initialize(content.Load<Texture2D>("player1"), playerOnePosition);
      PlayerTwo.Initialize(content.Load<Texture2D>("player2"), playerTwoPosition);
    }

    public override void UnloadContent()
    {

    }

    public override void Update(GameTime gameTime)
    {

    }

    public override void Draw(SpriteBatch spriteBatch)
    {
      graphicsDevice.Clear(Color.Black);
      spriteBatch.Begin();
      PlayerOne.Draw(spriteBatch);
      PlayerTwo.Draw(spriteBatch);
      spriteBatch.End();
    }
  }
}
