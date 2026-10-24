package triggers
{
   import Box2D.Dynamics.b2Body;
   import Gun.Firearm;
   
   public class ElvenBow extends Firearm
   {
      
      internal var whichBarrel:Number;
      
      internal var shots:int = 0;
      
      public function ElvenBow(param1:b2Body)
      {
         super("AACannon",param1,3,10,20,10,"elvenarr",1,1);
         burstAmount = 5;
         _burstDelay = 60;
         chamberTime = 3;
         magazineSize = 500;
         reloadTime = 60;
      }
      
      override public function shoot() : Boolean
      {
         this.whichBarrel = (Math.random() * 6 - 3) * userData(body.GetUserData()).size;
         datPos.y = this.whichBarrel;
         datPosFlipped.y = this.whichBarrel;
         return super.shoot();
      }
   }
}

