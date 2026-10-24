package powers
{
   import Box2D.Dynamics.b2Body;
   import triggers.DisintegratePowder;
   
   public class PowerPowder extends Power
   {
      
      public function PowerPowder()
      {
         super(Tool.POWDER,"poof","powder");
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         bodyUD.trigger = new DisintegratePowder(100,0.5,true);
         bodyUD.triggered = true;
      }
   }
}

