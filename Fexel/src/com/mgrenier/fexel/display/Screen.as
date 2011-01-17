package com.mgrenier.fexel.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * Screen
	 * 
	 * @author Michael Grenier
	 */
	public class Screen extends Bitmap
	{
		/**
		 * Constructor
		 */
		public function Screen(width:int, height:int, zoom:Number, fill:uint = 0xff000000)
		{
			super(null, "auto", false);
		}
	}
}