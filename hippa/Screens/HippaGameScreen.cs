using System.Collections.Generic;
using System.Linq;
using Hippa.Entities;
using Hippa.Entities.Player;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using MonoGame.Extended;
using MonoGame.Extended.Collisions;
using MonoGame.Extended.Input;
using MonoGame.Extended.Screens;
using MonoGame.Extended.Screens.Transitions;
using MonoGame.Extended.Tiled;
using MonoGame.Extended.Tiled.Renderers;

namespace Hippa.Screens
{
    public class HippaGameScreen : GameScreen
    {
        private SpriteBatch spriteBatch;
        private Texture2D lightMask;
        private Effect lightEffect;
        private RenderTarget2D lightsRenderTarget;
        private RenderTarget2D mainRenderTarget;
        private TiledMap map;
        private TiledMapRenderer mapRenderer;
        private OrthographicCamera camera;

        private EntityManager entityManager;
        private CollisionComponent collisionComponent;

        public Player PlayerOne;
        public Player PlayerTwo;

        public List<StationaryCollisionObject> StationaryCollisionObjects = new List<StationaryCollisionObject>();
        public int ScreenWidth => GraphicsDevice.Viewport.Width;
        public int ScreenHeight => GraphicsDevice.Viewport.Height;

        public HippaGameScreen(Game game) : base(game)
        {
        }

        public override void Initialize()
        {
            base.Initialize();
            camera = new OrthographicCamera(GraphicsDevice);
            spriteBatch = new SpriteBatch(GraphicsDevice);
            entityManager = new EntityManager();
        }

        public override void LoadContent()
        {
            base.LoadContent();
            PresentationParameters pp = GraphicsDevice.PresentationParameters;
            lightsRenderTarget = new RenderTarget2D(GraphicsDevice, pp.BackBufferWidth, pp.BackBufferHeight);
            mainRenderTarget = new RenderTarget2D(GraphicsDevice, pp.BackBufferWidth, pp.BackBufferHeight);
            lightMask = Content.Load<Texture2D>("lightmask");
            lightEffect = Content.Load<Effect>("lighteffect");

            map = Content.Load<TiledMap>("map");
            mapRenderer = new TiledMapRenderer(GraphicsDevice, map);

            collisionComponent = new CollisionComponent(new RectangleF(-10000, -5000, 20000, 10000));

            var nonBlankTiles = map.TileLayers.FirstOrDefault()?.Tiles.Where(tile => !tile.IsBlank);
            if (nonBlankTiles != null)
            {
                foreach (var mapTile in nonBlankTiles)
                {
                    var stationaryCollisionObject =
                        new StationaryCollisionObject(new Vector2((mapTile.X + 1) * map.TileWidth , (mapTile.Y+1) * map.TileWidth));
                    collisionComponent.Insert(stationaryCollisionObject);
                    StationaryCollisionObjects.Add(stationaryCollisionObject);
                }
            }
                

            SpawnPlayers();
        }

        private void SpawnPlayers()
        {
            PlayerOne = entityManager.AddEntity(new Player());
            PlayerTwo = entityManager.AddEntity(new Player());

            Vector2 playerOnePosition = new Vector2(GraphicsDevice.Viewport.TitleSafeArea.X, GraphicsDevice.Viewport.TitleSafeArea.Y + GraphicsDevice.Viewport.TitleSafeArea.Height / 2);
            Vector2 playerTwoPosition = new Vector2(GraphicsDevice.Viewport.TitleSafeArea.X + 200, GraphicsDevice.Viewport.TitleSafeArea.Y + GraphicsDevice.Viewport.TitleSafeArea.Height / 2);
            PlayerOne.Initialize(Content.Load<Texture2D>("player1"), playerOnePosition, new PlayerControls(Keys.Right, Keys.Left, Keys.Up, Keys.Down));
            PlayerTwo.Initialize(Content.Load<Texture2D>("player2"), playerTwoPosition, new PlayerControls(Keys.D, Keys.A, Keys.W, Keys.S));

            collisionComponent.Insert(PlayerOne);
            collisionComponent.Insert(PlayerTwo);
        }

        public override void Update(GameTime gameTime)
        {
            var keyboardState = KeyboardExtended.GetState();
            if (keyboardState.WasKeyJustDown(Keys.Escape))
                ScreenManager.LoadScreen(new TitleScreen(Game), new ExpandTransition(GraphicsDevice, Color.Black));

            entityManager.Update(gameTime);
            collisionComponent.Update(gameTime);
        }

        public override void Draw(GameTime gameTime)
        {
            // Lights ...
            DrawLights();

            // Camera ... Draw main scene
            GraphicsDevice.SetRenderTarget(mainRenderTarget);
            GraphicsDevice.Clear(Color.Transparent);
            spriteBatch.Begin(SpriteSortMode.Deferred, BlendState.AlphaBlend);

            entityManager.Draw(spriteBatch);

            mapRenderer.Draw(camera.GetViewMatrix());
            spriteBatch.End();

            // Action ... Blend the scenes together
            BlendRenderTargets();
        }

        private void DrawLights()
        {
            GraphicsDevice.SetRenderTarget(lightsRenderTarget);
            GraphicsDevice.Clear(Color.Black);
            spriteBatch.Begin(SpriteSortMode.Immediate, BlendState.Additive);
            spriteBatch.Draw(lightMask, PlayerOne.Position, null, Color.White, 0f, new Vector2(lightMask.Width / 2f, lightMask.Height / 2f), PlayerOne.IsHiding ? 0.2f : 1.5f, SpriteEffects.None, 0f);
            spriteBatch.Draw(lightMask, PlayerTwo.Position, null, Color.White, 0f, new Vector2(lightMask.Width / 2f, lightMask.Height / 2f), PlayerTwo.IsHiding ? 0.2f : 1.5f, SpriteEffects.None, 0f);
            spriteBatch.End();
        }

        private void BlendRenderTargets()
        {
            GraphicsDevice.SetRenderTarget(null);
            GraphicsDevice.Clear(Color.Black);
            spriteBatch.Begin(SpriteSortMode.Immediate, BlendState.AlphaBlend);
            lightEffect.Parameters["lightMask"].SetValue(lightsRenderTarget);
            lightEffect.CurrentTechnique.Passes[0].Apply();
            spriteBatch.Draw(mainRenderTarget, Vector2.Zero, Color.White);
            spriteBatch.End();
        }
    }
}
