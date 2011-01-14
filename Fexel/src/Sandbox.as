package
{
	import apparat.math.FastMath;
	
	import com.mgrenier.fexel.fexel;
	use namespace fexel;
	
	import com.mgrenier.events.ConsoleEvent;
	import com.mgrenier.fexel.Stage;
	import com.mgrenier.fexel.TextureLoader;
	import com.mgrenier.fexel.display.Bitmap;
	import com.mgrenier.fexel.display.DisplayObject;
	import com.mgrenier.fexel.display.View;
	import com.mgrenier.utils.Console;
	import com.mgrenier.utils.Input;
	import com.mgrenier.utils.Memory;
	
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
	
	[SWF(backgroundColor="#ff00ff", frameRate="30", width="800", height="800")]
	public class Sandbox extends Sprite
	{
		protected var params:Object;
		
		public function Sandbox():void 
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
		
		public var buffer:BitmapData;
		public var t:com.mgrenier.fexel.display.Bitmap;
		
		protected function initialize ():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			t = new com.mgrenier.fexel.display.Bitmap(480, 480);
			t.bitmapData = TextureLoader.load("yoshi", this.yoshi);
			
			buffer = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0xff000000);
			var bitmap:flash.display.Bitmap = new flash.display.Bitmap();
			bitmap.bitmapData = buffer;
			addChild(bitmap);
			
			t.x = stage.stageWidth / 2 - t.width / 2;
			t.y = stage.stage.height / 2 - t.height / 2;
			t.refX = t.refY = t.width / 2;
			
			trace(540 % 360);
			
			this.addEventListener(Event.ENTER_FRAME, this.enterFrame);
		}
		
		protected var matrix:Matrix = new Matrix(),
					  color:ColorTransform = new ColorTransform();
		
		protected function enterFrame (e:Event = null):void
		{
			buffer.lock();
			
			for (var i = 10; i > 0; --i) {
				t.color.color = Math.random() * 0xffffff;
				t.rotation += 5;
				t.render(buffer, matrix, color);
			}
			
			buffer.unlock();
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
