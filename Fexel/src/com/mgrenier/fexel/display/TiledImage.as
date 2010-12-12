package com.mgrenier.fexel.display
{
	import com.mgrenier.fexel.fexel;
	import com.mgrenier.geom.Rectangle2D;
	import com.mgrenier.geom.Vec2D;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Tiled Image base class
	 * 
	 * @author Michael Grenier
	 */
	public class TiledImage extends Image
	{
		private var tiledSource:BitmapData;
		private var last:Rectangle;
		private var tiled:BitmapData;
		
		public function TiledImage(w:Number, h:Number)
		{
			super(w, h);
		}
		
		/**
		 * Triggered by change in size
		 */
		override protected function updateSize ():void
		{
			super.updateSize();
			this.last = new Rectangle();
		}
		
		/**
		 * Render
		 */
		override public function render (cam:Rectangle2D, buffer:BitmapData, frameRate:int):void
		{
			if (!this.getTiledSource())
				return;
			
			var	rect:Rectangle2D = cam.intersection(this.getRect()),			// Intersection with cam
				matrix:Matrix = new Matrix(),									// Matrix transform
				pos:Vec2D = new Vec2D(-cam.x, -cam.y).addVec(this.getPosition());	// Real position
			
			// Different view, update source image
			if (last.x != pos.x || last.y != pos.y || last.width != rect.width || last.height != rect.height)
			{
				var tiled:flash.display.Sprite = Image.sprite,					// Sprite buffer (only way to get Graphics API
					source:BitmapData = new BitmapData(rect.width, rect.height);
				
				// Tiling origin 0 or scroll
				matrix.translate(Math.min(0, pos.x), Math.min(0, pos.y));
				
				// Draw tiling image
				tiled.graphics.clear();
				tiled.graphics.beginBitmapFill(this.getTiledSource(), matrix, true, false);
				tiled.graphics.drawRect(0, 0, rect.width, rect.height);
				tiled.graphics.endFill();
				
				source.draw(tiled);
				
				this.last.x = pos.x;
				this.last.y = pos.y;
				this.last.width = rect.width;
				this.last.height = rect.height;
				
				this.setSourceBitmapData(source);
				this.setSourceRect(new Rectangle(0, 0, rect.width, rect.height));
			}
			
			// Hack... change position
			var oldpos:Vec2D = this.getPosition();
			this.setPosition(Math.max(0, pos.x) + cam.x, Math.max(0, pos.y) + cam.y);
			
			// Render image with changed position
			super.render(cam, buffer, frameRate);
			
			// Restore real position
			this.setPosition(oldpos.x, oldpos.y);
		}
		
		/**
		 * Set Tiled source
		 * 
		 * @param	source
		 */
		public function setTiledSource (source:*):Image
		{
			this.tiledSource = Texture.getBitmapData(source);
			
			return this;
		}
		
		/**
		 * Get Tiled source
		 * 
		 * @return
		 */
		public function getTiledSource ():BitmapData
		{
			return this.tiledSource;
		}
	}
}