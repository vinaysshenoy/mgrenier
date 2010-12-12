package  
{
	import com.mgrenier.events.CirrusEvent;
	import com.mgrenier.events.ConsoleEvent;
	import com.mgrenier.net.CirrusClient;
	import com.mgrenier.net.CirrusConnection;
	import com.mgrenier.net.CirrusHost;
	import com.mgrenier.utils.Console;
	import com.mgrenier.utils.HString;
	import com.mgrenier.utils.Input;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * Stratus test
	 * 
	 * @author Michael Grenier
	 */
	[SWF(backgroundColor="#000000", frameRate="30", width="960", height="300")]
	public class Cirrus extends Sprite
	{
		
		public function Cirrus() 
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
		
		
		
		
		
		
		protected var host:CirrusConnection;
		protected var clients:Vector.<CirrusClient> = new Vector.<CirrusClient>();
		
		
		protected function initialize ():void
		{
			//this.params = LoaderInfo(this.root.loaderInfo).parameters;
			//this.params['farID'] = this.params['farID'] || "";
		}
		
		protected function uninitialize ():void
		{
			
		}
		
		protected function command (e:ConsoleEvent):void
		{
			var cmd:Array = String(HString.trim(e.text)).split(' ');
			switch (cmd.shift())
			{
				case '/listen':
					this.host = new CirrusHost("c0c6ebef7846859742a4e2c0-7d13a55e4fba");
					this.host.addEventListener(CirrusEvent.RECEIVED_PACKET, function (e:CirrusEvent) {
						Console.log("From client", e.id, e.data);
					});
					this.host.addEventListener(CirrusEvent.CLIENT_CONNECTED, function (e:CirrusEvent) {
						Console.log("Client connected", e.id);
					});
					this.host.addEventListener(CirrusEvent.CLIENT_DISCONNECTED, function (e:CirrusEvent) {
						Console.log("Client disconnected", e.id);
					});
					break;
				case '/id':
					if (this.host)
						Console.log(this.host.getNearId());
					break;
				case '/connect':
					this.clients.push(new CirrusClient("c0c6ebef7846859742a4e2c0-7d13a55e4fba", cmd.shift() || this.host.getNearId()));
					this.clients[this.clients.length-1].addEventListener(CirrusEvent.RECEIVED_PACKET, function (e:CirrusEvent) {
						Console.log("From server", e.data);
					});
					this.clients[this.clients.length-1].addEventListener(CirrusEvent.CLIENT_CONNECTED, function (e:CirrusEvent) {
						Console.log("Client connected");
					});
					this.clients[this.clients.length-1].addEventListener(CirrusEvent.CLIENT_DISCONNECTED, function (e:CirrusEvent) {
						Console.log("Client disconnected");
					});
					break;
				case '/hostsend':
					this.host.send(cmd.join(" "));
					break;
				case '/clientsend':
					this.clients[parseInt(cmd.shift())].send(cmd.join(" "));
					break;
				case '/hostdisconnect':
					this.host.close();
					this.host = null;
					break;
				case '/clientdisconnect':
					var client:CirrusClient = this.clients.pop();
					if (client)
					{
						client.close();
						client = null;
					}
					break;
				default:
					Console.log(e.text);
			}
		}
		
	}

}