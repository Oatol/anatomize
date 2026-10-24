package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class CloneProperties extends Trigger
   {
      
      public function CloneProperties()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Body = null;
         var _loc4_:userData = null;
         super.trigger(param1,param2);
         for each(_loc3_ in param2.connected)
         {
            _loc4_ = userData(_loc3_.GetUserData());
            _loc4_.copyElemental(ud);
         }
         ud.triggered = false;
      }
   }
}

