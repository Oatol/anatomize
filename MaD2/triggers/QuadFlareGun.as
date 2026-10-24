package triggers
{
   import Box2D.Dynamics.b2Body;
   import Gun.Firearm;
   
   public class QuadFlareGun extends Firearm
   {
      
      internal var whichBarrel:Number;
      
      public function QuadFlareGun(param1:b2Body)
      {
         super("AACannon",param1,12,100,20,10,"flr",1,1);
         this.whichBarrel = 3;
         burstAmount = 4;
         _burstDelay = 60;
         chamberTime = 12;
         magazineSize = 999;
         reloadTime = 120;
      }
      
      override public function shoot() : Boolean
      {
         if(super.shoot())
         {
            if(this.whichBarrel <= 0)
            {
               this.whichBarrel = 3;
            }
            else
            {
               --this.whichBarrel;
            }
            datPos.y = (-1.1 + this.whichBarrel * 0.4) * userData(body.GetUserData()).size;
            datPosFlipped.y = (-1.1 + this.whichBarrel * 0.4) * userData(body.GetUserData()).size;
            return true;
         }
         return false;
      }
   }
}

