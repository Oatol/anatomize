package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class VelocitySwitch extends Trigger
   {
      
      public function VelocitySwitch()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc6_:b2Body = null;
         super.trigger(param1,param2);
         var _loc3_:Boolean = false;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         _loc3_ = bodyVel.Length() > triggerForce;
         if(_loc3_)
         {
            for each(_loc6_ in param2.connected)
            {
               userData(_loc6_.GetUserData()).triggered = _loc3_;
            }
         }
      }
   }
}

