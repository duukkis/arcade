using System;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using MonoGame.Extended;
using MonoGame.Extended.Collisions;
using MonoGame.Extended.Sprites;

namespace Hippa.Entities.Player
{
    public class Player : Entity, ICollisionActor, IUpdate
    {
        private static float Gravity = 0.5f;
        private static float MovementAcceleration = 0.2f;
        private static float StoppingAcceleration = 0.4f;
        private static Vector2 MaximumVelocity = new Vector2(5f, 10f);
        private static float JumpForce = 10f;

        public Sprite Sprite;

        private Vector2 pos;

        public Vector2 Position
        {
            get => pos;
            set
            {
                pos = value;
                Bounds.Position = value;
            }
        }

        public Vector2 Velocity;
        public Vector2 Acceleration;

        public IShapeF Bounds { get; set; }

        public bool IsHiding;
        public PlayerControls Controls { get; private set; }
        private bool isGrounded = false;

        public void Initialize(Texture2D texture, Vector2 position, PlayerControls playerControls)
        {
            Controls = playerControls;
            Sprite = new Sprite(texture);
            Bounds = Sprite.GetBoundingRectangle(Position, 0, Vector2.One);
            Position = position;
            Acceleration.Y = Gravity;
            IsHiding = false;
        }

        public override void Update(GameTime gameTime)
        {

            if (!isGrounded)
            {
                Acceleration.Y = Gravity;
            }

            Velocity.X = GetLimitedVelocity(Velocity.X + Acceleration.X, MaximumVelocity.X);
            Velocity.Y = GetLimitedVelocity(Velocity.Y + Acceleration.Y, MaximumVelocity.Y);
            Position += Velocity;

            HandleControls();
        }


        private void HandleControls()
        {
            var keyboardState = Keyboard.GetState();
            if (keyboardState.IsKeyDown(Controls.Right))
            {
                Acceleration.X = Velocity.X <= 0 ? StoppingAcceleration : MovementAcceleration;
            }
            else if (keyboardState.IsKeyDown(Controls.Left))
            {
                Acceleration.X = Velocity.X >= 0 ? -StoppingAcceleration : -MovementAcceleration;
            }
            else
            {
                Acceleration.X = 0;
                Velocity.X *= 0.9f;
            }

            if (keyboardState.IsKeyDown(Controls.Jump))
            {
                Jump();
            }

            if (keyboardState.IsKeyDown(Controls.Hide))
            {
                IsHiding = !IsHiding;
            }
        }

        private float GetLimitedVelocity(float velocity, float limit)
        {
            if (velocity >= 0)
            {
                return MathHelper.Min(velocity, limit);
            }
            else
            {
                return MathHelper.Max(velocity, -limit);
            }
        }

        public override void Draw(SpriteBatch spriteBatch)
        {
            Sprite.Draw(spriteBatch, Position, 0, Vector2.One);
        }


        private void Jump()
        {
            if (isGrounded)
            {
                isGrounded = false;
                Velocity.Y = -JumpForce;
            }
        }

        public void OnCollision(CollisionEventArgs collisionInfo)
        {
            if (collisionInfo.Other.GetType() == typeof(StationaryCollisionObject))
            {
                if (collisionInfo.PenetrationVector.Y > 0) {
                    isGrounded = true;
                    Acceleration.Y = 0f;
                    Position -= collisionInfo.PenetrationVector;
                }
                
            }

        }
    }
}
