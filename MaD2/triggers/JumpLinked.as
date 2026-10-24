package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class JumpLinked extends Trigger
   {
      
      public function JumpLinked()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Body = null;
         var _loc4_:userData = null;
         var _loc5_:b2Vec2 = null;
         super.trigger(param1,param2);
         param2.triggerDuration -= TimeLord.speed;
         if(param2.triggerDuration > 0)
         {
            return;
         }
         param2.triggerDuration = param2.originalTriggerDuration;
         for each(_loc3_ in param2.connected)
         {
            _loc3_.WakeUp();
            _loc4_ = userData(_loc3_.GetUserData());
            _loc5_ = new b2Vec2(param2.triggerForce * 0.1,Math.abs(param2.triggerForce) * -0.1);
            _loc5_.Multiply(param2.triggerForce * _loc3_.GetMass());
            _loc3_.ApplyImpulse(_loc5_,_loc3_.GetWorldCenter());
         }
      }
   }
}

