package powers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class Power
   {
      
      public var AffectsBody:Boolean = true;
      
      public var AffectsOther:Boolean = false;
      
      protected var throwBody:b2Body;
      
      protected var throwBullet:String;
      
      protected var throwPos:b2Vec2;
      
      protected var throwScatter:Number;
      
      protected var throwDir:b2Vec2;
      
      protected var throwProjectiles:Number;
      
      protected var throwRadius:Number;
      
      protected var throwSound:String;
      
      protected var pressSound:String;
      
      protected var bodySound:String;
      
      protected var throwVol:Number = 0.5;
      
      protected var pressVol:Number = 0.5;
      
      protected var bodyVol:Number = 0.5;
      
      protected var particleRadius:Number;
      
      protected var particleAngle:int;
      
      protected var particlePos:b2Vec2;
      
      protected var pressPos:b2Vec2;
      
      protected var bodies:Array;
      
      protected var bodyUD:userData;
      
      protected var bodyPos:b2Vec2;
      
      public var name:String;
      
      public var particle:String;
      
      public var noThrowRadius:Boolean = false;
      
      public var noThrowAmount:Boolean = false;
      
      public var noThrowSpeed:Boolean = false;
      
      public var noThrowSpread:Boolean = false;
      
      public var noDuration:Boolean = true;
      
      public var noEffectRadius:Boolean = true;
      
      public var noEffectForce:Boolean = true;
      
      public var noPressRadius:Boolean = false;
      
      public var noThrow:Boolean = false;
      
      public function Power(param1:String, param2:String = null, param3:String = null)
      {
         super();
         this.name = param1;
         this.particle = param2;
         this.throwBullet = param3;
      }
      
      protected function ThrowUpdate(param1:b2Vec2) : void
      {
         this.throwScatter = Tweak.toolSpread;
         this.throwDir = new b2Vec2(param1.x * Tweak.toolSpeed,param1.y * Tweak.toolSpeed);
         this.throwProjectiles = Tweak.toolProjectiles;
         this.throwRadius = Tweak.toolThrowRadius;
         this.throwPos = new b2Vec2();
         this.ThrowPosRandom();
      }
      
      protected function ThrowPosRandom() : void
      {
         this.throwPos.x = Math.random() * this.throwRadius * 2 - this.throwRadius;
         this.throwPos.y = Math.random() * this.throwRadius * 2 - this.throwRadius;
         this.throwPos.x /= Physics.scale;
         this.throwPos.y /= Physics.scale;
      }
      
      public function Press(param1:b2Vec2, param2:b2Vec2) : void
      {
         var _loc3_:b2Body = null;
         this.bodies = Body.GetAroundPoint(new b2Vec2(param1.x,param1.y),Tweak.toolRadius,Tweak.toolRadius,false);
         this.pressPos = param1;
         for each(_loc3_ in this.bodies)
         {
            this.OnBodyPress(_loc3_);
         }
         if(this.pressSound)
         {
            sounds.play(this.pressSound,null,param1,this.pressVol);
         }
      }
      
      public function Release() : void
      {
      }
      
      protected function OnBodyPress(param1:b2Body) : void
      {
         param1.WakeUp();
         this.bodyUD = userData(param1.GetUserData());
         this.bodyPos = param1.GetWorldCenter().Copy();
         if(this.bodySound)
         {
            sounds.play(this.bodySound,null,new b2Vec2(this.bodyPos.x * Physics.scale,this.bodyPos.y * Physics.scale),this.bodyVol,false);
         }
      }
      
      protected function OnProjectileThrow(param1:b2Vec2, param2:b2Vec2) : void
      {
         this.ThrowPosRandom();
         var _loc3_:b2Body = Physics.world.GetGroundBody();
         var _loc4_:Number = Math.atan2(this.throwDir.y,this.throwDir.x);
         this.throwBody = GameState.objects.addbullet(this.throwBullet,param1.x + this.throwPos.x,param1.y + this.throwPos.y,_loc4_,1,1,this.throwDir,this.throwScatter,_loc3_);
         if(this.throwBody)
         {
            userData(this.throwBody.GetUserData()).projectileName = this.throwBullet;
         }
      }
      
      public function Throw(param1:b2Vec2, param2:b2Vec2) : void
      {
         var _loc4_:String = null;
         if(!this.throwBullet)
         {
            return;
         }
         this.ThrowUpdate(param2);
         var _loc3_:int = 0;
         while(_loc3_ < this.throwProjectiles)
         {
            this.OnProjectileThrow(param1,param2);
            _loc3_++;
         }
         if(this.throwSound)
         {
            if(this.throwSound != "")
            {
               sounds.play(this.throwSound,null,param1,this.throwVol);
            }
         }
         else
         {
            _loc4_ = String(1 + int(Math.random() * 5));
            sounds.play("throw" + _loc4_,null,param1,this.throwVol);
         }
      }
      
      public function Particles(param1:b2Vec2, param2:b2Vec2) : void
      {
         if(!this.particle)
         {
            return;
         }
         this.particleAngle = Math.random() * 360 >> 0;
         this.particleRadius = Tweak.toolRadius;
         this.AddParticles(param1,param2);
      }
      
      protected function AddParticles(param1:b2Vec2, param2:b2Vec2) : void
      {
         this.particlePos = GeneralUtils.pointOnCircle(param1.x,param1.y,this.particleRadius,this.particleAngle);
         GameState.particles.addParticles(this.particlePos.x,this.particlePos.y,1,this.particle,param2.x * 0.1,param2.y * 0.1);
      }
   }
}

