package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class TriggerSwitch extends Trigger
   {
      
      public function TriggerSwitch()
      {
         super();
      }
      
      override public function onTrigger() : void
      {
         var _loc1_:b2Body = null;
         var _loc2_:userData = null;
         super.onTrigger();
         for each(_loc1_ in ud.connected)
         {
            _loc2_ = userData(_loc1_.GetUserData());
            if(ud.triggerState == 1)
            {
               _loc2_.triggered = !_loc2_.triggered;
            }
            else
            {
               _loc2_.triggered = true;
            }
         }
      }
      
      override public function onUntrigger() : void
      {
         var _loc1_:b2Body = null;
         var _loc2_:userData = null;
         super.onUntrigger();
         for each(_loc1_ in ud.connected)
         {
            _loc2_ = userData(_loc1_.GetUserData());
            if(ud.triggerState == 1)
            {
               _loc2_.triggered = !_loc2_.triggered;
            }
            else
            {
               _loc2_.triggered = false;
            }
         }
      }
   }
}

