package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Repercutio extends Trigger
   {
      
      public function Repercutio()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         if(!ud.triggerForce)
         {
            ud.triggerForce = 100;
         }
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc15_:b2Body = null;
         var _loc16_:b2Vec2 = null;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:b2Vec2 = null;
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = param2.triggerPos.Copy();
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc5_:Number = param2.triggerRadius * param2.size;
         var _loc6_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y);
         var _loc7_:Array = Body.GetAroundPoint(_loc6_,_loc5_,_loc5_,false);
         var _loc8_:Number = 1;
         if(param2.triggerForce)
         {
            _loc8_ = param2.triggerForce * 0.01;
         }
         if(_loc8_ > 0)
         {
            for each(_loc15_ in _loc7_)
            {
               if(_loc15_ != param1)
               {
                  if(param2.connected.indexOf(_loc15_) == -1)
                  {
                     _loc16_ = new b2Vec2(-_loc15_.GetWorldCenter().x * Physics.scale + _loc6_.x,-_loc15_.GetWorldCenter().y * Physics.scale + _loc6_.y);
                     _loc17_ = _loc16_.Normalize();
                     _loc18_ = (_loc5_ - _loc17_) / _loc5_ * -1000 * param2.size;
                     if(_loc18_ > 0)
                     {
                        _loc18_ *= -1;
                     }
                     _loc19_ = new b2Vec2(_loc16_.x * _loc18_,_loc16_.y * _loc18_);
                     _loc19_.Multiply(_loc8_);
                     _loc15_.ApplyForce(_loc19_,_loc15_.GetWorldCenter());
                     _loc15_.GetLinearVelocity().Multiply(0.5);
                     _loc15_.SetAngularVelocity(_loc15_.GetAngularVelocity() * 0.99);
                  }
               }
            }
         }
         var _loc9_:b2Vec2 = GeneralUtils.pointOnCircle(_loc6_.x,_loc6_.y,_loc5_,triggerDuration);
         var _loc10_:b2Vec2 = GeneralUtils.pointOnCircle(_loc6_.x,_loc6_.y,_loc5_,triggerDuration + 90);
         var _loc11_:b2Vec2 = GeneralUtils.pointOnCircle(_loc6_.x,_loc6_.y,_loc5_,triggerDuration + 180);
         var _loc12_:b2Vec2 = GeneralUtils.pointOnCircle(_loc6_.x,_loc6_.y,_loc5_,triggerDuration + 270);
         var _loc13_:String = "forcefield";
         var _loc14_:String = "crystal";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc13_ = param2.pfx.getParticle();
            _loc14_ = param2.pfx.getParticle();
         }
         GameState.particles.addParticles(_loc9_.x,_loc9_.y,1,_loc13_,(-_loc6_.x + _loc9_.x) * 0.01,(-_loc6_.y + _loc9_.y) * 0.01,1,1);
         GameState.particles.addParticles(_loc10_.x,_loc10_.y,1,_loc14_,(-_loc6_.x + _loc10_.x) * 0.01,(-_loc6_.y + _loc10_.y) * 0.01,1,1);
         GameState.particles.addParticles(_loc11_.x,_loc11_.y,1,_loc13_,(-_loc6_.x + _loc11_.x) * 0.01,(-_loc6_.y + _loc11_.y) * 0.01,1,1);
         GameState.particles.addParticles(_loc12_.x,_loc12_.y,1,_loc14_,(-_loc6_.x + _loc12_.x) * 0.01,(-_loc6_.y + _loc12_.y) * 0.01,1,1);
         param2.triggerDuration += 6 * TimeLord.speed;
         if(param2.triggerDuration > 360)
         {
            param2.triggerDuration = 0;
         }
      }
   }
}

