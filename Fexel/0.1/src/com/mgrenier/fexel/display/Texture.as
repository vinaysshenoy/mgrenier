package com.mgrenier.fexel.display 
{
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	/**
	 * Store texture for later use
	 * 
	 * @author Michael Grenier
	 */
	public class Texture
	{
		
		static protected var textures:Dictionary = new Dictionary(true);
		
		// TODO Store
		// TODO Get
		// TODO Delete
		
		/**
		 * Get & Store BitmapData from source
		 * @param	source
		 * @return
		 */
		static public function getBitmapData (source:*):BitmapData
		{
			if (!textures[source])
			{
				var b:BitmapData;
				if (source is Class)
				{
					b = Bitmap(new source()).bitmapData;
					textures[source] = b;
				}
			}
			return textures[source] as BitmapData;
		}
		
	}

}