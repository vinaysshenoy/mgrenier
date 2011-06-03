package com.mgrenier.geom
{
	import apparat.math.FastMath;
	
	import flash.geom.Matrix;

	public class Matrix2D
	{
		public var a:Number;
		public var b:Number;
		public var c:Number;
		public var d:Number;
		public var tx:Number;
		public var ty:Number;
		
		/**
		 * Constructor
		 * 
		 * @param	a
		 * @param	b
		 * @param	c
		 * @param	d
		 * @param	tx
		 * @param	ty
		 */
		public function Matrix2D(a:Number = 1, b:Number = 0, c:Number = 0, d:Number = 1, tx:Number = 0, ty:Number = 0):void
		{
			this.a = a;
			this.b = b;
			this.c = c;
			this.d = d;
			this.tx = tx;
			this.ty = ty;
		}
		
		/**
		 * to String
		 * 
		 * @return
		 */
		public function toString ():String
		{
			return "(a="+this.a+", b="+this.b+", c="+this.c+", d="+this.d+", tx="+this.tx+", ty="+this.y+")";
		}
		
		/**
		 * To Flash Matrix
		 * 
		 * @return
		 */
		public function get matrix ():Matrix
		{
			return new Matrix(this.a, this.b, this.c, this.d, this.tx, this.ty);
		}
		
		/**
		 * Concatenate matrix values
		 * 
		 * @param	a
		 * @param	b
		 * @param	c
		 * @param	d
		 * @param	tx
		 * @param	ty
		 */
		public function concat (a:Number, b:Number, c:Number, d:Number, tx:Number, ty:Number):void
		{
			var ta:Number = this.a,
				tc:Number = this.c,
				ttx:Number = this.tx,
				tty:Number = this.ty;
			
			this.a = ta * a + this.b * c;
			this.b = ta * b + this.b * d;
			this.c = tc * a + this.d * c;
			this.d = tc * b + this.d * d;
			this.tx = ttx * a + tty * c + tx;
			this.ty = ttx * b + tty * d + ty;
		}
		
		/**
		 * Concatenate matrix
		 * 
		 * @param	m
		 */
		public function concatMatrix (m:Matrix2D):void
		{
			this.concat(m.a, m.b, m.c, m.d, m.tx, m.ty);
		}
		
		/**
		 * Rotate matrix
		 * 
		 * @param	a
		 */
		public function rotate (a:Number):void
		{
			var cos:Number = FastMath.cos(a),
				sin:Number = FastMath.sin(a),
				ta:Number = this.a,
				tc:Number = this.c,
				ttx:Number = this.tx,
				tty:Number = this.ty;
			
			this.a = ta * cos - this.b * sin;
			this.b = ta * sin + this.b * cos;
			this.c = tc * cos - this.d * sin;
			this.d = tc * sin + this.d * cos;
			this.tx = ttx * cos - tty * sin;
			this.ty = ttx * sin + tty * cos;
		}
		
		/**
		 * Scale matrix
		 * 
		 * @param	x
		 * @param	y
		 */
		public function scale (x:Number, y:Number):void
		{
			this.a *= x;
			this.d *= y;
			this.tx *= x;
			this.ty *= y;
		}
		
		/**
		 * Translate matrix
		 * 
		 * @param	x
		 * @param	y
		 */
		public function translate (x:Number, y:Number):void
		{
			tx += x;
			ty += y;
		}
		
		/**
		 * Reset to identity
		 */
		public function identity ():void
		{
			this.a = this.d = 1;
			this.c = this.d = this.tx = this.ty = 0;
		}
	}
}