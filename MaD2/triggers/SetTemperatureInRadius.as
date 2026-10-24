package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class SetTemperatureInRadius extends Trigger
   {
      
      public function SetTemperatureInRadius()
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
         var _loc5_:b2Body = null;
         var _loc6_:b2Body = null;
         var _loc7_:userData = null;
         var _loc8_:Number = NaN;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
         if(param2.connected.length > 0)
         {
            _loc3_ = [];
            for each(_loc6_ in param2.connected)
            {
               _loc3_.push(_loc6_);
            }
         }
         var _loc4_:String = "air";
         if(param2.triggerForce < 0)
         {
            _loc4_ = "tinysprinkle";
         }
         else if(param2.triggerForce > 40)
         {
            _loc4_ = "fire3";
         }
         BoxUtils.randomParticlesOnBody(param1,_loc4_);
         for each(_loc5_ in _loc3_)
         {
            _loc7_ = userData(_loc5_.GetUserData());
            _loc8_ = (-_loc7_.temperature + param2.triggerForce) / param2.triggerDuration;
            _loc7_.temperature += _loc8_;
         }
      }
   }
}

