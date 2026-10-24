package
{
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   
   public class ParticleSystem
   {
      
      public var graphic:BitmapData;
      
      public var name:String;
      
      public var holder:Vector.<MyLittleParticle>;
      
      public var pixelColour:uint;
      
      public var useWorldGravity:Boolean;
      
      public var smooth:Boolean;
      
      public var simple:Boolean;
      
      public var particleHealth:int;
      
      public var particleRestitution:Number;
      
      public var particleFriction:Number;
      
      public var particleFade:Number;
      
      public var particleFadeRandom:Number;
      
      public var particleGravity:Number;
      
      public var particleSpeedCap:Number;
      
      public var particleWander:Number;
      
      public var particleCollide:Boolean;
      
      public var particleBounds:Rectangle;
      
      public var particlerect:Rectangle;
      
      public var pW:Number;
      
      public var pH:Number;
      
      public var pWHalf:Number;
      
      public var pHHalf:Number;
      
      public function ParticleSystem(param1:String, param2:Number, param3:Number, param4:BitmapData)
      {
         super();
         this.name = param1;
         this.graphic = param4;
         this.holder = new Vector.<MyLittleParticle>();
         this.useWorldGravity = true;
         this.smooth = false;
         this.particleHealth = 100;
         this.particleRestitution = 0.1;
         this.particleFade = 0;
         this.particleFadeRandom = 0;
         this.particleFriction = 1;
         this.particleGravity = 0;
         this.particleSpeedCap = 100;
         this.particleWander = 0;
         this.particleCollide = true;
         this.particleBounds = new Rectangle(0,0,GameState.width * 2,GameState.height * 2);
         this.name = param1;
         this.pW = param4.width;
         this.pH = param4.height;
         this.pWHalf = param4.width * 0.5;
         this.pHHalf = param4.height * 0.5;
         this.particlerect = new Rectangle(0,0,this.pW,this.pH);
      }
      
      public function addParticles(param1:int, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : Vector.<MyLittleParticle>
      {
         var _loc10_:MyLittleParticle = null;
         var _loc8_:Vector.<MyLittleParticle> = new Vector.<MyLittleParticle>();
         var _loc9_:int = 0;
         while(_loc9_ < param1)
         {
            _loc10_ = new MyLittleParticle(this.particleBounds,param2,param3,param4 + Math.random() * (Math.random() * (2 * param6) - param6),Math.random() * param5 + (Math.random() * (2 * param7) - param7));
            _loc10_.health = this.particleHealth;
            if(this.particleRestitution > 0)
            {
               _loc10_.restitution = Math.random() * this.particleRestitution;
            }
            else
            {
               _loc10_.restitution = -1;
            }
            _loc10_.friction = (0.975 + 0.05 * Math.random()) * this.particleFriction;
            _loc10_.collide = this.particleCollide;
            _loc10_.colour = this.pixelColour;
            _loc10_.wander = this.particleWander;
            if(this.particleWander > 0)
            {
               _loc10_.wanderX = 0.1;
               _loc10_.wanderY = 0.1;
            }
            if(this.particleFade != 0 || this.particleFadeRandom != 0)
            {
               _loc10_.fade = this.particleFade + Math.random() * this.particleFadeRandom;
            }
            this.holder.push(_loc10_);
            _loc8_.push(_loc10_);
            if(this.holder.length > Vars.particlesMax)
            {
               this.holder.shift();
            }
            _loc9_++;
         }
         return _loc8_;
      }
      
      public function update(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc6_:MyLittleParticle = null;
         if(this.particles == 0)
         {
            return;
         }
         if(param3 == 0)
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
               _loc6_.update(_loc4_,param2 * 0.01,param3);
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

