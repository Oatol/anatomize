package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class CameraGimbal extends Trigger
   {
      
      internal var trigBod:b2Body;
      
      public function CameraGimbal()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:Number = NaN;
         var _loc6_:b2Vec2 = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Vec2 = null;
         var _loc9_:b2Vec2 = null;
         var _loc10_:b2Vec2 = null;
         super.trigger(param1,param2);
         var _loc3_:int = 0;
         for each(_loc4_ in param2.connected)
         {
            _loc4_.WakeUp();
            if(param2.ignored.indexOf(_loc4_) == -1)
            {
               param2.ignored.push(_loc4_);
               _loc4_.GetUserData().ignored.push(param1);
            }
            _loc5_ = _loc4_.GetAngle() - param1.GetAngle();
            _loc4_.SetAngularVelocity(_loc4_.GetAngularVelocity() * 0.8);
            _loc4_.ApplyTorque(-_loc5_ * _loc4_.GetMass() * param2.triggerForce);
            _loc6_ = param2.triggerPos.Copy();
            _loc6_.Multiply(param2.triggerRadius * 0.01);
            _loc7_ = BoxUtils.rotateVec(_loc6_,bodyAngle);
            _loc8_ = new b2Vec2(pixelCenter.x + _loc7_.x,pixelCenter.y + _loc7_.y);
            _loc9_ = new b2Vec2(-_loc4_.GetWorldCenter().x * Physics.scale + _loc8_.x,-_loc4_.GetWorldCenter().y * Physics.scale + _loc8_.y);
            _loc10_ = new b2Vec2(_loc9_.x * param2.triggerForce * _loc4_.GetMass(),_loc9_.y * param2.triggerForce * _loc4_.GetMass());
            _loc4_.GetLinearVelocity().Multiply(0.8);
            _loc4_.ApplyForce(_loc10_,_loc4_.GetWorldCenter());
            _loc3_++;
         }
      }
   }
}

