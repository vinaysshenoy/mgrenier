package com.mgrenier.fexel.display 
{
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	
	/**
	 * Animated Sprite
	 * 
	 * @author Michael Grenier
	 */
	public class AnimatedSprite extends Sprite
	{
		protected var frameRate:int;
		
		protected var animations:Dictionary;
		
		protected var currentAnimation:String;
		
		protected var playing:Boolean = false;
		protected var currentFrame:Number = 0;
		protected var delaying:int = 0;
		
		/**
		 * Constructor
		 * 
		 * @param	w
		 * @param	h
		 * @param	r
		 * @param	a
		 */
		public function AnimatedSprite(w:Number, h:Number, rate:int = 24) 
		{
			super(w, h);
			this.frameRate = rate;
			this.animations = new Dictionary();
			this.currentAnimation = undefined;
		}
		
		/**
		 * Add animation
		 * 
		 * @param	name
		 * @param	cells
		 * @param	loop
		 * @return
		 */
		public function addAnimation (name:String, cells:Array, loop:Boolean = false):AnimatedSprite
		{
			this.animations[name] = new Animation(cells, loop);
			
			return this;
		}
		
		/**
		 * Play animation in 
		 * @param	animation
		 * @return
		 */
		public function play (animation:String, rate:int = undefined):AnimatedSprite
		{
			if (!this.animations[animation])
				throw new Error("Animation does not exist ! Please use addAnimation(\"" + animation + "\", ...) before calling play(\"" + animation + "\")");
			
			if (rate)
				this.frameRate = rate;
			
			this.playing = true;
			this.currentAnimation = animation;
			this.currentFrame = 0;
			this.delaying = 0;
			
			return this;
		}
		
		/**
		 * Stop animation
		 * 
		 * @return
		 */
		public function stop ():AnimatedSprite
		{
			this.playing = false;
			this.delaying = 0;
			
			return this;
		}
		
		/**
		 * Resume animation
		 * 
		 * @return
		 */
		public function resume ():AnimatedSprite
		{
			this.playing = true;
			this.delaying = 0;
			
			return this;
		}
		
		/**
		 * Delay animation for d frames
		 * 
		 * @param	d
		 * @return
		 */
		public function delay (d:int):AnimatedSprite
		{
			this.delaying = d;
			
			return this;
		}
		
		/**
		 * Step forward !
		 */
		override public function step (frameRate:int):void
		{
			if (this.playing && this.currentAnimation && this.animations[this.currentAnimation])
			{
				var anim:Animation = this.animations[this.currentAnimation] as Animation,
					currentFrame:int = Math.floor(this.currentFrame);
				this.delaying -= this.delaying > 0 ? 1 : 0;
				if (this.delaying == 0)
				{
					if (currentFrame > anim.getCells().length - 1)
					{
						if (anim.isLooping())
							this.currentFrame = currentFrame = 0;
						else
						{
							// TODO onComplete()
							this.stop();
							return;
						}
					}
					
					this.setCellIndex(anim.getCells()[currentFrame]);
					this.currentFrame += this.frameRate / frameRate;
				}
			}
			
			super.step(frameRate);
		}
		
	}
}

class Animation
{
	protected var cells:Array;
	public function getCells ():Array { return this.cells; }
	
	protected var loop:Boolean;
	public function isLooping ():Boolean { return this.loop; }
	
	public function Animation (cells:Array, loop:Boolean = false)
	{
		this.cells = cells;
		this.loop = loop;
	}
}