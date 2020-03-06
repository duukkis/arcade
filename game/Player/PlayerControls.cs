using Microsoft.Xna.Framework.Input;

namespace Arcade.Entities {
  public class PlayerControls {
    public Keys Right { get; set; }
    public Keys Left { get; set; }
    public Keys Jump { get; set; }

    public PlayerControls(Keys right, Keys left, Keys jump) {
      this.Right = right;
      this.Left = left;
      this.Jump = jump;
    }
  }
}