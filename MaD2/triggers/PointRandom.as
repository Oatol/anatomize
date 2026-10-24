package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PointRandom extends Trigger
   {
      
      internal var dangle:* = 180;
      
      public function PointRandom()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         param1.WakeUp();
         this.rotateToTarget();
      }
      
      override public function onTrigger() : void
      {
         super.onTrigger();
         this.dangle = Math.random() * 360;
      }
      
      private function rotateToTarget() : Number
      {
         var _loc1_:b2Vec2 = body.GetPosition();
         var _loc2_:b2Vec2 = GeneralUtils.pointOnCircle(_loc1_.x,_loc1_.y,10,this.dangle);
         var _loc3_:Number = _loc2_.x - _loc1_.x;
         var _loc4_:Number = _loc2_.y - _loc1_.y;
         var _loc5_:Number = Math.atan2(_loc4_,_loc3_) + Math.PI * 0.5;
         var _loc6_:Number = bodyAngle + body.GetAngularVelocity() / (1 / Tweak.m_timeStep);
         var _loc7_:Number = _loc5_ - _loc6_;
         while(_loc7_ < -180 * Vars.toRadians)
         {
            _loc7_ += 360 * Vars.toRadians;
         }
         while(_loc7_ > 180 * Vars.toRadians)
         {
            _loc7_ -= 360 * Vars.toRadians;
         }
         var _loc8_:Number = _loc7_ * 60;
         var _loc9_:Number = body.GetInertia() * _loc8_ / Tweak.m_timeStep;
         body.ApplyTorque(_loc9_);
         return _loc9_;
      }
   }
}

