package powers
{
   import Box2D.Dynamics.b2Body;
   
   public class PowerGlitch extends Power
   {
      
      public function PowerGlitch()
      {
         super(Tool.GLITCH,"warning","glitch");
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         Body.Glitch(param1);
      }
   }
}

