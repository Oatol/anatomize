package powers
{
   import Box2D.Dynamics.b2Body;
   import triggers.Crit;
   
   public class PowerCrit extends Power
   {
      
      public function PowerCrit()
      {
         super(Tool.CRIT,"blood","crit");
         throwSound = "breaklimb2";
         throwVol = 0.3;
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         if(Math.random() > 0.999)
         {
            bodyUD.trigger = new Crit();
            bodyUD.triggered = true;
         }
      }
   }
}

