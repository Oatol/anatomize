package triggers
{
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class AutoGrenade extends Trigger
   {
      
      public function AutoGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         Body.Destroy(param1,"explosion");
         World.explode("grenade",pixelCenter,param2.triggerForce * param2.size,param2.triggerRadius * param2.size,false);
         var _loc3_:Array = ["explosive","explosive","explosive","fire2","fire2","fire3","poof","smoke"];
         var _loc4_:int = 0;
         while(_loc4_ < param2.triggerRadius * param2.size)
         {
            GameState.particles.addParticles(pixelCenter.x + (Math.random() * 20 - 10) * param2.size,pixelCenter.y + (Math.random() * 20 - 10) * param2.size,1,_loc3_[Math.random() * _loc3_.length >> 0],bodyVel.x * 0.01,bodyVel.y * 0.01,Math.random() * _loc4_ * 5 * param2.size,Math.random() * _loc4_ * 5 * param2.size);
            _loc4_++;
         }
         sounds.random(["explosion","explosion2","explosion4"],param1,pixelCenter);
      }
   }
}

