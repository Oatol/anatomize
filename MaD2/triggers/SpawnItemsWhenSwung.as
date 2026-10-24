package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class SpawnItemsWhenSwung extends SpawnItems
   {
      
      public function SpawnItemsWhenSwung()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         if(param2.triggerDuration > 0)
         {
            param2.triggerDuration -= TimeLord.speed;
            return;
         }
         param2.triggerDuration = param2.originalTriggerDuration;
         if(param1.GetLinearVelocity().Length() > 50 || param1.GetAngularVelocity() > 50)
         {
            super.trigger(param1,param2);
         }
      }
   }
}

