package com.mgrenier.events
{
	import com.mgrenier.net.CirrusPacket;
	
	import flash.events.Event;
	
	public class CirrusEvent extends Event
	{
		static public const CLIENT_CONNECTED:String = "CONNECTED";
		static public const CLIENT_DISCONNECTED:String = "CLOSED";
		static public const RECEIVED_PACKET:String = "PACKET_RECEIVED";
		
		public var id:int;
		public var nearId:String;
		public var data:*;
		
		public function CirrusEvent(type:String, nearId:String, data:* = null, id:int = -1)
		{
			super(type, false, false);
			this.id = id;
			this.nearId = nearId;
			this.data = data;
		}
	}
}