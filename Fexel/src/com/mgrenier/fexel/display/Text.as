package com.mgrenier.fexel.display 
{
	import com.mgrenier.fexel.fexel;
	use namespace fexel;
	import com.mgrenier.geom.Rectangle2D;
	
	import com.mgrenier.fexel.Entity;
	import com.mgrenier.geom.Vec2D;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Gern
	 */
	public class Text extends Image
	{
		protected var text:TextField;

		protected var update:Boolean = true;
		
		protected var shadowColor:uint = 0;
		protected var shadowDistance:Vec2D = new Vec2D();
		
		/**
		 * Basic Text entity
		 * 
		 * @param	text
		 * @param	embedded
		 */
		public function Text(width:int, text:String = "", size:int = 8, color:uint = 0xffffff, shadowColor:uint = 0x000000, shadowDistance:Number = 0) 
		{
			super(1, 1);
			
			this.text = new TextField();
			this.text.width = width;
			this.text.autoSize = TextFieldAutoSize.LEFT;
			this.text.embedFonts = true;
			this.text.selectable = false;
			this.text.multiline = true;
			this.text.sharpness = 100;
			this.text.wordWrap = true;
			this.text.text = text;
			
			this.setFormat("system", size, color, TextFieldAutoSize.LEFT, shadowColor);
			this.setShadowDistance(shadowDistance);
		}
		
		/**
		 * Dispose Text
		 */
		override public function dispose ():void
		{
			this.text = null;
			
			super.dispose();
		}
		
		/**
		 * Render
		 */
		override public function render (cam:Rectangle2D, buffer:BitmapData, frameRate:int):void
		{
			// Update buffer
			if (this.update)
			{
				var d:Vec2D = this.getShadowDistance(),
					text:BitmapData = new BitmapData(this.text.width + d.x, this.text.height + d.y, true, 0);
				
				// Draw shadow
				if (d.length() != 0)
				{
					var c:uint = this.getColor(),
						m:Matrix = new Matrix();
					
					m.translate(d.x, d.y);
					this.setColor(this.getShadowColor() );
					text.draw(this.text, m);
					this.setColor(c);
				}
				
				// Draw text
				text.draw(this.text);
				
				// Dispose & Recreate bitmapdata
				var bitmapData:BitmapData = new BitmapData(text.width, text.height, true, 0);
				bitmapData.copyPixels(text, new Rectangle(0, 0, text.width, text.height), Vec2D.zero.point);
				
				text.dispose();
				text = null;
				
				this.setWidth(bitmapData.width);
				this.setHeight(bitmapData.height);
				this.setSourceBitmapData(bitmapData);
				
				this.update = false;
			}
			
			super.render(cam, buffer, frameRate);
		}
		
		/**
		 * Set Text
		 * 
		 * @param	t
		 */
		public function setText(t:String):void
		{
			this.text.text = t;
			this.update = true;
		}
		
		/**
		 * Get Text
		 * 
		 * @return
		 */
		public function getText():String
		{
			return this.text.text;
		}
		
		/**
		 * Change text's format
		 * 
		 * @return
		 */
		public function setFormat(font:String, size:Number = 8, color:uint = 0xffffff, align:String = "left", shadowColor:uint = 0x000000):Text
		{
			var format:TextFormat = new TextFormat("system", 8, color);
			format.font = font;
			format.size = size;
			format.align = align;
			
			this.shadowColor = shadowColor;
			this.update = true;
			
			this.text.defaultTextFormat = format;
			this.text.setTextFormat(format);
			
			return this;
		}
		
		/**
		 * Change text's font
		 * 
		 * @param	c
		 * @return
		 */
		public function setFont (f:String):Text
		{
			var format:TextFormat = this.text.defaultTextFormat;
			return this.setFormat(f, Number(format.size), uint(format.color), format.align, this.shadowColor);
		}
		
		/**
		 * Get text's font
		 * @return
		 */
		public function getFont():String
		{
			return this.text.defaultTextFormat.font;
		}
		
		/**
		 * Change text's size
		 * @param	c
		 * @return
		 */
		public function setSize (s:Number):Text
		{
			var format:TextFormat = this.text.defaultTextFormat;
			return this.setFormat(format.font, s, uint(format.color), format.align, this.shadowColor);
		}
		
		/**
		 * Get text's size
		 * @return
		 */
		public function getSize():String
		{
			return new String(this.text.defaultTextFormat.size);
		}
		
		/**
		 * Change text's color
		 * 
		 * @param	c
		 * @return
		 */
		public function setColor (c:uint):Text
		{
			var format:TextFormat = this.text.defaultTextFormat;
			return this.setFormat(format.font, Number(format.size), c, format.align, this.shadowColor);
		}
		
		/**
		 * Get text's color
		 * @return
		 */
		public function getColor():uint
		{
			return uint(this.text.defaultTextFormat.color);
		}
		
		
		/**
		 * Change text's align
		 * 
		 * @param	c
		 * @return
		 */
		public function setAlign (a:String):Text
		{
			var format:TextFormat = this.text.defaultTextFormat;
			return this.setFormat(format.font, Number(format.size), uint(format.color), a, this.shadowColor);
		}
		
		/**
		 * Get text's align
		 * @return
		 */
		public function getAlign():String
		{
			return this.text.defaultTextFormat.align;
		}
		
		
		/**
		 * Change text's shadow color
		 * 
		 * @param	c
		 * @return
		 */
		public function setShadowColor (s:uint):Text
		{
			var format:TextFormat = this.text.defaultTextFormat;
			return this.setFormat(format.font, Number(format.size), uint(format.color), format.align, s);
		}
		
		/**
		 * Get text's shadow color
		 * @return
		 */
		public function getShadowColor():uint
		{
			return this.shadowColor;
		}
		
		/**
		 * Change text's shadow distance
		 * 
		 * @param	d
		 * @return
		 */
		public function setShadowDistance(dX:Number, dY:Number = undefined):Text
		{
			this.shadowDistance.x = dX;
			this.shadowDistance.y = dY || dX;
			this.update = true;
			return this;
		}
		
		/**
		 * Get text's shadow distance
		 * @return
		 */
		public function getShadowDistance():Vec2D
		{
			return this.shadowDistance;
		}
		
		
	}

}