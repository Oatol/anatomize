package powers
{
   import Box2D.Dynamics.b2Body;
   
   public class PowerMutate extends Power
   {
      
      public function PowerMutate()
      {
         super(Tool.MUTATE,"blood","mutate");
         noThrow = true;
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         if(Math.random() > 0.98)
         {
            Body.Mutate(param1);
         }
      }
   }
}

