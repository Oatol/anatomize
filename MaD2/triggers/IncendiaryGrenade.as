package triggers
{
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class IncendiaryGrenade extends Trigger
   {
      
      public function IncendiaryGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
         for each(_loc4_ in _loc3_)
         {
            userData(_loc4_.GetUserData()).temperature = userData(_loc4_.GetUserData()).temperature + triggerForce * param2.size / BoxUtils.vectorDist(bodyCenter,_loc4_.GetPosition());
         }
         param2.dead = true;
         Body.Disintegrate(param1,"poof");
         World.explode("incendiary",pixelCenter,50 * param2.size,param2.triggerRadius * param2.size);
         _loc5_ = 0;
         while(_loc5_ < 50 * param2.size)
         {
            _loc6_ = "fire2";
            _loc7_ = "fire3";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc6_ = param2.pfx.getParticle();
               _loc7_ = param2.pfx.getParticle();
            }
            GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,_loc6_,bodyVel.x * 0.1,bodyVel.y * 0.1,10 * param2.size,10 * param2.size);
            GameState.particles.addParticles(pixelCenter.x + Math.random() * 100 - 50,pixelCenter.y + Math.random() * 100 - 50,1,_loc7_,bodyVel.x * 0.1,bodyVel.y * 0.1,10 * param2.size,10 * param2.size);
            _loc5_++;
         }
         sounds.play("incendiary",param1,pixelCenter);
      }
   }
}

