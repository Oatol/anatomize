package powers
{
   import Box2D.Dynamics.b2Body;
   
   public class PowerFry extends Power
   {
      
      public function PowerFry()
      {
         super(Tool.FRY,"fried","deepfry");
         bodySound = "hiss";
         throwSound = "hiss";
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         Body.Deepfry(param1);
      }
   }
}

