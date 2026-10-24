package powers
{
   import Box2D.Dynamics.b2Body;
   
   public class PowerPetrify extends Power
   {
      
      public function PowerPetrify()
      {
         super(Tool.PETRIFY,"petrify","petrify");
         throwSound = "crash";
         bodySound = "petrify";
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         Body.Petrify(param1);
      }
   }
}

