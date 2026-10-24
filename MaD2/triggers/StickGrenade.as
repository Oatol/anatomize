package triggers
{
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class StickGrenade extends Trigger
   {
      
      public function StickGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:String = null;
         super.trigger(param1,param2);
         Body.Destroy(param1,"explosion");
         World.explode("grenade",pixelCenter,triggerForce * param2.size,param2.triggerRadius * param2.size,false);
         var _loc3_:int = 0;
         while(_loc3_ < 100 * param2.size)
         {
            _loc4_ = "explosive";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc4_ = param2.pfx.getParticle();
            }
            GameState.particles.addParticles(pixelCenter.x + (Math.random() * 20 - 10) * param2.size,pixelCenter.y + (Math.random() * 20 - 10) * param2.size,1,_loc4_,bodyVel.x * 0.01,bodyVel.y * 0.01,100 * param2.size,100 * param2.size);
            _loc3_++;
         }
         sounds.random(["explosion","explosion2","explosion4"],param1,pixelCenter);
      }
   }
}

