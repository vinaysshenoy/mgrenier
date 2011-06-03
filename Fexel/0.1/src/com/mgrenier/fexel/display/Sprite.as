package com.mgrenier.fexel.display 
{
	import com.mgrenier.geom.Rectangle2D;
	import com.mgrenier.geom.Vec2D;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	/**
	 * Image that contain multiple image (align to a grid)
	 * 
	 * @author Michael Grenier
	 */
	public class Sprite extends Image
	{
		protected var gridWidth:Number;
		protected var gridHeight:Number;
		
		
		/**
		 * Cell index (start at 1)
		 */
		protected var cellIndex:int;
		public function setCellIndex (i:int):void { this.cellIndex = i; }
		public function getCellIndex ():int { return this.cellIndex; }
		
		/**
		 * Constructor
		 */
		public function Sprite(w:Number, h:Number) 
		{
			super(w, h);
			
			this.gridWidth = w;
			this.gridHeight = h;
			this.cellIndex = 2;
			this.setSourceRect(new Rectangle(0, 0, w, h))
		}
		
		/**
		 * Render
		 */
		override public function render (cam:Rectangle2D, buffer:BitmapData, frameRate:int):void
		{
			if (!this.getSource())
				return;
			
			var source:BitmapData = this.getSource(),
				rect:Rectangle = this.getSourceRect(),
				cols:Number = Math.ceil(source.width / this.gridWidth),
				rows:Number = Math.ceil(source.height / this.gridHeight);
			
			rect.y = Math.ceil(this.cellIndex / cols) - 1;
			rect.x = this.cellIndex - (rect.y * cols) - 1;
			rect.x *= this.gridWidth;
			rect.y *= this.gridHeight;
			
			this.setSourceRect(rect);
			
			super.render(cam, buffer, frameRate);
		}
		
	}

}