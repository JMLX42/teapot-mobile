package 
{
	import aerys.minko.render.Viewport;
	import aerys.minko.render.effect.SinglePassRenderingEffect;
	import aerys.minko.render.shader.IShader;
	import aerys.minko.scene.node.camera.Camera;
	import aerys.minko.scene.node.group.StyleGroup;
	import aerys.minko.scene.node.group.TransformGroup;
	import aerys.minko.scene.node.mesh.modifier.NormalMeshModifier;
	import aerys.minko.scene.node.mesh.primitive.TeapotMesh;
	import aerys.minko.type.controller.ArcBallController;
	import aerys.minko.type.math.ConstVector4;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.math.Vector4;
	import aerys.monitor.Monitor;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Teapot extends Sprite
	{
		private var _viewport		: Viewport		= new Viewport();
		private var _camera			: Camera		= new Camera(new Vector4(0, 0, -12), new Vector4(0, 0, 0));
		private var _scene			: StyleGroup	= new StyleGroup(new TransformGroup(_camera));
		
		private var _shader			: IShader		= new CelShadingShader();
		private var _lightMatrix	: Matrix4x4		= new Matrix4x4();
	
		public function Teapot()
		{
			super();
			
			var cameraController : ArcBallController = new ArcBallController(_scene[0]);
			
			cameraController.mouseSensitivity = 0.001;
			cameraController.bindDefaultControls(stage);
			cameraController.setPivot(0, 1.5, 0);
			
			_scene.addChild(new NormalMeshModifier(new TeapotMesh(40)));
		
			_viewport.defaultEffect = new SinglePassRenderingEffect(_shader);
			_viewport.backgroundColor = 0x666666;
			
			stage.frameRate = 30.;
			stage.addChild(_viewport);
			
			stage.addChild(Monitor.monitor.watch(_viewport, ["numTriangles"]));
			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
	
		private function enterFrameHandler(event : Event) : void
		{
			_lightMatrix.appendRotation(0.01, ConstVector4.Y_AXIS);
			_shader.setNamedParameter(
				"light direction",
				_lightMatrix.transformVector(ConstVector4.Z_AXIS)
			);
			
			_viewport.render(_scene);
		}
	}
}