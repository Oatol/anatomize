package triggers
{
   import Box2D.Dynamics.b2Body;
   import Gun.Firearm;
   
   public class AutoRevolver extends Firearm
   {
      
      public function AutoRevolver(param1:b2Body)
      {
         super("burstpistol",param1,60,150,15,20,"pis",0.9,1);
         burstAmount = 6;
         _burstDelay = 90;
         chamberTime = 2;
         magazineSize = 32;
         reloadTime = 120;
      }
   }
}

