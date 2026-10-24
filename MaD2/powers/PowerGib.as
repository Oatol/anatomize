package powers
{
   import Box2D.Dynamics.b2Body;
   
   public class PowerGib extends Power
   {
      
      public function PowerGib()
      {
         super(Tool.GIB,"spatter","gib");
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         if(Math.random() > 0.9)
         {
            Body.Gib(param1);
         }
      }
   }
}

