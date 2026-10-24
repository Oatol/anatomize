package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class FireStaff extends Trigger
   {
      
      public function FireStaff()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc8_:b2Body = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc15_:userData = null;
         var _loc16_:Number = NaN;
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = param2.triggerPos.Copy();
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc5_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y);
         var _loc6_:Number = param2.triggerRadius * param2.size;
         if(triggerState == -1)
         {
            _loc6_ *= 0.25;
            param2.triggered = false;
         }
         var _loc7_:Array = Body.GetAroundPoint(_loc5_,_loc6_,_loc6_,false);
         for each(_loc8_ in _loc7_)
         {
            _loc15_ = userData(_loc8_.GetUserData());
            _loc16_ = Math.random() * 9 + 1;
            if(triggerState == -1)
            {
               _loc16_ += 3;
               _loc16_ = _loc16_ * 10;
            }
            _loc15_.temperature += _loc16_ * param2.size;
            if(_loc15_.temperature > 666)
            {
               _loc15_.temperature = 666;
            }
         }
         _loc9_ = "fire2";
         _loc10_ = "fire3";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc9_ = param2.pfx.getParticle();
            _loc10_ = param2.pfx.getParticle();
         }
         var _loc11_:b2Vec2 = GeneralUtils.pointOnCircle(_loc5_.x,_loc5_.y,_loc6_,triggerDuration);
         var _loc12_:b2Vec2 = GeneralUtils.pointOnCircle(_loc5_.x,_loc5_.y,_loc6_,-triggerDuration + 90);
         var _loc13_:b2Vec2 = GeneralUtils.pointOnCircle(_loc5_.x,_loc5_.y,_loc6_,triggerDuration + 180);
         var _loc14_:b2Vec2 = GeneralUtils.pointOnCircle(_loc5_.x,_loc5_.y,_loc6_,-triggerDuration + 270);
         GameState.particles.addParticles(_loc11_.x,_loc11_.y,1,_loc9_,(_loc5_.x - _loc11_.x) * 0.01 + bodyVel.x * 0.1,(_loc5_.y - _loc11_.y) * 0.01 + bodyVel.y * 0.1,1,1);
         GameState.particles.addParticles(_loc12_.x,_loc12_.y,1,_loc10_,(_loc5_.x - _loc12_.x) * 0.01 + bodyVel.x * 0.1,(_loc5_.y - _loc12_.y) * 0.01 + bodyVel.y * 0.1,1,1);
         GameState.particles.addParticles(_loc13_.x,_loc13_.y,1,_loc9_,(_loc5_.x - _loc13_.x) * 0.01 + bodyVel.x * 0.1,(_loc5_.y - _loc13_.y) * 0.01 + bodyVel.y * 0.1,1,1);
         GameState.particles.addParticles(_loc14_.x,_loc14_.y,1,_loc10_,(_loc5_.x - _loc14_.x) * 0.01 + bodyVel.x * 0.1,(_loc5_.y - _loc14_.y) * 0.01 + bodyVel.y * 0.1,1,1);
         param2.triggerDuration += 6 * TimeLord.speed;
         if(param2.triggerDuration > 360)
         {
            param2.triggerDuration = 0;
         }
         if(triggerState == -1)
         {
            param2.triggerState = 0;
         }
      }
   }
}

