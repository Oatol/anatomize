package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class AimAtLinkedAttachment extends AutoJoint
   {
      
      public function AimAtLinkedAttachment()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(!param2.connected || param2.connected.length == 0 || !attachedBody)
         {
            return;
         }
         this.rotateToTarget(attachedBody,param2.connected[0]);
      }
      
      private function rotateToTarget(param1:b2Body, param2:b2Body) : Number
      {
         var _loc3_:b2Vec2 = param2.GetPosition();
         var _loc4_:b2Vec2 = param1.GetPosition();
         var _loc5_:Number = _loc3_.x - _loc4_.x;
         var _loc6_:Number = _loc3_.y - _loc4_.y;
         var _loc7_:Number = 0;
         if(!userData(param1.GetUserData()).flipped)
         {
            _loc7_ += 180;
         }
         var _loc8_:Number = Math.atan2(_loc6_,_loc5_) + _loc7_ * Vars.toRadians;
         var _loc9_:Number = param1.GetAngle() + param1.GetAngularVelocity() / (1 / Tweak.m_timeStep);
         var _loc10_:Number = _loc8_ - _loc9_;
         while(_loc10_ < -180 * Vars.toRadians)
         {
            _loc10_ += 360 * Vars.toRadians;
         }
         while(_loc10_ > 180 * Vars.toRadians)
         {
            _loc10_ -= 360 * Vars.toRadians;
         }
         var _loc11_:Number = _loc10_ * ud.triggerForce * 0.5;
         var _loc12_:Number = param1.GetInertia() * _loc11_ / Tweak.m_timeStep;
         param1.ApplyTorque(_loc12_);
         return _loc12_;
      }
   }
}

