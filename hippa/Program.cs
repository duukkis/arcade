using System;

namespace Hippa
{
    public static class Program
    {
        [STAThread]
        static void Main()
        {
            using (var game = new Hippa())
                game.Run();
        }
    }
}
