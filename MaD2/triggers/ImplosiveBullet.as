package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class ImplosiveBullet extends GenericBullet
   {
      
      public function ImplosiveBullet()
      {
         super("shock2");
         trail = true;
         trailParticle = "shock2";
      }
      
      override protected function safeExplode() : void
      {
         var _loc3_:String = null;
         var _loc4_:b2Vec2 = null;
         super.safeExplode();
         Body.Destroy(body,"implosion");
         var _loc1_:Number = ud.triggerRadius * ud.size;
         World.explode("implosion",pixelCenter,-100 * ud.triggerForce * ud.size,_loc1_,false,0);
         var _loc2_:int = 0;
         while(_loc2_ < 50)
         {
            _loc3_ = "shock2";
            if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
            {
               _loc3_ = ud.pfx.getParticle();
            }
            _loc4_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,_loc1_ * 0.5 - Math.random() * Math.random() * Math.random() * _loc1_ * 0.5,Math.random() * 360);
            GameState.particles.addParticles(_loc4_.x,_loc4_.y,1,_loc3_,(-_loc4_.x + pixelCenter.x) * 0.25 * ud.size,(-_loc4_.y + pixelCenter.y) * 0.25 * ud.size,1 * ud.size,1 * ud.size);
            _loc2_++;
         }
         sounds.random(["explosion2","explosion4"],null,pixelCenter,0.4);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         needsExploding = true;
         return true;
      }
   }
}

