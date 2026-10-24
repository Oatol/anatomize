package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class RemoteGimbal extends Trigger
   {
      
      internal var trigBod:b2Body;
      
      public function RemoteGimbal()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Body = null;
         var _loc4_:Number = NaN;
         super.trigger(param1,param2);
         for each(_loc3_ in param2.connected)
         {
            _loc3_.WakeUp();
            _loc4_ = _loc3_.GetAngle() - param1.GetAngle();
            _loc3_.SetAngularVelocity(_loc3_.GetAngularVelocity() * 0.9);
            _loc3_.ApplyTorque(-_loc4_ * _loc3_.GetMass() * param2.triggerForce);
         }
      }
   }
}

