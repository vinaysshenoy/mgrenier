package com.mgrenier.fexel.display
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;

	/**
	 * SpriteSheet
	 * 
	 * @author Michael Grenier
	 */
	public class SpriteSheet extends Bitmap
	{
		protected var gridWidth:int;
		protected var gridHeight:int;
		public var cellIndex:int;
		
		public var spriteData:BitmapData;
		protected var _sourceRect:Rectangle;
		private var _destPoint:Point;
		
		/**
		 * Constructor
		 */
		public function SpriteSheet(width:Number, height:Number, transparent:Boolean=true, smooth:Boolean=false)
		{
			super(width, height, transparent, smooth);
			this.bitmapData = new BitmapData(width, height, transparent, transparent ? 0x00000000 : 0xff000000);
			this.gridWidth = width;
			this.gridHeight = height;
			this.cellIndex = 1;
			this._sourceRect = new Rectangle(0, 0, width, height);
			this._destPoint = new Point();
		}
		
		/**
		 * Dispose
		 */
		override public function dispose ():void
		{
			if (this.spriteData)
				this.spriteData.dispose();
			this.spriteData = null;
			this._sourceRect = null;
			this._destPoint = null;
			
			super.dispose();
		}
		
		/**
		 * Update buffer
		 * 
		 * @param	rate
		 */
		override public function update (rate:int = 0):void
		{
			if (!this.spriteData)
				return;
			
			var cols:int = Math.ceil(this.spriteData.width / this.gridWidth),
				rows:int = Math.ceil(this.spriteData.height / this.gridHeight);
			
			this._sourceRect.y = Math.ceil(this.cellIndex / cols) - 1;
			this._sourceRect.x = this.cellIndex - (this._sourceRect.y * cols) - 1;
			this._sourceRect.x *= this.gridWidth;
			this._sourceRect.y *= this.gridHeight;
			
			this.bitmapData.lock();
			this.bitmapData.copyPixels(this.spriteData, this._sourceRect, this._destPoint, null, null, false);
			this.bitmapData.unlock();
			
			super.update(rate);
		}
	}
}