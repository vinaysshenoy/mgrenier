package com.mgrenier.fexel.display
{
	import com.mgrenier.fexel.fexel;
	use namespace fexel;
	
	import com.mgrenier.geom.Rectangle2D;
	import com.mgrenier.utils.Disposable;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import com.mgrenier.geom.Vec2D;
	
	public class DisplayObject extends Rectangle2D implements Disposable
	{
		public var transformationPoint:Vec2D;
		
		public var scaleX:Number;
		public var scaleY:Number;
		
		/**
		 * Constructor
		 */
		public function DisplayObject(x:Number=0, y:Number=0, width:Number=0, height:Number=0)
		{
			super(x, y, width, height);
			this.transformationPoint = new Vec2D();
			this.scaleX = this.scaleY = 1;
		}
		
		/**
		 * Dispose Entity
		 */
		public function dispose ():void
		{
		}
		
		/**
		 * Render to buffer
		 */
		fexel function render (buffer:BitmapData, transformation:Matrix):void
		{
			throw new Error(this +" : Must be instanciated");
		}
		
		/**
		 * Get Bounds
		 */
		public function getBounds ():Rectangle2D
		{
			return null;
		}
	}
}