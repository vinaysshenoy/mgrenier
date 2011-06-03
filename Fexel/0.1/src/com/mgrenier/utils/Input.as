package com.mgrenier.utils
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	/**
	 * Track Input (mouse/keyboard)
	 * 
	 * Use : addChild( Input.getInstance() );
	 */
	public class Input extends Sprite
	{
		static private var		_instance:Input;
		
		static private var		_dispatcher:EventDispatcher = new EventDispatcher();
		
		protected var			_sprite:Sprite;
		public function get sprite():Sprite { return this._sprite; }
		
		protected var			_code:Array;
		public function get code():Array { return this._code; }
		
		static protected var	_ascii:Dictionary;
		static public function get ascii():Dictionary { return Input._ascii; }
		
		protected var			_mouseOutOfStage:Boolean = false;
		
		protected var			_mouseDown:Boolean = false;
		
		protected var			_mousePosition:Point = new Point(0, 0);
		
		static public var		enable:Boolean = true;
		
		/**
		 * Singleton
		 */
		static public function getInstance ():Input
		{
			if (!Input._instance)
				Input._instance = new Input();
			return Input._instance;
		}
		
		/**
		 * 
		 */
		static public function keyState(key:*):Boolean
		{
			var instance:Input = Input.getInstance();
			if (key is Number)
				return instance.code[key];
			else if (key is String && Input.ascii[key])
				return instance.code[Input.ascii[key]];
			return false;
		}
		
		/**
		 * 
		 */
		static public function get mouseState():Boolean
		{
			return Input.getInstance()._mouseDown;
		}
		
		/**
		 * 
		 */
		static public function get mousePosition():Point
		{
			return Input.getInstance()._mousePosition.clone();
		}
		
		/**
		 * 
		 */
		static public function get mouseOut():Boolean
		{
			return Input.getInstance()._mouseOutOfStage;
		}
		
		
		/**
		 * Constructor
		 */
		public function Input()
		{
			this.name = 'INPUT';
			
			this.addEventListener(Event.ADDED_TO_STAGE, this.initialize, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, this.uninitialize, false, 0, true);
			
			Input._ascii = new Dictionary(true);
			this._code = new Array(256);
			
			for (var i:int = 0, n:int = 256; i<n; i++)
			{
				Input._ascii[String.fromCharCode(i)] = i;
				this._code[i] = false;
			}
		}
		
		/**
		 * Initialize listeners
		 */
		protected function initialize (...args):void
		{
			this.uninitialize();
			
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.keyHandler);
			this.stage.addEventListener(KeyboardEvent.KEY_UP, this.keyHandler);
			
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, this.mouseHandler);
			this.stage.addEventListener(Event.MOUSE_LEAVE, this.mouseHandler);
		}
		
		/**
		 * Uninitialize listeners
		 */
		protected function uninitialize (...args):void
		{
			this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.keyHandler);
			this.stage.removeEventListener(KeyboardEvent.KEY_UP, this.keyHandler);
			
			this.stage.removeEventListener(MouseEvent.CLICK, this.mouseHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseHandler);
			this.stage.removeEventListener(Event.MOUSE_LEAVE, this.mouseHandler);
		}
		
		/**
		 * 
		 */
		protected function keyHandler (e:KeyboardEvent):void
		{
			if (Input.enable)
			{
				if (e.type == KeyboardEvent.KEY_DOWN)
					this._code[e.keyCode] = true;
				else
					this._code[e.keyCode] = false;
			}
			Input._dispatcher.dispatchEvent(e);
		}
		
		/**
		 * 
		 */
		protected function mouseHandler (e:Event):void
		{
			if (e.type == Event.MOUSE_LEAVE)
			{
				this._mouseOutOfStage = true;
				this._mouseDown = false;
			}
			else
			{
				this._mouseOutOfStage = false;
				
				if (e.type == MouseEvent.MOUSE_UP)
					this._mouseDown = false;
				else if (e.type == MouseEvent.MOUSE_DOWN)
					this._mouseDown = true;
				else if (e.type == MouseEvent.MOUSE_MOVE)
				{
					this._mousePosition.x = (e as MouseEvent).stageX;
					this._mousePosition.y = (e as MouseEvent).stageY;
				}
			}
			Input._dispatcher.dispatchEvent(e);
		}
		
		/**
		 * 
		 */
		static public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			Input._dispatcher.addEventListener(type, listener, useCapture, priority);
		}

		/**
		 * 
		 */
		static public function dispatchEvent(evt:Event):Boolean{
			return Input._dispatcher.dispatchEvent(evt);
		}

		/**
		 * 
		 */
		static public function hasEventListener(type:String):Boolean{
			return Input._dispatcher.hasEventListener(type);
		}
		
		/**
		 * 
		 */
		static public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
			Input._dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 * 
		 */
		static public function willTrigger(type:String):Boolean {
			return Input._dispatcher.willTrigger(type);
		}
		
		public static const LEFT:int = 37;
		public static const UP:int = 38;
		public static const RIGHT:int = 39;
		public static const DOWN:int = 40;
		
		public static const ENTER:int = 13;
		public static const CONTROL:int = 17;
		public static const SPACE:int = 32;
		public static const SHIFT:int = 16;
		public static const BACKSPACE:int = 8;
		public static const CAPS_LOCK:int = 20;
		public static const DELETE:int = 46;
		public static const END:int = 35;
		public static const ESCAPE:int = 27;
		public static const HOME:int = 36;
		public static const INSERT:int = 45;
		public static const TAB:int = 9;
		public static const PAGE_DOWN:int = 34;
		public static const PAGE_UP:int = 33;
		
		public static const A:int = 65;
		public static const B:int = 66;
		public static const C:int = 67;
		public static const D:int = 68;
		public static const E:int = 69;
		public static const F:int = 70;
		public static const G:int = 71;
		public static const H:int = 72;
		public static const I:int = 73;
		public static const J:int = 74;
		public static const K:int = 75;
		public static const L:int = 76;
		public static const M:int = 77;
		public static const N:int = 78;
		public static const O:int = 79;
		public static const P:int = 80;
		public static const Q:int = 81;
		public static const R:int = 82;
		public static const S:int = 83;
		public static const T:int = 84;
		public static const U:int = 85;
		public static const V:int = 86;
		public static const W:int = 87;
		public static const X:int = 88;
		public static const Y:int = 89;
		public static const Z:int = 90;
		
		public static const F1:int = 112;
		public static const F2:int = 113;
		public static const F3:int = 114;
		public static const F4:int = 115;
		public static const F5:int = 116;
		public static const F6:int = 117;
		public static const F7:int = 118;
		public static const F8:int = 119;
		public static const F9:int = 120;
		public static const F10:int = 121;
		public static const F11:int = 122;
		public static const F12:int = 123;
		public static const F13:int = 124;
		public static const F14:int = 125;
		public static const F15:int = 126;
		
		public static const DIGIT_0:int = 48;
		public static const DIGIT_1:int = 49;
		public static const DIGIT_2:int = 50;
		public static const DIGIT_3:int = 51;
		public static const DIGIT_4:int = 52;
		public static const DIGIT_5:int = 53;
		public static const DIGIT_6:int = 54;
		public static const DIGIT_7:int = 55;
		public static const DIGIT_8:int = 56;
		public static const DIGIT_9:int = 57;
		
		public static const NUMPAD_0:int = 96;
		public static const NUMPAD_1:int = 97;
		public static const NUMPAD_2:int = 98;
		public static const NUMPAD_3:int = 99;
		public static const NUMPAD_4:int = 100;
		public static const NUMPAD_5:int = 101;
		public static const NUMPAD_6:int = 102;
		public static const NUMPAD_7:int = 103;
		public static const NUMPAD_8:int = 104;
		public static const NUMPAD_9:int = 105;
		public static const NUMPAD_ADD:int = 107;
		public static const NUMPAD_DECIMAL:int = 110;
		public static const NUMPAD_DIVIDE:int = 111;
		public static const NUMPAD_ENTER:int = 108;
		public static const NUMPAD_MULTIPLY:int = 106;
		public static const NUMPAD_SUBTRACT:int = 109;
		
	}
}