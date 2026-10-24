package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class FryingPan extends Trigger
   {
      
      public function FryingPan()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         param2.burning = true;
         param2.temperature = 200;
         param2.ignition = 100;
         param2.conductivity = 1;
      }
   }
}

