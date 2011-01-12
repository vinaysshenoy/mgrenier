package com.mgrenier.fexel.display
{
	import com.mgrenier.fexel.EntitiesContainer;
	import com.mgrenier.geom.Rectangle2D;
	import com.mgrenier.geom.Vec2D;
	import com.mgrenier.utils.Disposable;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	public class View extends Rectangle2D implements Disposable
	{
		public var fill:uint;
		public var transparent:Boolean;
		public var zoom:Number;
		public var dirty:Boolean;
		
		protected var hud:EntitiesContainer;
		protected var buffer:BitmapData;
		protected var zoomBuffer:BitmapData;
		protected var zoomMatrix:Matrix;
		
		private var oldFieldOfView:Rectangle2D;
		
		/**
		 * Constructor
		 */
		public function View(x:Number=0, y:Number=0, width:Number=0, height:Number=0, zoom:Number = 1, fill:uint = 0x000000, transparent:Boolean = false)
		{
			super(x, y, width, height);
			this.zoom = zoom;
			this.fill = fill;
			this.transparent = transparent;
			this.dirty = true;
			
			this.hud = new EntitiesContainer();
			this.zoomMatrix = new Matrix();
		}
		
		/**
		 * Dispose View
		 */
		public function dispose ():void
		{
			
		}
		
		/**
		 * Render View
		 * 
		 */
		public function render ():void
		{
			var fov:Rectangle2D = this.getFieldOfView();
			this.dirty =	this.dirty ||
							!this.oldFieldOfView ||
							this.oldFieldOfView.width != fov.width ||
							this.oldFieldOfView.height != fov.height;
			
			if (this.dirty)
			{
				if (this.zoomBuffer)
				{
					this.zoomBuffer.dispose();
					this.zoomBuffer = null;
				}
				this.zoomBuffer = new BitmapData(fov.width, fov.height, this.transparent, this.fill);
				this.zoomMatrix.identity();
				this.zoomMatrix.scale(this.zoom, this.zoom);
				this.oldFieldOfView = fov;
			}
			
			this.zoomBuffer.lock();
			this.buffer.lock();
			
			//this.zoomBuffer.fillRect(
			
			
			this.buffer.unlock();
		}
		
		/**
		 * Set Camera center
		 * 
		 * @param	x
		 * @param	y
		 */
		public function setCenter (x:Number, y:Number):void
		{
			this.x = x - (this.width / 2);
			this.y = y - (this.height / 2);
		}
		
		/**
		 * Get Camera center
		 * 
		 * @return
		 */
		public function getCenter ():Vec2D
		{
			return new Vec2D(
				this.x + (this.width / 2),
				this.y + (this.height / 2)
			);
		}
		
		/**
		 * Get Field of view
		 */
		public function getFieldOfView ():Rectangle2D
		{
			var zoomwidth:Number = this.width / this.zoom,
				zoomheight:Number = this.height / this.zoom;
			return new Rectangle2D(
				this.x + (zoomwidth / 2),
				this.y + (zoomheight / 2),
				zoomwidth,
				zoomheight
			);
		}
	}
}