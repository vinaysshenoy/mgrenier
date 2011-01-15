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
	
	/**
	 * Display Object
	 * 
	 * @author Michael Grenier
	 */
	public class DisplayObject extends Rectangle2D implements Disposable
	{
		public var rotation:Number;
		public var scaleX:Number;
		public var scaleY:Number;
		public var refX:Number;
		public var refY:Number;
		public var blend:String;
		public var color:ColorTransform;
		
		
		private var _parent:DisplayObject;
		public function get parent ():DisplayObject { return this._parent; }
		fexel function setParent (v:DisplayObject):void { this._parent = v; }
		
		private var _matrix:Matrix;
		private var _oldTransformation:Object;
		
		/**
		 * Constructor
		 */
		public function DisplayObject(x:Number=0, y:Number=0, width:Number=0, height:Number=0)
		{
			super(x, y, width, height);
			this.rotation = 0;
			this.scaleX = this.scaleY = 1;
			this.refX = this.refY = 0;
			this.blend = BlendMode.NORMAL;
			this.color = new ColorTransform();
		}
		
		/**
		 * Dispose
		 */
		public function dispose ():void
		{
			this._parent = null;
			this._oldTransformation = null;
			this._matrix = null;
		}
		
		/**
		 * Render to buffer
		 * 
		 * @param	buffer
		 * @param	transformation
		 * @param	color
		 * @param	rate
		 */
		fexel function render (buffer:BitmapData, matrix:Matrix, color:ColorTransform, rate:int):void
		{
			throw new Error(this +" : Must be instanciated");
		}
		
		/**
		 * Get transformation matrix
		 * 
		 * @return
		 */
		public function getMatrix ():Matrix
		{
			if (
				!this._matrix ||
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
				this._matrix.rotate((this.rotation % 360) * 0.0174532925);
				this._matrix.scale(this.scaleX, this.scaleY);
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
			var	upperleft:Point = matrix.transformPoint(new Point(this.x, this.y)),
				upperright:Point = matrix.transformPoint(new Point(this.x + this.width, this.y)),
				bottomleft:Point = matrix.transformPoint(new Point(this.x, this.y + this.height)),
				bottomright:Point = matrix.transformPoint(new Point(this.x + this.width, this.y + this.height)),
				left:Number = Number.MAX_VALUE,
				right:Number = Number.MIN_VALUE,
				top:Number = Number.MAX_VALUE,
				bottom:Number = Number.MIN_VALUE,
			
			left = FastMath.min(upperleft.x, FastMath.min(upperright.x, FastMath.min(bottomleft.x, bottomright.x)));
			right = FastMath.max(upperleft.x, FastMath.max(upperright.x, FastMath.max(bottomleft.x, bottomright.x)));
			top = FastMath.min(upperleft.y, FastMath.min(upperright.y, FastMath.min(bottomleft.y, bottomright.y)));
			bottom = FastMath.max(upperleft.y, FastMath.max(upperright.y, FastMath.max(bottomleft.y, bottomright.y)));
			
			return new Rectangle2D(
				left + this.refX,
				top + this.refY,
				right - left,
				bottom - top
			);
		}
	}
}