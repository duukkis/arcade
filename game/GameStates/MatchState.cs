using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using MonoGame.Extended;
using MonoGame.Extended.Tiled;
using MonoGame.Extended.Tiled.Renderers;
using Arcade.Entities;

namespace Arcade.GameStates
{
  public class MatchState : GameState
  {
    public Player PlayerOne;
    public Player PlayerTwo;
    private Texture2D lightMask;
    private Effect lightEffect;
    private RenderTarget2D lightsRenderTarget;
    private RenderTarget2D mainRenderTarget;
    private TiledMap map;
    private TiledMapRenderer mapRenderer;
    private OrthographicCamera camera;
    private GraphicsDevice graphicsDevice;
    private KeyboardState currentKeyboardState;
    private KeyboardState previousKeyboardState;

    public MatchState(GraphicsDevice graphicsDevice) : base(graphicsDevice)
    {
      this.graphicsDevice = graphicsDevice;
    }

    public override void Initialize()
    {
      camera = new OrthographicCamera(graphicsDevice);
      PresentationParameters pp = graphicsDevice.PresentationParameters;
      lightsRenderTarget = new RenderTarget2D(graphicsDevice, pp.BackBufferWidth, pp.BackBufferHeight);
      mainRenderTarget = new RenderTarget2D(graphicsDevice, pp.BackBufferWidth, pp.BackBufferHeight);
      PlayerOne = new Player();
      PlayerTwo = new Player();
    }

    public override void LoadContent(ContentManager content)
    {
      lightMask = content.Load<Texture2D>("lightmask");
      lightEffect = content.Load<Effect>("lighteffect");
      Vector2 playerOnePosition = new Vector2(graphicsDevice.Viewport.TitleSafeArea.X, graphicsDevice.Viewport.TitleSafeArea.Y + graphicsDevice.Viewport.TitleSafeArea.Height / 2);
      Vector2 playerTwoPosition = new Vector2(graphicsDevice.Viewport.TitleSafeArea.X + 200, graphicsDevice.Viewport.TitleSafeArea.Y + graphicsDevice.Viewport.TitleSafeArea.Height / 2);
      PlayerOne.Initialize(content.Load<Texture2D>("player1"), playerOnePosition, new PlayerControls(Keys.Right, Keys.Left, Keys.Up, Keys.Down));
      PlayerTwo.Initialize(content.Load<Texture2D>("player2"), playerTwoPosition, new PlayerControls(Keys.D, Keys.A, Keys.W, Keys.S));
      map = content.Load<TiledMap>("map");
      mapRenderer = new TiledMapRenderer(graphicsDevice, map);
    }

    public override void UnloadContent()
    {

    }

    public override void Update(GameTime gameTime)
    {
      UpdatePlayers(gameTime);
      previousKeyboardState = currentKeyboardState;
      currentKeyboardState = Keyboard.GetState();
    }

    public override void Draw(SpriteBatch spriteBatch)
    {
      // Draw light scene
      graphicsDevice.SetRenderTarget(lightsRenderTarget);
      graphicsDevice.Clear(Color.Black);
      spriteBatch.Begin(SpriteSortMode.Immediate, BlendState.Additive);
      spriteBatch.Draw(lightMask, PlayerOne.Position, null, Color.White, 0f, new Vector2(lightMask.Width / 2f, lightMask.Height / 2f), PlayerOne.IsHiding ? 0.2f : 1.5f, SpriteEffects.None, 0f);
      spriteBatch.Draw(lightMask, PlayerTwo.Position, null, Color.White, 0f, new Vector2(lightMask.Width / 2f, lightMask.Height / 2f), PlayerTwo.IsHiding ? 0.2f : 1.5f, SpriteEffects.None, 0f);
      spriteBatch.End();

      // Draw main scene
      graphicsDevice.SetRenderTarget(mainRenderTarget);
      graphicsDevice.Clear(Color.Transparent);
      spriteBatch.Begin(SpriteSortMode.Deferred, BlendState.AlphaBlend);
      DrawPlayers(spriteBatch);
      mapRenderer.Draw(camera.GetViewMatrix());
      spriteBatch.End();

      // Blend the scenes together
      graphicsDevice.SetRenderTarget(null);
      graphicsDevice.Clear(Color.Black);
      spriteBatch.Begin(SpriteSortMode.Immediate, BlendState.AlphaBlend);
      lightEffect.Parameters["lightMask"].SetValue(lightsRenderTarget);
      lightEffect.CurrentTechnique.Passes[0].Apply();
      spriteBatch.Draw(mainRenderTarget, Vector2.Zero, Color.White);
      spriteBatch.End();
    }

    private void DrawPlayers(SpriteBatch spriteBatch)
    {
      PlayerOne.Draw(spriteBatch);
      PlayerTwo.Draw(spriteBatch);
    }

    private void UpdatePlayer(Player player, GameTime gameTime) {
      if (currentKeyboardState.IsKeyDown(player.Controls.Left))
      {
        player.Action(PlayerActions.WALK_LEFT);
      }
      else if (currentKeyboardState.IsKeyDown(player.Controls.Right))
      {
        player.Action(PlayerActions.WALK_RIGHT);
      }
      else
      {
        player.Action(PlayerActions.STOP_WALKING);
      }
      if (currentKeyboardState.IsKeyDown(player.Controls.Jump) && !previousKeyboardState.IsKeyDown(player.Controls.Jump)) {
        player.Action(PlayerActions.JUMP);
      }
      if (currentKeyboardState.IsKeyDown(player.Controls.Hide) && !previousKeyboardState.IsKeyDown(player.Controls.Hide)) {
        player.Action(PlayerActions.HIDE);
      }
      player.Update(gameTime);
    }

    private void UpdatePlayers(GameTime gameTime)
    {
      UpdatePlayer(PlayerOne, gameTime);
      UpdatePlayer(PlayerTwo, gameTime);
    }
  }
}
