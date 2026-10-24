package powers
{
   import Box2D.Dynamics.b2Body;
   
   public class PowerBling extends Power
   {
      
      public function PowerBling()
      {
         super(Tool.BLING,"money","bling");
         throwSound = "ching";
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         if(Math.random() > 0.98)
         {
            Body.Bling(param1);
         }
      }
   }
}

