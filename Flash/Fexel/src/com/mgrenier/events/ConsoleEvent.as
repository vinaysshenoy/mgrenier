package com.mgrenier.events
{
	import flash.events.Event;
	
	public class ConsoleEvent extends Event
	{
		static public const COMMAND:String = 'COMMAND';
		
		protected var _text:String;
		public function get text():String { return _text; }
		
		public function ConsoleEvent(type:String, text:String)
		{
			this._text = text;
			super(type, false, false);
		}
	}
}