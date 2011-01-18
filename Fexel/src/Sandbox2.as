package
{
	import apparat.math.FastMath;
	
	import com.mgrenier.fexel.fexel;
	use namespace fexel;
	
	import com.mgrenier.events.*;
	import com.mgrenier.fexel.*;
	import com.mgrenier.fexel.display.*;
	import com.mgrenier.utils.*;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.System;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	import flash.utils.getTimer;
	import flash.display.BlendMode;
	import com.mgrenier.fexel.display.SpriteSheet;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.media.Camera;
	
	[SWF(backgroundColor="#000000", frameRate="30", width="400", height="400")]
	public class Sandbox2 extends Sprite
	{
		protected var params:Object;
		
		public function Sandbox2():void 
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
		
		[Embed(source="assets/YoshiSprite.gif")]
		protected var yoshi:Class;
		
		protected var _stage:Stage;
		protected var _screen:Screen;
		protected var _tv:com.mgrenier.fexel.display.Bitmap;
		
		protected function initialize ():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			
			_stage = new Stage();
			_screen = new Screen(stage.stageWidth, stage.stageHeight);
			_screen.zoom = 1.9;
			
			var text1:Text = new Text(200, "Hello World A", 30);
			text1.x = 250;
			text1.y = 200;
			text1.update();
			
			_tv = new com.mgrenier.fexel.display.Bitmap(200, 200);
			_tv.scaleX = _tv.scaleY = 0.5;
			_tv.x = 100;
			_tv.y = 100;
			
			var yoshi:AnimatedSpriteSheet = new AnimatedSpriteSheet(48, 48, 12);
			yoshi.spriteData = TextureLoader.load("yoshi", this.yoshi);
			yoshi.addAnimation("runRight", new <int>[21, 22, 23, 24], true);
			yoshi.play("runRight");
			yoshi.x = 50;
			yoshi.y = 200;
			yoshi.update(30);
			
			_stage.addScreen(_screen);
			addChild(_screen);
			
			_stage.addChild(yoshi);
			_stage.addChild(text1);
			_stage.addChild(_tv);
			
			
			this.addEventListener(Event.ENTER_FRAME, this.enterFrame);
		}
		
		protected function enterFrame (e:Event = null):void
		{
			if (Input.keyState(Input.SPACE))
			{
				Memory.forceGC();
				Console.log(_screen.zoom);
			}
			
			if (Input.keyState(Input.NUMPAD_ADD))
				_screen.zoom += 0.05;
			if (Input.keyState(Input.NUMPAD_SUBTRACT))
				_screen.zoom -= 0.05;
			if (Input.keyState(Input.NUMPAD_0))
				_screen.zoom = 1;
			
			_screen.camRotation += 0.5;
			
			if (_tv.bitmapData)
				_tv.bitmapData.dispose();
			_tv.bitmapData = _screen.bitmapData.clone();
			_stage.render();
		}
		
		protected function uninitialize ():void
		{
			this.removeEventListener(Event.ENTER_FRAME, this.enterFrame);
		}
		
		protected function command (e:ConsoleEvent):void
		{
			switch (e.text)
			{
				default:
					trace(e.text);
			}
		}
		
	}
}
