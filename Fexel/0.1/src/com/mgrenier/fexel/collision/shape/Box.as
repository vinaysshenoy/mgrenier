package com.mgrenier.fexel.collision.shape
{
	import com.mgrenier.fexel.Entity;
	import com.mgrenier.geom.Vec2D;
	
	public class Box extends Polygon
	{
		private var normals:Vector.<Vec2D>;
		
		public function Box(x:int, y:int, width:int, height:int)
		{
			var vertices:Vector.<Vec2D> = new Vector.<Vec2D>(4);
			vertices[0] = new Vec2D(x, y);
			vertices[1] = new Vec2D(x+width, y);
			vertices[2] = new Vec2D(x+width, y+height);
			vertices[3] = new Vec2D(x, y+height);
			super(vertices);
			
			this.normals = new Vector.<Vec2D>(2);
			this.normals[0] = new Vec2D(0, 1);
			this.normals[1] = new Vec2D(1, 0);
			
		}
		
		/**
		 * Get Edges's normal
		 * 
		 * @param	offset
		 * @param	offsetB
		 * @param	shapeB
		 * @return	
		 */
		override public function getNormals (offset:Vec2D, offsetB:Vec2D, shapeB:AShape):Vector.<Vec2D>
		{
			return this.normals;
		}
	}
}