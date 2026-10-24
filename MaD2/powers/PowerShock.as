package powers
{
   import Box2D.Dynamics.b2Body;
   import triggers.Electrified;
   
   public class PowerShock extends Power
   {
      
      public function PowerShock()
      {
         super(Tool.SHOCK,"shock","zap1");
         throwSound = "shock";
         bodySound = "tinyshock";
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         if(bodyUD.resistShock)
         {
            return;
         }
         bodyUD.trigger = new Electrified();
         bodyUD.triggered = true;
         bodyUD.triggerDuration = 30;
      }
   }
}

