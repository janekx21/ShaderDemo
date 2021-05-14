using System;

namespace ShaderDemo {
#if WINDOWS || LINUX
    public static class Program {
        [STAThread]
        private static void Main() {
            using (var game = new ShaderDemo()) {
                game.Run();
            }
        }
    }
#endif
}
