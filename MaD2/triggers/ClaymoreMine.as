package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class ClaymoreMine extends Trigger
   {
      
      public function ClaymoreMine()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Body = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
         var _loc4_:int = 0;
         var _loc6_:Number = 9000;
         if(_loc3_.length > 0)
         {
            param2.triggerDuration = 30;
            param2.triggerRadius = 160;
            param2.triggerForce = 5000;
            param2.trigger = new Grenade();
            param2.triggered = true;
         }
      }
   }
}

