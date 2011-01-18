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
		
		private var _matrix:Matrix;
		private var _color:ColorTransform;
		
		private var _maskData:BitmapData;
		private var _maskPoint:Point;
		
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
			this._matrix = new Matrix();
			this._color = new ColorTransform();
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
			
			this._matrix = null;
			this._color = null;
			
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
		 * @param	bounds
		 * @param	transformation
		 * @param	color
		 * @param	rate
		 */
		override fexel function render (buffer:BitmapData, bounds:Rectangle2D, matrix:Matrix, color:ColorTransform):void
		{
			if (!this.bitmapData)
				return;
			
			var m:Matrix = this.getMatrix();
			
			this._matrix.a = m.a;
			this._matrix.b = m.b;
			this._matrix.c = m.c;
			this._matrix.d = m.d;
			this._matrix.tx = m.tx;
			this._matrix.ty = m.ty;
			this._color.alphaMultiplier = color.alphaMultiplier;
			this._color.alphaOffset = color.alphaOffset;
			this._color.blueMultiplier = color.blueMultiplier;
			this._color.blueOffset = color.blueOffset;
			this._color.greenMultiplier = color.greenMultiplier;
			this._color.greenOffset = color.greenOffset;
			this._color.redMultiplier = color.redMultiplier;
			this._color.redOffset = color.redOffset;
			
			
			this._matrix.translate(-this.refX, -this.refY);
			//this._matrix.concat(this.getMatrix());
			this._matrix.concat(matrix);
			this._matrix.translate(this.refX, this.refY);
			this._color.concat(this.colorTransform);
			
			this._sourceRect.width = this.bitmapData.width;
			this._sourceRect.height = this.bitmapData.height;
			this._destPoint.x = this._matrix.tx;
			this._destPoint.y = this._matrix.ty;
			
			var drawData:BitmapData = this.maskData ? this._combinedData : this.bitmapData;
			
			if (
				this._matrix.a != 1 || this._matrix.b != 0 || this._matrix.c != 0 || this._matrix.d != 1 ||
				this._color.redMultiplier != 1 || this._color.greenMultiplier != 1 || this._color.blueMultiplier != 1 || this._color.alphaMultiplier != 1 ||
				this._color.redOffset != 0 || this._color.greenOffset != 0 || this._color.blueOffset != 0 || this._color.alphaOffset != 0 ||
				this.blend != BlendMode.NORMAL
			)
			{
				buffer.draw(drawData, this._matrix, this._color, this.blend, null, this.smooth);
			}
			else
			{
				buffer.copyPixels(drawData, this._sourceRect, this._destPoint, null, null, this.transparent);
			}
			
			super.render(buffer, bounds, matrix, color);
		}
	}
}