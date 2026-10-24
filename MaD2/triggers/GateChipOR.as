package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class GateChipOR extends GateLogic
   {
      
      public function GateChipOR()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:userData = null;
         var _loc5_:int = 0;
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
            output = false;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc3_ = userData(param2.connected[_loc5_].GetUserData());
               if(_loc3_.trigger is GateLogic)
               {
                  if(GateLogic(_loc3_.trigger).output)
                  {
                     output = true;
                     break;
                  }
               }
               _loc5_++;
            }
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc3_ = userData(param2.connected[_loc5_].GetUserData());
               if(!(_loc3_.trigger is GateLogic))
               {
                  _loc3_.triggered = output;
               }
               _loc5_++;
            }
            return;
         }
      }
   }
}

