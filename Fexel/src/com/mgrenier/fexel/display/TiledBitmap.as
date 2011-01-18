package com.mgrenier.fexel.display
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	import flash.display.Sprite;
	
	/**
	 * TiledBitmap
	 * 
	 * @author Michael Grenier
	 */
	public class TiledBitmap extends Bitmap
	{
		public var bitmap:Bitmap;
		private var _matrix:Matrix;
		
		/**
		 * Constructor
		 */
		public function TiledBitmap(width:Number, height:Number, transparent:Boolean=true, smooth:Boolean=false)
		{
			super(width, height, transparent, smooth);
			this.bitmapData = new BitmapData(width, height, transparent, transparent ? 0x00000000 : 0xff000000);
			this._matrix = new Matrix();
		}
		
		/**
		 * Dispose
		 */
		override public function dispose ():void
		{
			this._matrix = null;
			
			super.dispose();
		}
		
		/**
		 * Update buffer
		 * 
		 * @param	rate
		 */
		override public function update (rate:int = 0):void
		{
			if (!this.bitmap)
				return;
			
			var tiling:Sprite = Bitmap.sprite;
			tiling.graphics.clear();
			tiling.graphics.beginBitmapFill(this.bitmap.bitmapData, this._matrix, true, this.smooth);
			tiling.graphics.drawRect(0, 0, this.bitmapData.width, this.bitmapData.height);
			tiling.graphics.endFill();
			
			this.bitmapData.lock();
			this.bitmapData.draw(tiling, this._matrix, null, null, null, this.smooth);
			this.bitmapData.unlock();
			
			super.update(rate);
		}
	}
}