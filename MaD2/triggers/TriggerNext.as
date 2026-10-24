package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class TriggerNext extends Trigger
   {
      
      public function TriggerNext()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
      }
      
      override public function onTrigger() : void
      {
         super.onTrigger();
         this.Next();
      }
      
      override public function onUntrigger() : void
      {
         super.onUntrigger();
         this.Next();
      }
      
      private function Next() : void
      {
         var _loc2_:b2Body = null;
         var _loc3_:userData = null;
         var _loc1_:int = -1;
         for each(_loc2_ in ud.connected)
         {
            if(++_loc1_ == ud.triggerForce)
            {
               _loc3_ = userData(_loc2_.GetUserData());
               _loc3_.triggered = ud.triggerState == 1;
               break;
            }
         }
         ++ud.triggerForce;
         if(ud.triggerForce >= ud.connected.length)
         {
            ud.triggerForce = 0;
         }
      }
   }
}

