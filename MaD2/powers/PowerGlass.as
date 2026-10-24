package powers
{
   import Box2D.Dynamics.b2Body;
   
   public class PowerGlass extends Power
   {
      
      public function PowerGlass()
      {
         super(Tool.GLASS,"tinysprinkle","glass");
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         Body.Glass(param1);
      }
   }
}

