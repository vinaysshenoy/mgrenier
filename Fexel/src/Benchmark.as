package 
{
	import com.mgrenier.events.ConsoleEvent;
	import com.mgrenier.fexel.World;
	import com.mgrenier.fexel.collision.QuadTree;
	import com.mgrenier.fexel.collision.SAT;
	import com.mgrenier.fexel.display.Text;
	import com.mgrenier.fexel.View;
	import com.mgrenier.geom.Rectangle2D;
	import com.mgrenier.utils.Console;
	import com.mgrenier.utils.Input;
	
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Gern
	 */
	[SWF(backgroundColor="#ffffff", frameRate="30", width="805", height="485")]
	public class Benchmark extends flash.display.Sprite 
	{
		protected var params:Object;
		
		public function Benchmark():void 
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
		
		
		
		
		protected var w:World;
		protected var v1:View;
		protected var vt1:Text;
		protected var v2:View;
		protected var vt2:Text;
		protected var v3:View;
		protected var vt3:Text;
		protected var v4:View;
		protected var vt4:Text;
		protected var y1:Yoshi;
		protected var yt1:Text;
		protected var bg:Background;
		
		protected function initialize ():void
		{
			w = new World();
			w.setActiveRect(new Rectangle2D());
			
			v1 = new View(800, 480);
			v2 = new View(400, 240);
			v3 = new View(400, 240);
			v4 = new View(800, 480);
			
			//v1.getBuffer().x = 200;
			//v1.getBuffer().y = 120;
			
			/*v2.setCamera(400, 0);
			
			v3.setCamera(0, 240);
			
			v2.getBuffer().x = v4.getBuffer().x = 405;
			v3.getBuffer().y = v4.getBuffer().y = 245;*/
			
			bg = new Background();
			w.addEntity(bg);
			
			var yt:Yoshi;
			for (var n:int = 200; n >= 0; n--)
			{
				yt = new Yoshi();
				yt.x = Math.random() * stage.stageWidth;
				yt.y = Math.random() * stage.stageHeight;
				w.addEntity(yt);
			}
			
			y1 = new Yoshi();
			w.addEntity(y1);
			
			yt1 = new Text(60);
			w.addEntity(yt1);
			
			vt1 = new Text(400);
			v1.getHud().addEntity(vt1);
			vt2 = new Text(400);
			v2.getHud().addEntity(vt2);
			vt3 = new Text(400);
			v3.getHud().addEntity(vt3);
			vt4 = new Text(400);
			v4.getHud().addEntity(vt4);
			
			//w.addView(v1);
			//w.addView(v2);
			//w.addView(v3);
			w.addView(v4);
			
			this.addChildAt(v4.getBuffer(), 0);
			//this.addChildAt(v3.getBuffer(), 0);
			//this.addChildAt(v2.getBuffer(), 0);
			//this.addChildAt(v1.getBuffer(), 0);
			
			w.setBroadphase(new QuadTree(4));
			
			this.addEventListener(Event.ENTER_FRAME, this.enterFrame);
		}
		
		protected function uninitialize ():void
		{
			this.removeEventListener(Event.ENTER_FRAME, this.enterFrame);
			
			this.removeChild(v1.getBuffer());
			this.removeChild(v2.getBuffer());
			
			w.dispose();
			w = null;
			
			v1 = null;
			v2 = null;
			v3 = null;
			v4 = null;
			
			y1.dispose();
			y1 = null;
			
			yt1.dispose();
			yt1 = null;
			
			vt1.dispose();
			vt1 = null;
			vt2.dispose();
			vt2 = null;
			vt3.dispose();
			vt3 = null;
			vt4.dispose();
			vt4 = null;
		}
		
		protected function enterFrame (e:Event = null):void
		{
			if (Input.keyState(Input.NUMPAD_ADD))
				v4.zoom += 0.2;
			if (Input.keyState(Input.NUMPAD_SUBTRACT))
				v4.zoom -= 0.2;
			
			var step:int = 8, //Math.ceil(8 / v4.getRealZoom()),
				cam:Rectangle2D = v4.getCamera();
			
			if (Input.keyState(Input.A))
				y1.x -= step;
			if (Input.keyState(Input.D))
				y1.x += step;
			if (Input.keyState(Input.W))
				y1.y -= step;
			if (Input.keyState(Input.S))
				y1.y += step;
			
			v4.setCamera(y1.x + 15 - cam.width / 2, y1.y + 10 - cam.height / 2);
			
			w.setActiveRect(cam);
			
			
			
			
			yt1.x = y1.x + 20 + yt1.width / 2;
			yt1.y = y1.y;
			yt1.setText(y1.x +", " + y1.y);
			
			vt1.setText(v1.getCamera().x +", " + v1.getCamera().y);
			vt2.setText(v2.getCamera().x +", " + v2.getCamera().y);
			vt3.setText(v3.getCamera().x +", " + v3.getCamera().y);
			vt4.setText(v4.getCamera().x +", " + v4.getCamera().y);
			
			w.step(stage.frameRate);
			
			if (Input.keyState(Input.SPACE))
				Console.log("Overlap "+ w.getBroadphase().overlapEntity(y1).length);
			
			if (Input.mouseState)
			{
				var mouse:Point = Input.mousePosition,
					offset:Rectangle2D = v4.getCamera(),
					zoom:Number = v4.getRealZoom();
				mouse.x = Math.floor(mouse.x / zoom);
				mouse.y = Math.floor(mouse.y / zoom);
				mouse.offset(offset.x, offset.y);
				//w.getBroadphase().overlapRectangle(new Projection2D(mouse.x, mouse.y, 1, 1));
				//Console.log("Click "+ mouse +" "+ w.getBroadphase().overlapRectangle(new Projection2D(mouse.x, mouse.y, 1, 1)));
			}
		}
		
		protected function command (e:ConsoleEvent):void
		{
			switch (e.text)
			{
				case '/reset':
					this.uninitialize();
					this.initialize();
					break;
				default:
					//y1.play(e.text);
			}
		}
		
	}
	
}
import com.mgrenier.fexel.collision.shape.Box;
import com.mgrenier.fexel.display.*;
import com.mgrenier.geom.Rectangle2D;
import com.mgrenier.utils.Input;

class Yoshi extends AnimatedSprite
{
	[Embed(source="assets/YoshiSprite.gif")]
	protected var image:Class;
	
	
	public function Yoshi ()
	{
		super(48, 48, 30);
		
		this.setShape(new Box(9, 10, 36, 38));
		//this.setAABB(new Projection2D(0, 0, 48, 48));
		
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
		this
		.play("runRight", 6 + Math.floor(Math.random() * 4))
			.delay(Math.floor(Math.random() * 30));
	}
	
}

class Background extends TiledImage
{
	[Embed(source="assets/pattern.gif")]
	protected var image:Class;
	
	public function Background ()
	{
		super(2000, 2000);
		
		this.setTiledSource(this.image);
	}
}


