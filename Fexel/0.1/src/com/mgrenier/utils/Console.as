package com.mgrenier.utils
{
	import com.mgrenier.events.ConsoleEvent;
	
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.geom.Matrix;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	/**
	 * Add Console
	 * 
	 * Use : addChild( Console.getInstance() );
	 */
	public class Console extends Sprite implements IEventDispatcher
	{
		static public const		LOG:int = 1;
		static public const		DEBUG:int = 2;
		static public const		ALPHA:Number = 0.5;

		static private var		_instance:Console;
		
		static public var		level:int = 0;
		
		static public var		stats:Stats;
		
		public var				console:TextField;
		public var				input:TextField;
		
		/**
		 * Singleton
		 */
		static public function getInstance ():Console
		{
			if (!Console._instance)
				Console._instance = new Console();
			return Console._instance;
		}
		
		/**
		 * Constructor
		 * 
		 */
		public function Console()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, this.initialize, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, this.uninitialize, false, 0, true);
		}
		
		/**
		 * Initialize listeners
		 */
		protected function initialize (...args):void
		{
			this.uninitialize();
			
			if (Console.level <= 0)
				return;
			
			this.alpha = 1;
			this.visible = false;
			
			this.graphics.beginFill(0x000000, Console.ALPHA);
			//this.graphics.drawRect(0, 0, stage.stageWidth, 100);
			this.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			this.graphics.lineStyle(1, 0xffffff, Console.ALPHA);
			this.graphics.moveTo(0, stage.stageHeight - 25);
			this.graphics.lineTo(stage.stageWidth, stage.stageHeight - 25);
			this.graphics.endFill();
			/*var grad:Matrix = new Matrix();
			grad.createGradientBox(stage.stageWidth, stage.stageHeight-100, 90 * (Math.PI / 180));
			grad.translate(0, 102);
			this.graphics.beginGradientFill(
											GradientType.LINEAR,
											[0x000000, 0x000000],
											[1, 0.5],
											[0, 255],
											grad,
											SpreadMethod.PAD,
											InterpolationMethod.LINEAR_RGB
											);
			this.graphics.drawRect(0, 100, stage.stageWidth, stage.stageHeight);
			this.graphics.endFill();*/
			
			var style:StyleSheet = new StyleSheet();
			style.setStyle("log", {fontSize:'12px', fontFamily:'mono', fontWeight:'bold', color:'#ffffff'});
			style.setStyle("debug", {fontSize:'12px', fontFamily:'mono', fontWeight:'bold', color:'#cccccc'});
			style.setStyle("*", {fontSize:'12px', fontFamily:'mono', fontWeight:'bold', color:'#ffffff'});
			
			this.console = new TextField();
			this.console.alpha = Console.ALPHA * 2;
			this.console.width = stage.stageWidth;
			this.console.height = stage.stageHeight - 25;
			this.console.wordWrap = true;
			this.console.selectable = true;
			this.console.styleSheet = style;
			addChild(this.console);
			
			this.input = new TextField();
			this.input.alpha = Console.ALPHA * 2;
			this.input.y = stage.stageHeight - 20;
			this.input.width = stage.stageWidth;
			this.input.height = 20;
			this.input.multiline = false;
			this.input.type = TextFieldType.INPUT;
			this.input.defaultTextFormat = HTextFormat.parseStyle("size:12;color:#ffffff;font:Courier;");
			addChild(this.input);
			
			input.addEventListener(KeyboardEvent.KEY_DOWN, this.consoleKeyHandler);
			input.addEventListener(KeyboardEvent.KEY_UP, this.consoleKeyHandler);
			
			if (Console.level & Console.DEBUG)
			{
				Console.stats = Stats.getInstance({bg:0x000000, fps:0xffff00, ms:0x00ff00, mem:0x00ffff, memmax:0xff0070});
				Console.stats.x = stage.stageWidth - 70;
				Console.stats.alpha = 0.75;
				addChild(Console.stats);
			}

			this.stage.addEventListener(KeyboardEvent.KEY_UP, this.keyHandler);
		}
		
		/**
		 * Uninitialize listeners
		 */
		protected function uninitialize (...args):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, this.initialize);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, this.uninitialize);
			this.stage.removeEventListener(KeyboardEvent.KEY_UP, this.keyHandler);
		}
		
		/**
		 * 
		 */
		protected function keyHandler (e:KeyboardEvent):void
		{
			if (e.keyCode == 222)
			{
				e.preventDefault();
				if (this.visible)
					this.input.text = this.input.text.substr(0, this.input.text.length - 1);
				this.visible = !this.visible;
			}
		}
			
		/**
		 * 
		 */
		protected function consoleKeyHandler (e:KeyboardEvent):void
		{
			if (e.keyCode == 13 && HString.trim(this.input.text) != "")
			{
				Console.dispatchEvent(new ConsoleEvent(ConsoleEvent.COMMAND, HString.trim(this.input.text)));
				this.input.text = "";
			}
			e.stopPropagation();
		}
		
		static protected function getNow():String
		{
			var date:Date = new Date();
			var now:String = date.toLocaleTimeString();
			var mili:Number = date.getMilliseconds();
			return now.substr(0, now.indexOf(" ")) +"."+ (mili < 100 ? '0'+mili : mili);
		}
		
		/**
		 * 
		 */
		static public function log (...args):void
		{
			if (!(Console.level & Console.LOG))
				return;
			
			var msg:String = args.join(" ");
			var console:TextField = Console.getInstance().console;
			console.htmlText += "<log>"+ Console.getNow() +" "+ msg +"</log>";
			console.scrollV = console.maxScrollV;
			//trace("LOG   :", Console.getNow(), msg, "buffer :", console.htmlText.length);
		}
		
		/**
		 * 
		 */
		static public function debug (...args):void
		{
			if (!(Console.level & Console.DEBUG))
				return;
			
			var msg:String = args.join(" ");
			var console:TextField = Console.getInstance().console;
			console.htmlText += "<debug>" + Console.getNow() +" " + msg +"</debug>";
			console.scrollV = console.maxScrollV;
			//trace("DEBUG :", Console.getNow(), msg, "buffer :", console.htmlText.length);
		}
		
		static private var _dispatcher:EventDispatcher = new EventDispatcher();
		
		/**
		 * 
		 */
		static public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			_dispatcher.addEventListener(type, listener, useCapture, priority);
		}
		
		/**
		 * 
		 */
		static public function dispatchEvent(evt:Event):Boolean{
			return _dispatcher.dispatchEvent(evt);
		}
		
		/**
		 * 
		 */
		static public function hasEventListener(type:String):Boolean{
			return _dispatcher.hasEventListener(type);
		}
		
		/**
		 * 
		 */
		static public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
			_dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 * 
		 */
		static public function willTrigger(type:String):Boolean {
			return _dispatcher.willTrigger(type);
		}
	}
}