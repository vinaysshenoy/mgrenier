package com.mgrenier.fexel.display
{
	import com.mgrenier.fexel.Entity;
	import com.mgrenier.geom.Rectangle2D;
	import com.mgrenier.geom.Vec2D;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Image base class
	 * 
	 * @author Michael Grenier
	 */
	public class Image extends Entity
	{
		private var source:BitmapData;
		private var rect:Rectangle;
		
		static public var sprite:flash.display.Sprite = new flash.display.Sprite();
		
		/**
		 * Constructor
		 * 
		 * @param	w
		 * @param	h
		 */
		public function Image(w:Number, h:Number) 
		{
			super(w, h);
			this.updateSize();
		}
		
		/**
		 * Dispose Entity
		 */
		override public function dispose ():void
		{
			if (this.source)
				this.source = null;
		}
		
		/**
		 * Triggered by change in size
		 */
		override protected function updateSize ():void
		{
			this.setSourceRect(new Rectangle(0, 0, this.width, this.height));
		}
		
		/**
		 * Render
		 */
		override public function render (cam:Rectangle2D, buffer:BitmapData, frameRate:int):void
		{
			if (!this.getSource())
				return;
			
			var pos:Vec2D = new Vec2D(-cam.x, -cam.y).addVec(this.getPosition());
			
			buffer.copyPixels(this.getSource(), this.getSourceRect(), pos.point);
			
			// TODO Transform ? ColorTransform ? Blend ?
			/*var mat:Matrix = new Matrix();
			mat.translate(-pos.x, -pos.y);
			
			buffer.draw(this.getSource(), mat, null, null, this.getSourceRect(), false);*/
		}
		
		/**
		 * Set Image source
		 * 
		 * @param	source
		 */
		public function setSource (source:*):Image
		{
			this.source = Texture.getBitmapData(source);
			
			return this;
		}
		
		/**
		 * Set Image source as BitmapData
		 * 
		 * @return
		 */
		public function setSourceBitmapData (source:BitmapData):Image
		{
			this.source = source;
			
			return this;
		}
		
		/**
		 * Get Source
		 * 
		 * @return
		 */
		public function getSource ():BitmapData
		{
			return this.source;
		}
		
		/**
		 * Set Source Rectangle
		 * 
		 * @param	rect
		 * @return
		 */
		public function setSourceRect (rect:Rectangle):Image
		{
			this.rect = rect;
			
			return this;
		}
		
		/**
		 * Get Source Rectangle
		 * 
		 * @return
		 */
		public function getSourceRect ():Rectangle
		{
			return this.rect;
		}
		
	}

}