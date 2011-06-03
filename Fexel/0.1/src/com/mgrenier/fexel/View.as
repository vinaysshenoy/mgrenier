package com.mgrenier.fexel 
{
	import com.mgrenier.fexel.fexel;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	use namespace fexel;
	
	import com.mgrenier.utils.Disposable;
	import com.mgrenier.geom.Vec2D;
	import com.mgrenier.geom.Rectangle2D;
	import com.mgrenier.fexel.Entity;
	import com.mgrenier.fexel.EntitiesContainer;
	import com.mgrenier.fexel.collision.shape.AShape;
	import com.mgrenier.fexel.display.Image;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Michael Grenier
	 */
	public class View implements Disposable
	{
		static public const DEBUG_NORENDER:int = 1;
		static public const DEBUG_ENTITY:int = 2;
		static public const DEBUG_AABB:int = 4;
		static public const DEBUG_SHAPE:int = 8;
		static public const DEBUG_VELOCITY:int = 16;
		
		protected var fill:uint;
		protected var bitmapData:BitmapData;
		protected var bitmap:Bitmap;
		protected var zoomBuffer:BitmapData;
		public function getBuffer():Bitmap { return this.bitmap }
		
		public var debug:int = 0;
		public var debugAlpha:Number = 1;
		public var debugColorEntity:uint = 0x60FF6A;
		public var debugColorAABB:uint = 0xFF0080;
		public var debugColorStatic:uint = 0xDDDDDD;
		public var debugColorDynamic:uint = 0x0DDAFF;
		public var debugColorSleep:uint = 0x92DAFF;//0xCADAFF;
		public var debugColorVelocity:uint = 0x0DDAFF;
		
		protected var cam:Vec2D;
		
		protected var hud:EntitiesContainer;
		public function getHud():EntitiesContainer { return this.hud; }
		
		public function get width():Number { return this.bitmapData.width; }
		public function get height():Number { return this.bitmapData.height; }
		
		protected var entities:Vector.<Entity>;
		
		protected var zoomMatrix:Matrix = new Matrix();
		protected var _zoom:Number = 0;
		public function get zoom():Number { return this._zoom; }
		public function set zoom(v:Number):void {
			this._zoom = v;
			
			var tW:Number = this.zoomBuffer.width, 
				tH:Number = this.zoomBuffer.height;
			
			var realzoom:Number = this.getRealZoom();
			if (this.zoomBuffer)
			{
				this.zoomBuffer.dispose();
				this.zoomBuffer = null;
			}
			this.zoomBuffer = new BitmapData(this.width * (1 / realzoom), this.height * (1 / realzoom), false, this.fill);
			this.zoomMatrix = new Matrix();
			this.zoomMatrix.scale(realzoom, realzoom);
			
			var cam:Rectangle2D = this.getCamera();
			cam.x -= Math.floor((this.zoomBuffer.width / 2) - (tW / 2));
			cam.y -= Math.floor((this.zoomBuffer.height / 2) - (tH / 2));
			this.setCamera(cam.x, cam.y);
		}
		
		
		public function getRealZoom():Number {
			return this.zoom > 0 ? this.zoom + 1 : 1 / (Math.abs(this.zoom) + 1);
		}
		
		public var active:Boolean = true;
		
		/**
		 * Display entities
		 * 
		 * @param	width
		 * @param	height
		 * @param	fill
		 */
		public function View(width:Number, height:Number, fill:uint = 0x000000) 
		{
			this.fill = fill;
			this.bitmapData = new BitmapData(width, height, false, this.fill);
			this.zoomBuffer = new BitmapData(width, height, false, this.fill);
			this.bitmap = new Bitmap(this.bitmapData);
			
			this.cam = new Vec2D(width / 2, height / 2);
			
			this.hud = new EntitiesContainer();
			
			this.entities = new Vector.<Entity>()
		}
		
		/**
		 * Dispose Entity
		 */
		public function dispose ():void
		{
			this.hud = null;
			
			this.bitmapData.dispose();
			this.bitmapData = null;
			this.bitmap = null;
			this.cam = null;
		}
		
		/**
		 * Set current entities... during loop
		 * 
		 * @param	entities
		 */
		fexel function addEntitiesToRender (e:Entity):void
		{
			this.entities.push(e);
		}
		
		/**
		 * Reset entities
		 */
		fexel function resetEntitiesToRender ():void
		{
			this.entities = new Vector.<Entity>();
		}
		
		/**
		 * Step forward !
		 */
		public function step (frameRate:int):void
		{
			// TODO Step HUD entities
		}
		
		/**
		 * Render loop
		 * 
		 * @param	entities
		 */
		public function render (frameRate:int):void
		{
			this.bitmapData.lock();
			this.zoomBuffer.lock();
			
			// Draw fill color
			this.bitmapData.fillRect(new Rectangle(0, 0, this.bitmapData.width, this.bitmapData.height), this.fill);
			this.zoomBuffer.fillRect(new Rectangle(0, 0, this.zoomBuffer.width, this.zoomBuffer.height), this.fill);
			
			var i:int,
				n:int,
				rect:Rectangle2D = new Rectangle2D(0, 0, this.width, this.height),
				entities:Vector.<Entity>,
				zero:Rectangle2D = new Rectangle2D();
			
			// Draw entities
			var entity:Entity,
				aabb:Rectangle2D,
				shape:AShape,
				pos:Vec2D = new Vec2D(),
				matrix:Matrix = new Matrix(),
				sprite:flash.display.Sprite = Image.sprite,
				offset:Rectangle2D = this.getCamera();
			for (i = 0, n = this.entities.length; i < n; i++)
			{
				entity = this.entities[i];
				if (entity.visible)
				{
					if (~this.debug & View.DEBUG_NORENDER)
						entity.render(offset.copy(), this.zoomBuffer, frameRate);
					
					if (this.debug && this.debugAlpha > 0)
					{
						rect = entity.getRect();
						pos.x = -offset.x + rect.x;
						pos.y = -offset.y + rect.y;
						matrix.identity();
						matrix.translate(pos.x, pos.y);
						
						sprite.graphics.clear();
						
						shape = entity.getShape();
						if (shape)
						{
							if (this.debug & View.DEBUG_SHAPE)
							{
								shape.drawDebug(sprite.graphics, this.debugAlpha, entity.sleeping > World.SLEEPAFTERFRAME ? this.debugColorSleep : (entity.dynamic ? this.debugColorDynamic : this.debugColorStatic));
							}
							if (this.debug & View.DEBUG_AABB)
							{
								aabb = shape.getAABB();
								sprite.graphics.beginFill(0x000000, 0);
								sprite.graphics.lineStyle(1, this.debugColorAABB, this.debugAlpha);
								sprite.graphics.drawRect(aabb.x, aabb.y, aabb.width, aabb.height);
								sprite.graphics.endFill();
							}
						}
						
						if (this.debug & View.DEBUG_ENTITY)
						{
							sprite.graphics.beginFill(0x000000, 0);
							sprite.graphics.lineStyle(1, this.debugColorEntity, this.debugAlpha);
							sprite.graphics.drawRect(0, 0, rect.width, rect.height);
							sprite.graphics.endFill();
						}
						
						if (this.debug & View.DEBUG_VELOCITY)
						{
							sprite.graphics.beginFill(0x000000, 0);
							sprite.graphics.lineStyle(1, this.debugColorVelocity, this.debugAlpha);
							sprite.graphics.moveTo(rect.width * 0.5, rect.height * 0.5);
							sprite.graphics.lineTo((entity.velocity.x * 3) + (rect.width * 0.5), (entity.velocity.y * 3) + (rect.height * 0.5));
							sprite.graphics.endFill();
						}
						
						this.zoomBuffer.draw(sprite, matrix);
					}
				}
			}
			
			// Apply Zoom
			if (this.getRealZoom() == 1)
				this.bitmapData.copyPixels(this.zoomBuffer, new Rectangle(0, 0, this.zoomBuffer.width, this.zoomBuffer.height), new Point());
			else
				this.bitmapData.draw(this.zoomBuffer, this.zoomMatrix, null, null, null, false);
			
			// Draw HUDs
			entities = this.getHud().getEntities();
			for (i = 0, n = entities.length; i < n; i++)
			{
				entity = entities[i];
				if (!rect.intersects(entity.getRect()) || !entity.active || !entity.visible)
					continue;
				entity.render(zero, this.bitmapData, frameRate);
			}
			
			this.zoomBuffer.unlock();
			this.bitmapData.unlock();
		}
		
		/**
		 * Check if Entity is in this View
		 * @param	e
		 * @return
		 */
		public function entityInView (e:Entity):Boolean
		{
			return this.getCamera().intersects(e.getRect());
		}
		
		/**
		 * Get Rectangle
		 * 
		 * @return
		 */
		public function getCamera():Rectangle2D
		{
			var realzoom:Number = 1 / this.getRealZoom(),
				rect:Rectangle2D = new Rectangle2D(
					this.cam.x - (this.width / 2),
					this.cam.y - (this.height / 2),
					this.width * realzoom,
					this.height * realzoom
				);
			return rect;
		}
		
		/**
		 * Set Camera
		 * 
		 * @param	p
		 */
		public function setCamera (x:Number, y:Number):View
		{
			this.cam.x = x + (this.width / 2);
			this.cam.y = y + (this.height / 2);
			
			return this;
		}
		
		/**
		 * Set Camera Vec2D
		 * 
		 * @param	p
		 */
		public function setCameraVec2D (p:Vec2D):View
		{
			this.cam.x = p.x;
			this.cam.y = p.y;
			
			return this;
		}
		
	}

}