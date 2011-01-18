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
	
	[SWF(backgroundColor="#000000", frameRate="30", width="800", height="800")]
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
		public var b:com.mgrenier.fexel.display.AnimatedSpriteSheet;
		public var t:com.mgrenier.fexel.display.TiledBitmap;
		
		protected function initialize ():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			//b = new Text(300, "Hello World", 30, 0xbbbbbb, 0x330033, 4, 4)
			/*b = new Shape(100, 100);
			b.graphics.beginFill(0xff00ff);
			b.graphics.drawCircle(50, 50, 50);
			b.graphics.endFill();*/
			b = new com.mgrenier.fexel.display.AnimatedSpriteSheet(48, 48, 12);
			b.spriteData = TextureLoader.load("yoshi", this.yoshi);
			b.addAnimation("runRight", new <int>[21, 22, 23, 24], true);
			b.play("runRight");
			
			t = new com.mgrenier.fexel.display.TiledBitmap(stage.stageWidth, stage.stageHeight);
			t.bitmap = b;
			
			buffer = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0xff000000);
			var bitmap:flash.display.Bitmap = new flash.display.Bitmap();
			bitmap.bitmapData = buffer;
			addChild(bitmap);
			
			b.scaleX = b.scaleY = 1;
			b.x = b.y = stage.stageWidth / 2 - b.width / 2;
			b.refX = b.refY = b.width / 2;
			
			t.refX = t.refY = t.width / 2;
			t.scaleX = t.scaleY = 0.6;
			
			b.update();
			t.update();
			
			this.addEventListener(Event.ENTER_FRAME, this.enterFrame);
		}
		
		protected var blur:BlurFilter = new BlurFilter(4, 4, 1);
		
		protected var matrix:Matrix = new Matrix(),
					  color:ColorTransform = new ColorTransform(),
					  blend:Vector.<String> = new <String>[BlendMode.NORMAL];
					  //blend:Vector.<String> = new <String>[BlendMode.ADD, BlendMode.ALPHA, BlendMode.DARKEN, BlendMode.DIFFERENCE, BlendMode.ERASE, BlendMode.HARDLIGHT, BlendMode.INVERT, BlendMode.LAYER, BlendMode.LIGHTEN, BlendMode.MULTIPLY, BlendMode.NORMAL, BlendMode.OVERLAY, BlendMode.SCREEN, BlendMode.SHADER, BlendMode.SUBTRACT];
		
		protected function enterFrame (e:Event = null):void
		{
			buffer.lock();
			
			var timer:int;
			
			if (Input.keyState(Input.SPACE))
				Memory.forceGC();
			
			if (Input.mouseState)
			{
				b.update(30);
				t.update(30);
			}
			for (var i:int = 1; i > 0; --i) {
				
				//t.colorTransform.color = Math.random() * -0xffffff;
				//t.colorTransform.redMultiplier = t.colorTransform.greenMultiplier = t.colorTransform.blueMultiplier = t.colorTransform.alphaMultiplier = Math.max(0.8, Math.random());
				//t.blend = this.blend[Math.floor(Math.random() * this.blend.length)];
				//t.render(buffer, matrix, color);
				t.rotation += 2;
				
				//b.color.color = Math.random() * -0xffffff;
				//b.color.redMultiplier = b.color.greenMultiplier = b.color.blueMultiplier = b.color.alphaMultiplier = 0.2 + Math.random();
				//b.blend = this.blend[Math.floor(Math.random() * this.blend.length)];
				//b.rotation += 2;
				
				//timer = getTimer();
				//b.render(buffer, matrix, color, 30);
				//trace(getTimer() - timer);
			}
			
			/*b.x = -440;
			b.y = 0;
			b.scaleX = b.scaleY = 1;
			var r:Number = b.rotation;
			var a:Number = b.color.alphaMultiplier;
			var b:String = b.blend;
			b.rotation = 0;
			b.color.alphaMultiplier = 1;
			b.blend = BlendMode.NORMAL;
			b.render(buffer, matrix, color);
			b.scaleX = b.scaleY = 0.25;
			b.x = b.y = stage.stageWidth / 2 - b.width / 2;
			b.rotation = r;
			b.color.alphaMultiplier = a;*/
			
			//buffer.applyFilter(buffer, new Rectangle(0, 0, buffer.width, buffer.height), new Point(0, 0), blur);
			
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
