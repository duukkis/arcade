using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;

namespace Arcade
{
  public class Player
  {
    public Texture2D PlayerTexture;
    public Vector2 Position;
    public float Speed;
    public int Width
    {
      get { return PlayerTexture.Width; }
    }
    public int Height
    {
      get { return PlayerTexture.Height; }
    }

    public void Initialize(Texture2D texture, Vector2 position)
    {
      PlayerTexture = texture;
      Position = position;
      Speed = 2.0f;
    }

    public void Update()
    {

    }

    public void Draw(SpriteBatch spriteBatch)
    {
      spriteBatch.Draw(PlayerTexture, Position, null, Color.White, 0f, Vector2.Zero, 1f, SpriteEffects.None, 0f);
    }
  }
}
