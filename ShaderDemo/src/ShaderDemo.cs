using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;

namespace ShaderDemo {
    public class ShaderDemo : Game {
        // Content
        private Effect effect;
        private Model model;
        private Texture2D texture;

        // Uniform Data
        private Matrix modelMatrix;
        private Matrix viewMatrix;
        private Matrix projectionMatrix;
        private readonly Vector3 cameraPosition = new Vector3(6f, 2f, 6f);
        private readonly Vector3 lightDirection = Vector3.Normalize(new Vector3(.5f, -1f, -.5f));

        public ShaderDemo() {
            var unused = new GraphicsDeviceManager(this) {GraphicsProfile = GraphicsProfile.HiDef};
            Content.RootDirectory = "Content\\bin\\Windows";
        }

        protected override void Initialize() {
            Window.AllowUserResizing = true;
            IsMouseVisible = true;
            base.Initialize();
        }

        protected override void LoadContent() {
            effect = Content.Load<Effect>("shaders/expand");
            model = Content.Load<Model>("models/bunny");
            texture = Content.Load<Texture2D>("images/brick");
        }

        protected override void Update(GameTime gameTime) {
            if (Keyboard.GetState().IsKeyDown(Keys.Escape)) Exit();

            var scale = Vector3.One;
            var rotation = Quaternion.Identity *
                           Quaternion.CreateFromAxisAngle(Vector3.Down,
                               (float) gameTime.TotalGameTime.TotalSeconds * .2f);
            var position = Vector3.Zero;

            // generate matrices
            modelMatrix = Matrix.CreateScale(scale)
                          * Matrix.CreateFromQuaternion(rotation)
                          * Matrix.CreateTranslation(position);
            viewMatrix = Matrix.CreateLookAt(cameraPosition, Vector3.Zero, Vector3.Up);
            projectionMatrix = Matrix.CreatePerspectiveFieldOfView(
                MathHelper.ToRadians(60f), GraphicsDevice.Viewport.AspectRatio, .1f, 100f);

            base.Update(gameTime);
        }

        protected override void Draw(GameTime gameTime) {
            // uncomment for simple rendering
            // DrawModelsSimple(gameTime);

            DrawModels(gameTime);

            base.Draw(gameTime);
        }

        private void DrawModelsSimple(GameTime gameTime) {
            GraphicsDevice.Clear(Color.Black);
            model.Draw(modelMatrix, viewMatrix, projectionMatrix);
        }

        private void DrawModels(GameTime gameTime) {
            GraphicsDevice.Clear(Color.Black);

            // Draw "model" with effect
            foreach (var mesh in model.Meshes) {
                foreach (var meshPart in mesh.MeshParts) {
                    var worldMatrix = mesh.ParentBone.Transform * modelMatrix;

                    // Setting mesh part shader to a effect
                    meshPart.Effect = effect;

                    // Matrices
                    effect.Parameters["worldMatrix"].SetValue(worldMatrix);
                    effect.Parameters["viewMatrix"].SetValue(viewMatrix);
                    effect.Parameters["projectionMatrix"].SetValue(projectionMatrix);

                    effect.Parameters["worldMatrixInverse"]?.SetValue(Matrix.Invert(modelMatrix));

                    // Textures
                    if (texture != null) {
                        effect.Parameters["albedoTexture"]?.SetValue(texture);
                    }

                    // Util
                    effect.Parameters["lightDirection"]?.SetValue(lightDirection);
                    effect.Parameters["cameraPosition"]?.SetValue(cameraPosition);
                    effect.Parameters["time"]?.SetValue((float) gameTime.TotalGameTime.TotalSeconds);
                }

                mesh.Draw();
            }
        }
    }
}
