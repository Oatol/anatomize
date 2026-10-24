package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class TechnoShield extends Flicker
   {
      
      public function TechnoShield()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc8_:b2Body = null;
         var _loc9_:b2Vec2 = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:b2Vec2 = null;
         super.trigger(param1,param2);
         _loc3_ = param2.triggerPos.Copy();
         if(param2.flipped)
         {
            _loc3_.x *= -1;
         }
         _loc3_.x *= param2.triggerRadius / 30;
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc5_:Number = param2.triggerRadius * param2.size;
         var _loc6_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y);
         var _loc7_:Array = Body.GetAroundPoint(_loc6_,_loc5_,_loc5_,false);
         for each(_loc8_ in _loc7_)
         {
            if(_loc8_ != param1)
            {
               _loc9_ = new b2Vec2(-_loc8_.GetWorldCenter().x * Physics.scale + pixelCenter.x,-_loc8_.GetWorldCenter().y * Physics.scale + pixelCenter.y);
               _loc10_ = _loc9_.Normalize();
               _loc11_ = (_loc5_ - _loc10_) / _loc5_ * triggerForce * param2.size;
               _loc12_ = new b2Vec2(_loc9_.x * _loc11_,_loc9_.y * _loc11_);
               _loc8_.GetLinearVelocity().Multiply(0.6);
               _loc8_.ApplyForce(_loc12_,_loc8_.GetWorldCenter());
               _loc8_.SetAngularVelocity(_loc8_.GetAngularVelocity() * 0.99);
            }
         }
      }
   }
}

