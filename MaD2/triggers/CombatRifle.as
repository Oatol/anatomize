package triggers
{
   import Box2D.Dynamics.b2Body;
   import Gun.Firearm;
   
   public class CombatRifle extends Firearm
   {
      
      public function CombatRifle(param1:b2Body)
      {
         super("CombatRifle",param1,10,100,10,50,"com",0.8,1);
         burstAmount = 8;
         _burstDelay = 32;
         chamberTime = 6;
         magazineSize = 24;
         reloadTime = 120;
      }
   }
}

