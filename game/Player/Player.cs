using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;

namespace Arcade.Entities
{
  public class Player
  {
    private static float Gravity = 0.5f;
    private static float MovementAcceleration = 0.2f;
    private static float StoppingAcceleration = 0.4f;
    private static Vector2 MaximumVelocity = new Vector2(5f, 10f);
    private static float JumpForce = 10f;

    public Texture2D PlayerTexture;
    public Vector2 Position;
    public Vector2 Velocity;
    public Vector2 Acceleration;

    public int Width
    {
      get { return PlayerTexture.Width; }
    }
    public int Height
    {
      get { return PlayerTexture.Height; }
    }
    public bool IsHiding;
    public PlayerControls Controls { get; private set; }
    private bool isGrounded = false;

    public void Initialize(Texture2D texture, Vector2 position, PlayerControls playerControls)
    {
      Controls = playerControls;
      PlayerTexture = texture;
      Position = position;
      Acceleration.Y = Gravity;
      IsHiding = false;
    }

    public void Update(GameTime gameTime)
    {
      if (Position.Y > 400.0f && Velocity.Y >= 0f)
      {
        isGrounded = true;
        Velocity.Y = 0f;
        Acceleration.Y = 0f;
      }
      if (!isGrounded)
      {
        Acceleration.Y = Gravity;
      }
      Velocity.X = GetLimitedVelocity(Velocity.X + Acceleration.X, MaximumVelocity.X);
      Velocity.Y = GetLimitedVelocity(Velocity.Y + Acceleration.Y, MaximumVelocity.Y);
      Position += Velocity;
    }

    private float GetLimitedVelocity(float velocity, float limit) {
      if (velocity >= 0) {
        return MathHelper.Min(velocity, limit);
      } else {
        return MathHelper.Max(velocity, -limit);
      }
    }
    public void Draw(SpriteBatch spriteBatch)
    {
      spriteBatch.Draw(PlayerTexture, Position, null, Color.White, 0f, new Vector2(Width / 2f, Height), 1f, SpriteEffects.None, 0f);
    }

    public void Action(PlayerActions action) {
      switch(action) {
        case PlayerActions.WALK_RIGHT:
          if (Velocity.X <= 0) {
            Acceleration.X = StoppingAcceleration;
          } else {
            Acceleration.X = MovementAcceleration;
          }
          break;
        case PlayerActions.WALK_LEFT:
          if (Velocity.X >= 0) {
            Acceleration.X = -StoppingAcceleration;
          } else {
            Acceleration.X = -MovementAcceleration;
          }
          break;
        case PlayerActions.STOP_WALKING:
          Acceleration.X = 0;
          Velocity.X *= 0.9f;
          break;
        case PlayerActions.JUMP:
          Jump();
          break;
        case PlayerActions.HIDE:
          IsHiding = !IsHiding;
          break;
        default:
          break;
      }
    }

    private void Jump() {
      if (isGrounded)
      {
        isGrounded = false;
        Velocity.Y = -JumpForce;
      }
    }
  }
}
