package
{
	import apparat.math.FastMath;
	
	import com.mgrenier.events.ConsoleEvent;
	import com.mgrenier.utils.Console;
	import com.mgrenier.utils.Input;
	
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	
	[SWF(backgroundColor="#ffffff", frameRate="30", width="805", height="485")]
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
		
		
		protected function initialize ():void
		{
			
			this.addEventListener(Event.ENTER_FRAME, this.enterFrame);
		}
		
		protected function enterFrame (e:Event = null):void
		{
			
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
