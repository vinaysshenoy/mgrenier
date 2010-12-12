package
{
	import apparat.math.FastMath;
	
	import com.mgrenier.events.CirrusEvent;
	import com.mgrenier.events.ConsoleEvent;
	import com.mgrenier.fexel.Entity;
	import com.mgrenier.fexel.View;
	import com.mgrenier.fexel.World;
	import com.mgrenier.fexel.collision.QuadTree;
	import com.mgrenier.fexel.collision.SAT;
	import com.mgrenier.fexel.collision.shape.*;
	import com.mgrenier.geom.FastRectangle2D;
	import com.mgrenier.geom.FastVec2D;
	import com.mgrenier.geom.Rectangle2D;
	import com.mgrenier.geom.Segment2D;
	import com.mgrenier.geom.Vec2D;
	import com.mgrenier.net.CirrusClient;
	import com.mgrenier.net.CirrusConnection;
	import com.mgrenier.net.CirrusHost;
	import com.mgrenier.utils.Console;
	import com.mgrenier.utils.HString;
	import com.mgrenier.utils.Input;
	
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	[SWF(backgroundColor="#ffffff", frameRate="30", width="805", height="300")]
	public class Network2 extends Sprite
	{
		public function Network2():void 
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
			
			Console.level = Console.LOG;
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
		
		
		
		protected var	world:World,
						view:View,
						yoshi1:Yoshi,
						params:Object,
						yoshis:Dictionary = new Dictionary(true);
		
		protected function initialize ():void
		{
			this.params = LoaderInfo(this.root.loaderInfo).parameters;
			this.params['farID'] = this.params['farID'] || "";
			
			world = new World();
			world.gravity.y = 0.3;
			world.friction = 0;
			world.setCollider(new SAT());
			view = new View(stage.stageWidth, stage.stageHeight);
			//view.debug = View.DEBUG_ENTITY | View.DEBUG_SHAPE | View.DEBUG_VELOCITY;
			view.debug = View.DEBUG_SHAPE;
			world.addView(view);
			this.addChildAt(view.getBuffer(), 0);
			
			yoshi1 = new Yoshi();
			world.addEntity(yoshi1);
			
			var bottom:Entity = new Entity(stage.stageWidth, 10);
			bottom.y = stage.stageHeight - 5;
			bottom.setShape(new Box(0, 0, bottom.width, bottom.height));
			world.addEntity(bottom);
			
			var top:Entity = new Entity(stage.stageWidth, 10);
			top.y = 5;
			top.setShape(new Box(0, 0, top.width, top.height));
			world.addEntity(top);
			
			var right:Entity = new Entity(10, stage.stageHeight);
			right.x = 5;
			right.setShape(new Box(0, 0, right.width, right.height));
			world.addEntity(right);
			
			var left:Entity = new Entity(10, stage.stageHeight);
			left.x = stage.stageWidth - 5;
			left.setShape(new Box(0, 0, left.width, left.height));
			world.addEntity(left);
			
			world.setBroadphase(new QuadTree(2));
			
			this.addEventListener(Event.ENTER_FRAME, this.enterFrame);
			
			if (this.params['farID'] != "")
			{
				this.client = new CirrusClient(this.devKey, this.params['farID']);
				this.client.addEventListener(CirrusEvent.RECEIVED_PACKET, this.clientPacketReceived);
			}
		}
		
		protected function enterFrame (e:Event = null):void
		{
			world.step(stage.frameRate);
			
			//var con:CirrusConnection = this.host ? this.host : this.client;
			//if (con)
			//	con.send({position:{x:yoshi1.x, y:yoshi1.y}, velocity:yoshi1.velocity, grounded:yoshi1.grounded, lastDir:yoshi1.lastDir});
			if (this.host)
			{
				this.host.send({
					type: 'update',
					list: this.updateYoshis()
				});
			}
			if (this.client)
			{
				this.client.send({
					type: 'update',
					data: {
						position: {x: yoshi1.x, y: yoshi1.y},
						velocity: {x: yoshi1.velocity.x, y: yoshi1.velocity.y},
						grounded: yoshi1.grounded,
						lastDir: yoshi1.lastDir
					}
				});
			}
		}
		
		protected function uninitialize ():void
		{
			this.removeEventListener(Event.ENTER_FRAME, this.enterFrame);
			
			this.removeChild(view.getBuffer());
			
			world.dispose();
			world = null;
			view = null;
		}
		
		protected var devKey:String = "c0c6ebef7846859742a4e2c0-7d13a55e4fba";
		protected var host:CirrusHost;
		protected var client:CirrusClient;
		
		protected function updateYoshis (exeptId:int = -100):Object
		{
			var yoshis:Object = new Object(),
				yoshi:Yoshi;
			yoshis[-1] = {
				position: {x: yoshi1.x, y: yoshi1.y},
				velocity: {x: yoshi1.velocity.x, y: yoshi1.velocity.y},
				grounded: yoshi1.grounded,
				lastDir: yoshi1.lastDir
			};
			for (var id:Object in this.yoshis)
				if (int(id) != exeptId)
				{
					yoshi = Yoshi(this.yoshis[id]);
					yoshis[id] = {
						position: {x: yoshi.x, y: yoshi.y},
						velocity: {x: yoshi.velocity.x, y: yoshi.velocity.y},
						grounded: yoshi.grounded,
						lastDir: yoshi.lastDir
					};
				}
			
			return yoshis;
		}
		
		protected function command (e:ConsoleEvent):void
		{
			var cmd:Array = String(HString.trim(e.text)).split(' ');
			switch (cmd.shift())
			{
				case '/id':
					if (this.host)
						Console.log(this.host.getNearId());
					break;
				case '/listen':
					this.host = new CirrusHost(this.devKey);
					this.host.addEventListener(CirrusEvent.RECEIVED_PACKET, this.hostPacketReceived);
					this.host.addEventListener(CirrusEvent.CLIENT_CONNECTED, this.hostClientConnected);
					this.host.addEventListener(CirrusEvent.CLIENT_DISCONNECTED, this.hostClientDisconnected);
					
					break;
				case '/connect':
					this.client = new CirrusClient(this.devKey, cmd.shift() || this.host.getNearId());
					this.client.addEventListener(CirrusEvent.RECEIVED_PACKET, this.clientPacketReceived);
					break;
			}
		}
		
		protected function hostClientConnected (e:CirrusEvent)
		{
			Console.log("Client connected", e.id);
			
			// New Client
			yoshis[e.id] = new Yoshi(true);
			world.addEntity(Entity(yoshis[e.id]));
			
			this.host.sendTo(e.id, {
				type: 'id',
				id: e.id
			});
			
			this.host.sendTo(e.id, {
				type: 'list',
				list: updateYoshis(e.id)
			});
		}
		
		protected function hostClientDisconnected (e:CirrusEvent)
		{
			Console.log("Client disconnected", e.id);
		}
		
		protected function hostPacketReceived (e:CirrusEvent)
		{
			//Console.log("From client", e.id, e.data);
			
			switch (e.data.type)
			{
				case 'update':
					
					yoshis[e.id].x = e.data.data.position.x;
					yoshis[e.id].y = e.data.data.position.y;
					yoshis[e.id].velocity.x = e.data.data.velocity.x;
					yoshis[e.id].velocity.y = e.data.data.velocity.y;
					yoshis[e.id].grounded = e.data.data.grounded;
					yoshis[e.id].lastDir = e.data.data.lastDir;
					
					break;
			}
		}
		
		protected var myId:int;
		
		protected function clientPacketReceived (e:CirrusEvent)
		{
			//Console.log("From Server", e.id, e.data);
			
			switch (e.data.type)
			{
				case 'id':
					this.myId = e.data.id;
					break;
				case 'list':
				case 'update':
					for (var id:Object in e.data.list)
						if (int(id) != this.myId)
						{
							if (!yoshis[int(id)])
							{
								yoshis[int(id)] = new Yoshi(true);
								world.addEntity(Entity(yoshis[int(id)]));
							}
							
							if (yoshis[int(id)])
							{
								yoshis[int(id)].x = e.data.list[id].position.x;
								yoshis[int(id)].y = e.data.list[id].position.y;
								yoshis[int(id)].velocity.x = e.data.list[id].velocity.x;
								yoshis[int(id)].velocity.y = e.data.list[id].velocity.y;
								yoshis[int(id)].grounded = e.data.list[id].grounded;
								yoshis[int(id)].lastDir = e.data.list[id].lastDir;
							}
						}
					break;
			}
			
		}
		
	}
}

