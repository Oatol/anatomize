package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class GateChipAND extends GateLogic
   {
      
      public function GateChipAND()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:userData = null;
         var _loc6_:int = 0;
         super.trigger(param1,param2);
         param2.triggerDuration -= TimeLord.speed;
         if(output)
         {
            Effect();
         }
         ConnectedEffect();
         if(param2.triggerDuration <= 0)
         {
            param2.triggerDuration = param2.originalTriggerDuration;
            var _loc4_:int = int(param2.connected.length);
            output = true;
            var _loc5_:Boolean = false;
            _loc6_ = 0;
            while(_loc6_ < _loc4_)
            {
               _loc3_ = userData(param2.connected[_loc6_].GetUserData());
               if(_loc3_.trigger is GateLogic)
               {
                  if(!GateLogic(_loc3_.trigger).output)
                  {
                     output = false;
                     break;
                  }
                  _loc5_ = true;
               }
               _loc6_++;
            }
            if(!_loc5_)
            {
               output = false;
            }
            _loc6_ = 0;
            while(_loc6_ < _loc4_)
            {
               _loc3_ = userData(param2.connected[_loc6_].GetUserData());
               if(!(_loc3_.trigger is GateLogic))
               {
                  _loc3_.triggered = output;
               }
               _loc6_++;
            }
            return;
         }
      }
   }
}

