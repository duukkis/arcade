using Hippa.Screens;
using Microsoft.Xna.Framework;
using MonoGame.Extended;
using MonoGame.Extended.Screens;
using MonoGame.Extended.Screens.Transitions;

namespace Hippa
{
    public class Hippa : Game
    {
        private readonly GraphicsDeviceManager graphicsDeviceManager;
        private readonly ScreenManager screenManager;

        private readonly FramesPerSecondCounter fpsCounter = new FramesPerSecondCounter();


        public Hippa()
        {
            graphicsDeviceManager = new GraphicsDeviceManager(this);
            
            Content.RootDirectory = "Content";
            IsMouseVisible = true;

            screenManager = Components.Add<ScreenManager>();
        }

        protected override void Initialize()
        {

            base.Initialize();
        }

        protected override void LoadContent()
        {
            base.LoadContent();
            screenManager.LoadScreen(new TitleScreen(this), new FadeTransition(GraphicsDevice, Color.Black, 0.5f));

        }

    }
}
