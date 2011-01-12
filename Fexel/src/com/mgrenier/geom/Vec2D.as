package com.mgrenier.geom 
{
	import apparat.math.FastMath;
	
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Vector 2D object
	 * 
	 * @author Michael Grenier
	 */
	public class Vec2D
	{
		static public var zero:Vec2D = new Vec2D();
		
		protected var _length:Number = undefined;
		
		private var _x:Number = 0;
		public function get x():Number { return this._x; }
		public function set x(v:Number):void
		{
			this._x = v;
			this._length = NaN;
		}
		
		private var _y:Number = 0;
		public function get y():Number { return this._y; }
		public function set y(v:Number):void {
			this._y = v;
			this._length = NaN;
		}
		
		/**
		 * Constructor
		 * @param	x
		 * @param	y
		 */
		public function Vec2D (x:Number = 0, y:Number = 0)
		{
			this.x = x;
			this.y = y;
		}
		
		/**
		 * Copy Object
		 * @return
		 */
		public function copy ():Vec2D
		{
			return new Vec2D(this.x, this.y);
		}
		
		/**
		 * To String
		 * @return
		 */
		public function toString ():String
		{
			return "(" + this.x +", " + this.y +")";
		}
		
		/**
		 * To Flash Point
		 * @return
		 */
		public function get point ():Point
		{
			return new Point(this.x, this.y);
		}
		
		/**
		 * Set Vector
		 * 
		 * @param	x
		 * @param	y
		 * @return
		 */
		public function set (x:Number, y:Number):Vec2D
		{
			this.x = x;
			this.y = y;
			return this;
		}
		
		/**
		 * Set from Vector
		 * 
		 * @param	v
		 * @return
		 */
		public function setVec (v:Vec2D):Vec2D
		{
			this.x = v.x;
			this.y = v.y;
			return this;
		}
		
		/**
		 * Add Vector
		 * 
		 * @param	x
		 * @param	y
		 * @return
		 */
		public function add (x:Number, y:Number):Vec2D
		{
			this.x += x;
			this.y += y;
			return this;
		}
		
		/**
		 * Add Vector
		 * @param	point
		 * @return
		 */
		public function addVec (v:Vec2D):Vec2D
		{
			this.x += v.x;
			this.y += v.y;
			return this;
		}
		
		/**
		 * Subtract Vector
		 * 
		 * @param	x
		 * @param	y
		 * @return
		 */
		public function subtract (x:Number, y:Number):Vec2D
		{
			this.x -= x;
			this.y -= y;
			return this;
		}
		
		/**
		 * Subtract Vector
		 * @param	point
		 * @return
		 */
		public function subtractVec (v:Vec2D):Vec2D
		{
			this.x -= v.x;
			this.y -= v.y;
			return this;
		}
		
		/**
		 * Multiply by scalar
		 * @param	scalar
		 * @return
		 */
		public function multiply (scalar:Number):Vec2D
		{
			this.x *= scalar;
			this.y *= scalar;
			return this;
		}
		
		/**
		 * Multiply by Vector
		 * @param	scalar
		 * @return
		 */
		public function multiplyVec (v:Vec2D):Vec2D
		{
			this.x *= v.x;
			this.y *= v.y;
			return this;
		}
		
		/**
		 * Divide by scalar
		 * @param	scalar
		 * @return
		 */
		public function divide (scalar:Number):Vec2D
		{
			var t:Number = 1 / scalar;
			this.x *= t;
			this.y *= t;
			return this;
		}
		
		/**
		 * Divide by Vector
		 * @param	scalar
		 * @return
		 */
		public function divideVec (v:Vec2D):Vec2D
		{
			this.x /= v.x;
			this.y /= v.y;
			return this;
		}
		
		/**
		 * Perpendicular
		 * 
		 * @return	
		 */
		public function perp ():Vec2D
		{
			var x:Number = this.x;
			this.x = -this.y;
			this.y = x;
			
			return this;
		}
		
		/**
		 * Normalize vector
		 * @return
		 */
		public function normalize ():Vec2D
		{
			var length:Number = this.length();
			if (length < Number.MIN_VALUE)
			{
				this.x = 0;
				this.y = 0;
			}
			else
			{
				this.multiply(1.0 / length);
			}
			
			return this;
		}
		
		/**
		 * Negate Vector
		 * @return
		 */
		public function negate ():Vec2D
		{
			this.x = -this.x;
			this.y = -this.y;
			
			return this;
		}
		
		/**
		 * Vector length
		 * @return
		 */
		public function length ():Number
		{
			if (isNaN(this._length))
				this._length = FastMath.sqrt(this.lengthSquared());
			
			return this._length;
		}
		
		/**
		 * Vector length squared
		 * @return
		 */
		public function lengthSquared ():Number
		{
			return this.x * this.x + this.y * this.y;
		}
		
		/**
		 * Get Dot product between other Vector
		 * @param	v
		 * @return
		 */
		public function dot (v:Vec2D):Number
		{
			return this.x * v.x + this.y * v.y;
		}
		
		/**
		 * Get Cross product between other Vector
		 * @param	v
		 * @return
		 */
		public function cross (v:Vec2D):Number
		{
			return this.x * v.y - this.y * v.x;
		}
		
		/**
		 * Project Vector onto other Vector
		 * @param	v
		 * @return
		 */
		public function project (v:Vec2D):Vec2D
		{
			var dot:Number = this.dot(v),
				t:Number = v.lengthSquared();
			
			this.x = (dot / t) * v.x;
			this.y = (dot / t) * v.y;
			
			return this;
		}
		
		/**
		 * Rotate Vector (Radian)
		 * 
		 * @param	rad
		 * @return
		 */
		public function rotate (rad:Number):Vec2D
		{
			var t:Number = this.x,
				cos:Number = FastMath.cos(rad),
				sin:Number = FastMath.sin(rad);
			this.x = t * cos - this.y * sin;
			this.y = t * sin + this.y * cos;
			return this;
		}
		
		/**
		 * Rotate Vector (Degree)
		 * 
		 * @param	deg
		 * @return
		 */
		public function rotateDegree (deg:Number):Vec2D
		{
			return this.rotate(deg * Math.PI / 180);
		}
		
		/**
		 * Return angle between 2 vectors in radian
		 * 
		 * @param	v
		 * @param	d
		 * @return
		 */
		public function angleBetween (v:Vec2D, d:Boolean = false):Number
		{
			var a:Number = this.dot(v) / (this.length() * v.length());
			var b:Number = a > 0 ? Math.acos(Math.min(a, 1)) : Math.acos(Math.max(a, -1));
			if (d)
				return b * (180 / Math.PI);
			return b;
		}
		
	}

}