package powers
{
   import Box2D.Dynamics.b2Body;
   import triggers.Concussion;
   
   public class PowerSleep extends Power
   {
      
      public function PowerSleep()
      {
         super(Tool.SLEEP,"sleep","sleep");
         noDuration = false;
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         bodyUD.trigger = new Concussion(Tweak.toolDuration * 60);
         bodyUD.triggered = true;
      }
   }
}

