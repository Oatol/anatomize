package powers
{
   import Box2D.Dynamics.b2Body;
   import triggers.Webbed;
   
   public class PowerWeb extends Power
   {
      
      public function PowerWeb()
      {
         super(Tool.WEB,"gas","web");
         throwSound = "breaklimb2";
         bodySound = "breaklimb2";
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         if(bodyUD.resistSnare)
         {
            return;
         }
         bodyUD.trigger = new Webbed();
         bodyUD.triggered = true;
         bodyUD.triggerForce = 1;
      }
   }
}

