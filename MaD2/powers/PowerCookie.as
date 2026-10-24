package powers
{
   import Box2D.Dynamics.b2Body;
   
   public class PowerCookie extends Power
   {
      
      public function PowerCookie()
      {
         super(Tool.COOKIE,"cookie","cookier");
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         if(Math.random() > 0.95)
         {
            Body.Cookie(param1);
         }
      }
   }
}

