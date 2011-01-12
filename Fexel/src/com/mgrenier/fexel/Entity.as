package com.mgrenier.fexel
{
	import com.mgrenier.geom.Rectangle2D;
	import com.mgrenier.utils.Disposable;
	
	public class Entity extends Rectangle2D implements Disposable
	{
		/**
		 * Constructor
		 */
		public function Entity(x:Number=0, y:Number=0, width:Number=0, height:Number=0)
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