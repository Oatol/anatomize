package triggers
{
   import Box2D.Dynamics.b2Body;
   import Gun.Firearm;
   
   public class Trizooka extends Firearm
   {
      
      public function Trizooka(param1:b2Body)
      {
         super("trizooka",param1,3,1,20,40,"triz",0.5,1);
         burstAmount = 3;
         _burstDelay = 240;
         chamberTime = 8;
         magazineSize = 999;
         reloadTime = 120;
      }
   }
}

