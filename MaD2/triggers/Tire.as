package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class Tire extends Trigger
   {
      
      public function Tire()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         body.ApplyTorque(body.GetMass() * ud.triggerForce * (ud.flipped ? -1 : 1));
         body.WakeUp();
      }
   }
}

