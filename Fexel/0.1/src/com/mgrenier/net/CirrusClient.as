package com.mgrenier.net
{
	import com.mgrenier.events.CirrusEvent;
	import com.mgrenier.utils.Console;
	
	import flash.events.NetStatusEvent;
	import flash.net.NetStream;

	public class CirrusClient extends CirrusConnection
	{
		protected var farId:String = "";
		protected var streamIn:NetStream;
		protected var streamOut:NetStream;
		
		/**
		 * Constructor
		 * 
		 * @param	developerKey
		 * @param	farId
		 */
		public function CirrusClient (developerKey:String, farId:String)
		{
			super(developerKey);
			this.farId = farId;
		}
		
		/**
		 * Handle Connection Success
		 * 
		 * @param	e
		 */
		override protected function handleConnectSuccess (e:NetStatusEvent):void
		{
			this.streamIn = new NetStream(this.netConnection, this.farId);
			this.streamIn.addEventListener(NetStatusEvent.NET_STATUS, this.handlerNetStatus);
			this.streamIn.play("data");
			this.streamIn.client = this;
		}
		
		/**
		 * Handle Stream Closed
		 * 
		 * @param	e
		 */
		override protected function handleStreamClosed (e:NetStatusEvent):void
		{
			this.close();
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
					
					if (this.streamOut)
						break;
					
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
					
					this.dispatchEvent(new CirrusEvent(CirrusEvent.CLIENT_CONNECTED, this.nearId));
					
					break;
				
				default:
					Console.debug(this, "Changed:", e.info.code, e.info.description);
			}
		}
		
		/**
		 * Close connection
		 * 
		 */
		override public function close ():void
		{
			if (this.streamIn)
			{
				this.streamIn.removeEventListener(NetStatusEvent.NET_STATUS, this.handlerNetStatus);
				this.streamIn.close();
			}
			this.streamIn = null;
			if (this.streamOut)
			{
				this.streamOut.removeEventListener(NetStatusEvent.NET_STATUS, this.handlerNetStatus);
				this.streamOut.close();
			}
			this.streamOut = null;
			
			this.dispatchEvent(new CirrusEvent(CirrusEvent.CLIENT_DISCONNECTED, this.nearId));
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
				this.streamOut.send("receiveData", new CirrusPacket(this.nearId, data));
		}
		
		public function receiveData (packet:*):void
		{
			this.dispatchEvent(new CirrusEvent(CirrusEvent.RECEIVED_PACKET, packet.nearId, packet.data, packet.id));
		}
	}
}