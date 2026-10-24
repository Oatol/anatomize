package powers
{
   import Box2D.Dynamics.b2Body;
   
   public class PowerAnimate extends Power
   {
      
      public function PowerAnimate()
      {
         super(Tool.ANIMATE,"chain","animate");
         noThrow = true;
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         Body.Animate(param1);
      }
   }
}

