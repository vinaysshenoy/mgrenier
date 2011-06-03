package com.mgrenier.fexel.collision.shape
{
	import com.mgrenier.fexel.Entity;
	import com.mgrenier.fexel.collision.ContactInfo;
	import com.mgrenier.geom.Projection2D;
	import com.mgrenier.geom.Rectangle2D;
	import com.mgrenier.geom.Segment2D;
	import com.mgrenier.geom.Vec2D;
	
	import flash.display.Graphics;
	
	public class Polygon extends AShape
	{
		protected var vertices:Vector.<Vec2D>;
		private var normals:Vector.<Vec2D>;
		
		public function Polygon(vertices:Vector.<Vec2D>)
		{
			super();
			
			if (vertices.length < 3)
				throw new Error("Need at least 3 vertices to form a polygon");
			
			
			this.vertices = vertices;
			var	last:Vec2D = this.vertices[this.vertices.length-1],
				left:Number = last.x,
				top:Number = last.y,
				right:Number = last.x,
				bottom:Number = last.y,
				i:int,
				n:int,
				vertex:Vec2D;
			
			
			for (n = this.vertices.length - 2; n >= 0; n--)
			{
				vertex = this.vertices[n];
				left = Math.min(left, vertex.x);
				top = Math.min(top, vertex.y);
				right = Math.max(right, vertex.x);
				bottom = Math.max(bottom, vertex.y);
			}
			
			this.aabb = new Rectangle2D(left, top, right - left, bottom - top);
			
			var normals:Vector.<Vec2D> = new Vector.<Vec2D>(this.vertices.length),
				uniques:Vector.<Vec2D> = new Vector.<Vec2D>(),
				vertex1:Vec2D,
				vertex2:Vec2D,
				normal:Vec2D,
				unique:Vec2D,
				found:Boolean;
			
			for (i = 0, n = this.vertices.length; i < n; i++)
			{
				vertex1 = this.vertices[i];
				vertex2 = this.vertices[i + 1 == n ? 0 : i + 1];
				normal = vertex1.copy().subtractVec(vertex2).perp();
				normal.normalize();
				normals[i] = normal;
			}
			
			// Get non-parrallele normals
			for each (normal in normals)
			{
				found = false;
				for each (unique in uniques)
					if ((unique.x == normal.x && unique.y == normal.y) || (-unique.x == normal.x && -unique.y == normal.y))
					{
						found = true;
						continue;
					}
				if (!found)
					uniques.push(normal);
			}
			
			this.normals = uniques;
			
			// Compute center... from box2d
			var area:Number = 0,
				p2:Vec2D = new Vec2D(),
				p3:Vec2D = new Vec2D(),
				inv3:Number = 1 / 3,
				a:Number = 0,
				b:Number = 0;
			for (i = 0, n = this.vertices.length; i < n; ++i)
			{
				p2.set(this.vertices[i].x, this.vertices[i].y);
				p3.set(this.vertices[i + 1 < n ? 1 + 1 : 0].x, this.vertices[i + 1 < n ? 1 + 1 : 0].y);
				b = p2.x * p3.y - p2.y * p3.x;
				a = b * 0.5;
				area += a;
				this.center.x += a * inv3 * (p2.x + p3.x);
				this.center.y += a * inv3 * (p2.y + p3.y);
			}
			this.center.x *= 1 / area;
			this.center.y *= 1 / area;
			
		}
		
		/**
		 * Dispose shape
		 */
		override public function dispose ():void
		{
			this.vertices = null;
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
			return this.normals;
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
			var min:Number = axis.dot(this.vertices[0].copy().addVec(offset)),
				max:Number = min,
				i:int = 1,
				n:int = vertices.length,
				t:Number;
			
			for (; i < n; i++)
			{
				t = axis.dot(this.vertices[i].copy().addVec(offset));
				if (t < min)	min = t;
				if (t > max)	max = t;
			}
			
			return new Projection2D(min, max);
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
			if (!shapeB instanceof Polygon)
				return false;
			
			var i:int,
				j:int,
				k:int,
				n:int,
				m:int,
				point:Vec2D;
			
			contact.point = new Vec2D();
				
			k = 0;
			for (i = 0, n = segments.length; i < n; ++i)
			{
				for (j = 0, m = segments.length; j < m; ++j)
				{
					point = segments[i].intersection(segments[j]);
					if (point != null)
					{
						++k;
						contact.point.x += point.x;
						contact.point.y += point.y;
					}
				}
			}
			contact.point.x /= k;
			contact.point.y /= k;
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
			var last:Vec2D = this.vertices[this.vertices.length-1],
				vertex:Vec2D;
			graphics.beginFill(0x000000, 0);
			graphics.lineStyle(1, colorShape, colorAlpha);
			graphics.moveTo(last.x, last.y);
			
			for (var n:int = this.vertices.length - 2; n >= 0; n--)
			{
				vertex = this.vertices[n];
				graphics.lineTo(vertex.x, vertex.y);
			}
			
			graphics.endFill();
		}
		
		/**
		 * Get Vertices
		 * 
		 * @return	
		 */
		public function getVertices ():Vector.<Vec2D>
		{
			return this.vertices;
		}
	}
}