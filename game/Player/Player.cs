using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;

namespace Arcade.Entities
{
  public class Player
  {
    public Texture2D PlayerTexture;
    public Vector2 Position;
    public float Speed;
    public float JumpForce;
    public float Gravity;
    public float CurrentVelocityY = 0f;
    public int Width
    {
      get { return PlayerTexture.Width; }
    }
    public int Height
    {
      get { return PlayerTexture.Height; }
    }
    public PlayerControls Controls { get; private set; }
    private bool _isGrounded = false;

    public void Initialize(Texture2D texture, Vector2 position, PlayerControls playerControls)
    {
      Controls = playerControls;
      PlayerTexture = texture;
      Position = position;
      Speed = 2.0f;
      JumpForce = 10f;
      Gravity = 0.5f;
    }

    public void Update(GameTime gameTime)
    {
      if (Position.Y > 400.0f && CurrentVelocityY >= 0f)
      {
        _isGrounded = true;
        CurrentVelocityY = 0f;
      }
      if (!_isGrounded)
      {
        Position.Y += CurrentVelocityY;
        CurrentVelocityY += Gravity;
      }
    }

    public void Draw(SpriteBatch spriteBatch)
    {
      spriteBatch.Draw(PlayerTexture, Position, null, Color.White, 0f, Vector2.Zero, 1f, SpriteEffects.None, 0f);
    }

    public void Action(PlayerActions action) {
      switch(action) {
        case PlayerActions.WALK_RIGHT:
          Position.X += Speed;
          break;
        case PlayerActions.WALK_LEFT:
          Position.X -= Speed;
          break;
        case PlayerActions.JUMP:
          Jump();
          break;
        default:
          break;
      }
    }

    private void Jump() {
      if (_isGrounded)
      {
        _isGrounded = false;
        CurrentVelocityY = -JumpForce;
      }
    }
  }
}
