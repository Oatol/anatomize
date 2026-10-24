package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class IceStaff extends Trigger
   {
      
      public function IceStaff()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc8_:b2Body = null;
         var _loc9_:String = null;
         var _loc13_:userData = null;
         var _loc14_:* = undefined;
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = param2.triggerPos.Copy();
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc5_:Number = param2.triggerRadius * param2.size;
         var _loc6_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y);
         if(triggerState == -1)
         {
            _loc5_ *= 0.25;
            param2.triggered = false;
         }
         var _loc7_:Array = Body.GetAroundPoint(_loc6_,_loc5_,_loc5_,false);
         for each(_loc8_ in _loc7_)
         {
            _loc13_ = userData(_loc8_.GetUserData());
            if(_loc13_.conductivity)
            {
               if(_loc13_.temperature > -50)
               {
                  _loc14_ = Math.random() * 3 + 1;
                  if(triggerState == -1)
                  {
                     _loc14_ += 2;
                     _loc14_ = _loc14_ * 5;
                  }
                  _loc13_.temperature -= _loc14_ * param2.size;
               }
               if(!_loc13_.brittle || _loc13_.temperature < 0 && _loc13_.temperature > -50)
               {
                  Body.Freeze(_loc8_);
               }
            }
         }
         _loc9_ = "gas";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc9_ = param2.pfx.getParticle();
         }
         var _loc10_:b2Vec2 = GeneralUtils.pointOnCircle(_loc6_.x,_loc6_.y,_loc5_,-triggerDuration);
         var _loc11_:b2Vec2 = GeneralUtils.pointOnCircle(_loc6_.x,_loc6_.y,_loc5_,-triggerDuration + 115);
         var _loc12_:b2Vec2 = GeneralUtils.pointOnCircle(_loc6_.x,_loc6_.y,_loc5_,-triggerDuration + 235);
         GameState.particles.addParticles(_loc10_.x,_loc10_.y,1,_loc9_,bodyVel.x * 0.1,bodyVel.y * 0.1,1,1);
         GameState.particles.addParticles(_loc11_.x,_loc11_.y,1,_loc9_,bodyVel.x * 0.1,bodyVel.y * 0.1,1,1);
         GameState.particles.addParticles(_loc12_.x,_loc12_.y,1,_loc9_,bodyVel.x * 0.1,bodyVel.y * 0.1,1,1);
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

