package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class Button extends Trigger
   {
      
      public function Button()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:b2Body = null;
         super.trigger(param1,param2);
         --param2.triggerDuration;
         if(param2.triggerDuration >= 0)
         {
            for each(_loc4_ in param2.connected)
            {
               _loc3_ = true;
               if(triggerState == 1)
               {
                  if(Math.random() < 0.9)
                  {
                     continue;
                  }
                  _loc3_ = Math.random() > 0.5;
               }
               userData(_loc4_.GetUserData()).triggered = _loc3_;
            }
         }
         else
         {
            for each(_loc4_ in param2.connected)
            {
               _loc3_ = false;
               userData(_loc4_.GetUserData()).triggered = _loc3_;
            }
            param2.triggered = false;
         }
      }
   }
}

