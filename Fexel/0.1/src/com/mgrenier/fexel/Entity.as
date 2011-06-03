package com.mgrenier.fexel 
{
	import com.mgrenier.fexel.fexel;
	use namespace fexel;
	
	import com.mgrenier.fexel.collision.IBroadphase;
	import com.mgrenier.fexel.collision.shape.AShape;
	import com.mgrenier.geom.Rectangle2D;
	import com.mgrenier.geom.Vec2D;
	import com.mgrenier.utils.Disposable;
	
	import flash.display.BitmapData;
	import flash.utils.getQualifiedClassName;
	import flash.utils.Dictionary;
	import com.mgrenier.fexel.collision.ContactInfo;
	
	/**
	 * World's base object
	 * 
	 * @author Michael Grenier
	 */
	public class Entity implements Disposable
	{
		static protected var total:int = 0;
		protected var _id:int = 0;
		public function get id():int { return this._id; }
		
		protected var world:World;
		internal var updated:Boolean = false;
		
		public var dynamic:Boolean = false;
		public var sleeping:int = 0;
		public var active:Boolean = true;
		public var visible:Boolean = true;
		
		fexel var initialVelocity:Vec2D = new Vec2D();
		public var velocity:Vec2D = new Vec2D();;
		public var sensor:Boolean = false;
		public var group:uint = 0x1;
		public var mass:Number = 1;
		public var friction:Number = 1;
		public var bounce:Number = 0;
		
		protected var _x:Number;
		public function get x():Number { return this._x; }
		public function set x(v:Number):void {
			this._x = v;
			this.internalUpdatePosition();
		}
		
		protected var _y:Number;
		public function get y():Number { return this._y; }
		public function set y(v:Number):void {
			this._y = v;
			this.internalUpdatePosition();
		}
		
		protected var _width:Number;
		public function get width():Number { return this._width; }
		fexel function setWidth(w:Number):void
		{
			this.x += Math.floor((w / 2) - (this.width / 2));
			this._width = w;
			this.internalUpdateSize();
		}
		
		protected var _height:Number;
		public function get height():Number { return this._height; }
		fexel function setHeight(h:Number):void
		{
			this.y += Math.floor((h / 2) - (this.height / 2));
			this._height = h;
			this.internalUpdateSize();
		}
		
		protected var _scaleX:Number;
		public function get scaleX():Number { return this._scaleX; }
		public function set scaleX(v:Number):void {
			this._scaleX = v;
			this.internalUpdateSize();
		}
		
		protected var _scaleY:Number;
		public function get scaleY():Number { return this._scaleY; }
		public function set scaleY(v:Number):void {
			this._scaleY = v;
			this.internalUpdateSize();
		}
		
		
		public var parralax:Vec2D;
		
		protected var shape:AShape;
		internal var newContact:Dictionary;
		internal var persistedContact:Dictionary;
		internal var deadContact:Dictionary;
		internal var frameContact:Dictionary;
		
		/**
		 * To String
		 * 
		 * @return
		 */
		public function toString ():String
		{
			var klass:String = getQualifiedClassName(this);
			
			return "[entity "+ klass +"(id:"+ this.id +") ]";
		}
		
		/**
		 * Constructor
		 * 
		 * @param	w
		 * @param	h
		 */
		public function Entity(w:Number, h:Number) 
		{
			this._id = Entity.total++;
			
			this._width = w;
			this._height = h;
			this._x = w * 0.5;
			this._y = h * 0.5;
			this._scaleX = 1;
			this._scaleY = 1;
			this.parralax = new Vec2D(1, 1);
			this.newContact = new Dictionary(true);
			this.persistedContact = new Dictionary(true);
			this.deadContact = new Dictionary(true);
			this.frameContact = new Dictionary(true);
		}
		
		/**
		 * Dispose Entity
		 */
		public function dispose ():void
		{
			if (this.shape)
			{
				this.shape.dispose();
				this.shape = null;
			}
		}
		
		/**
		 * Step forward !
		 */
		public function step (frameRate:int):void
		{
		}
		
		/**
		 * Render
		 */
		public function render (cam:Rectangle2D, buffer:BitmapData, frameRate:int):void
		{
		}
		
		/**
		 * Size has changed (internal)
		 */
		private function internalUpdateSize ():void
		{
			this.updateSize();
			this.updated = true;
		}
		
		/**
		 * Position has changed (internal)
		 */
		private function internalUpdatePosition ():void
		{
			this.updatePosition();
			this.updated = true;
		}
		
		/**
		 * Size has changed
		 */
		protected function updateSize ():void
		{
		}
		
		/**
		 * Position has changed
		 */
		protected function updatePosition ():void
		{
			
		}
		
		/**
		 * Get Shape of this entity
		 * 
		 * @return
		 */
		public function getShape():AShape
		{
			if (!this.shape) return null;
			
			return this.shape;
		}
		
		/**
		 * Set Shape for this entity
		 * 
		 * @param	s
		 * @return
		 */
		public function setShape(s:AShape):Entity
		{
			this.shape = s;
			this.shape.entity = this;
			
			return this;
		}
		
		/**
		 * Get Rectangle
		 * 
		 * @return
		 */
		public function getRect():Rectangle2D
		{
			return new Rectangle2D(
				this.x - (this.width / 2),
				this.y - (this.height / 2),
				this.width,
				this.height
			);
		}
		
		/**
		 * Get Position
		 * 
		 * @return
		 */
		public function getPosition():Vec2D
		{
			// TODO Parralax effect ?...
			return new Vec2D(this.x - (this.width / 2), this.y - (this.height / 2));
		}
		
		/**
		 * Get Center
		 * 
		 * @return
		 */
		public function getCenter():Vec2D
		{
			return new Vec2D(this.x, this.y);
		}
		
		/**
		 * Set Position
		 * 
		 * @param	x
		 * @param	y
		 * @return
		 */
		public function setPosition(x:Number, y:Number):Entity
		{
			this.x = x + (this.width / 2);
			this.y = y + (this.height / 2);
			return this;
		}
		
		
		/**
		 * Set World
		 * 
		 * @param	w
		 * @return
		 */
		final fexel function setWorld (w:World):Entity
		{
			this.world = w;
			
			return this;
		}
		
		/**
		 * Get World
		 * 
		 * @return
		 */
		final public function getWorld ():World
		{
			return this.world;
		}
		
		/**
		 * Remove World
		 * 
		 * @return
		 */
		final fexel function removeWorld ():Entity
		{
			this.world = null;
			
			return this;
		}
		
		/**
		 * Remove current entity from world
		 * 
		 * @return
		 */
		final public function removeFromWorld ():Entity
		{
			this.getWorld().removeEntity(this);
			
			return this;
		}
		
		/**
		 * Handle Collision Pair
		 * 
		 * Return false to cancel collision
		 * 
		 * @return
		 */
		public function handlerCollisionPair (e:Entity):Boolean
		{
			return true;
		}
		
		/**
		 * Handle Collision Contact
		 * 
		 * Return false to cancel collision
		 * 
		 * @param	e
		 * @return
		 */
		public function handlerCollisionContact (e:Entity):Boolean
		{
			return true;
		}
		
		/**
		 * Handle New Contact
		 * 
		 * @param	e
		 */
		public function handlerNewContact (e:Entity, c:ContactInfo):void
		{
		}
		
		/**
		 * Handle Persisting Contact
		 * 
		 * @param	e
		 */
		public function handlerPersistingContact (e:Entity, c:ContactInfo):void
		{
		}
		
		/**
		 * Handle Dead Contact
		 * 
		 * @param	e
		 */
		public function handlerDeadContact (e:Entity):void
		{
		}
		
	}

}