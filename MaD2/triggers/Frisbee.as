package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Frisbee extends Trigger
   {
      
      public function Frisbee()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = triggerPos;
         var _loc4_:b2Vec2 = param1.GetPosition();
         var _loc5_:Number = _loc3_.x - _loc4_.x;
         var _loc6_:Number = _loc3_.y - _loc4_.y;
         var _loc7_:b2Vec2 = param1.GetLinearVelocity();
         var _loc8_:Number = Math.abs(_loc7_.x);
         param1.ApplyForce(new b2Vec2(0,-_loc8_ * param2.triggerForce * 0.003),param1.GetWorldCenter());
         if(_loc8_ > 10)
         {
            param1.ApplyTorque(-bodyAngle % 360 * Vars.toRadians * 10000);
         }
      }
   }
}

