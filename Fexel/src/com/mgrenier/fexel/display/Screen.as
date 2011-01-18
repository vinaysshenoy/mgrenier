package com.mgrenier.fexel.display
{
	import com.mgrenier.fexel.fexel;
	use namespace fexel;
	
	import com.mgrenier.fexel.Stage;
	import com.mgrenier.geom.Rectangle2D;
	import com.mgrenier.geom.Vec2D;
	import com.mgrenier.utils.Disposable;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * Screen
	 * 
	 * @author Michael Grenier
	 */
	public class Screen extends Bitmap implements Disposable
	{
		public var fill:uint;
		public var zoom:Number;
		public var camX:int;
		public var camY:int;
		public var camRotation:Number;
		public var colorTransform:ColorTransform;
		
		protected var _rect:Rectangle;
		protected var _matrix:Matrix;
		protected var _offsetMatrix:Matrix;
		protected var _bounds:Rectangle2D;
		protected var _color:ColorTransform;
		
		/**
		 * Constructor
		 */
		public function Screen(width:int, height:int, zoom:Number = 1, fill:uint = 0xff000000)
		{
			super(new BitmapData(width, height, fill >>> 24 != 255, fill), "auto", false);
			this.camX = width / 2;
			this.camY = height / 2;
			this.camRotation = 0;
			this.fill = fill;
			this.zoom = zoom;
			this.colorTransform = new ColorTransform();
			
			this._rect = new Rectangle();
			this._matrix = new Matrix();
			this._offsetMatrix = new Matrix();
			this._bounds = new Rectangle2D();
			this._color = new ColorTransform();
		}
		
		/**
		 * toString
		 * 
		 * @return
		 */
		override public function toString ():String
		{
			return "("+[
				"x="+ this.x,
				"y="+ this.y,
				"width="+ this.width,
				"height="+ this.height,
				"fov="+ this.getFieldOfView()
			].join(", ")+")";
		}
		
		/**
		 * Dispose
		 */
		public function dispose ():void
		{
			if (this.bitmapData)
				this.bitmapData.dispose();
			this.bitmapData = null;
			
			this.colorTransform = null;
			
			this._matrix = null;
			this._offsetMatrix = null;
			this._bounds = null;
			this._color = null;
		}
		
		/**
		 * Render Screen
		 */
		fexel function render (s:Stage):void
		{
			var fov:Rectangle2D = this.getFieldOfView(),
				hwidth:int = this.width / 2,
				hheight:int = this.height / 2,
				children:Vector.<DisplayObject> = s.children(),
				i:int,
				n:int;
			
			this.zoom = this.zoom < 0 ? 0 : this.zoom;
			
			this._offsetMatrix.identity();
			this._offsetMatrix.rotate((this.camRotation % 360) * 0.0174532925);
			this._offsetMatrix.scale(this.zoom, this.zoom);
			this._matrix.identity();
			this._matrix.translate(-hwidth, -hheight);
			this._matrix.concat(this._offsetMatrix);
			this._matrix.translate(hwidth, hheight);
			
			this._bounds = fov.bounds(this._matrix);
			
			this._color.alphaMultiplier = this.colorTransform.alphaMultiplier;
			this._color.alphaOffset = this.colorTransform.alphaOffset;
			this._color.blueMultiplier = this.colorTransform.blueMultiplier;
			this._color.blueOffset = this.colorTransform.blueOffset;
			this._color.greenMultiplier = this.colorTransform.greenMultiplier;
			this._color.greenOffset = this.colorTransform.greenOffset;
			this._color.redMultiplier = this.colorTransform.redMultiplier;
			this._color.redOffset = this.colorTransform.redOffset;
			
			this._rect.width = this.bitmapData.width;
			this._rect.height = this.bitmapData.height;
			
			this.bitmapData.lock();
			
			this.bitmapData.fillRect(this._rect, this.fill);
			
			for (i = 0, n = children.length; i < n; ++i)
			{
				children[i].render(this.bitmapData, this._bounds, this._matrix, this._color);
			}
			
			this.bitmapData.unlock();
		}
		
		/**
		 * Set Camera center
		 * 
		 * @param	x
		 * @param	y
		 * @return
		 */
		public function setCamera (x:int, y:int):Screen
		{
			this.camX = x;
			this.camY = y;
			
			return this;
		}
		
		/**
		 * Get Camera center
		 * 
		 * @return
		 */
		public function getCamera ():Vec2D
		{
			return new Vec2D(this.camX, this.camY);
		}
		
		/**
		 * Get Field of view
		 * 
		 * @return
		 */
		public function getFieldOfView ():Rectangle2D
		{
			var zwidth:Number = this.width / this.zoom,
				zheight:Number = this.height / this.zoom;
			return new Rectangle2D(
				this.camX - (zwidth / 2),
				this.camY - (zheight / 2),
				zwidth,
				zheight
			);
		}
		
	}
}