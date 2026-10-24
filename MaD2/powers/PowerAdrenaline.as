package powers
{
   import Box2D.Dynamics.b2Body;
   import triggers.Hyped;
   
   public class PowerAdrenaline extends Power
   {
      
      public function PowerAdrenaline()
      {
         super(Tool.ADRENALINE,"fire3","adrenaline");
         bodySound = "bat1";
         noDuration = false;
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         if(bodyUD.resistAdrenaline)
         {
            return;
         }
         bodyUD.trigger = new Hyped(100);
         bodyUD.triggerDuration = Tweak.toolDuration;
         bodyUD.triggered = true;
      }
   }
}

