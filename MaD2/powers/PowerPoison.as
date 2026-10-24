package powers
{
   import Box2D.Dynamics.b2Body;
   import triggers.Poisoned;
   
   public class PowerPoison extends Power
   {
      
      public function PowerPoison()
      {
         super(Tool.POISON,"poison","poi");
         throwSound = "hiss";
         noDuration = false;
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         if(bodyUD.alive && !bodyUD.resistPoison)
         {
            bodyUD.trigger = new Poisoned();
            bodyUD.triggered = true;
            bodyUD.triggerDuration = Tweak.toolDuration;
         }
      }
   }
}

