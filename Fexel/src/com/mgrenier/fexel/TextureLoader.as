package com.mgrenier.fexel
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;

	/**
	 * Texture Loaader
	 * 
	 * @author Michael Grenier
	 */
	public class TextureLoader
	{
		static private var textures:Dictionary = new Dictionary(true);
		
		/**
		 * Unload texture id
		 * 
		 * @param	id
		 */
		static public function unload (id:String):void
		{
			if (TextureLoader.textures[id])
			{
				BitmapData(TextureLoader.textures[id]).dispose();
				TextureLoader.textures[id] = null;
			}
			delete TextureLoader.textures[id];
		}
		
		/**
		 * Load texture as id
		 * 
		 * @param	id
		 * @param	source
		 */
		static public function load (id:String, source:*):BitmapData
		{
			TextureLoader.unload(id);
			var bitmap:BitmapData,
				object:Object;
			
			// BitmapData
			if (source is BitmapData)
			{
				TextureLoader.textures[id] = source;
				return BitmapData(TextureLoader.textures[id]);
			}
			
			// Bitmap
			else if (source is Bitmap)
			{
				TextureLoader.textures[id] = Bitmap(source).bitmapData;
				return BitmapData(TextureLoader.textures[id]);
			}
				
			// Class
			else if (source is Class)
			{
				object = new source();
				
				// Class has bitmapData inside ?
				if (object.bitmapData && object.bitmapData is BitmapData)
				{
					TextureLoader.textures[id] = object.bitmapData;
					object = null;
					return BitmapData(TextureLoader.textures[id]);
				}
			}
			
			return null;
		}
		
		/**
		 * Get BitmapData id
		 * 
		 * @param	id
		 * @return
		 */
		static public function get (id:String):BitmapData
		{
			if (TextureLoader.textures[id])
				return BitmapData(TextureLoader.textures[id]);
			return null;
		}
		
	}
}