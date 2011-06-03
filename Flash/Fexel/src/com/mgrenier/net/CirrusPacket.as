package com.mgrenier.net
{
	public class CirrusPacket
	{
		public var id:int;
		public var nearId:String;
		public var data:*;
		
		public function CirrusPacket(nearId:String, data:*, id:int = -1)
		{
			this.id = id;
			this.nearId = nearId;
			this.data = data;
		}
	}
}