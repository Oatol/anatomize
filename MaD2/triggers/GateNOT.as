package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class GateNOT extends GateLogic
   {
      
      public function GateNOT()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:userData = null;
         var _loc5_:int = 0;
         super.trigger(param1,param2);
         var _loc4_:int = int(param2.connected.length);
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = userData(param2.connected[_loc5_].GetUserData());
            if(_loc3_.trigger is GateInput)
            {
               output = !GateInput(_loc3_.trigger).output;
               break;
            }
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = userData(param2.connected[_loc5_].GetUserData());
            if(!(_loc3_.trigger is GateInput))
            {
               if(!(_loc3_.trigger is GateLogic))
               {
                  _loc3_.triggered = output;
               }
            }
            _loc5_++;
         }
         if(output)
         {
            Effect();
         }
      }
      
      override public function onTrigger() : void
      {
         super.onTrigger();
         output = true;
      }
      
      override public function onUntrigger() : void
      {
         output = false;
         ud._triggered = true;
      }
   }
}

