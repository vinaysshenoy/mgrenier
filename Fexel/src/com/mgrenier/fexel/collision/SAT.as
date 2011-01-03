package com.mgrenier.fexel.collision
{
	import apparat.math.FastMath;
	
	import com.mgrenier.fexel.Entity;
	import com.mgrenier.fexel.collision.shape.AShape;
	import com.mgrenier.fexel.collision.shape.Circle;
	import com.mgrenier.fexel.collision.shape.Polygon;
	import com.mgrenier.geom.Projection2D;
	import com.mgrenier.geom.Segment2D;
	import com.mgrenier.geom.Vec2D;

	public class SAT implements ICollision
	{
		/**
		 * Get Collision with Entity
		 * 
		 * http://www.sevenson.com.au/actionscript/sat/
		 * http://www.codezealot.org/archives/55
		 */
		public function getContactInfo (entityA:Entity, entityB:Entity):ContactInfo
		{
			var	info:ContactInfo,
				shapeA:AShape = entityA.getShape(),
				shapeB:AShape = entityB.getShape();
			
			info = SAT.testShape(entityA.getPosition(), entityA.getShape(), entityB.getPosition(), entityB.getShape());
			if (!info) return null;
			
			// TODO Multiple shape per-entity ?
			
			info.entityA = entityA;
			info.entityB = entityB;
			return info;
		}
		
		/**
		 * Polygon / Polygon collision
		 * 
		 * @param	entityA
		 * @param	entityB
		 * @param	flip
		 * @return	
		 */
		static protected function testShape (offsetA:Vec2D, shapeA:AShape, offsetB:Vec2D, shapeB:AShape):ContactInfo
		{
			var	i:int,
				j:int,
				k:int,
				n:int,
				m:int,
				o:int,
				bothNormals:Array,
				normals:Vector.<Vec2D>,
				normal:Vec2D,
				uniqueNormals:Vector.<Vec2D> = new Vector.<Vec2D>(),
				unique:Vec2D,
				parrallele:Boolean,
				normalsA:Vector.<Vec2D> = shapeA.getNormals(offsetA, offsetB, shapeB),
				normalsB:Vector.<Vec2D> = shapeB.getNormals(offsetB, offsetA, shapeA),
				projectionA:Projection2D,
				projectionB:Projection2D,
				smallestOverlap:Number = Number.MAX_VALUE,
				overlap:Number,
				middle:Vec2D,
				min:Vec2D,
				max:Vec2D,
				segments:Vector.<Segment2D> = new Vector.<Segment2D>(),
				smallestAxis:Vec2D,
				info:ContactInfo = new ContactInfo();
			
			info.entityAContained = true;
			info.entityBContained = true;
			
			// For each Shapes's Normals, find non-parrallele normals
			bothNormals = [normalsA, normalsB];
			for (i = bothNormals.length -1; i >= 0; --i)
			{
				for (normals = Vector.<Vec2D>(bothNormals[i]), j = normals.length -1; j >= 0; --j)
				{
					normal = normals[j];
					parrallele = false;
					for (k = uniqueNormals.length -1; k >= 0; --k)
					{
						unique = uniqueNormals[k];
						if ((unique.x == normal.x && unique.y == normal.y) || (-unique.x == normal.x && -unique.y == normal.y))
						{
							parrallele = true;
							continue;
						}
					}
					if (!parrallele)
						uniqueNormals.push(normal);
				}
			}
			
			// For each non-parrallele normals
			for (i = uniqueNormals.length -1; i >= 0; --i)
			{
				normal = uniqueNormals[i];
				
				// Project shapes onto axis
				projectionA = shapeA.projectOntoAxis(offsetA, normal);
				projectionB = shapeB.projectOntoAxis(offsetB, normal);
				
				// Intersection ?
				if (!projectionA.overlaps(projectionB))
					return null; // Gap found, exit !
				
				info.entityAContained = info.entityAContained && projectionB.contains(projectionA);
				info.entityBContained = info.entityBContained && projectionA.contains(projectionB);
				
				// Overlap distance
				overlap = projectionA.overlap(projectionB);
				
				// Overlap center & axis
				middle = normal.copy().multiply(FastMath.max(projectionA.min, projectionB.min) + (overlap / 2));
				min = normal.copy().perp().multiply(-10000000000).addVec(middle);
				max = normal.copy().perp().multiply(10000000000).addVec(middle);
				segments.push(new Segment2D(min, max));
				
				// Smallest overlap => exit axis !
				if (overlap < smallestOverlap)
				{
					smallestOverlap = overlap;
					smallestAxis = normal.copy();
					if (overlap != projectionB.max - projectionA.min)
						smallestAxis.negate();
				}
			}
			
			// Determine Minimum Translation Vector
			info.distance = smallestOverlap;
			info.normal = smallestAxis;
			info.surface = smallestAxis.copy().perp();
			info.separation = info.normal.copy().multiply(info.distance);
			
			// Determine point of impact
			//if (!shapeA.pointFromSegmentsCrossing(shapeA, offsetA, shapeB, offsetB, info, segments))
			//	shapeB.pointFromSegmentsCrossing(shapeB, offsetB, shapeA, offsetA, info, segments);
			
			return info;
		}
	}
}
