package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class Deepfryer extends Toaster
   {
      
      public function Deepfryer()
      {
         super();
         aoe = 24;
         particle = "p_fried";
         toastCol = 9463851;
         burnCol = 9463851;
      }
      
      override protected function Particles() : void
      {
         var _loc1_:b2Vec2 = null;
         var _loc2_:b2Vec2 = null;
         var _loc3_:b2Vec2 = null;
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         if(Math.random() > 0.95)
         {
            _loc1_ = new b2Vec2(-15 * ud.size + Math.random() * 30 * ud.size,-45 * ud.size);
            _loc2_ = BoxUtils.rotateVec(_loc1_,bodyAngle);
            _loc3_ = new b2Vec2(pixelCenter.x + _loc2_.x,pixelCenter.y + _loc2_.y);
            _loc4_ = "fire3";
            if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
            {
               _loc4_ = ud.pfx.getParticle();
            }
            _loc5_ = bodyAngle + Vars.PI * 0.5;
            GameState.particles.addParticles(_loc3_.x,_loc3_.y,1,_loc4_,-2 * Math.cos(_loc5_),-2 * Math.sin(_loc5_),Math.cos(_loc5_),Math.sin(_loc5_));
         }
      }
      
      override protected function Toast(param1:b2Body) : void
      {
         super.Toast(param1);
         if(Math.random() > 0.95)
         {
            sounds.play("tinyhiss",body,pixelCenter);
         }
      }
   }
}

