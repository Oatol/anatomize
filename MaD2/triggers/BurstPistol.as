package triggers
{
   import Box2D.Dynamics.b2Body;
   import Gun.Firearm;
   
   public class BurstPistol extends Firearm
   {
      
      public function BurstPistol(param1:b2Body)
      {
         super("burstpistol",param1,3,160,20,20,"pis",0.8,1);
         burstAmount = 4;
         _burstDelay = 35;
         chamberTime = 3;
         magazineSize = 24;
         reloadTime = 60;
      }
   }
}

