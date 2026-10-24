package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Bubbleshield extends Trigger
   {
      
      public function Bubbleshield()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc9_:b2Body = null;
         var _loc10_:b2Vec2 = null;
         var _loc11_:int = 0;
         var _loc12_:b2Vec2 = null;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:b2Vec2 = null;
         var _loc16_:b2Vec2 = null;
         var _loc17_:b2Vec2 = null;
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = param2.triggerPos.Copy();
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc5_:Number = param2.triggerRadius * param2.size;
         var _loc6_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y);
         var _loc7_:Array = Body.GetAroundPoint(_loc6_,_loc5_,_loc5_,false);
         var _loc8_:String = "forcefield";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc8_ = param2.pfx.getParticle();
         }
         for each(_loc9_ in _loc7_)
         {
            if(_loc9_ != param1)
            {
               if(!(param2.triggerState == 0 && param2.connected.indexOf(_loc9_) != -1))
               {
                  _loc12_ = new b2Vec2(-_loc9_.GetWorldCenter().x * Physics.scale + _loc6_.x,-_loc9_.GetWorldCenter().y * Physics.scale + _loc6_.y);
                  _loc13_ = _loc12_.Normalize();
                  _loc14_ = 10 * param2.triggerForce / ((_loc5_ - _loc13_) / _loc5_) * param2.size;
                  if(_loc14_ > 0)
                  {
                     _loc14_ *= -1;
                  }
                  if(param2.triggerState == 1 && param2.connected.indexOf(_loc9_) != -1)
                  {
                     _loc14_ *= -1;
                     _loc16_ = _loc9_.GetWorldCenter().Copy();
                     _loc16_.Multiply(Physics.scale);
                     GameState.particles.addParticles(_loc16_.x,_loc16_.y,1,_loc8_,(-_loc16_.x + pixelCenter.x) * 0.08,(-_loc16_.y + pixelCenter.y) * 0.08,1,1);
                  }
                  _loc15_ = new b2Vec2(_loc12_.x * _loc14_,_loc12_.y * _loc14_);
                  _loc9_.GetLinearVelocity().Multiply(0.9);
                  _loc9_.SetAngularVelocity(_loc9_.GetAngularVelocity() * 0.9);
                  _loc9_.ApplyForce(_loc15_,_loc9_.GetWorldCenter());
               }
            }
         }
         _loc10_ = GeneralUtils.pointOnCircle(_loc6_.x,_loc6_.y,Math.random() * _loc5_,Math.random() * 360);
         GameState.particles.addParticles(_loc10_.x,_loc10_.y,1,_loc8_,(-_loc6_.x + _loc10_.x) * 0.08,(-_loc6_.y + _loc10_.y) * 0.08,1,1);
         _loc11_ = 0;
         while(_loc11_ < 4)
         {
            _loc17_ = GeneralUtils.pointOnCircle(_loc6_.x,_loc6_.y,_loc5_,Math.random() * 360);
            GameState.particles.addParticles(_loc17_.x,_loc17_.y,1,_loc8_,(-_loc6_.x + _loc17_.x) * 0.01,(-_loc6_.y + _loc17_.y) * 0.01,1,1);
            _loc11_++;
         }
      }
   }
}

