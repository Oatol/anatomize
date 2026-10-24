package triggers
{
   import Box2D.Dynamics.b2Body;
   import Gun.Firearm;
   
   public class DartTrap extends Firearm
   {
      
      public function DartTrap(param1:b2Body)
      {
         super("darttrap",param1,100,100,1,20,"trap",1,1);
         burstAmount = 6;
         _burstDelay = 60;
         chamberTime = 10;
         magazineSize = 6;
         reloadTime = 0;
      }
   }
}

