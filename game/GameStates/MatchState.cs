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
    private TiledMap _map;
    private TiledMapRenderer _mapRenderer;
    private OrthographicCamera _camera;
    private GraphicsDevice graphicsDevice;
    private KeyboardState currentKeyboardState;
    private KeyboardState previousKeyboardState;

    public MatchState(GraphicsDevice graphicsDevice) : base(graphicsDevice)
    {
      this.graphicsDevice = graphicsDevice;
    }

    public override void Initialize()
    {
      _camera = new OrthographicCamera(graphicsDevice);
      PlayerOne = new Player();
      PlayerTwo = new Player();
    }

    public override void LoadContent(ContentManager content)
    {

      Vector2 playerOnePosition = new Vector2(graphicsDevice.Viewport.TitleSafeArea.X, graphicsDevice.Viewport.TitleSafeArea.Y + graphicsDevice.Viewport.TitleSafeArea.Height / 2);
      Vector2 playerTwoPosition = new Vector2(graphicsDevice.Viewport.TitleSafeArea.X + 200, graphicsDevice.Viewport.TitleSafeArea.Y + graphicsDevice.Viewport.TitleSafeArea.Height / 2);
      PlayerOne.Initialize(content.Load<Texture2D>("player1"), playerOnePosition, new PlayerControls(Keys.Right, Keys.Left, Keys.Up));
      PlayerTwo.Initialize(content.Load<Texture2D>("player2"), playerTwoPosition, new PlayerControls(Keys.D, Keys.A, Keys.W));
      _map = content.Load<TiledMap>("map");
      _mapRenderer = new TiledMapRenderer(graphicsDevice, _map);

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
      graphicsDevice.Clear(Color.Black);
      spriteBatch.Begin();
      DrawPlayers(spriteBatch);
      _mapRenderer.Draw(_camera.GetViewMatrix());
      spriteBatch.End();
    }

    private void DrawPlayers(SpriteBatch spriteBatch)
    {
      PlayerOne.Draw(spriteBatch);
      PlayerTwo.Draw(spriteBatch);
    }

    private void UpdatePlayers(GameTime gameTime)
    {
      // Player 1
      if (currentKeyboardState.IsKeyDown(PlayerOne.Controls.Left))
      {
        PlayerOne.Action(PlayerActions.WALK_LEFT);
      }
      if (currentKeyboardState.IsKeyDown(PlayerOne.Controls.Right))
      {
        PlayerOne.Action(PlayerActions.WALK_RIGHT);
      }
      if (currentKeyboardState.IsKeyDown(PlayerOne.Controls.Jump) && !previousKeyboardState.IsKeyDown(PlayerOne.Controls.Jump)) {
        PlayerOne.Action(PlayerActions.JUMP);
      }

      // Player 2
      if (currentKeyboardState.IsKeyDown(PlayerTwo.Controls.Left))
      {
        PlayerTwo.Action(PlayerActions.WALK_LEFT);
      }
      if (currentKeyboardState.IsKeyDown(PlayerTwo.Controls.Right))
      {
        PlayerTwo.Action(PlayerActions.WALK_RIGHT);
      }
      if (currentKeyboardState.IsKeyDown(PlayerTwo.Controls.Jump) && !previousKeyboardState.IsKeyDown(PlayerTwo.Controls.Jump)) {
        PlayerTwo.Action(PlayerActions.JUMP);
      }

      PlayerOne.Update(gameTime);
      PlayerTwo.Update(gameTime);
    }
  }
}
