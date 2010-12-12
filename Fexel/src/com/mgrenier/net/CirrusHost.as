package com.mgrenier.net
{
	import com.mgrenier.events.CirrusEvent;
	import com.mgrenier.utils.Console;
	
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Dictionary;

	public class CirrusHost extends CirrusConnection
	{
		protected var farId:String = "";
		protected var streamOut:NetStream;
		protected var uniqueId:int = 0;
		protected var streamIn:Dictionary = new Dictionary(true);
		
		/**
		 * Constructor
		 * 
		 * @param	developerKey
		 */
		public function CirrusHost(developerKey:String)
		{
			super(developerKey);
		}
		
		/**
		 * Handle Connection Success
		 * 
		 * @param	e
		 */
		override protected function handleConnectSuccess (e:NetStatusEvent):void
		{
			this.streamOut = new NetStream(this.netConnection, NetStream.DIRECT_CONNECTIONS);
			this.streamOut.addEventListener(NetStatusEvent.NET_STATUS, this.handlerNetStatus);
			this.streamOut.publish("data");
			
			var handleClient:Object = new Object();
			handleClient.cirrusConnection = this;
			handleClient.onPeerConnect = function (caller:NetStream):Boolean {
				this.cirrusConnection.farId = caller.farID;
				return true;
			}
			this.streamOut.client = handleClient;
		}
		
		/**
		 * Handle Connection changed
		 * 
		 * @param	e
		 */
		protected function handlerNetStatus (e:NetStatusEvent):void
		{
			switch (e.info.code)
			{
				case "NetStream.Play.Start":
					
					if (this.farId == "")
						break;
					
					//Console.log(this, "Client connected:", this.streamOut.peerStreams.length, this.farId);
					
					// Open stream to new connection
					var streamIn:NetStream = new NetStream(this.netConnection, this.farId);
					streamIn.addEventListener(NetStatusEvent.NET_STATUS, this.handlerNetStatus);
					streamIn.play("data");
					streamIn.client = this;
					
					var id:int = this.uniqueId++;
					this.streamIn[id] = streamIn;
					
					this.dispatchEvent(new CirrusEvent(CirrusEvent.CLIENT_CONNECTED, this.farId, null, id));
					
					
					// Forget new connection
					this.farId = "";
					break;
				
				case "NetStream.Play.UnpublishNotify":
					
					var id:int = this.clientIdFromFarId(NetStream(e.currentTarget).farID),
						stream:NetStream = NetStream(this.streamIn[id]);
					this.dispatchEvent(new CirrusEvent(CirrusEvent.CLIENT_DISCONNECTED, e.info.farId, null, id));
					
					stream.removeEventListener(NetStatusEvent.NET_STATUS, this.handlerNetStatus);
					stream.close();
					stream = null;
					delete this.streamIn[id];
					
				default:
					//Console.log(this, "Changed:", e.info.code, e.info.description);
			}
		}
		
		/**
		 * Close connection
		 * 
		 */
		override public function close ():void
		{
			var stream:NetStream, i:int;
			
			if (this.streamIn)
			{
				for (var id:Object in this.streamIn)
				{
					stream = this.streamIn[id];
					stream.removeEventListener(NetStatusEvent.NET_STATUS, this.handlerNetStatus);
					stream.close();
					stream = null;
					delete this.streamIn[id];
				}
			}
			this.streamIn = null;
			
			if (this.streamOut)
			{
				for (i = this.streamOut.peerStreams.length; i > 0; --i)
				{
					stream = NetStream(this.streamOut.peerStreams.pop());
					stream.close();
					stream = null;
				}
				this.streamOut.removeEventListener(NetStatusEvent.NET_STATUS, this.handlerNetStatus);
				this.streamOut.close();
			}
			this.streamOut = null;
			
			super.close();
		}
		
		/**
		 * Send packet
		 * 
		 * @param	packet
		 */
		override public function send (data:*):void
		{
			if (this.streamOut)
				this.streamOut.send("receiveData", new CirrusPacket(null, data));
		}
		
		/**
		 * Handle	packet
		 */
		public function receiveData (packet:*):void
		{
			this.dispatchEvent(new CirrusEvent(CirrusEvent.RECEIVED_PACKET, packet.nearId, packet.data, this.clientIdFromFarId(packet.nearId)));
		}

		private function clientIdFromFarId (farId:String):int
		{
			for (var id:Object in this.streamIn)
				if (NetStream(this.streamIn[id]).farID == farId)
				{
					return int(id);
				}
			return -1;
		}
	}
}