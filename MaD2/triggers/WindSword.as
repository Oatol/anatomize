package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class WindSword extends Trigger
   {
      
      public function WindSword()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Vec2 = null;
         var _loc9_:b2Vec2 = null;
         super.trigger(param1,param2);
         if(triggerDuration > 0)
         {
            --param2.triggerDuration;
         }
         var _loc3_:b2Vec2 = new b2Vec2(0,-10 * param2.size);
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc5_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y);
         var _loc6_:String = "air";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc6_ = param2.pfx.getParticle();
         }
         if(bodyVel.Length() < 1)
         {
            _loc7_ = new b2Vec2(0,Math.random() * 90 - 30);
            _loc8_ = BoxUtils.rotateVec(_loc7_,bodyAngle);
            _loc9_ = new b2Vec2(Math.random() * triggerState * 0.1 - triggerState * 0.05,0);
            _loc9_ = BoxUtils.rotateVec(_loc9_.Copy(),bodyAngle);
            GameState.particles.addParticles(_loc5_.x - _loc8_.x * param2.size,_loc5_.y - _loc8_.y * param2.size,1,_loc6_,_loc9_.x,_loc9_.y,0,0);
            param2.triggerState += 1;
            if(param2.triggerState > 60)
            {
               param2.triggerState = -30;
            }
         }
         else
         {
            _loc7_ = new b2Vec2(Math.random() * 20 - 10,Math.random() * 90 - 30);
            _loc8_ = BoxUtils.rotateVec(_loc7_,bodyAngle);
            GameState.particles.addParticles(_loc5_.x - _loc8_.x * param2.size,_loc5_.y - _loc8_.y * param2.size,1,_loc6_,bodyVel.x * 0.1,bodyVel.y * 0.1,0,0);
         }
      }
   }
}

