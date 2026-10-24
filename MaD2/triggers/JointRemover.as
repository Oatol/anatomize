package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class JointRemover extends Trigger
   {
      
      public function JointRemover()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Body = null;
         super.trigger(param1,param2);
         for each(_loc3_ in param2.connected)
         {
            Body.RemoveJoints(_loc3_);
         }
         param2.triggered = false;
      }
   }
}

