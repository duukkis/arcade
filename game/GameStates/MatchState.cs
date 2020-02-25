using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Graphics;

namespace Arcade.GameStates
{
  public class MatchState : GameState
  {

    public MatchState(GraphicsDevice graphicsDevice) : base(graphicsDevice)
    {

    }
    public override void Initialize()
    {

    }

    public override void LoadContent(ContentManager content)
    {

    }

    public override void UnloadContent()
    {

    }

    public override void Update(GameTime gameTime)
    {

    }

    public override void Draw(SpriteBatch spriteBatch)
    {
      _graphicsDevice.Clear(Color.Black);
      spriteBatch.Begin();
      spriteBatch.End();
    }
  }
}
