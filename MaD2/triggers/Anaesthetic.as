package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class Anaesthetic extends Trigger
   {
      
      public function Anaesthetic()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:Vector.<b2Body> = null;
         var _loc6_:b2Body = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size);
         for each(_loc4_ in _loc3_)
         {
            if(Boolean(_loc4_.GetUserData().alive) && _loc4_.GetUserData().temperature > 0)
            {
               userData(_loc4_.GetUserData()).trigger = new Concussion(1200);
               userData(_loc4_.GetUserData()).triggered = true;
            }
         }
         _loc5_ = Body.Decompose(param1);
         for each(_loc6_ in _loc5_)
         {
            userData(_loc6_.GetUserData()).name = BoxUtils.shapeNameToColour(userData(_loc6_.GetUserData()).name,param2.skin).toString(16);
            Body.Disintegrate(_loc6_,"inherit",10,1,1);
         }
      }
   }
}

