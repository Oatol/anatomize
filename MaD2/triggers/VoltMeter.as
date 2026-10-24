package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class VoltMeter extends Trigger
   {
      
      public function VoltMeter()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Body = null;
         var _loc6_:b2Body = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size);
         var _loc4_:Boolean = false;
         if(_loc3_.length > 0)
         {
            for each(_loc5_ in _loc3_)
            {
               if(userData(_loc5_.GetUserData()).trigger is Electrified)
               {
                  for each(_loc6_ in param2.connected)
                  {
                     userData(_loc6_.GetUserData()).triggered = true;
                  }
                  _loc4_ = true;
                  break;
               }
            }
         }
         if(!_loc4_)
         {
            for each(_loc6_ in param2.connected)
            {
               userData(_loc6_.GetUserData()).triggered = false;
            }
         }
      }
   }
}

