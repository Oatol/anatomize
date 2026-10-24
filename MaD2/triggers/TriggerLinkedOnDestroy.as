package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class TriggerLinkedOnDestroy extends Trigger
   {
      
      public function TriggerLinkedOnDestroy()
      {
         super();
      }
      
      override public function OnDelete() : void
      {
         var _loc1_:b2Body = null;
         for each(_loc1_ in ud.connected)
         {
            userData(_loc1_.GetUserData()).triggered = true;
         }
         super.OnDelete();
      }
   }
}