import apparat.math.FastMath;

import com.mgrenier.fexel.Entity;
import com.mgrenier.fexel.collision.ContactInfo;
import com.mgrenier.fexel.collision.shape.*;
import com.mgrenier.fexel.display.*;
import com.mgrenier.geom.Rectangle2D;
import com.mgrenier.geom.Vec2D;
import com.mgrenier.utils.Input;

class Yoshi extends AnimatedSprite
{
	[Embed(source="assets/YoshiSprite.gif")]
	protected var image:Class;
	
	protected var networked:Boolean;
	
	public function Yoshi (networked:Boolean = false)
	{
		super(48, 48, 12);
		this.networked = networked;
		
		this.setSource(this.image);
		this.addAnimation("walkRight", [1, 2, 3, 4, 5, 6, 7, 8, 9], true);
		this.addAnimation("walkLeft", [11, 12, 13, 14, 15, 16, 17, 18, 19], true);
		this.addAnimation("runRight", [21, 22, 23, 24], true);
		this.addAnimation("runLeft", [31, 32, 33, 34], true);
		this.addAnimation("idleRight", [10], false);
		this.addAnimation("idleLeft", [20], false);
		this.addAnimation("jumpRight", [25], false);
		this.addAnimation("jumpLeft", [35], false);
		this.addAnimation("fallRight", [26], false);
		this.addAnimation("fallLeft", [36], false);
		this.play(this.lastAnim);
		
		/*var polygon:Vector.<Vec2D> = new Vector.<Vec2D>();
		polygon.push(new Vec2D(14, 19));
		//polygon.push(new Vec2D(42, 27));
		polygon.push(new Vec2D(42, 19));
		polygon.push(new Vec2D(22, 46));
		yoshi.setShape(new Polygon(polygon));*/
		this.setShape(new Circle(26, 30, 16));
		//yoshi.setShape(new Box(0, 0, 48, 48));
		this.dynamic = true;
		this.friction = 0;
		this.bounce = 0;
		this.mass = 1000;
		this.x = 50 + (Math.random() * 400);
		this.y = 200;
	}
	
