package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class BoomStaff extends Trigger
   {
      
      public function BoomStaff()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc9_:b2Vec2 = null;
         var _loc10_:int = 0;
         var _loc11_:Array = null;
         var _loc12_:b2Body = null;
         var _loc13_:b2Vec2 = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:b2Vec2 = null;
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
         var _loc7_:String = "fire3";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc7_ = param2.pfx.getParticle();
         }
         var _loc8_:b2Vec2 = GeneralUtils.pointOnCircle(_loc6_.x,_loc6_.y,_loc5_,Math.random() * 360);
         GameState.particles.addParticles(_loc8_.x,_loc8_.y,1,_loc7_,(_loc6_.x - _loc8_.x) * 0.01 + bodyVel.x * 0.1,(_loc6_.y - _loc8_.y) * 0.01 + bodyVel.y * 0.1,1,1);
         if(triggerState == -1 || (triggerDuration >> 0) % 90 == 0)
         {
            _loc9_ = GeneralUtils.pointOnCircle(_loc6_.x,_loc6_.y,Math.random() * _loc5_ * 0.7 + _loc5_ * 0.3,Math.random() * 360);
            _loc10_ = 0;
            while(_loc10_ < 10)
            {
               GameState.particles.addParticles(_loc9_.x,_loc9_.y,1,_loc7_,(-_loc6_.x + _loc9_.x) * 0.01 + bodyVel.x * 0.1 + Math.random() * 4 - 2,(-_loc6_.y + _loc9_.y) * 0.01 + bodyVel.y * 0.1 + Math.random() * 4 - 2,1,1);
               _loc10_++;
            }
            _loc11_ = Body.GetAroundPoint(_loc6_,_loc5_,_loc5_,false);
            for each(_loc12_ in _loc11_)
            {
               if(_loc12_ != param1)
               {
                  _loc13_ = new b2Vec2(_loc12_.GetWorldCenter().x * Physics.scale - pixelCenter.x,_loc12_.GetWorldCenter().y * Physics.scale - pixelCenter.y);
                  _loc14_ = _loc13_.Normalize();
                  _loc15_ = (_loc5_ - _loc14_) / _loc5_ * 1000 * param2.size;
                  _loc16_ = new b2Vec2(_loc13_.x * _loc15_,_loc13_.y * _loc15_);
                  World.explode("boomstaff",_loc9_,_loc16_.Length(),_loc5_,false);
               }
            }
         }
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

