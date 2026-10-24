package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class Rotator extends Trigger
   {
      
      public function Rotator()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Body = null;
         super.trigger(param1,param2);
         for each(_loc3_ in param2.connected)
         {
            _loc3_.SetAngularVelocity(triggerForce * triggerState);
            _loc3_.WakeUp();
         }
      }
   }
}

