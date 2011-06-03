package com.mgrenier.geom 
{
	import com.mgrenier.utils.IPool;
	
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	
	
	/**
	 * Rectangle
	 * 
	 * @author Michael Grenier
	 */
	public class Rectangle2D implements IPool
	{
		static public var zero:Rectangle2D = new Rectangle2D();
		
		public var x:Number;
		/*public function get x():int { return this._x; }
		public function set x(v:int):void
		{
			this._x = v;
		}*/
		
		public var y:Number;
		/*public function get y():int { return this._y; }
		public function set y(v:int):void
		{
			this._y = v;
		}*/
		
		public var width:Number;
		/*public function get width():int { return this._width; }
		public function set width(v:int):void
		{
			this._width = v;
		}*/
		
		public var height:Number;
		/*public function get height():int { return this._height; }
		public function set height(v:int):void
		{
			this._height = v;
		}*/
		
		public function get left():Number { return this.x; }
		public function get right():Number { return this.x + this.width; }
		public function get top():Number { return this.y; }
		public function get bottom():Number { return this.y + this.height; }
		
		/**
		 * Constructor
		 * @param	x
		 * @param	y
		 * @param	width
		 * @param	height
		 */
		public function Rectangle2D(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0) 
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}
		
		/**
		 * Copy Object
		 * @return
		 */
		public function copy ():Rectangle2D
		{
			return new Rectangle2D(this.x, this.y, this.width, this.height);
		}
		
		/**
		 * To String
		 * @return
		 */
		public function toString ():String
		{
			return "(" + this.x +", " + this.y +", " + this.width +", " + this.height +")";
		}
		
		/**
		 * To Flash Rectangle
		 * @return
		 */
		public function get rectangle ():Rectangle
		{
			return new Rectangle(this.x, this.y, this.width, this.height);
		}
		
		/**
		 * Adjuste the location of the Rectangle
		 * @param	x
		 * @param	y
		 * @return
		 */
		public function offset(x:Number, y:Number):Rectangle2D
		{
			this.x += x;
			this.y += y;
			
			return this;
		}
		
		/**
		 * Increases the size of the Rectangle
		 * @param	width
		 * @param	height
		 * @return
		 */
		public function inflate (width:Number, height:Number = undefined):Rectangle2D
		{
			height = height || width;
			
			this.x -= width;
			this.width += width * 2;
			
			this.y -= height;
			this.height += height * 2;
			
			return this;
		}
		
		/**
		 * Increases the size of the Rectangle
		 * @param	width
		 * @param	height
		 * @return
		 */
		public function inflateMultiply (width:Number, height:Number = undefined):Rectangle2D
		{
			height = height || width;
			
			width = this.width * width;
			height = this.height * height;
			
			return this.inflate(width / 2, height / 2);
		}
		
		/**
		 * Is Rectangle intersects with an other
		 * @param	r
		 * @return
		 */
		public function intersects(r:Rectangle2D):Boolean
		{
			return this.right > r.left && this.bottom > r.top && this.left < r.right && this.top < r.bottom;
		}
		
		/**
		 * Is Rectangle contains other
		 * 
		 * @param	r
		 * @return	
		 */
		public function contains (r:Rectangle2D):Boolean
		{
			return this.left <= r.left && this.top <= r.top && this.right >= r.right && this.bottom >= r.bottom;
		}
		
		/**
		 * Compute intersection of two rectangle
		 * @param	r
		 * @return 
		 */
		public function intersection (r:Rectangle2D):Rectangle2D
		{
			var intersection:Rectangle2D = new Rectangle2D();
			
			if (this.intersects(r))
			{
				intersection.x = Math.max(this.left, r.left);
				intersection.y = Math.max(this.top, r.top);
				intersection.width = Math.min(this.right, r.right) - intersection.x;
				intersection.height = Math.min(this.bottom, r.bottom) - intersection.y;
			}
			
			return intersection;
		}
		
		/**
		 * Get Rectangle2D that is the union of Rectangle + other
		 * @param	r
		 * @return
		 */
		public function union(r:Rectangle2D):Rectangle2D
		{
			return new Rectangle2D(
				this.left < r.left ? r.left : this.left,
				this.top > r.top ? this.top : r.top,
				this.left < r.left ? this.right - r.left : r.right - this.left,
				this.top > r.top ? r.bottom - this.top : this.bottom - r.top
			);
		}
		
	}

}