package com.mgrenier.fexel.display
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * Text
	 * 
	 * @author Michael Grenier
	 */
	public class Text extends Bitmap
	{
		[Embed(source = "../data/nokiafc22.ttf", fontFamily = "system", embedAsCFF = "false")]
		private var system:String;
		
		protected var textField:TextField;
		private var _textData:BitmapData;
		private var _matrix:Matrix;
		
		public var text:String;
		public var font:String;
		public var size:Number;
		public var color:uint;
		public var selectable:Boolean;
		public var shadowColor:uint;
		public var shadowX:int;
		public var shadowY:int;
		
		private var _textFormat:TextFormat;
		private var _shadowTransform:ColorTransform;
		
		/**
		 * Constructor
		 */
		public function Text(width:int, text:String = "", size:int = 8, color:uint = 0xffffff, shadowColor:uint = 0x000000, shadowX:int = 0, shadowY:int = 0)
		{
			super(width, size, true, false);
			this.text = text;
			this.font = "system";
			this.size = size;
			this.color = color;
			this.selectable = false;
			this.shadowColor = shadowColor;
			this.shadowX = shadowX;
			this.shadowY = shadowY;
			
			this.textField = new TextField();
			this._textFormat = new TextFormat();
			this._matrix = new Matrix();
			this._shadowTransform = new ColorTransform();
		}
		
		/**
		 * Dispose
		 */
		override public function dispose ():void
		{
			this._matrix = null;
			this._textFormat = null;
			this._shadowTransform = null;
			if (this._textData)
				this._textData.dispose();
			this._textData = null;
			this.textField = null;
			
			super.dispose();
		}
		
		/**
		 * Update buffer
		 * 
		 * @param	rate
		 */
		override public function update (rate:int = 0):void
		{
			this.textField.width = this.width;
			this.textField.autoSize = TextFieldAutoSize.LEFT;
			this.textField.embedFonts = true;
			this.textField.selectable = this.selectable;
			this.textField.multiline = true;
			this.textField.sharpness = 100;
			this.textField.wordWrap = true;
			this.textField.text = this.text;
			
			this._textFormat.font = this.font;
			this._textFormat.color = this.color;
			this._textFormat.size = this.size;
			this._textFormat.align = TextFormatAlign.LEFT;
			
			this.textField.defaultTextFormat = this._textFormat;
			this.textField.setTextFormat(this._textFormat);
			
			if (this.bitmapData)
				this.bitmapData.dispose();
			this.bitmapData = null;
			this.bitmapData = new BitmapData(this.textField.width + this.shadowX, this.textField.height + this.shadowY, true, 0x00000000);
			
			//this.width = this.bitmapData.width;
			//this.height = this.bitmapData.height;
			
			this.bitmapData.lock();
			
			this._matrix.tx = this._matrix.ty = 0;
			if (this.shadowX != 0 || this.shadowY != 0)
			{
				this._matrix.tx = this.shadowX < 0 ? 0 : this.shadowX
				this._matrix.ty = this.shadowY < 0 ? 0 : this.shadowY;
				this._shadowTransform.color = this.shadowColor;
				this.bitmapData.draw(this.textField, this._matrix, this._shadowTransform);
				
				this._matrix.tx = this.shadowX < 0 ? -this.shadowX : 0;
				this._matrix.ty = this.shadowY < 0 ? -this.shadowY : 0;
			}
			
			this.bitmapData.draw(this.textField, this._matrix);
			
			this.bitmapData.unlock();
			
			super.update(rate);
		}
	}
}