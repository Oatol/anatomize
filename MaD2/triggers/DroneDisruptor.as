package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class DroneDisruptor extends Trigger
   {
      
      public function DroneDisruptor()
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
            if((Boolean(_loc4_)) && _loc4_.trigger is Drone)
            {
               Drone(_loc4_.trigger).flightEnabled = !Drone(_loc4_.trigger).flightEnabled;
            }
         }
         ud.triggered = false;
      }
   }
}

