package triggers
{
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class ConcussionGrenade extends Trigger
   {
      
      public function ConcussionGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc8_:b2Body = null;
         super.trigger(param1,param2);
         var _loc3_:String = "poof";
         var _loc4_:String = "light";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc3_ = param2.pfx.getParticle();
            _loc4_ = param2.pfx.getParticle();
         }
         var _loc5_:int = 0;
         while(_loc5_ < 8)
         {
            GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,4,_loc3_,bodyVel.x * 0.2,bodyVel.y * 0.2,50 * param2.size,50 * param2.size);
            GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,2,_loc4_,bodyVel.x * 0.2,bodyVel.y * 0.2,50 * param2.size,50 * param2.size);
            _loc5_++;
         }
         sounds.play("explosion5",param1,pixelCenter);
         var _loc6_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
         var _loc7_:int = _loc6_.indexOf(param1);
         if(_loc7_ != -1)
         {
            _loc6_.splice(_loc7_,1);
         }
         Shadows.lightPos = pixelCenter;
         Shadows.lightRadius = triggerRadius;
         Main.instance.drawShadowsFor(_loc6_,2);
         for each(_loc8_ in _loc6_)
         {
            if(userData(_loc8_.GetUserData()).alive)
            {
               userData(_loc8_.GetUserData()).trigger = new Concussion(1800,userData(_loc8_.GetUserData()).name == "doll_head");
               userData(_loc8_.GetUserData()).triggered = true;
            }
         }
         param2.dead = true;
         Body.Disintegrate(param1,_loc3_,100,10,10);
      }
   }
}

