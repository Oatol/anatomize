package powers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import triggers.Transmute;
   
   public class PowerError extends Power
   {
      
      public function PowerError()
      {
         super(Tool.ERROR,"hype","error");
         noThrowAmount = true;
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         if(Math.random() > 0.99)
         {
            bodyUD.trigger = new Transmute("genericcube");
            bodyUD.triggered = true;
         }
      }
      
      override protected function ThrowUpdate(param1:b2Vec2) : void
      {
         super.ThrowUpdate(param1);
         throwProjectiles = 1;
      }
   }
}

