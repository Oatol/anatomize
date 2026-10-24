package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PointAtLinked extends Trigger
   {
      
      public function PointAtLinked()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(!param2.connected || param2.connected.length == 0 || param2.connected[0] == null)
         {
            param2.triggered = false;
            return;
         }
         param1.WakeUp();
         this.rotateToTarget(param2.connected[0]);
      }
      
      private function rotateToTarget(param1:b2Body) : Number
      {
         var _loc2_:b2Vec2 = param1.GetPosition();
         var _loc3_:b2Vec2 = body.GetPosition();
         var _loc4_:Number = _loc2_.x - _loc3_.x;
         var _loc5_:Number = _loc2_.y - _loc3_.y;
         var _loc6_:Number = Math.atan2(_loc5_,_loc4_) + Math.PI * 0.5;
         var _loc7_:Number = bodyAngle + body.GetAngularVelocity() / (1 / Tweak.m_timeStep);
         var _loc8_:Number = _loc6_ - _loc7_;
         while(_loc8_ < -180 * Vars.toRadians)
         {
            _loc8_ += 360 * Vars.toRadians;
         }
         while(_loc8_ > 180 * Vars.toRadians)
         {
            _loc8_ -= 360 * Vars.toRadians;
         }
         var _loc9_:Number = _loc8_ * 60;
         var _loc10_:Number = body.GetInertia() * _loc9_ / Tweak.m_timeStep;
         body.ApplyTorque(_loc10_);
         return _loc10_;
      }
   }
}

