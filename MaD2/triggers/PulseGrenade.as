package triggers
{
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class PulseGrenade extends Trigger
   {
      
      public function PulseGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:int = 0;
         var _loc6_:userData = null;
         var _loc7_:String = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
         for each(_loc4_ in _loc3_)
         {
            _loc6_ = userData(_loc4_.GetUserData());
            _loc6_.trigger = new Electrified();
            _loc6_.triggered = true;
            _loc6_.triggerDuration = 300;
         }
         param2.dead = true;
         Body.Disintegrate(param1,"shock");
         _loc5_ = 0;
         while(_loc5_ < 50)
         {
            _loc7_ = "shock";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc7_ = param2.pfx.getParticle();
            }
            GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,_loc7_,bodyVel.x * 0.1,bodyVel.y * 0.1,10 * param2.size,10 * param2.size);
            GameState.particles.addParticles(pixelCenter.x + (Math.random() * 100 - 50) * param2.size,pixelCenter.y + (Math.random() * 100 - 50) * param2.size,1,_loc7_,bodyVel.x * 0.1,bodyVel.y * 0.1,10 * param2.size,10 * param2.size);
            _loc5_++;
         }
         sounds.play("carbine_shoot",param1,pixelCenter);
      }
   }
}

