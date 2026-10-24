package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class WindStaff extends Trigger
   {
      
      public function WindStaff()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc8_:b2Body = null;
         var _loc9_:String = null;
         var _loc14_:b2Vec2 = null;
         var _loc15_:b2Vec2 = null;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
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
            if(_loc8_ != param1)
            {
               if(triggerState != -1)
               {
                  _loc15_ = new b2Vec2(-_loc8_.GetWorldCenter().x * Physics.scale + _loc6_.x,-_loc8_.GetWorldCenter().y * Physics.scale + _loc6_.y);
                  _loc16_ = _loc15_.Normalize();
                  _loc17_ = (_loc5_ - _loc16_) / _loc5_ * -2000 * param2.size;
                  if(_loc17_ > 0)
                  {
                     _loc17_ *= -1;
                  }
               }
               else
               {
                  _loc15_ = new b2Vec2(_loc8_.GetWorldCenter().x * Physics.scale - pixelCenter.x,_loc8_.GetWorldCenter().y * Physics.scale - pixelCenter.y);
                  _loc16_ = _loc15_.Normalize();
                  _loc17_ = (_loc5_ - _loc16_) / _loc5_ * -10000 * param2.size;
               }
               _loc14_ = new b2Vec2(_loc15_.x * _loc17_,_loc15_.y * _loc17_);
               _loc8_.ApplyForce(_loc14_,_loc8_.GetWorldCenter());
            }
         }
         _loc9_ = "air";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc9_ = param2.pfx.getParticle();
         }
         var _loc10_:b2Vec2 = GeneralUtils.pointOnCircle(_loc6_.x,_loc6_.y,_loc5_,triggerDuration);
         var _loc11_:b2Vec2 = GeneralUtils.pointOnCircle(_loc6_.x,_loc6_.y,_loc5_,triggerDuration + 90);
         var _loc12_:b2Vec2 = GeneralUtils.pointOnCircle(_loc6_.x,_loc6_.y,_loc5_,triggerDuration + 180);
         var _loc13_:b2Vec2 = GeneralUtils.pointOnCircle(_loc6_.x,_loc6_.y,_loc5_,triggerDuration + 270);
         GameState.particles.addParticles(_loc10_.x,_loc10_.y,1,_loc9_,(-_loc6_.x + _loc10_.x) * 0.01,(-_loc6_.y + _loc10_.y) * 0.01,1,1);
         GameState.particles.addParticles(_loc11_.x,_loc11_.y,1,_loc9_,(-_loc6_.x + _loc11_.x) * 0.01,(-_loc6_.y + _loc11_.y) * 0.01,1,1);
         GameState.particles.addParticles(_loc12_.x,_loc12_.y,1,_loc9_,(-_loc6_.x + _loc12_.x) * 0.01,(-_loc6_.y + _loc12_.y) * 0.01,1,1);
         GameState.particles.addParticles(_loc13_.x,_loc13_.y,1,_loc9_,(-_loc6_.x + _loc13_.x) * 0.01,(-_loc6_.y + _loc13_.y) * 0.01,1,1);
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

