package com.mgrenier.fexel.display
{
	import com.mgrenier.fexel.fexel;
	use namespace fexel;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.display.Sprite;
	import com.mgrenier.geom.Rectangle2D;

	/**
	 * Bitmap
	 * 
	 * @author Michael Grenier
	 */
	public class Bitmap extends DisplayObject
	{
		static public var sprite:Sprite = new Sprite();
		
		public var transparent:Boolean;
		public var smooth:Boolean;
		
		public var bitmapData:BitmapData;
		private var _sourceRect:Rectangle;
		private var _destPoint:Point;
		
		private var _maskData:BitmapData;
		private var _maskPoint:Point;
		
		private var _refMatrix:Matrix;
		
		public function get maskData():BitmapData { return this._maskData; }
		public function set maskData(v:BitmapData):void {
			this._maskData = v;
			
			if (this._combinedData)
				this._combinedData.dispose();
			this._combinedData = null;
			this._combinedData = new BitmapData(this.bitmapData.width, this.bitmapData.height, this.bitmapData.transparent, 0x000000);
			
			if (this._maskData)
				this._combinedData.copyPixels(this.bitmapData, this._sourceRect, this._destPoint, this._maskData, this._maskPoint, true);
			else
				this._combinedData.copyPixels(this.bitmapData, this._sourceRect, this._destPoint);
		}
		
		private var _combinedData:BitmapData;
		
		/**
		 * Constructor
		 * 
		 * @param	width
		 * @param	height
		 * @param	fill
		 */
		public function Bitmap(width:Number, height:Number, transparent:Boolean = true, smooth:Boolean = false)
		{
			super(0, 0, width, height);
			this.transparent = transparent;
			this.smooth = smooth;
			this.bitmapData = null;
			this._sourceRect = new Rectangle(0, 0, width, height);
			this._destPoint = new Point(0, 0);
			this._maskData = null;
			this._maskPoint = null;
			this._refMatrix = new Matrix();
		}
		
		/**
		 * Dispose
		 */
		override public function dispose ():void
		{
			if (this.bitmapData)
				this.bitmapData.dispose();
			this.bitmapData = null;
			
			this._sourceRect = null;
			this._destPoint = null;
			
			if (this._maskData)
				this._maskData.dispose();
			this._maskData = null;
			
			if (this._combinedData)
				this._combinedData.dispose();
			this._combinedData = null;
			
			this._refMatrix = null;
			
			super.dispose();
		}
		
		/**
		 * Update buffer
		 * 
		 * @param	rate
		 */
		override public function update (rate:int = 0):void
		{
			super.update(rate);
		}
		
		/**
		 * Render to buffer
		 * 
		 * @param	buffer
		 * @param	rect
		 * @param	bounds
		 * @param	transformation
		 * @param	color
		 * @param	debug
		 * @param	debugColor
		 */
		override fexel function render (buffer:BitmapData, rect:Rectangle2D, bounds:Rectangle2D, matrix:Matrix, color:ColorTransform, debug:uint, debugColor:DebugColor):void
		{
			if (!this.bitmapData)
				return;
			
			this._sourceRect.width = this.bitmapData.width;
			this._sourceRect.height = this.bitmapData.height;
			this._destPoint.x = this._matrixConcat.tx;
			this._destPoint.y = this._matrixConcat.ty;
			
			var drawData:BitmapData = this.maskData ? this._combinedData : this.bitmapData;
			
			if (
				this._matrixConcat.a != 1 || this._matrixConcat.b != 0 || this._matrixConcat.c != 0 || this._matrixConcat.d != 1 ||
				this._colorConcat.redMultiplier != 1 || this._colorConcat.greenMultiplier != 1 || this._colorConcat.blueMultiplier != 1 || this._colorConcat.alphaMultiplier != 1 ||
				this._colorConcat.redOffset != 0 || this._colorConcat.greenOffset != 0 || this._colorConcat.blueOffset != 0 || this._colorConcat.alphaOffset != 0 ||
				this.blend != BlendMode.NORMAL
			)
			{
				buffer.draw(drawData, this._matrixConcat, this._colorConcat, this.blend, null, this.smooth);
			}
			else
			{
				buffer.copyPixels(drawData, this._sourceRect, this._destPoint, null, null, this.transparent);
			}
			
			super.render(buffer, rect, bounds, matrix, color, debug, debugColor);
		}
	}
}