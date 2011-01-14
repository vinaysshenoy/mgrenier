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

	/**
	 * Bitmap
	 * 
	 * @author Michael Grenier
	 */
	public class Bitmap extends DisplayObject
	{
		public var transparent:Boolean;
		public var smooth:Boolean;
		
		public var bitmapData:BitmapData;
		protected var sourceRect:Rectangle;
		private var destPoint:Point;
		
		public var maskData:BitmapData;
		public var maskPoint:Point;
		
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
			this.sourceRect = new Rectangle(0, 0, width, height);
			this.destPoint = new Point(0, 0);
			this.maskData = null;
			this.maskPoint = null;
		}
		
		/**
		 * Dispose
		 */
		override public function dispose ():void
		{
			if (this.bitmapData)
				this.bitmapData.dispose();
			this.bitmapData = null;
			
			super.dispose();
		}
		
		/**
		 * Render to buffer
		 * 
		 * @param	buffer
		 * @param	transformation
		 */
		override fexel function render (buffer:BitmapData, matrix:Matrix, color:ColorTransform):void
		{
			if (!this.bitmapData)
				return;
			
			var transform:Matrix = matrix.clone(),
				colorTransform:ColorTransform = new ColorTransform(this.color.redMultiplier, this.color.greenMultiplier, this.color.blueMultiplier, this.color.alphaMultiplier, this.color.redOffset, this.color.greenOffset, this.color.blueOffset, this.color.alphaOffset);
			transform.translate(-this.refX, -this.refY);
			transform.concat(this.getMatrix());
			transform.translate(this.refX, this.refY);
			colorTransform.concat(color);
			
			if (
				transform.a != 1 || transform.b != 0 || transform.c != 0 || transform.d != 1 ||
				colorTransform.redMultiplier != 1 || colorTransform.greenMultiplier != 1 || colorTransform.blueMultiplier != 1 || colorTransform.alphaMultiplier != 1 ||
				colorTransform.redOffset != 0 || colorTransform.greenOffset != 0 || colorTransform.blueOffset != 0 || colorTransform.alphaOffset != 0 ||
				this.blend != BlendMode.NORMAL
			)
			{
				buffer.draw(this.bitmapData, transform, colorTransform, this.blend, null, this.smooth);
			}
			else
			{
				this.sourceRect.width = this.bitmapData.width;
				this.sourceRect.height = this.bitmapData.height;
				this.destPoint.x = transform.tx;
				this.destPoint.y = transform.ty;
				buffer.copyPixels(this.bitmapData, this.sourceRect, this.destPoint, this.maskData, this.maskPoint, this.transparent);
			}
		}
	}
}