package triggers
{
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class Implode extends Trigger
   {
      
      public function Implode()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         super.trigger(param1,param2);
         Body.Destroy(param1,"implosion");
         var _loc3_:Number = 200;
         if(param2.triggerRadius)
         {
            _loc3_ = param2.triggerRadius;
         }
         if(!triggerForce)
         {
            triggerForce = 1000;
         }
         World.explode("implosion",pixelCenter,-triggerForce * param2.size,_loc3_ * param2.size,false,0);
         var _loc4_:int = 0;
         while(_loc4_ < 100 * param2.size)
         {
            _loc5_ = pixelCenter.x + (Math.random() * 500 - 250);
            _loc6_ = pixelCenter.y + (Math.random() * 500 - 250);
            GameState.particles.addParticles(_loc5_,_loc6_,1,"explosive",(pixelCenter.x - _loc5_) / 5,(pixelCenter.y - _loc6_) / 5);
            _loc4_++;
         }
         sounds.random(["explosion","explosion2","explosion4"],null,pixelCenter);
      }
   }
}

