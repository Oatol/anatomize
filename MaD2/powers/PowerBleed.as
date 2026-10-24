package powers
{
   import Box2D.Dynamics.b2Body;
   
   public class PowerBleed extends Power
   {
      
      public function PowerBleed()
      {
         super(Tool.BLEED,"blood","bleed");
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         if(Math.random() > 0.9)
         {
            Body.Exsanguinate(param1);
         }
      }
   }
}

