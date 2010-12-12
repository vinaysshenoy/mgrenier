package com.mgrenier.fexel 
{
	use namespace fexel;
	
	import apparat.math.FastMath;
	
	import com.mgrenier.fexel.Entity;
	import com.mgrenier.fexel.collision.ContactInfo;
	import com.mgrenier.fexel.collision.IBroadphase;
	import com.mgrenier.fexel.collision.ICollision;
	import com.mgrenier.fexel.collision.shape.AShape;
	import com.mgrenier.geom.FastVec2D;
	import com.mgrenier.geom.Rectangle2D;
	import com.mgrenier.geom.Vec2D;
	import com.mgrenier.utils.Console;
	import com.mgrenier.utils.Disposable;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Michael Grenier
	 */
	public class World extends EntitiesContainer implements Disposable
	{
		static public const SLEEPTOLERANCE:Number = 0.08;
		static public const SLEEPAFTERFRAME:int = 60;
		
		[Embed(source = "data/nokiafc22.ttf", fontFamily = "system", embedAsCFF = "false")]
		protected var font:String;
		
		public var gravity:Vec2D;
		public var friction:Number = 0;
		
		protected var views:Vector.<View>;
		protected var activeRect:Rectangle2D;
		protected var broadphase:IBroadphase;
		protected var collider:ICollision;
		
		/**
		 * Constructor
		 * 
		 * @param	width
		 * @param	height
		 */
		public function World() 
		{
			this.setWorld(this);
			this.gravity = new Vec2D();
			
			this.views = new Vector.<View>();
		}
		
		/**
		 * Step forward world !
		 */
		public function step (frameRate:int, autoRender:Boolean = true):void
		{
			// Make copy of current entities...
			var entities:Vector.<Entity> = this.entities.concat(),
				n:int;
			
			// Reset entities to render
			for (n = this.views.length - 1; n >= 0; n--)
				View(this.views[n]).resetEntitiesToRender();
			
			// Loop
			var activeEntities:Vector.<Entity> = new Vector.<Entity>(),
				entity:Entity,
				view:View,
				shape:AShape,
				pairs:Vector.<Entity>,
				contact:ContactInfo,
				activeRect:Rectangle2D = this.getActiveRect(),
				broadphase:IBroadphase = this.getBroadphase(),
				collider:ICollision = this.getCollider(),
				k:Object,
				i:int,
				j:int,
				m:int,
				contactEntity:Object,
				newContacts:Dictionary,
				persistedContacts:Dictionary,
				tempVec:Vec2D = new Vec2D(),
				impactVelA:Vec2D = new Vec2D(),
				impactVelB:Vec2D = new Vec2D(),
				frictionVelA:Vec2D = new Vec2D(),
				frictionVelB:Vec2D = new Vec2D(),
				bounceVelA:Vec2D = new Vec2D(),
				bounceVelB:Vec2D = new Vec2D(),
				p:Number,
				frictionA:Number,
				frictionB:Number,
				bounceA:Number,
				bounceB:Number,
				collisionTimer:int,
				stepTimer:int;
			
			// Get Active entities
			for (i = 0, n = this.entities.length; i < n; i++)
			{
				entity = this.entities[i];
				
				// Entity not active, skip
				if (!entity.active || (activeRect && !activeRect.intersects(entity.getRect())))
					continue;
				
				// Build Active entities
				activeEntities.push(entity);
				
				// Contact frame reset
				entity.frameContact = new Dictionary(true);
				
				// Initial velocity
				entity.initialVelocity.x = entity.velocity.x;
				entity.initialVelocity.y = entity.velocity.y;
			}
			
			stepTimer = getTimer();
			
			// Step & Render active entities
			for (i = 0, n = activeEntities.length; i < n; i++)
			{
				entity = activeEntities[i];
				shape = entity.getShape();
				
				collisionTimer = getTimer();
				
				// Process collision
				if (entity.dynamic && entity.sleeping <= World.SLEEPAFTERFRAME && shape != null && broadphase != null && collider != null)
				{
					entity.velocity.multiply(1-this.friction).addVec(this.gravity);
					
					entity.x += entity.velocity.x;
					entity.y += entity.velocity.y;
					
					// Update Broadphase
					if (entity.updated)
						broadphase.update(entity);
					
					// Contact Listener
					newContacts = new Dictionary(true);
					persistedContacts = new Dictionary(true);
					for (contactEntity in entity.newContact)			newContacts[contactEntity] = 1;
					for (contactEntity in entity.persistedContact)		persistedContacts[contactEntity] = 1;
					entity.newContact = new Dictionary(true);
					entity.persistedContact = new Dictionary(true);
					entity.deadContact = new Dictionary(true);
					
					// Get Pairs
					pairs = broadphase.overlapEntity(entity);
					for (m = pairs.length - 1; m >= 0; m--)
					{
						// Collision already occured
						//if (pairs[m].frameContact[entity])
						//	continue;
						
						// Contact Listener ? Pair ?
						if (!entity.handlerCollisionPair(pairs[m]) && !pairs[m].handlerCollisionPair(entity))
							continue;
						
						contact = collider.getContactInfo(entity, pairs[m]);
						if (contact != null)
						{
							// Frame contact
							entity.frameContact[pairs[m]] = 1;
							pairs[m].frameContact[entity] = 1;
							
							// Persisted contact
							if (persistedContacts[pairs[m]] != undefined || newContacts[pairs[m]] != undefined)
							{
								entity.persistedContact[pairs[m]] = 1;
								entity.handlerPersistingContact(pairs[m], contact);
								pairs[m].persistedContact[entity] = 1;
								pairs[m].handlerPersistingContact(entity, contact);
							}
							
							// New contact
							else
							{
								entity.newContact[pairs[m]] = 1;
								entity.handlerNewContact(pairs[m], contact);
								pairs[m].newContact[entity] = 1;
								pairs[m].handlerNewContact(entity, contact);
							}
							delete persistedContacts[pairs[m]];
							delete newContacts[pairs[m]];
							
							// Sensors
							if (!entity.sensor && !contact.entityB.sensor && ~(entity.group & contact.entityB.group))
							{
								// Contact Listener ? Contact ?
								if (!entity.handlerCollisionContact(pairs[m]) && !pairs[m].handlerCollisionContact(entity))
									continue;
								
								// Response A Friction + Bounce
								impactVelA.x = entity.velocity.x;
								impactVelA.y = entity.velocity.y;
								impactVelB.x = contact.entityB.velocity.x;
								impactVelB.x = contact.entityB.velocity.y;
								
								// Impact Ratio
								p = entity.mass / (entity.mass + contact.entityB.mass);
								//p = 0;
								p = FastMath.isNaN(p) ? 0 : p;
								//frictionA = entity.friction / (entity.friction + contact.entityB.friction);
								//frictionA = FastMath.isNaN(frictionA) ? 0 : 1-frictionA;
								frictionA = 1-((entity.friction + contact.entityB.friction) / 2);
								//bounceA = entity.bounce / (entity.bounce + contact.entityB.bounce);
								//bounceA = FastMath.isNaN(bounceA) ? 0 : bounceA;
								bounceA = (entity.bounce + contact.entityB.bounce) / 2;
								
								entity.velocity.set(0, 0);
								entity.velocity.subtractVec(impactVelA.copy().project(contact.normal).multiply(bounceA)); // bounce
								entity.velocity.addVec(impactVelA.copy().project(contact.surface).multiply(frictionA)); // friction
								
								// Agains dynamic
								if (contact.entityB.dynamic)
								{
									// Separation A-B
									entity.x += contact.separation.x * 0.5;
									entity.y += contact.separation.y * 0.5;
									contact.entityB.x -= contact.separation.x * 0.5;
									contact.entityB.y -= contact.separation.y * 0.5;
									
									// http://www.gamedev.net/community/forums/topic.asp?topic_id=390861
									// http://en.wikipedia.org/wiki/Coefficient_of_restitution
									
									// Same mass && bounce 100% => exchange velocity {
									//tempVec.setVec(impactVelA);
									//entity.velocity.setVec(impactVelB);
									//contact.entityB.velocity.setVec(tempVec);
									
									entity.velocity.addVec(impactVelB.copy().project(contact.normal).multiply(1-p).multiply(bounceA));
									contact.entityB.velocity.addVec(impactVelA.copy().project(contact.normal).multiply(p).multiply(bounceA));
									// }
									
									//impactVelA.x += impactVelB.x * (1-p);
									//impactVelA.y += impactVelB.y * (1-p);
									
									/*entity.velocity.set(0, 0);
									entity.velocity.addVec(impactVelA.copy().project(contact.normal).multiply(bounceA)); // bounce
									entity.velocity.addVec(impactVelA.copy().project(contact.normal.perp()).multiply(frictionA)); // friction*/
									
									//impactVelB.x += tempVec.x * p;
									//impactVelB.y += tempVec.y * p;
									
									//entity.velocity.multiply(1-p).addVec(impactVelA.copy().multiply(p)).subtractVec(impactVelB.copy().multiply(1-p));
									
									/*frictionB = contact.entityB.friction / (entity.friction + contact.entityB.friction);
									frictionB = FastMath.isNaN(frictionB) ? 0 : 1-frictionB;
									bounceB = contact.entityB.bounce / (entity.bounce + contact.entityB.bounce);
									bounceB = FastMath.isNaN(bounceB) ? 0 : bounceB;*/
									
									//contact.entityB.velocity.set(0, 0);
									//contact.entityB.velocity.subtractVec(impactVelB.copy().project(contact.normal).multiply(bounceA)); // bounce
									//contact.entityB.velocity.addVec(impactVelB.copy().project(contact.normal.perp()).multiply(frictionA)); // friction
									
									//contact.entityB.velocity.multiply(p).addVec(impactVelB.copy().multiply(1-p)).subtractVec(impactVelA.copy().multiply(p));*/
									
									
									// Waking ?
									if (contact.entityB.velocity.length() > World.SLEEPTOLERANCE)
									{
										contact.entityB.sleeping *= 0.5;
										entity.sleeping *= 0.5;
									}
								}
								
								// Agains static
								else
								{
									entity.x += contact.separation.x;
									entity.y += contact.separation.y;
								}
								
							}
						}
					}
					
					// Dead contact
					for (contactEntity in newContacts)
					{
						entity.deadContact[contactEntity] = 1;
						entity.handlerDeadContact(Entity(contactEntity));
						Entity(contactEntity).deadContact[entity] = 1;
						Entity(contactEntity).handlerDeadContact(entity);
						Entity(contactEntity).sleeping = 0;
					}
					for (contactEntity in persistedContacts)
					{
						entity.deadContact[contactEntity] = 1;
						entity.handlerDeadContact(Entity(contactEntity));
						Entity(contactEntity).deadContact[entity] = 1;
						Entity(contactEntity).handlerDeadContact(entity);
						Entity(contactEntity).sleeping = 0;
					}
					
					
					// Sleeping ?
					if (entity.velocity.length() <= World.SLEEPTOLERANCE)
						entity.sleeping = entity.sleeping > World.SLEEPAFTERFRAME ? entity.sleeping : entity.sleeping+1;
					//else
					//	trace(entity.velocity.length());
				}
				
				entity.step(frameRate);
				
				
				// Determine if entity is in view(s)
				for (m = this.views.length - 1; m >= 0; m--)
				{
					view = this.views[m] as View;
					
					// View not active, skip
					if (!view.active)
						continue;
					
					// Add to view if entity in view
					if (view.entityInView(entity))
						view.addEntitiesToRender(entity);
				}
			}
			
			//trace('Step      ', getTimer() - stepTimer, 'ms');
			
			// Render views ?
			if (autoRender)
				this.render(frameRate)
		}
		
		/**
		 * Step & Render Views
		 */
		public function render (frameRate:int):void
		{
			var view:View,
				timer:int = getTimer();
			for (var n:int = this.views.length - 1; n >= 0; n--)
			{
				view = this.views[n] as View;
				if (view.active)
				{
					view.step(frameRate);
					view.render(frameRate);
				}
			}
			
			//trace('Render    ', getTimer() - timer, 'ms');
		}
		
		/**
		 * Add entity to the world
		 * 
		 * @param	e
		 * @return
		 */
		override public function addEntity (e:Entity):Entity
		{
			super.addEntity(e);
			
			var b:IBroadphase = this.getBroadphase();
			if (b && e.getShape())
				b.add(e);
			
			return e;
		}
		
		/**
		 * Remove entity from world
		 * 
		 * @param	e
		 * @return
		 */
		override public function removeEntity (e:Entity):Entity
		{
			super.removeEntity(e);
			
			var b:IBroadphase = this.getBroadphase();
			if (b && e.getShape())
				b.remove(e);
			
			return e;
		}
		
		/**
		 * Set Collider object
		 * 
		 * @param	c
		 * @return
		 */
		final public function setCollider (c:ICollision):World
		{
			this.collider = c;
			
			return this;
		}
		
		/**
		 * Get Collider object
		 * 
		 * @return
		 */
		final public function getCollider ():ICollision
		{
			return this.collider;
		}
		
		/**
		 * Set Broadphase object
		 * 
		 * @param	b
		 * @return
		 */
		final public function setBroadphase (b:IBroadphase):World
		{
			this.broadphase = b;
			this.broadphase.reset(this.entities);
			
			return this;
		}
		
		/**
		 * Get Broadphase object
		 * 
		 * @return
		 */
		final public function getBroadphase ():IBroadphase
		{
			return this.broadphase;
		}
		
		/**
		 * Set Active rectangle
		 * 
		 * @param	r
		 * @return
		 */
		final public function setActiveRect (r:Rectangle2D):World
		{
			this.activeRect = r;
			
			return this;
		}
		
		/**
		 * Get Active rectangle
		 * 
		 * @param	r
		 * @return
		 */
		final public function getActiveRect ():Rectangle2D
		{
			return this.activeRect;
		}
		
		/**
		 * Add view
		 * 
		 * @param	v
		 * @return
		 */
		final public function addView (v:View):View
		{
			this.views.push(v);
			return v;
		}
		
		/**
		 * Remove entity
		 * 
		 * @param	v
		 * @return
		 */
		final public function removeView (v:View):View
		{
			this.views.splice(this.views.indexOf(v), 1);
			return v;
		}
		
		/**
		 * Remove all views
		 */
		final public function removeAllViews ():void
		{
			while (this.views.length > 0)
				this.views.pop();
		}
		
		/**
		 * Dispose World
		 */
		override public function dispose ():void
		{
			super.dispose();
			
			var v:View;
			while (this.views.length > 0)
			{
				v = this.views.pop();
				v.dispose();
				v = null;
			}
			this.views = null;
		}
		
	}

}