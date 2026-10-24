package powers
{
   import Box2D.Dynamics.b2Body;
   
   public class PowerUpgrade extends Power
   {
      
      public function PowerUpgrade()
      {
         super(Tool.UPGRADE,"heal","upgrade");
         noThrow = true;
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         Body.Upgrade(param1);
      }
   }
}

