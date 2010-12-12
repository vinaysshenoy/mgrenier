package com.mgrenier.geom
{
	import apparat.math.FastMath;

	public class Projection2D
	{
		public var	min:Number,
					max:Number;
		
		/**
		 * Constructor
		 */
		public function Projection2D (min:Number, max:Number):void
		{
			this.min = min;
			this.max = max;
		}
		
		/**
		 * To String
		 * 
		 * @return
		 */
		public function toString ():String
		{
			return "(" + this.min +", " + this.max +")";
		}
		
		/**
		 * Overlap ?
		 * 
		 * @param	p
		 * @return	
		 */
		public function overlaps (p:Projection2D):Boolean
		{
			return !(this.min > p.max || p.min > this.max);
		}
		
		/**
		 * Get Overlap between 2 projections
		 * 
		 * @param	p
		 * @return
		 */
		public function overlap (p:Projection2D):Number
		{
			if (!this.overlaps(p)) return 0;
			return FastMath.min(this.max, p.max) - Math.max(this.min, p.min);
		}
		
		/**
		 * Contained within this projection
		 * 
		 * @param	p
		 * @return
		 */
		public function contains (p:Projection2D):Boolean
		{
			return p.min > this.min && p.max < this.max;
		}
		
		/**
		 * Distance between an other projection
		 * 
		 * @param	p
		 * @return
		 */
		public function distance (p:Projection2D):Number
		{
			if (this.overlaps(p)) return 0;
			return this.max < p.min ? p.min - this.max : this.min - p.max;
		}
	}
}