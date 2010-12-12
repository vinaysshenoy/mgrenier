package com.mgrenier.geom
{
	import apparat.inline.Inlined;
	import apparat.math.FastMath;

	public class FastVec2D extends Inlined
	{
		/**
		 * Copy Vector
		 * 
		 * @param	a
		 * @return
		 */
		static public function copy (a:Vec2D):Vec2D
		{
			return new Vec2D(a.x, a.y);
		}
		
		/**
		 * Set Vector equal to other
		 * 
		 * @param	a
		 * @param	b
		 * @return
		 */
		static public function setVec(a:Vec2D, b:Vec2D):Vec2D
		{
			a.x = b.x;
			a.y = b.y;
			return a;
		}
		
		/**
		 * Set Vector
		 * 
		 * @param	a
		 * @param	x
		 * @param	y
		 * @return
		 */
		static public function set(a:Vec2D, x:Number, y:Number = Number.NaN):Vec2D
		{
			a.x = x;
			a.y = y || x;
			return a;
		}
		
		/**
		 * Add Vector to an other
		 * 
		 * @param	a
		 * @param	b
		 * @return
		 */
		static public function addVec(a:Vec2D, b:Vec2D):Vec2D
		{
			a.x += b.x;
			a.y += b.y;
			
			return a;
		}
		
		/**
		 * Add to Vector
		 * 
		 * @param	a
		 * @param	x
		 * @param	y
		 * @return
		 */
		static public function add (a:Vec2D, x:Number, y:Number = Number.NaN):Vec2D
		{
			a.x += x;
			a.y += y || x;
			
			return a;
		}
		
		/**
		 * Subtract Vector to an other
		 * 
		 * @param	a
		 * @param	b
		 * @return
		 */
		static public function subtractVec(a:Vec2D, b:Vec2D):Vec2D
		{
			a.x -= b.x;
			a.y -= b.y;
			
			return a;
		}
		
		/**
		 * Subtract to Vector
		 * 
		 * @param	a
		 * @param	x
		 * @param	y
		 * @return
		 */
		static public function subtract (a:Vec2D, x:Number, y:Number = Number.NaN):Vec2D
		{
			a.x -= x;
			a.y -= y || x;
			
			return a;
		}
		
		/**
		 * Multiply Vector to an other
		 * 
		 * @param	a
		 * @param	b
		 * @return
		 */
		static public function multiplyVec(a:Vec2D, b:Vec2D):Vec2D
		{
			a.x *= b.x;
			a.y *= b.y;
			
			return a;
		}
		
		/**
		 * Multiply to Vector
		 * 
		 * @param	a
		 * @param	x
		 * @param	y
		 * @return
		 */
		static public function multiply (a:Vec2D, x:Number, y:Number = Number.NaN):Vec2D
		{
			a.x *= x;
			a.y *= y || x;
			
			return a;
		}
		
		/**
		 * Divide Vector to an other
		 * 
		 * @param	a
		 * @param	b
		 * @return
		 */
		static public function divideVec(a:Vec2D, b:Vec2D):Vec2D
		{
			a.x /= b.x;
			a.y /= b.y;
			
			return a;
		}
		
		/**
		 * Divide to Vector
		 * 
		 * @param	a
		 * @param	x
		 * @param	y
		 * @return
		 */
		static public function divide (a:Vec2D, x:Number, y:Number = Number.NaN):Vec2D
		{
			a.x /= x;
			a.y /= y || x;
			
			return a;
		}
		
		/**
		 * Distance between two Vector
		 * 
		 * @param	a
		 * @param	b
		 * @return
		 */
		static public function distance (a:Vec2D, b:Vec2D):Number
		{
			return FastMath.sqrt((a.x-b.x) * (a.x-b.x) + (a.y-b.y) * (a.y-b.y));
		}
		
		/**
		 * Make Vector perpendicular
		 * 
		 * @param	a
		 * @return
		 */
		static public function perp (a:Vec2D):Vec2D
		{
			var x:Number = a.x;
			a.x = -a.y;
			a.y = x;
			return a;
		}
		
		/**
		 * Negate Vector
		 * 
		 * @param	a
		 * @return	
		 */
		static public function negate (a:Vec2D):Vec2D
		{
			a.x = -a.x;
			a.y = -a.y;
			return a;
		}
		
		/**
		 * Get Dot Product from two Vector
		 * 
		 * @param	a
		 * @param	b
		 * @return
		 */
		static public function dot (a:Vec2D, b:Vec2D):Number
		{
			return a.x * b.x + a.y * b.y;
		}
		
		/**
		 * Get Cross Product from two Vector
		 * 
		 * @param	a
		 * @param	b
		 * @return
		 */
		static public function cross (a:Vec2D, b:Vec2D):Number
		{
			return a.x * b.x - a.y * b.y;
		}
		
		/**
		 * Project Vector onto an other
		 * 
		 * @param	a
		 * @param	b
		 * @return	
		 */
		static public function project (a:Vec2D, b:Vec2D):Vec2D
		{
			var dot:Number = a.x * b.x + a.y * b.y,
				t:Number = b.x * b.x + b.y * b.y;
			a.x = (dot / t) * b.x;
			a.y = (dot / t) * b.y;
			return a;
		}
	}
}