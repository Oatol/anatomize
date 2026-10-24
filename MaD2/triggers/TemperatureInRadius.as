package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class TemperatureInRadius extends Trigger
   {
      
      public function TemperatureInRadius()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         param2.triggerForceAllowNegative = true;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:userData = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = userData(_loc4_.GetUserData());
            _loc5_.temperature += param2.triggerForce;
         }
      }
   }
}

