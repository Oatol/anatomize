package triggers
{
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class CampfireGrenade extends Transmute
   {
      
      public function CampfireGrenade()
      {
         super("campfire");
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:String = null;
         var _loc5_:Vector.<MyLittleParticle> = null;
         updateTriggerHelpers();
         if(param2.resistTransmuting)
         {
            param2.trigger.reset();
            return;
         }
         World.explode("cluster",pixelCenter,20 * param2.size,100 * param2.size,true,0);
         sounds.play("explosion5",param1,pixelCenter);
         var _loc3_:int = 0;
         while(_loc3_ < 8)
         {
            _loc4_ = "bigSmoke";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc4_ = param2.pfx.getParticle();
            }
            _loc5_ = GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,_loc4_,bodyVel.x * 0.01,bodyVel.y * 0.01,Math.random() * 100,Math.random() * 100);
            if((Boolean(_loc5_)) && _loc5_.length > 0)
            {
               _loc5_[0].friction = 0.6;
               _loc5_[0].fade = 0.1;
               _loc5_[0].health = 1000;
            }
            _loc3_++;
         }
         super.trigger(param1,param2);
      }
   }
}

