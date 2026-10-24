package powers
{
   import Box2D.Dynamics.b2Body;
   
   public class PowerSandstone extends Power
   {
      
      public function PowerSandstone()
      {
         super(Tool.SANDSTONE,"tinydust","sandstone");
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         if(Math.random() > 0.9)
         {
            Body.Sandstone(param1);
         }
      }
   }
}

