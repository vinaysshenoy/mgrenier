package com.mgrenier.net
{
	import com.mgrenier.events.CirrusEvent;
	import com.mgrenier.utils.Console;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.NetStreamInfo;

	public class CirrusConnection implements IEventDispatcher
	{
		protected const ADDRESS:String = "rtmfp://stratus.adobe.com/";
		protected var developerKey:String;
		
		protected var netConnection:NetConnection;
		public function getConnection():NetConnection { return this.netConnection; }
		
		protected var nearId:String = "";
		public function getNearId():String { return this.nearId; }
		
		/**
		 * Constructor
		 * 
		 * @param	developerKey
		 */
		public function CirrusConnection(developerKey:String)
		{
			this.developerKey = developerKey;
			
			this.netConnection = new NetConnection();
			this.netConnection.addEventListener(NetStatusEvent.NET_STATUS, this.handlerNetConnection);
			this.netConnection.connect(ADDRESS + this.developerKey);
		}
		
		/**
		 * Handle Connection changed
		 * 
		 * @param	e
		 */
		final protected function handlerNetConnection (e:NetStatusEvent):void
		{
			switch (e.info.code)
			{
				case "NetConnection.Connect.Success":
					this.nearId = this.netConnection.nearID;
					this.handleConnectSuccess(e);
					break;
				case "NetStream.Connect.Closed":
					this.handleStreamClosed(e);
					break;
				default:
					Console.debug(this, "handlerNetConnection:", e.info.code, e.info.description);
			}
		}
		
		/**
		 * Handle Connection Success
		 * 
		 * @param	e
		 */
		protected function handleConnectSuccess (e:NetStatusEvent):void
		{
		}
		
		/**
		 * Handle Stream Closed
		 * 
		 * @param	e
		 */
		protected function handleStreamClosed (e:NetStatusEvent):void
		{
		}
		
		/**
		 * Close connection
		 * 
		 */
		public function close ():void
		{
			if (this.netConnection)
			{
				this.netConnection.removeEventListener(NetStatusEvent.NET_STATUS, this.handlerNetConnection);
				this.netConnection.close();
			}
			this.netConnection = null;
			this._dispatcher = null;
		}
		
		/**
		 * Send packet
		 * 
		 * @param	packet
		 */
		public function send (packet:*):void
		{
		}
		
		
		private var _dispatcher:EventDispatcher = new EventDispatcher();
		
		/**
		 * 
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			_dispatcher.addEventListener(type, listener, useCapture, priority);
		}
		
		/**
		 * 
		 */
		public function dispatchEvent(evt:Event):Boolean{
			return _dispatcher.dispatchEvent(evt);
		}
		
		/**
		 * 
		 */
		public function hasEventListener(type:String):Boolean{
			return _dispatcher.hasEventListener(type);
		}
		
		/**
		 * 
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
			_dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 * 
		 */
		public function willTrigger(type:String):Boolean {
			return _dispatcher.willTrigger(type);
		}
	}
}