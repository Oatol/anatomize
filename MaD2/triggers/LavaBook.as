package triggers
{
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class LavaBook extends Trigger
   {
      
      public function LavaBook()
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
         if(param2.triggerDuration > 0)
         {
            param2.triggerDuration -= TimeLord.speed;
            return;
         }
         param2.triggerDuration = 30;
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_ != param1)
            {
               _loc6_ = userData(_loc4_.GetUserData());
               Body.Lava(_loc4_);
            }
         }
         _loc5_ = 0;
         while(_loc5_ < 50 * param2.size)
         {
            _loc7_ = "fire3";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc7_ = param2.pfx.getParticle();
            }
            GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,_loc7_,bodyVel.x * 0.2,bodyVel.y * 0.2,10,10);
            GameState.particles.addParticles(pixelCenter.x + (Math.random() * 100 - 50) * param2.size,pixelCenter.y + (Math.random() * 100 - 50) * param2.size,1,_loc7_,bodyVel.x * 0.2,bodyVel.y * 0.2,10 * param2.size,10 * param2.size);
            _loc5_++;
         }
         param2.triggered = false;
         sounds.play("flamer_shoot",param1,pixelCenter);
         if(Math.random() > 0.5)
         {
            param2.trigger = new SnareBook();
         }
         else
         {
            param2.trigger = new SandstoneBook();
         }
      }
   }
}

