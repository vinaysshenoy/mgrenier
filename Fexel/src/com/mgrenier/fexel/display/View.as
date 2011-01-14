package com.mgrenier.fexel.display
{
	import com.mgrenier.geom.Rectangle2D;
	import com.mgrenier.geom.Vec2D;
	import com.mgrenier.utils.Disposable;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	/**
	 * View of the Stage
	 * 
	 * @author Michael Grenier
	 */
	public class View extends Rectangle2D implements Disposable
	{
		public var fill:uint;
		public var zoom:Number;
		public var dirty:Boolean;
		
		protected var hud:DisplayObjectContainer;
		protected var buffer:BitmapData;
		protected var zoomBuffer:BitmapData;
		protected var zoomMatrix:Matrix;
		
		private var dirtyInfo:Object;
		
		/**
		 * Constructor
		 */
		public function View(x:Number=0, y:Number=0, width:Number=0, height:Number=0, zoom:Number = 1, fill:uint = 0xff000000)
		{
			super(x, y, width, height);
			this.zoom = zoom;
			this.fill = fill;
			this.dirty = true;
			
			this.hud = new DisplayObjectContainer();
			this.zoomMatrix = new Matrix();
		}
		
		/**
		 * Dispose View
		 */
		public function dispose ():void
		{
			if (this.zoomBuffer)
				this.zoomBuffer.dispose();
			this.zoomBuffer = null;
			this.zoomMatrix = null;
			if (this.buffer)
				this.buffer.dispose();
			this.buffer = null;
			this.dirtyInfo = null;
		}
		
		/**
		 * Render View
		 * 
		 */
		public function render ():void
		{
			var fov:Rectangle2D = this.getFieldOfView(),
				transparent:Boolean = this.fill >>> 24 != 255,
				dirtr:Boolean = this.dirty ||
								!this.dirtyInfo ||
								this.dirtyInfo.width != fov.width ||
								this.dirtyInfo.height != fov.height ||
								this.dirtyInfo.zoom != this.zoom;
			
			if (dirty)
			{
				if (this.zoomBuffer)
				{
					this.zoomBuffer.dispose();
					this.zoomBuffer = null;
				}
				this.zoomBuffer = new BitmapData(fov.width, fov.height, transparent, this.fill);
				this.zoomMatrix.identity();
				this.zoomMatrix.scale(this.zoom, this.zoom);
				this.dirtyInfo = {
					width: fov.width,
					height: fov.height,
					zoom: this.zoom
				};
				this.dirty = false;
			}
			
			this.zoomBuffer.lock();
			this.buffer.lock();
			
			//this.zoomBuffer.fillRect(  transparent...
			
			
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
				this.x + (this.width / 2) - (zoomwidth / 2),
				this.y + (this.height / 2) - (zoomheight / 2),
				zoomwidth,
				zoomheight
			);
		}
	}
}