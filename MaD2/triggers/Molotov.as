package triggers
{
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class Molotov extends Trigger
   {
      
      public function Molotov()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Array = null;
         var _loc4_:b2Body = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         super.trigger(param1,param2);
         if(param2.burning)
         {
            _loc3_ = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
            for each(_loc4_ in _loc3_)
            {
               userData(_loc4_.GetUserData()).temperature = userData(_loc4_.GetUserData()).temperature + 15000 / BoxUtils.vectorDist(bodyCenter,_loc4_.GetPosition());
            }
            _loc5_ = 0;
            while(_loc5_ < 100 * param2.size)
            {
               _loc6_ = "fire2";
               _loc7_ = "fire3";
               if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
               {
                  _loc6_ = param2.pfx.getParticle();
                  _loc7_ = param2.pfx.getParticle();
               }
               GameState.particles.addParticles(pixelCenter.x + (Math.random() * 200 - 100) * param2.size,pixelCenter.y + (Math.random() * 200 - 100) * param2.size,1,_loc6_,bodyVel.x * 0.1,bodyVel.y * 0.1,20 * param2.size,20 * param2.size);
               GameState.particles.addParticles(pixelCenter.x + (Math.random() * 200 - 100) * param2.size,pixelCenter.y + (Math.random() * 200 - 100) * param2.size,1,_loc7_,bodyVel.x * 0.1,bodyVel.y * 0.1,20 * param2.size,20 * param2.size);
               _loc5_++;
            }
            sounds.play("incendiary",param1,pixelCenter);
         }
         param2.triggered = false;
         param2.burning = false;
         param2.temperature = 42;
         param2.ignition = 9000;
         Body.brittle(param1);
      }
   }
}

