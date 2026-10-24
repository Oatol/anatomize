package powers
{
   import Box2D.Dynamics.b2Body;
   
   public class PowerHeal extends Power
   {
      
      public function PowerHeal()
      {
         super(Tool.HEAL,"heal","med");
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         if(bodyUD.alive)
         {
            bodyUD.health += 50;
            if(Math.random() > 0.95)
            {
               bodyUD.bleeding = [];
            }
         }
         if(bodyUD.health > bodyUD.maxhealth)
         {
            bodyUD.health = bodyUD.maxhealth;
         }
      }
   }
}