	public var lastDir:int = 1; // -1 = left, 1 = right
	protected var lastAnim:String = "fallRight";
	
	override public function step(frameRate:int):void
	{
		var stepMove:Number = 5,
			h:Vec2D = this.velocity.copy().project(world.gravity.copy().perp()),
			v:Vec2D = this.velocity.copy().project(world.gravity),
			gravity:Vec2D = this.getWorld().gravity.copy(),
			velocity:Vec2D = this.velocity.copy(),
			anim:String = "",
			left:Boolean = !networked && Input.keyState(Input.A),
			right:Boolean = !networked && Input.keyState(Input.D),
			jump:Boolean = !networked && Input.keyState(Input.W),
			direction:int = left && right || !left && !right ? lastDir : (left ? -1 : 1);
		
		anim = direction == 1 ? "Right" : "Left";
		if (!grounded)
		{
			if (right)
				this.velocity.x += FastMath.min(h.x < 0 ? stepMove : stepMove - FastMath.abs(h.x), stepMove)*0.125;
			if (left)
				this.velocity.x -= FastMath.min(h.x > 0 ? stepMove : stepMove - FastMath.abs(h.x), stepMove)*0.125;
			
			if (gravity.negate().normalize().angleBetween(velocity.normalize(), true) < 90)
				anim = "jump"+anim;
			else
				anim = "fall"+anim;
		}
		else
		{
			if (right)
				this.velocity.x += FastMath.min(h.x < 0 ? stepMove : stepMove - FastMath.abs(h.x), stepMove);
			if (left)
				this.velocity.x -= FastMath.min(h.x > 0 ? stepMove : stepMove - FastMath.abs(h.x), stepMove);
			if (jump)
				this.velocity.y -= FastMath.min(v.y > 0 ? stepMove : stepMove - FastMath.abs(v.y), stepMove);
			
			if (velocity.length() < 0.1)
				anim = "idle"+anim;
			else
				anim = "run"+anim;
		}
		
		if (anim != this.lastAnim)
			this.play(anim);
		
		this.lastAnim = anim;
		this.lastDir = direction;
		
		
		this.sleeping = 0;
		super.step(frameRate);
	}
	
	public var grounded:Boolean = false;
	protected var groundEntity:Entity;
	
	protected function handleGround (e:Entity, point:Vec2D):void
	{
		var gravity:Vec2D = this.getWorld().gravity.copy(),
			pos:Vec2D = this.getPosition(),
			center:Vec2D = this.getShape().getCenter();
		center.add(pos.x, pos.y);
		if (gravity.normalize().angleBetween(point.copy().subtractVec(center).normalize(), true) < 30)
		{
			this.grounded = true;
			this.groundEntity = e;
		}
	}
	
	override public function handlerNewContact(e:Entity, c:ContactInfo):void
	{
		this.handleGround(e, c.point);
	}
	
	override public function handlerPersistingContact(e:Entity, c:ContactInfo):void
	{
		this.handleGround(e, c.point);
	}
	
	override public function handlerDeadContact(e:Entity):void
	{
		if (e == this.groundEntity)
		{
			this.groundEntity = null;
			this.grounded = false;
		}
	}
	
}