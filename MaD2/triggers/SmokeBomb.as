package triggers
{
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class SmokeBomb extends Trigger
   {
      
      public function SmokeBomb()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:Vector.<MyLittleParticle> = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size);
         for each(_loc4_ in _loc3_)
         {
            if(!userData(_loc4_.GetUserData()).invisible)
            {
               if(userData(_loc4_.GetUserData()).graphic)
               {
                  userData(_loc4_.GetUserData()).trigger = new Invis();
                  userData(_loc4_.GetUserData()).triggered = true;
                  userData(_loc4_.GetUserData()).triggerDuration = triggerDuration;
                  userData(_loc4_.GetUserData()).triggerLock = true;
               }
            }
         }
         _loc5_ = 0;
         while(_loc5_ < 100)
         {
            _loc6_ = Math.random() > 0.3 ? "light" : "bigSmoke";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc6_ = param2.pfx.getParticle();
            }
            _loc7_ = GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,_loc6_,bodyVel.x * 0.01,bodyVel.y * 0.01,Math.random() * 100,Math.random() * 100);
            if((Boolean(_loc7_)) && Boolean(_loc7_[0]))
            {
               _loc7_[0].friction = 0.5;
               _loc7_[0].fade = 1;
               _loc7_[0].health = 1000 * (triggerDuration / 150);
            }
            _loc5_++;
         }
         sounds.play("explosion5",param1,pixelCenter);
         Body.Destroy(param1,"functionality");
      }
   }
}

