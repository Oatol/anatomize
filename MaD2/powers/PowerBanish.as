package powers
{
   import Box2D.Dynamics.b2Body;
   import triggers.Disintegrate;
   
   public class PowerBanish extends Power
   {
      
      public function PowerBanish()
      {
         super(Tool.BANISH,"error","banish");
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         if(bodyUD.resistBanning)
         {
            return;
         }
         bodyUD.trigger = new Disintegrate("error",10,10);
         bodyUD.triggered = true;
      }
   }
}

