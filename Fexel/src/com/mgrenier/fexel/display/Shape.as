package com.mgrenier.fexel.display
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * Shape
	 * 
	 * @author Michael Grenier
	 */
	public class Shape extends Bitmap
	{
		private var _shape:flash.display.Shape;
		private var _sourceRect:Rectangle;
		
		public function get graphics ():Graphics {
			return this._shape.graphics;
		}
		
		/**
		 * Constructor
		 */
		public function Shape(width:Number, height:Number, transparent:Boolean=true, smooth:Boolean=false)
		{
			super(width, height, transparent, smooth);
			
			this.bitmapData = new BitmapData(width, height, transparent, transparent ? 0x00000000 : 0xff000000);
			this._sourceRect = new Rectangle(0, 0, width, height);
			this._shape = new flash.display.Shape();
		}
		
		/**
		 * Dispose
		 */
		override public function dispose ():void
		{
			this._sourceRect = null;
			this._shape = null;
			
			super.dispose();
		}
		
		/**
		 * Update buffer
		 * 
		 * @param	rate
		 */
		override public function update (rate:int = 0):void
		{
			this.bitmapData.lock();
			this.bitmapData.fillRect(this._sourceRect, this.transparent ? 0x00000000 : 0xff000000);
			this.bitmapData.draw(this._shape);
			this.bitmapData.unlock();
			
			super.update(rate);
		}
	}
}