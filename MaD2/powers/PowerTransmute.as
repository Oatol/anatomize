package powers
{
   import Box2D.Dynamics.b2Body;
   import triggers.Transmute;
   
   public class PowerTransmute extends Power
   {
      
      public function PowerTransmute()
      {
         super(Tool.TRANSMUTE,"sparkle","trans");
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         if(Math.random() > 0.99)
         {
            bodyUD.trigger = new Transmute();
            bodyUD.triggered = true;
            bodyUD.triggerLock = false;
         }
      }
   }
}

