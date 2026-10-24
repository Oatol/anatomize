package powers
{
   import Box2D.Dynamics.b2Body;
   import triggers.ToxinMelt;
   
   public class PowerBane extends Power
   {
      
      public function PowerBane()
      {
         super(Tool.BANE,"moss","bane");
         noDuration = false;
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         if(!bodyUD.alive)
         {
            return;
         }
         if(bodyUD.resistBlighting)
         {
            return;
         }
         Body.BlightEffect(param1,pressPos);
         if(bodyUD.trigger is ToxinMelt)
         {
            return;
         }
         Body.Blight(param1,Math.random() * Math.random() * 320 + 120);
      }
   }
}

