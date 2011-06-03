package
{
	import com.mgrenier.events.ConsoleEvent;
	import com.mgrenier.fexel.Entity;
	import com.mgrenier.fexel.World;
	import com.mgrenier.fexel.collision.QuadTree;
	import com.mgrenier.fexel.collision.SAT;
	import com.mgrenier.fexel.collision.shape.*;
	import com.mgrenier.fexel.View;
	import com.mgrenier.geom.Rectangle2D;
	import com.mgrenier.geom.Vec2D;
	import com.mgrenier.utils.Console;
	import com.mgrenier.utils.Input;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(backgroundColor="#ffffff", frameRate="30", width="805", height="485")]
	public class Collision extends Sprite
	{
		protected var params:Object;
		
		public function Collision():void 
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
		
		
		
		protected var	w:World,
						v:View,
						y1:Yoshi,
						y2:Yoshi,
						y4:Yoshi,
						y3:Yoshi;
		
		protected function initialize ():void
		{
			w = new World();
			v = new View(stage.stageWidth, stage.stageHeight);
			v.debug = View.DEBUG_SHAPE;
			w.addView(v);
			this.addChildAt(v.getBuffer(), 0);
			
			y1 = new Yoshi();
			y2 = new Yoshi();
			y3 = new Yoshi();
			y4 = new Yoshi();
			y1.x = 300;
			y1.y = 200;
			y2.x = 400;
			y2.y = 100;
			y3.x = 400;
			y3.y = 200;
			y4.x = 400;
			y4.y = 300;
			
			//trace(1 << 0, 1 << 1, 1 << 2, 1 << 3);
			//trace(0xffffffff, uint.MAX_VALUE);
			
			var polygon:Vector.<Vec2D> = new Vector.<Vec2D>();
			polygon.push(new Vec2D(14, 19));
			polygon.push(new Vec2D(42, 27));
			polygon.push(new Vec2D(22, 46));
			
			y1.setShape(new Polygon(polygon));
			y1.dynamic = true;
			y2.setShape(new Circle(26, 31, 16));
			y4.setShape(new Box(10, 17, 32, 32));
			y3.setShape(new Polygon(polygon));
			
			w.addEntity(y4);
			w.addEntity(y3);
			w.addEntity(y2);
			w.addEntity(y1);
			
			w.setCollider(new SAT());
			w.setBroadphase(new QuadTree());
			
			this.addEventListener(Event.ENTER_FRAME, this.enterFrame);
		}
		
		protected function enterFrame (e:Event = null):void
		{
			var step:int = 5;
			
			if (Input.keyState(Input.SPACE))
			{
				stage.frameRate = stage.frameRate == 1 ? 30 : 1;
			}
			
			if (Input.keyState(Input.NUMPAD_MULTIPLY))
			{
				v.zoom = 0;
				v.setCamera(0, 0);
			}
			if (Input.keyState(Input.NUMPAD_ADD))
				v.zoom += 0.2;
			if (Input.keyState(Input.NUMPAD_SUBTRACT))
				v.zoom -= 0.2;
			
			if (Input.keyState(Input.A))
				y1.x -= step;
			if (Input.keyState(Input.D))
				y1.x += step;
			if (Input.keyState(Input.W))
				y1.y -= step;
			if (Input.keyState(Input.S))
				y1.y += step;
			
			w.step(stage.frameRate);
			
			if (Input.keyState(Input.SPACE))
				Console.log("Overlap "+ w.getBroadphase().overlapEntity(y1));
		}
		
		protected function uninitialize ():void
		{
			this.removeEventListener(Event.ENTER_FRAME, this.enterFrame);
			
			this.removeChild(v.getBuffer());
			
			w.dispose();
			w = null;
			v = null;
			y1.dispose();
			y1 = null;
			y2.dispose();
			y2 = null;
		}
		
		protected function command (e:ConsoleEvent):void
		{
			switch (e.text)
			{
				case '/reset':
					this.uninitialize();
					this.initialize();
					break;
				default:
					//y1.play(e.text);
			}
		}
		
	}
}

import com.mgrenier.fexel.display.*;
import com.mgrenier.geom.Rectangle2D;
import com.mgrenier.geom.Vec2D;

class Yoshi extends AnimatedSprite
{
	[Embed(source="assets/YoshiSprite.gif")]
	protected var image:Class;
	
	public function Yoshi ()
	{
		super(48, 48, 30);
		
		this.setSource(this.image);
		this.addAnimation("walkRight", [1, 2, 3, 4, 5, 6, 7, 8, 9], true);
		this.addAnimation("walkLeft", [11, 12, 13, 14, 15, 16, 17, 18, 19], true);
		this.addAnimation("runRight", [21, 22, 23, 24], true);
		this.addAnimation("runLeft", [31, 32, 33, 34], true);
		this.addAnimation("idleRight", [10], false);
		this.addAnimation("idleLeft", [20], false);
		this.addAnimation("jumpRight", [25], false);
		this.addAnimation("jumpLeft", [35], false);
		this.addAnimation("fallRight", [26], false);
		this.addAnimation("fallLeft", [36], false);
		this
		.play("runRight", 6 + Math.floor(Math.random() * 4))
			.delay(Math.floor(Math.random() * 30));
	}
}