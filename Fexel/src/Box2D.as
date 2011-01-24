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
	import com.mgrenier.utils.Console;
	import com.mgrenier.utils.Input;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	[SWF(backgroundColor="#000000", frameRate="30", width="800", height="400")]
	public class Box2D extends Sprite
	{
		protected var params:Object;
		
		public function Box2D():void 
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
		
		protected function initialize ():void
		{
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			debugDraw.SetSprite(_debug);
			debugDraw.SetDrawScale(30);
			debugDraw.SetFillAlpha(0.5);
			debugDraw.SetLineThickness(1);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			
			_world = new b2World(new b2Vec2(0, 10), true);
			_world.SetDebugDraw(debugDraw);
			_world.DrawDebugData();
			
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(stage.stageWidth / 30 / 2, stage.stageHeight / 30);
			bodyDef.type = b2Body.b2_staticBody;
			var boxShape:b2PolygonShape = new b2PolygonShape();
			boxShape.SetAsBox(stage.stageWidth / 30 / 2, 10 / 30);
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = boxShape;
			fixtureDef.friction = 0.3;
			fixtureDef.restitution = 0.2;
			var body:b2Body = _world.CreateBody(bodyDef);
			body.CreateFixture(fixtureDef);
			
			var circleShape:b2CircleShape;
			for (var i:uint = 100; i > 0; --i)
			{
				bodyDef = new b2BodyDef();
				bodyDef.position.Set(Math.random() * stage.stageWidth / 30, Math.random() * 200 / 30);
				//bodyDef.type = Math.random() > 0.5 ? b2Body.b2_dynamicBody : b2Body.b2_staticBody;
				bodyDef.type = b2Body.b2_dynamicBody;
				//bodyDef.fixedRotation = true;
				
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
			}
			
			
			this.addEventListener(Event.ENTER_FRAME, this.enterFrame);
		}
		
		protected function uninitialize ():void
		{
			this.removeEventListener(Event.ENTER_FRAME, this.enterFrame);
			var body:b2Body;
			
			for (_world.GetBodyList(); body; body = body.GetNext())
				_world.DestroyBody(body);
			
			_world.SetDebugDraw(null);
			_world = null;
		}
		
		protected function enterFrame (e:Event = null):void
		{
			_world.Step(1/30, 10, 10);
			_world.DrawDebugData();
		}
		
		protected function command (e:ConsoleEvent):void
		{
			switch (e.text.split(' ').shift())
			{
				case '/reset':
					this.uninitialize();
					this.initialize();
					break;
				default:
					trace(e.text);
			}
		}
	}
}