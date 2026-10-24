package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class RotateToVelocity extends Trigger
   {
      
      internal var prevAngle:Number = 0;
      
      public function RotateToVelocity()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(bodyVel.Length() < 10)
         {
            return;
         }
         var _loc3_:Number = Math.atan2(bodyVel.y,bodyVel.x);
         if(this.prevAngle < 0 != _loc3_ < 0)
         {
            param1.SetXForm(param1.GetPosition(),_loc3_ + Math.PI * 0.5);
         }
         var _loc4_:Number = _loc3_ - bodyAngle % (Math.PI * 2) + Math.PI * 0.5;
         _loc4_ = _loc4_ * 10;
         param1.ApplyTorque(_loc4_);
         this.prevAngle = _loc3_;
      }
   }
}

