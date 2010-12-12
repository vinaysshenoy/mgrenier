package com.mgrenier.fexel.collision
{
	import com.mgrenier.fexel.Entity;
	import com.mgrenier.geom.Vec2D;

	public class ContactInfo
	{
		public var	entityA:Entity;
		public var	entityB:Entity;
		public var	entityAContained:Boolean;
		public var	entityBContained:Boolean;
		public var	distance:Number;
		public var	point:Vec2D;
		public var	separation:Vec2D;
		public var	surface:Vec2D;
		public var	normal:Vec2D;
	}
}