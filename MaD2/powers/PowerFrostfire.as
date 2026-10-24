package powers
{
   import Box2D.Dynamics.b2Body;
   
   public class PowerFrostfire extends Power
   {
      
      public function PowerFrostfire()
      {
         super(Tool.FRY,"frostfire","frostfire");
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         Body.Frostfire(param1);
      }
   }
}

