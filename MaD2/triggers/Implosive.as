package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class Implosive extends Trigger
   {
      
      public function Implosive()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:String = null;
         var _loc6_:b2Vec2 = null;
         super.trigger(param1,param2);
         Body.Destroy(param1,"implosion");
         var _loc3_:Number = param2.triggerRadius * param2.size;
         World.explode("implosion",pixelCenter,-10000 * param2.size,_loc3_,false,0);
         var _loc4_:int = 0;
         while(_loc4_ < 100 * param2.size)
         {
            _loc5_ = "shock2";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc5_ = param2.pfx.getParticle();
            }
            _loc6_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,_loc3_ * 0.5 - Math.random() * Math.random() * Math.random() * _loc3_ * 0.5,Math.random() * 360);
            GameState.particles.addParticles(_loc6_.x,_loc6_.y,1,_loc5_,(-_loc6_.x + pixelCenter.x) * 0.25 * param2.size,(-_loc6_.y + pixelCenter.y) * 0.25 * param2.size,1 * param2.size,1 * param2.size);
            _loc4_++;
         }
         sounds.random(["explosion2","explosion4"],param1,pixelCenter);
      }
   }
}

