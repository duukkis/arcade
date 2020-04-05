using System.Collections.Generic;
using System.Linq;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;

namespace Hippa.Entities
{
    public interface IEntityManager
    {
        T AddEntity<T>(T entity) where T : Entity;
    }

    public class EntityManager : IEntityManager
    {
        private readonly List<Entity> entities;
        public IEnumerable<Entity> Entities => entities;

        public EntityManager()
        {
            entities = new List<Entity>();
        }

        public T AddEntity<T>(T entity) where T : Entity
        {
            entities.Add(entity);
            return entity;
        }

        public void Update(GameTime gameTime)
        {
            foreach (var entity in entities.Where(e => !e.IsDestroyed))
            {
                entity.Update(gameTime);
            }

            entities.RemoveAll(e => e.IsDestroyed);
        }

        public void Draw(SpriteBatch spriteBatch)
        {
            foreach (var entity in entities.Where(e => !e.IsDestroyed))
            {
                entity.Draw(spriteBatch);
            }
        }
    }
}
