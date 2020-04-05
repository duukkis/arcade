using Microsoft.Xna.Framework;
using MonoGame.Extended;
using MonoGame.Extended.Collisions;

namespace Hippa.Entities
{
    public class StationaryCollisionObject : ICollisionActor, IUpdate
    {

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
        public IShapeF Bounds { get; }


        public StationaryCollisionObject(Vector2 position)
        {
            Bounds = new RectangleF(Position, new Size2(16, 16));
            Position = position;
        }


        public void OnCollision(CollisionEventArgs collisionInfo)
        {
        }

        public void Update(GameTime gameTime)
        {
        }
    }
}
