package triggers
{
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class Flashbang extends Trigger
   {
      
      public function Flashbang()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:Array = null;
         var _loc6_:int = 0;
         super.trigger(param1,param2);
         var _loc3_:String = "explosive";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc3_ = param2.pfx.getParticle();
         }
         if(triggerDuration == 60)
         {
            _loc6_ = 0;
            while(_loc6_ < 40)
            {
               GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,_loc3_,bodyVel.x * 0.2,bodyVel.y * 0.2,150 * param2.size,150 * param2.size);
               _loc6_++;
            }
            sounds.play("explosion5",param1,pixelCenter);
         }
         GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,_loc3_,bodyVel.x * 0.2,bodyVel.y * 0.2,50 * param2.size,50 * param2.size);
         _loc4_ = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
         var _loc5_:int = _loc4_.indexOf(param1);
         if(_loc5_ != -1)
         {
            _loc4_.splice(_loc5_,1);
         }
         Shadows.lightPos = pixelCenter;
         Shadows.lightRadius = triggerRadius;
         Main.instance.drawShadowsFor(_loc4_,2);
         param2.triggerDuration -= TimeLord.speed;
         if(triggerDuration <= 0)
         {
            param2.dead = true;
            Body.Disintegrate(param1,"poof");
         }
      }
   }
}

