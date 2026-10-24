package powers
{
   import Box2D.Dynamics.b2Body;
   
   public class PowerWater extends Power
   {
      
      public function PowerWater()
      {
         super(Tool.WATER,"water","wat");
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         Body.Wet(param1,pressPos);
      }
   }
}

