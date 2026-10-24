package powers
{
   import Box2D.Dynamics.b2Body;
   
   public class PowerLava extends Power
   {
      
      public function PowerLava()
      {
         super(Tool.LAVA,"lava","lava");
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         if(Math.random() > 0.9)
         {
            Body.Lava(param1);
         }
      }
   }
}

