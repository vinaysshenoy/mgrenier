package com.mgrenier.geom
{
	import apparat.math.FastMath;

	/**
	 * Segment 2D object
	 * 
	 * @author Michael Grenier
	 */
	public class Segment2D
	{
		public var p1:Vec2D;
		public var p2:Vec2D;
		
		/**
		 * Constructor
		 */
		public function Segment2D(p1:Vec2D = null, p2:Vec2D = null)
		{
			this.p1 = p1 || new Vec2D();
			this.p2 = p2 || new Vec2D();
		}
		
		/**
		 * To String
		 * 
		 * @return
		 */
		public function toString ():String
		{
			return "(" + this.p1.x +", "+ this.p1.y +", "+ this.p2.x +", "+ this.p2.y +")";
		}
		
		/**
		 * Get Intersection with other Segment
		 * 
		 * @param	b
		 * @return
		 */
		public function intersection (b:Segment2D):Vec2D
		{
			var x1:Number = this.p1.x,
				y1:Number = this.p1.y,
				x2:Number = this.p2.x,
				y2:Number = this.p2.y,
				x3:Number = b.p1.x,
				y3:Number = b.p1.y,
				x4:Number = b.p2.x,
				y4:Number = b.p2.y,
				z1:Number = x1-x2,
				z2:Number = x3-x4,
				z3:Number = y1-y2,
				z4:Number = y3-y4,
				d:Number = z1 * z4 - z3 * z2;
			
			// No intersection ?
			if (d == 0) return null;
			
			var pre:Number = (x1*y2 - y1*x2),
				post:Number = (x3*y4 - y3*x4),
				x:Number = (pre * z2 - z1 * post) / d,
				y:Number = (pre * z4 - z3 * post) / d;
			
			// Within both lines ?
			//if (x < FastMath.min(x1, x2) || x > FastMath.max(x1, x2) ||	x < FastMath.min(x3, x4) || x > FastMath.max(x3, x4) ) return null;
			//if (y < FastMath.min(y1, y2) || y > FastMath.max(y1, y2) || y < FastMath.min(y3, y4) || y > FastMath.max(y3, y4) ) return null;
			
			return new Vec2D(x, y);
		}
	}
}