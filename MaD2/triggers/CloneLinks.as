package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class CloneLinks extends Trigger
   {
      
      public function CloneLinks()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:userData = null;
         super.trigger(param1,param2);
         var _loc3_:Array = BoxUtils.connections(param1);
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = userData(_loc4_.GetUserData());
            _loc5_.connected = param2.connected.slice();
         }
         ud.triggered = false;
      }
   }
}

