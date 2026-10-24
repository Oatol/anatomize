package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class ExplodeAfterDuration extends Trigger
   {
      
      internal var customs:Object;
      
      internal var particles:Array = ["fire3"];
      
      internal var eparticles:Array = ["fire3"];
      
      internal var sfx:Array = ["explosion","explosion2","explosion4"];
      
      internal var vols:Array = [1,1,1];
      
      public function ExplodeAfterDuration()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         super.trigger(param1,param2);
         if(!this.customs)
         {
            this.customs = param2.ParseTriggerCustom();
            if(this.customs["particles"])
            {
               this.particles = this.customs["particles"].split(",");
            }
            if(this.customs["particlesExplode"])
            {
               this.eparticles = this.customs["particlesExplode"].split(",");
            }
            if(this.customs["sounds"])
            {
               this.sfx = this.customs["sounds"].split(",");
            }
            if(this.customs["volumes"])
            {
               this.vols = GeneralUtils.toNumberArray(this.customs["volumes"]);
            }
         }
         param2.triggerDuration -= TimeLord.speed;
         var _loc3_:b2Vec2 = param2.triggerPos.Copy();
         _loc3_.Multiply(param2.size);
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         _loc4_.Add(pixelCenter);
         _loc5_ = this.particles[Math.random() * this.particles.length >> 0];
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc5_ = param2.pfx.getParticle();
         }
         BoxUtils.randomParticlesOnBody(param1,_loc5_);
         if(triggerDuration <= 1)
         {
            Body.Destroy(param1,"explosion");
            World.explode("grenade",pixelCenter,triggerForce,param2.triggerRadius,false);
            _loc6_ = 20;
            if(this.customs["particlesCount"])
            {
               _loc6_ = int(this.customs["particlesCount"]);
            }
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc5_ = this.eparticles[Math.random() * this.eparticles.length >> 0];
               _loc8_ = this.eparticles[Math.random() * this.eparticles.length >> 0];
               if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
               {
                  _loc5_ = param2.pfx.getParticle();
                  _loc8_ = param2.pfx.getParticle();
               }
               GameState.particles.addParticles(pixelCenter.x + (Math.random() * 20 - 10),pixelCenter.y + (Math.random() * 20 - 10),1,_loc5_,bodyVel.x * 0.01,bodyVel.y * 0.01,Math.random() * 100,Math.random() * 100);
               GameState.particles.addParticles(pixelCenter.x + (Math.random() * 20 - 10),pixelCenter.y + (Math.random() * 20 - 10),1,_loc8_,bodyVel.x * 0.01,bodyVel.y * 0.01,Math.random() * 100,Math.random() * 100);
               _loc7_++;
            }
            sounds.random(this.sfx,param1,pixelCenter,Math.random() * 0.4 + 0.4);
            param2.dead = true;
         }
      }
   }
}

