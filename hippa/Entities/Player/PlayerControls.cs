using Microsoft.Xna.Framework.Input;

namespace Hippa.Entities.Player
{
    public class PlayerControls
    {
        public Keys Right { get; set; }
        public Keys Left { get; set; }
        public Keys Jump { get; set; }
        public Keys Hide { get; set; }

        public PlayerControls(Keys right, Keys left, Keys jump, Keys hide)
        {
            this.Right = right;
            this.Left = left;
            this.Jump = jump;
            this.Hide = hide;
        }
    }
}
