package
{
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import flash.geom.Rectangle;
   
   public class ParticleSystemSimple extends MovieClip
   {
      
      public var holder:Vector.<MyLittleParticle>;
      
      public var useWorldGravity:Boolean;
      
      public var fade:ColorTransform;
      
      public var particleHealth:int;
      
      public var particleRestitution:Number;
      
      public var particleFriction:Number;
      
      public var particleFade:Number;
      
      public var particleFadeRandom:Number;
      
      public var particleGravity:Number;
      
      public var particleSpeedCap:Number;
      
      public var particleWander:Number;
      
      public var particleCollide:Boolean;
      
      public var particleRect:Rectangle;
      
      public function ParticleSystemSimple(param1:String, param2:Number, param3:Number)
      {
         super();
         name = param1;
         this.holder = new Vector.<MyLittleParticle>();
         this.useWorldGravity = true;
         this.particleHealth = 100;
         this.particleRestitution = 0.1;
         this.particleFade = 0;
         this.particleFadeRandom = 0;
         this.particleFriction = 1;
         this.particleGravity = 0;
         this.particleSpeedCap = 100;
         this.particleWander = 0;
         this.particleCollide = true;
         this.particleRect = new Rectangle(0,0,param2,param3);
      }
      
      public function addParticles(param1:int, param2:Number, param3:Number, param4:uint, param5:Number, param6:Number, param7:Number, param8:Number) : Vector.<MyLittleParticle>
      {
         var _loc11_:MyLittleParticle = null;
         var _loc9_:Vector.<MyLittleParticle> = new Vector.<MyLittleParticle>();
         var _loc10_:int = 0;
         while(_loc10_ < param1)
         {
            _loc11_ = new MyLittleParticle(this.particleRect,param2,param3,param5 + (Math.random() * (2 * param7) - param7),param6 + (Math.random() * (2 * param8) - param8));
            _loc11_.health = this.particleHealth;
            _loc11_.restitution = this.particleRestitution;
            _loc11_.friction = this.particleFriction;
            _loc11_.colour = param4;
            _loc11_.collide = this.particleCollide;
            if(this.particleFade != 0 || this.particleFadeRandom != 0)
            {
               _loc11_.fade = this.particleFade + Math.random() * this.particleFadeRandom;
            }
            this.holder.push(_loc11_);
            _loc9_.push(_loc11_);
            _loc10_++;
         }
         return _loc9_;
      }
      
      public function update(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc6_:MyLittleParticle = null;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         if(this.particles == 0)
         {
            return;
         }
         var _loc4_:Number = this.particleGravity;
         if(this.useWorldGravity)
         {
            _loc4_ += param1 * 0.007;
         }
         var _loc5_:* = 0;
         while(_loc5_ < this.holder.length)
         {
            _loc6_ = this.holder[_loc5_];
            if(_loc6_.remove)
            {
               this.holder.splice(_loc5_,1);
               _loc5_--;
               _loc6_ = null;
            }
            else
            {
               if(this.particleWander != 0)
               {
                  if(Math.random() > 0.9)
                  {
                     _loc6_.wanderX = Math.random() * this.particleWander - this.particleWander * 0.5;
                     _loc6_.wanderY = Math.random() * this.particleWander - this.particleWander * 0.5;
                  }
               }
               _loc7_ = _loc6_.x;
               _loc8_ = _loc6_.y;
               _loc6_.update(_loc4_,param2 * 0.25,param3);
            }
            _loc5_++;
         }
      }
      
      public function clear() : void
      {
         var _loc1_:MyLittleParticle = null;
         while(this.holder.length > 0)
         {
            _loc1_ = this.holder[0];
            this.holder.splice(0,1);
            _loc1_ = null;
         }
         this.holder = new Vector.<MyLittleParticle>();
      }
      
      public function get particles() : int
      {
         return this.holder.length;
      }
   }
}

