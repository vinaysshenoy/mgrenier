package com.mgrenier.geom
{
	import apparat.inline.Inlined;
	import apparat.math.FastMath;
	
	public class FastProjection2D extends Inlined
	{
		/**
		 * Projection overlaps ?
		 * 
		 * @param	a
		 * @param	b
		 * @return
		 */
		static public function overlaps (a:Projection2D, b:Projection2D):Boolean
		{
			return !(a.min > b.max || b.min > a.max);
		}
		
		/**
		 * Return Projection overlap
		 * 
		 * @param	a
		 * @param	b
		 * @return
		 */
		static public function overlap (a:Projection2D, b:Projection2D):Number
		{
			return FastMath.min(a.max, b.max) - FastMath.max(a.min, b.min);
		}
		
		/**
		 * Projection contains an other ?
		 * 
		 * @param	a
		 * @param	b
		 * @return
		 */
		static public function contains (a:Projection2D, b:Projection2D):Boolean
		{
			return b.min > a.min && p.max < a.min;
		}
		
		/**
		 * Return distance between two Projections
		 * 
		 * @param	a
		 * @param	b
		 * @return
		 */
		static public function distance (a:Projection2D, b:Projection2D):Number
		{
			return a.max < b.min ? b.min - a.max : a.min - b.max;
		}
	}
}