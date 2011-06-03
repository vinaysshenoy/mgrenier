package com.mgrenier.fexel.display
{
	import com.mgrenier.fexel.fexel;
	use namespace fexel;
	
	import com.mgrenier.geom.Rectangle2D;
	import com.mgrenier.utils.Disposable;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import com.mgrenier.geom.Vec2D;
	import flash.geom.Point;
	import apparat.math.FastMath;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import com.mgrenier.fexel.Stage;
	import flash.display.Sprite;
	
	/**
	 * Display Object
	 * 
	 * @author Michael Grenier
	 */
	public class DisplayObject extends Rectangle2D implements Disposable
	{
		public var visible:Boolean;
		public var rotation:Number;
		public var scaleX:Number;
		public var scaleY:Number;
		public var refX:Number;
		public var refY:Number;
		public var blend:String;
		public var colorTransform:ColorTransform;
		
		fexel var _matrixConcat:Matrix;
		fexel var _colorConcat:ColorTransform;
		
		
		private var _parent:DisplayObject;
		public function get parent ():DisplayObject { return this._parent; }
		fexel function setParent (v:DisplayObject):void { this._parent = v; }
		
		private var _stage:Stage;
		public function get stage ():Stage { return this._stage; }
		fexel function setStage (v:Stage):void { this._stage = v; }
		
		private var _matrix:Matrix;
		private var _oldTransformation:Object;
		
		fexel var _bounds:Rectangle2D;
		public function get boundingBox ():Rectangle2D { return this._bounds;	}
		
		/**
		 * Constructor
		 */
		public function DisplayObject(x:Number=0, y:Number=0, width:Number=0, height:Number=0)
		{
			super(x, y, width, height);
			this.visible = true;
			this.rotation = 0;
			this.scaleX = this.scaleY = 1;
			this.refX = this.refY = 0;
			this.blend = BlendMode.NORMAL;
			this.colorTransform = new ColorTransform();
			
			this._matrix = new Matrix();
			this._bounds = new Rectangle2D();
			
			this._matrixConcat = new Matrix();
			this._colorConcat = new ColorTransform();
		}
		
		/**
		 * Dispose
		 */
		public function dispose ():void
		{
			this._parent = null;
			this.colorTransform = null;
			this._oldTransformation = null;
			this._matrix = null;
			this._bounds = null;
			this._matrixConcat = null;
			this._colorConcat = null;
		}
		
		/**
		 * Update buffer
		 * 
		 * @param	rate
		 */
		public function update (rate:int = 0):void
		{
		}
		
		/**
		 * Pre Render
		 * 
		 * @param	rect
		 * @param	bounds
		 * @param	transformation
		 * @param	color
		 */
		fexel function preRender (rect:Rectangle2D, bounds:Rectangle2D, matrix:Matrix, color:ColorTransform):void
		{
			var m:Matrix = this.getMatrix();
			this._matrixConcat.a = m.a;
			this._matrixConcat.b = m.b;
			this._matrixConcat.c = m.c;
			this._matrixConcat.d = m.d;
			this._matrixConcat.tx = m.tx;
			this._matrixConcat.ty = m.ty;
			this._matrixConcat.concat(matrix);
			
			this._colorConcat.alphaMultiplier = this.colorTransform.alphaMultiplier;
			this._colorConcat.alphaOffset = this.colorTransform.alphaOffset;
			this._colorConcat.blueMultiplier = this.colorTransform.blueMultiplier;
			this._colorConcat.blueOffset = this.colorTransform.blueOffset;
			this._colorConcat.greenMultiplier = this.colorTransform.greenMultiplier;
			this._colorConcat.greenOffset = this.colorTransform.greenOffset;
			this._colorConcat.redMultiplier = this.colorTransform.redMultiplier;
			this._colorConcat.redOffset = this.colorTransform.redOffset;
			this._colorConcat.concat(color);
			
			var tx:Number = this.x, ty:Number = this.y;
			this.x = 0;
			this.y = 0;
			this.bounds(this._matrixConcat, this._bounds);
			this.x = tx;
			this.y = ty;
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
		fexel function render (buffer:BitmapData, rect:Rectangle2D, bounds:Rectangle2D, matrix:Matrix, color:ColorTransform, debug:uint, debugColor:DebugColor):void
		{
			var debugDraw:Sprite = Bitmap.sprite;
			if (debug > 0)
			{
				debugDraw.graphics.clear();
				if (debug & Screen.DEBUG_BOUNDINGBOX)
				{
					debugDraw.graphics.beginFill(0x000000, 0);
					debugDraw.graphics.lineStyle(1, debugColor.boundingColor);
					debugDraw.graphics.drawRect(this.boundingBox.x, this.boundingBox.y, this.boundingBox.width, this.boundingBox.height);
					debugDraw.graphics.endFill();
				}
				buffer.draw(debugDraw);
			}
		}
		
		/**
		 * Get transformation matrix
		 * 
		 * @return
		 */
		public function getMatrix ():Matrix
		{
			if (
				!this._oldTransformation ||
				this._oldTransformation.x != this.x ||
				this._oldTransformation.y != this.y ||
				this._oldTransformation.rotation != this.rotation ||
				this._oldTransformation.scaleX != this.scaleX ||
				this._oldTransformation.scaleY != this.scaleY ||
				this._oldTransformation.refX != this.refX ||
				this._oldTransformation.refY != this.refY
			)
			{
				this._matrix = this._matrix || new Matrix();
				this._matrix.identity();
				this._matrix.scale(this.scaleX, this.scaleY);
				this._matrix.translate(-this.refX, -this.refY);
				this._matrix.rotate((this.rotation % 360) * 0.0174532925);
				this._matrix.translate(this.refX, this.refY);
				this._matrix.translate(this.x, this.y);
				
				this._oldTransformation = {
					'x': this.x,
					'y': this.y,
					'rotation': this.rotation,
					'scaleX': this.scaleX,
					'scaleY': this.scaleY,
					'refX': this.refX,
					'refY': this.refY
				}
			}
			
			return this._matrix;
		}
		
		/**
		 * Get Concatenated Matrix
		 * 
		 * @param	target
		 * @return
		 */
		public function getConcatenatedMatrix (target:DisplayObject = null):Matrix
		{
			var next:DisplayObject = this,
				concatenated:Matrix = new Matrix();
			do
			{
				concatenated.translate(-next.refX, -next.refY);
				concatenated.concat(next.getMatrix());
				concatenated.translate(next.refX, next.refY);
				if (next == target) break;
			} while (next = next.parent);
			
			return concatenated;
		}
		
		/**
		 * Get Bounds
		 * 
		 * @return
		 */
		public function getBounds (matrix:Matrix = null):Rectangle2D
		{
			if (!matrix)
			{
				matrix = new Matrix(1, 0, 0, 1, -this.refX, -this.refY);
				matrix.concat(this.getMatrix());
			}
			return this.bounds(matrix);
		}
	}
}