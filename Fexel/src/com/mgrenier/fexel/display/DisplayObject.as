package com.mgrenier.fexel.display
{
	import com.mgrenier.geom.Rectangle2D;
	import com.mgrenier.utils.Disposable;
	
	public class DisplayObject extends Rectangle2D implements Disposable
	{
		/**
		 * Constructor
		 */
		public function DisplayObject(x:Number=0, y:Number=0, width:Number=0, height:Number=0)
		{
			super(x, y, width, height);
		}
		
		/**
		 * Dispose Entity
		 */
		public function dispose ():void
		{
		}
	}
}