package triggers
{
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class Grenade extends Trigger
   {
      
      public function Grenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         super.trigger(param1,param2);
         if(triggerDuration < 0)
         {
            param2.triggered = false;
            return;
         }
         param2.triggerDuration -= TimeLord.speed;
         if((triggerDuration >> 0) % 29 == 0 && triggerDuration > 28)
         {
            sounds.play("ui_hover",param1,pixelCenter,2);
         }
         if(triggerDuration <= 1)
         {
            Body.Destroy(param1,"explosion");
            World.explode("grenade",pixelCenter,triggerForce * param2.size,param2.triggerRadius * param2.size,false);
            _loc3_ = 0;
            while(_loc3_ < 100 * param2.size)
            {
               _loc4_ = "explosive";
               _loc5_ = "fire2";
               if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
               {
                  _loc4_ = param2.pfx.getParticle();
                  _loc5_ = param2.pfx.getParticle();
               }
               GameState.particles.addParticles(pixelCenter.x + (Math.random() * 20 - 10) * param2.size,pixelCenter.y + (Math.random() * 20 - 10) * param2.size,1,_loc4_,bodyVel.x * 0.01,bodyVel.y * 0.01,Math.random() * triggerForce * 0.1 * param2.size,Math.random() * triggerForce * 0.1 * param2.size);
               GameState.particles.addParticles(pixelCenter.x + (Math.random() * 20 - 10) * param2.size,pixelCenter.y + (Math.random() * 20 - 10) * param2.size,1,_loc5_,bodyVel.x * 0.01,bodyVel.y * 0.01,Math.random() * triggerForce * 0.1 * param2.size,Math.random() * triggerForce * 0.1 * param2.size);
               _loc3_++;
            }
            sounds.random(["explosion","explosion2","explosion4"],param1,pixelCenter);
         }
         if(triggerDuration <= 0)
         {
            param2.dead = true;
         }
      }
   }
}

