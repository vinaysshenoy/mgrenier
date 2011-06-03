package com.mgrenier.fexel.collision.shape
{
	import com.mgrenier.fexel.Entity;
	import com.mgrenier.fexel.collision.ContactInfo;
	import com.mgrenier.geom.Projection2D;
	import com.mgrenier.geom.Rectangle2D;
	import com.mgrenier.geom.Segment2D;
	import com.mgrenier.geom.Vec2D;
	
	import flash.display.Graphics;

	public class Circle extends AShape
	{
		protected var radius:Number;
		
		public function Circle(x:Number, y:Number, radius:Number)
		{
			super();
			
			this.center.set(x, y);
			this.radius = radius;
			
			this.aabb = new Rectangle2D(this.center.x - radius, this.center.y - radius, radius *2, radius *2);
			
		}
		
		/**
		 * Dispose shape
		 */
		override public function dispose ():void
		{
			this.center = null;
			this.radius = 0;
			super.dispose();
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
			var normals:Vector.<Vec2D> = new Vector.<Vec2D>(1),
				vertices:Vector.<Vec2D>,
				vertex:Vec2D,
				n:int,
				min:Number = Number.MAX_VALUE,
				dist:Number;
			
			//normals[0] = new Vec2D(0, 1);
			//normals[1] = new Vec2D(1, 0);
			
			// Circle / Circle Normals
			if (shapeB is Circle)
			{
				normals[0] = this.center.copy().addVec(offset).subtractVec(Circle(shapeB).center.copy().addVec(offsetB));
				normals[0].normalize();
			}
			
			// Circle / Polygon Normals
			else
			{
				var center:Vec2D = new Vec2D(offset.x + this.center.x, offset.y + this.center.y);
				normals[0] = new Vec2D(0, 0);
				vertices = Polygon(shapeB).getVertices();
				for (n = vertices.length - 1; n >= 0; n--)
				{
					vertex = vertices[n];
					dist = (center.x - offsetB.x + vertex.x) * (center.x - offsetB.x + vertex.x) + (center.y - offsetB.y + vertex.y) * (center.y - offsetB.y + vertex.y);
					if (dist < min)
					{
						min = dist;
						normals[0].x = offsetB.x + vertex.x;
						normals[0].y = offsetB.y + vertex.y;
					}
				}
				normals[0].subtractVec(center);
				normals[0].normalize();
			}
			
			return normals;
		}
		
		/**
		 * Project Polygon onto axis
		 * 
		 * @param	offset
		 * @param	axis
		 * @return	
		 */
		override public function projectOntoAxis (offset:Vec2D, axis:Vec2D):Projection2D
		{
			var min:Number = axis.dot(offset.copy().addVec(this.center));
			return new Projection2D(min - this.radius, min + this.radius);
		}
		
		/**
		 * Get Vector from Crossing multiple Segment
		 * 
		 * @param	shapeA
		 * @param	shapeB
		 * @param	offsetA
		 * @param	offsetB
		 * @param	contact
		 * @param	segments
		 * @return
		 */
		override public function pointFromSegmentsCrossing (shapeA:AShape, offsetA:Vec2D, shapeB:AShape, offsetB:Vec2D, contact:ContactInfo, segments:Vector.<Segment2D>):Boolean
		{
			var circle:Circle,
				center:Vec2D;
				
			if (shapeA instanceof Circle)
			{
				circle = Circle(shapeA);
				center = new Vec2D(offsetA.x, offsetA.y);
			}
			else
			{
				circle = Circle(shapeB);
				center = new Vec2D(offsetB.x, offsetB.y);
			}
			center.x += circle.center.x;
			center.y += circle.center.y;
			
			contact.point = center.subtractVec(contact.normal.copy().multiply(circle.radius - (contact.distance / 2)));
			return true;
		}
		
		/**
		 * Draw shape into graphics
		 * 
		 * @param	graphics
		 * @param	colorAlpha
		 * @param	colorAABB
		 * @param	colorShape
		 */
		override public function drawDebug (graphics:Graphics, colorAlpha:Number, colorShape:uint):void
		{
			graphics.beginFill(0x000000, 0);
			graphics.lineStyle(1, colorShape, colorAlpha);
			graphics.drawCircle(this.center.x, this.center.y, this.radius);
			graphics.endFill();
		}
	}
}