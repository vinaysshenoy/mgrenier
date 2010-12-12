package com.mgrenier.fexel.collision
{
	import com.mgrenier.fexel.Entity;
	import com.mgrenier.geom.Vec2D;

	public interface ICollision
	{
		
		function getContactInfo (entityA:Entity, entityB:Entity):ContactInfo;
		
	}
}