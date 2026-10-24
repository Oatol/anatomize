package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class HealStaff extends Trigger
   {
      
      public function HealStaff()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc8_:b2Body = null;
         var _loc9_:userData = null;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:int = 0;
         var _loc17_:String = null;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:b2Vec2 = null;
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
            _loc9_ = userData(_loc8_.GetUserData());
            if(_loc9_.alive)
            {
               if(_loc9_.health < _loc9_.maxhealth)
               {
                  if(triggerState == -1 || Math.random() > 0.9)
                  {
                     _loc9_.bleeding = [];
                  }
                  _loc10_ = 0.5 * param2.size;
                  if(triggerState == -1)
                  {
                     _loc10_ = 50 * param2.size;
                  }
                  _loc9_.health += _loc10_;
                  _loc11_ = 1;
                  if(triggerState == -1)
                  {
                     _loc11_ = 10;
                  }
                  _loc12_ = Math.random() * _loc9_.width - _loc9_.width * 0.5;
                  _loc13_ = Math.random() * _loc9_.height - _loc9_.height * 0.5;
                  _loc14_ = _loc8_.GetLinearVelocity().x * 0.1;
                  _loc15_ = _loc8_.GetLinearVelocity().y * 0.1;
                  _loc16_ = 0;
                  while(_loc16_ < _loc11_)
                  {
                     if(!(_loc11_ == 1 && Math.random() > 0.1))
                     {
                        _loc17_ = "heal";
                        if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
                        {
                           _loc17_ = param2.pfx.getParticle();
                        }
                        _loc18_ = _loc8_.GetPosition().x * Physics.scale + _loc12_ * Math.cos(_loc8_.GetAngle()) - _loc13_ * Math.sin(_loc8_.GetAngle());
                        _loc19_ = _loc8_.GetPosition().y * Physics.scale + _loc12_ * Math.sin(_loc8_.GetAngle()) + _loc13_ * Math.cos(_loc8_.GetAngle());
                        GameState.particles.addParticles(_loc18_,_loc19_,1,_loc17_,_loc14_,_loc15_);
                     }
                     _loc16_++;
                  }
               }
            }
         }
         if(Math.random() > 0.5)
         {
            _loc17_ = "heal";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc17_ = param2.pfx.getParticle();
            }
            _loc20_ = GeneralUtils.pointOnCircle(_loc6_.x,_loc6_.y,_loc5_,Math.random() * 360);
            GameState.particles.addParticles(_loc20_.x,_loc20_.y,1,_loc17_,(_loc6_.x - _loc20_.x) * 0.01 + bodyVel.x * 0.1,(_loc6_.y - _loc20_.y) * 0.01 + bodyVel.y * 0.1,0,0);
         }
         if(triggerState == -1)
         {
            param2.triggerState = 0;
         }
      }
   }
}

