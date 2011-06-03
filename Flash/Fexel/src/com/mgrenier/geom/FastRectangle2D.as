package com.mgrenier.geom
{
	import apparat.inline.Inlined;
	import apparat.math.FastMath;
	
	public class FastRectangle2D extends Inlined
	{
		/**
		 * Copy Rectangle
		 * 
		 * @param	a
		 * @return
		 */
		static public function copy (a:Rectangle2D):Rectangle2D
		{
			return new Rectangle2D(a.x, a.y, a.width, a.height);
		}
		
		/**
		 * Set Rectangle equal to other
		 * 
		 * @param	a
		 * @param	b
		 * @return
		 */
		static public function setRect (a:Rectangle2D, b:Rectangle2D):Rectangle2D
		{
			a.x = b.x;
			a.y = b.y;
			a.width = b.width;
			a.height = b.height;
			return a;
		}
		
		/**
		 * Set Rectangle values
		 * 
		 * @param	a
		 * @param	x
		 * @param	y
		 * @param	width
		 * @param	height
		 */
		static public function set(a:Rectangle2D, x:Number = Number.NaN, y:Number = Number.NaN, width:Number = Number.NaN, height:Number = Number.NaN):Rectangle2D
		{
			a.x = x || a.x;
			a.y = y || a.y;
			a.width = width || a.width;
			a.height = height || a.height;
			return a;
		}
		
		/**
		 * Offset Rectangle
		 * 
		 * @param	a
		 * @param	x
		 * @param	y
		 * @return
		 */
		static public function offset (a:Rectangle2D, x:Number, y:Number = Number.NaN):Rectangle2D
		{
			a.x += x;
			a.y += y || x;
			return a;
		}
		
		/**
		 * Inflate Rectangle
		 * 
		 * @param	a
		 * @param	width
		 * @param	height
		 * @return
		 */
		static public function inflate (a:Rectangle2D, width:Number, height:Number = Number.NaN):Rectangle2D
		{
			height = height || width;
			a.x -= width / 2;
			a.width += width;
			a.y -= height / 2;
			a.height += height;
			return a;
		}
		
		/**
		 * Rectangles intersects ?
		 * 
		 * @param	a
		 * @param	b
		 * @return
		 */
		static public function intersects (a:Rectangle2D, b:Rectangle2D):Boolean
		{
			return a.right > b.left && a.bottom > b.top && a.left < b.right && a.top < b.bottom;
		}
		
		/**
		 * Rectangle contains an other ?
		 * 
		 * @param	a
		 * @param	b
		 * @return
		 */
		static public function contains (a:Rectangle2D, b:Rectangle2D):Boolean
		{
			return a.left <= b.left && a.top <= b.top && a.right >= b.right && a.bottom >= b.bottom
		}
		
		/**
		 * Intersection between two rectangle
		 * 
		 * @param	a
		 * @param	b
		 * @return
		 */
		static public function intersection (a:Rectangle2D, b:Rectangle2D):Rectangle2D
		{
			return new Rectangle2D(
				FastMath.max(a.left, b.left),
				FastMath.max(a.top, b.top),
				FastMath.min(a.right, b.right) - FastMath.max(a.left, b.left),
				FastMath.min(a.bottom, b.bottom) - FastMath.max(a.top, b.top)
			);
		}
		
		/**
		 * Union between two rectangle
		 * 
		 * @param	a
		 * @param	b
		 * @return
		 */
		static public function union (a:Rectangle2D, b:Rectangle2D):Rectangle2D
		{
			return new Rectangle2D(
				a.left < b.left ? b.left : a.left,
				a.top > b.top ? a.top : b.top,
				a.left < b.left ? a.right - b.left : b.right - a.left,
				a.top > b.top ? b.bottom - a.top : a.bottom - b.top
			);
		}
		
	}
}