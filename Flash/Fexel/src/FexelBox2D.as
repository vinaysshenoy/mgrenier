package
{
	import com.Box2D.Collision.Shapes.b2CircleShape;
	import com.Box2D.Collision.Shapes.b2PolygonShape;
	import com.Box2D.Common.Math.b2Vec2;
	import com.Box2D.Dynamics.b2Body;
	import com.Box2D.Dynamics.b2BodyDef;
	import com.Box2D.Dynamics.b2DebugDraw;
	import com.Box2D.Dynamics.b2FixtureDef;
	import com.Box2D.Dynamics.b2World;
	import com.mgrenier.events.ConsoleEvent;
	import com.mgrenier.fexel.Stage;
	import com.mgrenier.fexel.display.DisplayObject;
	import com.mgrenier.fexel.display.Screen;
	import com.mgrenier.fexel.display.Shape;
	import com.mgrenier.geom.Vec2D;
	import com.mgrenier.utils.Console;
	import com.mgrenier.utils.Input;
	import com.mgrenier.utils.Memory;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.getTimer;

	[SWF(backgroundColor="#000000", frameRate="30", width="800", height="400")]
	public class FexelBox2D extends Sprite
	{
		protected var params:Object;
		
		public function FexelBox2D():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		final private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, uninit);
			// entry point
			this.initialize();
			
			Console.level = Console.DEBUG | Console.LOG;
			addChild(Console.getInstance());
			Console.addEventListener(ConsoleEvent.COMMAND, this.command);
			
			addChild(Input.getInstance());
			
			stage.quality = StageQuality.LOW;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			_debug.y = stage.stageHeight / 2;
			addChild(_debug);
		}
		
		final private function uninit(e:Event = null):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, uninit);
			addEventListener(Event.ADDED_TO_STAGE, init);
			// exit point
			this.uninitialize();
			
			removeChild(Console.getInstance());
			Console.removeEventListener(ConsoleEvent.COMMAND, this.command);
			
			removeChild(Input.getInstance());
		}
		
		protected var _debug:Sprite = new Sprite();
		protected var _world:b2World;
		
		protected var _stage:Stage;
		protected var _screen1:Screen;
		protected var _screen2:Screen;
		
		protected function initialize ():void
		{
			_stage = new Stage();
			_screen1 = new Screen(stage.stageWidth, stage.stageHeight / 2, 0.5, 0x00000000);
			_stage.addScreen(_screen1);
			addChildAt(_screen1, 0);
			_screen2 = new Screen(stage.stageWidth, stage.stageHeight / 2, 1, 0x00000000);
			//_screen2.debug = Screen.DEBUG_BOUNDINGBOX;
			_screen2.y = stage.stageHeight / 2;
			//_screen2.camStretchX = -1;
			//_screen2.camRotation = 180;
			//_screen2.colorTransform.alphaMultiplier = 0.5;
			_stage.addScreen(_screen2);
			addChildAt(_screen2, 0);
			
			//_screen2.camY = 400;
			
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			debugDraw.SetSprite(_debug);
			debugDraw.SetDrawScale(30);
			debugDraw.SetFillAlpha(0.5);
			debugDraw.SetLineThickness(1);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			
			_world = new b2World(new b2Vec2(0, 10), false);
			_world.SetDebugDraw(debugDraw);
			_world.DrawDebugData();
			
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(stage.stageWidth / 30 / 2, stage.stageHeight / 2 / 30);
			bodyDef.type = b2Body.b2_staticBody;
			var boxShape:b2PolygonShape = new b2PolygonShape();
			boxShape.SetAsBox(stage.stageWidth / 30 / 2, 10 / 30);
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = boxShape;
			fixtureDef.friction = 0.3;
			fixtureDef.restitution = 0.2;
			var body:b2Body = _world.CreateBody(bodyDef);
			body.CreateFixture(fixtureDef);
			
			bodyDef = new b2BodyDef();
			bodyDef.position.Set(stage.stageWidth / 30 / 2, 0);
			bodyDef.type = b2Body.b2_staticBody;
			body = _world.CreateBody(bodyDef);
			body.CreateFixture(fixtureDef);
			
			boxShape = new b2PolygonShape();
			boxShape.SetAsBox(10 / 30, stage.stageHeight / 30 / 2);
			fixtureDef.shape = boxShape;
			bodyDef = new b2BodyDef();
			bodyDef.position.Set(0, stage.stageHeight / 2 / 30);
			bodyDef.type = b2Body.b2_staticBody;
			body = _world.CreateBody(bodyDef);
			body.CreateFixture(fixtureDef);
			
			bodyDef = new b2BodyDef();
			bodyDef.position.Set(stage.stageWidth / 30, stage.stageHeight / 2 / 30);
			bodyDef.type = b2Body.b2_staticBody;
			body = _world.CreateBody(bodyDef);
			body.CreateFixture(fixtureDef);
			
			var circleShape:b2CircleShape,
				_box:Shape;
			for (var i:uint = 50; i > 0; --i)
			{
				bodyDef = new b2BodyDef();
				bodyDef.position.Set(Math.random() * stage.stageWidth / 30, Math.random() * 100 / 30);
				//bodyDef.angle = 0.5;
				//bodyDef.type = Math.random() > 0.5 ? b2Body.b2_dynamicBody : b2Body.b2_staticBody;
				bodyDef.type = b2Body.b2_dynamicBody;
				//bodyDef.fixedRotation = true;

				_box = new Shape(20, 20);
				_box.refX = 10;
				_box.refY = 10;
				_box.graphics.beginFill(0xffffff * Math.random() + 0x222222);
				_box.graphics.drawRect(0, 0, 20, 20);
				_box.graphics.endFill();
				_box.update();
				bodyDef.userData = _box;
				
				boxShape = new b2PolygonShape();
				boxShape.SetAsBox(10 / 30, 10 / 30);
				fixtureDef.shape = boxShape;
				//circleShape = new b2CircleShape(10 / 30);
				//fixtureDef.shape = circleShape;
				fixtureDef.density = 1;
				fixtureDef.friction = 1;
				fixtureDef.restitution = 0.5;
				body = _world.CreateBody(bodyDef);
				body.CreateFixture(fixtureDef);
				
				_stage.addChild(_box);
			}
			
			this.addEventListener(Event.ENTER_FRAME, this.enterFrame);
		}
		
		protected function uninitialize ():void
		{
			this.removeEventListener(Event.ENTER_FRAME, this.enterFrame);
			var body:b2Body;
			
			for (body = _world.GetBodyList(); body; body = body.GetNext())
				_world.DestroyBody(body);
			
			_world.SetDebugDraw(null);
			_world = null;
			
			_stage.dispose();
			_stage = null;
			_screen1 = null;
		}
		
		protected function enterFrame (e:Event = null):void
		{
			if (Input.keyState(Input.SPACE))
			{
				Memory.forceGC();
			}
			
			var step:int = 2;
			
			if (Input.keyState(Input.UP))
				_screen1.camY -= step;
			if (Input.keyState(Input.DOWN))
				_screen1.camY += step;
			if (Input.keyState(Input.RIGHT))
				_screen1.camX -= step;
			if (Input.keyState(Input.LEFT))
				_screen1.camX += step;
			
			if (Input.keyState(Input.W)) {
				_screen1.camStretchX += 0.05;
				_screen1.camStretchY += 0.05;
			}
			if (Input.keyState(Input.S)) {
				_screen1.camStretchX -= 0.05;
				_screen1.camStretchY -= 0.05;
			}
			if (Input.keyState(Input.A))
				_screen1.camRotation -= step;
			if (Input.keyState(Input.D))
				_screen1.camRotation += step;
			
			if (Input.keyState(Input.NUMPAD_0))
			{
				//_screen1.camStretchX = _screen1.camStretchY = 1;
				_screen1.camX = stage.stageWidth / 2;
				_screen1.camY = stage.stageHeight / 2 / 2;
				_screen1.camRotation = 0;
			}
			
			var gravity:b2Vec2 = _world.GetGravity(),
				vec:Vec2D = new Vec2D(0, 10);
			vec.rotateDegree(-_screen1.camRotation);
			gravity.x = vec.x;
			gravity.y = vec.y;
			_world.SetGravity(gravity);
			
			var time:int = getTimer();
			
			_world.Step(1/30, 10, 10);
			//_world.DrawDebugData();
			
			//Console.log('Step  :', getTimer() - time);
			time = getTimer();
			
			_stage.render();
			
			//Console.log('Render:', getTimer() - time);
			
			var display:DisplayObject,
				pos:b2Vec2;
			for (var body:b2Body = _world.GetBodyList(); body; body = body.GetNext())
				if (body.GetUserData() is DisplayObject)
				{
					display = DisplayObject(body.GetUserData());
					pos = body.GetPosition();
					display.x = pos.x * 30;
					display.x -= display.width / 2;
					display.y = pos.y * 30;
					display.y -= display.height / 2;
					display.rotation = body.GetAngle() * 57.2957795;
				}
		}
		
		protected function command (e:ConsoleEvent):void
		{
			switch (e.text.split(' ').shift())
			{
				case '/reset':
					this.uninitialize();
					Memory.forceGC();
					this.initialize();
					break;
				default:
					trace(e.text);
			}
		}
	}
}