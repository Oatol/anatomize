package
{
   import Box2D.Dynamics.b2Body;
   import Gun.Firearm;
   
   public class BattleRifle extends Firearm
   {
      
      public function BattleRifle(param1:b2Body)
      {
         super("battlerifle",param1,3,300,20,10,"ass",0.8,1);
         burstAmount = 3;
         _burstDelay = 12;
         chamberTime = 3;
         magazineSize = 30;
         reloadTime = 120;
      }
   }
}

